Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B6F6C94A1
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjCZNxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCZNxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:53:14 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021021.outbound.protection.outlook.com [52.101.62.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C4E7A85;
        Sun, 26 Mar 2023 06:53:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghuqYiu5QmcESV8SLBk4nNigtrSZ0KpFPcYkwGkn819mkKVYnRKzF/712gx9ccUf1GCOnOcHDOZkRNpW+o5KlWIxmVURanhbz5Ps3GBy+0B4qOyVvS7B1vtAFrzzyLA40QH7myZfTEHQ/iODkQtKJPHIctRApp7CTarpEv6WMXEh813QV2eF7BkA75Z/oRlJkFecXcete/aRKCmdi4SWlU6amnNEm78nyuM+E1l4oipFB4zTLhM5l15RMf7bbSzPTCX/yksaGdOAlnsNdL4vPdZcIp2PN/l0TfIlQ64evHbl346lkh9lz96XC674mcfZzPmuX+DsgeKErX2Q4xMQGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlA0ggFcSKVY+mrFUq7xZmXYePx+rwVJ8G6fdkxgkxU=;
 b=UiIf6+XhASjOAE107nOtyu2hYt+YEGuJj6Q3TUnkBYBrwHU6EAr7PAz/Xe5w1VGM/lY5QrJXAZsmBZMWBuNv3B4KVq/0gYvLMjIGgYgRKI0mVmFjxisqRXqm2mw4zzXP2o759CBkGKDxiiUhPjtbjxSPXNSw/b0wU9eRrwe3gI+ARlXFurAvqJUeSb3C+pnAS/tBDYZEJn//pSAnV24Js1J109x3cr069NoXPN6iYrQP1Sd0v4EQiKJWFG8pmPq6HUNp3V7CaYM74wvGvK2n9aSsdBjYz1WIGIx0GKbqHJT2Qho9b+NZsMpsjzRusHcAKXDcBecok112qF1SJCRlWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlA0ggFcSKVY+mrFUq7xZmXYePx+rwVJ8G6fdkxgkxU=;
 b=Aazke/2ZzbjVJEBW1M8NxYBTyaWgYQFzjJ+xpvymXJDOFUiy+BCQhrd/NqyTb800Q6ZMTuWjSNgfywLHYBCaotoR76vuzSK6/G3BxEKP5eI9lxjYO8gfy71cEYulvSIN7oJLknKAUVPNYM5BDmcpCuy3pmkb0cXtQfz6d+3xCg4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by PH7PR21MB3044.namprd21.prod.outlook.com (2603:10b6:510:1e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16; Sun, 26 Mar
 2023 13:53:07 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:07 +0000
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
Subject: [PATCH v7 00/12] Add PCI pass-thru support to Hyper-V Confidential VMs
Date:   Sun, 26 Mar 2023 06:51:55 -0700
Message-Id: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:303:8d::23) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|PH7PR21MB3044:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ec4a03-9745-418d-0966-08db2e016d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbA4JcCSxH+iBiPAz5cb7N+QWMGL8i45fzn7gu+Nmgsskw7/VXz8oPQPWBKkl2Xs3G10BLlSsxwsRFEaRcykI4UJuVTwjnNdcrBHnbJSfdj9jWpVYefIQow2tRhGe1w/rUxxNiylAsXxTzBis1HyZEtxO1or02EoDM5hOaF0d1CxMD5J8pZWRQ+wtBgm0/FnaK7R9C484WYfAyoHGcBOQ+kdueevwr/gvnetYZgxQeOKOXDk99K2UDpYBzp0JS5kltv/f9CcY7zdjslupWqj2TNTZAGu/v2f6lK4UnHjwZu5uZjxn5ZRAAnNtGyfDsTKMRBw91ZU9+zyDOiH1JnoG+83s/2v/09pBUVZqQP02AS523HjVbnn872Www6iX5gn10ZFxdegLu+dtLcGKJjit65XdYswciRHg8Omm+AYyxJa9T2GAg5QuKCFnhGgdVvdy2wBiDfE/9hZWoh5VZZbz8R4h/bkkPSPZdyk/+imt4/+JFmP3XJm5QOQ06NwqipZMHueSgckmTb6eBzlc+6tYrOYtnz7IYcEeszmzE5I3qsmXKMLGdZqNFXaOXdurhNWiHAmpzS8aa+aruyy+rS1CK6ygo0knpLbUdbnCSffX21vS0nc73Zd1sFVfdEd1OuGfFmeVmrarz+R3CTQxmms9W0J98/dLCT4Pw0NB/RmSBqAQ2Zas01x1pIHCh8Cb/SvBg9CUAFgMPQjmhCcH/lJ0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(966005)(6486002)(41300700001)(30864003)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TDYn0KNREEVZ3t3AmySDqYKAAN/5pCDGJo0dx3UFHK5IwAcbKPUhTpZytimk?=
 =?us-ascii?Q?kf8HIgR77TiEyJJm4I/4u+9CUTAHR0O7RDkqPjjTLNSvNfPRxQ9RRLj7eQSW?=
 =?us-ascii?Q?Kjv9KiRSvpXLRzC9XGOcy2pS+MBi7WeulIL+w5fJhMTvgEb6JopaDCBbM2ZD?=
 =?us-ascii?Q?GYbTBdsRTkzTIfCbLfGp9cjYU+gc4u6v6n6SdY+zYygEbtXP7L0V2V3BqIXP?=
 =?us-ascii?Q?zT3P9qap/FN8a7NsbVVfgwngfIVAPR68HdZH694irEQe0PQu8g7s3yKiEFui?=
 =?us-ascii?Q?MH7f6nn8RYeDelKL59XbqHI9R0DDlbhs5z2rl9qr2amLu+8pFIud2w+6Hc9J?=
 =?us-ascii?Q?513b2H+J6S6yvRv47l5zy7XR7dVb2MqLVAOjswbVosKdwHrw611EZTaUcyDF?=
 =?us-ascii?Q?QRsYUa0oL68pnahNHxkx3BU9aOY7pjvOvNF9sRW/lI4y7vGUe31912EC42ot?=
 =?us-ascii?Q?+bOIY3iijTLIEtlNY9ugPg9gJqepLyAq1B/PRhjJgCU0OJC6ZyId6f/7q98T?=
 =?us-ascii?Q?LU1NGKhdO8l8V9iJz8k8Fbqf+jidhIcmOQGnv7XOXIc3D5lU4cqC8qDaikJC?=
 =?us-ascii?Q?9EJiH6ao1c63/5zNg/2xCJUE0Ig7b+NkVT5cWUmNiJ3/w1CiCPJK5wBFSvbB?=
 =?us-ascii?Q?XG6NADwaI3jaxWt3m7sEYOTtbKNbQMOfaZe5POYU45WiADlOL+c/BlL76lWZ?=
 =?us-ascii?Q?ysuIMBddx1rDuIGN40+KMQ2kOdwydyKsev07NhcaOs4NDwOXM2m0bJ2LZZ6L?=
 =?us-ascii?Q?JEy25Tb4Uw8knpvBkCbNlVG/QHZz+LRYW8eAmwEYpNhI4TY+WliZD5ogftD4?=
 =?us-ascii?Q?rHu91V2aJ/O+M7J4Fxz5yTHatUMsPVbz8o2yyjZ+ZPdLpUzrj357Q4pAtjs3?=
 =?us-ascii?Q?Hhba0MKjdcDFLILHATE/VSAgpB2mCBBL1onHmmSjiHYjjlNpQZT+E4VTvIxP?=
 =?us-ascii?Q?qz7kOjDawAZXgcRMb+qytVaqbeWxyx3kBzmICu9oWA5iUjCEGM9laf9bccXR?=
 =?us-ascii?Q?A0vHnUwPsjKt+Rj8ITpnYko4uYRC+f1+8fR+rOApxRiiWzhb/3Ke09UUe/RM?=
 =?us-ascii?Q?1L/KMLLXjEyh3KvpbAbHyjyN8VNiNv3hcRMaBoIGchimVx6Zf5ZCBECH9ZTJ?=
 =?us-ascii?Q?wT5cZQXIeX+HmtqMro/JmIhbohtgn1fYIxNjOTik+2soYTiQP10vAbcj3iPE?=
 =?us-ascii?Q?yXDIe2IUQBmwLWRWxKCUQtwohnI+ek7kHIAmmctqvMgDNykQHThAkQvsjJlA?=
 =?us-ascii?Q?NGyDrgifws96iDdUUxivnNE5l9x3BJ9vlZbho++p2brw+KLq2O5mac4HZbuE?=
 =?us-ascii?Q?OlKNR9/zFx4ZoiCaZqXppmlfRv2qyudas+SpUUmc9SMkFOCncox5ZvpX2py4?=
 =?us-ascii?Q?JWSWzPxan4RCJjkSJ+JGkh93ZwT6phmZ2OmZ2g+wOCnvSRrPXA8GP7qtFKX8?=
 =?us-ascii?Q?GrJoaD0qdu0N603ALlb4lmvjezpDpWAX1rWedK8d/M7H7E+xNo8Elpmk9clq?=
 =?us-ascii?Q?hkRDilxS4/IVS27CULvcMAIq9IDZmD21OS3PGQLano4cZv7eLqqgZjbsskBq?=
 =?us-ascii?Q?MiRFBIfgBBRX3gven2uhmkuqEdqTEWOmBiU6vt/dcrpeSxa38XcyfWGA0GT5?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ec4a03-9745-418d-0966-08db2e016d59
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:06.9096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfkPG/o76p/tEAmwmaB/gHWZJkmWr4B/IBi4jyWpwiZ4U1R9co8qxsf2Wcdxl37dUEnQknswpbQmRNJHx8023g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3044
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Patches 12 adds new hypercalls for accessing MMIO space
and uses those hypercalls for PCI config space. Also enable
the Hyper-V vPCI driver to be used in a Confidential VM.

These patches are built against the linux-next20230324 tree.

[1] https://lore.kernel.org/lkml/20220706195027.76026-1-parri.andrea@gmail.com/
[2] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[3] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
[4] https://lore.kernel.org/all/20220511223207.3386-1-parri.andrea@gmail.com/

---

Changes in v7:
* Fix Patch 6 so it compiles when CONFIG_AMD_MEM_ENCRYPT=n and
  CONFIG_INTEL_TDX_GUEST=y [Boris Petkov]

* Squash the previous Patch 13 into Patch 12 to prevent unused
  function errors when bisecting [Lorenzo Pieralisi]

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

Michael Kelley (12):
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
  PCI: hv: Enable PCI pass-thru devices in Confidential VMs

 arch/x86/coco/core.c                |  42 +++++--
 arch/x86/hyperv/hv_init.c           |  18 +--
 arch/x86/hyperv/ivm.c               | 148 +++++++++++++----------
 arch/x86/include/asm/coco.h         |   1 -
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 arch/x86/include/asm/mem_encrypt.h  |   1 +
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
 30 files changed, 441 insertions(+), 439 deletions(-)

-- 
1.8.3.1

