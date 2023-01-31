Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA4A68300D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjAaO7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjAaO7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:59:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA60C526F;
        Tue, 31 Jan 2023 06:59:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djdhv1tO/BX0AT/RSHu5wdZ/EtlrlNHpt++aFp8Tzhh4pW2ohA2wJCu2tbbPek/S8omprcm+Iu3UcSHA1ehG2vpPtEPj2PQ1dzTb7mtMeMcLyhDPzqbbIOPVQoZiLUCmTequsV3+VkjWSgbu/F71mz/XF+N8s2NMyUQnw6v1cL5MldV2AdQ5umYHW0n0IVOIM5SkFagPZ4ZUOclFURtwBmiECPeipz6YVFkCKeVWj0NORBuW560KphXsRiCHRqOZ2k3I5pcFnOHrXPfAEsMT5FPb1oMqM96ln41VHw2kFLII4/xPnEwYOn5AxBudB4wOKpo+Z3OLom1efvWIWSatWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJZ9CdJPwpfEsAg4eN3qSEH+8FiBnklNOpbPHSapSbE=;
 b=gqq+dBfY5+wg8d96fH0cD1m3R/AXSdSOLaKM1h+/QWvaNJ6cgfL8+mWPGNO+Q+DggLA0DdYhdlu91UuSg6WhblPVPasbTP/3zm/1QaGDeu31fUL8fqqKiQgSX0pF7QDHY9SLXjEH5UDAb8hscDF6wFsCj4Qtui0g+vod2HzAFeJtx4B9SmxwWJLa0447qbOzPNv7Qqi0e//USrLy6VBEs9cLJuGKUPsH8Gv9gItdvtGuBT6leIdzJZOUJIk51F5rwDCHrvgEq3RJKRf5NOdYyT39RYedG2fQh6DO5RwiCMEleSBu6UsvVDl3idZMatjaeO+UsDGBsQ/9OmROfiib6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJZ9CdJPwpfEsAg4eN3qSEH+8FiBnklNOpbPHSapSbE=;
 b=VchuWbse+IDpht4JALgv1LK8kNqbZORwqdAa2kx6hNLvGu7GLMtdqFdw5xaLoy6dw5roAODGLmRNk9+y4WS9Hkt3zkDZbpYpE8YPgOwwKCmmZSls8znSnwcw7ipXunbqGDcPpbXBZEpxLwqvcOptf1t0EoLCmize3ssgF70+3Ac=
Received: from BN7PR06CA0057.namprd06.prod.outlook.com (2603:10b6:408:34::34)
 by CY5PR12MB6405.namprd12.prod.outlook.com (2603:10b6:930:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 14:58:58 +0000
Received: from BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::3b) by BN7PR06CA0057.outlook.office365.com
 (2603:10b6:408:34::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 14:58:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT081.mail.protection.outlook.com (10.13.177.233) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.22 via Frontend Transport; Tue, 31 Jan 2023 14:58:58 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:53 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 31 Jan 2023 08:58:52 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next 8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Tue, 31 Jan 2023 14:58:22 +0000
Message-ID: <20230131145822.36208-9-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT081:EE_|CY5PR12MB6405:EE_
X-MS-Office365-Filtering-Correlation-Id: ccf85879-d21a-4ddb-5583-08db039bae73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHDxfD6Da0vJo4p6OwhwUsby2DdhsS82F/Vi9O4fGIEkIKURJQKVsQHAT0nhibTFJ6fcn/MhTMH0QR9xwTu/aSuLnSTesVja7WTZvPkL9e6XPreW83BHY1QHVIbcG0AaamOIpOxjMq4YDEIjXhEE/JClgFgYiXTAzonJBu0U/evXt/KZLJxJPzgoBzwb9HqY3Hv11ckvQM9v+KH4bKj3fuesCg+60qcXSu32Q4u9MTbGgDBQQ/YVjWr7xfiIwQDdkvp5gxfg0dsmRbhy5G+K2qdQPqI19XrUAY7O77zYYPazpJ2ILkXYUtabxLwekRKQYDClDeVpYwsf/BP9V7I7bXT0JN1keTQerLnwvmJYYPL7dteirFS9BORoWzGaIWv+82a+NbGhKQm0PniN1PMcMUwwrVkIoc+vv+tG4+s3O+tLcNRSysltEk860dflWnz/6BHcKT0IdzrkCNO/VMUUoiTOzEqaSSOygQ3KjDwMdtX5epj4sQaLjs19S8dzd3dPs2nQ8pknyl3bcuzMPN2Wxrb6tFHZwp/h/YZ8DeSSfE6gVXF4mnRciiqY/ZbQpiRM3z3mrl1ycD3Oh8sBoJoGHyT8yxbc3m8vvH/wkEb7Q26bKFnmDw7s9eKQGDHv90Ad5tid6LereETADCQSNVZM2WoanKmMZhCxJuF4KkCz/7YBxErjxx40AeJXqpezqXoNetOpCQUQKs3zLmM5HiMuOJ49BxEjhRcBa/XuV/Qkv/8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(36756003)(41300700001)(70206006)(6636002)(316002)(110136005)(54906003)(82310400005)(8676002)(4326008)(5660300002)(7416002)(8936002)(70586007)(86362001)(81166007)(356005)(82740400003)(36860700001)(6666004)(186003)(26005)(1076003)(336012)(426003)(40480700001)(2906002)(2876002)(40460700003)(47076005)(478600001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:58:58.4196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccf85879-d21a-4ddb-5583-08db039bae73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6405
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

Using the builtin client handle id infrastructure, this patch adds
support for setting the mac address linked to mports in ef100. This
implies to execute an MCDI command for giving the address to the
firmware for the specific devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 50 ++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 709418b1935a..454187b7f98b 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -107,6 +107,55 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
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
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -513,6 +562,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
 };
 
 static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
-- 
2.17.1

