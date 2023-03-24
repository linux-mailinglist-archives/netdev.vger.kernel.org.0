Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED186C8587
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCXTDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCXTDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:20 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E74B15153
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtBd+pkzggOocay4s8c0H5h+8I//R2ZeY7D+W4ts6PoWVWU05iMQlCfQU2AQtFs4JRnjAvOHJUwBy2xWLV0yAyzh6O+TK48qsIDLQNKKI0xxwiMVCZ+oz15uvM0fjGwjS2in4mEn1DvGK30EkzCLJzRl2XvvZDrXqypFQoVNjaA7VKvZPtMpNfJCLl1W7bLMg3w6ntAVMd+p4DaiEPrsIvaGlvoUk7C1soxYmqkfxdo79QA5HgTRxVpPq3cWhbvrXMuDgVk/tc1EfFGnxqoifnlI1FawyxYJzYx0VPmKyTp+wlQsQYzDvhG1btEOoN/F0QmvveL8iAFP1o4ZKjq2EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dq1go+W0quN8cOTTEYVy3ERge755/St0cDgbXKH6hP0=;
 b=XnTSXSifA1bDmOgFux1E/O+kjmlR3OxbDTHooAlhSwwXtPPw2aDaI6RrzFVMivLRP6Djua/bubBXzx64oFLArz8JW2lVU+DTg0RWAo96WF8kkU3idqeYOICBlNIYsONhI2R4OYbMDjZ/P6sTQkzBAJ65bbVDCr2Ypzt4Dcu1RxOkavVH3cBJFfXy/AsA2wBp+zPP38N/0cff3aDJ8hoSmCltjoNh+K4p4147HiNzUsd2g6cYZFrfH5UlH+A/orNRlKeDABW7N1Sn/pxkL3c84Ll9QJ+I/Spj/OT6wp+SHxo3BpBjg6iiqA39kSGZfgUkoVukz0Br0jUc1fqr1mklCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dq1go+W0quN8cOTTEYVy3ERge755/St0cDgbXKH6hP0=;
 b=Lt8MlwQZ9P7M8AErw0lE2DtCIYPpuxjtfDt/D53ZD2JaHW98qBp7PI5/a4XLn4WL39Y96gW8dLoibgVb9veSFvJ37ujPA/tkxYGNwx1e0l8N+U2pKm75DL2Km0erd6ThhVmpihmTABIhz2rfTNwS6qJDa1RiojVWIulSG9YFXW8=
Received: from DM6PR21CA0016.namprd21.prod.outlook.com (2603:10b6:5:174::26)
 by PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:15 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::c1) by DM6PR21CA0016.outlook.office365.com
 (2603:10b6:5:174::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.9 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.9 via Frontend Transport; Fri, 24 Mar 2023 19:03:15 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:14 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 11/14] pds_core: devlink params for enabling VIF support
