Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7286736F3
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjASLdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjASLc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:32:56 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7689578547
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcfCGMbBWkozQ/8EqMk/cuz0M8gDnA8Up7AwAY2frVuV2MqMWC/DuBpr4IJclutN3GwzZNEsTaFtsgjbMlfMvBQ8V6HPPoPWwkuqCXM6tc2OPrbqu98F8cHztyUCKZxjZwNZiOzEDpD6B0gMwwJ0s0d+7qkVDsYKW+oRoDLtT3NjtYONYpJn1aTpRvQjdm2Wq7ZA0GVG7shQob2UUJROMZAELHQkF3DkhW1sMS+Fr1cZCw7hafqGpTQAESb0HaGioB/QlUGCV4kX5MTcNrLk4Wo+eRAW/HBF+56uGn8B/G04qdzW056HBd6blDy3zNJLCQ6DOvZylZ96a/Ahm+A86w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eaUBca5UOglHLEmhWXjR/0C3H8SMV0eOd3dEqTTgjQ0=;
 b=MC8luMKgAF4qSMeVh54FTIwJTWhsXxWVzyD27Tg12YxjbYTx0gpl2hktooKKTe4TWUc1mkW8TsJ+ufsbVwaafCJ9QKvSWfhXP4kSwISWANYVB/7JIGZStTRu/bevmK0tdfVQh89OYIteeQjkP2vktX5SsUgbcNlKeYJOeis6w8yQJIa9TRE6yt/C77md04bvTUyPup35YfoiRjQ16LJjl+Axso19Swo0uUnYLWCm+9KQzejcOE7DtudPwx9C55wJ5iPY8zUKKmxlLE4fSQTb7alc44/twdHcocZnhjaOP33DCaaRTcVQllF515E7266fxyaUw+79rxXstAw4PizBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaUBca5UOglHLEmhWXjR/0C3H8SMV0eOd3dEqTTgjQ0=;
 b=x9VFeu/f7YV44VT1ej3ZHAApXHNVTzNBUNB3nq9Uu84XL5wBc6C+fNIju1ayCUSPnFw50/+bj2Znya/If4IHkpfcq3Ty+u2bPb96/31qSOqzo4noBkFzvddeffOShv0JwtrdQr4PPv2TkyGjgcXhYOj/xTKoaJ8gx8nvFPojAEQ=
Received: from MW4PR03CA0302.namprd03.prod.outlook.com (2603:10b6:303:dd::7)
 by BL1PR12MB5802.namprd12.prod.outlook.com (2603:10b6:208:392::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 11:32:30 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::6b) by MW4PR03CA0302.outlook.office365.com
 (2603:10b6:303:dd::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 11:32:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 11:32:29 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:26 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:26 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 19 Jan 2023 05:32:25 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net-next 6/7] sfc: add support for port_function_hw_addr_get devlink in ef100
Date:   Thu, 19 Jan 2023 11:31:39 +0000
Message-ID: <20230119113140.20208-7-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|BL1PR12MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: 8389dd5f-cbdb-40b8-7346-08dafa10d952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /n74osZIOk96a5QKGEAoM9E+YkZqHWeGrqI2fguSGPoIqoeLpYJkVf/0Z4O375dym1cPo/zNLomV3lFYFD6XI+DCiKFCu7Jtl4Uy3qY1kzQb5BkIF1SwsLrKkrGcnpE63Qzjf3UgN8VoNzEO2w5YlFM3zu/PmL1Rg8miE3XVWJNHt+KhQybKbpsr+3fUsOTjwdR8V8PNbFqVRV93IhcJUwC/dFm+ToUYjV9QXt2oxAZS9zPK1rCGsrLWPAEW4aKjoNRjonxN5Y3En7L4YQN2ZMsyLzQQvQL3qlGS+wiJgOq1HuJJA6mPU17EqUh51AaslbujpPY9l4mU2ef12hMcJu5sa8pKFf90EVE69xo18K/UYWfm0JaZeoDTKBO268ZoIfRF9scqNAY54xGLZWBfE+tb8GeqNHUO8s7CZoo/QqU/nMsULKJKeA26YBEobnUSUJOzWiYhUelTSapc/m4MMb+E2VEbmPWMVqbz/snc/0OTZliEBiI2DW1/f2Va36X0Kdv5yZWdL5oSml2PG8rPqOWpp2ZQkKBIOCw9BuAPXF345fcsVu+wThKigOr4YhI112RtU1o/SWcsc3Y/EuHVN2URpmkgOJM6j1vVrh0Ild/paU6zc7a9X7K5/LgS1G3GoOAX8V+1vQgNCvMo65LT4Al32uYWYTzTmzNUbUjruVZ9LEmD7Sp67uJekNyig015SpF1DqvPMvo1tMb/CQszF+dsNOtBuV8WpNiVtEBRt8Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(82740400003)(82310400005)(81166007)(110136005)(36860700001)(40460700003)(86362001)(41300700001)(6636002)(70206006)(70586007)(4326008)(8676002)(316002)(2906002)(8936002)(426003)(478600001)(186003)(5660300002)(2616005)(1076003)(47076005)(336012)(26005)(2876002)(40480700001)(54906003)(356005)(6666004)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:32:29.7107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8389dd5f-cbdb-40b8-7346-08dafa10d952
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Using the builtin client handle id infrastructure, this patch adds
support for obtaining the mac address linked to mports in ef100. This
implies to execute an MCDI command for getting the data from the
firmware for each devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c   | 27 ++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
 drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
 drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
 drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
 5 files changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index f4e913593f2b..4400ce622228 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1121,6 +1121,33 @@ static int ef100_probe_main(struct efx_nic *efx)
 	return rc;
 }
 
