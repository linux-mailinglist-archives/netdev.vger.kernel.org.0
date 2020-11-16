Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035932B3F97
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgKPJP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKPJP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:15:56 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3A8C0613CF;
        Mon, 16 Nov 2020 01:15:56 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 34so9389862pgp.10;
        Mon, 16 Nov 2020 01:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kzcHf4qEtowuNNsUci4VPgRhokFzxujl5WcBs5MXL4Y=;
        b=cxNZPywu6qn3f/MOS6B3JGgPe4gVgy+5jwt1bYI/GjP14ktcLrewAb82Fja+nhfy4D
         nDjKUebt1TU9vX2v6LH36i/hDhoJMOgUCro7brt7Mr8npsk2y2btJld/1E4d34PGpDG6
         oBoe5EjNZLKPMamw7du6wdQe7Qm8DOajzVJLYJuGGlSW3425eAoigMuKkHnEP89hp4cx
         vGTkiMYB3B2LQD4+FRj3dbMx4dTffJE67jDJMDLEuOPa8bKHVaHfV3RGYCqP9Tr+KkeX
         LF630I/5MENJLG/gr3Y6g2zf4mi6YC3bQKQWUke7ENz+XXGgS4lOGuCy2MztFqWT+UUf
         xXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kzcHf4qEtowuNNsUci4VPgRhokFzxujl5WcBs5MXL4Y=;
        b=rfQLxFbVjtmBKo8L6RsW7sqGG3nWMrIPZ1g4JAKjtal0zNXIm2989/1axGOfX6szwT
         81m7y17FU+Td0WChbjyrNOrRPqw4BduMCwpuu9omp/IKTvnx5rEOqa2eoGt3s93H8o5u
         jIbecRCJcY/d9eFJeXZl9Y6aON1TEngCiMKhocUPQ9YO0wtd7pfyHRd5G4i4EK1juOE1
         HKL7y4c5y8ev1FKtUzZeVDr+HRW7qO3JBFEx/I32tX/IHXxD7hBZQnRwvtPSvauofQaW
         oHPnqfSFAyDM4OkDNDNmWRYHr+uU3DdbSdZ950gqq84GFtSMm0tH1a84x4U5yb/jFPya
         gVUA==
X-Gm-Message-State: AOAM532BvudpsXen1iWi9f8B4x2vsy+jK4+yeH/Hq+9TSHMrqS11CB01
        zvOVvSaKge+LZQ2oemMCWfL4tYKQjLc=
X-Google-Smtp-Source: ABdhPJzEeHJxst6LWnNBgewnVuNPLaDp5agvIVLK8G1015Wytqa/+U/qIVT8CG0VayJ4nAkTmneO7A==
X-Received: by 2002:a63:2848:: with SMTP id o69mr9774875pgo.413.1605518155269;
        Mon, 16 Nov 2020 01:15:55 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u24sm17663466pfm.51.2020.11.16.01.15.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 01:15:54 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        gnault@redhat.com, pabeni@redhat.com, lorenzo@kernel.org
Subject: [PATCH net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
Date:   Mon, 16 Nov 2020 17:15:47 +0800
Message-Id: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to let it always do CRC checksum in sctp_gso_segment()
by removing CRC flag from the dev features in gre_gso_segment() for
SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.

It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
after that commit, so it would do checksum with gso_make_checksum()
in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
gre csum for sctp over gre tunnels") can be reverted now.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/gre_offload.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index e0a2465..a5935d4 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
-	bool need_csum, need_recompute_csum, gso_partial;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
 	u16 mac_len = skb->mac_len;
 	int gre_offset, outer_hlen;
+	bool need_csum, gso_partial;
 
 	if (!skb->encapsulation)
 		goto out;
@@ -41,10 +41,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	skb->protocol = skb->inner_protocol;
 
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
-	need_recompute_csum = skb->csum_not_inet;
 	skb->encap_hdr_csum = need_csum;
 
 	features &= skb->dev->hw_enc_features;
+	features &= ~NETIF_F_SCTP_CRC;
 
 	/* segment inner packet. */
 	segs = skb_mac_gso_segment(skb, features);
@@ -99,15 +99,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 		}
 
 		*(pcsum + 1) = 0;
-		if (need_recompute_csum && !skb_is_gso(skb)) {
-			__wsum csum;
-
-			csum = skb_checksum(skb, gre_offset,
-					    skb->len - gre_offset, 0);
-			*pcsum = csum_fold(csum);
-		} else {
-			*pcsum = gso_make_checksum(skb, 0);
-		}
+		*pcsum = gso_make_checksum(skb, 0);
 	} while ((skb = skb->next));
 out:
 	return segs;
-- 
2.1.0

