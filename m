Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695AD606779
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiJTR6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJTR6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:58:35 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022020.outbound.protection.outlook.com [40.93.200.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3749A199F5D;
        Thu, 20 Oct 2022 10:58:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UG7bi673NeFE5higFOwrg+SLY3QllNwg4VUOKUYo3M+aYn8+IsLUZ1lq2QIwBgys/bysa9xOE4r/xtN39qrIQfGrfyaZyIV9T6VEv0Nacqnmak7ZKlDuGgQF8tUe/Z4vL84Yk78bdkMpPpL2/azNqZdGWrnBgcK8eOhBhvVPk7EWCU+XdYixIPqG2jSfUFzeDyQkXkYDBAIjlZQcLwvTX8QhtfRFdPNcqGVhmpZ8vEwcxQWF3vppOV2UleMqRllZodhUTBemWvH3SYtOiTQ/+lb2S5cgo1ORxV0KCJhRKgkQc/RM6Rh3i1r8OJ8QfjV6Fxw5IDvQliV3uV3pxq2tSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJO2AMMOaQWBR+6ivU1oD2mPgZ8IalvVP13hhcOhvlM=;
 b=FjzjP8emD1c3ap5Q2VHIPw1JIvcxnxFs4u6TMZ3azVyhwCpBbiU4c5vLAyBmzSEfJsjq6z/mFdSXMCYFoeul4ofrb1bgUsd0CSuCsCyponojtMffK3R77t4AfjCvJHKNQzppv7xO41bC/pC6Kk5oAdmh4fnNnUUYoE2I4dZ/9zu5qdbYdBN4pNjTnDSflm2/3iKoGIqj3RT0xBKgrH1h65xFOTfWI967yXgl3SnGH0Bxc3u+tDfR2eU2S7cjKXBDjfkSzpXSxUfjEYOflo/quKF+/FMho7WuR5eXoRtvMSvGqFC1HY33H1n0fyNDYgdxCPgbiRmA/kLkVs3aj1eR0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJO2AMMOaQWBR+6ivU1oD2mPgZ8IalvVP13hhcOhvlM=;
 b=jc+bvVRyI4NlB2EwQ0+GYv8UA7WypRCC1+MyQXSmtdflZ5tT+fQCF6iX0Xa0XAfYsfPvs8dGcDn/MzUpx4dpFgVX6xXdxia2NMvijD7yyiPaPlWbVH9CIrmcIW6BAmaCfGVRFXI0s6HM+NW4fJtk4F8rzRgRLUcqo0HBad+0HcU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:21 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:21 +0000
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
Subject: [PATCH 00/12] Add PCI pass-thru support to Hyper-V Confidential VMs
Date:   Thu, 20 Oct 2022 10:57:03 -0700
Message-Id: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: 04065d67-ebf4-49b3-b260-08dab2c4acc8
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bLz5gKCLJszVeSWSEKeyPNA1BaA+a67j+ag+J99PMeDm/gPI9yUZcw/D5s8DodYv9pW6EDcwAEb9u2fimJ0b8fAxpgFLphcsXPQbRDH/XuL7FogveXiIZqB4JfNviIfW8Ac7V4dBFekUJF33W6G87Du7DMrMsfdd8W46uIxO9Dal6F8/K3fKLAdmEVXPpc4mD4HDjKTxkHoQsp1kBJqr5w9BliEjIqOPj+kqcV6FaUVOrVmCUVCb830JoMBD/ppIcfjXNvVoVZSNNn/fhLcwpW/Jg0Kea8QSjD0g0NSgqRNQXoRcd8UYEVGY45rwrD6IB7PTJR/rX6ef+65f2UZ+BGEix2XpT5VbjILnrCA+z/qiqR6oylrM0LvysIr1SXD085xiV9Suk/w0Oe0CvW/m3N18UV8zHXbIXk20ByRgDSJ5Lw52WBM4FriA5A7IMRpMBLUAkLFVahZyBxae9KV8fHftnIFZnXaS4Ky9JKLgWUnkdFAyG8ROQKhAt9ZALubXCGeYVz/KDmilOTEX8AG5XKS+pKMgh6yNRLo355pKZzcAbMTe61CIS071mZDd4IgIym3rLtb4/nO/gR4kZlqpItM0I4n1k80kSywvqfVOgrlq2QHANa7+sOPWQiaXG6i1ok/6OrDiUHfoiJPtQdotOGI7kHy1r4ZWs9fs3od3LvyTh8ZnpzmQPoXiQrqbI4w14p58iDX8qHek2d36yZEsK25rXS3bJCxpvbj/QeOSFTnESrKsrBo+TFOgdxGcbq9ZBVLIHRU8smPu3EVEQX8UoK8GhJr9XTKleQRiuBLuvWOIcCd0e/0stbmPaLLfqW+Otwl2HW9YZgtEKsC7KewOsZakMrJp1OFeGWJopHidZpJkaA3+OuP7m+ni4zedbrhkQqRnUrvZ62oLNS/HS3Z1aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(966005)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUbuR0GqWShKof4aAuM1EB7pX5FwRAfJtzJTZV0gxKRIepCW5V4fBetDRPmA?=
 =?us-ascii?Q?gIOzEyFbK62marEJFimWSRoubKL75pCVInxYbkOHzKR61tkRWdZmTwv921Mw?=
 =?us-ascii?Q?esHurGmkf5q3PrH0l0cwepaLWQrDhEHZkBwXqTA6i1UeRp9Ddeodrl7owFL8?=
 =?us-ascii?Q?sUowYVF3EQl8kBgWEWr6YTyfIrOQlXPeHOCDjLpD/CvUWC8/un/A+x51NSY5?=
 =?us-ascii?Q?u+Uyzrtm+Y6XXBvyUOrdjPMAX9WC5jIQhwsgoSqZVhO1VodIcbj2K4K+Xadp?=
 =?us-ascii?Q?qcHvejvJRLYKXQqiZdendwRviBxQusRR05pt2X3MpBxm4vbLbHNojujLrNQ6?=
 =?us-ascii?Q?zs8E16jlZqErJr1RIJNF8O31fMy3BKRBRtXA6l1Gp+xtcN6KDgKG5B7QoDf5?=
 =?us-ascii?Q?P/l4DlL4SzHYytZVRx4SqSTuNPjmVyI5P4Z+aGW5uMCnuOUPnni8cHYdwyHe?=
 =?us-ascii?Q?8Lug0qwQTR31GTmZhcMMaVJJ2vP9bVqty8Zolvw4mGVGkOlxn3EndlfRMF/q?=
 =?us-ascii?Q?oPFjzNK3zraVDbSOWhH/q3WtzjPCaYNXDE0+qjg/7DQbZe78xfdIT7vf4Iub?=
 =?us-ascii?Q?n6FSQQlEtOJRaVU/Z553fE6OlJO5W/DxrItEfsGVzW2OGW/j390W7sc2Uk+1?=
 =?us-ascii?Q?EeEsPYrZdudW94y51icmC0dqsN27OAQbf24I3WbWbtUZNb4WfNLAc0VJvOph?=
 =?us-ascii?Q?1A7CY7nAjH7vTNgmG8khK8lN98GA39tms2WJZu+0teUIdtmi4QqB58bMTFTW?=
 =?us-ascii?Q?wpHzItfoPCAfmatvJqR1ieZTYkZJVKNYfIZektL6ektcRXnqbUmU1HauUx2P?=
 =?us-ascii?Q?2tAjozoq7T2nYWMWlEofXkrF2PMvMBo9BZaI3tgPcaxRznX8F07oDPlQ0ZEs?=
 =?us-ascii?Q?od08TGSa44HOyse0yhEqne7BT8t3meR2sjfHhjlQP3ev7VGboxYU03eQMoMK?=
 =?us-ascii?Q?99cQ15A8DVwbyIcDAu3je8GSlE0cW3XbIN+xZ0yQ7uIzzTBdiH7ZGK0jNIPh?=
 =?us-ascii?Q?CSApQjT7/pRct4PrhSP98pLKKZTA6I69lsVNzTdAhfR9U/b82T7b38kxI+zy?=
 =?us-ascii?Q?uhxvoCB/wSUhe/Vh6f+tVxIv4soVbqa4ZfDDf4U4F0HPB6Mz4wVCduI2NviZ?=
 =?us-ascii?Q?F2P6XboW1xJhxrlx2uCa6o90Dv/pGpJEpTjjE1x1XTvw0Uks2JWU5N1vGIyj?=
 =?us-ascii?Q?d1ytwB0n3PIfGcTmaN2UPgGq+evyBLB1hqvOn6nRO8Rfy6rCXiSMjk6snatw?=
 =?us-ascii?Q?/U9Awjg/mzH8LYp8gD5Q4Dydglbaktp2FOaSTbUNgB0UaGAM+bJh4/vi6O7Z?=
 =?us-ascii?Q?9ERIepwWL6/Gh/CfxzBwqPRoggB5KxCWNqDAM4i5T8YDashmaFCObjVPziM4?=
 =?us-ascii?Q?WghEatA+oGj/wNynC0IiK7J710BmQyQjiwqSDWJW1vikHZBcmonR71tbRTCM?=
 =?us-ascii?Q?lvab99387/h/yc4q77CBmIAORGYyZQVblEjQhWM6Pkzf6/o9kLGPRZFz9gX9?=
 =?us-ascii?Q?/CEckT8UN4I1c8PHF+3cusCZuH6BZqFcopT6qkf9VgqHyrp68VnBCQzu6ctO?=
 =?us-ascii?Q?Yic1zjb6TkIcSJjaKuh+OMQR/7wFPkCTPrBBaLxP?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04065d67-ebf4-49b3-b260-08dab2c4acc8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:21.0858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MedxN3Q9jXrig+m36wt2nONqruYGQf8ehnleHpMQlz6x0qsHXJBdA+vk+2CTbQMhCrmRHTd7jxDX5cNYKkrYbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
are changed to add or remove the vTOM bit just as with TDX.  The
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
needed, the changes to the DMA layer proposed as an RFC[1] are no
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
Patch 1 fixes a bug in __ioremap_caller() that affects the
existing Hyper-V code after the change to treat the vTOM bit as
a protection flag. Fixing the bug allows the old code to continue
to run until later patches in the series remove or update it.
This sequencing avoids the need to enable the new approach and
remove the old code in a single large patch.

Patch 2 handles the I/O APIC quirk by defining a new CC_ATTR enum
member that is set only when running on Hyper-V.

Patch 3 does some simple reordering of code to facilitate Patch 5.

Patch 4 tweaks calls to vmap_pfn() in the old Hyper-V code that
are deleted in later patches in the series. Like Patch 1, this
patch helps avoid the need to enable the new approach and remove
the old code in a single large patch.

Patch 5 enables the new approach to handling vTOM for Hyper-V
guest VMs.

Patches 6 thru 9 remove existing code for creating a second
kernel virtual mapping.

Patch 10 updates existing code so that it no longer assumes that
the vTOM bit is part of the physical address.

Patch 11 adds the new hypercalls for accessing MMIO Config Space.

Patch 12 updates the PCI Hyper-V driver to use the new hypercalls
and enables the PCI Hyper-V driver to be used in a Confidential VM.

[1] https://lore.kernel.org/lkml/20220706195027.76026-1-parri.andrea@gmail.com/
[2] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[3] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
[4] https://lore.kernel.org/all/20220511223207.3386-1-parri.andrea@gmail.com/

Michael Kelley (12):
  x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
  x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
  x86/hyperv: Reorder code in prep for subsequent patch
  Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
  x86/hyperv: Change vTOM handling to use standard coco mechanisms
  swiotlb: Remove bounce buffer remapping for Hyper-V
  Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
  Drivers: hv: vmbus: Remove second way of mapping ring buffers
  hv_netvsc: Remove second mapping of send and recv buffers
  Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
  PCI: hv: Add hypercalls to read/write MMIO space
  PCI: hv: Enable PCI pass-thru devices in Confidential VMs

 arch/x86/coco/core.c                |  10 +-
 arch/x86/hyperv/hv_init.c           |   7 +-
 arch/x86/hyperv/ivm.c               | 121 ++++++++++----------
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 arch/x86/include/asm/mshyperv.h     |   8 +-
 arch/x86/kernel/apic/io_apic.c      |   3 +-
 arch/x86/kernel/cpu/mshyperv.c      |  22 ++--
 arch/x86/mm/ioremap.c               |   2 +-
 arch/x86/mm/pat/set_memory.c        |   6 +-
 drivers/hv/Kconfig                  |   1 -
 drivers/hv/channel_mgmt.c           |   2 +-
 drivers/hv/connection.c             | 113 +++++--------------
 drivers/hv/hv.c                     |  23 ++--
 drivers/hv/hv_common.c              |  11 --
 drivers/hv/hyperv_vmbus.h           |   2 -
 drivers/hv/ring_buffer.c            |  62 ++++-------
 drivers/net/hyperv/hyperv_net.h     |   2 -
 drivers/net/hyperv/netvsc.c         |  48 +-------
 drivers/pci/controller/pci-hyperv.c | 215 +++++++++++++++++++++++++-----------
 include/asm-generic/hyperv-tlfs.h   |  22 ++++
 include/asm-generic/mshyperv.h      |   2 -
 include/linux/cc_platform.h         |  13 +++
 include/linux/swiotlb.h             |   2 -
 kernel/dma/swiotlb.c                |  45 +-------
 24 files changed, 343 insertions(+), 402 deletions(-)

-- 
1.8.3.1

