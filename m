Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF236685EF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbjALVtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240968AbjALVsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:41 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021018.outbound.protection.outlook.com [52.101.62.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B1CB4B;
        Thu, 12 Jan 2023 13:43:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtMNtXHBNo3zAh41Dg5PmdAZTslKguV8jNTpaZ8e65ziSNQ0JOFdTs8EOWvonhFjaVWgoDg6ErUhHjAZN48wQxhGt24Vl2Xvb4LLOd+gLMoKDIRLysYflAzuOpHPa6fci2fcAwVLWJPFZBuCyTcuybuPO4Xmv46Ye0jGvTwpiuse/YnGHh8blq+cCbDPSSi1ygFx2QJy9R/EW96cromQ8QikmdZk416vMmwQZigLfHwTZd513IJcF/+rRmOYp5gW9X4kYDQ+NUzI2Kwv/92WYWk3atsKM3tBe4co6+Hv2HazjfdRx83MyiWwte6Qfuhc+vEjP84wmN6sBNTztinwJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jo/7z2NizQa93c/Nkl/lSx9vly8AsdrlK083lzTJtbQ=;
 b=gGZpKfzsqfL2c92WCSTS3odAv++fRh3PL1DJUz/Qhw+IGxrkK4CzOdpFWLDpSIS5T82ldMU+WXxUiiDvJhvcLB9BcIL47QDNVMEk/rMUgUD1pHdnz7gYGBGjnpMCOE5wgTfMU+VtdQmkGjvcPppvAtxstoTzEaSucCRclAs210IJmvD63UONMiztZTJEqkWys93oVXnZzYOZBuG2MwiYodQvQX9fbJDr/sZzv6IyQvC9JKn7CVdWaNhzw7ldoEXRszTrLsYNdS5FMSKzLN31EarPXYEcUgx4PMBZIJQQdZRHhMfG1M23VvhT7ZzIqbce3B2embfo5twIH7t4lgm/vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jo/7z2NizQa93c/Nkl/lSx9vly8AsdrlK083lzTJtbQ=;
 b=I8CAG3lhekwsPJbSXAEFgnZbTjW4zAcjIcbgNoIZ5nXY7uSP2cFhb/+LgQ7G2uPBjVSgPC3a51h+ETjQFGaN0CDlMCbqErpXpcDTsplqjKYjRBjIRNk2Nsi5q6APTkMO3Yh+eK/wawV6zw5/vhh0cYxpm94Ign1i/ArwRt1AYiE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:09 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:09 +0000
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
Subject: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range to map as encrypted
Date:   Thu, 12 Jan 2023 13:42:25 -0800
Message-Id: <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 06e037a5-3427-4573-1658-08daf4e5fef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQOQgocwf1XVaSPUTxKvESH4cZeWMXhFCWV1iAgKQNMqCJPh0MBKJXi53taucGpJ5lyblNpDkCabXI6pXpM5Oit3OfUCrMXBmBdB8a0IflkPm3oMMp/ADGjj1YW4s23H654p5aLY124rQT41CNyCYsy+AhpQcdkWZIjlaWqCvaO95rIZ0xI7UhwIqL0NFdSapZcKgzt6gLUY+kyEjw5mdbPLxzuY1ueoFhHK7DvP8b+8dVgPsXkWqvUWJl+et/Rv/ZEtQSvQTTQqZeA4FkMh7ndMxZAt5lZQornhpHq6YGryaP5q+uXRwBYNll647tSawv5CdAN9Ptdyw+bxVFPvUkoxOtuH4sVfG/zdbIJpKXTGUVdwP96fRiVS8NcCRlXZ7LNxgBt3wOPCvQgnAnZGMm5fLxkrVwRIEzNPRIxQxPRuKffvDjQM0mFQ8dLZbf8YyKZCxzWM4urpTFKL8XTv9cVhB5p3JO+2mfkLcdNuYNmxLfTivCsoJksQ9SORgDHAuYkSjXEHgPJUF9kSAtNLSMYlVAA3TKWIyfi6iTFNtk0HmQYItIDApTIMMjuemI2Im8d/9n6NNPjRIJ7Mm0B5R3/F+clFE3+PJQVuCUMiOIp+lw6++c/sT6ceZM2wgSyC4HwkbnfyUc7mKSy5TNwh6hV/pfr7eHwFTUmB7YxvETmgHhbN1oAitQ7Hu4Si9fCZ3Xbu+LJqGyHkZFY2Rd8kF42mb850luGOi4nIdtRurPmuWXFhJ3P+g0K/q62aU+XjN8LaTi2jPNZ9+2yFRTxNHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(66899015)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4EeAElfzrssHOARVqJ96ZUUUTyVWHsSXPfTKG5Peag2AxFtJqRHUAIMFqLXX?=
 =?us-ascii?Q?9zR935l8pHrfQgGOUKW/GXLyEzsLA4zl+i2uoOaR1+xSTMyod8a0tFF4J573?=
 =?us-ascii?Q?+/X2C6lJELgrMtMgHqPbhPNAsL0zq40KjGhgG5eqmgel0krgicpIC7rr46Sb?=
 =?us-ascii?Q?SB8b5a9x2uys0gDB7Gfc2altNkZ+IN/offvnS5iGtsMte9oXXxEHMCbJFioE?=
 =?us-ascii?Q?UZ9IYc3AOgTi1yXzQ99oR8729wsu/3F6Psh8A8XCuIDWSp4j9AF4hXECIakG?=
 =?us-ascii?Q?tHXk8pHWxKho6rEb1gZ+5YddJ+0aWIvAtYIyI3EkVmRUxp1K/M778zcYg0O4?=
 =?us-ascii?Q?3HhzAAUuUQhNtdmXhzYHJewdyNkBR970xt9eBEgkMNVYgOom+na449Ny1ACu?=
 =?us-ascii?Q?u5Ex14ItjqSPiGiq7s4cI+sr185+Sif0dY9GmA48sJter84h+2jS2aRtZsh4?=
 =?us-ascii?Q?M+b49Ontj4CSblGIRz2XTxxoq4EV2Z9idI/BPXPvh7YrowkTVkzhQIrN84Sy?=
 =?us-ascii?Q?x8/5frtPA3DJnNIcXdNILw8+Ptz5PpcPapAATJoE2XPP3fMqb8JEf/7/yW3i?=
 =?us-ascii?Q?wg4qgj5pqhFKjhPy2ZjLnuBMgiuGQAWCm2gbFMHA3jHkwNcELWdhrGA+0puI?=
 =?us-ascii?Q?nuABHLyIuSWBVyWcCfXQfK9ZksxhJGkQ670ZgSOp7G312dLRU87vxUpJPh+Q?=
 =?us-ascii?Q?y9NyLWBMJyUqbPGN0Xy0vG7YZc1DFxrMeNce3RxV8LfsEWL3vqCej1Z+Z/Vv?=
 =?us-ascii?Q?QSOSytzBmcAC/Tf1n8psCClDt0IqMbZDVM3YXDQj7TZAGlqD1vrolSOmu7mP?=
 =?us-ascii?Q?Z6Mnfvn6cTaM4afLXI8wpKtN+Me0lS36uW0Y0jNvjwwTihNm7dv/qnAnTq2d?=
 =?us-ascii?Q?k0063UJLuahpKaCqBgCsnm0pVL4ZjrLZhbOi+6QpNID5z8yuLkCYN2T0QSsz?=
 =?us-ascii?Q?KSMobDR5iC718JOyOeodIHRsgOaZ7IE+XuuymhQbncBY2GeF0zRXG7Q5EhJM?=
 =?us-ascii?Q?TdBJmLeUz0ddiqxF990mBTEWHQlwUGWMPxw6IC/ihhujHN6vUGiS4G/o/WcY?=
 =?us-ascii?Q?nX8ylZ6WZYLz3HQN2ibXLJCS3+S8RtccaUddfpR4E2A8V3epOraIyzjD9HQw?=
 =?us-ascii?Q?BrfgLEj1+bqy16CSpfbUG5S+i6Qg0uOPePjJXc5Dho8jFWJERUSwEY1KTDWv?=
 =?us-ascii?Q?CB+x+MeVCbRSCutyRN90cb0Oa8J2AZ/FxcwV8c2T7NGViwAujp6lkJFCajbv?=
 =?us-ascii?Q?SEh0rOn6g+8xpT2U47d7mtN8MEXH0qAA5B3r84t2AIcoZWddBhNVQ8N7gVzI?=
 =?us-ascii?Q?m1EzEEJg6cW5Mkomk+SKuFWBIdAC1ksSeFew81j88vjuU/po9v5+s55wfu/B?=
 =?us-ascii?Q?rdHsIFISkIGX5jeSbvNaLLhybrBglgpSgwLoxm4w1Zw47Q5tstdxeB0ZMH6i?=
 =?us-ascii?Q?2rHiejlDBxXpXYQnflDuTGwYKRXv2NyCCt848C8rhJVfm16MuD9Y4D/1zEMG?=
 =?us-ascii?Q?d8EqQvulToPru41VvKqWukUNxKN5g+nuqhTSQVn7MddTvfxB3rYeaTIiOyX/?=
 =?us-ascii?Q?NUR1ep/sJAGntWxeMlcuvSeVKIVTSMzth4EYNGkQ?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e037a5-3427-4573-1658-08daf4e5fef4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:09.0006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxjgmQqaSS/UXLfI6SBTxRsLQqm0qxOGvVyeR3MEFs14y7NEW/IBWHSJjGQ8PTQp4ZSEICEQNH0B3Ubio0LY7Q==
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

In a AMD SEV-SNP VM using vTOM, devices in MMIO space may be provided by
the paravisor and need to be mapped as encrypted.  Provide a function
for the hypervisor to specify the address range for such devices.
In __ioremap_caller(), map addresses in this range as encrypted.

Only a single range is supported. If multiple devices need to be
mapped encrypted, the paravisor must place them within the single
contiguous range.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/include/asm/io.h |  2 ++
 arch/x86/mm/ioremap.c     | 27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e902564..72eb366 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -169,6 +169,8 @@ static inline unsigned int isa_virt_to_bus(volatile void *address)
 }
 #define isa_bus_to_virt		phys_to_virt
 
