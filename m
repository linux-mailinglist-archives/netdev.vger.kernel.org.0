Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5514C49BE69
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiAYWX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiAYWX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:23:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C114C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 14:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3645FB81979
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 22:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89E0C340E8;
        Tue, 25 Jan 2022 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643149404;
        bh=X4yd7Dxmu5PFhFcieA8ox30wK4paNfYa0lKukRAMuz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCdys/vlY2Qp4/gtHtvlGXk6GjSGjb3QJiRTkEJVq4JWB7WZCyhN+BA8+Zu3O8tNd
         IBMMPukejSBCpT5gFfxkllHFL0p/PuFCKG4Hf8lb4W1hNU4miigEtdynVrc35KKnu1
         72rfGUawKfgzql4rC0zomFxFsXl9p12C7DOX4O14BTRivYpaK/5KiXT/LuYTUcOzJd
         Na99zLBfqFDQuETUvxjtAR22cMZBgP5q26iVlI1733M8VzqvGJQkUqDGktLxPww50Q
         HGqbHDd6Us27SZl3lYp5HunXQeOFHDtV+75t+BUiRLAduSL4djOfg8pdEXcmA40gA1
         Vdk6eMcWGpPSA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/3] ethernet: 3com/typhoon: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 14:23:15 -0800
Message-Id: <20220125222317.1307561-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125222317.1307561-1-kuba@kernel.org>
References: <20220125222317.1307561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver casts off the const and writes directly to netdev->dev_addr.
This will result in a MAC address tree corruption and a warning.

Compile tested ppc6xx_defconfig.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/3com/typhoon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 481f1df3106c..8aec5d9fbfef 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2278,6 +2278,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *dev;
 	struct typhoon *tp;
 	int card_id = (int) ent->driver_data;
+	u8 addr[ETH_ALEN] __aligned(4);
 	void __iomem *ioaddr;
 	void *shared;
 	dma_addr_t shared_dma;
@@ -2409,8 +2410,9 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto error_out_reset;
 	}
 
-	*(__be16 *)&dev->dev_addr[0] = htons(le16_to_cpu(xp_resp[0].parm1));
-	*(__be32 *)&dev->dev_addr[2] = htonl(le32_to_cpu(xp_resp[0].parm2));
+	*(__be16 *)&addr[0] = htons(le16_to_cpu(xp_resp[0].parm1));
+	*(__be32 *)&addr[2] = htonl(le32_to_cpu(xp_resp[0].parm2));
+	eth_hw_addr_set(dev, addr);
 
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		err_msg = "Could not obtain valid ethernet address, aborting";
-- 
2.34.1

