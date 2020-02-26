Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6631704D2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgBZQt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:49:56 -0500
Received: from mail-eopbgr70130.outbound.protection.outlook.com ([40.107.7.130]:57611
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbgBZQt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 11:49:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrWE+wzwGVE5Pz6zFmFTvn9cpEUoWtfw4rK70HS9kPRI0qK6PWyE1cX43piv6J/aMhB2RRZDPjwkWDPoDEJmNkJ+omHUSCnDo6jygsSoN4LtOtgDsaO3C6OauhSD77QaCJ3BcxDK9Y6TanRDfiFA+j23VC0fxpAzjS7AhEm9J4t5LroTxNt92JKV5FdEwh6Wjju5QbOFtZJIK0z22Co29Eqll/LrRiNPUIUSpEmOLFvqeMAPGZ3u1NTqPpNHcBB4UUSuw1X4qd4ZKeIGLwL9TjYZZDUfwu3XmvQioZ6Rwkm79JuO8yQkQqoKmPiAxTonhyRcdOeeKqELLyfoY4/KuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5SNKEzE4sk0pYUuWVBX9EkUt+5NO5rqjz4l15olbpY=;
 b=oZ1wL3OLq2Qecf5orM6tgjAT5Mw/odvPk4i+OpOdsdPc4wMpBuSlDYi99msHtsr59zuHa2thZW4WDlqkGipCDTsibhV0oA1p9CY069ZxL1hfTnZ36ePREUh+IWAnP5ak2DPwk5I+/tmR54xcs2PH825ddEPZz7AEm4HP3+AmaLc9En5QVHgK9qcyHqcCde9UTsHDSJc8d/R9QGf7FU3+YxunXpW2sSlJlr+/VQkuQI66/rS1r51pa/Tqmzdv0+KtcxAHqxHCznkaMAuMGDsuI2rKw7wVJOvw1/aCWWLwyELdT3HdDVKJmXF3+Oy23hN9Q//3ZHI1kMsLzeR8R10leA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5SNKEzE4sk0pYUuWVBX9EkUt+5NO5rqjz4l15olbpY=;
 b=LPhdYAozp5XBd9JEUsG4fkDbyiDG5NS7MmOM22QAfuscAcN2Jcyig6Y+ZhHjktUAzSiLsjvJLSiwnrpOI8Ic8p6kZdG538FT3xbmIv2ugWTuSFDXIf3KxopOdvPKZmiPZjkeQNUrB7Y82hR3oMxCwbcwnEhJ9aILapkPWKQsOpc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=aaro.koskinen@nokia.com; 
Received: from VI1PR07MB6174.eurprd07.prod.outlook.com (20.178.9.83) by
 VI1PR07MB6304.eurprd07.prod.outlook.com (10.141.128.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.7; Wed, 26 Feb 2020 16:49:52 +0000
Received: from VI1PR07MB6174.eurprd07.prod.outlook.com
 ([fe80::7514:700c:669b:3c8f]) by VI1PR07MB6174.eurprd07.prod.outlook.com
 ([fe80::7514:700c:669b:3c8f%7]) with mapi id 15.20.2772.012; Wed, 26 Feb 2020
 16:49:52 +0000
From:   aaro.koskinen@nokia.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: [PATCH v2] net: stmmac: fix notifier registration
Date:   Wed, 26 Feb 2020 18:49:01 +0200
Message-Id: <20200226164901.21883-1-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: HE1PR08CA0048.eurprd08.prod.outlook.com
 (2603:10a6:7:2a::19) To VI1PR07MB6174.eurprd07.prod.outlook.com
 (2603:10a6:803:a5::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ak-desktop.emea.nsn-net.net (131.228.2.28) by HE1PR08CA0048.eurprd08.prod.outlook.com (2603:10a6:7:2a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Wed, 26 Feb 2020 16:49:51 +0000
X-Mailer: git-send-email 2.11.0
X-Originating-IP: [131.228.2.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed2d9185-6590-4160-1efd-08d7badbe61b
X-MS-TrafficTypeDiagnostic: VI1PR07MB6304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB63046E1DD6060C4ABA3B0C1CF4EA0@VI1PR07MB6304.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:164;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(189003)(199004)(16526019)(6486002)(186003)(26005)(956004)(478600001)(52116002)(8936002)(9686003)(66946007)(36756003)(6512007)(966005)(110136005)(6506007)(6666004)(1076003)(316002)(2616005)(86362001)(81156014)(8676002)(5660300002)(2906002)(107886003)(66476007)(66556008)(81166006)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB6304;H:VI1PR07MB6174.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1g/ool0Vko3SDr1PSDAqSbHSiossD0us+sBBa97UXYwxgV1age0TlcNhK0NC8bhsUsKSskXSqVbaqIQpHFNvjCYsEHQYvShkiwLnGnXeIyaFPe5HwDN98JR3rMQrNMYysBj33Cih8lUSBrcndTpPAxKYbh2VW9ItxaBv7uCsgzZeSAoQ4WoPFfs0rVibvj7OK9QGJOCCNwfHTHWdKDsNhWGLVLT5JbmT1VnSkor4G4B2xdtmBwnlT0dKuXZrf+J/YfqxdGsJyd23uOTP8+DVYrpc0FDWNK4c/r5Jzf2CJywYYVpbLQ2VCJOlhPQ0h0ZQJprdhUI3psNcnN+KKttwTh0K3ZC3LM4luGDZdlyyEtq0XTMixIejLG4Bt88QAmJmQTNpMEhevUtHuO6tbDG+aq6kUfl5QP0Cg71IMzs6ykgqepmZMC/5sP4nY3sQSnn0qXR512W0l/Mp1yisKngg+FxVZ/Fg+dbVxuUC1DMGnSAiXxewjqs+tGwcDwEh07k+b/xmtAJGeKutw80Obk+/Q==
X-MS-Exchange-AntiSpam-MessageData: kMAJt/3iJLIqXlif6hFysO20Mz8tKy0uW+Z1tOZ/EVdnzspTQYRXKNdSVETYirevHQcl4DAPUBzz0UtAyKlVZyCtbbEBL9G/HYQPXqdXPxbuS3KSpnuP0NzcUwQO2QQ0DfuI9iMfahW6OA0r3N9Bjw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2d9185-6590-4160-1efd-08d7badbe61b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 16:49:52.0763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqk15SbCdtJM7dUtcOZ7mt5Q63z0hQaV5cxJkMKzHUqShWTH35cv+ZseoaVCYBEhOk01gwyvbqUOcs+xysPJYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6304
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nokia.com>

We cannot register the same netdev notifier multiple times when probing
stmmac devices. Register the notifier only once in module init, and also
make debugfs creation/deletion safe against simultaneous notifier call.

Fixes: 481a7d154cbb ("stmmac: debugfs entry name is not be changed when udev rename device name.")
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---

	v2: Register the notifier in module init.

	v1: https://patchwork.ozlabs.org/patch/1244006/

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5836b21edd7e..7da18c9afa01 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4405,6 +4405,8 @@ static void stmmac_init_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
+	rtnl_lock();
+
 	/* Create per netdev entries */
 	priv->dbgfs_dir = debugfs_create_dir(dev->name, stmmac_fs_dir);
 
@@ -4416,14 +4418,13 @@ static void stmmac_init_fs(struct net_device *dev)
 	debugfs_create_file("dma_cap", 0444, priv->dbgfs_dir, dev,
 			    &stmmac_dma_cap_fops);
 
-	register_netdevice_notifier(&stmmac_notifier);
+	rtnl_unlock();
 }
 
 static void stmmac_exit_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	unregister_netdevice_notifier(&stmmac_notifier);
 	debugfs_remove_recursive(priv->dbgfs_dir);
 }
 #endif /* CONFIG_DEBUG_FS */
@@ -4940,14 +4941,14 @@ int stmmac_dvr_remove(struct device *dev)
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
-#ifdef CONFIG_DEBUG_FS
-	stmmac_exit_fs(ndev);
-#endif
 	stmmac_stop_all_dma(priv);
 
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
+#ifdef CONFIG_DEBUG_FS
+	stmmac_exit_fs(ndev);
+#endif
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
@@ -5166,6 +5167,7 @@ static int __init stmmac_init(void)
 	/* Create debugfs main directory if it doesn't exist yet */
 	if (!stmmac_fs_dir)
 		stmmac_fs_dir = debugfs_create_dir(STMMAC_RESOURCE_NAME, NULL);
+	register_netdevice_notifier(&stmmac_notifier);
 #endif
 
 	return 0;
@@ -5174,6 +5176,7 @@ static int __init stmmac_init(void)
 static void __exit stmmac_exit(void)
 {
 #ifdef CONFIG_DEBUG_FS
+	unregister_netdevice_notifier(&stmmac_notifier);
 	debugfs_remove_recursive(stmmac_fs_dir);
 #endif
 }
-- 
2.11.0

