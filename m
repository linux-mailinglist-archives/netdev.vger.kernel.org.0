Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4103F6067A9
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiJTSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiJTSAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:00:22 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0931E3CE;
        Thu, 20 Oct 2022 10:59:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YT2cEu+YSmC32yD1NlGgbOpDoG4C0suEccXyiuUiac0fEBry8d3xzR8avzuztm0BGIiKWFXU6z2b1e3IH3CEMQQ0cTK/MH2oFEl0sjvp5C2kXTbsg1hjZudkZO74IQN5nmYnfOQOmbsMjl513nTbhL635nw8WyofLwyzIwPPeRnolVgiKZM5wzzquJCLQzSxyfXgYDSDuj0vI5W1GKKhZxirBByGRwxlyAycVVKN90NhTcJ5oH8aCFMTSUxkQpZqdz5PmdLtZij/ux1NBOaiyEqE6uPbRQzeQgO3PXAdBw72zE2iKHBKnnnRseWC/88jEB0hEBBE9epyE/i4AuGi4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eljc1J1pgzqPiDTnuiJvXOgC32zjnxb/j3MncVDhV0Q=;
 b=UVnZC3vgnSxz1mL9gRQ6UahpHhcl7Eg9hbpvsCAWX9Kou4zCDEsqfCOqbChIeKwAEzQq2108SO++KM5P3OBwVdgvHyyEduIctkfuk4kkijOxO04DA/YARjLV9ilOiRdB8pVNJaAiR+WFAePf6+g2WAHm1HwkyabXz7JCRtQ+gokZDrA3dzgatfiehsCu7rEbQoa0Gt9Day6E1HRL4Ro3cWPNWWo6HyYD66cShH4vtQLEI2ggDy8LJdFPBOnCmgPr7qnT+J5KXB5kgQtSVHEucYqxHMD++CclGEAGbalkx3F6J/7kHIL4DFfeY4uXEx53k/40oMkoO/BVUeTDB7BeQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eljc1J1pgzqPiDTnuiJvXOgC32zjnxb/j3MncVDhV0Q=;
 b=ZqmBRy5CMnmqlOhCmZjLEqYKTiZ0/mGJSO/pFgVIceXyWjs4oWXq29vJ47Fg01yZ1+z9TD6+YHci5wZ/dxnwog/155W6qJtWzMl7YTcMSJbZx5Dms37GXJN5pK1UML+slgTW/WNn9Se2x7NYEE8Nrk2fjpZCqzLOJGbbR1bi4hg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:48 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:48 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [PATCH 12/12] PCI: hv: Enable PCI pass-thru devices in Confidential VMs
