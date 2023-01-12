Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B48668628
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjALVvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjALVtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:49:00 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021023.outbound.protection.outlook.com [52.101.62.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3839B25D5;
        Thu, 12 Jan 2023 13:43:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFR6OG1oczv55QBeazEomPfUct/B5j0EAL4qjM0fa6vI+prY8PGg9Nq3b/wboSodoBgXFrgVOBRrqGSpbUskXR0FriemCg6kBrgdVBaMO9sxVYzWr2/66e0B0JvFxIxIJbqL049yBxKRF78KqMZLeO7HMWB/cV4HgH1/7mhLcdYv/Ad6s/uIJAF/f4ix8b1FDJHjGBLn4DT1RWf0TncIYugtesvCIJDdfe6M8aovGlMzqiIj1mXNs69W8g6xG26dVJ9XqGjHwJCYd7JLnfGZdFwa6kAwfnoUuUCH+KDpkVWWRcQJZAKminNrJAt/dVxi8Va5ArcdT4oLN/q50JzuSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGndZWQu3HNngqcEmna4NaG2bsukODbgQidpOqhCV9o=;
 b=MLCF1RLFuJs4ooyFuNztKMHzIjmeYMKQozzuPvaAfNVSZoD7IZdbWEmpEJ6UXnzavO+xN/Iuyj4OV1YWgo2ne+BctoHrr5hKLsvvEvbuRipbZz+d4ltSX30EjGhN/HZwSqWnRiGm2ik6tIAPLrJ/+FtMuy4BhE4sxSGK57hL78HFKHurFkZCFSJGOi3c22tWsgzbDplbLwMdp6QR/N5FJRiW6JRw3FUBny2HvcibSaEsFB89mO05KCGTmS6u2EO12IyBKNARSWqJTtu+KsT7rO+FUhlz0sqKkEs/tVRPgk5wvJ/BPk1uutjqaSe/kqOjgBomR6eTn/eTyRAfmhGMIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGndZWQu3HNngqcEmna4NaG2bsukODbgQidpOqhCV9o=;
 b=JGI1rCLknFNe2hd82NC3jIN+eNTznW6MQVcBKoxAsOAfMbK8I/7J9h7Tx7Wi2jTDIXp4evNMWo4TmpzMjQcCUll3ml0r1i0dWHJOPGoE186MHkpSvZOTWInv7u3BtRXy8TlyocnksSojZkA8AM6b1Vg6oW+huGxhkyYoMphSRyA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:27 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:26 +0000
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
Subject: [PATCH v5 14/14] PCI: hv: Enable PCI pass-thru devices in Confidential VMs
Date:   Thu, 12 Jan 2023 13:42:33 -0800
Message-Id: <1673559753-94403-15-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:303:6a::32) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1953:EE_
X-MS-Office365-Filtering-Correlation-Id: 59c0cc4e-f754-4183-bff5-08daf4e60955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ugl/mEAhPHzspg1xTRCCkuFWkCpq3vt+54qOsh8MejnorkAfYXgUQAA7Mt4AcWxKDb8i0iRwPY/GHZKt3OusGq28T4K1J7dtLNTF0/MwkpP9v4PS3n8I/Oi9RNBc3MD2IRBLAbce8wsPMMfepwHZN/Rf2NZmvFS6zKoODydiX1VJ2P2uAg3Dgw/S5BN2XnIz47BKL6A2zecswYn04Ln6sFIjudaoM2I5UxF2SoIVyhvmRv/XnOyveyyhDI50CLxd0pdpgNpPNUd8ZiHjVPb305QnkXskPJNRjDzsXy50XBJZnig0s77YQJjNvj5cgbmReNYHKi3mjW6YK6s4M69JRBjCc42oIhx5bzE7OJRs3FkptQ2Nub8dnmENp/02KPI1a+pE7J/l6KxCxZWQcAwkHOGbDh7fFrxWNCAVdWW1QdZd22mw53lGnVwRUzDJpU7MHd6//9IB9gm8fs9q07dATntp0ERnqYQtB5CoXs3vWIACX0eBrcEXwFeMELAq8eP5bE7DjKpVP547nfjEX0CXu+JR64awBO1n/0Xc9IMIwx3FzkjofkR5gzFYic2pV7h7gwqdNBRpZtXQp69KcCD3Bs9Rb9DoXZJtnD0TozadLAiPHx0T0lZwlLZ3gR2TwRIObpN5ODxO78yuwP4aK5gAnSd/wuYIF7uKr1yXrHnqoTdWubW0ppo1N2Qc1eg3nFTk11eBurML1TTDLGO+O5aZ7oKNf0D3OE++PrWbeegsBcrhE+MHpf/zajqXzbh3oloknQq7ESteNSPtkZx5mfqBc5KnIhYUwP5oh+PVurRUR4w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(966005)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MbwNvmlH6jPQ98GFNxoPVkfBGoRfPkwQJhHgwxyg19hs0uMJILaRgXJ5xyaa?=
 =?us-ascii?Q?AJDPDbbmRWMghp+U+FSmKAgi7MztvRFjLBgcHhnMnnVUWsrVzN6ekRzMkAKJ?=
 =?us-ascii?Q?kmsn0OMGnXYLH6TIahblZVQuCfJxE4iETINq2pClRtHB88DPwQGBoSqnVppF?=
 =?us-ascii?Q?rVDZPOm7r0LmeN9t7VQHaiUOd7iN5sk/d/ua+M+aT58XcZAyU9wY9DHjwvTy?=
 =?us-ascii?Q?v8wBZAyD0uA6jm7375HrP+46BJPGmPUj0/KxJm/Z4EirUNKI3EINznGwCOL1?=
 =?us-ascii?Q?xdgIa8JQdKn6WYCrjQfhcGSLw0mE1OqwgqKEeuVYpkWN0VGsB0ZAAz2jtEyM?=
 =?us-ascii?Q?zCUVGdVwQElILehyj482loMzRnzsTz3r1c+oPXsIj2O4b9uLfT5oMnhyXgfi?=
 =?us-ascii?Q?SeX5s864vA5RsAGtT3mDiuRLmWYErv1b/LOf08rFTUNr7ESr0e3VSZWM0UUB?=
 =?us-ascii?Q?1ela2+ywIFSsZWGVjwDmcxH/xum5YAkqbZkkt7wSSWjP/thjHZ0CmbufBrMo?=
 =?us-ascii?Q?3EoYvX09ZOvj0iCfcmNdiHoswvP+cmHcSp1fqnLHhq3rVJ09cxwpxc61WqIb?=
 =?us-ascii?Q?HDkFPwuhKynMloOIMoHifhge4eTsFrDN/8Cx8Xm5hIhGbqrlX89NL7sr82nR?=
 =?us-ascii?Q?57gmPTeyBIINtqDqgmjfvP5Gdf3IGkezBaxs4/qowc4nMvBDs0trnDvLrvtn?=
 =?us-ascii?Q?2t2kNo2L94a+de209Xo9b3m3HEVATpNpJoHUpDm9CDINavknby70lgJtgbFZ?=
 =?us-ascii?Q?D0CbR8NH5UjWFXvi2ZoYIiwnXHA+CLHrOCPnc+o5aFiFTcBPuNcjRUIHcRDm?=
 =?us-ascii?Q?dbbC/XpUX+QXJUUv7fQvrt7iO4bEiSiOpw8JBjv8c1PaSGRcqDGey+bYQHnx?=
 =?us-ascii?Q?hlQ3mHZnevfThTec2+4AkWfSIwWRH9Kl5koDZgwkMOaZC2S+A8jUukVrlpSO?=
 =?us-ascii?Q?3GcsR19jFG42PhC03znwF+HjJEdhBqvDWH8hmHY4Zv/MD9BWWFSJajlFpolk?=
 =?us-ascii?Q?VyFsWFc0jKmPGPPkJ45gTz4kulSox8vbfAsEaHIYEwwyTGPsKa8tpqjakbq9?=
 =?us-ascii?Q?q4+2xOXN5fWXK1vOiDwWUOJSS4YJTwxGtLlMJatIkBvfcT2EgDXpOdlyWg1b?=
 =?us-ascii?Q?N3rd12tCeF1bOM1NLRZa9sAAtwcgaKSM5s9gdjQKe1zNE+DO+fRAvth7bIQw?=
 =?us-ascii?Q?kuJ3EB4j2dvNyOjVDhI4xrYj4FexJiQW29/18onNy0xF7PXjDo3OCe+UmWo6?=
 =?us-ascii?Q?p5udcMIXb5rpGPINfiRk7JNyp1RNRhlB3ZDg/Q/yTqRhDB7d/pJkyYvz4QGn?=
 =?us-ascii?Q?I4EK/J4YB82N+bRZ/aHmH2RmpJ+TQB7ZxgZ7w3sHREPtRvUWLPrg0JGv/ahD?=
 =?us-ascii?Q?pWjA3hIBU3GqNac3AlFtLm6nswut6uUc6ddxUgR5lMZqXyh4pM825EH5CV4O?=
 =?us-ascii?Q?vOve0saz7I06HbT86jNYSXCSBZW+yUA1PtlGd5x5462rzCXCX4ECI2H5DN/O?=
 =?us-ascii?Q?AHBDQorygqi+vpoo6/+wCnnT5NPbKRV9jSULBG8scY4wgyyKcG3vPx5Jkf6T?=
 =?us-ascii?Q?51/Fhd7LGSMKD0viHJndibKUxpzvOVBceQ6+8Yu3?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c0cc4e-f754-4183-bff5-08daf4e60955
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:26.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AvwFQdhc8h5e2n7l5WvhI205IEkGx+er6w0hTh/TkrFirBB7a1F/p/RbGXTYfNPDFljUYxGbuDdI1rvo6RkG4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1953
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

