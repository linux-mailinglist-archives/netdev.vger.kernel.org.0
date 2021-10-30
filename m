Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B6F44068A
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 02:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhJ3A5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 20:57:17 -0400
Received: from mail-cusazon11021026.outbound.protection.outlook.com ([52.101.62.26]:8930
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231286AbhJ3A5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 20:57:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARI66YoTSjJ6YD49jfN57xbQm0mQOfAoV3kNoKdrKke4ycpX2/0J1ddnFNHz9hq5Qvx9N2jLvURY1QHmDlN/IJtblLO6JUtWEIIr+HjBk0lUDHzHRj1V57rPkAOjipAYKAhGOnd3lYVf6+XbyNXyldrKRxptYDNNLKNDB8tGdPgRo/9vK7dU/wnfx8YR9L+GOCNdWzLHDxFW5lE5jVeEE/q81amcJb/+P1mqtOeg5hVMFUTd6ctDi7KGfR/N+YimKht4JyyCs5zYjPeGj9aZPmtRxT6Cd/WE31EBRsptQFUb4NnGT5S7zgpQ34wFmY5sm1QQQCYtIo5gQzKLz3KrHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTDZOpUe7oVcTWp2V+NbZNUjY/7Ba5aqmOPBiZeDX7Q=;
 b=ZSymGO1tHj3M+vaI/4OA3wTTwtH75oBKpq5UXXw9o2m/nwwcknPGPh4rmO38tWJHn8zoec3bOLK7f/ar5BKKbHkE0JnVCSPME8gr0dampUOSF4BIU6ydulq4uTWDLpKOg+/g8oDxHuCsyGf376SLxvRdZwLdeMdl/pdN9S9/EgDN+i/mSQ+rGVRQ+yZtHhpPetCjVdl0AiEc4tL/VvGDT7rJsY8NCTaNw9yxnwHYpjLcs/bhqAho2p8qtXh8x51SzogejladkUFfsDDKbxDhjO59PkAG84w28qFE4z+BaVM/TuhejZJorwLiUxAlgOrUViX23ESW0BklsVg4gStReA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTDZOpUe7oVcTWp2V+NbZNUjY/7Ba5aqmOPBiZeDX7Q=;
 b=NvCEGPLPRdm+VBsLNVz4/wOGO/sJLgdqOifwv9nTDW+ZO2d8QwOIDEiTiqEF8MlFTFS8IqjXPCadFHv/H0HNofV0ys/Ws1j5lTddAFFJS7y4hE86CSnqR4dTgLUcVgxZMxK6Lwqvx04GGnn14GJ48Q3+DxcD5wrrJXszOQ7PXf8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com (2603:10b6:4:a2::17)
 by DM5PR21MB0827.namprd21.prod.outlook.com (2603:10b6:3:a3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.6; Sat, 30 Oct 2021 00:54:33 +0000
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828]) by DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828%4]) with mapi id 15.20.4649.010; Sat, 30 Oct 2021
 00:54:33 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org
