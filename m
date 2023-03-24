Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D796C8589
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjCXTEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjCXTDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6461C5BA
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObMl3v+NZkMaA6E8Rz3eE528wtD/tt/6QswAaxfd/tgFYqaJOXvbvHGfIhwws02OHj/o594SH2Ly97JO652q0Erc2l1iWd0PRstdenXK3w58oai87PfESQXdL1x6oFVIM7zUTWhxjwQa9Y7EmaSrfM16UKDbCczPK0gWkI3dt+geoOQ8Ikk8NQCUkPU/0ype3L8Z9nB12Q9bLGOOUFsjKi3g/JJ/oSqI1rgUQUfrPAqSHOkzk4DXwicw4WAnPyau25tBenDjx0IwpF/wTi9K7GpJ6AECjtriPnAFnhn4VbaSKjicELrtqG9NdOERsvMlVAtHRq99pPXhyO+AKDfL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxX6rTGoD4qf29/wIcjRiycQ67QaDTWQkGeCOz/4SKg=;
 b=DHcx2mh0BKgI7dhIgXOj2hLbGwHTvjo3Ws9fN0p0ZqgzCjugO8MHZukp57vYY8+NeMw2Xw38qseYfBPU1O+mmCedrP1kmj2h4OsOvm//mJXM+M8u2ZlzRi0mUMfCzm5GOD8dSHf8Su+M9ub09Iu9nQIqm01OQnvXmEH5zqJENvi3e2uUszqlnDIT/UlWYLwqKWc2n+Yf7rlwoIK1KqRWQ5f2nrpHbkWbt8xkBYMtTvH4lnmmlHndmrKsJPYMQ6mohp17vbgSOBSGafOH7biLxDs8WrB9a/GSKvTynHd3X7sDnZIZUt8J8vILjKpXoKigBPH3IMOFdm08LIs7toakrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxX6rTGoD4qf29/wIcjRiycQ67QaDTWQkGeCOz/4SKg=;
 b=EHxh+5eTX4lG6tl7qc8tD5BfWncoUQ2EUoSEqcmE+nRXjiHkk4e+/av7+unWhNWEG0TXGVrzqAWT46qcBtL3eNPMxzcSU6PJN6uUFwxFuMunRf5iY7VekK/Ccrq8G5GjY9Pybni6KnsO5/oxetKS8mp2MKpYInlyjZIS8ydbxzA=
Received: from DM6PR17CA0030.namprd17.prod.outlook.com (2603:10b6:5:1b3::43)
 by DS0PR12MB8528.namprd12.prod.outlook.com (2603:10b6:8:160::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:18 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::aa) by DM6PR17CA0030.outlook.office365.com
 (2603:10b6:5:1b3::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.9 via Frontend Transport; Fri, 24 Mar 2023 19:03:18 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:16 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 13/14] pds_core: publish events to the clients
Date:   Fri, 24 Mar 2023 12:02:42 -0700
Message-ID: <20230324190243.27722-14-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT035:EE_|DS0PR12MB8528:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ecbf42-cfb9-4e61-7eb7-08db2c9a6ddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CwWRFlNT1vSxnfPcqCbR97YUenUezWlGnkcDq9ocOCOvieYgkQsFaKC9FEnHAFeDl0539W5TqQcsINURQsGTG7f8iGC+ghQ9MT1RUqk6kO8tHjHhVDqom/v82kqFa1pLVG0z8yY6+5DyfRYCp9P4F7duUseY5laouMhDB4neiGSpXW9amw+axuDVzA3f5/ovS3bcAFWC96rrSdXU+bgxBKVBAATPnbTCrlrxWpcrgVjZWq1aXXiyXf3ezOnddL7/i4YD7Ch9ttM4lXi5iMHeallAyWr10QtjS/cVXFluJBF8A27HMB57IsjQPvoWuevXtAMSR0EOjDDxwhztdZ3Zcnq4wTHGbhTgxTlrNZ0bcRMqTFV4JY+Ef6QN7gBrCb4AabOBMkjASjfinnljGvkFPwn0pZTI0IT6odjtEE0hFCKL6yNO4DCHaekYb6ZD1ALCl8DxFCB3qaImGlPIZnml5AsJkOol95LzbB1tfWveh6R3JubAVVtEm7IEXRneCyYIHxHk0lsl9NGrPxXhG3f5/yMJ+WhXnIygqD6klFQCnMex0GSWN0FftOCUzOMyV2IrYV6k8oKkn1IJPRpHp7Xcy2BcvJ9XR4hZoABcKro7Z5+RottSSy1ti8jBkbYicyihH1oMsTewUIWtU/zuT0qtrS+K9j7aw3sgk2utgw5xFLR4pgyQ5xcLN1BJu7Q5z7RrQGNWQJ3X1iRNVDaMqdhMPY6DQLpyx7MtGMYS1/B0Scs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(4326008)(86362001)(41300700001)(70586007)(8936002)(70206006)(8676002)(478600001)(110136005)(16526019)(82310400005)(5660300002)(44832011)(82740400003)(54906003)(316002)(40460700003)(81166007)(356005)(2906002)(36756003)(1076003)(2616005)(336012)(6666004)(186003)(26005)(47076005)(83380400001)(426003)(40480700001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:18.2094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ecbf42-cfb9-4e61-7eb7-08db2c9a6ddd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8528
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.  Add the code to
pass along the events to the clients.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
 drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
 include/linux/pds/pds_common.h             |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index f9fb04308eff..4f86d1a917c1 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -27,11 +27,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 		case PDS_EVENT_LINK_CHANGE:
 			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);
 			break;
 
 		case PDS_EVENT_RESET:
 			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(PDS_EVENT_RESET, comp);
 			break;
 
 		case PDS_EVENT_XCVR:
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 6b2884f64419..5322caa780f1 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -5,6 +5,25 @@
 
 #include "core.h"
 
+static BLOCKING_NOTIFIER_HEAD(pds_notify_chain);
+
+int pdsc_register_notify(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&pds_notify_chain, nb);
+}
+EXPORT_SYMBOL_GPL(pdsc_register_notify);
+
+void pdsc_unregister_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&pds_notify_chain, nb);
+}
+EXPORT_SYMBOL_GPL(pdsc_unregister_notify);
+
+void pdsc_notify(unsigned long event, void *data)
+{
+	blocking_notifier_call_chain(&pds_notify_chain, event, data);
+}
+
 void pdsc_intr_free(struct pdsc *pdsc, int index)
 {
 	struct pdsc_intr_info *intr_info;
@@ -506,6 +525,11 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	mutex_lock(&pdsc->config_lock);
 
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -514,7 +538,9 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	/* Notify clients of fw_down */
 	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
@@ -524,6 +550,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	mutex_lock(&pdsc->config_lock);
@@ -544,9 +574,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	/* Notify clients of fw_up */
 	pdsc->fw_recoveries++;
 	devlink_health_reporter_state_update(pdsc->fw_reporter,
 					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	return;
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index ce3598cf8de1..5ec31cc12b1d 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -302,6 +302,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
+void pdsc_notify(unsigned long event, void *data);
 int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
 int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
 
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 898f3c7b14b7..17708a142349 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -91,5 +91,7 @@ enum pds_core_logical_qtype {
 	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
 };
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 #endif /* _PDS_COMMON_H_ */
-- 
2.17.1

