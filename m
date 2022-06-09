Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EC75456CA
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbiFIV6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 17:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345198AbiFIV60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 17:58:26 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-bgr052101064021.outbound.protection.outlook.com [52.101.64.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3002163294;
        Thu,  9 Jun 2022 14:58:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nR7idzHH+mqcbt9TUvuOM4a+yj+43tY/PjXpMuVTFGX70Mhtl8ebf3hJkiL+z0gQR7OG0KX1HwF0dYqfzJ3UE/czlzDwb7ULVyDWmZSWaXsP6rWMaJFiX8xbYL6Felypmr+onEt7LcUitaGY8hr+4yQMOL1f7QuUC+SP7Bk5gdXIASDjS5m/npOEPLpZUs+yQXV5s10xLm7krlYly0qiOnRRip7UE6h3UH1oBcAipgUxZWp3ioJVJ8lx7GfYrSt3HstKzMPR2UZIFQjo9cPSVO468eufiuJvjTV2QXNrsMCqGbjk8DOaXcLnxDIi9c/vF7SNGx2BU+auf93/XA11Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C44B/0tWOMpfl5HTsKNb9OgUy1nnuD3Up/YDXOUO+Ts=;
 b=OBIVt95gD22lb49Wz5S1AohX9VsTUEl8V8EyZe8D/+BJdVYyhxosYfzpnMtIMIA5qs4JW05WtbADLcMFMW+/dvRMajsywNHv0To7puuig5B9k9L07JynSnlVmX5b8G6BozWCQMF3R78OMXlbhZZb8bcBFWJc7VP3tIau4pdB/eApuAvIrUSuEMpObyYibFD0NXhmmQ/3c8lnmrRgceiwUkCNzK7H7gl4Ev9G0LkH+datySe3J9VAuW96P3uix+AIEcQnVVXSqR0zQr5C/snYP2exVQcygaIlaSuYbgccrVgNSNdTkojoYNG6HXD7buC/xc5wQDcfYgxCP1hvDGKz2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C44B/0tWOMpfl5HTsKNb9OgUy1nnuD3Up/YDXOUO+Ts=;
 b=aX2aYA1hk273lZxG58/oblzyRZC/3Bf5AQBXuLw36eMWdC8orGKEJREyWXTqKj7dkyrfqFXOCDYepSgtX1hGXhIYWII0TRrxjGOYtwWO830/X/DGZ92Z8hBWGv6UJdFYgWB1izePzoV93u8NwCNyiclA8p6ZEK5VBDJggFVDo4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BYAPR21MB1223.namprd21.prod.outlook.com (2603:10b6:a03:103::11)
 by SJ0PR21MB1871.namprd21.prod.outlook.com (2603:10b6:a03:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.6; Thu, 9 Jun
 2022 21:58:21 +0000
Received: from BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac]) by BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac%5]) with mapi id 15.20.5353.001; Thu, 9 Jun 2022
 21:58:21 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next,1/2] net: mana: Add the Linux MANA PF driver
Date:   Thu,  9 Jun 2022 14:57:07 -0700
Message-Id: <1654811828-25339-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654811828-25339-1-git-send-email-haiyangz@microsoft.com>
References: <1654811828-25339-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0060.namprd19.prod.outlook.com
 (2603:10b6:300:94::22) To BYAPR21MB1223.namprd21.prod.outlook.com
 (2603:10b6:a03:103::11)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c7ee489-0b17-41d9-7de5-08da4a632b3d
