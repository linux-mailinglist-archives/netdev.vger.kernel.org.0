Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511EE3B2B87
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhFXJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFXJky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 05:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA28613F7;
        Thu, 24 Jun 2021 09:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624527516;
        bh=j9LKsxTjE7kLy/riQPudALCo1NepgJYKTZyqAjzyA7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ya3pQleo2NTskmiHEFPKJfSywFmHL2cVFcUs8sWnnq2WcaJu7KYvdf5DDaXZVgCFM
         A2vGg5Dr4hpk4SKRq0Ng/fcXCRAG2fhl5NzgAiOonpm5QTF76+bc1T3ZmPvKwRT1Lh
         ugKvqTOhq9U8zGIEYndaD6McFvR/4jR1owlyotBkpXXGAtYV4bZwObmAmZuQ7bzq9X
         2mFyZqrMjrkswFcsUVEkEDm+AnBJf6fL2qj151fhA2MT+bk424dKVJ72ZHnI6CBH6q
         bAw9Pcfrdgx/JWysqt+Yx403gcc82KkeK0/W+mh1BWconPek5caPZI7smTjYN7x0sh
         8z/rWttjc3MDA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, sd@queasysnail.net,
        andrew@lunn.ch, hkallweit1@gmail.com, irusskikh@marvell.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net 1/3] net: macsec: fix the length used to copy the key for offloading
Date:   Thu, 24 Jun 2021 11:38:28 +0200
Message-Id: <20210624093830.943139-2-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624093830.943139-1-atenart@kernel.org>
References: <20210624093830.943139-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The key length used when offloading macsec to Ethernet or PHY drivers
was set to MACSEC_KEYID_LEN (16), which is an issue as:
- This was never meant to be the key length.
- The key length can be > 16.

Fix this by using MACSEC_MAX_KEY_LEN to store the key (the max length
accepted in uAPI) and secy->key_len to copy it.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Reported-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/macsec.c | 4 ++--
 include/net/macsec.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 92425e1fd70c..93dc48b9b4f2 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1819,7 +1819,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		ctx.sa.rx_sa = rx_sa;
 		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
-		       MACSEC_KEYID_LEN);
+		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
 		if (err)
@@ -2061,7 +2061,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		ctx.sa.tx_sa = tx_sa;
 		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
-		       MACSEC_KEYID_LEN);
+		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_txsa, &ctx);
 		if (err)
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 52874cdfe226..d6fa6b97f6ef 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -241,7 +241,7 @@ struct macsec_context {
 	struct macsec_rx_sc *rx_sc;
 	struct {
 		unsigned char assoc_num;
-		u8 key[MACSEC_KEYID_LEN];
+		u8 key[MACSEC_MAX_KEY_LEN];
 		union {
 			struct macsec_rx_sa *rx_sa;
 			struct macsec_tx_sa *tx_sa;
-- 
2.31.1

