Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB2749BE6A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbiAYWX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiAYWX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:23:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2BDC061744
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 14:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89E6EB81B7E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 22:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17999C340EC;
        Tue, 25 Jan 2022 22:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643149405;
        bh=8EPKyibJPLFnHUibBxFOVRIZAK8CWCm519c3Pj97zX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIXtezNj0TWdcKKrPGPRfLpD2UXRoPwz1ju5pSksWa3zaC1T+VCeCiNJsbr3LIPrQ
         iZwd/qjqEbVso9XebxULwO72FX8OPU5BEzinbQ7S2OIygc33cwoOhZX0D941EXltyL
         yCp4uuTDSxtWT8eowrGYvJRiJ/nq7Mfrzq2JVIYjmcLz4AVws5r7Rb4ARhEEJSSBnP
         0rR/UY8K44uM5at8rKSn88MJTSIKpk3L+uLX/XRU9LCuo4qKqRXTLbb3gqFiyrw96a
         4sUxKUanHTXRuJi7PCLDGN/9U7yh0gjTxBe73ykGDBCvPJHSYY1p34ASach2k5B4ph
         PAZj+RWkxWVpA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] ethernet: tundra: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 14:23:16 -0800
Message-Id: <20220125222317.1307561-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125222317.1307561-1-kuba@kernel.org>
References: <20220125222317.1307561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr is const now.

Maintain the questionable offsetting in ndo_set_mac_address.

Compile tested holly_defconfig and mpc7448_hpc2_defconfig.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 35 ++++++++++++------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index cf0917b29e30..5251fc324221 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1091,20 +1091,22 @@ static int tsi108_get_mac(struct net_device *dev)
 	struct tsi108_prv_data *data = netdev_priv(dev);
 	u32 word1 = TSI_READ(TSI108_MAC_ADDR1);
 	u32 word2 = TSI_READ(TSI108_MAC_ADDR2);
+	u8 addr[ETH_ALEN];
 
 	/* Note that the octets are reversed from what the manual says,
 	 * producing an even weirder ordering...
 	 */
 	if (word2 == 0 && word1 == 0) {
-		dev->dev_addr[0] = 0x00;
-		dev->dev_addr[1] = 0x06;
-		dev->dev_addr[2] = 0xd2;
-		dev->dev_addr[3] = 0x00;
-		dev->dev_addr[4] = 0x00;
+		addr[0] = 0x00;
+		addr[1] = 0x06;
+		addr[2] = 0xd2;
+		addr[3] = 0x00;
+		addr[4] = 0x00;
 		if (0x8 == data->phy)
-			dev->dev_addr[5] = 0x01;
+			addr[5] = 0x01;
 		else
-			dev->dev_addr[5] = 0x02;
+			addr[5] = 0x02;
+		eth_hw_addr_set(dev, addr);
 
 		word2 = (dev->dev_addr[0] << 16) | (dev->dev_addr[1] << 24);
 
@@ -1114,12 +1116,13 @@ static int tsi108_get_mac(struct net_device *dev)
 		TSI_WRITE(TSI108_MAC_ADDR1, word1);
 		TSI_WRITE(TSI108_MAC_ADDR2, word2);
 	} else {
-		dev->dev_addr[0] = (word2 >> 16) & 0xff;
-		dev->dev_addr[1] = (word2 >> 24) & 0xff;
-		dev->dev_addr[2] = (word1 >> 0) & 0xff;
-		dev->dev_addr[3] = (word1 >> 8) & 0xff;
-		dev->dev_addr[4] = (word1 >> 16) & 0xff;
-		dev->dev_addr[5] = (word1 >> 24) & 0xff;
+		addr[0] = (word2 >> 16) & 0xff;
+		addr[1] = (word2 >> 24) & 0xff;
+		addr[2] = (word1 >> 0) & 0xff;
+		addr[3] = (word1 >> 8) & 0xff;
+		addr[4] = (word1 >> 16) & 0xff;
+		addr[5] = (word1 >> 24) & 0xff;
+		eth_hw_addr_set(dev, addr);
 	}
 
 	if (!is_valid_ether_addr(dev->dev_addr)) {
@@ -1136,14 +1139,12 @@ static int tsi108_set_mac(struct net_device *dev, void *addr)
 {
 	struct tsi108_prv_data *data = netdev_priv(dev);
 	u32 word1, word2;
-	int i;
 
 	if (!is_valid_ether_addr(addr))
 		return -EADDRNOTAVAIL;
 
-	for (i = 0; i < 6; i++)
-		/* +2 is for the offset of the HW addr type */
-		dev->dev_addr[i] = ((unsigned char *)addr)[i + 2];
+	/* +2 is for the offset of the HW addr type */
+	eth_hw_addr_set(dev, ((unsigned char *)addr) + 2);
 
 	word2 = (dev->dev_addr[0] << 16) | (dev->dev_addr[1] << 24);
 
-- 
2.34.1

