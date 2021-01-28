Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF79307289
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhA1JVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 04:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbhA1JTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 04:19:39 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E35C061756
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:18:58 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u15so3001036plf.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mK0/+9iW2x8uz2VxyxWZQDGjXg3EBuKUOG/sV5MybAs=;
        b=iT9IExS8cf4oqSnjqoHYUVDFQ2+rqVLuCdPf4MA7bB+opp+pw70BoUAEOBiK++SQs6
         JIGxfYns/vb38LOkgbOuduiprs4hfo+5qzIjOF74T4R03PtmTK8kmAnDTl5b+eMicArP
         DzgtQaYjeCgfd652zwKr1e0meWLOHNQbUz3SWR9KKHVD4J53iueqkZIRm2ezSyWrpm5N
         FjLOvPAn+x0f6oVDyHRK/H8XnKz7ZxAk27EKkIbpVBTL8lm7I1OvKYeRTeRpQDDkyb4t
         8gxDILVRu7DjIo2S/56AjL4H6YIkIgWBcwgOVeofI7zDPv4/HtPwEiYfKCG9rhDt7xE/
         pYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=mK0/+9iW2x8uz2VxyxWZQDGjXg3EBuKUOG/sV5MybAs=;
        b=N1YTwqFWPrdK417gH+BMkMtpE93SufImMyf3N/sCA0x1u8bn8sjCtoKOCcKzCceNpP
         QwLUMRU0GhLbdHgr2IjVY43mv6d9B2Prz5wdaIdGM+EsWAX+JD2swroJ5J5vKrScSGDc
         2Tg+n1+RUBR5ZoEQ4oKVFM/EgRY2gjzXZ8u5BmscXH0WIucU3jNXtkX+PilrDYUzfUjV
         harfOLaySclKC7HfY4LB8zoalUalZwYribpmdVPjmKjsFUStj4Mf8H+YVJ/SM/liSxoQ
         MtF7HMMEFa/78JKy045PPCfiaN/csEkIDC+hY4k012mGWM5IagkSKyfjhOF5g7zjAWQz
         7JEw==
X-Gm-Message-State: AOAM530j2TMm44k6gc6ALqGhbqSpVy54MG2XaRgqxkvLlM1gtX6SpycB
        YAhsL4JnrkbB2o8wPhLG5wh2zVbPPCgMcQ==
X-Google-Smtp-Source: ABdhPJxxHvDbtR8fwb6D44Ww8DY8f9MeqO2/7J2YNgTJlMJ+a4trM+CBQPsv2KVqEUfAmETbVWrB6A==
X-Received: by 2002:a17:903:248e:b029:de:b329:ffaa with SMTP id p14-20020a170903248eb02900deb329ffaamr15567840plw.71.1611825537639;
        Thu, 28 Jan 2021 01:18:57 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i10sm4823491pgt.85.2021.01.28.01.18.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Jan 2021 01:18:56 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv3 net-next 2/2] ip_gre: add csum offload support for gre header
Date:   Thu, 28 Jan 2021 17:18:32 +0800
Message-Id: <6a8bceca30a03e63da07dcbf5c37de40b53d7978.1611825446.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
References: <cover.1611825446.git.lucien.xin@gmail.com>
 <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611825446.git.lucien.xin@gmail.com>
References: <cover.1611825446.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add csum offload support for gre header:

On the TX path in gre_build_header(), when CHECKSUM_PARTIAL's set
for inner proto, it will calculate the csum for outer proto, and
inner csum will be offloaded later. Otherwise, CHECKSUM_PARTIAL
and csum_start/offset will be set for outer proto, and the outer
csum will be offloaded later.

On the GSO path in gre_gso_segment(), when CHECKSUM_PARTIAL is
not set for inner proto and the hardware supports csum offload,
CHECKSUM_PARTIAL and csum_start/offset will be set for outer
proto, and outer csum will be offloaded later. Otherwise, it
will do csum for outer proto by calling gso_make_checksum().

Note that SCTP has to do the csum by itself for non GSO path in
sctp_packet_pack(), as gre_build_header() can't handle the csum
with CHECKSUM_PARTIAL set for SCTP CRC csum offload.

v1->v2:
  - remove the SCTP part, as GRE dev doesn't support SCTP CRC CSUM
    and it will always do checksum for SCTP in sctp_packet_pack()
    when it's not a GSO packet.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/gre.h      | 19 +++++++------------
 net/ipv4/gre_offload.c | 15 +++++++++++++--
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/net/gre.h b/include/net/gre.h
index b60f212..4e20970 100644
--- a/include/net/gre.h
+++ b/include/net/gre.h
@@ -106,17 +106,6 @@ static inline __be16 gre_tnl_flags_to_gre_flags(__be16 tflags)
 	return flags;
 }
 
-static inline __sum16 gre_checksum(struct sk_buff *skb)
-{
-	__wsum csum;
-
-	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		csum = lco_csum(skb);
-	else
-		csum = skb_checksum(skb, 0, skb->len, 0);
-	return csum_fold(csum);
-}
-
 static inline void gre_build_header(struct sk_buff *skb, int hdr_len,
 				    __be16 flags, __be16 proto,
 				    __be32 key, __be32 seq)
@@ -146,7 +135,13 @@ static inline void gre_build_header(struct sk_buff *skb, int hdr_len,
 		    !(skb_shinfo(skb)->gso_type &
 		      (SKB_GSO_GRE | SKB_GSO_GRE_CSUM))) {
 			*ptr = 0;
-			*(__sum16 *)ptr = gre_checksum(skb);
+			if (skb->ip_summed == CHECKSUM_PARTIAL) {
+				*(__sum16 *)ptr = csum_fold(lco_csum(skb));
+			} else {
+				skb->ip_summed = CHECKSUM_PARTIAL;
+				skb->csum_start = skb_transport_header(skb) - skb->head;
+				skb->csum_offset = sizeof(*greh);
+			}
 		}
 	}
 }
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 10bc49b..1121a9d 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -15,10 +15,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
+	bool need_csum, offload_csum, gso_partial, need_ipsec;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
-	bool need_csum, gso_partial;
 	u16 mac_len = skb->mac_len;
 	int gre_offset, outer_hlen;
 
@@ -47,6 +47,11 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	if (need_csum)
 		features &= ~NETIF_F_SCTP_CRC;
 
+	need_ipsec = skb_dst(skb) && dst_xfrm(skb_dst(skb));
+	/* Try to offload checksum if possible */
+	offload_csum = !!(need_csum && !need_ipsec &&
+			  (skb->dev->features & NETIF_F_HW_CSUM));
+
 	/* segment inner packet. */
 	segs = skb_mac_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
@@ -100,7 +105,13 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 		}
 
 		*(pcsum + 1) = 0;
-		*pcsum = gso_make_checksum(skb, 0);
+		if (skb->encapsulation || !offload_csum) {
+			*pcsum = gso_make_checksum(skb, 0);
+		} else {
+			skb->ip_summed = CHECKSUM_PARTIAL;
+			skb->csum_start = skb_transport_header(skb) - skb->head;
+			skb->csum_offset = sizeof(*greh);
+		}
 	} while ((skb = skb->next));
 out:
 	return segs;
-- 
2.1.0