X-MS-TrafficTypeDiagnostic: SJ0PR21MB1871:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <SJ0PR21MB1871000A74F76832817FEA87ACA79@SJ0PR21MB1871.namprd21.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6YJ+Ig99163gtv0RSWpxa6lXkHrdqI/Qj9lN2I6NI3uD9/Lh0/DcRF1FLBYPM+8hwO5QHuKAFfUgguC/1rOdf81J6+8IjztmO/dqK7S4ObhLFidbtk6WH0Q708r7nnJDGU2X8KUz6mfVFykjJEEYWksLBmteQhMZcT7U/1m6uNKsRWOCOCCrx4RKJGTCE8s9vayPOGr3W79/Z+3w8xIN3s41ENA5LsuXsmhp9z5btDVizhusP2MOkOaEADgT0U5eP5XgtBlQay25+/ADwPkFcReV0FXcgWwFkp3epYMLYnL5RCSiUnOjn6Z2hnaCYhhT5GFPRdFvjN0QTnD3dzDwWNVb8apF7+g20vr9aXo+XgaFXCNiz4hKfbeJbM76O+JlmWP9Q/VFBaENojcGHfNb4Tq3sO84ASxHYnGD5LogaddAst86rwgXpw56nAu5RN2pWZNsHKNHXgvFi2pjMYAAPyyLydtQLoHIfDWjK7VfTsXnzRsZnvcNfDRUoaHq31qpmuLnR0Q+UF8jRONW6Z+J/HFPbGnZSG15C6Vs19EqvjiNtjXVbsocMs33X60fg3S+QCeTCbwP4KDkzDPJGvFdqnItVK4yqKiHUEB90PNwBBze8ALLHHTyF2Hx9W7gjiYoLuvf/D7rGWfK5GfBHfrXj4l6GO5SgK4LV7gfS2FOeu9wP2qTLYY1PfHyQVB2jI/KHwSKl3eRuDKb7LeI1Ig369/WMx24L/OUSMtz5sDtw/fOZXBJ5YxTGS1hSqkKTpf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1223.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(83380400001)(10290500003)(36756003)(4326008)(38350700002)(6666004)(2906002)(38100700002)(5660300002)(66556008)(66946007)(66476007)(8676002)(186003)(316002)(2616005)(30864003)(6486002)(7846003)(6506007)(52116002)(82960400001)(6512007)(8936002)(82950400001)(26005)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vR0BJykNj+6+1HCrfHcyj2WQuhiPhbI7Gg1QdddE9zCEw5nk45UWTQqFvp5+?=
 =?us-ascii?Q?bi6MxIjYZK1pem4HPYEDJo5AEYWpGZDyN0EKyAbAt7K5rc6AufHHJC1nIpCE?=
 =?us-ascii?Q?ZR658yCvG1LsEN8te2ZxNew+z7/sVQBeSTiRpLo0F4h9oC/bLV0Y7Gk3EYZo?=
 =?us-ascii?Q?E/uhw8tI4FdZPuPyTDIjPWHeLO0xr7T3hooo5oGHX5qRZFzE5bfeThb2hp3B?=
 =?us-ascii?Q?OSs8EnArsJrmiG5Lo0aWnWWlwEVU07OdBGvL0jrnU5fG0+mKU5YTWnkyoz7R?=
 =?us-ascii?Q?B6xBXYg46HF1cqpYE0ppK/rB1VQXE9e81FhJ1XCiVWtS+K1zPm3nZW2WSfug?=
 =?us-ascii?Q?qB/+2GK3DRDqu5tWCTc53q9GUE+n2h14EsVVLRzVyl565oJ6nZY6HbVMBImY?=
 =?us-ascii?Q?D4DQ+9aJr3MRHO7GU9czhucrsu17BRbgtN7VfZJ9pnjDIRX3z1z4AwQj+La7?=
 =?us-ascii?Q?YJ+Mo6doqNtVD9znDiGzWivmZTbfpQGM1iDMYMRKuaEd9kW6TXwIAB8j43Gw?=
 =?us-ascii?Q?lq/0tXym+ohKLMpP1vo6nd0H0wvqn9hW0dDzDuW/t79jDExoZ2nAg+KAuLLD?=
 =?us-ascii?Q?Jln96lsI/uoT9CIpGA/hUoiOqfbd4tE50oNxlbFiJlC46OjLctAdBnyagrC2?=
 =?us-ascii?Q?56YH2sQTUYkhz3boq31vnGFOTZGAB1xqER5x9WBUb/h3MKXV19ss/SHGKyiA?=
 =?us-ascii?Q?TWcFA3YvIQozvzUVibCe1Z9YrVZp084xMF/Qj5GHOK9UZbQqwIaGfYoSiqNs?=
 =?us-ascii?Q?qa7xgDc2xU/Wl3yLgrdkATjTNx0P4RkYKH5m3Awb65pbyziBo3kAyD6830qN?=
 =?us-ascii?Q?6tNpAQ7EAYR7/S4PY6oocIV5gtbEGHKh0aZkSY0sOXbJfj5I12P9PxDIa5bq?=
 =?us-ascii?Q?qkftAqm6dIKM7CckBE2TwDarVmXGseC56N9HQodcRhelGbocRNFTiqolQp/e?=
 =?us-ascii?Q?t5kydy5DMyEeeuMF9vG0YyofE75sdCxsBCeQI/lrm0DiUW0ebSBuR2demizd?=
 =?us-ascii?Q?NXxaoMl+/Cjd6M+spYWCAmor1nMgj8oh4jNLTvTwbyCAkiSSCzxk3i/SXCn5?=
 =?us-ascii?Q?YCxsLkNfek7BjL+rqtBZ55hUsfxUtj+Qz2GwHw/RyUzi6dimq1hOLlAlDmNV?=
 =?us-ascii?Q?UIxqsLzvpLWGXUGgh5xPqiJHpeGBncxQ9Z7VFBGpx/b1UTv9BhW9usr2jmWc?=
 =?us-ascii?Q?Z20y20LhG9luJD9WKwofDitTImlzg3EHrtyfh2r1oxhTegjnaSZkgDUZ9lS8?=
 =?us-ascii?Q?+WGtfz0Ragnd8pDzd32XQfTIE77eOYyYLfSljhvfqrJM+MHELyWUr4x4rZjz?=
 =?us-ascii?Q?p47YOs6EoBFOxjcGVtx58phAxFSPKlm7QXjG4ep3YDbKriMV7zJi5RluROiC?=
 =?us-ascii?Q?05GvSOirdqq0GLu9eRzn8kR36S14pyqimtevKB0uU4am3iTauTn5rYJyMrYp?=
 =?us-ascii?Q?41Q7dTecD2hCrz1kA3VjuAgXlC94eHoup66qINBN61YKHVFQ9NTjR2Otcnie?=
 =?us-ascii?Q?2LoEjfPl5XogNscOo7aNqvUvbgyi2EjdShxb0pfvzMLEeSGweDgBP8bSEWIC?=
 =?us-ascii?Q?yI77zxspcANcScjc/zDflKQVe8zAuh75AihuCkOq7ysgDY1OipkpKnemGLno?=
 =?us-ascii?Q?XedT6Jzx3O4BnmFTwEslD0IoZlEEcNwLgOXKcYxkOc9fIjarb8bQPjMW4afq?=
 =?us-ascii?Q?1ecRknH7x3EkyKBCjet7bHXCtoZrmi8k/FIydgxqH3pQq8Bcthkpb6U5qpkt?=
 =?us-ascii?Q?1qRmxUQsQw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c7ee489-0b17-41d9-7de5-08da4a632b3d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1223.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 21:58:21.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HeUi9GwcNlIxWqYniEmm8vSgjjZIoKA6K/p2LpNHkwtlxCKaZcePS+Ur7JO0qBS3eIYHKYvOY/we+sFkm4D1sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1871
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

