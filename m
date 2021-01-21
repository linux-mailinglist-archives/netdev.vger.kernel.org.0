Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343B42FF38E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhAUSuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbhAUIrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:47:10 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E715C061575
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:46:14 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id z21so935914pgj.4
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=bfYcNjs9yLyzTbVMgIgcdJUR93FtgJul/qWPg+jtbPg=;
        b=W6g/Teqo2Dag7nCWOwvqFBQmUIpLr/igIqzICtiVMjYoTmSYD7+frx3wJlDwfsz2kP
         FzaDSAVmYyXbqfvBH1Q935JK/esCdVTO/wCjZwIRRmasXMHwpsZ77oOncWCHJ7pGtM7u
         V9vW6Sge8fwHJQyJkOljuuvDiYj1xhEt708MEIxNzuwCuRYCF5HRuS1cWnMocwsvvyW7
         XtgP21b9+HefbGM+ZwIS5i2J224YahXyoahjsZhVllEk4Ld2zrMR+fL30UDRVU1tcavA
         KDXd4OVviC5aO21xSu/iV1dQPeJrDC1giVBsxQL4XwW0lEBNTwYLiWrlv+eH0sFRo5+Z
         y1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=bfYcNjs9yLyzTbVMgIgcdJUR93FtgJul/qWPg+jtbPg=;
        b=pWccSE9o7WxKaoB8vOFmTP4Krvkd34zSNdmg036R9z8U14k/nYeMDFqY4V+2Zyph8D
         wBlXPOYkPPXgI1K9ReJzU9b48Vv5Esp8c3yslDEiqfiZh05K0BKIIX/wdCbemvbiTtFa
         zB+V7QDx0f6CFxK1jIC8dFvmGmhV1cStanhXM7EhGYC2NqmH1flNGAmdgZMtypcUP74E
         YiIJl3TXZcueXR++kfTA7GdTz65CHMSGr9fUw+dytpnF6g5Gs2Vl5rLRH3g1sXvJIaa3
         qA/WxWxYwSy7jSd21xO1cU8ISe/lo1iKn9PSIFp4ScOON4IIDsdnzEmERwFsIOn0rfHN
         kqbg==
X-Gm-Message-State: AOAM531+Bgmlh543i1QDnaABE8Tm8V76immxlv4a+3U17p0D4pP2ftwr
        EcNEclz+xRewMUPCZL7o0FCAftWXepM=
X-Google-Smtp-Source: ABdhPJxVMP03LD0qNluuRf9LVpUeCMScTB9hBPbJsRkhc1K0DXmb8AIs8VyXDwnW+GtRxyQBDKZpQQ==
X-Received: by 2002:a62:6585:0:b029:1b9:d8d9:1af2 with SMTP id z127-20020a6265850000b02901b9d8d91af2mr10632809pfb.17.1611218773876;
        Thu, 21 Jan 2021 00:46:13 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e63sm4808202pfe.216.2021.01.21.00.46.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Jan 2021 00:46:13 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 3/3] ip_gre: add csum offload support for gre header
Date:   Thu, 21 Jan 2021 16:45:38 +0800
Message-Id: <2f662d55a698ef6d7af2b549f39b72d5b3a4f815.1611218673.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <bb59ed7c9c438bf076da3a956bb24fddf80978f7.1611218673.git.lucien.xin@gmail.com>
References: <cover.1611218673.git.lucien.xin@gmail.com>
 <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
 <bb59ed7c9c438bf076da3a956bb24fddf80978f7.1611218673.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611218673.git.lucien.xin@gmail.com>
References: <cover.1611218673.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/gre.h      | 20 ++++++++------------
 net/ipv4/gre_offload.c | 16 ++++++++++++++--
 net/sctp/output.c      |  1 +
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/include/net/gre.h b/include/net/gre.h
index b60f212..250b2fb 100644
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
@@ -146,7 +135,14 @@ static inline void gre_build_header(struct sk_buff *skb, int hdr_len,
 		    !(skb_shinfo(skb)->gso_type &
 		      (SKB_GSO_GRE | SKB_GSO_GRE_CSUM))) {
 			*ptr = 0;
-			*(__sum16 *)ptr = gre_checksum(skb);
+			if (skb->ip_summed == CHECKSUM_PARTIAL) {
+				*(__sum16 *)ptr = csum_fold(lco_csum(skb));
+			} else {
+				skb->csum_type = CSUM_T_IP_GENERIC;
+				skb->ip_summed = CHECKSUM_PARTIAL;
+				skb->csum_start = skb_transport_header(skb) - skb->head;
+				skb->csum_offset = sizeof(*greh);
+			}
 		}
 	}
 }
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 10bc49b..12d6996 100644
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
@@ -100,7 +105,14 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 		}
 
 		*(pcsum + 1) = 0;
-		*pcsum = gso_make_checksum(skb, 0);
+		if (skb->encapsulation || !offload_csum) {
+			*pcsum = gso_make_checksum(skb, 0);
+		} else {
+			skb->csum_type = CSUM_T_IP_GENERIC;
+			skb->ip_summed = CHECKSUM_PARTIAL;
+			skb->csum_start = skb_transport_header(skb) - skb->head;
+			skb->csum_offset = sizeof(*greh);
+		}
 	} while ((skb = skb->next));
 out:
 	return segs;
diff --git a/net/sctp/output.c b/net/sctp/output.c
index a8cf0191..52e12df 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -515,6 +515,7 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 		return 1;
 
 	if (!(tp->dst->dev->features & NETIF_F_SCTP_CRC) ||
+	    tp->dst->dev->type == ARPHRD_IPGRE ||
 	    dst_xfrm(tp->dst) || packet->ipfragok || tp->encap_port) {
 		struct sctphdr *sh =
 			(struct sctphdr *)skb_transport_header(head);
-- 
2.1.0