Date:   Fri, 24 Mar 2023 12:02:40 -0700
Message-ID: <20230324190243.27722-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|PH7PR12MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 142bfdbe-9f22-41d0-3986-08db2c9a6c6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvejUm2r2uq4+DlFW4w6rb2r1WiRfqJ3CSmHvvL0T4FfQLAavy3XMWc3vPdAzis3MNkj7yrXdd4cSuRIOzKyuYY6L2VLGo/8w8PYuffVOUuTCZ0x1aYC2nU5x3YGISa+Xk6sOuiqGhQHg7IaAjNF2BKdZEjqC2jMiSMUYPmYuRCrIQeNjRG5aRSJOwNBqhGk6bE6ZBHNeeHViLfYzFHxZHmjNe4dbTkUNBjKauU/slmDCCvJiObKz2NMUMTKxRdbt8pPPFoHtTT9/d3ttoFzsuRKxzXVSN2DefKASZwoEmMhpO1biXOFYpzlgbWbEi1WJO2fWaNIuUmOO3kqihMxTSaDro0xyUZvZdpBytsxDBbdZ2lxJA4z6k/4dGoaac3rJmqJVevv5tc3f4WVJdzA0yYGfWPcT/hWOlQAoKu53tH0fZQiC2GGTnZcrCJMLCHmjOmuXzXRxabnwHE+1bh3bUJcXVcnGvI3KeIvlVX0g6i2auIS4/LqwS4mVAlUoc77aQ0Ju7ZVJbonuVD5ZbN+mCos/WEqMYJIwidKdHxvVXiz3pvEFQA8/DyORk2tRJhKEslsXDuICbG7PQmQeNUDqLeEfDGJdQfCmaTGSNoamkL1K5loYMdJuTfVBOe+o8eHXmRmeZWV+s8k/qG9wrqzyzV0N6F49bj7r4srvhTdI+7OEoNB4elM/VWASFlANYgDLQ9aUnR1U42aJPOvlFggv3NEKsZzQ5EUJ/8By33Wnxo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(44832011)(2906002)(4326008)(41300700001)(83380400001)(36756003)(40460700003)(70206006)(336012)(478600001)(70586007)(186003)(40480700001)(36860700001)(16526019)(1076003)(2616005)(81166007)(426003)(54906003)(82310400005)(47076005)(26005)(8936002)(8676002)(110136005)(6666004)(5660300002)(316002)(356005)(86362001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:15.7606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 142bfdbe-9f22-41d0-3986-08db2c9a6c6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the devlink parameter switches so the user can enable
the features supported by the VFs.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 90 ++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 17464b063009..45ab7e2e6528 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -7,6 +7,87 @@
 #include <linux/pci.h>
 
 #include "core.h"
+#include <linux/pds/pds_auxbus.h>
+
+static struct
+pdsc_viftype *pdsc_dl_find_viftype_by_id(struct pdsc *pdsc,
+					 enum devlink_param_type dl_id)
+{
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (pdsc->viftype_status[vt].dl_id == dl_id)
+			return &pdsc->viftype_status[vt];
+	}
+
+	return NULL;
+}
+
+static int pdsc_dl_enable_get(struct devlink *dl, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry)
+		return -ENOENT;
+
+	ctx->val.vbool = vt_entry->enabled;
+
+	return 0;
+}
+
+static int pdsc_dl_enable_set(struct devlink *dl, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+	int err = 0;
+	int vf_id;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry || !vt_entry->supported)
+		return -EOPNOTSUPP;
+
+	if (vt_entry->enabled == ctx->val.vbool)
+		return 0;
+
+	vt_entry->enabled = ctx->val.vbool;
+	for (vf_id = 0; vf_id < pdsc->num_vfs; vf_id++) {
+		struct pdsc *vf = pdsc->vfs[vf_id].vf;
+
+		err = ctx->val.vbool ? pdsc_auxbus_dev_add_vf(vf, pdsc) :
+				       pdsc_auxbus_dev_del_vf(vf, pdsc);
+	}
+
+	return err;
+}
+
+static int pdsc_dl_enable_validate(struct devlink *dl, u32 id,
+				   union devlink_param_value val,
+				   struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	struct pdsc_viftype *vt_entry;
+
+	vt_entry = pdsc_dl_find_viftype_by_id(pdsc, id);
+	if (!vt_entry || !vt_entry->supported)
+		return -EOPNOTSUPP;
+
+	if (!pdsc->viftype_status[vt_entry->vif_id].supported)
+		return -ENODEV;
+
+	return 0;
+}
+
+static const struct devlink_param pdsc_dl_params[] = {
+	DEVLINK_PARAM_GENERIC(ENABLE_VNET,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      pdsc_dl_enable_get,
+			      pdsc_dl_enable_set,
+			      pdsc_dl_enable_validate),
+};
 
 static int pdsc_dl_flash_update(struct devlink *dl,
 				struct devlink_flash_update_params *params,
@@ -162,9 +243,16 @@ void pdsc_dl_free(struct pdsc *pdsc)
 int pdsc_dl_register(struct pdsc *pdsc)
 {
 	struct devlink *dl = priv_to_devlink(pdsc);
+	int err;
+
+	if (!pdsc->pdev->is_virtfn) {
+		err = devlink_params_register(dl, pdsc_dl_params,
+					      ARRAY_SIZE(pdsc_dl_params));
+		if (err)
+			return err;
 
-	if (!pdsc->pdev->is_virtfn)
 		pdsc_dl_reporters_create(pdsc);
+	}
 
 	devlink_register(dl);
 
-- 
2.17.1

