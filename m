Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAA6C513C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjCVQvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCVQuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:50:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C64521EF
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:50:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGzyQk//uqXDbjMuO6pfmKTarq6F2wkvPBgpGYFsbQkkOy1zJRkfD/PYBnNupYQl7cGigW7xx+XcDkLiQ5kn8dooClBwUP4zXPJvlO7LII8WiPkdS+/0DBFFdKQ5LaN/jgPzkDH75qjtbFLFjdN0HPTbaTPOTTuSqcrm6xnSu8OrVFmQFN0s/FqnU70Rx2RadWWVWffbiQFe6i5NOkbgeRa/OlcRH61JN8in13zX9tRuQdrtP5LAGVLFigk8hr7JSxLjQ+iptwdIO6V/ZiR9yCIi0/N2RpBXWGOi3AAIijaZ+J4shhK/Y+ADQ2ZQIj+/loiNoIjIbmEB/5EuMmXDRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qr7/QCrfX99Zr7/6xJZ96YEwd6FI4sO7wcfxqrv2PDw=;
 b=UF9xU6XUREqehc6ghXTBY76cgaLa00U852Wdwm1QBqb2iJKoSXWNgqfbZbF7aQgSG7zB5pg0XThwebUVi9sBnYQPjNFXmpPZw8BRLVvrYXpW+3BtMSELKFjqheFYe27eeVHqESajTtyZNs2ZXwxLsmZTtdJFfCTs61PN8aODy0MYlMqKsHxKkfx2locec03QyQTmW9EyuQfexi01iT9Hlye3mQOkZ9lYmTQ7XhmbjApzxJWvR4iOkAUM6BP5F0CsVsuN+KSgXUMqpsDSsgNS7ZqI5C6dijzs6GPGJXQDU1/vtZ3IyIO9IEiDkKwIrLAa6OcOkqMbNdQ/I9WR3WohrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qr7/QCrfX99Zr7/6xJZ96YEwd6FI4sO7wcfxqrv2PDw=;
 b=mzBqGmBvZ5kiRl444yVIz7DDkqe8fPoNLQJ57u68mDcR/blUkGAXL4BSk0noODTC6AM3+Hodgmc3+YJM/ICPsh4BrgnJc+b3K1sCwYi7OHBmqolbFOxsFIBmLrEsAk3ybir2T5qehXKW4fQWOmoZyhNX6qgOSVJJEn20ndLE79J6LVANckIkvYb72dh4YFABIRA4vlXEec2JCNS+C4AFAB5aavgE7EhVZsdbXVBYunqQTrZGtAiUyG5isaSDkMZJijRe80jYO+nw1zHibTU3pGEfaPi7037Htc4iFGSSripr50K0GrWuqqNrpYtTK9wNYMdcD0Rk8LvhOi4rklGGpA==
