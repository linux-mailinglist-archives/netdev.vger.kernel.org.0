Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6AB362397
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245435AbhDPPNo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 11:13:44 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:26386 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244955AbhDPPN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:13:26 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-aMx0w6q8NOSY-8kv_mW_dQ-1; Fri, 16 Apr 2021 11:11:52 -0400
X-MC-Unique: aMx0w6q8NOSY-8kv_mW_dQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD06C85EE8B;
        Fri, 16 Apr 2021 15:11:50 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFECE196E3;
        Fri, 16 Apr 2021 15:11:48 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>,
        Juri Lelli <jlelli@redhat.com>, Xiumei Mu <xmu@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH ipsec-next] xfrm: ipcomp: remove unnecessary get_cpu()
Date:   Fri, 16 Apr 2021 17:11:46 +0200
Message-Id: <2bc5f05b0c50082cf0f5c817ae7c9f660848f146.1618394396.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing ipcomp on a realtime kernel, Xiumei reported a "sleeping
in atomic" bug, caused by a memory allocation while preemption is
disabled (ipcomp_decompress -> alloc_page -> ... get_page_from_freelist).

As Sebastian noted [1], this get_cpu() isn't actually needed, since
ipcomp_decompress() is called in napi context anyway, so BH is already
disabled.

This patch replaces get_cpu + per_cpu_ptr with this_cpu_ptr, then
simplifies the error returns, since there isn't any common operation
left.

[1] https://lore.kernel.org/lkml/20190820082810.ixkmi56fp7u7eyn2@linutronix.de/

Cc: Juri Lelli <jlelli@redhat.com>
Reported-by: Xiumei Mu <xmu@redhat.com>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_ipcomp.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 4d422447aadc..2e8afe078d61 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -41,19 +41,16 @@ static int ipcomp_decompress(struct xfrm_state *x, struct sk_buff *skb)
 	const int plen = skb->len;
 	int dlen = IPCOMP_SCRATCH_SIZE;
 	const u8 *start = skb->data;
-	const int cpu = get_cpu();
-	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
-	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	u8 *scratch = *this_cpu_ptr(ipcomp_scratches);
+	struct crypto_comp *tfm = *this_cpu_ptr(ipcd->tfms);
 	int err = crypto_comp_decompress(tfm, start, plen, scratch, &dlen);
 	int len;
 
 	if (err)
-		goto out;
+		return err;
 
-	if (dlen < (plen + sizeof(struct ip_comp_hdr))) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (dlen < (plen + sizeof(struct ip_comp_hdr)))
+		return -EINVAL;
 
 	len = dlen - plen;
 	if (len > skb_tailroom(skb))
@@ -68,16 +65,14 @@ static int ipcomp_decompress(struct xfrm_state *x, struct sk_buff *skb)
 		skb_frag_t *frag;
 		struct page *page;
 
-		err = -EMSGSIZE;
 		if (WARN_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS))
-			goto out;
+			return -EMSGSIZE;
 
 		frag = skb_shinfo(skb)->frags + skb_shinfo(skb)->nr_frags;
 		page = alloc_page(GFP_ATOMIC);
 
-		err = -ENOMEM;
 		if (!page)
-			goto out;
+			return -ENOMEM;
 
 		__skb_frag_set_page(frag, page);
 
@@ -96,11 +91,7 @@ static int ipcomp_decompress(struct xfrm_state *x, struct sk_buff *skb)
 		skb_shinfo(skb)->nr_frags++;
 	}
 
-	err = 0;
-
-out:
-	put_cpu();
-	return err;
+	return 0;
 }
 
 int ipcomp_input(struct xfrm_state *x, struct sk_buff *skb)
-- 
2.31.1