Cc:     kys@microsoft.com, stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Date:   Fri, 29 Oct 2021 17:54:08 -0700
Message-Id: <20211030005408.13932-5-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211030005408.13932-1-decui@microsoft.com>
References: <20211030005408.13932-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:300:ef::12) To DM5PR2101MB1095.namprd21.prod.outlook.com
 (2603:10b6:4:a2::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:f:7661:5dff:fe6a:8a2b) by MWHPR22CA0002.namprd22.prod.outlook.com (2603:10b6:300:ef::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Sat, 30 Oct 2021 00:54:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b2478d7-d7ca-40fe-cb21-08d99b3fd63f
X-MS-TrafficTypeDiagnostic: DM5PR21MB0827:
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB08270C00A18FED17812631B7BF889@DM5PR21MB0827.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezEzRpO8IRgwyhvmpLzT3tASJ26vu3889ZOSOixuerxqgqCO9Z7fA8pJde1szTCMgK4lUaKeXlGP7FXUwcVjpY21qJdfz4yMF0RIZcFY276PqDjhEjCqMvob0XrlYcq42Q4xo+ySalGDvmz0YHM/+HwlsSHzaI6DeQAGO8yxFPCXwHykq6HPFsNBrpYYIKuSC6YN+v2mWKlfVbfP0cM3Llc+hXTtAFXhJWbEN2tuGbvTXu3KHiUqyVfnILthCdZ3lVL4u22KkL5q/qUWi5FUD1t1ZFIURwJjYAtMjGQGbqhXa6CdvERG6zG0keVw3l4/zqAukJcAzp/wCZncxg2JAQyRTIN/m7AEMVmXNyyE/t45aEcCHM6Zy3XUMXSgB+hWFBWrK5Lsi6AZyhwXHW5rIu2FCOUGPTnD8QpekwPrVoat+oLiXVI7Qk4srotSmZsQ7ZndCK8/u5MwyVUbl8ReyXWa9OZDmsii0ILVo4sjoxHtgo01zeMouZGH3fY+7J55X6sZt+nJL2FBLalK9AW82YniXxc+8lZODGyzw5Y+aLBKU3j0SVN70g1/5+oIvnlXyjsvkgjzgpF0LYE2dy/E7ntuTgvojal4y2+Ea2mUlmxCfqKBxwz+90e8zsE49TR0y7sHUy9aT8NPgIh1Sx3oXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB1095.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(7696005)(86362001)(6486002)(1076003)(83380400001)(66556008)(66476007)(4326008)(107886003)(66946007)(8676002)(2616005)(5660300002)(6666004)(10290500003)(38100700002)(82950400001)(82960400001)(7416002)(36756003)(316002)(2906002)(186003)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MkywIFrO4eIj75JzxN4ixcPKG5jzJrz0F6kmfw1oV+NMXXTCAJ+rRKsbxTYg?=
 =?us-ascii?Q?iiQM6rCBme8f4qlpjb5LC2El13F8MGJ5SyHOZKVcKg1UDQ1A0O5huYFi08Uc?=
 =?us-ascii?Q?/EpVn3CCkwQplxY8C7nZ0zkRbLVGzSS2OoS1mhigXKSJps58bH57BYYjSFu9?=
 =?us-ascii?Q?iPBcgd5/hZdqGdPHxaUpGoLOrJeP83XKhx3eoGWsyCcjCuMBUAci8B4Rpk80?=
 =?us-ascii?Q?ViBTybDZkCaqnLjtmZL8eKUs89dLpKhcO1bKYMBI7ItNKwzw/cKMy1Xp7Ob3?=
 =?us-ascii?Q?NludPdSNDcBDZkb4Byt468r5PG4RrBZwPSVFw2zcHPbauHruP966BMdJOMF/?=
 =?us-ascii?Q?r3MraV5/TKyg0n6sXM9ntvPcAPp/rtZRtzR1FQvmQpHA217yJGFee1mRGlkT?=
 =?us-ascii?Q?b4S6WRKH6vC/ej+dpMdBUAkgPhybW8NYLo3zgTZul5XdwpjbxKBGWJ89pOx6?=
 =?us-ascii?Q?Mb8XAh0C2ne6uxcJGuRHlhufllgUq2PFGY/J7lCmYn5LmRPVFr0S3AkigPUn?=
 =?us-ascii?Q?IZ2CemgL4h/n2oRR1sjIFJpFb5D5cm4qqQg7SNZyr6L7rGRm3jt51uHgqc4q?=
 =?us-ascii?Q?kWf8X0h1KrxFC1xtpC/Vvr2R6/udZRAvwNXLogyRomGSpV0KPEwyBF96dPY6?=
 =?us-ascii?Q?2sLvNQ/5bh5RGgtnUMVMLxjPsfy/IeReszYegASp78rAz+Eda2Wtl3bosQX9?=
 =?us-ascii?Q?x4Pl7FrB/x31COt1ksVq6iNbyXbA9ryo+ONZRMCnQmb17vvue31sB8Trrgx2?=
 =?us-ascii?Q?FfKNL2aJp8qkisjUAOhXhn+eGliBxoJtLV5tF3kew//QR13T7vVqiUjvXaAO?=
 =?us-ascii?Q?CBcmNqNtHAbWkGgeC1kg7FBiu/jNKeu6+3l5EiX1w384aMicQGgqGJbAPLRa?=
 =?us-ascii?Q?LuZgx8jewgGuqKRTkrwK/Oq2fuqZx4ErRcUzBwBVe2En0Zv0/GJz5iU7T+3K?=
 =?us-ascii?Q?rf/lG8TVKSDx3rBWEimrQbc4L8PprjuXsAOvlsHiGDAVyDH7WOFD2KFjrOwc?=
 =?us-ascii?Q?FX6mffCzDZRfVDi6g2OWrdo3+bYSAzKJ5lzRSsa5jqBmLG6LAikFgSPG78KH?=
 =?us-ascii?Q?WBTaAf/D1ks1dYMs3btqdEctUpU6xNsZNd/NsSBg41JxmMY2oFZhrdKLciFQ?=
 =?us-ascii?Q?xJkPbjWnCj2P1qoauNPnUorXuGa0qR393LCboAE2zbaWsa4pKj2Pmly7jSG/?=
 =?us-ascii?Q?DNJl7k5TzLkOfy9sp1MP1ysb03TZG4JFeHgtSsdeWQbOLoJJZbwoYuocUqvO?=
 =?us-ascii?Q?QZBGbweWzy30BaqlYlUgWfx0A0Ff0qSbUN+Bm9l6CG2x4MAzjR0Gv1g4nhYE?=
 =?us-ascii?Q?vAKtHWzccJ6mNzpidazLDyJ0wRQqmfEV/e3G10+agPVnUQqvE+dUniRn/Js4?=
 =?us-ascii?Q?9XZF1tHkfI5e+4gFX1Jxgzoe6hHa6bLV4JUGfS9b7zSJz7gCaZDRXRc5Mkod?=
 =?us-ascii?Q?3ifN5WBAlRzGADbxJRUheod5IibvrfzQ/XhN9dhj0LqGLZ8tdPUbtrkiwjgM?=
 =?us-ascii?Q?6bD24930gp8/UEBUVWXJcWjXIKL0gOVEBcpflckBWZGrNHSA9iYycapdiaJD?=
 =?us-ascii?Q?eJI6hm4vwmU0csbSMZ+3kLs26CMBVr3z9fFF4yMrW4MF7oEJNrPm5HynaCFc?=
 =?us-ascii?Q?JScGYAM0Gf8kdk+ccF5Z5emPbA/HS/gKFyEXwDmAbj940M32eQX7NqGZ+k4t?=
 =?us-ascii?Q?qbNP9EKyWqtoyz0g6e3EVi5t3VY=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2478d7-d7ca-40fe-cb21-08d99b3fd63f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB1095.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2021 00:54:33.0385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQG6wmKkb1C1vn9vR5NCr/su+IDGpBw3CJtjHyPtFqovseg37dM66LFUmW0IKb/0zbUwg74ZNMbEyJV7R4N7TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the suspend/resume/shutdown callbacks for hibernation/kexec.

Add mana_gd_setup() and mana_gd_cleanup() for some common code, and
use them in the mand_gd_* callbacks.

Reuse mana_probe/remove() for the hibernation path.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 140 +++++++++++++-----
 drivers/net/ethernet/microsoft/mana/mana.h    |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  72 +++++++--
 3 files changed, 164 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 599dfd5e6090..c96ac81212f7 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1258,6 +1258,52 @@ static void mana_gd_remove_irqs(struct pci_dev *pdev)
 	gc->irq_contexts = NULL;
 }
 
