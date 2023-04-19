Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375626E801A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjDSRGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbjDSRFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FCF7DAA
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPj64ZbFSBlSHLTVomFU0Un+oJiDg8+96noBd1tINVosAeNHVIEbCJtyVfaIbeYLhDhaHyJ40e+bEcPQgsqclhqy50aqnL6XQt3QAnxYG/tL33OrAfUOYVyTbiI83oodsZKSJofgQPLIleI0zFuRDE2xv6Hq2DEBv2qKvMwYP23sCusJ814hFPayev7OgzW7jxXlhH0oKD9FSxybjhr7VBV/wZwnIwlyrXTALbuSGlhBUIPhpCDwLr13R4gPhz9aHQzBJ+FwF0NFQ+Zx8gZNBp9KB5/WC7DWomrSLkXHAAoZ6EjIarhUUnyZ9RZFevADCvRqacyIKznf0ba1WHlaFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHdOSs9yNm+/Y1DCP/+Fb93S3MpAMu3PTckC73LJ+I0=;
 b=V1bRew7OeWXCR/Z4p/Xix9LPgGppDCYe4W1EE9ccKNwy51Old2AhlL8xxy0s/ogmYscdPkBxL789MWZO9/hZ+bW8Po48pg0Gwn9vehiV/6uQE8Uo22yDmAVI1x6vNvv6SPiXnq0LBi5vQrXNUr56HoPKMuEGy7edk22CAQPUkmK0g8pQ/DhBscS3vdF30KRBWhm93URNW63b1RWn7MpIon67q3JqKRcOfsouIZ7i6P/nhstTZrLf3TU2xEk9kIMW5RFKB1ySR6Ab2bj69GHyy98pSfetr6H5PWIkUNTZPef7/2Dbpjm8vgtFqJeroRm69b6eb2N8LPZQDwlKeGVQ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHdOSs9yNm+/Y1DCP/+Fb93S3MpAMu3PTckC73LJ+I0=;
 b=xNJ8WA+wc+vfZLlUnyEtXulZ4wUoRk7utqXjQp0DcUfxsQ57G7XOvBjcPhkAL5J/UfddKBMAXwrWfebrAKix0dV69QvHhcIzKZ3w3oG+FzHgkI9pyej5ckiZxnhPZcGPFQH5sBJUQBbrwqQLs2nMtOg+jrWmjpF+U8OdHf4phzU=
Received: from MW2PR16CA0012.namprd16.prod.outlook.com (2603:10b6:907::25) by
 CH0PR12MB5204.namprd12.prod.outlook.com (2603:10b6:610:bb::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Wed, 19 Apr 2023 17:05:33 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::5e) by MW2PR16CA0012.outlook.office365.com
 (2603:10b6:907::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:33 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:24 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 13/14] pds_core: publish events to the clients
Date:   Wed, 19 Apr 2023 10:04:26 -0700
Message-ID: <20230419170427.1108-14-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419170427.1108-1-shannon.nelson@amd.com>
References: <20230419170427.1108-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|CH0PR12MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a330a36-11aa-4cd2-72ea-08db40f84996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQ09YXA2GLFRIAD9ThQ7cUYXMesCvW9mhdz+IY+nIHRYBjBnKcYCk6rDCqkTKvcYOE+Ma6S9vSuEUTMQcnIgCoyZsTQmtIWe5Mc7W8qixjLK/EpGPl/ZaBZopAzbuTQwKk85OVcWZNld9xWOOctT9Ke9Jt+d8oK+P00tMI0vbhPbp/Mi8DP5awh+NqdVvnQE/UMqCAb1iroPf/W8UoWSW44IO7Azx6WlScvoJc+FjUOOHuvEOPtkWzBlk8YQ+c1ys6qE3MBBsehZBaBWGzJ3Vo8Fs1+palrRMQVKLVLh/2Tj3C3baCJUCayTK3b7lEMMCXx500uFnRIcaOTQIldC78UI/u2qNmQDX+tnveifmT3PlLZJG42PC8/MiKzjX36QrvFXPiPurwZfT/FlFVAFdPVcS3WfOarjCHkFBPetTAP8Fye5b2xgmWoPNnlvROl2FzJhLBtwaEug8256N9M9M/kgdIEY1DKFCS1Xtt3CdfMuf6Eof9jGoBL0NgT9rvbhtFW/HCxQvi3fTx/3IhIU6+wRN4bwS0MYo3E571O7nEs6gFtSmdiBLB7JV4Q5yhFqz+Uf0TTlZy1fsOzS78CVn2HfNfCD4uVf4n0XT1k96PYFtTptklton94eyg8R/68HpW22cQ2lAfAhK73nOMFmED5TjgMXIRGb4dQO8MXJCl52X/yZkNICxzdTDHnmJHYBkSij1joDRUlHmxnZQ0YfYU7INvVIKZbGrXQu8fZEem4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(54906003)(110136005)(83380400001)(47076005)(478600001)(2616005)(36860700001)(40480700001)(1076003)(26005)(70586007)(70206006)(4326008)(81166007)(41300700001)(356005)(336012)(426003)(316002)(82740400003)(16526019)(186003)(5660300002)(44832011)(8676002)(2906002)(40460700003)(8936002)(86362001)(36756003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:33.1845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a330a36-11aa-4cd2-72ea-08db40f84996
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5204
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.  Add the code to
pass along the events to the clients.

The entry points pdsc_register_notify() and pdsc_unregister_notify()
are EXPORTed for other drivers that want to listen for these events.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
 drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
 include/linux/pds/pds_common.h             |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index fb2ba3f62480..045fe133f6ee 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -29,11 +29,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
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
index b2fca3b99f02..483a070d96fa 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -6,6 +6,25 @@
 
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
@@ -494,12 +513,19 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
 		dev_err(pdsc->dev, "%s: already happening\n", __func__);
 		return;
 	}
 
+	/* Notify clients of fw_down */
 	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	pdsc_stop(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
@@ -507,6 +533,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -522,9 +552,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 	if (err)
 		goto err_out;
 
+	/* Notify clients of fw_up */
 	pdsc->fw_recoveries++;
 	devlink_health_reporter_state_update(pdsc->fw_reporter,
 					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	return;
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 9e01a9ee6868..e545fafc4819 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -297,6 +297,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
+void pdsc_notify(unsigned long event, void *data);
 int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf);
 int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf);
 
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 4b37675fde3e..060331486d50 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -60,6 +60,8 @@ enum pds_core_logical_qtype {
 	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
 };
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 int pds_client_register(struct pci_dev *pf_pdev, char *devname);
 int pds_client_unregister(struct pci_dev *pf_pdev, u16 client_id);
-- 
2.17.1

