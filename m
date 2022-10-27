Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA7160F227
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiJ0IVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiJ0IVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:21:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0322872EC3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666858879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GtNroKlpZr+0jqtQZWwTzDz99PGQTifPz+tF7jg5FWg=;
        b=Q8mUvMDL8HF5Iy4ZLEf5HekJSoAv67qG6zWay2J6EMh4DyBDMd2/NBFhHfK7hwg/k1fg0l
        q8gu0j6XeQQpq8Y9AuTO3wFyOudZh0ynI2WwHNBfCaaqwYoaqW8kO1OYZ4ksfiMH+rm0my
        epc8QGfIjyoAE7Br2ApTiFn1hrGdjvk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-Zi-DIejXPMikq-cF3c2JjA-1; Thu, 27 Oct 2022 04:21:17 -0400
X-MC-Unique: Zi-DIejXPMikq-cF3c2JjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8CBD800B30;
        Thu, 27 Oct 2022 08:21:16 +0000 (UTC)
Received: from griffin.upir.cz (ovpn-208-2.brq.redhat.com [10.40.208.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 956E61415117;
        Thu, 27 Oct 2022 08:21:14 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Shmulik Ladkani <shmulik@metanetworks.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Subject: [PATCH net] net: gso: fix panic on frag_list with mixed head alloc types
Date:   Thu, 27 Oct 2022 10:20:56 +0200
Message-Id: <559cea869928e169240d74c386735f3f95beca32.1666858629.git.jbenc@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when
splitting gso_size mangled skb having linear-headed frag_list"), it is
allowed to change gso_size of a GRO packet. However, that commit assumes
that "checking the first list_skb member suffices; i.e if either of the
list_skb members have non head_frag head, then the first one has too".

It turns out this assumption does not hold. We've seen BUG_ON being hit
in skb_segment when skbs on the frag_list had differing head_frag. That
particular case was with vmxnet3; looking at the driver, it indeed uses
different skb allocation strategies based on the packet size. The last
packet in frag_list can thus be kmalloced if it is sufficiently small.
And there's nothing preventing drivers from mixing things even more
freely.

There are three different locations where this can be fixed:

(1) We could check head_frag in GRO and not allow GROing skbs with
    different head_frag. However, that would lead to performance
    regression (at least on vmxnet3) on normal forward paths with
    unmodified gso_size, where mixed head_frag is not a problem.

(2) Set a flag in bpf_skb_net_grow and bpf_skb_net_shrink indicating
    that NETIF_F_SG is undesirable. That would need to eat a bit in
    sk_buff. Furthermore, that flag can be unset when all skbs on the
    frag_list are page backed. To retain good performance,
    bpf_skb_net_grow/shrink would have to walk the frag_list.

(3) Walk the frag_list in skb_segment when determining whether
    NETIF_F_SG should be cleared. This of course slows things down.

This patch implements (3). To limit the performance impact in
skb_segment, the list is walked only for skbs with SKB_GSO_DODGY set
that have gso_size changed. Normal paths thus will not hit it.

Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 net/core/skbuff.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d9719e72f9d..bbf3acff44c6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4134,23 +4134,25 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	int i = 0;
 	int pos;
 
-	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
-	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
-		/* gso_size is untrusted, and we have a frag_list with a linear
-		 * non head_frag head.
-		 *
-		 * (we assume checking the first list_skb member suffices;
-		 * i.e if either of the list_skb members have non head_frag
-		 * head, then the first one has too).
-		 *
-		 * If head_skb's headlen does not fit requested gso_size, it
-		 * means that the frag_list members do NOT terminate on exact
-		 * gso_size boundaries. Hence we cannot perform skb_frag_t page
-		 * sharing. Therefore we must fallback to copying the frag_list
-		 * skbs; we do so by disabling SG.
-		 */
-		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
-			features &= ~NETIF_F_SG;
+	if ((skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY) &&
+	    mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb)) {
+		struct sk_buff *check_skb;
+
+		for (check_skb = list_skb; check_skb; check_skb = check_skb->next) {
+			if (skb_headlen(check_skb) && !check_skb->head_frag) {
+				/* gso_size is untrusted, and we have a frag_list with
+				 * a linear non head_frag item.
+				 *
+				 * If head_skb's headlen does not fit requested gso_size,
+				 * it means that the frag_list members do NOT terminate
+				 * on exact gso_size boundaries. Hence we cannot perform
+				 * skb_frag_t page sharing. Therefore we must fallback to
+				 * copying the frag_list skbs; we do so by disabling SG.
+				 */
+				features &= ~NETIF_F_SG;
+				break;
+			}
+		}
 	}
 
 	__skb_push(head_skb, doffset);
-- 
2.37.3