+static int mana_gd_setup(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	int err;
+
+	mana_gd_init_registers(pdev);
+	mana_smc_init(&gc->shm_channel, gc->dev, gc->shm_base);
+
+	err = mana_gd_setup_irqs(pdev);
+	if (err)
+		return err;
+
+	err = mana_hwc_create_channel(gc);
+	if (err)
+		goto remove_irq;
+
+	err = mana_gd_verify_vf_version(pdev);
+	if (err)
+		goto destroy_hwc;
+
+	err = mana_gd_query_max_resources(pdev);
+	if (err)
+		goto destroy_hwc;
+
+	err = mana_gd_detect_devices(pdev);
+	if (err)
+		goto destroy_hwc;
+
+	return 0;
+
+destroy_hwc:
+	mana_hwc_destroy_channel(gc);
+remove_irq:
+	mana_gd_remove_irqs(pdev);
+	return err;
+}
+
+static void mana_gd_cleanup(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+
+	mana_hwc_destroy_channel(gc);
+
+	mana_gd_remove_irqs(pdev);
+}
+
 static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct gdma_context *gc;
@@ -1287,6 +1333,9 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!gc)
 		goto release_region;
 
+	mutex_init(&gc->eq_test_event_mutex);
+	pci_set_drvdata(pdev, gc);
+
 	bar0_va = pci_iomap(pdev, bar, 0);
 	if (!bar0_va)
 		goto free_gc;
