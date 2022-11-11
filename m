Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EE4625386
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiKKGWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKKGWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:23 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022018.outbound.protection.outlook.com [52.101.53.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD8A663CF;
        Thu, 10 Nov 2022 22:22:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLelYF1r1+JEX1LadeeJ/b+hFJuRDpOWEAgw4z9QjTCd5vk38cxXp98uu2qbCXtkdPO18+vH1azyr+/76w78H6fKXBY8aZ2VePejoiudr+o7ytTZPCLcxjQ582JlLSMogN3dClsbWnfkEoV0ejdNpjMIm64XZb8aiJAtvaBgC0+UgCSrDZ/9QIOmMvyIftV6k1PUf2rWayl8HWbCCloRbSlEZFDowJZBxoZJul3F1D1S1h1o89ReZ4S8RZUQxgocVvrWFDh6qxBkp6tqlQxqC5SOPdrVbTBZTLHgA4Jk5WYGD+A95wGuxvBvvvhK77d6wGMH30hHKZqr0Z0/G8zBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3HhMK3z+9LYIWEVDiSqYzVhym9msgayXbL2cWDGX9o=;
 b=mJNy8+ufLfL4pgSTMc2RmfkEShN1OyoB1Jcp1uteB9UmEyFGSwOM8KhxOTlvv0uK8Uwa9hLlGSepoDlhBX6ElpBIhwVfdEui6wr/VDKnQcuxgqIvHeonFuqRu38RqibPYbQqzF3i4Nc06AtnEgd1imvXuK3DeoaiMpC6GUqX3VQYdSZKWsdio2YzMpHEIeksvfY8IYpZymdSDOxJUaG5w6EEK/FlPICRpl8RfnhdcnHM6JymD9oeZRwozyzxLYoMCHtp3uw7CTM5el+FYlrShTZoSvWYBlNBDxoO8J69+ZEhNzJVZvTAlYsHkNuKsWOnPE7U1fRGZC5XEGRPKBkiPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3HhMK3z+9LYIWEVDiSqYzVhym9msgayXbL2cWDGX9o=;
 b=LdA0w94MlAdqTmZnFBLUcQQ2GhjtreKbNnJCGtSbWBlS4JOIzXFGTMGu3RczYjYL+FpHwikWvbe1lI0SsgTRwNTSTsk5QvbWVvXyElEA00WT+jy9Nt9Dt+eN0ywEwONj2zSREJtS3N63XXYeDG7u2nT7gA3T2izCeZJZ/kODLHQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:09 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:08 +0000
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
Subject: [PATCH v2 00/12] Drivers: hv: Add PCI pass-thru support to Hyper-V Confidential VMs
Date:   Thu, 10 Nov 2022 22:21:29 -0800
Message-Id: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: a5cc2c1d-d8e1-45ff-b4dd-08dac3ad0f6c
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PbWGQkcw3whk0cMpiFSXlegugWv4tdCwVfe1vHKODpHP8w2jHavj4Xv2HJkgzSLfm/8/5wxZWQRp9C0Ef7yrPJiHko6sslQ3wovK0zXU4cO66s3LHyFhD3e1pVinSKjHMfDXUtnZhM0cCYThn/FM45SogjX11quSp3OIYqVqunEsDrj+fpSOmWm588Ia0lIDuG2ntN5vtuLIk/94oUOea061g0VrlC5fZp7b11LNMjZF7GYa4etfNpTl2oGWrT7Evax3L4lNwKq7b/3A3MNrHT43zQPar16iQtf/nkx0/HwdDAuN0zdM3pBSWD0lOnqLwgFvc1ztSYHWEGwpsIFtQAUUNiYGCq5egbszDYg66UGN4zsl3MQLN3O0EWwONEF5NVxJklYcY14jx0eZ9oXcvCsnViyqkS9DFfC9l+slsamqOr5uXlZKgM2jaLWnB0DSguAPFLy6PqkrC00KF5pW3+KT8cmpQU6BntzbZv/3DimEZTZZOO8to+fomIN/h3XrdDG5MAiGHJs7dEPhA2UL2w0Ibiy9dYVd/5mdR1UlXRJKVodz2syn9fXVqkJMq/0XvkZVqh/QOA9UsG4mrC1CL/tjgFXyxxkse21L/KC1IkEYBqXZPUS2osNRRFASVz+7pTVsAck9aLCKtiFsfuMvgVDo08rZ7ndlLbAcdd4DWJ6woVEJejhjyMsF3ghZHoYHg9IoTcWrnZN/m4P+lgInPhz7xEOYjTwCgrEsrbTKlMT+7Un/c6YuZ5LI+e9a7xi/ChH/Vpk3AzxtjfTNX0sZwQu3VrUJ7j+U0m77lygTtiLcywKbdLk2okE2mVmjWQ0CsTG91ON4wcA96v+Nuzn3qJQO762vJM0xpaK8GPPIlyrS2eA/chCyGtJbbDpkCcLV2jr94LDSIOf2Cg+7FjHLnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(966005)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ufQA+92Bm5tOKtXrdnwRrwInUbZC5f1fK9zZGinaq1IcGDo69WsDk1WGlsGj?=
 =?us-ascii?Q?NFunbmN7Y/NwKKHdetQ2+WuRMinnk2T0rXiDi2Vrq1yViKEy0RlR21Tn5kv4?=
 =?us-ascii?Q?pJdGhg+lKmjVkacgfYn9RA6809JWx07+45xtnDupiJbydR9sYo8jXN4VcKBb?=
 =?us-ascii?Q?2lLemtNQ62lX6rBttK1r9lgiFA5tSDPfHTDJ+4vkzY7n7K+VaWv2do3qtgMY?=
 =?us-ascii?Q?Or4MalD6/X25ZxjI83BaD+dLqw6d6QM9JIQN6g5xOqsxUxOMrUGnmRdG+2ic?=
 =?us-ascii?Q?bVUpnnBlgEBhBXKPp+sruvCylKD5WLgh1qUTLCKMbeG6Oh2Dlq1WOPXsYJls?=
 =?us-ascii?Q?Gr7eyZRhDqCkj0862nEQtGL5Fs3JSke7XgV4gBID2Dvo9YW0Ss26oqM2KnlL?=
 =?us-ascii?Q?ZAutvCA97IQOvFJnMHxwytygEW6ChoCKn+eo9wObxxhAVhoKsZlGDVc1gFh/?=
 =?us-ascii?Q?auLwcowvEcKaeF5lz3vIGcLkuiLt3lf11gvjj45bR8GqJKGOtyIwyaNYUidI?=
 =?us-ascii?Q?bmvO7PCpQjtAkuSJYOgXwuADYKuOpcffM8aRsscBP2S/rvc39MW/IYYAF0Pv?=
 =?us-ascii?Q?Yb1koCWhBJyunT6AcA5Qh1W08Da8Pfi4XST93JztpvZzTyg1+jwt6c6jki73?=
 =?us-ascii?Q?C+Uc6MD+BUJhtbg0LNePmGLg53ZRkSeaZJXP+oZtpFRPDuSIp3uY+QI/391T?=
 =?us-ascii?Q?8OBQ0WaUcZZqDywkwZk/Q3KRo2Qn7QtKX0hVM4BhV5+sju6edr/csHFL7rky?=
 =?us-ascii?Q?SSMT/ScE3+VOhmdWd3ioMOXiwvWu9RcQCliRE8EnAVuy+M5aCgVtewV/nB5J?=
 =?us-ascii?Q?gjqw/o82EEoKk1lfnZMtW7qCpIK3WfiNTTjN0T9RNtKZsCW4IPB+AeRY70E9?=
 =?us-ascii?Q?AhO4usmbu2qtZBwCXq1U3J1KlXJIW0NsFlJac74OjrdfqHH/Y1pKiZ5zVKSq?=
 =?us-ascii?Q?5PiErGKcx+HY/ORT39DLBQR3RDuJG7+8eRRrM1cKDoITlxSs8atocnxZww6s?=
 =?us-ascii?Q?ztkHnkYqzdghT+EsH54/kfPnQNfwfHBXDjG9rNyyBk9zksgcMmi8mHFE40xH?=
 =?us-ascii?Q?nXU0V0Ucv1Ll7gTq/3I60HuMUf08GLztVMizY/0/62WXp/w1Iw0WZPHSYlbR?=
 =?us-ascii?Q?puni3Ori15TJf9gXuiAcL34EbM5O/QmVz9MQM84KAV1M3nQXecoH4GuuYtrd?=
 =?us-ascii?Q?NLCnk1VUzBKriTnsFZeJDDSUHEmjS7KqtBLJ9IfwZ9XWZR91N5Ibhztm2uGt?=
 =?us-ascii?Q?dfrNdO/VaFVFvpyIk2+IBb1spNbzMyxUe77S7p5cgrUr7gvpWAE4b/qrCkNF?=
 =?us-ascii?Q?Nem/bto+/IDcr0814Sreq0QYpBGMOtfA0XmnuyQrJCz32anNSJ8NZnypXOiG?=
 =?us-ascii?Q?Xs3rq0rVU+BMugfL2cXumRLzy8I4tHFzSrQEMx6L+u74kZ+IkJN47tu8IX1H?=
 =?us-ascii?Q?Tv2nuol0PIcbFM5cgNOkKnhloxpzfgRP0VPgLSFXtsK1sN5oXvaZC+O9X4YK?=
 =?us-ascii?Q?U6E7oGwOEnkeeMitPOiVKhPwE1a1Vjq1f9fvPQlqCQvP9Iv0XetZwnVK/MD6?=
 =?us-ascii?Q?CpSVd3vn7KE9w8KniCLSUtLdF9yqeV3Wy5ZZ9B7WSJdJLHykJUlo6+jqsy47?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cc2c1d-d8e1-45ff-b4dd-08dac3ad0f6c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:08.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ViYAb52pzuDovFr8L+ae1s9XN+7Xj2pS03v3EavAzOV1kRywDuPxJUFgLZAdN5JK0GucTwWcLmyDSsXMVV+89A==
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

---

Changes in v2:
* Patch 11: Include more detail in the error message if an MMIO
  hypercall fails. [Bjorn Helgaas]

* Patch 12: Restore removed memory barriers. It seems like these
  barriers should not be needed because of the spin_unlock() calls,
  but commit bdd74440d9e8 indicates that they are. This patch series
  will leave the barriers unchanged; whether they are really needed
  can be sorted out separately. [Boqun Feng]


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
 arch/x86/hyperv/ivm.c               | 121 +++++++++----------
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 arch/x86/include/asm/mshyperv.h     |   8 +-
 arch/x86/kernel/apic/io_apic.c      |   3 +-
 arch/x86/kernel/cpu/mshyperv.c      |  22 ++--
 arch/x86/mm/ioremap.c               |   2 +-
 arch/x86/mm/pat/set_memory.c        |   6 +-
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
 include/linux/cc_platform.h         |  13 ++
 include/linux/swiotlb.h             |   2 -
 kernel/dma/swiotlb.c                |  45 +------
 24 files changed, 358 insertions(+), 404 deletions(-)

-- 
1.8.3.1

