Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8849B6253C6
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiKKG1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiKKG0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:26:46 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA488BF47;
        Thu, 10 Nov 2022 22:23:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDL6YZLl0JrWEIS1KY8tinsMfJBC7LL6iy9Hh0J12kAMz3KOx3PYdBinorLPzbC23Nv8EG30+6hKhQsHPVGfDUnWfEX5yfT2V4zgqRhSy38TojV7ySqUDmilyxApqbPQ+AUHxebxSxlGMpLjImJQLStmjqp4a1kAbBM7ukPK2OwL8b4AwxwW6jhwLKYq/7s7St07UmjfyfxAXPR7qhbttDD9XUrigwGkjnhCawu+fWw/ny+2svjdj7qKUDoil0slqRkTTy6N03riL94dia3MBTc2Kwkt87kiFldZMm4TQ48cHdQ1XCOsxf3SzpIGzcJ/PGdH9nozP+kCimYZYzcyCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vfRKktGtusAn2CuHkYy3SoKI+4YG9f3c1x8BjXPr9U=;
 b=Y3Up6zVbbaKNYW9CWyEJ7KyGIDNK8BGsvsFB/WjTh2ugqKj0m7VmsM3n4WIK2biK7Z8fUXL4F03aM9NPc7NkqtJ6VI1I8ss1SO4MtsjE0QnsHYY5BoJQtBmPil0Dl9YKAseeKHVoiUwIJhs4yWnw5r6AL4UbK2w8bcdus42Oi3EsKM+lbi0TBHqPJmIgv+vF1X5S8ENxhgmW3p378oereWbLeKUBqg1a52+TcRh9Sgcgke99xgErJAMLCw6QwaXKpofTICpSGLHReIRyJnIBt8r/T2QVQXyltn9svMxKn9pgYVwwWxhE/GWPdBRnMrYLcU51ErO7YXtBmDL12tYhHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vfRKktGtusAn2CuHkYy3SoKI+4YG9f3c1x8BjXPr9U=;
 b=GAV3oE7v8Aap1vFNmCyDs19WaWsTlY7eEhckD0FfhImEhG2kXKwRoJ+iOdnzROAYWZcRKEFkMfDsJz3TGy5B9qSkfKK3SiKAQ+oAROaRtscPz0vt7pnP69vMpCwMAedpMcDxcFuSWN3CKgvfQGVQq0OTQglLOBVoW702zqXPVXA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:36 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:36 +0000
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
Subject: [PATCH v2 12/12] PCI: hv: Enable PCI pass-thru devices in Confidential VMs
Date:   Thu, 10 Nov 2022 22:21:41 -0800
Message-Id: <1668147701-4583-13-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: a1e3d493-6603-4beb-c515-08dac3ad202a
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6dLEXvJhw3Hv+YTYtjwlO4FqoiUlslw/7fjhKItZ25HyixIzuqbyzp8HO7Qcv5NP0LWi3xRh+Ntytt4/AS1gT2wTZm6vKdR6vc8QNKAsE1MW+FreYOrUZ0PnSYWrvZlbvbZpSwdAZhXM/v6IOU3tdI93ttocIfVb7iyS0z6ioFgSc/IIoi0fsDwa7k8gQZ3aPEPAwQTN8o6Y7C/Q8O9RMsDi5TRXXx3eAkiqq6H8rs/bBIBwlWwMputLrZR/K6f+iMGB2I9tC8Q0JWv0s950e8zcC1MEfYKR1c81+w0aIQmmq3OigSOaeLJta6iYU81QDs1IfzvwQT7pWRUcK4Kqv2ePPegsGPnmywFmZhJRT+Bity1nR3wQVNBdNhr/g95xD54oPdrMe8gMcjxsrP1ZUsZkgbaL8eKBvWNpoL2e7JtddQiIe4lP8uGbyIZfsL94JTGYsV20PH+64HsAogSf3I2usftT/Q8uEKUtxkmq2CmCn4YWMGppxKZnVTdruTKO59J75X+4HqqqlmDOmLiU8ppWX7/9tvdxOfde0PcSYyUAYruLc4tfmMlJaWCQPPSXuRZC1HXL+5/6YLtGie1KIlvOCdK0rldp6oIqoGeRqjwvnuC3fnSB9IK+p5ZAAIlHcgi+tVF/5pHmdE2cxSQUPFrqs1I3SCUHDW+pcYNK+/QHX4aa7Uqj5DmR3ZDZxEc2ZOC4aZEy849StSgDs+bwLmRbqf3pau6S6e0DeFBFezztQw+89TGW0EbdNe5jniadf0hCGv8MfFmRCuk2UgY0KznI6xu3qNzNc843L5tvZLgITdanmKRnist5qX58N+XCoQJ1F0z9Ndgt9O97faHhnXdISypThIu0o/HuiNhMRA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(966005)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t40nKXbEll/pv94uG4XiAhccctpehCFbCqcIMnI08ih7fWzKoIKLTtYjUURW?=
 =?us-ascii?Q?uX+uTZncQVd5JGEtEAiJF9aRsB8YOvqVht9ARCeFMsVeTM93/M4jtuu9gjtW?=
 =?us-ascii?Q?MLvJd8Hawkm8SOh8/rJQl3+ZrKheUH2Dcxk4yZnck8R3t3KB7w7UisukvgzP?=
 =?us-ascii?Q?tB38IT4oEPObntCcvfN/nO9Isu9EgWnKjNgLpDU5pC/euDMA5IrpGHu5KxCh?=
 =?us-ascii?Q?oyjuDkosIZJnFGgT/1OMroJK+yFRol23yYHWz6AybpvOhmDg/7arXYnxTyC/?=
 =?us-ascii?Q?HHTgN2CB3lDcQRo9MZ8gLQHZRTCJCfh0uq/IaKbW6ihdVW6o5TY2Ur6A2/oh?=
 =?us-ascii?Q?otUlXXZw9GTxT07/Pcpzr2FnrqMSZcnWYLVfzWPCP2By4N6r/B7/ai5Cv8HJ?=
 =?us-ascii?Q?SW8dmpILVaTOTkbUjKw4hp/dFr8zMESffkdIqz+iCF5SNGMrL3xorUXvQZvq?=
 =?us-ascii?Q?NDRKlnTN0Pu8VqO1139SMplvveKYxPQkDtjLadnZ8XtPsAd/KEHdDXccWhqa?=
 =?us-ascii?Q?A+iroEvWWAq7MLfJKfFcRk5ZDKHPOi7gw6ijsU92m9vGAA4nNGQXiSWN+NuU?=
 =?us-ascii?Q?MdqgZ5vRITTQnQAGYDDYgLl59wWSsPo8I8OYI4T0hUSMxuO9F+v65g1+9gCg?=
 =?us-ascii?Q?FxQS1M5AUsyIi2ucK9j0s7D7guSmRY7YuHto4wCCp2EKavba1vXE9Z1llbJK?=
 =?us-ascii?Q?6tZ6ZKIUJXGxHSRbFHXX2kRGiA2ZlPN14zHcs7SIxhSiXOfOpoTBGpmND4lS?=
 =?us-ascii?Q?+G8b++tz6kQMWNfSmVgeppX2VM8a82nJdanPtvRBiplGUM+tB14p0XAzV6Aq?=
 =?us-ascii?Q?NMBCX5t66YY9ZmQmLExYRq0NJiYGTIUxfCb7gGVo10HpwMZpw5l4PXaksN1i?=
 =?us-ascii?Q?SvHnms+V18njpkpEBAyxMpq7tl451xqVNW2LS2b9+U52fBSp5ujNW1NqzJH6?=
 =?us-ascii?Q?kxRpvBTSrkBX12effhPNwsWey2UBCnxmZLlLLpRkjwvYeH/9yaENSGsSSPmZ?=
 =?us-ascii?Q?g/Yj30Sesnt71pqNhDh0Nvbd8cwqMFJuKWDZ53+3Ij5YOOC7r+VZX8Mdt4fi?=
 =?us-ascii?Q?62lkontgtJCRM9WlM6+J9k9n+veCOL9vXeLfvAFx/zTXuxRs4Tq5Lso3Q+lw?=
 =?us-ascii?Q?jSu2AcLfUVReYUTkcAObVRqjUcP5MD5U2VYqnuUdVflYU8hhlmJbpQj+huMT?=
 =?us-ascii?Q?PTnT6xJO5RimagWf2ESiKpiklHalcLK7f/vPBbatJVSYTLBNvNAxx7C+9gjV?=
 =?us-ascii?Q?iFYXdtU/ep200CR3/OabH+62lrtQ255SYiseEkR0Y+wVlN5TWEo7HBtZqPHv?=
 =?us-ascii?Q?ZdXRyZhjrJI5BVzkCioc+YcEKIggMyrOjSNOdMM9fT4Enr6B7Ri5jKZj9Zq4?=
 =?us-ascii?Q?Am3hBnOCX/SKTAq1R+znLc+8leSZs96RWKpRoOaURwZK71rpa3kcvc8RLCV0?=
 =?us-ascii?Q?kddNDO/fdDNjl93taO0xV7n92dxtaQaOxCTC7k/ro2L/13ymHziG7dtJrMHG?=
 =?us-ascii?Q?7IIYCMlRJWL/C2qMsaSfivU/9BL7lRnQ2gWQuVdLNwZKVnK70mXG8lN9Tev0?=
 =?us-ascii?Q?S1U5BVXqxT8hZILu72tTOdyUJ1tfnYfiiPH+MIWikoFr1Gx7fqk43t50wRBg?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e3d493-6603-4beb-c515-08dac3ad202a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:36.4810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzwHSP8bHTjp0BSFZNcfnU14VY7geNXCsdnZdm4DoEWumVeLW6TaS9bxmb95rlIoiTsniDAMgo1P67arE/SfxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
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
index 5b12040..c0f9ac2 100644
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
index 09b40a1..6ce83e4 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -514,6 +514,7 @@ struct hv_pcibus_device {
 
 	/* Highest slot of child device with resources allocated */
 	int wslot_res_allocated;
+	bool use_calls; /* Use hypercalls to access mmio cfg space */
 
 	/* hypercall arg, must not cross page boundary */
 	struct hv_retarget_device_interrupt retarget_msi_interrupt_params;
@@ -1136,8 +1137,10 @@ static void hv_pci_write_mmio(struct device *dev, phys_addr_t gpa, int size, u32
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
@@ -1165,56 +1168,79 @@ static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
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
@@ -1229,39 +1255,51 @@ static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
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
 
@@ -3580,6 +3618,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	hbus->bridge->domain_nr = dom;
 #ifdef CONFIG_X86
 	hbus->sysdata.domain = dom;
+	hbus->use_calls = !!(ms_hyperv.hints & HV_X64_USE_MMIO_HYPERCALLS);
 #elif defined(CONFIG_ARM64)
 	/*
 	 * Set the PCI bus parent to be the corresponding VMbus
@@ -3589,6 +3628,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	 * information to devices created on the bus.
 	 */
 	hbus->sysdata.parent = hdev->device.parent;
+	hbus->use_calls = false;
 #endif
 
 	hbus->hdev = hdev;
-- 
1.8.3.1

