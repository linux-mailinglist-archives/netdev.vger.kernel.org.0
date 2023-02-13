Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D777F694F7F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjBMSft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjBMSfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:35:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C6C18AB6;
        Mon, 13 Feb 2023 10:35:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leKQEUL7uZPld2fnleW5IqEGHJT50OOHtl9sSdPifxYfv4LIBeWzLUFkQVjUwS7G0GXI5wyYIAi75svIdeb+1NCiytUgDV9pIv+I46DRX2nuerXrBLm6LtJOLlCZIzb5ws0Ekpo1fDuCNmEzEYYR+Tsh2X5m6cXii5B0ufKCCJM1NxZrtYObvCbhR+Zkbop3gS9BOaee4omldvcp/8DBdzcmec+aeZXo/IxAdjx+B7JH6aNMrdSoglohRF3KoPttqGRaqZL22aMRAdCD2oqvcFhrbScPqG8wwSkacmEG8eJrvEvzF4EFhBgAmHAZPRRZ9W0JvJEXcKL6QTnQUuntNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pyJl17PuBsN+JZ8X3GxflYlHvOvXbOda9kqwcIUu9wM=;
 b=Xb3oQ6dCU8oDL9UvCyFZmzi4/ayXCBkrmVwXgDbQ++OfgiOhIozuR/dbU695aCN9ZR7F7VZDVIXcWxVXPhf7V+caFxOn72KPdsiH8Mkc4+ISw4er7klDqXo1c26d/OcfvWnwNk4C9bPZzihCABEBR9TCwese/Dc0ftlSbJJLhnI3jgc4xlW63WY+NOJa/4tVDOTcYTOgSAijLSV9Gau75RShiOrf+n8ffRYkUrFXcYLslvvZCDfAXQglPY5jyQ0/GPzGkCewACj85xKF7shVoY8NEuWXOTcitZEteYQvIYaVzK57lYvRRSkvbi5slUt9PoZdz4zkb/W93rnXPoReiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyJl17PuBsN+JZ8X3GxflYlHvOvXbOda9kqwcIUu9wM=;
 b=QQB8Tk+8X3e3zu6qWjJG2T+CDpEjHUEHMG6Sx6t09iXGuV/TpnUmoVQKwbylTCJYi2TrishW14n/H6Rqi64RNet63LJ57fFVEXQURbL5Vwi+BZFGsrciRf/lVtW6cifrqpMp6nhIq+1GIVMu3rPRLUOkgft1Mh8KTy50ECRT+OY=
Received: from DS7PR03CA0053.namprd03.prod.outlook.com (2603:10b6:5:3b5::28)
 by PH0PR12MB8097.namprd12.prod.outlook.com (2603:10b6:510:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:35:28 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::9b) by DS7PR03CA0053.outlook.office365.com
 (2603:10b6:5:3b5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:35:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:35:28 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:35:27 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 13 Feb 2023 12:35:26 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v7 net-next 8/8] sfc: add support for devlink port_function_hw_addr_set in ef100
Date:   Mon, 13 Feb 2023 18:34:28 +0000
Message-ID: <20230213183428.10734-9-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|PH0PR12MB8097:EE_
X-MS-Office365-Filtering-Correlation-Id: 92870156-4295-4de1-f81d-08db0df11459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+i7M+67vezAofYPZSgRtzhKjt3u0TeUp6k3gM9y8kkigtZazUaE+c9OtlnGsWL4SMHDBOw7QWuC/TtFzQhEfGFCBaK7zuAxaq0e31g0pRNbR4wHa1FV+4sZwHyudfYmARUOCVQ1pAxQLbe8fpI9d8bfYhjydA7ID2O82BmhmrfQBoUrCSl8F+2FGW0RycqPB3tlgNK529nYwH/QeL414dTnaLtyigD2XuqfPWH2VixB6XKs/L1iq9F0Z0rbDZA05xKnDloycgxkyecPoqiVAhQKQ4Rwn/P7WL2d1/8TtP0Rgf+DKLBPhASlye1SHXjdvqGUftQ1QxBytEnX9YTiXEsrHLZIdqqqFLurINTopQxU46PzWUrAxeAADC+YMWdIqKlsm7GMv0akWEoFTsu6CKIfLeBpXsFX34dJrHBID/cuJrGdm375go86luAYoPPTvAptvyBDLBekRX+E2b1Ta9jZr3Q3T+ET4EHw1Sy2vja5MtJ2bxxB2qfQFgQACE67v0VaYs3882eHjN+8b8C2z5Wr6nyTIVmNMDo4tJ4BNJXFaP6b3R/oI/+YoaZ8+h9DbZniD3RZtYOPPELvZ2CqH29bU3iKCzq+CO99QkZHfcCWigiPYYE4Zj6NsZyxW6obWV6GXA92puYF2UuD1o7ufE4XoqpF2ak/FezO6G2VbfztTKtlK9Uih0OPTLtpxFwIEwPjW1hmMGFDvGibCNQdXUwa4k2wSuBfIrwHTlfrCPM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(186003)(26005)(1076003)(2616005)(8676002)(4326008)(478600001)(70586007)(316002)(70206006)(110136005)(54906003)(6636002)(336012)(41300700001)(426003)(47076005)(36860700001)(8936002)(5660300002)(2876002)(7416002)(2906002)(82740400003)(81166007)(82310400005)(356005)(40460700003)(86362001)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:35:28.1839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92870156-4295-4de1-f81d-08db0df11459
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8097
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
index 1c9dc15c8618..0645c24699bf 100644
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
@@ -569,6 +618,7 @@ static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 #ifdef CONFIG_SFC_SRIOV
 	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
 #endif
 };
 
-- 
2.17.1

