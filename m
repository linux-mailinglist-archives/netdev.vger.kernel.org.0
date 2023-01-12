Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7756685FF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbjALVt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240902AbjALVsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:38 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D7318B;
        Thu, 12 Jan 2023 13:42:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZ0g5qH1Mz89s+8s9JkO53bqwX2RF36hPdGIzw7l8cD89VxXg2tmJNDeedJbHsDu798xlmYi6b7U1+gS4KknpgtEF/8naaZ22t5nOalemfsAQW+Ocoo83Er7VFCyxL+5O5pMerTCsNZDGbAcgqLcSqnFlwav2Iyc4FfZOd3p1Wvot6Q8tP7iBaeCc1OYB6kwzK9nqKLOWW6m6GQj5a2Wo0bjZ69iobBOe4VzYtuh4oE/20k1AVeMhusoUeTJy+9pWKqCLZ5Juk/LbhgwW+jvMldzUF0wQijsC6I+9VjrgXjVsylGKRceiYZK5UOHGIjRX9MaQPJrpTstB/EOW0/PMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SPfUDX/BZY1ukERs+t5UvUaxcl8ws8rk7/zksE2Esg=;
 b=od/LAJ7urVHVNmx/a/YLNUz6KOy7UAJ4UK0NP89GDNx7fzIl0d9/AU597Y3+5w9Fk/i7LNogLVpUtiV6mEhVLZ7bRW/DPGxVPXqgj3mY2yyjZSkPk0rH7gnL3ijnXvkv6mhIONKiVC4zxKe13KYwsWVkMZZ1Zj7cmexD8DIi38lRTuCOFXecem2JL00rGOvcjpDQdKsKmU7W/Rc/B8/sq1nTU5WHVVeM8O66HuAsEjFOwRhTyphJ9HTB7wvlQYTleXy5kOFTJ0rmKXgmCATH5KMYNWGLuQfBhzJKt8i62ZEbfrR1NhWA8UCZiTTs0PnY4LSR6EdRZBa9hzjim65eRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SPfUDX/BZY1ukERs+t5UvUaxcl8ws8rk7/zksE2Esg=;
 b=BOWLl9TQkuUtc/sc41UFOag8D2+2VSRIss9d318LFrGFH7HkHi/c63/FGFVaRrsdGFvjX5iMoFKf+wYfIgq0hMNL6NX+pZTBj35YnDBYUOyCBIkO3xu/qA66Zir0x03XUPn7fvFT+oAZdXXTZedYIkGDn+Y84xdjUUGJ1MVxZNA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:42:55 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:42:55 +0000
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
Subject: [PATCH v5 00/14] Add PCI pass-thru support to Hyper-V Confidential VMs
Date:   Thu, 12 Jan 2023 13:42:19 -0800
Message-Id: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:303:6a::32) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1953:EE_
X-MS-Office365-Filtering-Correlation-Id: 07d9e5a0-dfbc-4785-cf80-08daf4e5f685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDHxT/8Q9rwZRJiv5+/PYVHfzRL1PbTEJ0K7XUsKfeLOxd4MV4UdZ+LTyk64OHcW9Y4q/NsZNtxN93DrTyVVmO3z6TKPsgemnwDJvyu/ZkRqjp5NfkJLfTE/haXeJ6AOnBsNvUKfoVciFohrIjjoKi/ITVMXgAYsclFynaP48Ppautop9kCd7QkMjqtMf3c4nGePH7kXM+smKsHXQBqgYYRjj1hMHxczsz3EpOAy2flzetkJxCtyobL0aylOPg2+3VnhjZT7emgkTnLM2E4qXOYYstkxmNPlcZD1JVNQCHynFDO5FPCjsJPajHwRSieQkvv5FhGZxi1WoUT9ixhGKnVGJYwDSplrAYTQhoITrwlNWODLvKeH7xMKfRiIu0mvblLujcw2OpqXLGQvxSUMXXFPdCMC0EtCqHTyYnbI+oZynKvRHfOeIg+/Rv3Pt8anKlWyDQPMZaHGOCvHUkDTbaVgWTPLGzmAC5/MBcsrYo0QHQFE4SFQBDI/AzlAbxIVWaGFQPlqXHRHoOwC27P839y3kF4jVI6rX0ylGkWz8g/E2uphg0oNS4WnRABZ60MYE/VIqZwBKcQ0xewzuNIadoncvBXU+G3D94fVZU9ASScmDOuwUT7t8ZFjvPGcPoaXoX9bj0Q+VZ5rCIN59AhZBWifbi3PHJh+cMICkDUsU72v+JooGgFRIALq4qTmcTSzyKvb0eXf1LWcwVhgSPIiqYRhxz7s79c8Q4q3cfoIHxY71WuQAr7wGHj6+j90WSzjPbbghu9QnuJ0Ivp/PrIdBn2nPIQo35cmAGZPfs7m2f5/jpwK9nwjN8yo/eW21dv/CwM4RRMWP5iPUEa5QL32ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(966005)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PlunhToWZAVomXB9+5U2Zck+dw6d6hMummJa2QBp6Ulsvt/zbCi6Q6/NU4LU?=
 =?us-ascii?Q?62e+9keG0krWxdW+B/yJCaf9qhMmGfpTzQv6OaEjnJhyRf16/eH68QagrnjG?=
 =?us-ascii?Q?eLMqVD8799kxGuj29NPV/Kj2GLMGtzmkI1NsJe/X29n7jYJ+Dp8lg3P1Gq0y?=
 =?us-ascii?Q?9V/uEFD6uZJ/yHbaXLJ7TSbPk4B0JXqUKExkLglzc6FVjOjtAbREZuodUzt5?=
 =?us-ascii?Q?nFOVRPOvk/AFgkqWTDShTU6ZNBMsKBHfkrafRTywvgqzBPW8zXo7ZKIPgVVR?=
 =?us-ascii?Q?/JAigiUwQsDfdZs0/Yy3h4sdDMyKelIL+7m6JoJZfN5NisGlyLcnW02Aju5u?=
 =?us-ascii?Q?81Wz2vkOyvU8lRlRluBnqiebSJ2ed+6hv89E/tSdU+DQijarI+S1RxuQfsov?=
 =?us-ascii?Q?h17/gf6N9TIaCxHrfLXQuR7EFDiCp65W3dbRsbeq7oeAo74bRRKfRtDi/j1B?=
 =?us-ascii?Q?QwfqRUk4zx4rlMIwQ13AELZDZmG382ibVczFhLGZ+Oc+6ard0r2LuzO0dR5+?=
 =?us-ascii?Q?Ma1gnM/8hrdMxU9igWSs/1wKGJQm/WWH9x4XDxsg75B6LaUiL+AR+1jqXRKx?=
 =?us-ascii?Q?Sh5coCXqbaRpihxOUCdsC0pqKjfh1DNYQwbWD0ITwlKOPMsLpq/Arnf/dbq8?=
 =?us-ascii?Q?Q2RH3HZ044jRNJYEG1HwXTRpYLaI0BuoGF5yOwERM++Q+qSosGdu41kkhitU?=
 =?us-ascii?Q?GBv2tdRH9W9hX3vjwe3Zk+ICLb8b3yHrrazBSkh0eQT0pST+VNJow/gHuW+Q?=
 =?us-ascii?Q?mazpD8mS/rgWDwr7X8XRX0l13pNyoBDm+DlvGhXubeimewsDxqG5vhm2oh+f?=
 =?us-ascii?Q?ecHSj+tWw7eh5smncWFtVK+lUCm9JEWbvLinCyvZlAHItksExXCH7vF5FVii?=
 =?us-ascii?Q?bNNeAkXEnUTToXVEVEvHOe6XEhS2SaSXTGDwrc8TDD5Tf3So37Vase7GByC4?=
 =?us-ascii?Q?dLK+UUBd0GDNFrZiZ0nES21GTTzBBW/QYNXMzzBLue91Et6aK/BWRaqd/A8d?=
 =?us-ascii?Q?kqzokmZXa/J0LGIdfXWjmaKmhEZIcaNBHPemy8OEpPT8Zqrjfq58azSvNybJ?=
 =?us-ascii?Q?oMPW0xvgU8MnImibQgpuDwuaDwSlDEWR8gyQggsD7fm4SxtfJYUi+LBl/AO6?=
 =?us-ascii?Q?uuhN1IMGIRYIzIF9Zmkn0BcWA2UEZVTcZliBRw/QYqNGmJswiKVku7AfMvHf?=
 =?us-ascii?Q?3qXLQYpZUwON4obw1vTHWxGEgZ14Vpw1VI35tnGdFsNcKyKQ1CKY9JDO9Yao?=
 =?us-ascii?Q?E1I7DXN985HgirzRi3id8lwXGFehJF4CSMaiVdiCwXuWVc0zSGWJZycg9HJS?=
 =?us-ascii?Q?FR7CVexCZPbYBrtqlpQTGBy5b/jRFk0QvIYQkHZ1DM+EqKH70jYOGAxe8kHc?=
 =?us-ascii?Q?/mHXJl7RR2GLqbm9CcsnTzjeIO/bVUwlmMvj06EsHoyCD+DEZ7R+qw2vudN3?=
 =?us-ascii?Q?/g6gMWcDBRPDIbyVxsYQ7Jke9GhXiDollfWX+H6EHs8Ntf5RiDQv5DXapV02?=
 =?us-ascii?Q?8BEaKs4vNU5gSjPuTq1d8muA4pjRyw4P7ufj/zXQxJ2NV6ujvONrKlQcT92d?=
 =?us-ascii?Q?nWNnOUHGNTrT69+RrNmKhTwy29dXNldYRVRSHmLp?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d9e5a0-dfbc-4785-cf80-08daf4e5f685
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:42:54.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KJkAXlGGYjvH503/t6rb+KuP0shVL8HQ3Co8hIheSl6SGRnL+qbFD4NlTgCtCJwMLrwOd1q2xghnU6Zog+llA==
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
like the IO-APIC and virtual TPM as part of the guest VM.  Accesses to
such devices made by the normal guest OS trap to the paravisor and are
emulated in the guest VM context instead of in the Hyper-V host. This
emulation is invisible to the normal guest OS, but with the quirk that
memory mapped I/O accesses to these devices must be treated as private,
not shared as would be the case for other device accesses.

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
tweaks to map the IO-APIC and vTPM to use private accesses as
mentioned above.

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

