Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B38D63FF17
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiLBDfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiLBDdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:40 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11022022.outbound.protection.outlook.com [52.101.63.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F059F27168;
        Thu,  1 Dec 2022 19:32:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5LjHiYA2VqmUTkBTTp7JO1G3opLxMC8aJp+5ADu7Kkeay5OCJIJUSBtbXd9q+3E7zFjXJxcTHFJMVUgZk68SG9e+jqrqn34tBmj8wE5NATqAnIJgQfzu0+fWNIDItFPi7PThl0kNJ7qyXr9fWuF1vWH83efMaKCMBZc14YPJ5WhCv7OY79nLq9L1Lp+JNICrWE+9BSQGtYfQDzDBFnO+VYKQNk3xtN2qh1cWeio4S06FlSeAQXW+l5ZY8kfqJBW+4ZTG4W52VWNzkhWab/AFgqojHrlEEltEqS0V4fWtAtEbxN5ftNCLtvNqbKH/An3FJcGtNiJZVZXFzMfvXjydA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGndZWQu3HNngqcEmna4NaG2bsukODbgQidpOqhCV9o=;
 b=GzwMXlvjww6lIe2KciB2ymLKsEAUc/VSwchLXg4Qw4pCmO19W0rlwQEznM6rO1DfPGfrMr9OMvXiefbvPz/BvJXkL3jORjZNdts7+NAhbsWXeV6DNB5NuDVVvllWHTg8d4OS5fFAWXmQNdf1+2uaTsk9NQitHUF72yRejo5FMQ036JTzX4y2IusRmys4wji5dSoYAC1DxDKsP0ycw8ulkFlciI/39l1WdjHDLshcKlFgBF1ns5Wb8JQg0FDYVHHrdVaHQAnkiDTwrVWkhJanL4IAmyoaTRDw1EjUM8u1Zzw3pvfVWXe/g+IjqfTRwoZEJtyVRFWrjGsizGooCTPZcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGndZWQu3HNngqcEmna4NaG2bsukODbgQidpOqhCV9o=;
 b=YnfbAKKmxnGy3gdXss0wLsEYhFhE+xRMMDUH2X6GZDTcljlAjRYQM6hnw3iVbUCagAGdF7lcEmVbo2EelneGyr/RWO3HdGFSMd1ifbW/q50t/o4PS2xfkWxcdLMzXhU3M1dXaDEZCqN8XD3SSO63DfXiZ168Zc6mL4QPjB4PVV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Fri, 2 Dec
 2022 03:32:31 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:31 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Cc:     mikelley@microsoft.com
Subject: [Patch v4 13/13] PCI: hv: Enable PCI pass-thru devices in Confidential VMs
Date:   Thu,  1 Dec 2022 19:30:31 -0800
Message-Id: <1669951831-4180-14-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM6PR21MB1340:EE_
X-MS-Office365-Filtering-Correlation-Id: 50aa3d65-8d63-47c5-26db-08dad415d7fd
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: reXaGvaLxRQrzRadew4MyuUK4g7qHyAtWRhe/JwPWTQ4VQl/tUnXrAv5wIxyfzfMm/MAq33r5iGmZrdpsPrnqTmW/qP3T1BiI6V2d679JaQTIj/XOFtB5NWDz9Rc7Lp8/Oafg0CK3dHLDLdlElXKzJYsNjTtXzPuj151jo4+EUmXW8rwWh1Jp9M1QHPHVXC4IPUIVP17PmXxjWWI/bTrcAyPtW+zujE2rcdbFmdSluLQz7/DwYdcsQ1SaAxZnpSuKPNOovbV7vl74HP3SGGvmjrATtsHdlyIquGObqp03oerwxQ930Tp4AIpvX/gdoIUhsJIS3kDCvnDzeYEFGti2Z3OXcaSYSvOB6SBeHKH35exlldLOU2VE1klgheMio5napyF58/ff5+ew5KfleULQy8aRmYQVHtLDJ5sWphq2OEEPNi97hEjB6Pt/UPpBJ6fYH9DWbEsE5g10nu4+7inAlMUwjGWVJTyInO791kLqODat2oqKNh7NOyO5IDjzfJqL87Rj2/7wQYDSIskibDPhM0G41a5pMIn/IVxlF4767bXcrmqe+jJ/E+OUG0CivMxXlhv/tPRw/TG+Tkl3VDC3zdktH5ATd64MVVnIYgRRFTR4FQG7zRBaNYZYb/XhGQIXAmtfeCEbcyI5Y2vB6aLEndtBkdNcSJXazjULWvBMe1uPWnMqkp9lMoqokg3qn0hEIYUC43PWtZP9jHqNgz5O58sHzNZQdkhuD4m/sivDMUz7U64QfqD8nA0UEcx7ixHQuQRDQmtu3AQrPHleyTQW6jkDVaiANawCt4SW4Ze+4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(186003)(8936002)(8676002)(10290500003)(2616005)(107886003)(86362001)(2906002)(36756003)(7416002)(41300700001)(82950400001)(7406005)(82960400001)(66476007)(66556008)(83380400001)(66946007)(316002)(4326008)(921005)(5660300002)(966005)(52116002)(478600001)(6486002)(6506007)(38350700002)(6512007)(38100700002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Spsx7FsEZFbvF8xBh80t+EDnNYzomTV70AnCBwTz/b8y74ABGvbgLBPyFoiI?=
 =?us-ascii?Q?f7sq5C3ad4UfJuVJWwRiGVYPauVkGJfKzghXmYiLfcT7YCCwenNLvTDLIWKv?=
 =?us-ascii?Q?nXzIIVbyhSMCpiNActz/Vl6ORubnJEqHtKSlgIDn5pb/ABeDQU0VmjPkt6Wj?=
 =?us-ascii?Q?7ZJuOiETzbVQdlJGHvAQez5B6yxAiH75Ef0uUeuYRuDlBBgX3orpHA77Cr87?=
 =?us-ascii?Q?EvDerb2XmmjQ6yWzrcj6roSvel1cduizKbGU9kwHeX6OL7TdC+VuTHcSe9RF?=
 =?us-ascii?Q?hvQ0yyj3sP7ZnB6bFsXTpX1U3pOwZywve9/wQPeMAv/GaFA78bWACqGsndQ5?=
 =?us-ascii?Q?YsVtmRBbvT66h1QDPOVge32agrYVxqvZxpuMXNwjJVuKCow6i+37mRvIfsjL?=
 =?us-ascii?Q?6NnQEilOdnAdKzVGG7eGyWoJjTTO1EblVReibU55lwBMivIHjcf8i40HtGvd?=
 =?us-ascii?Q?g0Bl+VCqaYfPqGNu7mJH+2jB2y0Bbwwgd7gKWzNTyY8evMvGWgXuihlDb1zL?=
 =?us-ascii?Q?cEPX+rAxLcRCgYNsfpmDOwKzw1TKArIEPI6eVoYva72fU2PzL5GdIzH9pWcK?=
 =?us-ascii?Q?kXyyjY972K58Rv0lmu0bCn6PltfzZEB9vJdU7L6TtHTb6zx5aCVDd9wCQOsM?=
 =?us-ascii?Q?vYKOmx5cpdcsy2kO4+bOZlj1+eN3xM5mO+dydAgoaa7CUDU2QQn7VwYkzFY+?=
 =?us-ascii?Q?wrIbDreSMlQkbht62HWsEYUh1CeO104vmhzjWezRwoV65aerzsUAlh2El0+b?=
 =?us-ascii?Q?sbLMCmXWeLVkWlhtqoR+4vwlwk+w5J+N3kN+WvcVPqwXtjWZybOS6jhx5Yfb?=
 =?us-ascii?Q?6iREBWIEWz6HgQ8qhTKX8iIURkTvWFOv4xd0o9WdCOCBIWJcitqhViq4gA5Q?=
 =?us-ascii?Q?9JD9udv00pdHydraKB02qrJP9OMAYqIy9BuPdxMhb0MrXYeFulZg9U2+p3RO?=
 =?us-ascii?Q?x+n9UI3AcztEi0NL67EnPF8Hq7Nc+7U1HhmcCN5frWhufOW43iPAdZOgJhMI?=
 =?us-ascii?Q?b2c7w7lZSbQFgJCplHjThPKe9YE03AjQSutl74mxWgIvGwPdQSljxwzgihq5?=
 =?us-ascii?Q?o7VEe8PGQXqibOKgttlLPBUt3l6vZciWt0kuXdCAJvORAfsY0FEmponHt1Ai?=
 =?us-ascii?Q?GM03+AgINnJ/hBri0x5zQkMSIxNADmaKTasBSQE/0pdC+udnvTgjF1aANEdE?=
 =?us-ascii?Q?MhudYiN+LxAy+xnDPH8VhCwdyOr8rZ7uOnuXZ9sWEpw5017vkIvdx7lAeRRO?=
 =?us-ascii?Q?igdwdgL41NB58DZaT8kvASbqdiaBgFTXfhWA5b7VvKS3tTc5NxcPf/LMBuWl?=
 =?us-ascii?Q?/j3/CPe9q1v36MlzpNxfQk8Ho/XeCJY7r+V/45VQTYWENlsddh0IyyPGpu1u?=
 =?us-ascii?Q?5bFD6LADG/f/Xqdlwx6MEjQTeHqOTnmFATdYdrNz57o38obzLBo5GY9oIUcB?=
 =?us-ascii?Q?1Ahex9ZBBn9Isddr36IWT3oW8MJYZspurt0rRlB2WWyDdL7GPbX+J7NYRrJH?=
 =?us-ascii?Q?APFyJg/4rOdUpKfwK6lhZSc6Z9dsi2fTsEJMVG/4suYoPJzk+ilUZBNcbQcX?=
 =?us-ascii?Q?a36M4O+GMS8wiqVck+RN+oE6hKkVeDD7+MnsyeJFvE2SM/GV/lrJffmBWEx+?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50aa3d65-8d63-47c5-26db-08dad415d7fd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:31.1795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIxtsxtlCDyNbBy2cVCA7IKh/MrCUq5j/8hWQ0JY9qhkcdS/shQuIVn6VhFp0EnbrjV+EgQFHlQzBBTUS7v5EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For PCI pass-thru devices in a Confidential VM, Hyper-V requires
that PCI config space be accessed via hypercalls.  In normal VMs,
config space accesses are trapped to the Hyper-V host and emulated.
But in a confidential VM, the host can't access guest memory to
decode the instruction for emulation, so an explicit hypercall must
be used.

Update the PCI config space access functions to use the hypercalls
when such use is indicated by Hyper-V flags.  Also, set the flag to
allow the Hyper-V PCI driver to be loaded and used in a Confidential
VM (a.k.a., "Isolation VM").  The driver has previously been hardened
against a malicious Hyper-V host[1].

[1] https://lore.kernel.org/all/20220511223207.3386-2-parri.andrea@gmail.com/

Co-developed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/hv/channel_mgmt.c           |   2 +-
 drivers/pci/controller/pci-hyperv.c | 168 ++++++++++++++++++++++--------------
 2 files changed, 105 insertions(+), 65 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index cc23b90..007f26d 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -67,7 +67,7 @@
 	{ .dev_type = HV_PCIE,
 	  HV_PCIE_GUID,
 	  .perf_device = false,
-	  .allowed_in_isolated = false,
+	  .allowed_in_isolated = true,
 	},
 
 	/* Synthetic Frame Buffer */
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index bbe6e36..f874f89 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -514,6 +514,7 @@ struct hv_pcibus_device {
 
 	/* Highest slot of child device with resources allocated */
 	int wslot_res_allocated;
+	bool use_calls; /* Use hypercalls to access mmio cfg space */
 
 	/* hypercall arg, must not cross page boundary */
 	struct hv_retarget_device_interrupt retarget_msi_interrupt_params;
@@ -1123,8 +1124,10 @@ static void hv_pci_write_mmio(struct device *dev, phys_addr_t gpa, int size, u32
 static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
 				     int size, u32 *val)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
+	struct device *dev = &hbus->hdev->device;
+	int offset = where + CFG_PAGE_OFFSET;
 	unsigned long flags;
-	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET + where;
 
 	/*
 	 * If the attempt is to read the IDs or the ROM BAR, simulate that.
@@ -1152,56 +1155,79 @@ static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
 		 */
 		*val = 0;
 	} else if (where + size <= CFG_PAGE_SIZE) {
-		spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
-		/* Choose the function to be read. (See comment above) */
-		writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
-		/* Make sure the function was chosen before we start reading. */
-		mb();
-		/* Read from that function's config space. */
-		switch (size) {
-		case 1:
-			*val = readb(addr);
-			break;
-		case 2:
-			*val = readw(addr);
-			break;
-		default:
-			*val = readl(addr);
-			break;
+
+		spin_lock_irqsave(&hbus->config_lock, flags);
+		if (hbus->use_calls) {
+			phys_addr_t addr = hbus->mem_config->start + offset;
+
+			hv_pci_write_mmio(dev, hbus->mem_config->start, 4,
+						hpdev->desc.win_slot.slot);
+			hv_pci_read_mmio(dev, addr, size, val);
+		} else {
+			void __iomem *addr = hbus->cfg_addr + offset;
+
+			/* Choose the function to be read. (See comment above) */
+			writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
+			/* Make sure the function was chosen before reading. */
+			mb();
+			/* Read from that function's config space. */
+			switch (size) {
+			case 1:
+				*val = readb(addr);
+				break;
+			case 2:
+				*val = readw(addr);
+				break;
+			default:
+				*val = readl(addr);
+				break;
+			}
+			/*
+			 * Make sure the read was done before we release the
+			 * spinlock allowing consecutive reads/writes.
+			 */
+			mb();
 		}
-		/*
-		 * Make sure the read was done before we release the spinlock
-		 * allowing consecutive reads/writes.
-		 */
-		mb();
-		spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
+		spin_unlock_irqrestore(&hbus->config_lock, flags);
 	} else {
-		dev_err(&hpdev->hbus->hdev->device,
-			"Attempt to read beyond a function's config space.\n");
+		dev_err(dev, "Attempt to read beyond a function's config space.\n");
 	}
 }
 
 static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
+	struct device *dev = &hbus->hdev->device;
+	u32 val;
 	u16 ret;
 	unsigned long flags;
-	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET +
-			     PCI_VENDOR_ID;
 
-	spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
+	spin_lock_irqsave(&hbus->config_lock, flags);
 
-	/* Choose the function to be read. (See comment above) */
-	writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
-	/* Make sure the function was chosen before we start reading. */
-	mb();
-	/* Read from that function's config space. */
-	ret = readw(addr);
-	/*
-	 * mb() is not required here, because the spin_unlock_irqrestore()
-	 * is a barrier.
-	 */
+	if (hbus->use_calls) {
+		phys_addr_t addr = hbus->mem_config->start +
+					 CFG_PAGE_OFFSET + PCI_VENDOR_ID;
+
+		hv_pci_write_mmio(dev, hbus->mem_config->start, 4,
+					hpdev->desc.win_slot.slot);
+		hv_pci_read_mmio(dev, addr, 2, &val);
+		ret = val;  /* Truncates to 16 bits */
+	} else {
+		void __iomem *addr = hbus->cfg_addr + CFG_PAGE_OFFSET +
+					     PCI_VENDOR_ID;
+		/* Choose the function to be read. (See comment above) */
+		writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
+		/* Make sure the function was chosen before we start reading. */
+		mb();
+		/* Read from that function's config space. */
+		ret = readw(addr);
+		/*
+		 * mb() is not required here, because the
+		 * spin_unlock_irqrestore() is a barrier.
+		 */
+	}
 
-	spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
+	spin_unlock_irqrestore(&hbus->config_lock, flags);
 
 	return ret;
 }
@@ -1216,39 +1242,51 @@ static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
 static void _hv_pcifront_write_config(struct hv_pci_dev *hpdev, int where,
 				      int size, u32 val)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
+	struct device *dev = &hbus->hdev->device;
+	int offset = where + CFG_PAGE_OFFSET;
 	unsigned long flags;
-	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET + where;
 
 	if (where >= PCI_SUBSYSTEM_VENDOR_ID &&
 	    where + size <= PCI_CAPABILITY_LIST) {
 		/* SSIDs and ROM BARs are read-only */
 	} else if (where >= PCI_COMMAND && where + size <= CFG_PAGE_SIZE) {
-		spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
-		/* Choose the function to be written. (See comment above) */
-		writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
-		/* Make sure the function was chosen before we start writing. */
-		wmb();
-		/* Write to that function's config space. */
-		switch (size) {
-		case 1:
-			writeb(val, addr);
-			break;
-		case 2:
-			writew(val, addr);
-			break;
-		default:
-			writel(val, addr);
-			break;
+		spin_lock_irqsave(&hbus->config_lock, flags);
+
+		if (hbus->use_calls) {
+			phys_addr_t addr = hbus->mem_config->start + offset;
+
+			hv_pci_write_mmio(dev, hbus->mem_config->start, 4,
+						hpdev->desc.win_slot.slot);
+			hv_pci_write_mmio(dev, addr, size, val);
+		} else {
+			void __iomem *addr = hbus->cfg_addr + offset;
+
+			/* Choose the function to write. (See comment above) */
+			writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
+			/* Make sure the function was chosen before writing. */
+			wmb();
+			/* Write to that function's config space. */
+			switch (size) {
+			case 1:
+				writeb(val, addr);
+				break;
+			case 2:
+				writew(val, addr);
+				break;
+			default:
+				writel(val, addr);
+				break;
+			}
+			/*
+			 * Make sure the write was done before we release the
+			 * spinlock allowing consecutive reads/writes.
+			 */
+			mb();
 		}
-		/*
-		 * Make sure the write was done before we release the spinlock
-		 * allowing consecutive reads/writes.
-		 */
-		mb();
-		spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
+		spin_unlock_irqrestore(&hbus->config_lock, flags);
 	} else {
-		dev_err(&hpdev->hbus->hdev->device,
-			"Attempt to write beyond a function's config space.\n");
+		dev_err(dev, "Attempt to write beyond a function's config space.\n");
 	}
 }
 
@@ -3627,6 +3665,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	hbus->bridge->domain_nr = dom;
 #ifdef CONFIG_X86
 	hbus->sysdata.domain = dom;
+	hbus->use_calls = !!(ms_hyperv.hints & HV_X64_USE_MMIO_HYPERCALLS);
 #elif defined(CONFIG_ARM64)
 	/*
 	 * Set the PCI bus parent to be the corresponding VMbus
@@ -3636,6 +3675,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	 * information to devices created on the bus.
 	 */
 	hbus->sysdata.parent = hdev->device.parent;
+	hbus->use_calls = false;
 #endif
 
 	hbus->hdev = hdev;
-- 
1.8.3.1

