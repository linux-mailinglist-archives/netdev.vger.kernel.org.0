Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12421E8921
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgE2Uqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:46:45 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727024AbgE2Uqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:46:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biF6lK15kNUvbNM8w5VTnR31Biyjo0y7XDSXk1vodi9e+59s255dP1MqkswiAyGPknmDoAE6jlNZ3xzd4BRFyheD08vjUxo+e9j0KGKzgE745MSq+PWpNtp2KeAwJSfEh57FsSVylJ19YptNQIrHZIQYLdTxDXWyh/e1XHj4ZWs0cUuWgDPr6mXB3+rCEhqdMDaDFZG6q8GFpuQfidU9xjJppwMkOo1Zm2zPbMWVXgsihrJGuS4FRjqemrVuhp7/uBcNyo2m61kCz5Uc6NqUh52UiyyTi/gzPPp7lF+72haaP26OpIeM3XYt5gJgVuC4pP6sFBKCrF815yjKznm/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+BrsDz9hr1TCdq7J2jSPh9lErbDMzKJlkwI7D2s2c=;
 b=RNNZBVcz2jIGtKtFv93IdAHw0+tmrEEjTmfD+XLOE8YIEmusB0QN9DVFlnxjPAWCcUL6LXUTrqrUw7gX3X4+RahPMi31dKKwYH0gonqggavF5HXY6E7EwGugIfFZXsqAAijN3uRXthzyao5UBwf3fFUgFATR5FF91ZdMJzglnGcqy1FC0Iv/TOfsZrFB2VmZ3UzPjUDTayGMG20l/z9NjBiS1aqkXlrDV7YWd72krchpJRH5u4L+2zXtnMMTqffS0nhe6sQCTFBGiiHWf0DoAzaLqydfXq6M+W+wVEzRdFGWOPPAcrjYw9XVxk32zdRzQHPq1eE/X+aD+Y7LxABwLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+BrsDz9hr1TCdq7J2jSPh9lErbDMzKJlkwI7D2s2c=;
 b=lJlx6SeyOCzRqvtz+HrQvfO23QK4898XVn5Elrp0FKVoOgAQHyFnpIKIO2vgSq40Fz5Dhmhv+xmuRf9DC7axGZh7dOBlLMIRulJCaFZQ3V2ZU4jkJbAQuOghcX+tGPTCC3Ykxz0TKmEG/txx+rcxjQRaJwH1/0w8cYAAwQWl5a0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Dexuan Cui <decui@microsoft.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 1/7] net/mlx5: Fix crash upon suspend/resume
Date:   Fri, 29 May 2020 13:46:04 -0700
Message-Id: <20200529204610.253456-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529204610.253456-1-saeedm@mellanox.com>
References: <20200529204610.253456-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:38 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ea2cb09-3294-418a-2d06-08d80411639a
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3359E4C36806676332423246BE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +H/uElkUhpY+mJjlMI8dKKjqiOWCqcAQrrmL4Tg3BAMoc8/lmAw3EFMPjX2rou28xiufZ3FydjMKCXY3D/14bfz/UkIbhZBTXpVMFlhWSsfiOf79MejcRK6G8rCsLax7XJpVgQKmhvdm9IaQepuYTvNpd4Vqv/JvhzdcjudKsNmf1vMmhU3totIOh2QaUqkS1iday92sWgy47Oik0HIlZ3UnJM2oGj9L/060oRhORAVTeKWNamjN9mZbf0ohpG9fmprwltzygYRT4N3a7dKGlV6vhuvac0ktPVgmksDeVFjzPdo7paXMfaxl96KgfD8V9Y4qNzKsTwfHKtbTIRUhLdm2VGX1Up9PdEaEUQiLr7F43f3USBoi/a/FCs/fPEQX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(54906003)(15650500001)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(45080400002)(107886003)(4326008)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SrGfmOFm73KJUPsVBBUrkeG4i1ED4tFyZdgEKbkUz9RhbNch8OPZHp8bTsXTCGY4+delnKTq2KD0VwQr60j5UcohqGAn8dFEhnkPkkj3bGxe4cITijW/tUFnkxYx9NiD7teSgV8xtHJh6e0lYrfEWKZclAbiKNsH29U4nluWgRfGrN9NG67uL9d3mdVIHT4ixklcw+Xgr4wPqlO4FRV7fVo/ZjizWHGG28f7jf+R4Kzpcjjlt00pKKxdNP1mwGoAdcEYBhEAHLRMM18T9vsQy2tDBwGLJqs7jhy6svKLXen5Hp3anTmM0tc4Ixd84/QFnPr/8OXDWgnqFgJiGPcqm2FjVQQt/pNfS29bDc1HzLqKAqPv+x3TsH8Zd3MgcpmUvfRASBPGMSAZEVvoDTcgDiPLAkYRPnqoeTYMHsfv/q6yo7BGwu0TSlQWzs4IzGaPTh55IcAY6Ka+G81BfYk/IY6B33b/wDHpx2QpFz5lEGs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea2cb09-3294-418a-2d06-08d80411639a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:41.1774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxKCKdx/mC1ts7HfHaFKbc1f9joV8H5QM+x+1J80nTYuEWq3Lk3KmFwl0l6Tg7OSOtBu6+KOWINEmkJYTsH9wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Currently a Linux system with the mlx5 NIC always crashes upon
hibernation - suspend/resume.

Add basic callbacks so the NIC could be suspended and resumed.

Fixes: 9603b61de1ee ("mlx5: Move pci device handling from mlx5_ib to mlx5_core")
Tested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c1618b818f3ab..17f818a540903 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1549,6 +1549,22 @@ static void shutdown(struct pci_dev *pdev)
 	mlx5_pci_disable_device(dev);
 }
 
+static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	mlx5_unload_one(dev, false);
+
+	return 0;
+}
+
+static int mlx5_resume(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	return mlx5_load_one(dev, false);
+}
+
 static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_CONNECTIB) },
 	{ PCI_VDEVICE(MELLANOX, 0x1012), MLX5_PCI_DEV_IS_VF},	/* Connect-IB VF */
@@ -1592,6 +1608,8 @@ static struct pci_driver mlx5_core_driver = {
 	.id_table       = mlx5_core_pci_table,
 	.probe          = init_one,
 	.remove         = remove_one,
+	.suspend        = mlx5_suspend,
+	.resume         = mlx5_resume,
 	.shutdown	= shutdown,
 	.err_handler	= &mlx5_err_handler,
 	.sriov_configure   = mlx5_core_sriov_configure,
-- 
2.26.2

