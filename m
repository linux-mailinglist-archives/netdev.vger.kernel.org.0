Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD306685F8
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbjALVtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240899AbjALVsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:38 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BD51CD;
        Thu, 12 Jan 2023 13:43:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um95EYTQHhXjTM2ilqgNmnYLF7Tz5M6zhL2wxF9zRlCSOMYSVUqNVBthpb9Hmr796/4+5XnFrBol61/zg/P6nuN01V6E62nJNbHa05D8W65K+F0Y8kiizpBvlE0a5WPHFfyTsVhd+NiQTLzIMvvy4C9j2Tt6E3UiAnYaXoDJBQwXEAcz9pF8rpyDvI480y1UY4wxBXSPtJAOTX2qNzEDEap0E7mHyX1W8KlMryirO+RuD3cBumFlpSdputAerb4ChJbFgLuGOTVFsmWkrtZ9mSR/w7WNox4nrEBbDXAzM1lrYL0wKgJ5m82fuM6Ru97ZkdxJBRvRGhkYDlHxg/8jhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prBl40LE1pY7rW1brW6ejZmnzAIhX7f98kgAyr5rCvA=;
 b=KMRc8nY4lqsNS9seHPReXk+RtunQ65EeXp96XG1CblGWhskUlCNMOwejkeMhIbrcprI4KwaX0K4ytUD0RGIix+LNE6gBv2GF4QoNh+FXHHu8fTKlYbb0CgP26aVKA13Jwx9kM/EnYipaUMjX2huOYG8tcaJSUXi+c0komSHycEnkMI2s3tyMGe0SZ4OdA0bZgOuc71sl6HCqaix46Dcw0OATHQsZ0DV54CTxNAZC5RdT90hinD6S+jpQWpOcchqIq1/WIMFz8DH8cEyJSk0yfX3BReUNN5gx59O8txoPwA60KxMEp6vWXHa3pxB1YUXHVQ/72d01+xVnif0svt/S1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prBl40LE1pY7rW1brW6ejZmnzAIhX7f98kgAyr5rCvA=;
 b=VZcGsfmAbbjBR5EBZHMHvYKfT/S/4+VhHRt909MsqfqntLmNEn0pKsn8ljVp9pI2E8CfrBZ2QwjuwErGS70aH9bfLsczDKS4KjZfSPZqRQpo+LH0CITrZGjEzRyvflUXBfAchEiDENrxUrG7u8SPBPQOXAT6Or8osKoZJUsrCNs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:42:58 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:42:58 +0000
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
Subject: [PATCH v5 01/14] x86/ioapic: Gate decrypted mapping on cc_platform_has() attribute
Date:   Thu, 12 Jan 2023 13:42:20 -0800
Message-Id: <1673559753-94403-2-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9808566c-fee6-4821-098c-08daf4e5f884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4h6B1nLXCtVOyqRaaTnoYoF0n8L5ufqRcj+FsXNr28z7R3dkWDHBVp46dTuFc7O/+rDYDORec4dfxFT0WeS/W0cBP2XPi5myiuOzE5ONuMx3qfnQ4nk1m7AOneDJB5IYTUBwD+cOzjM82QVsHh8zxzP8c9Esh4MovKwhvhk+Gs48rVndrTfFZyYyiQGKjYXXFAm5Ko4IaEsDZGCtu8z/K4n1iYxI/76eixWmvtMKQ0ZLtfJ/pht4rKLpDCAVvHkNkBgvfWawxoafYRWv2sMu3Scem/o8CnBT1UB80Z1tgLsCIh4DfqsiW69TJZETxyzQ9hKtsKoLABS8zfWj35DVfSwh8dsM1gkV2D13dQzLCeRpKcx4bvs8gCRK0nH91dFdLo3IJ41Fi/9+0NWsMyJNsdxRhF+K7WP21b+Q3iV/y5t7aGCU2qdag4kMvyJskU4GNOuOA8+CMw2vzF4Mel5V+fipkhYAp3Pdz0CfXKsW7JqiY4DcfTqzbSHvt+qeCnlQJ/xyplxGHxE6xlXLjtjlVXimPZcU12ZOhD0mYxSiTF3g83SrEc7cE1W2ryOZUjeehOORaq6rWGqgWNjPPfwX8aeHnSb5zHnltxgt6yHvEIKMXFK9p4lNjyI6zffLIoObgzlhZqe+vnYQuGys5TAm4T2cL3z2Ms2lpOQWmUodksBjW/sRsHSXiTN5QGW0OW8hTxkiXplzsuB8QK/GYM+xuaeviUlUMmgjjeoX7yIq6D1cgSujKU7WtulIDHwjIiR2XmU+gPGZvJdgSLnWC6nAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7h/7b1pufhuhWNL8TtHjR9lu6MEaoci139rZvOXaw6zRMCF4zSOlBP7aH3tv?=
 =?us-ascii?Q?gPh76ZPKOZi8cht62/O1Lb1lzu5yrpFok74sEkPIfmjHYo7EC0dZXtf6DEEq?=
 =?us-ascii?Q?RrPjGFXhdD7cR/+h7RWbO/HqjzRJb13Xz+5Jy2Dw4IMSUTYDF3pY7tD6xT2l?=
 =?us-ascii?Q?cnl8+cUwCpIfa/c98/l7SxlLm5ZhVrpL1006w1YofixqSN5mS5Q3nRVAgkae?=
 =?us-ascii?Q?pKTsgPgEjReIR7KIPelN+9lLzDKVvrZGW5mCnyjwIuLmaHGlPWXqbNrIs2h1?=
 =?us-ascii?Q?+8X64lIhZ8O4bzXeVd04eF/ENlhhEV6OKi/ZGc7ZMAaSaBmGZi6c+MjDZJiT?=
 =?us-ascii?Q?XOhkp5XkbpffZo8HRHQVNP/Tp8iDHk1h/09ykSJVMXrk3veEvtUnoLyJgaXa?=
 =?us-ascii?Q?6c4GSrlIB+KMA0MsowCjQKVRPHeBZrmaO9YJ8i4qrzdSqc8s91ygL4j3dQDh?=
 =?us-ascii?Q?Y9D6fnzOdNmhNzNfGWSmo0FNqJKuDROnc2Ssh6bcM3/dIqwEGTGSZA+gPZOf?=
 =?us-ascii?Q?fI7SCXYjXXrVRpCEqnyp5Vo6dy4JytINS59+pngucr7bwXtCVUiH9SCavoUM?=
 =?us-ascii?Q?PoEkbDKW67VlAxVs4odp17S7m1J3I8+O2lqiWrv3jjVXH20FXGbDsaj1Fr37?=
 =?us-ascii?Q?uQjRZqYJVn0t0XAN1IzoWjOaIjh9CQb9cbSqnX62a4Y+hCMlup0g8rmUpqeB?=
 =?us-ascii?Q?w3w6Ftx2wGucrs5l0qEo3BrJTg2MiA1PzwPdgpoQfk1UCQq9RhOEmbqX5i6i?=
 =?us-ascii?Q?LeF9KGe0YBT6IQ7nOUj4Ov1SOi64Vx5zeLzq0fIVrKY1p6zlvLzGUBXfSVBb?=
 =?us-ascii?Q?FM6oC7MpJBnJXii2F3x1E+tRJMUFL1gI0syaiq1/XPQH0WUCUnrDFYMFNuS3?=
 =?us-ascii?Q?k7Ko899EG8iOdBIiMbHcHUVJacXT1pvkNhhzBv4Dh7H5dstPR0My+apQ52k6?=
 =?us-ascii?Q?H/A+hSkiTwjRnrC+6a78dnTY085ayIPdM0HumDLPeUHxopGd3uSBkm3fnuyk?=
 =?us-ascii?Q?gSD/4TVCUj4TvPYiOgLOWVuXuXkOQ6frMyB3Tsw1lxMBDa564kx62niTS1RE?=
 =?us-ascii?Q?gaqufcdqAEAmUJfU5r70KR79C937V9YasBusrZ3J8O/tusz3fOK7ucMogchG?=
 =?us-ascii?Q?8S/eqr/Cm86q2xS16VZEQLhUALJo1AFp/Z3fF1RI3tryaLmyy5nHd0V1dAKy?=
 =?us-ascii?Q?m6romflyQxnWIIJlndy1NCYDSJN7mEjL/SrvThUgd2X+qHMtNCY5xaYoMS3J?=
 =?us-ascii?Q?PekVh0gM7S5utcSq06RVi8EoHcqw8LViVz7X0FXeMY23PZ7H+EtBbp8KDPvV?=
 =?us-ascii?Q?O8wkzPAxuipRbkPq+AB7L6YG8i93kMLm54kTf9088poGWpjfL58srkwGgURG?=
 =?us-ascii?Q?ECopt7X+3n4b/swJvaalVsfBt6ef2eRBWx4nIQm2zGLYylOuprrtlreXv5dB?=
 =?us-ascii?Q?AcKY8fSHVihHgOjJR2BrqL0rs37uDugcWYj4SgqcMtaSN7FOajsbW4jwcDQ2?=
 =?us-ascii?Q?fsiFguQne/BEsysc32zAxx8PvAJgL4E3SX2VxbD7ij0BWOPny3QQfprsUa00?=
 =?us-ascii?Q?irlwRF+JYNxazgmKz/V1vc4RyU1DBjyVUIciKQnyMwqR5vLBCBkpmBnemEEh?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9808566c-fee6-4821-098c-08daf4e5f884
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:42:58.2780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIJ6ADs1bXlT5A2RZv75TbmQYWNFS+8HChvPi1tef3fFop3OWstGnyYJikQzGA5rHSY2yIIWqFnHtZUn/6rtkg==
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

