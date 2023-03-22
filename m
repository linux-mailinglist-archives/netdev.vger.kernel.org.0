Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505A26C513A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjCVQvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjCVQuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:50:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5EF5D46B
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:50:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRsJO1nKYcbIUha1D00a/mYvEzxeALxkQ1wwuIVZH1AFC3dO6o5tFUg36KKxYEuc45Oe16uk6kTfOwEs7+L8iU5WMQUNWFcI3QB7/DxVo55ehbMY3r1Ryy6aSHNQhib5zA5LBqFtHGMzXPK6nUAhHhqUe7krPTc/JmvUXnP1boj3pnK50rT5IN6TyRfOS0kM82BAvd9gA3Y4r6NtlrOdIFoaiLG5dclbCXep/tOXo+jdQcmR9XVSqLbfImjicA1sl2KMu/os8M9wZ+IJ2o+X6VA0FmSImkrRWLXlc7Dn3kyvd2cHc6FWa06JsO0sGBa1xR8hB4NXb+tdZGZcJ6z0EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDlTXJ8LraZF9TZoQQdmFQquQrDTHXH6LAh0r1ilwYI=;
 b=OXjT1qVqTtA6gwnW8uEGKCWPU36WHEJyh943p2S4hiACCr8SLoypBUHydmDTgO7gP2p7DcgxlavAlOs2nJSKKy+rJLKUYlx8AfTnxid58Q04weu3IvZL30Xm5OXKEDim+2fWi4GAAGLhoGDgOERnEKZIi7HW9QzmaupA2HLlSwT3PQ3veW4PPo1wMitpXZTzxjnmLdOW3mkpVhH+2H0exkdGMMAjH8xh8f+K4ZZtYyrgmJNeojdKh4MN3+IlIzFV2Tke32LJZX6Oj2b17uAEu1kXC/75zLsU2L0preHot5kADvv7fa0hSd+x17bEFYYkhrT5Wy+tnddlwp2HPGQ5Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDlTXJ8LraZF9TZoQQdmFQquQrDTHXH6LAh0r1ilwYI=;
 b=BefS/MkZieyE/V0pwwDFfS2ReI/Gy9DLzkULOFIlLlhqaBbuS6fL3WlmjO34dsdfoXLJNhFL48MLIWY6z3N+pHzaTpTYhPsRBjMfOAU5SM28No0gAahg1EDn3j6yzxb8URzv5FAdfSL5qoksR4Oq+W815Bv9d0OFlQptFhxo/DnMvoD6EthtdnJX4vQKOSxj08iGtPN+zb6SyhGj0vcIcW0/1tKk2V4nkhYf3n/2zeuuJuXMVX7C8AkFWmYfa+0nIT4ESnBIt87f13Bfu8dhF/1mEuMTn58XX8m+V/CMsFohoOhDxf3p7V0vuQ+MEwoFKVx1sUF9LBIdC6l+o/jJgQ==
Received: from DS7PR03CA0294.namprd03.prod.outlook.com (2603:10b6:5:3ad::29)
 by DS0PR12MB6656.namprd12.prod.outlook.com (2603:10b6:8:d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:50:38 +0000
Received: from DS1PEPF0000B075.namprd05.prod.outlook.com
 (2603:10b6:5:3ad:cafe::d8) by DS7PR03CA0294.outlook.office365.com
 (2603:10b6:5:3ad::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 16:50:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B075.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Wed, 22 Mar 2023 16:50:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 09:50:24 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 09:50:22 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: pci: Rename mlxsw_pci_sw_reset()
Date:   Wed, 22 Mar 2023 17:49:33 +0100
Message-ID: <7e957b01082f6251c2554f4299150e1821a5976e.1679502371.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679502371.git.petrm@nvidia.com>
References: <cover.1679502371.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B075:EE_|DS0PR12MB6656:EE_
X-MS-Office365-Filtering-Correlation-Id: c22a5ab8-c361-45b5-14c4-08db2af58fe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGduGj8epzr5ecHvahW/1YJQ6CEFon+mEJtf3ZA3TpmHvMJVWxAj9+LxLzlf6h3ssqeHQj2wAICIsI8vEIUKJIkGrRlG4oDoEzYNH1SssTvtfuOfbAw030+crAZ5V4ElKQlkjy2XXlJsLp81FEiRhHzAp0ZpWNx1RCi3MD+l3KSdxcodzhlPpLy049E9snNgz0Shvgo3hrpbyr1T7zj0JaD2816XZZHPhd7Qu9BVVos16eXeLilWpksmrEq2UplYIpIRkM6UpYbH6AvMH25hw+HGavtTxrf2fSJsapP8KHP9UfLZA6pkt/Ts9LIVL4+M5Xf1o0hZfbij1+Qewo7WxmvgBwBMtXIyNdpYHMlp6C19UbOJNI5shcqWzXAjyf55RmhUMJcIH3UZij7KKtBnHKkjezla4PA2AyxW7E8Y913qybnO3crw2Xygw8ooM3lZxegSrNADzcEuxzJ6J/y5XuELxE0yPq5Kww+g4xUxtPi8p5SXNnLfL+h6S6eM2lVqEr08+RYJ8kZzPeafXf9zv/ygEufBOKkgpjwHOk/M261KCk6HG/CxGPhXQbQROHR7iEt9QMkgmZLL+2F2xRJ67kenB+owTEb75nsQ956uSdZ07R2IZuW2hJ81o0WbEmCeJFuSHt1m3MbSbG52qCnV8ExLWZlAfLVLuczRFe13niEPXxAL6TQBmCCpEHpJ7fFtzIKkVOciHCFqi5qpz6IrlPOQKYRBzerNtngQopqKoEWzUbgx7OGSdu2QEgcbCMfR
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(8936002)(41300700001)(70586007)(5660300002)(478600001)(8676002)(70206006)(54906003)(40460700003)(36756003)(86362001)(4326008)(110136005)(47076005)(186003)(6666004)(2616005)(7636003)(16526019)(40480700001)(82740400003)(336012)(82310400005)(107886003)(316002)(26005)(2906002)(426003)(83380400001)(36860700001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:50:37.1135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c22a5ab8-c361-45b5-14c4-08db2af58fe7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B075.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6656
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In the next patches, mlxsw_pci_sw_reset() will be extended to support
more reset types and will not necessarily issue a software reset. Rename
the function to reflect that.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 3c6d5f37c743..a2d3b2ae00ad 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1459,8 +1459,8 @@ static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
 	return -EBUSY;
 }
 
-static int mlxsw_pci_sw_reset(struct mlxsw_pci *mlxsw_pci,
-			      const struct pci_device_id *id)
+static int
+mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	char mrsr_pl[MLXSW_REG_MRSR_LEN];
@@ -1520,9 +1520,9 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	if (!mbox)
 		return -ENOMEM;
 
-	err = mlxsw_pci_sw_reset(mlxsw_pci, mlxsw_pci->id);
+	err = mlxsw_pci_reset(mlxsw_pci, mlxsw_pci->id);
 	if (err)
-		goto err_sw_reset;
+		goto err_reset;
 
 	err = mlxsw_pci_alloc_irq_vectors(mlxsw_pci);
 	if (err < 0) {
@@ -1654,7 +1654,7 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 err_query_fw:
 	mlxsw_pci_free_irq_vectors(mlxsw_pci);
 err_alloc_irq:
-err_sw_reset:
+err_reset:
 mbox_put:
 	mlxsw_cmd_mbox_free(mbox);
 	return err;
-- 
2.39.0

