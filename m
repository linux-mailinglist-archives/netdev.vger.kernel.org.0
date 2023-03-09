Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D6D6B1978
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCICoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCICoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:44:10 -0500
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazlp170100000.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B116D4624;
        Wed,  8 Mar 2023 18:42:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctFP6jEv55rOifZXC1RocdCttjc2isoRcSPEhOkyKNMLjbXeuIUPrgV1xySyYKuFBhtlm7VI5MVRUAhKze3aWPQeg3cPZguuu7y9KmqRJDBBcSoLh3Cpb7wucMREvCOejCkdlHQPtLc/Qmb6fOMH2Acf2tiQFZwjlNTiOBoKdJInlDejUyPzf1dk3dKyGsAzY1qmkJErmO08K/kXWeAynt1wZjP+j6Gb85gdqimEYeDktuaAy4e7hGVBgl27WmZKAcq2ge65HtjpyS3W+iWIgzVc0hy66rf9eNtKBz3hsMZaAz7wS7I/LFQ7GUbeCJisz+kfSxsqSpXH+N9EtJEKVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUK0Dt9X7UjZw6PR2H6wPn9q+516BXWRDrkS9bV3108=;
 b=HCo1r9LexJvLaxxk1LM+mkgTuSNULx7oaUDMC1Z52UccawDXl5MHr2hptxF2Wm/wQKKspYhVwPUSnv//S4JwxyRcVPN0z2Tc8KSOM5ho3a3PzfE4T/ve/cZpW0zjGmREp4F2pAWNtnc+Dwr+LReBxkvfs9MW4KIwu5SKTUaMNyH2XlFbcxfsv+vaMwk2sdAI8AlT73Gwu3YhKk8yfvkYljx1sajxNnqoTU+c2mk0F7vJTLWKAXhYqsH/w2OpZYaHSPG55vFZsTWJ65YJ7t93MMgapGfdnqLK59weUMvN5FlPscBUi6oYpxSd2KzUOj091IQ0pAF2aXh+sx73d38Bgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUK0Dt9X7UjZw6PR2H6wPn9q+516BXWRDrkS9bV3108=;
 b=FT0r9aPlxlBRoaIjAPwGC6/bljHmXWw7Vl2c/o1sDHMb8Qyfhlgsm4THKsnw/lsYpSG1tDOsL8HEO7WeD7d1zfc2+57W9jIpBdTQIGQLBnpC1NxBZcgxyhjsHqTnU+5FOe7ETRXQz5bdR1M6kM9OQFhJ5a6jt/L4jE3+haQYAew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1985.namprd21.prod.outlook.com (2603:10b6:303:7a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:42:05 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:42:02 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [PATCH v6 13/13] PCI: hv: Enable PCI pass-thru devices in Confidential VMs
Date:   Wed,  8 Mar 2023 18:40:14 -0800
Message-Id: <1678329614-3482-14-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1985:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f579e31-8a87-4e96-a994-08db2047dce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JoRMO4XM1dCgpCZJRnNJGSOohcbfdyKpMQ17fwQBFPg6SV34QP6/r7fW+8npyvGsYrZftLV9fr389UDzmpV3xKlG3LmvZgmHDWfFDVDih5+T406XDHfuCUfrF4MXBbGetllYEhJHoNZwdm2VOYY48JK3Nrdi+Zj5iqKJgbbcwxwquVx/kpN4JCqxXSoynYm228LE5d2UapL8i5xywuqHqtNe+OLfc2C4buN+BOY9jyVwBsiJKTh4LZxRCztSTDnn4mUNwGES6uCKxcjB/e2rvXQZgzI3LWT78S81hbO0B9DRPkfAb/DMianC8xtKLPgHxQJMgvtHNCo8u9a9bP6eaH+ON9GrmX7CVXJD4m5+BO6mmrkBO2KMq5iOOIrw91iRJjLB+kU1+8zFSi8jqEYLDtRAbD0J9jdruvPNegmlXy5VmlRzV4flK9bq+/CB0dGekiGKNl7+n8yiD8K6Z7TSTCSciYiLLcYB4x0XuNE4mocTuJKhO4Tnk2pv6+FR7QyBQ4H3qirJWgxUsVbKrlIoBmkrG0UavKPjzzpfWwXRr3mTxJSSCN6LBgHGFMb13yGCswrwk3T5087dVmXUOOlt9WJ5rGs7h564KCGLYr47B0vR5jtRAidodRJt3fD9H2irO4SdPw0jH5fy6xWMgKTsqmEr8uvrRxuHvGx1QjbWgCAxadF3MZvo9Rn52Kd2N4BdiCnLz3MyNI6CipgrXdgwvfKM6CVcXH0d8ggpUwHLBrVGXtOX5mL+XqNl7tCLW51I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199018)(82950400001)(82960400001)(83380400001)(36756003)(38350700002)(10290500003)(478600001)(107886003)(921005)(38100700002)(316002)(6486002)(2616005)(6506007)(6666004)(966005)(6512007)(52116002)(26005)(186003)(7416002)(7406005)(5660300002)(66946007)(41300700001)(66476007)(8936002)(2906002)(4326008)(66556008)(8676002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rsap7eDLATwbBt+dv6cCRRQW0JHV1k5EjvviQwpe4CcwlOezGlVI2c86Cxfk?=
 =?us-ascii?Q?YNLfWKCilGsrp4VlVv1Q8aLgfqD6dlA1fJEpIAFJRZ1c/DQt+wf+hnqDWNm/?=
 =?us-ascii?Q?ivQGTnGCZ8dCdPIZBb9HnSnu8WnroFesrmn/az2VcJxcXL9PFo7b4SD4uOLj?=
 =?us-ascii?Q?UAtVi1/rgg48OFKOdZQmB4hIFLGJ6UlyyofuyjBgdnWy32dF/GVcR/LtJawy?=
 =?us-ascii?Q?ZKciJZH0+zLPwmOZ+u5yI643bMMRFvoOwZIH6OEBMmLnO4apA7BCt/munDEj?=
 =?us-ascii?Q?lrwYilrWZebvQHAELxdlS+/rbF0pVo1CxFWkWBKUkefm4fkJA0yffC5cJ/Ti?=
 =?us-ascii?Q?B7vBLglRUr5ZJgw/7zmONocIxx0ZpTGCwlTxtF7proX4MAxepM2DMYF/LNy1?=
 =?us-ascii?Q?opIVfk/WZq5Lm04O4L3EUq9zb1InD3Nl3Avu5y+03K9sWBHL1WV52oBSVijU?=
 =?us-ascii?Q?v3In2luozhpKy1ge2sYtoi6KnOZG9X83MS/GtG+F3ipdpaStcEBfSbnIKOQ3?=
 =?us-ascii?Q?kbCyMbb36cIIMH912s5okS1HABbw0KIqY2c+G4gvLuhxVecGhnuabbRvHW2Q?=
 =?us-ascii?Q?2oQFOfh11QZmG1mAzCUcPVZ3mwxxH4/ypYzvHahfXTIxwQcdF1Foxe0a0Ga2?=
 =?us-ascii?Q?tMoJ2vBaUec5u7d+KMOrCWBW/Ef14jYufiRvlXZypHm0sNmqdcODyS2Uv4p/?=
 =?us-ascii?Q?6Eb7zCCuWItMbPgidLTkAGP9oE1UcPFyhTmdz+KTSs5ID9DwJAGiFsSBIizF?=
 =?us-ascii?Q?s9qgszt1A9s3lg614foG2f+MDdquImQiLfAa/nhcYaZ96CcS4+CKZ9tRxhWb?=
 =?us-ascii?Q?2fKVwnNyqjKLxV2w5MpUxYzwx0VIYkNfNq9JUu9PgF9w9zJw1rKjEnib3DLi?=
 =?us-ascii?Q?QZZ2UarB1BP7LEyAGkP8kEqiACTML//gaPo+e+pfUiL27oJmP5PDlzXTWpDq?=
 =?us-ascii?Q?TcZ0f4XJIegvVqTBG1YCzjgDBoxn1mTuV43ZggqgymHU3gksVmwOcFb03H+d?=
 =?us-ascii?Q?Fh+zI65J+kP+D0baHHIordH9+ZyoYSObdrnWKkUeRu56ifBdqEjhT2GFzaGR?=
 =?us-ascii?Q?KKVOmuWWfgzFxYt1L3GEoCo9IWXJ2BcrBr07/ZkHlsqdP8UrVawpj4ObHsRW?=
 =?us-ascii?Q?mTXXUA/V9nk7+TSeMFC6NFLy3LP4mzeaQx4S6WNEMjrM09n02BhRGLyFEBJU?=
 =?us-ascii?Q?gYb2VUrjEIhBeI35h+5Cew67Vvm3hIyvFKw6pfJbKWAlU5SuzxaVXCcnI4UO?=
 =?us-ascii?Q?XtFbgOz7rgQf5dtieGt+M+hHI2da19gXI1ZnGfn+T66xaTTT6MzpwRmkTGxP?=
 =?us-ascii?Q?A9NEDCBn1jND2vgPbBDt4WBqkCKhG080s3bwWtaw2u3OwZZm9UVJzn09XwaU?=
 =?us-ascii?Q?T+lMH6wm4y34CtrisA+heviKq7AR8Q9GeGhY6HTsdUeJ4fl1kJ8umZidtF1W?=
 =?us-ascii?Q?YwxVMTjKPjlnItPaFrEo6L/WJmTjxJDZc0NKIvIsiGfViIh3g+18DWCeZp1N?=
 =?us-ascii?Q?Yc1ZFfXVQGhQV6UaHgG8jbhgVXoAbTP0JcJb4U71fsfVs5v8+x/KhmB/amBv?=
 =?us-ascii?Q?MUDKFPZ9BbNeSsk86CdCQBpTDaE+MJ+Fm3HcVNteQ05Mbyjvxj40cSpWgjvw?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f579e31-8a87-4e96-a994-08db2047dce0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:42:02.5409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmeg3N7UOHNYvTDVNqpNzDXzG54oLE3cb/YRysif1XavwoBGvaBr8HNXyl6pqEc6mMqtwnB0z+Ztz2rNkpMAxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1985
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index d78a419..337f3b4 100644
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

