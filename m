Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AFE6169D1
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiKBQzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiKBQz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:55:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F8565A2
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667408074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Fwukjgqx6hIjubyBsyrhZbQ5eX3AkZwzX93xkd1cljE=;
        b=JotMnQ1su8bAZRa0rinlVNkWefqCDluV9a2OnFfbnBuUqKXaASkv3QwGxx1wGFTwdvs1HB
        BmfQaapI+r7i3o8eQ2KHBffDJoJR4RqoBCFLwIkq56j7Jspzvztalc6XIEn57yjCXnTSGT
        r+uNn7rB9AxDcRKnY4z8eE762EntrcA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-3H_SHTliPGqcAPJ0Gw4vGg-1; Wed, 02 Nov 2022 12:54:23 -0400
X-MC-Unique: 3H_SHTliPGqcAPJ0Gw4vGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BFFB381494D;
        Wed,  2 Nov 2022 16:54:23 +0000 (UTC)
Received: from griffin.upir.cz (ovpn-208-27.brq.redhat.com [10.40.208.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9648A40C94CE;
        Wed,  2 Nov 2022 16:54:21 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Shmulik Ladkani <shmulik@metanetworks.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v2] net: gso: fix panic on frag_list with mixed head alloc types
Date:   Wed,  2 Nov 2022 17:53:25 +0100
Message-Id: <e04426a6a91baf4d1081e1b478c82b5de25fdf21.1667407944.git.jbenc@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
in skb_segment when skbs on the frag_list had differing head_frag with
the vmxnet3 driver. This happens because __netdev_alloc_skb and
__napi_alloc_skb can return a skb that is page backed or kmalloced
depending on the requested size. As the result, the last small skb in
the GRO packet can be kmalloced.

There are three different locations where this can be fixed:

(1) We could check head_frag in GRO and not allow GROing skbs with
    different head_frag. However, that would lead to performance
    regression on normal forward paths with unmodified gso_size, where
    !head_frag in the last packet is not a problem.

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

We could check only the last skb but since we need to walk the whole
list anyway, let's stay on the safe side.

Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
v2: fixed the description; the code is unchanged
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
2.38.1