Received: from CY5PR22CA0080.namprd22.prod.outlook.com (2603:10b6:930:80::19)
 by SA3PR12MB7902.namprd12.prod.outlook.com (2603:10b6:806:305::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:50:42 +0000
Received: from CY4PEPF0000B8E9.namprd05.prod.outlook.com
 (2603:10b6:930:80:cafe::80) by CY5PR22CA0080.outlook.office365.com
 (2603:10b6:930:80::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 16:50:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8E9.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.2 via Frontend Transport; Wed, 22 Mar 2023 16:50:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 09:50:29 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 09:50:27 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Date:   Wed, 22 Mar 2023 17:49:35 +0100
Message-ID: <c61d07469ecf5d3053442e24d4d050405f466b76.1679502371.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E9:EE_|SA3PR12MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: 32ee9104-a7f1-472e-f156-08db2af59298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5DGyQC6itfHeCCWUbZ7/SH9qGzGqkjqE2YqK30t0iJzJ2Mln3pmXpiTL4WQS/3mlbUyegvrcOWqzZmUynvdy5G16oS6d2s5yYFQXSD/L2sNW4ugLh8Q1ixOZK4IHozNvi/T8cYSn4jLYduuZcRixXKx+CLmabbC/ShhHd/N2IPIln5OStZHNUbjSYZJNTAvByt+P6+Txbpcmve2MIyAjY4DMEmpXArvoi+/HYY4ouJmlFJB28xHYPcHwxi7SdlABrHi3OocOXV+Hytz4gQL/OtCs/fe1gjrUwVpq6KFWiwMp7ygfSn7W8w/WvTH0PagKYtm7NvEmfpUiFN35oceUndj0HtmfehQy4hNo0zcljnVw+J2tniVPUnE+bU8mg98zCd5T5yCPPxmgQ8KrEhT0bvRfaSFZnKftZWPJ5I5lVGFRfjv56jehhlrOKpgT9ayiUpJozengEraURKM/tRLQ+uJeSdm9OIdR7bdwzXfnaB7bq91WryZ5uJx6WUgGy9JsEBFsOOXZWEQd9IHv3L4YEYoP5MdNghSBTA7a99YzLrnKR6OzUcwZ8A+yrgSFa9Hnls8/AKKusvDAnM7V48gl2VyA50cqbExUd+X9XN+O14TXQaK0HVIJ/zs4nvTq6n+wWxOvVXYj/PXN7Fcu61JimzY2KgN7UGRlxt2uBsWtKPVJZ0Lt+FZ+k1W8x6ylffi2EC3hLigcjqWQR1V38juQWrK+KXENQvKJBJvY1jo+dtS17ATgAY/4nQFvZk9HqWH
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(426003)(47076005)(36860700001)(336012)(41300700001)(82740400003)(83380400001)(45080400002)(186003)(478600001)(7636003)(107886003)(6666004)(4326008)(5660300002)(8676002)(2906002)(110136005)(8936002)(54906003)(316002)(70206006)(356005)(2616005)(70586007)(86362001)(26005)(40480700001)(36756003)(82310400005)(16526019)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:50:41.6814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ee9104-a7f1-472e-f156-08db2af59298
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7902
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

The driver resets the device during probe and during a devlink reload.
The current reset method reloads the current firmware version or a pending
one, if one was previously flashed using devlink. However, the reset does
not take down the PCI link, preventing the PCI firmware from being
upgraded, unless the system is rebooted.

To solve this problem, a new reset command (6) was implemented in the
firmware. Unlike the current command (1), after issuing the new command
the device will not start the reset immediately, but only after the PCI
link was disabled. The driver is expected to wait for 500ms before
re-enabling the link to give the firmware enough time to start the reset.

Implement the new reset method and use it only after verifying it is
supported by the current firmware version by querying the Management
Capabilities Mask (MCAM) register. Consider the PCI firmware to be
operational either after waiting for a predefined time of 2000ms or after
reading an active link status when "Data Link Layer Link Active Reporting"
is supported. For good measures, make sure the device ID can be read from
the configuration space of the device.

Once the PCI firmware is operational, go back to the regular reset flow
and wait for the entire device to become ready. That is, repeatedly read
the "system_status" register from the BAR until a value of "FW_READY"
(0x5E) appears.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c    | 151 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h |   5 +
 2 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 73ae2fdd94c4..9b11c5280424 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1459,6 +1459,137 @@ static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
 	return -EBUSY;
 }
 
+static int mlxsw_pci_link_active_wait(struct pci_dev *pdev)
+{
+	unsigned long end;
+	u16 lnksta;
+	int err;
+
+	end = jiffies + msecs_to_jiffies(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
+	do {
+		msleep(MLXSW_PCI_TOGGLE_WAIT_MSECS);
+		err = pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
+		if (err)
+			return pcibios_err_to_errno(err);
+
+		if (lnksta & PCI_EXP_LNKSTA_DLLLA)
+			return 0;
+	} while (time_before(jiffies, end));
+
+	pci_err(pdev, "PCI link not ready (0x%04x) after %d ms\n", lnksta,
+		MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
+
+	return -ETIMEDOUT;
+}
+
+static int mlxsw_pci_link_active_check(struct pci_dev *pdev)
+{
+	u32 lnkcap;
+	int err;
+
+	err = pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &lnkcap);
+	if (err)
+		goto out;
+
+	if (lnkcap & PCI_EXP_LNKCAP_DLLLARC)
+		return mlxsw_pci_link_active_wait(pdev);
+
+	/* In case the device does not support "Data Link Layer Link Active
+	 * Reporting", simply wait for a predefined time for the device to
+	 * become active.
+	 */
+	pci_dbg(pdev, "No PCI link reporting capability (0x%08x)\n", lnkcap);
+
+out:
+	/* Sleep before handling the rest of the flow and accessing to PCI. */
+	msleep(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
+	return pcibios_err_to_errno(err);
+}
+
+static int mlxsw_pci_link_toggle(struct pci_dev *pdev)
+{
+	int err;
+
+	/* Disable the link. */
+	err = pcie_capability_set_word(pdev, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_LD);
+	if (err)
+		return pcibios_err_to_errno(err);
+
+	/* Sleep to give firmware enough time to start the reset. */
+	msleep(MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS);
+
+	/* Enable the link. */
+	err = pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
+					 PCI_EXP_LNKCTL_LD);
+	if (err)
+		return pcibios_err_to_errno(err);
+
+	/* Wait for link active. */
+	return mlxsw_pci_link_active_check(pdev);
+}
+
+static int mlxsw_pci_device_id_read(struct pci_dev *pdev, u16 exp_dev_id)
+{
+	unsigned long end;
+	u16 dev_id;
+	int err;
+
+	end = jiffies + msecs_to_jiffies(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
+	do {
+		msleep(MLXSW_PCI_TOGGLE_WAIT_MSECS);
+
+		/* Expect to get the correct PCI device ID as first indication
+		 * that the ASIC is available.
+		 */
+		err = pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
+		if (err)
+			return pcibios_err_to_errno(err);
+
+		if (dev_id == exp_dev_id)
+			return 0;
+	} while (time_before(jiffies, end));
+
+	pci_err(pdev, "PCI device ID is not as expected after %d ms\n",
+		MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
+
+	return -ETIMEDOUT;
+}
+
+static int mlxsw_pci_reset_at_pci_disable(struct mlxsw_pci *mlxsw_pci)
+{
+	struct pci_bus *bridge_bus = mlxsw_pci->pdev->bus;
+	struct pci_dev *bridge_pdev = bridge_bus->self;
+	struct pci_dev *pdev = mlxsw_pci->pdev;
+	char mrsr_pl[MLXSW_REG_MRSR_LEN];
+	u16 dev_id = pdev->device;
+	int err;
+
+	mlxsw_reg_mrsr_pack(mrsr_pl,
+			    MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE);
+	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
+	if (err)
+		return err;
+
+	/* Save the PCI configuration space so that we will be able to restore
+	 * it after the firmware was reset.
+	 */
+	pci_save_state(pdev);
+	pci_cfg_access_lock(pdev);
+
+	err = mlxsw_pci_link_toggle(bridge_pdev);
+	if (err) {
+		pci_err(bridge_pdev, "Failed to toggle PCI link\n");
+		goto restore;
+	}
+
+	err = mlxsw_pci_device_id_read(pdev, dev_id);
+
+restore:
+	pci_cfg_access_unlock(pdev);
+	pci_restore_state(pdev);
+	return err;
+}
+
 static int mlxsw_pci_reset_sw(struct mlxsw_pci *mlxsw_pci)
 {
 	char mrsr_pl[MLXSW_REG_MRSR_LEN];
@@ -1471,6 +1602,8 @@ static int
 mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
+	char mcam_pl[MLXSW_REG_MCAM_LEN];
+	bool pci_reset_supported;
 	u32 sys_status;
 	int err;
 
@@ -1481,7 +1614,23 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 		return err;
 	}
 
-	err = mlxsw_pci_reset_sw(mlxsw_pci);
+	mlxsw_reg_mcam_pack(mcam_pl,
+			    MLXSW_REG_MCAM_FEATURE_GROUP_ENHANCED_FEATURES);
+	err = mlxsw_reg_query(mlxsw_pci->core, MLXSW_REG(mcam), mcam_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mcam_unpack(mcam_pl, MLXSW_REG_MCAM_PCI_RESET,
+			      &pci_reset_supported);
+
+	if (pci_reset_supported) {
+		pci_dbg(pdev, "Starting PCI reset flow\n");
+		err = mlxsw_pci_reset_at_pci_disable(mlxsw_pci);
+	} else {
+		pci_dbg(pdev, "Starting software reset flow\n");
+		err = mlxsw_pci_reset_sw(mlxsw_pci);
+	}
+
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 48dbfea0a2a1..ded0828d7f1f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -27,6 +27,11 @@
 
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
 #define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
+
+#define MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS	500
+#define MLXSW_PCI_TOGGLE_WAIT_MSECS		20
+#define MLXSW_PCI_TOGGLE_TIMEOUT_MSECS		2000
+
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
 #define MLXSW_PCI_FW_READY_MAGIC		0x5E
-- 
2.39.0