@@ -1294,47 +1343,23 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	gc->bar0_va = bar0_va;
 	gc->dev = &pdev->dev;
 
-	pci_set_drvdata(pdev, gc);
-
-	mana_gd_init_registers(pdev);
 
-	mana_smc_init(&gc->shm_channel, gc->dev, gc->shm_base);
-
-	err = mana_gd_setup_irqs(pdev);
+	err = mana_gd_setup(pdev);
 	if (err)
 		goto unmap_bar;
 
-	mutex_init(&gc->eq_test_event_mutex);
-
-	err = mana_hwc_create_channel(gc);
+	err = mana_probe(&gc->mana, false);
 	if (err)
-		goto remove_irq;
-
-	err = mana_gd_verify_vf_version(pdev);
-	if (err)
-		goto remove_irq;
-
-	err = mana_gd_query_max_resources(pdev);
-	if (err)
-		goto remove_irq;
-
-	err = mana_gd_detect_devices(pdev);
-	if (err)
-		goto remove_irq;
-
-	err = mana_probe(&gc->mana);
-	if (err)
-		goto clean_up_gdma;
+		goto cleanup_gd;
 
 	return 0;
 
-clean_up_gdma:
-	mana_hwc_destroy_channel(gc);
-remove_irq:
-	mana_gd_remove_irqs(pdev);
+cleanup_gd:
+	mana_gd_cleanup(pdev);
 unmap_bar:
 	pci_iounmap(pdev, bar0_va);
 free_gc:
+	pci_set_drvdata(pdev, NULL);
 	vfree(gc);
 release_region:
 	pci_release_regions(pdev);
@@ -1349,11 +1374,9 @@ static void mana_gd_remove(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 
-	mana_remove(&gc->mana);
+	mana_remove(&gc->mana, false);
 
-	mana_hwc_destroy_channel(gc);
-
-	mana_gd_remove_irqs(pdev);
+	mana_gd_cleanup(pdev);
 
 	pci_iounmap(pdev, gc->bar0_va);
 
@@ -1364,6 +1387,52 @@ static void mana_gd_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+/* The 'state' parameter is not used. */
+static int mana_gd_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+
+	mana_remove(&gc->mana, true);
+
+	mana_gd_cleanup(pdev);
+
+	return 0;
+}
+
+/* In case the NIC hardware stops working, the suspend and resume callbacks will
+ * fail -- if this happens, it's safer to just report an error than try to undo
+ * what has been done.
+ */
+static int mana_gd_resume(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	int err;
+
+	err = mana_gd_setup(pdev);
+	if (err)
+		return err;
+
+	err = mana_probe(&gc->mana, true);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Quiesce the device for kexec. This is also called upon reboot/shutdown. */
+static void mana_gd_shutdown(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+
+	dev_info(&pdev->dev, "Shutdown was calledd\n");
+
+	mana_remove(&gc->mana, true);
+
+	mana_gd_cleanup(pdev);
+
+	pci_disable_device(pdev);
+}
+
 #ifndef PCI_VENDOR_ID_MICROSOFT
 #define PCI_VENDOR_ID_MICROSOFT 0x1414
 #endif
@@ -1378,6 +1447,9 @@ static struct pci_driver mana_driver = {
 	.id_table	= mana_id_table,
 	.probe		= mana_gd_probe,
 	.remove		= mana_gd_remove,
+	.suspend	= mana_gd_suspend,
+	.resume		= mana_gd_resume,
+	.shutdown	= mana_gd_shutdown,
 };
 
 module_pci_driver(mana_driver);
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index fc98a5ba5ed0..d047ee876f12 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -374,8 +374,8 @@ int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
 int mana_detach(struct net_device *ndev, bool from_close);
 
-int mana_probe(struct gdma_dev *gd);
-void mana_remove(struct gdma_dev *gd);
+int mana_probe(struct gdma_dev *gd, bool resuming);
+void mana_remove(struct gdma_dev *gd, bool suspending);
 
 extern const struct ethtool_ops mana_ethtool_ops;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 4ff5a1fc506f..820585d45a61 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1828,11 +1828,12 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	return err;
 }
 