This minimal PF driver runs on bare metal.
Currently Ethernet TX/RX works. SR-IOV management is not supported yet.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    |  10 ++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  39 ++++-
 .../net/ethernet/microsoft/mana/hw_channel.c  |  18 ++-
 .../net/ethernet/microsoft/mana/hw_channel.h  |   5 +
 drivers/net/ethernet/microsoft/mana/mana.h    |  64 +++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 135 ++++++++++++++++++
 6 files changed, 267 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 41ecd156e95f..4a6efe6ada08 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -348,6 +348,7 @@ struct gdma_context {
 	struct completion	eq_test_event;
 	u32			test_event_eq_id;
 
+	bool			is_pf;
 	void __iomem		*bar0_va;
 	void __iomem		*shm_base;
 	void __iomem		*db_page_base;
@@ -469,6 +470,15 @@ struct gdma_eqe {
 #define GDMA_REG_DB_PAGE_SIZE	0x10
 #define GDMA_REG_SHM_OFFSET	0x18
 
+#define GDMA_PF_REG_DB_PAGE_SIZE	0xD0
+#define GDMA_PF_REG_DB_PAGE_OFF		0xC8
+#define GDMA_PF_REG_SHM_OFF		0x70
+
+#define GDMA_SRIOV_REG_CFG_BASE_OFF	0x108
+
+#define MANA_PF_DEVICE_ID 0x00B9
+#define MANA_VF_DEVICE_ID 0x00BA
+
 struct gdma_posted_wqe_info {
 	u32 wqe_size_in_bu;
 };
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 49b85ca578b0..5f9240182351 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -18,7 +18,24 @@ static u64 mana_gd_r64(struct gdma_context *g, u64 offset)
 	return readq(g->bar0_va + offset);
 }
 
-static void mana_gd_init_registers(struct pci_dev *pdev)
+static void mana_gd_init_pf_regs(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+	void __iomem *sriov_base_va;
+	u64 sriov_base_off;
+
+	gc->db_page_size = mana_gd_r32(gc, GDMA_PF_REG_DB_PAGE_SIZE) & 0xFFFF;
+	gc->db_page_base = gc->bar0_va +
+				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
+
+	sriov_base_off = mana_gd_r64(gc, GDMA_SRIOV_REG_CFG_BASE_OFF);
+
+	sriov_base_va = gc->bar0_va + sriov_base_off;
+	gc->shm_base = sriov_base_va +
+			mana_gd_r64(gc, sriov_base_off + GDMA_PF_REG_SHM_OFF);
+}
+
+static void mana_gd_init_vf_regs(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 
@@ -30,6 +47,16 @@ static void mana_gd_init_registers(struct pci_dev *pdev)
 	gc->shm_base = gc->bar0_va + mana_gd_r64(gc, GDMA_REG_SHM_OFFSET);
 }
 
+static void mana_gd_init_registers(struct pci_dev *pdev)
+{
+	struct gdma_context *gc = pci_get_drvdata(pdev);
+
+	if (gc->is_pf)
+		mana_gd_init_pf_regs(pdev);
+	else
+		mana_gd_init_vf_regs(pdev);
+}
+
 static int mana_gd_query_max_resources(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
@@ -1304,6 +1331,11 @@ static void mana_gd_cleanup(struct pci_dev *pdev)
 	mana_gd_remove_irqs(pdev);
 }
 
+static bool mana_is_pf(unsigned short dev_id)
+{
+	return dev_id == MANA_PF_DEVICE_ID;
+}
+
 static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct gdma_context *gc;
@@ -1340,10 +1372,10 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!bar0_va)
 		goto free_gc;
 
