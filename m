Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E758A63FED4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiLBDcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiLBDcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:32:13 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021015.outbound.protection.outlook.com [40.93.199.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B36D9B32;
        Thu,  1 Dec 2022 19:32:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEGUMMLeS6pMw4M83jDNAnkUHYLZmJJxcomo2tgAAYLPGblCYS36QlM2LYFKruvDKNukQ5fc03L8I/cLhLEHIK/X49FBd3yymrFn2K9wwy+M0zL003Zk+wfMSqzQcEs6Lg+mdVfwb+KnF8AkaxYXLU+Jy4N2MOoOctpU83mjpaKUWJCOV1ysXJghLsOop5T61Y1+pjQbpE7G1P6oHeAcwjwH9n+v/Dsb4jTXW/5QmMPAGZ2Gdj/V2ajGuaNk7MPs6eJkYalMBkhTSN7czpsWeaxHX+VgXXJS03LBVADxbxUrv4oL76/v166TKAkkERn3Bn+QEru9CmU/dT5LCx63cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/eyHJRqCxy6wLFFe/eWhOXLtk/aZrnSbg4MPjO52Cc=;
 b=CU3Lf86FFYCycR4duMJQN3GJvmSAob6UBes+sk1gDQkvgP4T0h4Pin548U1foQuTO61Z7gtrW04xC2IjsVJfYGt9+WiVhLIE1dkGYlgrBy4yvKf6IzHSIo/+yh2Mgo9GybO7eLUVDh3pn2xTLE4w0xSz37WjTlpvT1PPH+ITShnwIOHItTJGMgNO8wCKAIDzfmBbqaZ/iqMV6NPHcAapSiro1pPJfI/LfwWu7dMCG7K2gIty45gS9Vb2HCYTIzTJvKfdO1lkrLpSGQNEA7KQkRL6Y8HSLR9/Gi+sip5DQZvXeYvb8JfcHy/7qRwY0g1z9ERHd8KAzQ1G4PXTYhk6qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/eyHJRqCxy6wLFFe/eWhOXLtk/aZrnSbg4MPjO52Cc=;
 b=TayGr5h0tJ0w2+ya3/Wl9oepD8bQdPzjPGugbkcNHpIun43HA+EMGu7SV4/YttBQ8Ukm58II4fsBI1o98yFWr+HkKy/cT6w/Jz9gBO5aIjZKs6Bl4kAR9eELUc2zTTlz+rxhxLkkTZcT5lnL4SRapBoAbYhGwyBAeYsQzWu5eno=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:02 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:01 +0000
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
Subject: [Patch v4 00/13] Add PCI pass-thru support to Hyper-V Confidential VMs
Date:   Thu,  1 Dec 2022 19:30:18 -0800
Message-Id: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: d5bd8664-cc7c-4305-dd55-08dad415c653
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cwsv2l7vGlG2AgB8jWr6os9iAjA3+nSo7nm+vkdLEsP9O0EK7Mf7y8a9gLT8Vw103LGTDGC2KIRjsHdVNWcuENyINrsthIeDaPGLrebj+/SVvlOFrAp+wdVXSlpkq3NuZDQJct1emMf5IoNG8SZVbwaWNsxVRnMlvQQI70D6z07/a1KdwXn3AJ47W4O83DPkGL9kinIYlg0vs5/9IuVWM/2JvWc2Ey0ybg7PDXMdCQdGrV+0sTsmRWGMmfYu2N/M37E8ulW5NSHpR9B24Zw7eNesW8FCJWjB5ofVnEPIclygL3saTDvQfpWH5bIiOx6k+C2xqUJCd3nJbkz7/Nk34t3XsWZAYBX5BIaoUAtyaHan1lyUHPj+UGrKFzFBuvlTPokHoJM4DFOwurpXhWvp63p7se5CXkeQBcujeH1GCLj/VbFgCzLypWbxpgFLtESPfwm0WSbczrMLXOFyDFeaQWzyWxDMsVc4JddvGBxM22PmVnG5/tPsb4mGuVXa0GQRoWGdErbNIYn6xEH+berykFVtqcWw040b3pXDC/hp1+oQHDXakqmW6N2f60dVXz83HQNjV0tPPKQ1t7MvYjGkJiBigYILoTL4yD9QExkzI1uQ3ShRCtVl+qXFdUN6bDxq4UIKGLsyo+TIwDjpGQOh7iawsEDgE/bw8IHnsXKMkgy765ts4HMng0JR8woops0MBCoLawNfDGQvpz3hDWUaYw8zQpKQjdIwt1peIJcM6Go4xXZc8rQhQGcFvAu5KY8d7STWXJV8HDThLa5oTZDq+bkymzbyECrGprHPsFynrZjTtQFIhl2jYd0VfapPrPb2lklZKkFsxcJn3S632oyFBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(966005)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O2NrqrhwOXuZ22dlVGA5P6LHE5fdEKjemJGfBCw/WpbTU4kkQZI3E+YXx1u5?=
 =?us-ascii?Q?6UpXuU61AHLVV8euaurQDpCx/oeQKuMr9uilWAkKt8dnL3LvEvYEXtVCDAxn?=
 =?us-ascii?Q?2khFEpEmxhptk/SmHJRq9Jbjde2qQ8oxUAfPu+s3xSCIwrWYC9Q3tDCp6YSa?=
 =?us-ascii?Q?HuTmF9kQ/K4UwWgKQxpO/Tylr97+zTt/4i/O++22JHbc/BZveVPOA58cNcTl?=
 =?us-ascii?Q?k1Nz6ypdDi32gKqPV/81If6hxwIMofFB9rsRU6SuC9vRRYeTIKN1Lp09b9en?=
 =?us-ascii?Q?Qgl3G//UKr6Wt0c7yADF5J1DnMshG3cyFsxi4newrKrX/Dxy/Cq6uMcBpMpi?=
 =?us-ascii?Q?YiZSCwIDliIAHmGTiihsWj+m//+Rfu1WVBREZ9x17rT+Y6M9kdlnyPh7JTNA?=
 =?us-ascii?Q?HMC90iFZSMhYjvVhrFanZRxevAZazQ95bX9a8cVuXm7pKiFvxbFOGGNuYs55?=
 =?us-ascii?Q?6NEz6SPbLLFt60DizKF+9dOK5BaAp99Zgd/QfpTkDHjvMjJ8MUAmnpt6u3r+?=
 =?us-ascii?Q?imKGc39DWK4X2VMAi6/B9S2eTEp44DKYc5pIIdFCdNehcoWpeQiue9TcAbqZ?=
 =?us-ascii?Q?3Vmun4dyrCUdpsP/MAEL8XVWx08oSrlAPRHwPebts+4ndxh8vbjYUolMZ2cv?=
 =?us-ascii?Q?aPZ/uZ2pTJq4oKrLBd4muvPQ8KDyUyhQn4DM2Ecpm3UGSJf60zDkdkGMvR9r?=
 =?us-ascii?Q?8Zd864fjG7BwPrfcYO5Iye89SZAQOIbEcpDlNLcSJzY8983LvMdLt7m9Qh0m?=
 =?us-ascii?Q?VMFVvKoxqEsJLZ92rT33sxZdcg16LI+PkqBKBGBbPu7jVDMLL9g+doXxSnNS?=
 =?us-ascii?Q?anKq1yk6lAoZKSpyvmhlEayQk0tWG5MvMqET8I7fjfItf/VtyI+Ypn7raT6Z?=
 =?us-ascii?Q?MpOW5ikiwxwjbuPzWz5sYYm9c+VBpmp/mElN2WHw0Ouczi7tnjFTlV7QGhcM?=
 =?us-ascii?Q?PZ+HP0gQLTfMFLxwr1+NZq0iHRcpBy+YKy9V7xs1AquuPSaaetVb3H64T0Ow?=
 =?us-ascii?Q?I8bpFxQ8HpYQgXPKDuPR3+y5UB5rKRbncaYeQ77XEOl407nMquM3RO7CfXDJ?=
 =?us-ascii?Q?nDk18fXJjJNqPp0LFdHKFnp2czbysGrVK+V/HiRLXlzK9M7Ktpd4FSW4T0Og?=
 =?us-ascii?Q?BvUP3O6aRytb+jfDAAml4kOESBGWjASapFzM192PDg8UxkEnnzmRN42zlJ8l?=
 =?us-ascii?Q?PpzYnZXOP5/aUMUhp4JQC98SGVSBFoebjTnYTyKIJHKGJOpZEJVvzKruGHRJ?=
 =?us-ascii?Q?GdB+o2hbiWgb4IEc05aUoQ4ARHVowvmJbZpkLP6Qn3tv2PLLzqo+Vk2019c+?=
 =?us-ascii?Q?LvqMImLCMmAiv6b29jXgebSaXlYvFWJIB20d1UruJvw5PLRu4x+dLKTvB57A?=
 =?us-ascii?Q?kpvjSX7bQAm91e9Z8U+aFYI0wRWw7uCbi0TlZkK+z/kCbW0S4O6StHL/KTX6?=
 =?us-ascii?Q?BfXVaYToSgszL4j26IEwH1WXUxJWizHuiyqkqPXFL7bD6I6z4Rj/LczqIKJj?=
 =?us-ascii?Q?FvmYM8QnpE1u8a/L2maVHs+aizZY40CQjSncEIAtXkGNFznNVP0g3aAz6P23?=
 =?us-ascii?Q?+Y8s73wmEzmPySJnExJFMMYtWvlqV8bLkWRow7+gKEdZ8pSRZf+bu9FOUzIl?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bd8664-cc7c-4305-dd55-08dad415c653
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:01.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+fGW/SNKY2AWjOwOx+bxhlqpHDNC79NztQQvASdnzxZSGz6MYJNfZf4geCDEDwfPmHt436mDZDMZfwERytKSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316
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
like the IO-APIC as part of the guest VM.  Accesses to such devices
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
a minor tweak to map the IO-APIC to use private accesses as mentioned
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
Patches 1 thru 5 are prepatory patches that account for
slightly different assumptions when running in a Hyper-V VM
with vTOM, fix some minor bugs, and make temporary tweaks
to avoid needing a single large patch to make the transition
from the old approach to the new approach.

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

[1] https://lore.kernel.org/lkml/20220706195027.76026-1-parri.andrea@gmail.com/
[2] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[3] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
[4] https://lore.kernel.org/all/20220511223207.3386-1-parri.andrea@gmail.com/

---

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

 arch/x86/coco/core.c                |  37 ++++--
 arch/x86/hyperv/hv_init.c           |  18 +--
 arch/x86/hyperv/ivm.c               | 128 ++++++++++----------
 arch/x86/include/asm/coco.h         |   1 -
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 arch/x86/include/asm/mshyperv.h     |   8 +-
 arch/x86/include/asm/msr-index.h    |   1 +
 arch/x86/kernel/apic/io_apic.c      |   3 +-
 arch/x86/kernel/cpu/mshyperv.c      |  22 ++--
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
 27 files changed, 398 insertions(+), 434 deletions(-)

-- 
1.8.3.1

