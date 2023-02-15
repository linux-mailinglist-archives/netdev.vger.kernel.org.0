Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823456978B8
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbjBOJKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjBOJJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:09:58 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C0C36FE2;
        Wed, 15 Feb 2023 01:09:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i05lx9inQws+AMYxu2Dqof4OLp4DWRbFZ/6HY2ZSJLOqxPXIZiVlGsI7GeAcNiY6yUc9hEfsA4rd0JYGvHZ0GRPUzxE9q556YJA4PV3/tuEAkGMHKp3TpEXpfdQ+mgN2+pFEkjNj5EnOpWfUe4oMKRXsNF94WrEaNqUOsSlt+ZPLCqIWMmcDBW9PNAbvbC6nd1N3e6VJ3j/6r1qOMhlMaKd712P2GVcGsxXhGy8A2mWjR6hK26Bc6m7dYMqpaCVDxRcoHZSR+OusgL4tDxLF6d7MeoKQFf2/dl5IU4H1Uc5486t/oUNWLWt41AIzthrnnTiWh/flAVqWWUPxs2h+sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsBRBbvsm8NTCcEOQmCoczt/6JoM3YP9Gtru7C/9aDw=;
 b=emxghK2XyB8pfM7XBZYALuT+verlFVxlsWhzwkGtwaDeMtFYYetqhtMbW543WZsQ4MJwaFhkfqps0FBoQciedZi00YYIpb3yv3IU/JJXCaiojBHrbnKAIZnOj7dy6Avna5vA2b2MtYuhiEQPJ8UKPtVI6TED5xmH29FLJe8h5Gera588bSlbt4VjQ/ZWvIMTX4KLUOQA80ay4FNYI4uNwj/1gDufTa+7joGjyJki5D1sOrDlnpuo4qWJYExJytwLOFQJH/uBPepGSzgzQaIMUVAeI5CFow4QepwSeqGwWbRghab7AnZ6xfuZgKBqQjcQBOZoqmyvznGgEwWdrx7d2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsBRBbvsm8NTCcEOQmCoczt/6JoM3YP9Gtru7C/9aDw=;
 b=3QvrB/rKHBLhHbcQdhKuVHW20fs+o6LfbHvj38yBGTUghjEgWDC/80nE7HW9vIElIxdiFKIv2TRsej9KzG6fBms/8GAx2qIR4mFaBsq++LLNIHPexx/DfYSNj/779RbgWBliQP2dBLA2tC1GetuvKhyzQhUO2jeF9EqU77Q2akI=
Received: from DM6PR02CA0059.namprd02.prod.outlook.com (2603:10b6:5:177::36)
 by PH0PR12MB7011.namprd12.prod.outlook.com (2603:10b6:510:21c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 15 Feb
 2023 09:09:41 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::5c) by DM6PR02CA0059.outlook.office365.com
 (2603:10b6:5:177::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 09:09:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.22 via Frontend Transport; Wed, 15 Feb 2023 09:09:40 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 03:09:37 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 01:09:30 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 15 Feb 2023 03:09:29 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v8 net-next 8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Wed, 15 Feb 2023 09:08:28 +0000
Message-ID: <20230215090828.11697-9-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
References: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|PH0PR12MB7011:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d202165-d590-4791-c207-08db0f345ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0dD1cnYr3olByhEiTG4fMHpR+q1gLBna5fWHgSQKuioq5nRHly4amK+/Mi9HRiey+wBDo2P95QjQbcxxiYU6AML8hfjpxu3Pz5GQvrvCJxqdC8qhIE1hpZZ8QQYcVKjCgMIYRoP+ijCIw6QMxZceEfD4sE7owtn4w2oFUKS33UF6yuHltmBZSWdfs2PGao60Ev+LjVyqoFjF+KuRG/HWp2qy8URJCR3/Tiiy/iabIEpN9jqeZxWv3elVCYQ1f0FW+mYMvcl1w+mnARKJoagf7uClQmtOMzmPo9+W6EmXajwltEI+kqO48HFGoM9uKM2lVZ2jW0Lszw35GDE7l5VmKYKrqQFY18R821hV+Tx5AZ9gdfNwYQ5+SNXYoEJ73f3zrRszCTs+a7YFnwZupb4t/+zLm6j7NVljld1LE7+DcziO3J5z+gteEkaEl/zGGXen1Ww7goMWFYBLMo2Oi1dCETzEDhLLgeSaby6J4xayIYCBv9U5U9Nr9PIkct4X0SBlT5Ka3Zr6Dji29w6EJWrASl1Aek2Js51kQdci0ZE6xwhhMQDOfgBp4j+rWZMvYNN/3QkW3X18Og/yVNyFwSlBvM7lW1n0Pcwxp0Y+I2yPzXKjqrLr8Vj+sTLzqcIvtgItKlKkHzmL+gQK8kDU2dMgazDTsXrGTjubT/88NtwBbzGFO9nt1egC+aHTb0IU939guf/DZzIHATGzK9ExHfCQijMdm3PnOUfPoZsoZpjnlU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199018)(36840700001)(40470700004)(46966006)(356005)(81166007)(36756003)(40460700003)(47076005)(426003)(40480700001)(4326008)(86362001)(41300700001)(70586007)(2906002)(8676002)(70206006)(36860700001)(2876002)(2616005)(1076003)(82740400003)(316002)(54906003)(110136005)(7416002)(6636002)(478600001)(8936002)(336012)(82310400005)(26005)(5660300002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 09:09:40.2560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d202165-d590-4791-c207-08db0f345ea2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7011
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Using the builtin client handle id infrastructure, add support for
setting the mac address linked to mports in ef100. This implies to
execute an MCDI command for giving the address to the firmware for
the specific devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 50 ++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 0af25dca7b53..d2eb6712ba35 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -109,6 +109,55 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
 	return rc;
 }
 
+static int efx_devlink_port_addr_set(struct devlink_port *port,
+				     const u8 *hw_addr, int hw_addr_len,
+				     struct netlink_ext_ack *extack)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_CLIENT_MAC_ADDRESSES_IN_LEN(1));
+	struct efx_devlink *devlink = devlink_priv(port->devlink);
+	struct mae_mport_desc *mport_desc;
+	efx_qword_t pciefn;
+	u32 client_id;
+	int rc;
+
+	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
+
+	if (!ef100_mport_is_vf(mport_desc)) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "port mac change not allowed (mport: %u)",
+				   mport_desc->mport_id);
+		return -EPERM;
+	}
+
+	EFX_POPULATE_QWORD_3(pciefn,
+			     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
+			     PCIE_FUNCTION_VF, mport_desc->vf_idx,
+			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+
+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
+	if (rc) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "No internal client_ID for port (mport: %u)",
+				   mport_desc->mport_id);
+		return rc;
+	}
+
+	MCDI_SET_DWORD(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_CLIENT_HANDLE,
+		       client_id);
+
+	ether_addr_copy(MCDI_PTR(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_MAC_ADDRS),
+			hw_addr);
+
+	rc = efx_mcdi_rpc(devlink->efx, MC_CMD_SET_CLIENT_MAC_ADDRESSES, inbuf,
+			  sizeof(inbuf), NULL, 0, NULL);
+	if (rc)
+		NL_SET_ERR_MSG_FMT(extack,
+				   "sfc MC_CMD_SET_CLIENT_MAC_ADDRESSES mcdi error (mport: %u)",
+				   mport_desc->mport_id);
+
+	return rc;
+}
+
 #endif
 
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
@@ -567,6 +616,7 @@ static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 #ifdef CONFIG_SFC_SRIOV
 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
 #endif
 };
 
-- 
2.17.1

