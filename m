Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A601E3503
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgE0Buf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:35 -0400
Received: from mail-eopbgr40067.outbound.protection.outlook.com ([40.107.4.67]:57088
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727041AbgE0Buc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QulEY3abnhPUQqkTF9P1hqM6aL+54lKMVMagD+LGQkANtAbBb3a4cVDT3FDU9FrCGXvx3Rm6zOcmxeI/df4Jt71iGVc1hon9GDUpYGMYhuRKxtHriDwOXVrC3nYu7Nm/30YilCoiO3b+mkKMhL5BIHyyBA7T4GLNdnOTfSoE+n4PncQ3BZ7Lzbk2iNIgHA/1jIagGJi7Yl0koZYZbtlgUs2odGh8W39N6OT8i0aZPACCCjqfsWo2zTzVr3etB8gRE8JSHPQNpyGiUIcJuMOoW3SIIxrodutniZhGR5Udant6TQY9zza4wV6Ci/xtrWIVgwP6Bd7Of5UVNU2RTuwr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLJ1iCFtwn3knA4anqZ1z5FSWhp2eN0mYPYoHR0TQaQ=;
 b=E/jOjfWTSOZ8tOcrFkg9v77WmKgUGIo0l6+PoTo7Hae2jaLuCxymxtrSKN79mK2h/+5kfMYxK4N6v+G4s4MuiL4WBPqHhzXRAmDXrKLAJFq9r1zVU0D9cnQD/5qN/KZuDAJtaMIpb0Z4TR49rXOX6pEV4m/JgBtyZ3ZEVl+0YQSQFI3jho+bxhBVJVU1zfDJc1yeS2yrMreD0KuOoNN0mZb2sUnQI3Ctfna8lxgJBALjz0z+YES89s7mvmYyvLshJwMc4uVlElYaNVAceucrTkDUfk1EetdDqnRnJTiVRtysVOn+FbrbidIi/fm7sznp2wDIbDlo76WE4x0RLSUylQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLJ1iCFtwn3knA4anqZ1z5FSWhp2eN0mYPYoHR0TQaQ=;
 b=Sv1BV73VZ7Bbmf7AwlJ7ccFCewWdLZxcC6Rz/oklX6Iki/JHAF0/k/RZcKDxs9024iuNb5u6bvXF+1b/x+I4p1xn52MjCeUzwUxBAkRWexjJf0ZiRCKbvizKN4hDbZCpaedjOoPNfKA5a2b+/WvKJoA/+SkVmeby7ZEH4pGncA0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4704.eurprd05.prod.outlook.com (2603:10a6:802:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 01:50:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Dexuan Cui <decui@microsoft.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/16] net/mlx5: Add basic suspend/resume support
Date:   Tue, 26 May 2020 18:49:20 -0700
Message-Id: <20200527014924.278327-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:19 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6af11899-7632-45e7-2e54-08d801e05095
X-MS-TrafficTypeDiagnostic: VI1PR05MB4704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4704DB34C628698D042460DCBEB10@VI1PR05MB4704.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:276;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPwH8IUoKIRKQcSp8YGn2NGiecy8rW9ubqsvRHaVp5nUpkqq5O2FP8X44m9+PO8fhx8LM7PaxmubI3BST44XWZdf1SKPXRaPRB3GnrKzPY76E+muhY7C71bvZ3uCEAGOv4hY5lg1WhvbSpGKNo0i/igWg3bl81PNW7tWq4m3LEH/RTo3HLkkOHojQSFx4Qv7nJDnj57mXwoCl94zeC1FhZLJ+OeRa8skq72rC2oQWNpR7RtdmqMCsx0b3hj/sHTcoj9oBl53VWJBbYOT9TxINUucUu+/42F3NFTIjZVOhK9nPM8U/Wz3GZfU0IMin8SEKgEDUdmG4pt1GGkBU5S8oYM5QH/UJXR+0jrBKOA12qcVScQ89rZqKTSL/WfgXN+T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39850400004)(376002)(346002)(8936002)(15650500001)(86362001)(5660300002)(83380400001)(6486002)(8676002)(6512007)(6506007)(26005)(66476007)(66946007)(956004)(6666004)(1076003)(2906002)(66556008)(2616005)(186003)(316002)(107886003)(54906003)(4326008)(16526019)(45080400002)(52116002)(478600001)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FanFLp3XFiMavyXZlVdHzrtx280tNiW7p+6GQCsuA8YVzoGz8sV/EywJT6A0s0K4XM+9GR4u8wROLyVoT6dYTk9+1+0kiluVf1SZVLU46wI6/LmI2i9GVejgun5kneApkfipCQkqjllCRfL7s5wZ0/iGDFDe80NQ5LphqUFqb2tOZjXRPgFKwzak5lsB9gew9KiPfFfrmYwQ/rAARGbUCbP2u/jRl8kqeGfMiQZqlWBB7f28qKnwMdSDn37fQGpy29qFHczFzVjBRbMs4X/48iu3SO1TfDsUkMZFUp3KgjuSSfwCPGPNXxl0fEQGWnTFdy9oB8NERTVrpldgJyawLgJ9h4zI1WLGzqyPMznor7hHEM9VQixzb7fQfizZXYMKWu9LbZeoq1Vgy74aYyXKPJsUzrbNXJrvX5SqxPk9sXynB/02OCbgzswtpIHp2cXqp/n6QrdBNTN0htoAsctkEVGeCVDpV/ckdMWPQnsgMs0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af11899-7632-45e7-2e54-08d801e05095
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:21.1909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXbuWn6qDacjPW+U651ioULbT3EXiV08jVY7ErxkgyZMd1gNE8OtIESbg/QyFMZwMPdWGySnHKnmIryaS8NbSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4704
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Add callbacks so the NIC could be suspended and resumed.

Tested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 30de3bf35c6d..408ee64aa33b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1539,6 +1539,22 @@ static void shutdown(struct pci_dev *pdev)
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
@@ -1582,6 +1598,8 @@ static struct pci_driver mlx5_core_driver = {
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

