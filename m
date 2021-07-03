Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109A53BAA19
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 21:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhGCTUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 15:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhGCTUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 15:20:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4BE61919;
        Sat,  3 Jul 2021 19:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625339865;
        bh=mrWU9jztvAXXGTCnxmouRppWGNj3qwSMU13psuTjTDI=;
        h=From:To:Cc:Subject:Date:From;
        b=HRRfaQ3pyMXroynATN1ItXx4pbIA4VpnTfuTLG0OomSvpL5jcD58JpYEh3Mx4x0pc
         QKNYsWvHs2WMhW3ipPBG674lOpiUI2hylT1bXWROysqgxhlEREZpEINjw7moT1AtYQ
         8VZ7U8BnOpY+To/MykOHWQYpPErO11qj8rHCmS683S1sff6au7JRZFBzqHA9JtNl/1
         C/+Rc9hPR8hLjrxJCP0nwhQPTObET8UulYTqvFFBxdjNkLfhmggXa/gttrcF4Jb3ke
         Eiu9CpOr12uC7Rxf6UC1qcL0g1voMnjpYMN8yksDU5bY2+Mu/LYBiHphXCdbLaXXhl
         HYBSCSyrG601Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, lorenzo.bianconi@redhat.com,
        linux@armlinux.org.uk, thomas.petazzoni@bootlin.com,
        brouer@redhat.com
Subject: [PATCH net] net: marvell: always set skb_shared_info in mvneta_swbm_add_rx_fragment
Date:   Sat,  3 Jul 2021 21:17:27 +0200
Message-Id: <ddbed54495f68d75857d3ff7ab43d15a1274c3b0.1625339666.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always set skb_shared_info data structure in mvneta_swbm_add_rx_fragment
routine even if the fragment contains only the ethernet FCS.

Fixes: 039fbc47f9f1 ("net: mvneta: alloc skb_shared_info on the mvneta_rx_swbm stack")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 361bc4fbe20b..76a7777c746d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2299,19 +2299,19 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		skb_frag_off_set(frag, pp->rx_offset_correction);
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
-
-		/* last fragment */
-		if (len == *size) {
-			struct skb_shared_info *sinfo;
-
-			sinfo = xdp_get_shared_info_from_buff(xdp);
-			sinfo->nr_frags = xdp_sinfo->nr_frags;
-			memcpy(sinfo->frags, xdp_sinfo->frags,
-			       sinfo->nr_frags * sizeof(skb_frag_t));
-		}
 	} else {
 		page_pool_put_full_page(rxq->page_pool, page, true);
 	}
+
+	/* last fragment */
+	if (len == *size) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		sinfo->nr_frags = xdp_sinfo->nr_frags;
+		memcpy(sinfo->frags, xdp_sinfo->frags,
+		       sinfo->nr_frags * sizeof(skb_frag_t));
+	}
 	*size -= len;
 }
 
-- 
2.31.1

