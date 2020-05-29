Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340961E763D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgE2G5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:57:23 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:44867
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgE2G5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 02:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yi/OQLgtLDlCcAx0l5/aCMOHT0ip8wc3KfNB/A9Xz0wuZ33ZP/4h2tflIguHhjTGVoMWEKWU4NuSQ23GHYHW6DSrO1BJJ4eL2w6fVQZfRbUcsL46Ba9YKZzaA1quZj43FoBQhIRLV7+CNBToWX6gjTpyV8J+duoz50KBN4a9GIKVCjIo+vk1BR3brggPDAyPm+UQYiN9P7RLu5A4/Hzmn7NOzh7hwMQIBKSTPfiE/GtHSyKJHOgtcVXyUKj6o8B4M5DKNRCoCfy3ogxmRMQj/H637mDlK49f5WXBEjiRpDmoiYM6d5pXCJgCoKIUjFqXAuez0C42U948MT64ZzG2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+BrsDz9hr1TCdq7J2jSPh9lErbDMzKJlkwI7D2s2c=;
 b=fEhXE4lfWD7xVqR2rFpiFcLXXvlOeG7HrOvsleVff5hxpq+F+mARk1DNr/AADsp8Bi6cXBd+63AewBavJvbKRP/OwwbgKGT1SeH3wxaJgpgxRNcTfhC2f6BQKDuQsb27ETfvK5m6kGqXy/GsUKfeo6YBsJ31hlOK0qC0EM+CSn8/u3UyOeT7stTLIkkYmHlUCFq5iF0fjMO5LZfXthzZOFQolpNBkoIW7avLkSB9TCOm+bxdZlCNQ7tOVkqEhsbHNNfdz8DCZEUNxHJ36psrjVaDRIk0L0uL2+SrmNW7m89tmtcuPfVLcCeCc8zD69azylIoN2Q9mvlgbg+eKC8/Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx+BrsDz9hr1TCdq7J2jSPh9lErbDMzKJlkwI7D2s2c=;
 b=DSxLwQK4V/OaHlqdQTEFp2r1wN/EMDVVhjkzQhIlSuAuk+z1b4Mcz08siKB2d9L0dlpEOSF9PoI+ansT7F+86m2cfmPb8obUh/QRuD52Wmjch6nPZh7NmXm2XuRDdJDM5rQvP9Wj/YsJPFoVqoo17gKXEk3Mk8acPp5wQzHi6/4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6640.eurprd05.prod.outlook.com (2603:10a6:800:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 06:57:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:57:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, jakub@kernel.org
Cc:     netdev@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Dexuan Cui <decui@microsoft.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/6] net/mlx5: Fix crash upon suspend/resume
Date:   Thu, 28 May 2020 23:56:40 -0700
Message-Id: <20200529065645.118386-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529065645.118386-1-saeedm@mellanox.com>
References: <20200529065645.118386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 06:57:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fac067db-52d4-4292-727e-08d8039d85c9
X-MS-TrafficTypeDiagnostic: VI1PR05MB6640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB664047FF01DF76B988E92855BE8F0@VI1PR05MB6640.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OI6BSg0coVslRpnBKAgcOfsq8AbZNX86GxZAwc4xJNFIC2gLFu0NiFo9WzZVbD8inpNyeXXl+SVMvaYHOt/X5yrrhUzDOU0jyykDMjUtCviRD73Q8uqy7JSp9gOc/NLLfp+BdNZyo7nwOhYwNr77JF6fF3Rgm4PWrpFFT2yJoJNRUpzuoX1iFe+Cc6Vk+yQIOwA/Vc+DB/z+YRO1Xr7SkwYkNquJ9VL+3kwnZb/BYewx3lNq9qYECNSBY6ygxaWdh/SAZAGEXSUrl1sVxqFKP74Sitqi2wCXPWLO1sMtUw9AykNj6vyME7titLtIuqjhugaImbYboqTUf++4KSBoO8DUKA6ja26a2lqwVFaBADZFLplf47XVacqmYkf0H+nM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(83380400001)(15650500001)(107886003)(2906002)(5660300002)(6486002)(6512007)(86362001)(66946007)(4326008)(1076003)(66556008)(66476007)(6666004)(54906003)(52116002)(8676002)(36756003)(316002)(45080400002)(8936002)(956004)(2616005)(186003)(478600001)(16526019)(6506007)(26005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z7CyOzW5JpVewAfk4VihsEp9FXs0rHbs7Cci/+MVkGQYrP9+Fb6W9iPEiVtM4KC7fCvbRLkLHJe+wNoRASyl94OVfexbRBo8ZXlz3YqFx6sy0EMHer3y5wbAX27Qh8iQmimHoKeu9B/BDEnljxoh+OjQE6FLhwM3ToBbV88UrXahL/xW0gZjCdfD8gdcmiesyrdiklUcFfRRtZmepZ7B4MzOxW3raMDfeKWAqYwQy/Ma7M1oacFMbTqD3rTalYcAklYzIl5vnD9mMDvdmGuOeR4OP/JDcFx5XeiE5l6jbC7GHDT+zPuQMVkT+B2T0NFSs9WwGSwovLZC/dwbMuff71EOxA3kWFLTMiJLLIKZpConPB6IWS1DaOzpbkFSzZ/syMkmoxXaO/9JJ496F6kXofdAqSr3VDuMAvc9mkvGImMb1tn2ZuXarWm2zByHxjYOGvbdYKwrfGw6ecJHRRbb6xWAfpyLy8LCZLTgQxW0M+Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac067db-52d4-4292-727e-08d8039d85c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:57:16.3994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euc77adg3XYlTrrdgmVi8BG93uCpLe71t+1JSKCeO2RyKUpJhaBOz0668CQnuZkEWwrjcJ1UAFVWsGVHCPOSZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6640
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

