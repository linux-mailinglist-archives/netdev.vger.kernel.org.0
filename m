Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E1463C137
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiK2Nf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiK2Nfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:35:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15FB627E8;
        Tue, 29 Nov 2022 05:35:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D659B8162D;
        Tue, 29 Nov 2022 13:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C01C43470;
        Tue, 29 Nov 2022 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669728927;
        bh=kvstdPpBR+/mRxEi9E/PktQ1fiwMJVU4LvP10NqUmvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2HC3MD37hGupbzyOmeEO1aA6t3RiMy+VB3YJXmAB38sCF+25Y9wsyskR4D2Qfjl8
         C6xfy8E9hDaGsGlNBeV2j+Bi1MHF2QiNIuGSfjsL9gC5FzwJqQoIB0Mmw/uxIzOIYt
         UWRW3uDBhJgJj4+r1DFdpzIMPsymm4Dstsqo9TbGJgUPVZpNNdzKdZrF0ilFUtt330
         BuUjDQinKbWlqaxMzRahjuOP0OeveEtwCz9EAUU0QYco7gul9AKh4uoXpZ1ngSp+Ir
         J5/K5hQ9739ItNHPtxZWSWDa089ugBy/af8lR9TwpykJqXk1b6n+m7RQimbOhYxuqW
         cTwjGas2LDYNg==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v4 net-next 6/6] net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume
Date:   Tue, 29 Nov 2022 15:35:01 +0200
Message-Id: <20221129133501.30659-7-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221129133501.30659-1-rogerq@kernel.org>
References: <20221129133501.30659-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On low power during system suspend the ALE table context is lost.
Save the ALE context before suspend and restore it after resume.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 3f430f8d8a26..43bb71a471ae 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2712,6 +2712,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	struct clk *clk;
 	u64 id_temp;
 	int ret, i;
+	int ale_entries;
 
 	common = devm_kzalloc(dev, sizeof(struct am65_cpsw_common), GFP_KERNEL);
 	if (!common)
@@ -2807,6 +2808,10 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		goto err_of_clear;
 	}
 
+	ale_entries = common->ale->params.ale_entries;
+	common->ale_context = devm_kzalloc(dev,
+					   ale_entries * ALE_ENTRY_WORDS * sizeof(u32),
+					   GFP_KERNEL);
 	ret = am65_cpsw_init_cpts(common);
 	if (ret)
 		goto err_of_clear;
@@ -2877,6 +2882,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
 	struct net_device *ndev;
 	int i, ret;
 
+	cpsw_ale_dump(common->ale, common->ale_context);
 	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
@@ -2949,6 +2955,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 	}
 
 	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
+	cpsw_ale_restore(common->ale, common->ale_context);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index e95cc37a7286..4b75620f8d28 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -149,6 +149,8 @@ struct am65_cpsw_common {
 	struct net_device *hw_bridge_dev;
 	struct notifier_block am65_cpsw_netdevice_nb;
 	unsigned char switch_id[MAX_PHYS_ITEM_ID_LEN];
+	/* only for suspend/resume context restore */
+	u32			*ale_context;
 };
 
 struct am65_cpsw_ndev_stats {
-- 
2.17.1

