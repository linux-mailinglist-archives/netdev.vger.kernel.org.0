Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A611069B5C2
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBQW5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjBQW5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:18 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C156783B
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu/3+sFJZp9gPIdzmCgFgdZv7apecMNply/DdWstSbNoMmP3jpw70VkgNsH6/wWLJ4MQO03lpOjBJ4sV8kOBQrZDF2yoXCRccujVYNFryCbszbeeJUndTnAaQLgVIVAym53MByJ2azuJHgJGvdLt6YAGickHR9xE4zlO15Jkp+SlupsDZ83t6s5F79khpO6TkWYg2B1ORrS/mv29bLTvOpkD3eMU6MaZ2KCMOzSXaAI9IS/2oI/oEx3kEhcwjaFwDT/aFEIc0tw+TBcusN3KxdPd/kupuNIBr20gfvk99MBJhO51pgEyk1jgrCIFBEG+7Np1yFKaykaXTZqu0Aw2Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUekdjQDCVQxr5jD0MUZ8olLQCpucKVmWTEvuKWaIIY=;
 b=aVOZrQ/2PbsSuMmWW9zhDnDnVPR6fZOUtuuVmv98fwU0Y/fcpBPCiH1xYgk58AwkibAK7VXLqhK/Hr/Pu8zvuYJBJsXwxblipSqv9iot+Pb+aGLq0vxsGxBogn9ZYzsUp302Eje3EN6PLYo5DAH5r3VUw8ENaxkobXHkmGUL93rB0sRX6ge8XO9N4TDqEDjqGrK8ziaO1SVnbDMddh+aMnmxq7tj638rZZxQsRDTVYxTIB/vIoZJ8VBmjM84lPRoAGi9BWqNOjKRkxqrXH7MaRsJxW3PgXPq0eYZIV4p3QSKNCNPWDUMVf66nhI4w22zXgN143rP/G9suGSbEL3kUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUekdjQDCVQxr5jD0MUZ8olLQCpucKVmWTEvuKWaIIY=;
 b=ck+q7Jo9pJklDKa4zN7D3lqbWOLzxXCRP5qt3pMvG3XqAdCT6Be3G+uQHzhHg8oMqCEoFbKesM6dHjBFB0xp6pLKymw42Bh1YN2AkiQwjnX0it2Fcki2huCIZeCUB2emQmxJmTmjBLFjAfJ4FDtqj1zFLLPn+HiAunpmwrWZbZc=
Received: from DS7PR05CA0019.namprd05.prod.outlook.com (2603:10b6:5:3b9::24)
 by LV2PR12MB5776.namprd12.prod.outlook.com (2603:10b6:408:178::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 22:56:46 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::1) by DS7PR05CA0019.outlook.office365.com
 (2603:10b6:5:3b9::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.11 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:45 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:43 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 09/14] pds_core: initial VF configuration
