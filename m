Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD906736F5
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjASLds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjASLc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:32:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F047854C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxlwIZwSRAG3ZMNBYdoDvW1+A0ahZvC5tz1jmeireh3MdFgjFX7mSXNcuieIxIH7Xr2ZhSksHxO7Otm+Crirsj9hV+fKGIDcsJhw/p9I4QFZcBzNsMFE37mRK6THWABnEg+vCSz6HlrDy+BfCEB6efq1aZAb/T1mPd5lqRqwOzd75jPOAk0ZupeQcsKrD+svkxnxYJ3XD6kIu7ZjQFLSVdxvaixWMj2s2dlNqSmpdCupp/MME7K5ouQoAbIFe+88WgmiyWeeT31ggeCfu1rt0uLQQBbSqZGgxSbqwLQn2r2VfKEFTjoFli/jFaGXSlUr3QQCrgrAWewgQXan3IQpbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdL0GZH3Ti9QatHuT4cOTV0m1mxjAT70uXIcDP+5ht8=;
 b=kdPUrFwaPpTMhe/1P4jj7acvFSfbvD9hLzT8YwNtiVNzn5ewIyi5T5o2VSyWnX6uXq9xmFVqaWWxlTgT2/ns2tsG0/u0IxhBYZxdXMgy2TZrImVMQ2S18+YXVqEhBDW3naejxl+UUNDsVFHchCrhZvRtYjFV4SbT4Kn1efDCGTH4ohpsPsyTe8JUCaQjSWJkCxEpzxrz+qBcWkgoXzEdHqODCVQBOgfzkLABi5prBU2y3Escf6MrO2lroSoUhlVPVFYS4o+H5P09eLtQVjMJfj9OfhUUD04QX/AdAEIwZmLl5pzWwdOe2k6rfd2uEZlhc3Yq1BsWaxszyjVXL9iz6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdL0GZH3Ti9QatHuT4cOTV0m1mxjAT70uXIcDP+5ht8=;
 b=McYrhNKc3cXRoV/If/Suc1h5oTNa+u/3GdKhdxXN20+bv0aogzRTp0wqL7S+e21ISEG8Ke7kN7K/ahfSaHIKVQVdXrVf5TMeej2xqKJf7D4JBsx9KmvOyOvF5ZOZH+WWJqteoQqehChfTQnstABf42NZforMfRftTJkmPttr01M=
Received: from MW4PR04CA0309.namprd04.prod.outlook.com (2603:10b6:303:82::14)
 by SA1PR12MB7320.namprd12.prod.outlook.com (2603:10b6:806:2b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 11:32:31 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::db) by MW4PR04CA0309.outlook.office365.com
 (2603:10b6:303:82::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 11:32:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 11:32:31 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:29 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:28 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 19 Jan 2023 05:32:27 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net-next 7/7] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Thu, 19 Jan 2023 11:31:40 +0000
Message-ID: <20230119113140.20208-8-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|SA1PR12MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: d4e2dab0-dc08-4bab-4b40-08dafa10da2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VKJQaq5FM0BQoleoIsoqRHUGLtTlpM+QSl1wUvJt/SK9xvpkOK4/H+lLG49Oza4tiyEmAxuhZ0Ze02rtrmd2UH2kfvIpW9dpIVDn75bVLcAi6jdEGauS+lqVaHowQ60AcM8qVwY2EGHN0FEWyYQZReBYOJYBuELkj2iMyN1tEUTErEuaWM6Rog6uRVPFaZEBqvp9cSJ8vfArsS2lOIwgj7PeBBZM/wzGSsvAO2ZrlE2cqeJiXjodE28Eb/BPigYKHXdO3OYGNAnnmBO3mnZA7TfmnunfkyroEmfRwwZcE4Zfs26GNRQkvV1IYI9xcLfBoTAQ1tVe55reioJRVUMD7nkLFj/agSN1ZQwGRfimkS/7XtAIoozb075f+NGPfSGfb1dtC38OZ1S1MD/CZUCEpIItXJmN+jo9h0t2v7D6ATnN5wo3N2PqqaUwNZyVozAfX36U4ODI9498I7n6Hf/Db8iT9+YnudV3YOqimSaeHGV7geCIbc0G1ILDTTmB4dfPrcl74PK31wDDjUEYVKOkvAEROzKfSczWmGEeWZvjg6KBTCXVKCQOUmsO9fKOFZZfryD0M45cE3fdqfb4mr6Kgg0lvRviKSxlLCMzcoIu58UfxpQ5EeAthG67x8a1J9EYX70ZTaCJa56HRkWXBW7RgqogydApp+drZgRkyaQuVHXj6VvgsDraKDapdY661r92WNnl/kfOrQXvQ6ZrX5HHFRIoMpZZn0naYsop9/KDKdE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(8936002)(316002)(5660300002)(86362001)(40460700003)(36756003)(478600001)(6666004)(2876002)(2906002)(2616005)(426003)(110136005)(54906003)(47076005)(6636002)(336012)(81166007)(1076003)(70206006)(4326008)(70586007)(82740400003)(40480700001)(8676002)(26005)(186003)(356005)(82310400005)(36860700001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:32:31.1581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e2dab0-dc08-4bab-4b40-08dafa10da2f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7320
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
support for setting the mac address linked to mports in ef100. This
implies to execute an MCDI command for giving the address to the
firmware for the specific devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 2a57c4f6d2b2..a85b2d4e54ab 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -472,6 +472,49 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
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
+	mport_desc = efx_mae_get_mport(devlink->efx, port->index);
+	if (!mport_desc)
+		return -EINVAL;
+
+	if (!ef100_mport_is_vf(mport_desc))
+		return -EPERM;
+
+	EFX_POPULATE_QWORD_3(pciefn,
+			     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
+			     PCIE_FUNCTION_VF, mport_desc->vf_idx,
+			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+
+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
+	if (rc) {
+		netif_err(devlink->efx, drv, devlink->efx->net_dev,
+			  "Failed to get client ID for port index %u, rc %d\n",
+			  port->index, rc);
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
+
+	return rc;
+}
+
 static int efx_devlink_info_get(struct devlink *devlink,
 				struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
@@ -486,6 +529,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
 };
 
 static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
-- 
2.17.1

