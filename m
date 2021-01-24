Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DFC301AB5
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbhAXIqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAXIqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:46:15 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D97C061756
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:45:17 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id h15so3267590pli.8
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=mK0/+9iW2x8uz2VxyxWZQDGjXg3EBuKUOG/sV5MybAs=;
        b=jxy+h3G9XVNZV0ZZ+6/wXUN9CzeSnxP7iUpA/4SQk4xcsU65xdbEmFIZ01fljeW4ic
         izdg7hITd4179Z+fnoA2/ifma5cTdqkqTmTTYa3ezipLldHUWDB54iMVUq8wvlcN1zbz
         oFoge6JaWLu5JCWRNQyhZwJEmR5bd2/HaGh6HErqD49V7OgHCgMvtQPL3mjqtOaQlqmN
         wTaSCjuoUfjSkfxa7NOatYYbl12Lbma/qnvoU0elqEsV/Y6fhChx56iWQq/dhxPiHPq5
         DXSfrAMvOo4xUem/z+CwyowgcsIAjQHxzrEdpOPqWcxe5cq5zRJsA7I6scGhET3UOMWw
         UeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=mK0/+9iW2x8uz2VxyxWZQDGjXg3EBuKUOG/sV5MybAs=;
        b=l/55pbfJlVgAry3SPf2L5W8aZ9bg0/9Fzq0V0ZfRcvZAodmL2Mq2HYjr/SxxkmHF48
         8zRENAUONzdcpkzYpNwpxskKoRuCGmeGAZtCfAHzxS47wFxtPkl4SUyel7+EFPjW61be
         6DcYqdj2K9rQ6w6n3dLki4yrlKFjwNNeLVhMekzEfJOPrUGWznXaFh3P+KCkM2uW3mKG
         Zf+OqXze7Zg/8AfM4cMgRLvN83ft4B5kxbqLUfsYBxRPvstQboPrdBAO2OzZ1f7uLuho
         3Yn5GnMk07SSb0/KSLqxpW/CD9g6MnecpvmK+LJPDFDB84c76D/tWwksrHkzIrkGkfLn
         XqUg==
X-Gm-Message-State: AOAM530X/nRf0bF9QM+rfsK31AUrfxF7E/C6PYftrROjo1Xn8e87C0PN
        0kPppCM77+A3y3K15wNRghGasOiF80/oPA==
X-Google-Smtp-Source: ABdhPJwIfo3tQHs23WgdEQ5KOur1pvCtPwN6/mNEDxDPds2D6qVOdufkxLXMWfiP3gFdw7mHn+56rg==
X-Received: by 2002:a17:902:8b8a:b029:df:fff2:c133 with SMTP id ay10-20020a1709028b8ab02900dffff2c133mr143164plb.63.1611477917096;
        Sun, 24 Jan 2021 00:45:17 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u4sm14480713pjv.22.2021.01.24.00.45.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Jan 2021 00:45:16 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 2/2] ip_gre: add csum offload support for gre header
Date:   Sun, 24 Jan 2021 16:44:52 +0800
Message-Id: <045a48adc4ff5d81e2ff9f685a9a8c4cea56b792.1611477858.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <100e0b32b0322e70127f415ea5b26afd26ac0fed.1611477858.git.lucien.xin@gmail.com>
References: <cover.1611477858.git.lucien.xin@gmail.com>
 <100e0b32b0322e70127f415ea5b26afd26ac0fed.1611477858.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611477858.git.lucien.xin@gmail.com>
References: <cover.1611477858.git.lucien.xin@gmail.com>
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

