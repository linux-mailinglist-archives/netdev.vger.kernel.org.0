Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42A6635EE7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbiKWNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238577AbiKWNFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:05:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D636CEBB5;
        Wed, 23 Nov 2022 04:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A451B61C61;
        Wed, 23 Nov 2022 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5559C43144;
        Wed, 23 Nov 2022 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207739;
        bh=o3Io+SK7lX1cC2f73bZPoDGBckcr/KVKDkRqhBF9SK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/bcDk7krj5VnAJm2QAY4P6ukQmr50nr9VztKrPLZPPaAHHARlB6jDeG3CJe7ygK9
         ajzzdKjAc2QfpF2CE4IYwJ3JEUOC+BJ/c0v6+WZaPjIOVTPdc5ZdnxRSTDpyHYlFxZ
         YH2We6ZPxg2x9fSSn8yDKw1rYBeFFJhm/n1CSHt8ilolU4AMupj5uTXVou9+f30F6j
         VZ7ruHQjgtlhEPGMXxc9H4QuOMQftV/WiJtoJ0yCDe3/rqaSPF+fwu2iu2FmOozO6k
         ZotEDFxugoZRZXAlfCmiy8buyVdCayVEkeBUKn4/WggsU+nvHnYZE3FyTD2j0MuDfM
         KqB9UuK0uof5g==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v3 net-next 6/6] net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume
Date:   Wed, 23 Nov 2022 14:48:35 +0200
Message-Id: <20221123124835.18937-7-rogerq@kernel.org>
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

On low power during system suspend the ALE table context is lost.
Save the ALE context before suspend and restore it after resume.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f5357afde527..72e4ee71f106 100644
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
 	int i, ret;
 	struct am65_cpsw_host *host_p = am65_common_get_host(common);
 
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