+	gc->is_pf = mana_is_pf(pdev->device);
 	gc->bar0_va = bar0_va;
 	gc->dev = &pdev->dev;
 
-
 	err = mana_gd_setup(pdev);
 	if (err)
 		goto unmap_bar;
@@ -1438,7 +1470,8 @@ static void mana_gd_shutdown(struct pci_dev *pdev)
 #endif
 
 static const struct pci_device_id mana_id_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, 0x00BA) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, MANA_PF_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, MANA_VF_DEVICE_ID) },
 	{ }
 };
 
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 078d6a5a0768..543a5d5c304f 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -158,6 +158,14 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			hwc->rxq->msg_buf->gpa_mkey = val;
 			hwc->txq->msg_buf->gpa_mkey = val;
 			break;
+
+		case HWC_INIT_DATA_PF_DEST_RQ_ID:
+			hwc->pf_dest_vrq_id = val;
+			break;
+
+		case HWC_INIT_DATA_PF_DEST_CQ_ID:
+			hwc->pf_dest_vrcq_id = val;
+			break;
 		}
 
 		break;
@@ -773,10 +781,13 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp)
 {
+	struct gdma_context *gc = hwc->gdma_dev->gdma_context;
 	struct hwc_work_request *tx_wr;
 	struct hwc_wq *txq = hwc->txq;
 	struct gdma_req_hdr *req_msg;
 	struct hwc_caller_ctx *ctx;
+	u32 dest_vrcq = 0;
+	u32 dest_vrq = 0;
 	u16 msg_id;
 	int err;
 
@@ -803,7 +814,12 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 
 	tx_wr->msg_size = req_len;
 
-	err = mana_hwc_post_tx_wqe(txq, tx_wr, 0, 0, false);
+	if (gc->is_pf) {
+		dest_vrq = hwc->pf_dest_vrq_id;
+		dest_vrcq = hwc->pf_dest_vrcq_id;
+	}
+
+	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
 		goto out;
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.h b/drivers/net/ethernet/microsoft/mana/hw_channel.h
index 31c6e83c454a..6a757a6e2732 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.h
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.h
@@ -20,6 +20,8 @@
 #define HWC_INIT_DATA_MAX_NUM_CQS	7
 #define HWC_INIT_DATA_PDID		8
 #define HWC_INIT_DATA_GPA_MKEY		9
+#define HWC_INIT_DATA_PF_DEST_RQ_ID	10
+#define HWC_INIT_DATA_PF_DEST_CQ_ID	11
 
 /* Structures labeled with "HW DATA" are exchanged with the hardware. All of
  * them are naturally aligned and hence don't need __packed.
@@ -178,6 +180,9 @@ struct hw_channel_context {
 	struct semaphore sema;
 	struct gdma_resource inflight_msg_res;
 
+	u32 pf_dest_vrq_id;
+	u32 pf_dest_vrcq_id;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index d36405af9432..f198b34c232f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -374,6 +374,7 @@ struct mana_port_context {
 	unsigned int num_queues;
 
 	mana_handle_t port_handle;
+	mana_handle_t pf_filter_handle;
 
 	u16 port_idx;
 
@@ -420,6 +421,12 @@ enum mana_command_code {
 	MANA_FENCE_RQ		= 0x20006,
 	MANA_CONFIG_VPORT_RX	= 0x20007,
 	MANA_QUERY_VPORT_CONFIG	= 0x20008,
+
+	/* Privileged commands for the PF mode */
+	MANA_REGISTER_FILTER	= 0x28000,
+	MANA_DEREGISTER_FILTER	= 0x28001,
+	MANA_REGISTER_HW_PORT	= 0x28003,
+	MANA_DEREGISTER_HW_PORT	= 0x28004,
 };
 
 /* Query Device Configuration */