+/* MCDI commands are related to the same device issuing them. This function
+ * allows to do an MCDI command on behalf of another device, mainly PFs setting
+ * things for VFs.
+ */
+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_HANDLE_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_HANDLE_IN_LEN);
+	u64 pciefn_flat = le64_to_cpu(pciefn.u64[0]);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, GET_CLIENT_HANDLE_IN_TYPE,
+		       MC_CMD_GET_CLIENT_HANDLE_IN_TYPE_FUNC);
+	MCDI_SET_QWORD(inbuf, GET_CLIENT_HANDLE_IN_FUNC,
+		       pciefn_flat);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_HANDLE, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	*id = MCDI_DWORD(outbuf, GET_CLIENT_HANDLE_OUT_HANDLE);
+	return 0;
+}
+
 int ef100_probe_netdev_pf(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index e59044072333..f1ed481c1260 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -94,4 +94,5 @@ int ef100_filter_table_probe(struct efx_nic *efx);
 
 int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
 			  int client_handle, bool empty_ok);
+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
 #endif	/* EFX_EF100_NIC_H */
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index ff0c8da61919..974c9ff901a0 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -362,6 +362,14 @@ bool ef100_mport_on_local_intf(struct efx_nic *efx,
 		     mport_desc->interface_idx == nic_data->local_mae_intf;
 }
 
+bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc)
+{
+	bool pcie_func;
+
+	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
+	return pcie_func && (mport_desc->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL);
+}
+
 void efx_ef100_init_reps(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 9cca41614982..74853ccbc937 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -75,4 +75,5 @@ void efx_ef100_fini_reps(struct efx_nic *efx);
 struct mae_mport_desc;
 bool ef100_mport_on_local_intf(struct efx_nic *efx,
 			       struct mae_mport_desc *mport_desc);
+bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index bb19d3ad7ffd..2a57c4f6d2b2 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -429,6 +429,49 @@ static int efx_devlink_add_port(struct efx_nic *efx,
 	return err;
 }
 
+static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
+				     int *hw_addr_len,
+				     struct netlink_ext_ack *extack)
+{
+	struct efx_devlink *devlink = devlink_priv(port->devlink);
+	struct mae_mport_desc *mport_desc;
+	efx_qword_t pciefn;
+	u32 client_id;
+	int rc = 0;
+
+	mport_desc = efx_mae_get_mport(devlink->efx, port->index);
+	if (!mport_desc)
+		return -EINVAL;
+
+	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc))
+		goto out;
+
+	if (ef100_mport_is_vf(mport_desc))
+		EFX_POPULATE_QWORD_3(pciefn,
+				     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
+				     PCIE_FUNCTION_VF, mport_desc->vf_idx,
+				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+	else
+		EFX_POPULATE_QWORD_3(pciefn,
+				     PCIE_FUNCTION_PF, mport_desc->pf_idx,
+				     PCIE_FUNCTION_VF, PCIE_FUNCTION_VF_NULL,
+				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+
+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
+	if (rc) {
+		netif_err(devlink->efx, drv, devlink->efx->net_dev,
+			  "Failed to get client ID for port index %u, rc %d\n",
+			  port->index, rc);
+		return rc;
+	}
+
+	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
+out:
+	*hw_addr_len = ETH_ALEN;
+
+	return rc;
+}
+
 static int efx_devlink_info_get(struct devlink *devlink,
 				struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
@@ -442,6 +485,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
 
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
 };
 
 static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
-- 
2.17.1