+extern void ioremap_set_encrypted_range(resource_size_t addr, unsigned long size);
+
 /*
  * The default ioremap() behavior is non-cached; if you need something
  * else, you probably want one of the following.
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 6453fba..8db5846 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -37,6 +37,10 @@ struct ioremap_desc {
 	unsigned int flags;
 };
 
+/* Range of "other" addresses to treat as encrypted when remapping */
+resource_size_t other_encrypted_start;
+resource_size_t other_encrypted_end;
+
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
@@ -108,14 +112,35 @@ static unsigned int __ioremap_check_encrypted(struct resource *res)
 }
 
 /*
+ * Allow a hypervisor to specify an additional range of addresses to
+ * treat as encrypted when remapping.
+ */
+void ioremap_set_encrypted_range(resource_size_t addr, unsigned long size)
+{
+	other_encrypted_start = addr;
+	other_encrypted_end = addr + size - 1;
+}
+
+/*
  * The EFI runtime services data area is not covered by walk_mem_res(), but must
- * be mapped encrypted when SEV is active.
+ * be mapped encrypted when SEV is active. Also check the hypervisor specified
+ * "other" address range to treat as encrypted.
  */
 static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *desc)
 {
 	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return;
 
+	/*
+	 * Check for an address within the "other" encrypted address range. If such
+	 * a range is set, it must include the entire space used by the device,
+	 * so we don't need to deal with a partial fit.
+	 */
+	if ((addr >= other_encrypted_start) && (addr <= other_encrypted_end)) {
+		desc->flags |= IORES_MAP_ENCRYPTED;
+		return;
+	}
+
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-- 
1.8.3.1