Date:   Fri, 17 Feb 2023 14:55:53 -0800
Message-ID: <20230217225558.19837-10-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|LV2PR12MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 45276b73-c9c8-40b8-e2c8-08db113a3e79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbaoMG9aK7CAjaZsHMsE5OPqPm1hDoryr6TEcyCFEwQQG+dwOMpa3AC63m6M+fmDbdWdHdxtamFHTLdmlAF86DWqHnx5dxZxd/4qNLVE24brQlJA3G7VuANyM4Nr0YAEdUgASEHQkYlgRG74Wgvua8bGbeDdiQ3InVwtepktUDlywkIKCnSe4cgFdDzuYO3AqLWHqp3iEZyzuNTCaFp4EzwsVPD6CELgyxz6KMQR++2qsVeD0BH5cSujQygp0b7vc4IaVkNoBTzNt/eYZEp1f9sNQfWCzV/2nm0k34QkQ8Y1pjW5nsNwZ6r40Ii0A+I88BdtVcoHP4xJ28f5IqFJpcX1KCoLVIODHN/YrHQN5p0ZxjBwFSjk4KIlJZkwrmrJUYQrKWZKWaZuCy2bfgQXfS+nTuZJe88GRI3YBIHdaqLqcPgZqio6HWE2JQL/iSaRg8KKjTT3HqHKUt+lqZ8pg4jKauv0y5XN8raJTPotyUAtwyLpJW4XeRxtHeHaENJHvrNST4v7c/ACES/FRCTSspRx90lzIL1XLI27dDtVrRozvNMT8bByme5rgejWtnTuQ637bIfPTgkkUJ1vq6oLUMpQX49Lw4Fd8FdFUSUZyq1SenYhMP5czaLA7B9aD0STFsKFlizGiotSrwts+dmSt766rspM6mrizVbBegZyZYDNAZ8UfXzyfvbEtVGCrcjE5vQG+xE6T68oMGGqadllIOIchtTUNdjGNewSI3vwAmg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(26005)(36756003)(478600001)(6666004)(82310400005)(186003)(16526019)(81166007)(1076003)(40480700001)(336012)(83380400001)(36860700001)(40460700003)(41300700001)(8676002)(356005)(70586007)(47076005)(2906002)(4326008)(2616005)(426003)(70206006)(86362001)(5660300002)(54906003)(316002)(44832011)(8936002)(110136005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:45.5445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45276b73-c9c8-40b8-e2c8-08db113a3e79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5776
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the VF control and management

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.h | 10 ++++++-
 drivers/net/ethernet/amd/pds_core/main.c | 35 ++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 0355a0b850eb..1885976c6486 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -30,6 +30,13 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc_vf {
+	u16     index;
+	__le16  vif_types[PDS_DEV_TYPE_MAX];
+
+	struct pds_auxiliary_dev *padev;
+};
+
 struct pdsc_devinfo {
 	u8 asic_type;
 	u8 asic_rev;
@@ -147,6 +154,7 @@ struct pdsc {
 	struct dentry *dentry;
 	struct device *dev;
 	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	struct pdsc_vf *vfs;
 	int num_vfs;
 	int hw_index;
 	int id;
@@ -166,6 +174,7 @@ struct pdsc {
 	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
 
 	struct workqueue_struct *wq;
+	struct rw_semaphore vf_op_lock;	/* lock for VF operations */
 
 	unsigned int devcmd_timeout;
 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
@@ -299,5 +308,4 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
-
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 23e9bf48a05e..1376dec84756 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -165,6 +165,37 @@ void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
 			       (u64)page_num << PAGE_SHIFT, PAGE_SIZE);
 }
 
+static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+	struct device *dev = pdsc->dev;
+	int ret = 0;
+
+	if (num_vfs > 0) {
+		pdsc->vfs = kcalloc(num_vfs, sizeof(struct pdsc_vf), GFP_KERNEL);
+		if (!pdsc->vfs)
+			return -ENOMEM;
+		pdsc->num_vfs = num_vfs;
+
+		ret = pci_enable_sriov(pdev, num_vfs);
+		if (ret) {
+			dev_err(dev, "Cannot enable SRIOV: %pe\n", ERR_PTR(ret));
+			goto no_vfs;
+		}
+
+		return num_vfs;
+	}
+
+no_vfs:
+	pci_disable_sriov(pdev);
+
+	kfree(pdsc->vfs);
+	pdsc->vfs = NULL;
+	pdsc->num_vfs = 0;
+
+	return ret;
+}
+
 static DEFINE_IDA(pdsc_pf_ida);
 
 #define PDSC_WQ_NAME_LEN 24
@@ -237,6 +268,7 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	spin_lock_init(&pdsc->adminq_lock);
 
 	mutex_lock(&pdsc->config_lock);
+	init_rwsem(&pdsc->vf_op_lock);
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
 	if (err)
 		goto err_out_unmap_bars;
@@ -300,6 +332,8 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
+	pdsc_sriov_configure(pdev, 0);
+
 	/* Now we can lock it up and tear it down */
 	mutex_lock(&pdsc->config_lock);
 	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
@@ -337,6 +371,7 @@ static struct pci_driver pdsc_driver = {
 	.id_table = pdsc_id_table,
 	.probe = pdsc_probe,
 	.remove = pdsc_remove,
+	.sriov_configure = pdsc_sriov_configure,
 };
 
 static int __init pdsc_init_module(void)
-- 
2.17.1