Date:   Thu, 20 Oct 2022 10:57:15 -0700
Message-Id: <1666288635-72591-13-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: 62a96bf9-646e-4679-577f-08dab2c4bd44
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJu1tWV4gZGPneFsojIUsIQUmGX5sta7AKjtuVF97ZAZBhD8pTGTWUOpJD52b7eSq9Og5geg/Sx1TVOmr9ERWPVqHCejb2IjbCjSRAdTb0baToWmZEWJD1YiBuImuwKXDi8AKdk8IvLzUP1+rjEdcTOmxtm6xYIG2paPhkt2jk7lFsIdz+iDioaoc41msGNQd5CrHm0ZKnVx3rXejx2rpgXUHfB3ViIZwibqSK1aXfl/EGw3ocmEf5hXF7bQJnBCt7lwSsGlWkRZMeoIm9A/UV+wZ55FWD4iOYf6qxRBn0wCl8q0r5i0BDVwSUq56x9THmTzF1CagLIr0ShDvKhBL76Ih/AdKOeW23FMEWlJqG+3y5SKqSvAXvBIMTrSj/eHa4FlMldsJIhcb218jPnfcu1HTphqb02bt8JUl0f+MML/ed0O/51BK0r3pMz8OIAlzKc7vC9bDukRlrDWtyg1xXLy6wl5PUXFmtuQTj7eyM9evNcLXOtJ+A1yVpc4SChb3BOMxCNpxn2pHjPpACbxSnXh8HCDZqnzCjeGIkTA0hJJG9sDzJq2SeZs7AR+17b6C5PNH+Wfx1a7p7lZjjdomvwWRtfLnPyz7kOZe0dyLV+48lx5xtIDILu0nK3ayjZMw/D8SaShl0OW4S8Ugv+fdLm7Xpdn46CWwyjbTzxEzuIfpzk+SHrjR+EKWxirYP/FOx4O9fXKjzrEWO3gF3Ht3YdfyhbTxhGX/LgDSAoYIQIkgQTzMqM3lF4YEQS/rRJbZoKRCIVUrgUaQqObV+3oOBD0M9zPGbRuFqVcg40BahBgydUK1T5QnTGaxgxmdZCNxBRMyIXWz1AU2uANlGYOCsrhlagMn1R0Mde58cfbpIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(966005)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vwstw3tFllf2Mv0HgkWocbnMIr2f4WoajhctaD6Nvojx9iO63d39hQsB2ehQ?=
 =?us-ascii?Q?KovLAQoq52rleousK1yt/T+nkhQMCeGAOboaB4rB3pqaUqYBkxfgi0E57yFv?=
 =?us-ascii?Q?N4djzjm1b2CbAo+D9eMhOH+v1NFb2uxntXTQPB3hl/2Gy9/3V+gTOdqgTpT4?=
 =?us-ascii?Q?L+cM4Xz6F5o3Qtz9VrMp8xe6UunZ1yZ1oZb2DtNuDN5I5YJGdrs4vPOr8qsu?=
 =?us-ascii?Q?lfXQ7EjPL3MdsEoQ0YAYdx0zCOsmxnmQMNJd4Ogtg8a2j5MIfm8JLd8dh2oo?=
 =?us-ascii?Q?ZRI2R3Ch7EJookrU7gr+6rIaF02k0RByNXV6WmaHrZpXEG48ZlD99LtQtjqm?=
 =?us-ascii?Q?gPQ6N4iD2kPrHz3eqvjMSVFZhmJyw1zyRbDErbKaqqgtRk0urggx1SVC8B1N?=
 =?us-ascii?Q?KX1xOS+z8UxU/9IRnxP8aajEUfIBEDtIHcQ+0GimJ86wkU/jlj+CU4g9uv4h?=
 =?us-ascii?Q?X+s0h2qacwT2/V/f0MDDzgAwvvm+cVTHzWu9hcmJrmZDF5zFwTkJjIVUpNz0?=
 =?us-ascii?Q?QiIIzqmowNfNRh+4qEWWmFREgGXIDG1hHfDIeOvQTZ5n0KcUXRoC8X8nrzCc?=
 =?us-ascii?Q?22mFSDDdqMAPkiUFVVhCC4Dcgcn6wGClarZRq5Nk6m+yx7VQ/zFHthIcxenm?=
 =?us-ascii?Q?xWC2niGlUbChrQtjMTr6Qs+hEZg3+/vJBKg9c5kFfwqifPKP2peTDQu7bPJz?=
 =?us-ascii?Q?MxK6+90O1QZuab4PRMY5NpNsnAkThbuCGuo9opoPi9h7PIEuPW9i08Zq/cWk?=
 =?us-ascii?Q?qoji79wKEDLSRq1l6iBRE3UiMRbHVVVB321L8uyqS+t9BVAN83PUIV2LS2Mo?=
 =?us-ascii?Q?V4rs2Hu4EKWWffL7cgykNKmNAHClTcof2NFIGn+DK5dJ5JP8DAnMn7/01ZQ5?=
 =?us-ascii?Q?gqQAp67vVaNhsTBVp2u079Y+238YhreG+0qDBJWptxqCAdYPN1jDllVMRX1H?=
 =?us-ascii?Q?WOyvu9WIr9lqwCjirbahKCB7dOYtng5IXCYtZUSINHCqQ8PH9sJ7Gg0xUGsx?=
 =?us-ascii?Q?QAZ0rRRhcFcE+OpXomzQWCB6z3t1mPzEgYWiv1Mtd05VF7YwdSywz9SKmYiJ?=
 =?us-ascii?Q?AnagOcAuBFhAzL/ij3FEo5jhIpuDd6luau7KanWNcAm1rsUjK0UXrhJZMvRP?=
 =?us-ascii?Q?iMF8APQxfBA0i8jiswccBfQ2thPrc2TRl9gCSem99iLHQ4dH95mnKWIU1YJx?=
 =?us-ascii?Q?dZqKH7fo6+0CxCzzQ1gy0PuNGVeOfO3gNP6y7ictcO46ugd2VxyiwwSmCxCu?=
 =?us-ascii?Q?zozD91/o+fYhK6WKhRjUs5rmIUfX2g/miau/dUDQoJatiPZtRcfa+qdcjkD4?=
 =?us-ascii?Q?avuRRfzHQbeG8gp19W3gz+LER2YqNbpQMYLVi3xaOl3ZzhVuOKoNFctS7UVE?=
 =?us-ascii?Q?mqLaeTpmfXqIiHHCgNwf2kVxOIlxgk1bl0zWrw1HHxvAtTGxCAvkIRlvdKLb?=
 =?us-ascii?Q?lp/k3J19EH8gnl8WRV5P7E0LjCr/XtJZIOBYMVOlwcpzih9ARldZXZFTtGtR?=
 =?us-ascii?Q?OjrkMyMmNSmpdAqrF7CLR/4eC2LdQ7y4VKbP7czrqn9MvGWhcml+e8w1tZbb?=
 =?us-ascii?Q?I8ZK1VpAlzxpRs5YVN902YpaWIhp0RqQZf9BYLny?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a96bf9-646e-4679-577f-08dab2c4bd44
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:48.7240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vm4QhGEEamMt09opXmUgztRVTfY3bvrnqnEKwx/aCbBg4zKfbwDOArVJ9+E3uuXw0Ax8AHL+kAHhJ9IhoIjJkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
---
 drivers/hv/channel_mgmt.c           |   2 +-
 drivers/pci/controller/pci-hyperv.c | 153 +++++++++++++++++++++---------------
 2 files changed, 92 insertions(+), 63 deletions(-)

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
index 02ebf3e..9873296 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -514,6 +514,7 @@ struct hv_pcibus_device {
 
 	/* Highest slot of child device with resources allocated */
 	int wslot_res_allocated;
+	bool use_calls; /* Use hypercalls to access mmio cfg space */
 
 	/* hypercall arg, must not cross page boundary */
 	struct hv_retarget_device_interrupt retarget_msi_interrupt_params;
@@ -1134,8 +1135,9 @@ static void hv_pci_write_mmio(phys_addr_t gpa, int size, u32 val)
 static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
 				     int size, u32 *val)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