Current code always maps the IO-APIC as shared (decrypted) in a
confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
enabled use a paravisor running in VMPL0 to emulate the IO-APIC.

In such a case, the IO-APIC must be accessed as private (encrypted)
because the paravisor emulates the IO-APIC at an address below
vTOM, where all accesses are encrypted.

Add a new CC attribute which determines how the IO-APIC MMIO mapping
should be established depending on the platform the kernel is
running on as a guest.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |  3 ++-
 include/linux/cc_platform.h    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a868b76..2b70e2e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2686,7 +2686,8 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
 	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
 	 * bits, just like normal ioremap():
 	 */
-	flags = pgprot_decrypted(flags);
+	if (!cc_platform_has(CC_ATTR_ACCESS_IOAPIC_ENCRYPTED))
+		flags = pgprot_decrypted(flags);
 
 	__set_fixmap(idx, phys, flags);
 }
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd..7b63a7d 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,18 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_ACCESS_IOAPIC_ENCRYPTED: Guest VM IO-APIC is encrypted
+	 *
+	 * The platform/OS is running as a guest/virtual machine with
+	 * an IO-APIC that is emulated by a paravisor running in the
+	 * guest VM context. As such, the IO-APIC is accessed in the
+	 * encrypted portion of the guest physical address space.
+	 *
+	 * Examples include Hyper-V SEV-SNP guests using vTOM.
+	 */
+	CC_ATTR_ACCESS_IOAPIC_ENCRYPTED,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
-- 
1.8.3.1