@@ -547,6 +554,63 @@ struct mana_cfg_rx_steer_resp {
 	struct gdma_resp_hdr hdr;
 }; /* HW DATA */
 
+/* Register HW vPort */
+struct mana_register_hw_vport_req {
+	struct gdma_req_hdr hdr;
+	u16 attached_gfid;
+	u8 is_pf_default_vport;
+	u8 reserved1;
+	u8 allow_all_ether_types;
+	u8 reserved2;
+	u8 reserved3;
+	u8 reserved4;
+}; /* HW DATA */
+
+struct mana_register_hw_vport_resp {
+	struct gdma_resp_hdr hdr;
+	mana_handle_t hw_vport_handle;
+}; /* HW DATA */
+
+/* Deregister HW vPort */
+struct mana_deregister_hw_vport_req {
+	struct gdma_req_hdr hdr;
+	mana_handle_t hw_vport_handle;
+}; /* HW DATA */
+
+struct mana_deregister_hw_vport_resp {
+	struct gdma_resp_hdr hdr;
+}; /* HW DATA */
+
+/* Register filter */
+struct mana_register_filter_req {
+	struct gdma_req_hdr hdr;
+	mana_handle_t vport;
+	u8 mac_addr[6];
+	u8 reserved1;
+	u8 reserved2;
+	u8 reserved3;
+	u8 reserved4;
+	u16 reserved5;
+	u32 reserved6;
+	u32 reserved7;
+	u32 reserved8;
+}; /* HW DATA */
+
+struct mana_register_filter_resp {
+	struct gdma_resp_hdr hdr;
+	mana_handle_t filter_handle;
+}; /* HW DATA */
+
+/* Deregister filter */
+struct mana_deregister_filter_req {
+	struct gdma_req_hdr hdr;
+	mana_handle_t filter_handle;
+}; /* HW DATA */
+
+struct mana_deregister_filter_resp {
+	struct gdma_resp_hdr hdr;
+}; /* HW DATA */
+
 #define MANA_MAX_NUM_QUEUES 64
 
 #define MANA_SHORT_VPORT_OFFSET_MAX ((1U << 8) - 1)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index b1d773823232..3ef09e0cdbaa 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -446,6 +446,119 @@ static int mana_verify_resp_hdr(const struct gdma_resp_hdr *resp_hdr,
 	return 0;
 }
 
