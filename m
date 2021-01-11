Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF652F144A
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbhAKNW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbhAKNWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:22:53 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B982EC061786;
        Mon, 11 Jan 2021 05:22:12 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b5so10577276pjl.0;
        Mon, 11 Jan 2021 05:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZsvKyfZNbkUgZwQwTqVunivVNEpXtGZADbSXAlyFMts=;
        b=O+kOVPocTQiFP5uAY0rAPaiG1ktXsBYFDCqJZIA/ufTaPCZW+lVtwsHgoafjfxlOAn
         dKrLcLmb23Bkss0lTf9GcmaBmsevpPOxq6/GyBXVyN4SYCQ9hH+kwff494PJJ20S+sKw
         ftoY+wnNRpL0xL8eAIQ/tPbIJ0JpgNVLoOY5LNK+RPK303OCPuLDFKR9TNpuxXZ23aCx
         DDOYHMkIHghCXS++kCUOXFuFHz1W4yJCf/xQUXhXFaqcxvL/7C5nKV4sOSsjNiS5bYcq
         L5bY4+1f0RFyava4yGQ8D85yw+sWdh1i3YOr0Z4yU69xz2zjsrvpYA/bTDmZ5Ntmp1yb
         NgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZsvKyfZNbkUgZwQwTqVunivVNEpXtGZADbSXAlyFMts=;
        b=At74iuxS2mFZ5pg3eUGF1gvVPmZFefmkyIZKvtPW99vuSrI3cjcFV8ugUv+sos23Hc
         XM19OJvXtUPQ39KdUFitVwlFYuvIA0W6MEba++8C4b8oltLiRPx8ecU3scWGPyZwvNgd
         KwE3DzJ2an1/LYpwLh6FNJwtDhEXWRz/ga971NkPsP6OpmMRHR+dRNPO44jOfo7OslrT
         PxPQK+V1woAK5AlK44oOdhhGBLQKovMhRYwHCrDDf1LqZcropO9CKaBBjzhJNfMYJ5PN
         bnJO5GFhJBAaci5JxRs6ljrGPyhycY3PcZGE5oB/jI3dz/IGziKxZqyeGkGAFf3nMwD1
         8bCg==
X-Gm-Message-State: AOAM533B0OjdjZJB8N+JgQ4QxwaaVgfh1iRnALU4NcyrSiYhj4nBQuyd
        +UikFDJC913fB6SjUtBcdjNLQJcsTPAbbg==
X-Google-Smtp-Source: ABdhPJzmavXf20PlEM3SVp+u//KzX75TlBzbSSXfFfwcpJRXqIEWQnACcz/Mstxt0lqUENsfZFTB4Q==
X-Received: by 2002:a17:90a:4817:: with SMTP id a23mr17840061pjh.16.1610371331893;
        Mon, 11 Jan 2021 05:22:11 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 193sm19373926pfz.36.2021.01.11.05.22.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 05:22:11 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCHv2 net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
Date:   Mon, 11 Jan 2021 21:22:03 +0800
Message-Id: <d8dc3cd362915974426d8274bb8ac6970a2096bb.1610371323.git.lucien.xin@gmail.com>
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

Note that the current HWs like igb NIC can only handle the SCTP CRC
when it's in the outer packet, not in the inner packet like in this
case, so here it removes CRC flag from the dev features even when
need_csum is false.

v1->v2:
  - improve the changelog.
  - fix "rev xmas tree" in varibles declaration.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/gre_offload.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index e0a2465..a681306 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -15,10 +15,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
-	bool need_csum, need_recompute_csum, gso_partial;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
+	bool need_csum, gso_partial;
 	u16 mac_len = skb->mac_len;
 	int gre_offset, outer_hlen;
 
@@ -41,10 +41,11 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	skb->protocol = skb->inner_protocol;
 
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
-	need_recompute_csum = skb->csum_not_inet;
 	skb->encap_hdr_csum = need_csum;
 
 	features &= skb->dev->hw_enc_features;
+	/* CRC checksum can't be handled by HW when SCTP is the inner proto. */
+	features &= ~NETIF_F_SCTP_CRC;
 
 	/* segment inner packet. */
 	segs = skb_mac_gso_segment(skb, features);
@@ -99,15 +100,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
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

