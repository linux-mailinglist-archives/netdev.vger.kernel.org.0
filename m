Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B656C513B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjCVQvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCVQuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:50:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E9E5CC0D
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:50:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhXy4Sn8fugdC7Qt/MgFjB2vxdLbZGqGK7qsM3chcy5V7DCZbsJl9ZY9wV7+cpK9XCgRbVIc6g50QCW38jtGYcdVmE7jlM0dH44BP2PE/a9lX1tyC10NeNDVizGWDnqoSj4AxeJMsMBR2O7KYTS8zU6ID7RNbO6C85S6qLK3JXPSMj0RUUZ4gO6m06LrbPUY7ahkN34QrDXZjsCv6Kd+UT9UgH5V0ff3On+WXYLCNvDgwVkeUWFCNfn0gl8GOFnYACC3L93jmfyGBfeDETZxWyFc0rnsXap00K0Ed0I7m08uPD/9LF4tFc6Tc2vNJPxM0KkqKhEKje17g2ywVUEw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eO8PFFvuakwF8C470CB3Nd7QFW9NJeaGExrngIzPEMQ=;
 b=WXBjXbCDBAGtpdYe8Uc6fTOMItOLRpQlV1hs4D52piguP3ekXJPKLCWPvGX7aIPgznCyiYvtXU6/xAlnGH584X+AOJavUP9+dLc5Aj5GCZiGZgAySCymBns7ERdfh+WinJwOcLW4gvWETwh1k02YtR8rt6LfgWzOxSd9JOnX5cIo2Jqsl8zNgI4+hUIvEZv/UknB35g0IR5i/2AB54BXqojn5vo6Wsk9JYXkCO3cp8IbWvffyTTPItsosKrmTpVRAOaLpNIff2wFwkTNj7ShCe4uacBU6JF/cDe17qDFeJMgAtxB5LaUXFneXj8bngHVe0cJ5/6aFJr91DgMkg0w5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eO8PFFvuakwF8C470CB3Nd7QFW9NJeaGExrngIzPEMQ=;
 b=IcNl4TmmdaEeXoSGhRyiEGZZZGN0TBq1SXOqYTmTCresW7wI5fWqb8/xIlkbHXbLVs8KzdphR6nC7vw4dx0zdIUZxj+AZNUSIgEjiZREQbaNp/ekvNHbiFwM7GkMUUSrSMpSheZtTjUapFqCRvy8TpS9+1Trgss15AE6w/8iCK6v5jM/R/acSzhRNyAktI8inGrjIMVmVFRCHbm+2voftErAQYfRQ42krMWlpwRVq9N/me6DUvSNoVzKEqtusiKu2TYw5VEm1w1uHiW8oZ8FPyCHwHX+dBZKZsejj7gCxvcNyXGJb7iQrjhdBCNtcNidJp8Y7yDtqtGgKJFTHdmavg==
Received: from DS7PR07CA0010.namprd07.prod.outlook.com (2603:10b6:5:3af::29)
 by DM6PR12MB4531.namprd12.prod.outlook.com (2603:10b6:5:2a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:50:39 +0000
Received: from DS1PEPF0000B076.namprd05.prod.outlook.com
 (2603:10b6:5:3af:cafe::86) by DS7PR07CA0010.outlook.office365.com
 (2603:10b6:5:3af::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 16:50:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B076.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Wed, 22 Mar 2023 16:50:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 09:50:27 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 09:50:24 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: pci: Move software reset code to a separate function
Date:   Wed, 22 Mar 2023 17:49:34 +0100
Message-ID: <b3ca40f2076f96c10f9275ffdac318033f273a99.1679502371.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B076:EE_|DM6PR12MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: a3950157-c2b0-40b1-eaf7-08db2af59139
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: btDC6pnTGZb2Cg+xYCEB+MaDreGe7DIBy0zSeLCcOkCNL3J5dXaQx1LwQQkMXdq9Af7oCI+SpNbOetdCzG2riVmpm6mdK9IZI53KKqOwMmmKDQFpaTKbaLzr7ExkHKjpji2Epx6aVR1saluQvIbl1ZARvq8YkTOK0TH3k6CVgypbwZfE6G5Zx1Dk15WZT7V/4pnrpGyaYGWG2zZn0XexGXH5384hUSUOJzD06TlCBW/0RVQuViIVhtG1JPFgDIUoiLb6BOpj3A6A3zUavU1j9X83P/huWmaZayZOXz/ldYMpm5UZs3th1yJi2CUPB6z/DWinCQ+n1CbAyHumRscDzg4tIWJ6aZYYuQul2lJDVUp8XCC+8bvAi4u0hvRq5h++zyyQfATOzcv+e3pi0AbOyZq0EUx/Kz7BriWHYIf1Ra92XbtGYrAbAnt6EsMdPoSv8CjGb+sfxcsoQZxcFSiW8mGi+pUvIc/zmTkQ8E4anePPapNsu7za2hx8KE7Jya/pMjb0BEx8vgpje1oPwmrDPGjuLLKH6wZP5ZzMJ5IXcLkatf2e5B5OVZ6Dd5t9AXZSAcsffArQmeMJ6Ct/dZVFbfevOXecEgKTqFBVre/5ygGdY5R/wXjkV0omzVoSHSkpByLAkM2IVFHpmQY9Jp3z30+8zJcd/3v8J3tdAsq4VDI7LJXl3MJNO+bIdjxuNY53O5BNAPnaRD9B46izaIHutkUSqTQBNJPLamUzY7KCXVm9S16jn5XprV9zP2E1ZRPO
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(336012)(16526019)(26005)(426003)(107886003)(47076005)(6666004)(8676002)(316002)(70206006)(186003)(83380400001)(4326008)(2616005)(54906003)(110136005)(478600001)(70586007)(41300700001)(8936002)(5660300002)(2906002)(36860700001)(7636003)(82740400003)(356005)(86362001)(82310400005)(36756003)(40480700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:50:39.3340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3950157-c2b0-40b1-eaf7-08db2af59139
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B076.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4531
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

In general, the existing flow of software reset in the driver is:
1. Wait for system ready status.
2. Send MRSR command, to start the reset.
3. Wait for system ready status.

This flow will be extended once a new reset command is supported. As a
preparation, move step #2 to a separate function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index a2d3b2ae00ad..73ae2fdd94c4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1459,11 +1459,18 @@ static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
 	return -EBUSY;
 }
 
-static int
-mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
+static int mlxsw_pci_reset_sw(struct mlxsw_pci *mlxsw_pci)
 {
-	struct pci_dev *pdev = mlxsw_pci->pdev;
 	char mrsr_pl[MLXSW_REG_MRSR_LEN];
+
+	mlxsw_reg_mrsr_pack(mrsr_pl, MLXSW_REG_MRSR_COMMAND_SOFTWARE_RESET);
+	return mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
+}
+
+static int
+mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
+{
+	struct pci_dev *pdev = mlxsw_pci->pdev;
 	u32 sys_status;
 	int err;
 
@@ -1474,8 +1481,7 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 		return err;
 	}
 
-	mlxsw_reg_mrsr_pack(mrsr_pl, MLXSW_REG_MRSR_COMMAND_SOFTWARE_RESET);
-	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
+	err = mlxsw_pci_reset_sw(mlxsw_pci);
 	if (err)
 		return err;
 
-- 
2.39.0

