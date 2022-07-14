Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B25744C7
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbiGNGAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiGNGA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:00:26 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D7830564;
        Wed, 13 Jul 2022 23:00:24 -0700 (PDT)
X-UUID: 0447f95b1c89461ea7ab33728d43a720-20220714
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:517bff6a-e90f-4cd4-a81e-7ed7ef6d5832,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:4170f332-b9e4-42b8-b28a-6364427c76bb,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 0447f95b1c89461ea7ab33728d43a720-20220714
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 401005709; Thu, 14 Jul 2022 14:00:20 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 14 Jul 2022 14:00:19 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Thu, 14 Jul 2022 14:00:18 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Subject: [PATCH net v5 2/3] net: stmmac: fix pm runtime issue in stmmac_dvr_remove()
Date:   Thu, 14 Jul 2022 14:00:13 +0800
Message-ID: <20220714060014.18958-3-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220714060014.18958-1-biao.huang@mediatek.com>
References: <20220714060014.18958-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If netif is running when stmmac_dvr_remove is invoked,
the unregister_netdev will call ndo_stop(stmmac_release) and
vlan_kill_rx_filter(stmmac_vlan_rx_kill_vid).

Currently, stmmac_dvr_remove() will disable pm runtime before
unregister_netdev. When stmmac_vlan_rx_kill_vid is invoked,
pm_runtime_resume_and_get in it returns EACCESS error number,
and reports:

	dwmac-mediatek 11021000.ethernet eth0: stmmac_dvr_remove: removing driver
	dwmac-mediatek 11021000.ethernet eth0: FPE workqueue stop
	dwmac-mediatek 11021000.ethernet eth0: failed to kill vid 0081/0

Move the pm_runtime_disable to the end of stmmac_dvr_remove
to fix this issue.

Fixes: 6449520391dfc ("net: stmmac: properly handle with runtime pm in stmmac_dvr_remove()")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d1a7cf4567bc..197fac587ad5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7213,8 +7213,6 @@ int stmmac_dvr_remove(struct device *dev)
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
 	pm_runtime_get_sync(dev);
-	pm_runtime_disable(dev);
-	pm_runtime_put_noidle(dev);
 
 	stmmac_stop_all_dma(priv);
 	stmmac_mac_set(priv, priv->ioaddr, false);
@@ -7241,6 +7239,9 @@ int stmmac_dvr_remove(struct device *dev)
 	mutex_destroy(&priv->lock);
 	bitmap_free(priv->af_xdp_zc_qps);
 
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_dvr_remove);
-- 
2.25.1

