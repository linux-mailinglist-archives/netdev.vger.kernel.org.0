Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1BA368EA6
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbhDWIO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:14:57 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:52896 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhDWIOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:14:54 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 2DD5080005B;
        Fri, 23 Apr 2021 10:14:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 10:14:17 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 23 Apr
 2021 10:14:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 49AEB31805DA; Fri, 23 Apr 2021 10:14:16 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/4] xfrm: ipcomp: remove unnecessary get_cpu()
Date:   Fri, 23 Apr 2021 10:14:09 +0200
Message-ID: <20210423081409.729557-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210423081409.729557-1-steffen.klassert@secunet.com>
References: <20210423081409.729557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.25.1

