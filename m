Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87188635ECE
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbiKWNEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbiKWNEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:04:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A2CCB942;
        Wed, 23 Nov 2022 04:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF60AB81F6F;
        Wed, 23 Nov 2022 12:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06104C433C1;
        Wed, 23 Nov 2022 12:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207724;
        bh=VSOHmo7sDplewfab+OwnRAyCOu/HX80NiUna1LwAweg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sjxs0OeT1QyRSn0QYyeQ+hztPPyni+GUrHrFs6UY6zD1rGhqVliq61xgK5VEVmKMT
         Cu9kXusPyTVaYCfGc6PwPD4p2tyc6hwJt6Ticav0EFJ1eDYFcnh91jlIJaMkWJlMTT
         sB63mubxbPNy0bUPfQveIzGZiMb5v9lC5FybmrUgUZTtCDX6BYn0al9dpnGX2EtuvU
         V1bnQ6Yb/zd262vAXL2ifZLn50fvpAcAECkxJhx754GyeT5QgXjyh6sGHllA4/BROa
         A8GX7PztRZFCjwiRxgV1dbk3SUzb9SKf0SwKpDFW1qUIHOPTMD1X83uO5NZ7f6GLsx
         dS2caVcoORLKw==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v3 net-next 1/6] Revert "net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume"
Date:   Wed, 23 Nov 2022 14:48:30 +0200
Message-Id: <20221123124835.18937-2-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221123124835.18937-1-rogerq@kernel.org>
References: <20221123124835.18937-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 1af3cb3702d02167926a2bd18580cecb2d64fd94.

This is to make it easier to revert the offending commit
fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")

Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 -------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6b0458df613a..b43dc75c2202 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2714,7 +2714,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	struct clk *clk;
 	u64 id_temp;
 	int ret, i;
-	int ale_entries;
 
 	common = devm_kzalloc(dev, sizeof(struct am65_cpsw_common), GFP_KERNEL);
 	if (!common)
@@ -2809,10 +2808,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		goto err_of_clear;
 	}
 
-	ale_entries = common->ale->params.ale_entries;
-	common->ale_context = devm_kzalloc(dev,
-					   ale_entries * ALE_ENTRY_WORDS * sizeof(u32),
-					   GFP_KERNEL);
 	ret = am65_cpsw_init_cpts(common);
 	if (ret)
 		goto err_of_clear;
@@ -2883,7 +2878,6 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 	int i, ret;
 	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
-	cpsw_ale_dump(common->ale, common->ale_context);
 	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
@@ -2942,7 +2936,6 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	}
 
 	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
-	cpsw_ale_restore(common->ale, common->ale_context);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 4b75620f8d28..e95cc37a7286 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -149,8 +149,6 @@ struct am65_cpsw_common {
 	struct net_device *hw_bridge_dev;
 	struct notifier_block am65_cpsw_netdevice_nb;
 	unsigned char switch_id[MAX_PHYS_ITEM_ID_LEN];
-	/* only for suspend/resume context restore */
-	u32			*ale_context;
 };
 
 struct am65_cpsw_ndev_stats {
-- 
2.17.1

