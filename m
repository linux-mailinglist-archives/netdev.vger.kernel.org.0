Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E550E62C7D3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiKPSm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiKPSm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:42:28 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022017.outbound.protection.outlook.com [40.93.200.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9CD2981A;
        Wed, 16 Nov 2022 10:42:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYxGCU1k/WhJuJB1n1hKlCgzANoBfcAzPfZpqt+d07WzLo83Xgsedm5M3IexfAPYvehyuqWCU54mJJo8TjpRDG47h8iRZIEys2737AIoxrUhy0KZgs6KvwauhVbntv6I2Apv3qX3OnJnG1AiS1Lm51uoD9ktyS9coDaHqxEHHCGTDqGX19mwrgs6skpS08YgoKtJF6g6Zwoh9yfeBSEEgZt4DBebN6d7XjHiGOSaAhmKczC40G2RIeYGdnosW8tQSiU5CfZpBIYFMpVwWKZkB5z/oSnJ+z9J+1qIsho980st/rhTkAu+VgVCz9EiNbYXeXhdIaZkCtDhL9sI1d/xAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvwfxgS31fToXnal/0+sDCK2ZCm2Rf42EyWzq64mDAg=;
 b=YOtrU3ptx+awGH7WgngXFJKIDidydxocuq6JODyF1tkJQHeQFyaD2ifttHV5OC67ybwwcsZJSdm4dsekeBy8ecP2wDA2fG/XHfgstkoA2KxKiMETTtQDpDyFCuKiowhFPRbjY30WWjcEJjxOD5B25dt5//XKz/FCF7Az2P/1DRxRO/UJE89vOcXuw1H7MLA9UeZxjwgAP40qsA3pQhdn7F499236qO04QJf93KfnVHlg/ozJ7uezpd09THHimzZ2ONLVOwU2LRsNxew4KGBP1XEG1Gg+kNa4BLeCpukmd/sfTCSDpbv/MWiv7QOSxzqJNlEqgVRv7LVVT0wLysVXUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvwfxgS31fToXnal/0+sDCK2ZCm2Rf42EyWzq64mDAg=;
 b=BDVMBAqypn2F0w9Y55vV3tlobZtQSrbur19zmscxlRimEKVFBakaPxRyiYnAdoqLrOMhSSPuKSRZcEJtCOnKKHwF9goU+VA6mczGvg4uB09Rxnay93/hUDrBa8S/1IGW9ROTZyai6xcrwPJMkmoG3mIBPI+bl0qTqZ2J7YLiczw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:20 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:20 +0000
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
Subject: [Patch v3 00/14] Add PCI pass-thru support to Hyper-V Confidential VMs
Date:   Wed, 16 Nov 2022 10:41:23 -0800
Message-Id: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM4PR21MB3130:EE_
X-MS-Office365-Filtering-Correlation-Id: c09ef50b-13b3-4296-adc8-08dac8024af6
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bhAN27IWcHx4hrgn1qYz9ch7+ggpCTrvB/9032cAN1Yijt9yzPN94/eadJEjI3HIM3IyduBHS8jx6NDzXR/duWsWh8VjaEaF19AvfwlxP3g66kGvy4VX3PX95Oix69jF0fYHhwdxzYrkDn/90HQMm2WL6TVsBT+JPPtTDvsFFCyH5+mFZkV5bHDAMRaymnDltiVP7RinglFk2rNDfMOyOR22ac8rFNIF6Tiyaw4V4U2mdVLT5/Rt6LIH0ssMPjQXYZBGLD0N3Aq9AGGrMNPp6X6EtaAuBlSMUlIUpHrj62WoBd1CBEwqxDRtUFqI9MDeW+ZMlepRY3mI5DpHdcnLMt0q5LjgvbfA4aV+1vCLckvmj8RZbjFidY7la9sXiVujUoM08aH4BeLXJ/drHhRhwos/iXRsU64oB2TlRWRyKAAmlhYpx231mVq/KRJSPcPnhqtLtZbgD/LD1aEWfdNDhGtBA6y2zrycSJfIVJvWBXEPh00+pOO2Ml4WoOqjo707iQMR61mhu69ecnd+95xFvalLIY8YVMAaxrda15pLA6zW8bmEBNbxbjaS6RAf02iOig2lGU0L+k9XwoEWva8iAFmXv1Dr5eNXcmF8m4CemFmIg+PwMnrTJG+dFBjct4dNgCOJQXYkCTs2x7j3A7TcJLk5KAdG1F2JBXiDtXDrZiU5SNqKYXcM4nDVPGtpuJdJdXz0ufsAsLyDQak3/A1r6B8004RoTNuGkdd2OjbFakPYjRiMfhCZ9/n0ygRpPwet4npGXFNmA2g1Ev0g0wVGFDmiwNnHQD810HjCYwTqEgemXewmUjC8t8gp9a/iYqhvRKmBIZJ7d+B55eF8ygv88IJF0e0a3oEgKyZXPeu9eAPTGbTMhvjXVVrVGNGp+6wJzEWZwxvYXBku/J2ZLDmuuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(82960400001)(966005)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6lwkB0pzDE71WrUblmVTJebV1KOHULmsi4dwQW/ePxZeshRmyo9qtfZ3hYLe?=
 =?us-ascii?Q?BUhzDYdn9CRDDsh9Pzucezxhi4EhupsIms1U4acO7TIRuZ28aVJK4agW083O?=
 =?us-ascii?Q?sDnGgIjNlmO8QfZPu3tP2IojNaALMnAWUgeNuJcsLJTAxVnuJtzibue9wWsA?=
 =?us-ascii?Q?4utQwYrFv6mxEY243KAkBLmzmMDgjt684DEzbodW38uNzCC5Lspl1aR1uOgF?=
 =?us-ascii?Q?hxOJPV4ib+Q1WewKvvzs/8mA0CkdTeuIsKO23QooB7ymXUjPUMmVvwClTPDn?=
 =?us-ascii?Q?ZBMsxolU0Zl8X0KBvMrGiQjJO4rCuoFWAKmaI0WgcAP/2NZylJZTt9SSNQqN?=
 =?us-ascii?Q?/S3owRdmdwvkkEj+kry6jH4z7CoRYeZWHp2PMAyiS8sjzsFIj6H8Otg887dk?=
 =?us-ascii?Q?q1/11Mo+edfQbcIahOyAufQD5DJkXEBm4zFd8K474pacc0tIncHt44l+xP9I?=
 =?us-ascii?Q?FfKBGBPQgh9cwivHlQBZ+c25XUl/sNiqbjOCiRVUHGJnRqx8Tu8yITgggD6S?=
 =?us-ascii?Q?Qewu+rfyVc8c0+MIkXEvSUjtN8PKDOS46hbVLZeK8j3FDzGtYq1pu2m6gO/R?=
 =?us-ascii?Q?rr4oJcZ32DxwNihNlOt0slEiXKSJKucXWN9k+5VN0GZ6NTf3jISeab0m15aZ?=
 =?us-ascii?Q?+z1voI1RwdSUvO/VEJsWbUAGgDviMGOHS53zJIEX7YPgqT53ytk33aF2bFRb?=
 =?us-ascii?Q?ND1oxHGjNCwTAOrPPZv+1iYLn+AiJzwgu25rJ9B5y3sd2kS7IdXcdMcQLixQ?=
 =?us-ascii?Q?OGsJJHYIIT5kR/PIfCdd5Sgm80VmtwFwl9xW11OUw6Epdh/oFtGtDuLOLvbr?=
 =?us-ascii?Q?KYD9ovyZQEyP+Kz4VPwn2F2e7mHh1mJj1gN3SKhEu3GpgpnLb8gv9bpR5GT1?=
 =?us-ascii?Q?bfB03Wves9lcXqNufPzJjM8hXegTiH4qcoqE8u2J65wG13B0fOgpYftcuNcm?=
 =?us-ascii?Q?vEhOM17v3ELBYHHFTxfVpi4o1G+bJ/tXZg6ZZZevyeotoKD0X+Znc7HLNETa?=
 =?us-ascii?Q?KLwbWkhKl/DO5Gwnvri2lErRsmDsW5wSemI+NRs/xsHx/oXSx5L/hRZETx/V?=
 =?us-ascii?Q?siTYPedRx6AoNPRCayGP/jJehBKeMn5pUiw1qJoUOsbmz8W++F03AqJLnXiD?=
 =?us-ascii?Q?cG9sXd9WKbOc5FOjdEs4+80v/ydNbDtlCPalXyj671lbU5dbKeZ27pb/zX44?=
 =?us-ascii?Q?hwoTAtnmnh7+y0M/A5h7kKq/z3SMe4rH8RimviKSKsl3+C8qOP04SAuTQWUp?=
 =?us-ascii?Q?3QW6jUwPPFa8jF2P6EMXaIvoGwHGrXm3+NqHmWv7ELt0m8Ubbf7ysEc+iZGl?=
 =?us-ascii?Q?Utczk9mMS+FhTOB/XgqA7rYh3VeeV+CiWIXepjDqJJ+5QEdZfYYOzITxklBk?=
 =?us-ascii?Q?pr84IedeGiZCvJlFQQCz+UL79XLOkQF4gzB0BS8k4wEBGrKX6yw3/f+uqQJd?=
 =?us-ascii?Q?K5MZQjI3/jo4ZpAFsuQQpRKuBGjQKSAIZXCO6jt8CXGIgJbIncbLQjpQOSX0?=
 =?us-ascii?Q?fOjTya0QsYXiYwAH/kSDdHVPJiWZSeQKvjEY6fK2Z8rgUQ1oOE4P20d20+0D?=
 =?us-ascii?Q?X7kCa75DI0tkl5KoUqDyf74ZRrQuItmhckvLcgQE?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09ef50b-13b3-4296-adc8-08dac8024af6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:20.1403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBo4M4BGG2LbN9CJjmpIyY4RYsZVs7i0Q7mdqNWWn9cR4FuMcqr+8VhYCyPCfZQRlPU786pkIOvRa75qwDZauA==
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

This patch series adds support for PCI pass-thru devices to Hyper-V
Confidential VMs (also called "Isolation VMs"). But in preparation, it
first changes how private (encrypted) vs. shared (decrypted) memory is
handled in Hyper-V SEV-SNP guest VMs. The new approach builds on the
confidential computing (coco) mechanisms introduced in the 5.19 kernel
for TDX support and significantly reduces the amount of Hyper-V specific
code. Furthermore, with this new approach a proposed RFC patch set for
generic DMA layer functionality[1] is no longer necessary.

Background
==========
Hyper-V guests on AMD SEV-SNP hardware have the option of using the
"virtual Top Of Memory" (vTOM) feature specified by the SEV-SNP
architecture. With vTOM, shared vs. private memory accesses are
controlled by splitting the guest physical address space into two
halves.  vTOM is the dividing line where the uppermost bit of the
physical address space is set; e.g., with 47 bits of guest physical
address space, vTOM is 0x40000000000 (bit 46 is set).  Guest phyiscal
memory is accessible at two parallel physical addresses -- one below
vTOM and one above vTOM.  Accesses below vTOM are private (encrypted)
while accesses above vTOM are shared (decrypted). In this sense, vTOM
is like the GPA.SHARED bit in Intel TDX.

In Hyper-V's use of vTOM, the normal guest OS runs at VMPL2, while
a Hyper-V provided "paravisor" runs at VMPL0 in the guest VM. (VMPL is
Virtual Machine Privilege Level. See AMD's SEV-SNP spec for more
details.) The paravisor provides emulation for various system devices
like the I/O APIC as part of the guest VM.  Accesses to such devices
made by the normal guest OS trap to the paravisor and are emulated in
the guest VM context instead of in the Hyper-V host. This emulation is
invisible to the normal guest OS, but with the quirk that memory mapped
I/O accesses to these devices must be treated as private, not shared as
would be the case for other device accesses.

Support for Hyper-V guests using vTOM was added to the Linux kernel
in two patch sets[2][3]. This support treats the vTOM bit as part of
the physical address.  For accessing shared (decrypted) memory, the core
approach is to create a second kernel virtual mapping that maps to
parallel physical addresses above vTOM, while leaving the original
mapping unchanged.  Most of the code for creating that second virtual
mapping is confined to Hyper-V specific areas, but there are are also
changes to generic swiotlb code.

Changes in this patch set
=========================
In preparation for supporting PCI pass-thru devices, this patch set
changes the core approach for handling vTOM. In the new approach,
the vTOM bit is treated as a protection flag, and not as part of
the physical address. This new approach is like the approach for
the GPA.SHARED bit in Intel TDX.  Furthermore, there's no need to
create a second kernel virtual mapping.  When memory is changed
between private and shared using set_memory_decrypted() and
set_memory_encrypted(), the PTEs for the existing kernel mapping
are changed to add or remove the vTOM bit just as with TDX. The
hypercalls to change the memory status on the host side are made
using the existing callback mechanism. Everything just works, with
a minor tweak to map the I/O APIC to use private accesses as mentioned
above.

With the new handling of vTOM in place, existing Hyper-V code that
creates the second kernel virtual mapping still works, but it is now
redundant as the original kernel virtual mapping (as updated) maps
to the same physical address. To simplify things going forward, this
patch set removes the code that creates the second kernel virtual
mapping. And since a second kernel virtual mapping is no longer
needed, changes to the DMA layer proposed as an RFC[1] are no
longer needed.

Finally, to support PCI pass-thru in a Confidential VM, Hyper-V
requires that all accesses to PCI config space be emulated using
a hypercall.  This patch set adds functions to invoke those
hypercalls and uses them in the config space access functions
in the Hyper-V PCI driver. Lastly, the Hyper-V PCI driver is
marked as allowed to be used in a Confidential VM.  The Hyper-V
PCI driver has been hardened against a malicious Hyper-V in a
previous patch set.[4]

Patch Organization
==================
Patches 1 thru 6 are prepatory patches that account for
slightly different assumptions when running in a Hyper-V VM
with vTOM, fix some minor bugs, and make temporary tweaks
to avoid needing a single large patch to make the transition
from the old approach to the new approach.

Patch 7 enables the new approach to handling vTOM for Hyper-V
guest VMs. This is the core patch after which the new approach
is in effect.

Patches 8 thru 11 remove existing code for creating the second
kernel virtual mapping that is no longer necessary with the
new approach.

Patch 12 updates existing code so that it no longer assumes that
the vTOM bit is part of the physical address.

Patches 13 and 14 add new hypercalls for accessing MMIO space
and use those hypercalls for PCI config space. They also enable
the Hyper-V vPCI driver to be used in a Confidential VM.

[1] https://lore.kernel.org/lkml/20220706195027.76026-1-parri.andrea@gmail.com/
[2] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[3] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
[4] https://lore.kernel.org/all/20220511223207.3386-1-parri.andrea@gmail.com/

---

Changes in v3:
* Patch 1: Tweak the code fix to cleanly separate the page
  alignment and physical address masking [Dave Hansen]

* Patch 2: Change the name of the new CC_ATTR that controls
  whether the IO-APIC is mapped decrypted [Dave Hansen]

* Patch 5 (now patch 7): Add CC_ATTR_MEM_ENCRYPT to what
  Hyper-V vTOM reports as 'true'. With the addition, Patches
  5 and 6 are new to accomodate working correctly with Hyper-V
  VMs using vTOM. [Tom Lendacky]

Changes in v2:
* Patch 11: Include more detail in the error message if an MMIO
  hypercall fails. [Bjorn Helgaas]

* Patch 12: Restore removed memory barriers. It seems like these
  barriers should not be needed because of the spin_unlock() calls,
  but commit bdd74440d9e8 indicates that they are. This patch series
  will leave the barriers unchanged; whether they are really needed
  can be sorted out separately. [Boqun Feng]

Michael Kelley (14):
  x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
  x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
  x86/hyperv: Reorder code in prep for subsequent patch
  Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
  x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
  init: Call mem_encrypt_init() after Hyper-V hypercall init is done
  x86/hyperv: Change vTOM handling to use standard coco mechanisms
  swiotlb: Remove bounce buffer remapping for Hyper-V
  Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
  Drivers: hv: vmbus: Remove second way of mapping ring buffers
  hv_netvsc: Remove second mapping of send and recv buffers
  Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
  PCI: hv: Add hypercalls to read/write MMIO space
  PCI: hv: Enable PCI pass-thru devices in Confidential VMs

 arch/x86/coco/core.c                |  11 +-
 arch/x86/hyperv/hv_init.c           |  18 +--
 arch/x86/hyperv/ivm.c               | 121 +++++++++----------
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 arch/x86/include/asm/mshyperv.h     |   8 +-
 arch/x86/kernel/apic/io_apic.c      |   3 +-
 arch/x86/kernel/cpu/mshyperv.c      |  22 ++--
 arch/x86/mm/ioremap.c               |   8 +-
 arch/x86/mm/mem_encrypt_amd.c       |  10 +-
 arch/x86/mm/pat/set_memory.c        |   3 -
 drivers/hv/Kconfig                  |   1 -
 drivers/hv/channel_mgmt.c           |   2 +-
 drivers/hv/connection.c             | 113 +++++-------------
 drivers/hv/hv.c                     |  23 ++--
 drivers/hv/hv_common.c              |  11 --
 drivers/hv/hyperv_vmbus.h           |   2 -
 drivers/hv/ring_buffer.c            |  62 ++++------
 drivers/net/hyperv/hyperv_net.h     |   2 -
 drivers/net/hyperv/netvsc.c         |  48 +-------
 drivers/pci/controller/pci-hyperv.c | 232 ++++++++++++++++++++++++++----------
 include/asm-generic/hyperv-tlfs.h   |  22 ++++
 include/asm-generic/mshyperv.h      |   2 -
 include/linux/cc_platform.h         |  12 ++
 include/linux/swiotlb.h             |   2 -
 init/main.c                         |  19 +--
 kernel/dma/swiotlb.c                |  45 +------
 26 files changed, 380 insertions(+), 425 deletions(-)

-- 
1.8.3.1

