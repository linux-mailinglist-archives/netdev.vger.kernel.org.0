Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0053D6B1950
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCICln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCIClk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:41:40 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021017.outbound.protection.outlook.com [52.101.57.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC1967732;
        Wed,  8 Mar 2023 18:41:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZ8PvzNAHoIPBffwZL3115hQ4jJagk5WW7bCs81r5MOUoHYEVxVSEINELufbKNWKf0Sm8sHY9LEs2BkRJ/dc5Qzt+HYZBg02EPam8QGFlxpHGshrh13LzhCBiFlNcmRxehu2t7HIXcuMtfr6Eh5HSxYGoMmTYM52AQdBy08BHGsOmYZhGPd6y1ZrqZ1TELWX3Vgr95S/1rj3fjaMLu0G3OPmqd2qapabcr/0skwT/ROymBx12vw0vMgSd2h2TlF5jrhNaIfRM5f6xwEl8KWKBqKUNWqU0q2bPbAPn/8S2+QOi43ciIa4XyumV5w/eXBdlCVBqvkErxqOQ+Z9hhhaSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJSsjkE6n4QET9p3yMwrUTThHUQbkoJIj/zzWReCAO8=;
 b=hLpS2k/NoTw3KDp+d/iUEkeN1Cq/+OtSUhZBXB7JWuJj8ps42Ql8wNC2sYEZwXaNio0Y8KXRQBrUdRGcjPnb3W0/V1Hb7QgclaB/MoXaRiXUzngCFeMCqIpx+qkWnqVA1ia4xusYDUpMd3GFwIQa3mYVQuZt3ROlWoIETgx0ErNeUBtuEfXSPBQ0caeGGLJMwMniud7H+/D13RFpL1K/VAWARNOYtzcp7U8sM6HU6lUncULvrussVYuwR808Hgs23JbQvYyo9EzS5jV2+Wf1+PnRf9RW8DXQ8JZV00jrfWEjLoR/eerFPySsAghUNt+JRX68x8Bea4Kinv3F28adxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJSsjkE6n4QET9p3yMwrUTThHUQbkoJIj/zzWReCAO8=;
 b=KIm5xs/LBXgHOOsr/KyeRFOspSFOXR2263J3e+rixp+EJYKCe8Z18aae0WIcfN+zcqnBr58r1s5jPpcNHeHEuQ5DU1O+WE+oxT7f+KbOeAEg4cA4ujrvLqXAWHN8q71GqpJksmBMYzwBRCrn5B06EMPA9SyKjTxGVW2y5d8xYOM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:36 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:36 +0000
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
Subject: [PATCH v6 01/13] x86/ioremap: Add hypervisor callback for private MMIO mapping in coco VM
Date:   Wed,  8 Mar 2023 18:40:02 -0800
Message-Id: <1678329614-3482-2-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1313:EE_
X-MS-Office365-Filtering-Correlation-Id: aae9bbbb-5dbe-403f-7125-08db2047cd1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XwGuW/N+vrB+6+OhLiyC9thzovubM4tJmpQMM+VbZ5L/fesvAt1K2JKXNapmqiV1Lq5uxMaol7CjsIowfidxIEPG+aKQ7O43Hx9D1x84ilrlei9M1r78Y/TG0v1EbwayCBTe1HoTsoB7JG3o373FsTR9MzPQiwtzG0nBsHdtb3u2LKk4aeUGQmabBUFUej+ica00m5FtzUS2XEVyb/TkycN4E0Ruq84/INBbRuuKzD/PQ77k+unFAgcMfFYmCJ/JZxjmRLyGampr4r1AZL1NcO9pNhbViotTz6JYJ02nlV7+ADZ5FbcWnpkqHCO6ons99mtyZU5jbpvCEdIPCdEDRh4WIepxp9dlWR4JbRWx3sjGJ4Sx6uAwxKvnRzXd9xYt+OBD1AvKXT9i2b2FcUizozyxrj+H/joj9p5a2xRVFU9zGuCFaQ9qnUkiV0jU0X4hSvOICV+g+OapUn4VV6aVk7o6cL4PE9DcuExyWK0zjqD3LtVKrz/3xCeX3X8jay3fiYdUnq8qSOsnuJUYN3EUtNPO8L53QqqOFniJI3mP+b5/5lCJzUAA/Nx39XigDdjG7JXe65D0pgwSHpMnd50YApvez3q5u2izh5xRe/kjTQrFLHUf6Wtmt92PIGfLZ50BZ039ydA/w2KCYAMELyj0BtLJx4/BvRcHn5EGT7BXfO9+/4CjGRHHsxYS40xRQP5i3z95wZXVmxBiir/neO9pnmF9wyQnBsE2ABQIQjxEL3OoEBDsp9max1aHb4PhGsCOQIyw8HVhT8SqXEk9ArWFgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u3fAXCWuzmTm61bXdPNWo96AbJkyFNK7L2A12xy5X+s1Qv5rPQzezKU1y5MM?=
 =?us-ascii?Q?4M75CvLHQDh4LNarbhdG+IUuvPddDMmckhkCyCqhU0JxriXAs4qVSTZri3yb?=
 =?us-ascii?Q?nIxGfV/JosL5dOSYJd5Zb3Wtjqh/GEMhZVVXjfDrdnCRaGdDxYTQiy3sR2G8?=
 =?us-ascii?Q?Al8K2xBthbMwlETlA4UaSsDDE52UNPLIpbQQ2exC5ZG9e88oKlpMTkJTkYYu?=
 =?us-ascii?Q?QLG4oCjEvzXyo9+MhFxbA8OVYf2BRXkYV6glrf4Ncwq00dPwzoa2VKMjYSbF?=
 =?us-ascii?Q?0MfIbj4/9FnJGq9nvsOSYJ7jcXHO7nZPRgUBm7uUgUdVftgp//DelKqY9U06?=
 =?us-ascii?Q?vlyiY/tqwMDZ80uogLkC3RNKDZTT0QyKALuGfc9veFAkRYXnM/Et0vcn9736?=
 =?us-ascii?Q?BJ74aREFvPlYb3ESPHGNqG40OzCO9VJQVjS2+2eauwwBhPKyErGCXqMKsGyl?=
 =?us-ascii?Q?uT7CukJtUD/TOdgDXBLZnyC8rDFw0yBMscExERPkPhS/HtQcn99KL5091SPE?=
 =?us-ascii?Q?mxn6eL6ejiAnp+ZDk3oLwULTMhGTehEF93tMHVLxawXieTGNWBT6pusW6it3?=
 =?us-ascii?Q?CWMDGKiSLTzDpS1S0CxR9lvlV75FELh4M+AdnlQ0YNPg9UG7XTvn/RmgAdwJ?=
 =?us-ascii?Q?cPaek6E65HGRyJjxiOI7QRpUZZ0xfxmN/De/xb0wQCRSaBtuHFMh7kwHr8Kw?=
 =?us-ascii?Q?5H0ByhAblUMzAO9dyosmuxuWdU64jCvW18EpnUYgxY/WTZoRVop9FObg3LNs?=
 =?us-ascii?Q?lw4QJI+qLfyl8lMOjYOyckzfrJWiCXgFW8A3h7JRad3Z75tb7cs8j0+kD2KE?=
 =?us-ascii?Q?FCfbKRtVXj04ExPXikcG1emGL9lZk0zcSkAlcNo72wY0qNrW+vXrO44MsXci?=
 =?us-ascii?Q?1W/OaWemK7VkBYk6tIjSEePA1WgwXmHFK+acRyxsHv/DJCfnOrR+PYm+CjU1?=
 =?us-ascii?Q?/PLTkUCKEL99IIJsWTj7dk6L6V8136Nay9FXVg0L+i1xlYyzLC7skXE5UM4B?=
 =?us-ascii?Q?qT4k3KSyqtl5AhUTFMG/0PoZARUxACoYKBsFkhDWMiRL7tFQM+avlp6oKc+2?=
 =?us-ascii?Q?Eml7AoCZ6qrznTxVcY6XTvNo0kJTz8TJCzFha/nGLNnsexveY0hVLaEu1Cv9?=
 =?us-ascii?Q?h6cO9SogPFU9q7MjSe2A3N29BMWFTTcyJDVRwWpNOWyPhMbD0Sa6QlwzpUwJ?=
 =?us-ascii?Q?TOKE4+Nwc2R0Bf+fVVJblJq+N/DA11qpOaV+7MGRdhIwca+KDaxCX4sAJLVq?=
 =?us-ascii?Q?GbSwuGkmFrH3z9/WL+SY3TJtgx6y595rKYQCfU19CjC0yUBl0licHgxKTs4a?=
 =?us-ascii?Q?wVnBJfrl656fOGN26MOZsq4pCILo6hH5XzWnYwFIIjPdinOlEbtScJUsCRKt?=
 =?us-ascii?Q?K6A6gOwmWAtE63XnnEmq08bjh06rKs7dE7Ocytloxs8XarlwgPuStYuN1F5+?=
 =?us-ascii?Q?FdjR3aKm2tC+ojzNs2jWRzsaNN/xOZ/uRG+tk62lTQb6HdVG0deSTPKRBRyn?=
 =?us-ascii?Q?HPoF8ewknaYDVjgiXbGQo6cu7mfgfadntU745/TrPeKiucuGIZWstdQYJGMB?=
 =?us-ascii?Q?TQagrvBaSdKPQs1GPflNGJHuL8K+DBtQU38hR2YZxhvUV7D7/oLWtjm1tFfc?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae9bbbb-5dbe-403f-7125-08db2047cd1c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:36.0735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /C5aeriFRkR0bancV7rMcB6fQ5BNoBay3qo7qW0P4mU8NezWUXAijubYt7+p3WO2OT0YWgDKoQ/JQCzFH/MzYQ==
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

Current code always maps MMIO devices as shared (decrypted) in a
confidential computing VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
use a paravisor running in VMPL0 to emulate some devices, such as the
IO-APIC and TPM. In such a case, the device must be accessed as private
(encrypted) because the paravisor emulates the device at an address below
vTOM, where all accesses are encrypted.

Add a new hypervisor callback to determine if an MMIO address should
be mapped private. The callback allows hypervisor-specific code to handle
any quirks, the use of a paravisor, etc. in determining whether a mapping
must be private. If the callback is not used by a hypervisor, default
to returning "false", which is consistent with normal coco VM behavior.

Use this callback as another special case to check for when doing ioremap.
Just checking the starting address is sufficient as an ioremap range must
be all private or all shared.

Also make the callback in early boot IO-APIC mapping code that uses the
fixmap.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/include/asm/x86_init.h |  4 ++++
 arch/x86/kernel/apic/io_apic.c  | 16 +++++++++++-----
 arch/x86/kernel/x86_init.c      |  2 ++
 arch/x86/mm/ioremap.c           |  5 +++++
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index c1c8c58..6f873c6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -259,11 +259,15 @@ struct x86_legacy_features {
  *				VMMCALL under SEV-ES.  Needs to return 'false'
  *				if the checks fail.  Called from the #VC
  *				exception handler.
+ * @is_private_mmio:		For Coco VM, must map MMIO address as private.
+ *				Used when device is emulated by a paravisor
+ *				layer in the VM context.
  */
 struct x86_hyper_runtime {
 	void (*pin_vcpu)(int cpu);
 	void (*sev_es_hcall_prepare)(struct ghcb *ghcb, struct pt_regs *regs);
 	bool (*sev_es_hcall_finish)(struct ghcb *ghcb, struct pt_regs *regs);
+	bool (*is_private_mmio)(u64 addr);
 };
 
 /**
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1f83b05..88cb8a6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -66,6 +66,7 @@
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
 #include <asm/pgtable.h>
+#include <asm/x86_init.h>
 
 #define	for_each_ioapic(idx)		\
 	for ((idx) = 0; (idx) < nr_ioapics; (idx)++)
@@ -2679,11 +2680,16 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
 {
 	pgprot_t flags = FIXMAP_PAGE_NOCACHE;
 
-	/*
-	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
-	 * bits, just like normal ioremap():
-	 */
-	flags = pgprot_decrypted(flags);
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		/*
+		 * Ensure fixmaps for IOAPIC MMIO respect memory encryption
+		 * pgprot bits, just like normal ioremap():
+		 */
+		if (x86_platform.hyper.is_private_mmio(phys))
+			flags = pgprot_encrypted(flags);
+		else
+			flags = pgprot_decrypted(flags);
+	}
 
 	__set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ef80d36..95be383 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -134,6 +134,7 @@ static void enc_status_change_prepare_noop(unsigned long vaddr, int npages, bool
 static bool enc_status_change_finish_noop(unsigned long vaddr, int npages, bool enc) { return false; }
 static bool enc_tlb_flush_required_noop(bool enc) { return false; }
 static bool enc_cache_flush_required_noop(void) { return false; }
+static bool is_private_mmio_noop(u64 addr) {return false; }
 
 struct x86_platform_ops x86_platform __ro_after_init = {
 	.calibrate_cpu			= native_calibrate_cpu_early,
@@ -149,6 +150,7 @@ struct x86_platform_ops x86_platform __ro_after_init = {
 	.realmode_reserve		= reserve_real_mode,
 	.realmode_init			= init_real_mode,
 	.hyper.pin_vcpu			= x86_op_int_noop,
+	.hyper.is_private_mmio		= is_private_mmio_noop,
 
 	.guest = {
 		.enc_status_change_prepare = enc_status_change_prepare_noop,
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 6453fba..aa7d279 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -116,6 +116,11 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return;
 
+	if (x86_platform.hyper.is_private_mmio(addr)) {
+		desc->flags |= IORES_MAP_ENCRYPTED;
+		return;
+	}
+
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-- 
1.8.3.1

