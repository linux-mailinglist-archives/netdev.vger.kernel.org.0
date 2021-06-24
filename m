Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CF53B2B88
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhFXJlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFXJk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 05:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EC58613F6;
        Thu, 24 Jun 2021 09:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624527519;
        bh=nroBsKWJJxUHBe+pmBgTlAGQCdIlIewQPm2Pf4A08kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0IvcPRrCKY1ctUT8YQxQA9LjVshQoXoFCmz5E080rRilk3yrDEVGKVeluUoY5wep
         lmeF3sUw9ib+ON8XDvd0GdSUzQvVNzWrJuzB9igGqMHfnZEke9iA/SzkTO5STiDk8y
         CXeNFzNptuC5DT9kv0a2avKd7vhpNmZ4axVhhjlFEhNlv58oUa97ou4piW1y1JIvSi
         HtnkYVhxK6AlVZgIgEvvyK3UeSc3x3ZGVr8HXMgbiw0czrhN6fwbjhEJn4ihVqB7Lz
         nALBSyN4Aung8t+6Hx+3eZec2UPsaEvqOZw/aJplib6CulCrsmCk+2CvFmoHvylcdC
         wpIFBQSaDPlUw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, sd@queasysnail.net,
        andrew@lunn.ch, hkallweit1@gmail.com, irusskikh@marvell.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net 2/3] net: phy: mscc: fix macsec key length
Date:   Thu, 24 Jun 2021 11:38:29 +0200
Message-Id: <20210624093830.943139-3-atenart@kernel.org>
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

Fixes: 28c5107aa904 ("net: phy: mscc: macsec support")
Reported-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 2 +-
 drivers/net/phy/mscc/mscc_macsec.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 10be266e48e8..b7b2521c73fb 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -501,7 +501,7 @@ static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
 }
 
 /* Derive the AES key to get a key for the hash autentication */
-static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
+static int vsc8584_macsec_derive_key(const u8 key[MACSEC_MAX_KEY_LEN],
 				     u16 key_len, u8 hkey[16])
 {
 	const u8 input[AES_BLOCK_SIZE] = {0};
diff --git a/drivers/net/phy/mscc/mscc_macsec.h b/drivers/net/phy/mscc/mscc_macsec.h
index 9c6d25e36de2..453304bae778 100644
--- a/drivers/net/phy/mscc/mscc_macsec.h
+++ b/drivers/net/phy/mscc/mscc_macsec.h
@@ -81,7 +81,7 @@ struct macsec_flow {
 	/* Highest takes precedence [0..15] */
 	u8 priority;
 
-	u8 key[MACSEC_KEYID_LEN];
+	u8 key[MACSEC_MAX_KEY_LEN];
 
 	union {
 		struct macsec_rx_sa *rx_sa;
-- 
2.31.1