-int mana_probe(struct gdma_dev *gd)
+int mana_probe(struct gdma_dev *gd, bool resuming)
 {
 	struct gdma_context *gc = gd->gdma_context;
+	struct mana_context *ac = gd->driver_data;
 	struct device *dev = gc->dev;
-	struct mana_context *ac;
+	u16 num_ports = 0;
 	int err;
 	int i;
 
@@ -1844,44 +1845,70 @@ int mana_probe(struct gdma_dev *gd)
 	if (err)
 		return err;
 
-	ac = kzalloc(sizeof(*ac), GFP_KERNEL);
-	if (!ac)
-		return -ENOMEM;
+	if (!resuming) {
+		ac = kzalloc(sizeof(*ac), GFP_KERNEL);
+		if (!ac)
+			return -ENOMEM;
 
-	ac->gdma_dev = gd;
-	ac->num_ports = 1;
-	gd->driver_data = ac;
+		ac->gdma_dev = gd;
+		gd->driver_data = ac;
+	}
 
 	err = mana_create_eq(ac);
 	if (err)
 		goto out;
 
 	err = mana_query_device_cfg(ac, MANA_MAJOR_VERSION, MANA_MINOR_VERSION,
-				    MANA_MICRO_VERSION, &ac->num_ports);
+				    MANA_MICRO_VERSION, &num_ports);
 	if (err)
 		goto out;
 
+	if (!resuming) {
+		ac->num_ports = num_ports;
+	} else {
+		if (ac->num_ports != num_ports) {
+			dev_err(dev, "The number of vPorts changed: %d->%d\n",
+				ac->num_ports, num_ports);
+			err = -EPROTO;
+			goto out;
+		}
+	}
+
+	if (ac->num_ports == 0)
+		dev_err(dev, "Failed to detect any vPort\n");
+
 	if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
 		ac->num_ports = MAX_PORTS_IN_MANA_DEV;
 
-	for (i = 0; i < ac->num_ports; i++) {
-		err = mana_probe_port(ac, i, &ac->ports[i]);
-		if (err)
-			break;
+	if (!resuming) {
+		for (i = 0; i < ac->num_ports; i++) {
+			err = mana_probe_port(ac, i, &ac->ports[i]);
+			if (err)
+				break;
+		}
+	} else {
+		for (i = 0; i < ac->num_ports; i++) {
+			rtnl_lock();
+			err = mana_attach(ac->ports[i]);
+			rtnl_unlock();
+			if (err)
+				break;
+		}
 	}
 out:
 	if (err)
-		mana_remove(gd);
+		mana_remove(gd, false);
 
 	return err;
 }
 
-void mana_remove(struct gdma_dev *gd)
+void mana_remove(struct gdma_dev *gd, bool suspending)
 {
 	struct gdma_context *gc = gd->gdma_context;
 	struct mana_context *ac = gd->driver_data;
 	struct device *dev = gc->dev;
 	struct net_device *ndev;
+	int err;
 	int i;
 
 	for (i = 0; i < ac->num_ports; i++) {
@@ -1897,7 +1924,16 @@ void mana_remove(struct gdma_dev *gd)
 		 */
 		rtnl_lock();
 
-		mana_detach(ndev, false);
+		err = mana_detach(ndev, false);
+		if (err)
+			netdev_err(ndev, "Failed to detach vPort %d: %d\n",
+				   i, err);
+
+		if (suspending) {
+			/* No need to unregister the ndev. */
+			rtnl_unlock();
+			continue;
+		}
 
 		unregister_netdevice(ndev);
 
@@ -1910,6 +1946,10 @@ void mana_remove(struct gdma_dev *gd)
 
 out:
 	mana_gd_deregister_device(gd);
+
+	if (suspending)
+		return;
+
 	gd->driver_data = NULL;
 	gd->gdma_context = NULL;
 	kfree(ac);
-- 
2.17.1