Changes in v5:
* Add new Patch 6 and update hv_vtom_init() in Patch 7 so that
  the virtual TPM in the guest is mapped as encrypted

* Update commit messages for Patches 1 thru 4, and 13 [Boris Petkov]

* Remove the Fixes tag in Patch 4 after discussion upstream
  [Boris Petkov, Tom Lendacky, others]

* Use PAGE_KERNEL instead of PAGE_KERNEL_NOENC in arch independent
  Hyper-V code. PAGE_KERNEL_NOENC doesn't exist for ARM64, so it
  causes compile errors. Using PAGE_KERNEL means or'ing in
  sme_me_mask when on x86, but it will be zero for vTOM VMs.

* In Patch 7, break out amd_cc_platform_has() handling of vTOM
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

Michael Kelley (14):
  x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
  x86/hyperv: Reorder code to facilitate future work
  Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
  x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
  init: Call mem_encrypt_init() after Hyper-V hypercall init is done
  x86/ioremap: Support hypervisor specified range to map as encrypted
  x86/hyperv: Change vTOM handling to use standard coco mechanisms
  swiotlb: Remove bounce buffer remapping for Hyper-V
  Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
  Drivers: hv: vmbus: Remove second way of mapping ring buffers
  hv_netvsc: Remove second mapping of send and recv buffers
  Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
  PCI: hv: Add hypercalls to read/write MMIO space
  PCI: hv: Enable PCI pass-thru devices in Confidential VMs

 arch/x86/coco/core.c                |  43 +++++--
 arch/x86/hyperv/hv_init.c           |  18 +--
 arch/x86/hyperv/ivm.c               | 134 +++++++++++----------
 arch/x86/include/asm/coco.h         |   1 -
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 arch/x86/include/asm/io.h           |   2 +
 arch/x86/include/asm/mshyperv.h     |   8 +-
 arch/x86/include/asm/msr-index.h    |   1 +
 arch/x86/kernel/apic/io_apic.c      |   3 +-
 arch/x86/kernel/cpu/mshyperv.c      |  22 ++--
 arch/x86/mm/ioremap.c               |  27 ++++-
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
 include/linux/cc_platform.h         |  12 ++
 include/linux/swiotlb.h             |   2 -
 init/main.c                         |  19 +--
 kernel/dma/swiotlb.c                |  45 +------
 30 files changed, 440 insertions(+), 436 deletions(-)

-- 
1.8.3.1

