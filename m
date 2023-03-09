Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121EB6B194B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCICll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCIClj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:41:39 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021017.outbound.protection.outlook.com [52.101.57.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B405367731;
        Wed,  8 Mar 2023 18:41:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAKO7UZQOh2s/vtnFCYaWLCB3MQlIjxWMWQwDJciIDf5nEcPgRqVmGb+Bc6Vz3/GWJWvhsKwEGdDzPlLZEH7JjZUkuFbbPm//21EjA0tKwMX5Q1k8GM8CecEQxY6Ctt4OX+dVIuHJWJU0XautXOGS+bfuW37cuWAZIpAhhDQt0IjcTv+Zg3J3/SrERzMolp0QepiidN1XyG2Di2vEk/0Br2U2kqpvQgQXKmj8nqn19ztPm2/UjT3hc5y+yhishZ0iWLF8dqCUKKKZznaNKSE/ywOjsw412ZVH+d+4JJPvuR+wHPRQPbUFjiEt2XJr2zPQKzbdeJmR/SP0gI5wTPBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtHBT112wmXDVhDD0/izLKJ98FKcdBuGkaQjkCSLXzo=;
 b=kouACpXNo0WwgzG27DxI+EEOJx57NWeLwoGW7k5j7ufwyOxf7X+Ore0G7BH9f4+ZvqBaW8BW+59jkSwUjEuLcX8hMUhC0PBYNNUmVCyvKhkh6fdF0xa6pW3Jiq2MG+FwfxNVQ6mIHXhpOShO6b0HNw6zviG2bRvi6Bsvxov6Phmfi73BQ3uO/0FX9/gJJvRkwaJsHzOWMdmxk+rYSvS5nxxMc9BYt8ykAq/ujvJaEpVHEgfaIvUb+FkCkOqPEgfhaD741AwF7oq4aSyzJGE4+8VeurPmuKjvgDvlc6AaCgkDBvIbWDFzUj9TJgZkie9Fwt16Hf4sElm/YHJQgigtZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtHBT112wmXDVhDD0/izLKJ98FKcdBuGkaQjkCSLXzo=;
 b=CdlW1R/4XXzDmxHxAR8N2DSuTH5M9TqTAOztAw71eFw5/MiLHZYbbKrVwWaOQJasJGATDEPhbKpyPJy50PDaBR2ubIEB2K5IFTKRKpwBQqXL4U5ha32BRsNnBY7EzVw6ZBrthGUbXlnsX9gLiFwjvELYHRb4TYLXfISheQBAV9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:33 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:33 +0000
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
Subject: [PATCH v6 00/13] Add PCI pass-thru support to Hyper-V Confidential VMs
Date:   Wed,  8 Mar 2023 18:40:01 -0800
Message-Id: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1313:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a0b8cd9-b7e7-460b-8675-08db2047cb7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hPGvlaDwpSmF5Mp2JX/Bgt0V5v7GQssFQtwNOPeRhCNFtL/wP4G1bF2fZaHnCy/1OIoICJut/roSa6wolo8v+l8eKvWbHyjygWVYsRd6wnUnvE1Zo7tLGVA+CSBE5k5EMy/DU0JRgWa57AQiIU9KiIDLNFu5/RhIRuICit2IiipfNYRJaZScmfnUlF+msqunIrQpw9jqGo/+o7geM8y9ymkDRz5m02E+06xEk+/EJydsKc/t2sgrOvff+F4R+P48wbfO05Drtyz/FUzWWqZ5XLm+/1fXk7VWdi0bgD7AEJY7vUXgXGucwvLEKPXlv3yLM/bH7LXKhMblsUA6kWG07MWs8yVx3lcD+p/LaU5Z9D8E+96kSItpx/tpn+vcZFW+al6aN/lSTZtiaZs8y9UwGpltIJZluz3xBqD3mFzOlK96BQTRQxxZeAEC3gsqzP2f9YkZD3EsTD1iaT9bwCQbl6p3Oq5Fx0KvHvljCRXH/CKNxi0B16wxYY3A1nnVG5It5dpsqCCW8uYRtKMjyh+rnhgbeZkUuzM4rg5ynx/Ju8Z1rqcvrheZCfKw8O414njwwWvt3Zi6tEmA40CNZF6hkPkQhjM3AsvzhyUvKWLvjGtP64vKcaesSoMzlaZoOCFrfrbGXUGOG/XWIy+Q/S8B6Am6k3rJEim7Dck4fyWfwymTMva1Ftt8+5o0BL27o0pBOO6zMrOiLBOnc6ZZrKsmNEvJLQibZEiGTkqanEk16ixWIxbvw3xb2Tevi/eWe9ff+drFu3SpuLpRCwVtcLEsmNrbYlJ6La+9Jnw//+OtouM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(966005)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ckPuat/0rm3Isndw8fF2Fu3IjBM587XW53FrnkYCnM/dXx6i6sYeJCH1iDOr?=
 =?us-ascii?Q?OZIpIHb0u1uPD8SAUDqj3cJP/4UAAqBbRPhgQqrpZ/tPZ6e6O+OcuwkOoocO?=
 =?us-ascii?Q?tiLRXDjPdL+cqop3hZZZW+NTbr31x+QDio5A7m/0HZJA8Qn9vlu0EDPhhoiq?=
 =?us-ascii?Q?07rl3zPnq93fhYnTTEiEfbWij5gA0Txd43hAGJnwmHd5D/bQ0RZObisl1l6v?=
 =?us-ascii?Q?Tty1l3caNxTowdsXUKdE/lO5AGXja+tbj0nlT0MI84xL4tldAxpazJXk7B3G?=
 =?us-ascii?Q?OCvAxAmDo44MYG0grBBUqPv4w3EGiTVy1sPfUGXuVNk8F9KDlnV72joK/gfG?=
 =?us-ascii?Q?2263myuZjDNv0duA7z+/KRzql61cwocG0x1lC793txYgL2gb+pJHTEH59+BY?=
 =?us-ascii?Q?8wx5mqOMOUL42uQ9jMCebwHJ6cgzvroNA+G9lTrq3aLGhZ6RmDiuMDXMGRlT?=
 =?us-ascii?Q?v4AREEmVrr5QWbiPvh64eCCnl3JyoZ3JhT8TS+ugsVNiuSgHbxtOEpmBTzX2?=
 =?us-ascii?Q?ZkawRR3iJWHoPMKYl6qX1WLLkiOHrhGsn/S0XGi4GL8npzyvGVFsBi1phs+B?=
 =?us-ascii?Q?6zM7p0WRx+knl2ZunwsGxM75dYd+B9La8+GD18rG9V6s2zG2VbudRyrx5pRO?=
 =?us-ascii?Q?CuFDRYQSCRJtjP6UxZh/Jn/vtN564xj3WF/VzYIwoUEcZImTVrI1SrFQ3F5I?=
 =?us-ascii?Q?YMLU/PjIq0ksI0oz2YdiG96RFoz3YeR5zsaNlj31q1Tp7wrhyXKJR19I3VEs?=
 =?us-ascii?Q?OLUjMS3WDzl4leNL/8vZHaZnq7KumlUWYvyRgdPnKiBlQo6AkltbFvoRzZng?=
 =?us-ascii?Q?n5aSa7VRel2JkeS5m+uW/uLN8Ip0ksxMbq44gPbH+DE4fwWQH6pO7TbT5ON+?=
 =?us-ascii?Q?GDy6RcFLFhsYiSRsz6l8Wo6dr+Z7Vf+Rh1vXi2vpNP9M3lmYFDBkglPI+AzX?=
 =?us-ascii?Q?Jfm/V4wWtYdIOXjY0GUwHGjrEgGf3+F3NO0DwDkHhFS5mwAdl/pd1TKhz+98?=
 =?us-ascii?Q?m+h8KQb1pwCVMHoBscAamDTE6l0XSvf8uSg6lj7iuaiPLah/NDrcoC94tnLW?=
 =?us-ascii?Q?ELSfd+aexPPlCe5ZvrhQN+nOf9gJXfwFIeVGic+cE7DfTEM5WeRKsEnRsO5t?=
 =?us-ascii?Q?ggRboj+4rvVLb9ObmVLbiZ/RG/5IBNehGPLgFDL6FmyOxdJPpe/jz3Rg0NJV?=
 =?us-ascii?Q?eV1vy9ylF/kavAtPemyQ0/wjlL6EH8IpOc4UmLtcB1UbJ4BhWZD+s1Nzir4U?=
 =?us-ascii?Q?E8sjk1MKEjZmlEwQh2lKHVFTXN8K8ZvnKBlB0B6w7qZ7RQIbtUxpiNcMd2wQ?=
 =?us-ascii?Q?trs8tuh2yHuAEBdal+qW4YctAbgz2adWvXD0Rcnv/i6D3H0FJfP6Oah7Xtm0?=
 =?us-ascii?Q?u5EXu/p0+C0JRDTHB3oHh3pa9oI46XzFJSPoUqojEESCn8FeO2CUjcVBzGiS?=
 =?us-ascii?Q?hrAadKqBPBT4EBUm3W2dD+VYmLTuAZxlhI83jwgIHOpdYEvXXO1IoZib8HQo?=
 =?us-ascii?Q?LqGq2uBTEfjpSwLiebn9g3fweSF7YMO2geqfKCWaLlvu/cCCCqr0XysThxfL?=
 =?us-ascii?Q?+aau75qCe6a6qbpeqqzmkyrtKZhbIeczzg454rKOeLhEjJVYKpVLagiqriCA?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0b8cd9-b7e7-460b-8675-08db2047cb7d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:33.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hggb9iOSBNpIuXy5BxhrG7vCjKyhQDebKwrhL6ZBuwgW6djSzmWBBAvrHZ5KKHnQ0+/wT+3i8+64RlMWtbBu9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
address space, vTOM is 0x400000000000 (bit 46 is set).  Guest physical
memory is accessible at two parallel physical addresses -- one below
vTOM and one above vTOM.  Accesses below vTOM are private (encrypted)
while accesses above vTOM are shared (decrypted). In this sense, vTOM
is like the GPA.SHARED bit in Intel TDX.

In Hyper-V's use of vTOM, the normal guest OS runs at VMPL2, while
a Hyper-V provided "paravisor" runs at VMPL0 in the guest VM. (VMPL is
Virtual Machine Privilege Level. See AMD's SEV-SNP spec for more
details.) The paravisor provides emulation for various system devices
like the IO-APIC and TPM as part of the guest VM.  Accesses to such
devices made by the normal guest OS trap to the paravisor and are emulated
in the guest VM context instead of in the Hyper-V host. This emulation is
invisible to the normal guest OS, but with the quirk that memory mapped
I/O accesses to these devices must be treated as private, not shared as
would be the case for other device accesses.

Support for Hyper-V guests using vTOM was added to the Linux kernel
in two patch sets[2][3]. This support treats the vTOM bit as part of
the physical address.  For accessing shared (decrypted) memory, the core
approach is to create a second kernel virtual mapping that maps to
parallel physical addresses above vTOM, while leaving the original
mapping unchanged.  Most of the code for creating that second virtual
mapping is confined to Hyper-V specific areas, but there are also
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
a minor tweak to map the IO-APIC and TPM to use private accesses
as mentioned above.

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
Patches 1 thru 5 are prepatory patches to account for
slightly different assumptions when running in a Hyper-V VM
with vTOM, and to make temporary tweaks to avoid needing a single
large patch to make the transition from the old approach to
the new approach.

Patch 6 enables the new approach to handling vTOM for Hyper-V
guest VMs. This is the core patch after which the new approach
is in effect.

Patches 7 thru 10 remove existing code for creating the second
kernel virtual mapping that is no longer necessary with the
new approach.

Patch 11 updates existing code so that it no longer assumes that
the vTOM bit is part of the physical address.

Patches 12 and 13 add new hypercalls for accessing MMIO space
and use those hypercalls for PCI config space. They also enable
the Hyper-V vPCI driver to be used in a Confidential VM.

These patches are built against the linux-next20230307 tree.

[1] https://lore.kernel.org/lkml/20220706195027.76026-1-parri.andrea@gmail.com/
[2] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[3] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
[4] https://lore.kernel.org/all/20220511223207.3386-1-parri.andrea@gmail.com/

---

Changes in v6:
* Redo Patch 1 to use a hypervisor callback to determine if an
  MMIO mapping should be private. [Sean Christopherson]

* Remove Patch 6 since it is replaced by the new hypervisor
  callback in Patch 1

* Update the previous Patch 7 (now Patch 6) to set up the
  new hypervisor callback and return "true" when mapping the
  IO-APIC or TPM.

* Minor tweaks to rebase to linux-next20230307

Changes in v5:
* Add new Patch 6 and update hv_vtom_init() in Patch 7 so that
  the virtual TPM in the guest is mapped as encrypted

* Update commit messages for Patches 1 thru 4, and 12 [Boris Petkov]

* Remove the Fixes tag in Patch 4 after discussion upstream
  [Boris Petkov, Tom Lendacky, others]

* Use PAGE_KERNEL instead of PAGE_KERNEL_NOENC in arch independent
  Hyper-V code. PAGE_KERNEL_NOENC doesn't exist for ARM64, so it
  causes compile errors. Using PAGE_KERNEL means or'ing in
  sme_me_mask when on x86, but it will be zero for vTOM VMs.

* In patch 6, break out amd_cc_platform_has() handling of vTOM
  into a separate helper function [Boris Petkov]

Changes in v4:
* Remove previous Patch 1 from this series and submit separately
  [Dave Hansen & Boris Petkov]

* Patch 1: Change the name of the new CC_ATTR that controls
  whether the IO-APIC is mapped decrypted [Boris Petkov]

* Patch 4: Use sme_me_mask directly instead of calling the
  getter function. Add Fixes: tag. [Tom Lendacky]

* Patch 6: Remove CC_VENDOR_HYPERV and merge associated
  vTOM functionality under CC_VENDOR_AMD. [Boris Petkov]

* Patch 8: Use bitwise OR to pick up the vTOM bit in
  shared_gpa_boundary rather than adding it

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

Michael Kelley (13):
  x86/ioremap: Add hypervisor callback for private MMIO mapping in coco VM
  x86/hyperv: Reorder code to facilitate future work
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

 arch/x86/coco/core.c                |  42 +++++--
 arch/x86/hyperv/hv_init.c           |  18 +--
 arch/x86/hyperv/ivm.c               | 148 +++++++++++++----------
 arch/x86/include/asm/coco.h         |   1 -
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 arch/x86/include/asm/mshyperv.h     |  16 ++-
 arch/x86/include/asm/x86_init.h     |   4 +
 arch/x86/kernel/apic/io_apic.c      |  16 ++-
 arch/x86/kernel/cpu/mshyperv.c      |  22 ++--
 arch/x86/kernel/x86_init.c          |   2 +
 arch/x86/mm/ioremap.c               |   5 +
 arch/x86/mm/mem_encrypt_amd.c       |  10 +-
 arch/x86/mm/pat/set_memory.c        |   3 -
 drivers/hv/Kconfig                  |   1 -
 drivers/hv/channel_mgmt.c           |   2 +-
 drivers/hv/connection.c             | 113 +++++-------------
 drivers/hv/hv.c                     |  23 ++--
 drivers/hv/hv_common.c              |  11 --
 drivers/hv/hyperv_vmbus.h           |   2 -
 drivers/hv/ring_buffer.c            |  62 ++++------
 drivers/hv/vmbus_drv.c              |   1 -
 drivers/net/hyperv/hyperv_net.h     |   2 -
 drivers/net/hyperv/netvsc.c         |  48 +-------
 drivers/pci/controller/pci-hyperv.c | 232 ++++++++++++++++++++++++++----------
 include/asm-generic/hyperv-tlfs.h   |  22 ++++
 include/asm-generic/mshyperv.h      |   4 +-
 include/linux/swiotlb.h             |   2 -
 init/main.c                         |  19 +--
 kernel/dma/swiotlb.c                |  45 +------
 29 files changed, 440 insertions(+), 439 deletions(-)

-- 
1.8.3.1