+static int mana_pf_register_hw_vport(struct mana_port_context *apc)
+{
+	struct mana_register_hw_vport_resp resp = {};
+	struct mana_register_hw_vport_req req = {};
+	int err;
+
+	mana_gd_init_req_hdr(&req.hdr, MANA_REGISTER_HW_PORT,
+			     sizeof(req), sizeof(resp));
+	req.attached_gfid = 1;
+	req.is_pf_default_vport = 1;
+	req.allow_all_ether_types = 1;
+
+	err = mana_send_request(apc->ac, &req, sizeof(req), &resp,
+				sizeof(resp));
+	if (err) {
+		netdev_err(apc->ndev, "Failed to register hw vPort: %d\n", err);
+		return err;
+	}
+
+	err = mana_verify_resp_hdr(&resp.hdr, MANA_REGISTER_HW_PORT,
+				   sizeof(resp));
+	if (err || resp.hdr.status) {
+		netdev_err(apc->ndev, "Failed to register hw vPort: %d, 0x%x\n",
+			   err, resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	apc->port_handle = resp.hw_vport_handle;
+	return 0;
+}
+
+static void mana_pf_deregister_hw_vport(struct mana_port_context *apc)
+{
+	struct mana_deregister_hw_vport_resp resp = {};
+	struct mana_deregister_hw_vport_req req = {};
+	int err;
+
+	mana_gd_init_req_hdr(&req.hdr, MANA_DEREGISTER_HW_PORT,
+			     sizeof(req), sizeof(resp));
+	req.hw_vport_handle = apc->port_handle;
+
+	err = mana_send_request(apc->ac, &req, sizeof(req), &resp,
+				sizeof(resp));
+	if (err) {
+		netdev_err(apc->ndev, "Failed to unregister hw vPort: %d\n",
+			   err);
+		return;
+	}
+
+	err = mana_verify_resp_hdr(&resp.hdr, MANA_DEREGISTER_HW_PORT,
+				   sizeof(resp));
+	if (err || resp.hdr.status)
+		netdev_err(apc->ndev,
+			   "Failed to deregister hw vPort: %d, 0x%x\n",
+			   err, resp.hdr.status);
+}
+
+static int mana_pf_register_filter(struct mana_port_context *apc)
+{
+	struct mana_register_filter_resp resp = {};
+	struct mana_register_filter_req req = {};
+	int err;
+
+	mana_gd_init_req_hdr(&req.hdr, MANA_REGISTER_FILTER,
+			     sizeof(req), sizeof(resp));
+	req.vport = apc->port_handle;
+	memcpy(req.mac_addr, apc->mac_addr, ETH_ALEN);
+
+	err = mana_send_request(apc->ac, &req, sizeof(req), &resp,
+				sizeof(resp));
+	if (err) {
+		netdev_err(apc->ndev, "Failed to register filter: %d\n", err);
+		return err;
+	}
+
+	err = mana_verify_resp_hdr(&resp.hdr, MANA_REGISTER_FILTER,
+				   sizeof(resp));
+	if (err || resp.hdr.status) {
+		netdev_err(apc->ndev, "Failed to register filter: %d, 0x%x\n",
+			   err, resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	apc->pf_filter_handle = resp.filter_handle;
+	return 0;
+}
+
+static void mana_pf_deregister_filter(struct mana_port_context *apc)
+{
+	struct mana_deregister_filter_resp resp = {};
+	struct mana_deregister_filter_req req = {};
+	int err;
+
+	mana_gd_init_req_hdr(&req.hdr, MANA_DEREGISTER_FILTER,
+			     sizeof(req), sizeof(resp));
+	req.filter_handle = apc->pf_filter_handle;
+
+	err = mana_send_request(apc->ac, &req, sizeof(req), &resp,
+				sizeof(resp));
+	if (err) {
+		netdev_err(apc->ndev, "Failed to unregister filter: %d\n",
+			   err);
+		return;
+	}
+
+	err = mana_verify_resp_hdr(&resp.hdr, MANA_DEREGISTER_FILTER,
+				   sizeof(resp));
+	if (err || resp.hdr.status)
+		netdev_err(apc->ndev,
+			   "Failed to deregister filter: %d, 0x%x\n",
+			   err, resp.hdr.status);
+}
+
 static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
 				 u32 proto_minor_ver, u32 proto_micro_ver,
 				 u16 *max_num_vports)
@@ -1653,6 +1766,7 @@ static int mana_add_rx_queues(struct mana_port_context *apc,
 
 static void mana_destroy_vport(struct mana_port_context *apc)
 {
+	struct gdma_dev *gd = apc->ac->gdma_dev;
 	struct mana_rxq *rxq;
 	u32 rxq_idx;
 
@@ -1666,6 +1780,9 @@ static void mana_destroy_vport(struct mana_port_context *apc)
 	}
 
 	mana_destroy_txq(apc);
+
+	if (gd->gdma_context->is_pf)
+		mana_pf_deregister_hw_vport(apc);
 }
 
 static int mana_create_vport(struct mana_port_context *apc,
@@ -1676,6 +1793,12 @@ static int mana_create_vport(struct mana_port_context *apc,
 
 	apc->default_rxobj = INVALID_MANA_HANDLE;
 
+	if (gd->gdma_context->is_pf) {
+		err = mana_pf_register_hw_vport(apc);
+		if (err)
+			return err;
+	}
+
 	err = mana_cfg_vport(apc, gd->pdid, gd->doorbell);
 	if (err)
 		return err;
@@ -1755,6 +1878,7 @@ static int mana_init_port(struct net_device *ndev)
 int mana_alloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
+	struct gdma_dev *gd = apc->ac->gdma_dev;
 	int err;
 
 	err = mana_create_vport(apc, ndev);
@@ -1781,6 +1905,12 @@ int mana_alloc_queues(struct net_device *ndev)
 	if (err)
 		goto destroy_vport;
 
+	if (gd->gdma_context->is_pf) {
+		err = mana_pf_register_filter(apc);
+		if (err)
+			goto destroy_vport;
+	}
+
 	mana_chn_setxdp(apc, mana_xdp_get(apc));
 
 	return 0;
@@ -1825,6 +1955,7 @@ int mana_attach(struct net_device *ndev)
 static int mana_dealloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
+	struct gdma_dev *gd = apc->ac->gdma_dev;
 	struct mana_txq *txq;
 	int i, err;
 
@@ -1833,6 +1964,9 @@ static int mana_dealloc_queues(struct net_device *ndev)
 
 	mana_chn_setxdp(apc, NULL);
 
+	if (gd->gdma_context->is_pf)
+		mana_pf_deregister_filter(apc);
+
 	/* No packet can be transmitted now since apc->port_is_up is false.
 	 * There is still a tiny chance that mana_poll_tx_cq() can re-enable
 	 * a txq because it may not timely see apc->port_is_up being cleared
@@ -1915,6 +2049,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->max_queues = gc->max_num_queues;
 	apc->num_queues = gc->max_num_queues;
 	apc->port_handle = INVALID_MANA_HANDLE;
+	apc->pf_filter_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
 
 	ndev->netdev_ops = &mana_devops;
-- 
2.25.1