+	int offset = where + CFG_PAGE_OFFSET;
 	unsigned long flags;
-	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET + where;
 
 	/*
 	 * If the attempt is to read the IDs or the ROM BAR, simulate that.
@@ -1163,56 +1165,74 @@ static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
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
+			hv_pci_write_mmio(hbus->mem_config->start, 4,
+						hpdev->desc.win_slot.slot);
+			hv_pci_read_mmio(addr, size, val);
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
+		dev_err(&hbus->hdev->device,
 			"Attempt to read beyond a function's config space.\n");
 	}
 }
 
 static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
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
+		hv_pci_write_mmio(hbus->mem_config->start, 4,
+					hpdev->desc.win_slot.slot);
+		hv_pci_read_mmio(addr, 2, &val);
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
@@ -1227,38 +1247,45 @@ static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
 static void _hv_pcifront_write_config(struct hv_pci_dev *hpdev, int where,
 				      int size, u32 val)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
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
+			hv_pci_write_mmio(hbus->mem_config->start, 4,
+						hpdev->desc.win_slot.slot);
+			hv_pci_write_mmio(addr, size, val);
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
+		dev_err(&hbus->hdev->device,
 			"Attempt to write beyond a function's config space.\n");
 	}
 }
@@ -3568,6 +3595,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	hbus->bridge->domain_nr = dom;
 #ifdef CONFIG_X86
 	hbus->sysdata.domain = dom;
+	hbus->use_calls = !!(ms_hyperv.hints & HV_X64_USE_MMIO_HYPERCALLS);
 #elif defined(CONFIG_ARM64)
 	/*
 	 * Set the PCI bus parent to be the corresponding VMbus
@@ -3577,6 +3605,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	 * information to devices created on the bus.
 	 */
 	hbus->sysdata.parent = hdev->device.parent;
+	hbus->use_calls = false;
 #endif
 
 	hbus->hdev = hdev;
-- 
1.8.3.1

