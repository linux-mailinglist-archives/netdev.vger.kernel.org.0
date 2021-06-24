Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994A73B2B89
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhFXJlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhFXJlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 05:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E50B613F7;
        Thu, 24 Jun 2021 09:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624527521;
        bh=pdW2QVi5lgMgtuRwExp4AtoMBgqeclkOLDlxZrbEIhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcsV+5QLm13OIep0WPtIlNNhz6J03D72zVdG1vkwmRJpPVquPpyNRLNPtFvYwJv0o
         apXYgL1yN+HLaX/h3UWo7hxAAJVCcLHavlnWz5ukeUSM9Momwi7st18q+SFca+rbDg
         EqGsdcxzLSw1PaZZsL7MtK6gYQalS+McFLd6z2WvpFulB/mCF4oLgt/PEx9YhQ2ZFp
         bb0/6AxyEgBH8zxz4O10+k/9Lm+Kt90edfq2LOXe1K3NC2MhP/g7xjNQN/IPYUFErY
         0+ChF/8uW6D9NkLKFKKDyst7iAMtqjNq4mIo3KINRmhlrVykRBYum9DCE+3Y77to5h
         lbx4sHkXNpJYg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, sd@queasysnail.net,
        andrew@lunn.ch, hkallweit1@gmail.com, irusskikh@marvell.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net 3/3] net: atlantic: fix the macsec key length
Date:   Thu, 24 Jun 2021 11:38:30 +0200
Message-Id: <20210624093830.943139-4-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624093830.943139-1-atenart@kernel.org>
References: <20210624093830.943139-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The key length used to store the macsec key was set to MACSEC_KEYID_LEN
(16), which is an issue as:
- This was never meant to be the key length.
- The key length can be > 16.

Fix this by using MACSEC_MAX_KEY_LEN instead (the max length accepted in
uAPI).

Fixes: 27736563ce32 ("net: atlantic: MACSec egress offload implementation")
Fixes: 9ff40a751a6f ("net: atlantic: MACSec ingress offload implementation")
Reported-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
index f5fba8b8cdea..a47e2710487e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
@@ -91,7 +91,7 @@ struct aq_macsec_txsc {
 	u32 hw_sc_idx;
 	unsigned long tx_sa_idx_busy;
 	const struct macsec_secy *sw_secy;
-	u8 tx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
+	u8 tx_sa_key[MACSEC_NUM_AN][MACSEC_MAX_KEY_LEN];
 	struct aq_macsec_tx_sc_stats stats;
 	struct aq_macsec_tx_sa_stats tx_sa_stats[MACSEC_NUM_AN];
 };
@@ -101,7 +101,7 @@ struct aq_macsec_rxsc {
 	unsigned long rx_sa_idx_busy;
 	const struct macsec_secy *sw_secy;
 	const struct macsec_rx_sc *sw_rxsc;
-	u8 rx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
+	u8 rx_sa_key[MACSEC_NUM_AN][MACSEC_MAX_KEY_LEN];
 	struct aq_macsec_rx_sa_stats rx_sa_stats[MACSEC_NUM_AN];
 };
 
-- 
2.31.1

