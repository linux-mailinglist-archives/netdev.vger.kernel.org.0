Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94AA562C7FD
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiKPSpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239349AbiKPSob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:44:31 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C05D657C8;
        Wed, 16 Nov 2022 10:43:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/zisvuJahIaQlxYEPn0XW/NK5EBhxuExWgvemQZeO2kD+WuK6YsnDvXOYGfFkN2cnAozEfXtQLcpzIdGddYeaOX0HBLFtwIgj9o52QELFEtH9llDXCTrrIAKdznaw4oHVvRmg5CcS0Q449sYpEsNYotlugqgsDeZFfPmIN2PF8ZbeGnl/cRSosslYNioNefzKSIZmm4pSn5J7DH7zoHTLALOVMfUQJFJ97+nTMvkmTFUVqJuR0eBgdYr5Qb9ht5W0kEPldstmLu7FuCRNRUyn2GFBlG39xk03Bo6JTMtPNQabGj1H+CaX4A+ybR03beQU6qecoQLIudmx0fjr8Shg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vfRKktGtusAn2CuHkYy3SoKI+4YG9f3c1x8BjXPr9U=;
 b=OIMN2rQw2/OuXtfkMst5UlCN+vwPmrjSBXzhe4Z4fdXPRvT7kugoun8xCNtyIhTpB9cByhKHffYV4lEpcGOKuoPIPP6MKx4NuZ/RDn/u4mqgNPcstfEXzhonZaCorCSNFj8lEacuqjQij081xB4qNa1dF61tY2AQzRZcMHscXB93XBpv/6CA42I2eOLwSRhOAcq7BzDX+gBBdLGK10unIJkNmzAHjR/kXzyeHQyXX6yerkrDEFUfMjXkFBnrbBCtev84HmkDGvy/1u+9gTrB/5+4NNNBumUs/X+EF99vdVpQ82Vq0cTPwxeZmpp1xBW5qspp81U8oxa7vT/8vTTP0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vfRKktGtusAn2CuHkYy3SoKI+4YG9f3c1x8BjXPr9U=;
 b=iw6eek5YreYKRY3hkm9ZcBEKB7P+VoE5V0N+XbYCpMPe/JfZMUrQvp/ibvLNWQ5gJEcw59KZZ6zM4tuKC75j3YTL8+94jndMAXWJT8REwln5WIQQH1ogvPzeEDyTnyzBCKzYkqkJOFdYgEPefVR/0IWqBz/nm+wzYzCus7NEbT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:53 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:53 +0000
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
Subject: [Patch v3 14/14] PCI: hv: Enable PCI pass-thru devices in Confidential VMs
Date:   Wed, 16 Nov 2022 10:41:37 -0800
Message-Id: <1668624097-14884-15-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM4PR21MB3130:EE_
X-MS-Office365-Filtering-Correlation-Id: 810e8982-f83f-4afc-8243-08dac8025ed9
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHHYlP8IT6S3zW8i2wWOWKUICfF+x8Vwdvt9OaEYViH4l/0vyo6kKKhbyxTvNbxoWqyhPtX6TqpYk8SXUq0F2RHJSDaKoSFFTO/rDHDN4ogFr4bPwP3zbTnnbMAxFHcSU3k7aDq80FpTkYELLTwq+FIl8zCbz2NMZxATKDuwglE/f10LLSfDm5e/2InlsOF6DWaCFXoKXf8BoObdYJ6Q95plt1Bp0aURtJ4P4UZG7sbLrrN67iLSffPKCgtq+n55KSJootKk3ujgFaZimeiRA932iyscYcyHfRAskKiDFdgyXhQYH1pJRFy5zGa8WFjhKKkl1/mzwY4ZcGVIiHZeFwuL17TALA9z/Jg1kaOsU2znCCXCJGMKgY63D85Hw79nwLX5cSL+IuYJMQv/jBYlAqZ1JDh7X3dbqzq9mGvyjpkHzs8O74EUxDtVGoxp+7IkMkr987cxiuLuevxWhWH8BRwQTVd9pGECXVGAA2RWpobV3e1AsapthPyolREZJIfDzd0DBUUNJPFzpiyfB2uLQMqMzsVwQK7A/0ojFbuZKODVnDjC+SXxo4jcRnqQgdApye3Haeab28Ymt/KEjedD2q46KGT4FzHlukALbXxIL6GT3Kvht/skbFbyfZktD20nUEjmCD+apvlcJX/kCocq+6oRPOmjXf9/QeRwF+WnfHf9PkNkx0QGtsl1bvx7SbgNqApVXxNXpc0mxvGW1NSOgodKZi3Orpm6bZgWMmpRGWk3WkjyZS4bUdhykiQ3EjeL1D9xhXHxzLVZsP9Okvtvw1x+rWvN4g2TlpbE8zILYXzBo9e35ZjAGa3Lm+B4xjsXY55SM9UFGWskBOs/csxkeWVZm78MQ5geSJDl99pA91A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(966005)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2v19J1g01Mi9XTJpsXdZAf6N+2ng4sCdq1w4xaXop+1njGjFvR3ZtVyMMXhK?=
 =?us-ascii?Q?x4RvUs5bKJPbWc2gjAb31kYxm40Kg0kxedpMWsvMebG7jHB5bnUEgHyFhk9+?=
 =?us-ascii?Q?4wKfDnE4Fm9wW+RZucsDQ8uCH+UO/KfW+V7Z1UhV8bjMzT2qQczh2RJDb9LD?=
 =?us-ascii?Q?InFmdpMjhVmNrv4tKI9YplxQ9B7RWeRYnkdvb+4gV1i3cSBxtcHFHH6fOjum?=
 =?us-ascii?Q?5BMZMTu79Jqzei+EZSEGtxHoiwwiAciBidJJ5oEitaCVysrJrnF6y/DWdwzT?=
 =?us-ascii?Q?IG1FICq2gqZd72bzAoTcKPaLXY6MLXmP1L9PUCT9kOndJOHXsqo/+D6cCj5X?=
 =?us-ascii?Q?YYfYBX8/lCInzws2st1D3OaFAfPn0pb/1cY4iffIrVMwj2Lf3ZhYmmDVSntK?=
 =?us-ascii?Q?ZZgG7FWWl2vKMx1kvq38o4zLz5cc4PB+tdinmImM1pyaUyWajfzkIeWJRw+t?=
 =?us-ascii?Q?9N08tAWcLWYoOJp+PIdEM7KvLBwsou8fXsD0umj6jTzBB3I3AcNYJkWp2K5i?=
 =?us-ascii?Q?joWX6t+IkHVkIbWTS4xBUgyKHGaReArwNR6Vi9LGUuRzloL2XPDxxF+ZJshv?=
 =?us-ascii?Q?MY7NgZkjDsjoPS38PQ6mvsEMnQh9yMPFYhHTGmYBOIk+X0SuvDic3TiNPIUi?=
 =?us-ascii?Q?8nDzQiBaf7Umg8HcNZarLmVwNnDAfaup8z97nUcB4Bgj0FPATI5kwuKdyQiy?=
 =?us-ascii?Q?iUgHraRCYsTaLFbYNNmqZQ6kbMn+dCgUOMBwfKb3U02jAkCjlN0+zTVoCjOO?=
 =?us-ascii?Q?vLyIdWEN5qbwk3ylJYigFtXNJVAUKU5lgsPK+/ry37kF17aPAnlmv3JHNHF2?=
 =?us-ascii?Q?+YsgQYuPnmqagK75OYKcOPi5vS8J0ecM6RImYVn4vwRVnOCA1Lfio21xYXKZ?=
 =?us-ascii?Q?hY156kj8HMGE9nCLZnwsamtrihNsy3y0jLK/Upk/nq+dy4DbNxrhBjtncTRf?=
 =?us-ascii?Q?Han1CFkpvVLXbWzZPVMEJdOhN0BEcph+exNjFwHN+cCNnkK9tiJTltF3lMg2?=
 =?us-ascii?Q?TmXNxmfAUtEUXffg3OszePM9LEXr2CY3ZGd/qpMbOcCfo76B0/hikhGhgymG?=
 =?us-ascii?Q?O39drmxG/IhJPAN97PtAeECKvlKFHWjnG9isWZXAs/cXEvudbuunMsr7Pnil?=
 =?us-ascii?Q?+CiTQ0UMlDbay2FISpdAFzVGac4JSYIkoY6sUMROMpgH9349jMSgohqhzB7N?=
 =?us-ascii?Q?0fptzBKS8vq4h9YckaLHxuzwfLD3c1iD8ufv3+br677Ca1ApvsUPyiKWiEjU?=
 =?us-ascii?Q?ZGcpSVbDXbr2MNiJNAfTYG9hcj4ZmZZoLJ0JsdAxpWW3Jj6YAiAEjTSvSvI0?=
 =?us-ascii?Q?oC3v3EZ+PBiOhfU60HAMlFIFgjudFmGlksGysBnJb6S2FbGsFPNwmINOrCkF?=
 =?us-ascii?Q?L8Kq/NA1lJvXjQDNSvTSKPm2fgXgNX5HzxbvBOhCePvtp6I5wjKlbOARh42k?=
 =?us-ascii?Q?UgWR6y2exv3Ssx1qKZCYDfhCQMbKMycnO79r4XXCfGoxbNRW/OZPndurc86/?=
 =?us-ascii?Q?vnEKxoScimviS/e8kdIrmjeGuM38lT8dCeVDnaQ7o6HtppVAd7lZApHUSRjG?=
 =?us-ascii?Q?CkFUlQz4mXyMrX3XuKEtD+cD8E1DQukDx6fp3VM7?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 810e8982-f83f-4afc-8243-08dac8025ed9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:53.5024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RzvLOWBwrOzPnkEXvVogFVP0+mpILUifXuXbio5b0xwn6FKFh+Y7pTHDvDGrOP6J+mzPGPrucWPNguVBp80jwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3130
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

