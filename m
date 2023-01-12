Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0E0668601
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjALVtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240918AbjALVsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:38 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021018.outbound.protection.outlook.com [52.101.62.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F85B81;
        Thu, 12 Jan 2023 13:43:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5V2Sw/KWmBI0jSD/GLQhu1U60bkb33o1PYEWFLFQ+8q/951cRHGFbbduJwKxDf7OqY1aTLlbpSQuEHEnXykoq+CxaPPYcDq2Pb01BY4GQ6PdDuO99/7sj0Ktqe1MBAtEfKD1qBA0yiml8uw0U7GdZFgMMdqvvmgWmJO42WV2J1/l9NDwMmeULFIaU7ZTzJccW0T+VenaMQQY4fc7sGEpdAnlOHnD/S82LUamOz0YuBgDwrnrWH0I7ByE/sn9Jk+mwLWM31EHyWqovbe65t+7PrH/X9YH758hMRH1X2WAD+3Rh5LMWYhAVhKlvcuXxKgFA4jkmkCquYkiozTnGh1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbHFPFmTeMZYHHAR+6LzRBCkRR+Lt6NfcAGOTQF+av8=;
 b=mBdTN2DJ2OiEvk6Nz1Zaw168kNerDxqdM4gmkJ+Sn/YXGIJvLFv0iV1PaF4qA4Pw9hmvKC1DtGNUGq5HfzZ+i1sJA96sXw4Rfnl1bQncdFnO0RwGoVkYNUQX+qXmvzupUy0GdXlLKIj0ECc7DSCGI9WJEM9uHIRS+2WWelJTzxLf2RAA31S+o85jk7RvHc5BSLAerYMpUg/GmvaPs5TYsdFpJWC1UrNOUtUJTJUJecBT/DmV4S3Wpzh7lGdiEuFPfY1LS9NqH6X4kpvR+TzJsYmg974niPlsb+LpeCuNeOdF7nAbHP1zFKrt/mzGRoLMCWgOkjciguw2fvds9JH2pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbHFPFmTeMZYHHAR+6LzRBCkRR+Lt6NfcAGOTQF+av8=;
 b=LzQmz9iZsf2q3fsLiRQPMFoATencT2hMTIEatsVQVII0w7ohk5+kDag4+vthu6nwthj4Npcv1FazQwCv9PpoU5W0r9jwAFjlr3bqbjO7+UKVPNmaWc0aEAnTV2ibrU+BK/jF2Np6ZKgh2zGD42zbGs/nZKcDn5fShr10UGZvw1o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:00 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:00 +0000
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
Subject: [PATCH v5 02/14] x86/hyperv: Reorder code to facilitate future work
Date:   Thu, 12 Jan 2023 13:42:21 -0800
Message-Id: <1673559753-94403-3-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: c730d0cf-32cd-4428-c94c-08daf4e5f9d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZLug7Jhw6z9kW706ZqljyObfT1uj0x6KmEQnhJwt+suQW3gS/CS3VYwuJCyqFmTFw8xxVosfdYWaq0ZSoT6dJr/KeGZsYp60pGJkqutB5iR9/EPHrzSunqC5hZam4U42krEZAl5eOTcJvIpFo0f1t1d0iI+qrvrpwCxXfDZH4C9V8V9rpVek9omepGo6Mms5w6MjcEG4djoBy1LBKwE/mhy1J5uJRGVx4jPXqUqRMRY4KOC9dAixNstQMa7Qd7DSxSW0KTlnLqY49hmphHE1uIQNXRVbs15TwcJDRjOfBf/4uihBDkqvLRIyimLlJI4tYPtt32nlsH1q0AGGoxhdJlQgDV90CVsy+qiep3KI9sfo+lMD/B7YvJywIGFf64HYHZxP+iNdk5r/8TuXnL7sYT2i9fnGDjBp/KYM3fsxY9Q4ElxPD9rTPyJ4MQ2YUSB9MOXBTkSceLVN4LoGDfwV0c43tITPJpSLNEelzXkc0NI/cbquQ/SGqFURmZejfpPpRFNpobNSRiWr/guMntrIY/VJ/NDICtRs/ekyd/17U6Xhw70i9yvQEZuJ6HP50w1j9jJqU/Az7vh9RXCcKX7bQ7yva4lifjBQidTQGF9DXh0mX/9ADWwF7JgdZXfuJAP2IrM5BOZ/Qn/ka1XDktrerKNtAo1lqVePlyf9oqMaCmHOtX84J0NUDAxP+3wHxtYGDm4JNtM+zF3RrW+ZewCq8FuqCUSvInbRR4CJUp0jVp2+jinKVxZgvcJ5csCIAQ/oZM/qGmRNw6KktQll0oVr6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JxFIRFdsDrHUV/FcckO1RZNiTp1Zy6gLmynuxrTiV2sCO0qZx0nvhEUMf0zw?=
 =?us-ascii?Q?ggM+7lCoiW65XzcGD8V+Wz0rMaYq9Cjpya2uEU8r+R5TCOiEZDQ7IpEH6k/f?=
 =?us-ascii?Q?maNJDZOPgkU1de/yL4tO8IigYllwNElqFhaGZF3yaGxRDoLFefKCZfANZVMy?=
 =?us-ascii?Q?1uHWxhyg89OSr0s6OKqTAZQ0bTpl8LmtYQEs3uRBzBn+7c/SbWP/R1MIzqUI?=
 =?us-ascii?Q?39gGTarX8G/YB1CZwXCI6ppDZllvqlwnno/U3YYRqw2XCc98AOQ2rjQPwQVC?=
 =?us-ascii?Q?mNFaEg8yu09aDPab2+bBrsTKjqiOL8LwiclvXzrQp53hzYFov+iSTdB5G4NF?=
 =?us-ascii?Q?kdbhDOaWinFTvdSNeo1MRwB2dirMJXEv0kQKbEGHkTxajyTfOE9KGELkgyUz?=
 =?us-ascii?Q?DTPQweOyF2oXc83moHQDAiHdmoGy9NyCkJ73CId1ADnrjN9VHZy73/tLe38y?=
 =?us-ascii?Q?ia40C4SX6N+Rnh44PUDRblLHURaT2BZLfp56zYFlzP8CyGZnYvOsD51wKYWW?=
 =?us-ascii?Q?jnu9gzorJaHXxwt10qWIkKagI+wmdK9Xrb/IdPIglFVPmRbjhoJnaqQYXCEg?=
 =?us-ascii?Q?fJLpFSYmDZlV77AauJwyiLbNiWQsbmTM8fkiPDNSV6VGRx9fu3PVyQsryhnr?=
 =?us-ascii?Q?s+F4MplbtUFC67Pp6MeQlDWu7TSkjECUn4BYutWyPXV93SgcsJYgONx0IEyh?=
 =?us-ascii?Q?ZZ7up1GCzWoXRBFTN6XzF/4N1+e8fZSVySXakF7jOa8ig2pcLBLRFWEWLn0G?=
 =?us-ascii?Q?vwtG0nuLUYc1W5rot9mFN6ijzxmY9cI6iiHDLGmEsJhIyTtzDb/WOVLlwPTd?=
 =?us-ascii?Q?jl0ZTyfRg02HFeB3mbAw55a0C8G2SEXhHe0ZubxrECbZMyXJxjzCmSsjHUO3?=
 =?us-ascii?Q?gl+8VoN2v9/ag0pLGVtdmg2aVuQUeP0bXQPXXA+cqEuQt+7kx1vq8Oe/owAM?=
 =?us-ascii?Q?9xSRhla80fVt/oR78BcJPG0gSnD34UDPhVRD0AOTXP3EqkUUC7U+ysS2clId?=
 =?us-ascii?Q?hoRyMqdQGZbpffFN1hQjqAxMR7kdHe8BsEJiPqCeKqmQTPiHvBBErHhWBhjE?=
 =?us-ascii?Q?g5VI5diBKDB8uJw3q8SetgqQQH9UYT7vvwA7Yd2K01HPLCPwInBuC/HL+fdK?=
 =?us-ascii?Q?Inly/+8rU3tn1D+sJlZWgndB7fm/bYTL54+ADwLLMGQWnKcanWTIZSxQyVa2?=
 =?us-ascii?Q?62kiS3a2W1Eogqi1HWVkVNSJB8bdSh9ZTk8px5pyEEI2gtEOLJQMzWN9otAq?=
 =?us-ascii?Q?S20Ib4EFHOdnNs25FNt8dZuke7eAVX6XRea5c9cUEj7XHb/CFDq5PmRVOEFX?=
 =?us-ascii?Q?s2+XsZF4UJjN6BFE3uP8MpvCRvNYzyYEfkM0wFm1GPXesJJHhzuMxOHjcqqK?=
 =?us-ascii?Q?WhYc5S/Bm/emrk0cyhGn+b1YAbfVjYa6tqSAsczapipO8F5nTObnmXsU9bkl?=
 =?us-ascii?Q?hBRKoWvlcHH0Fx8aJmbEEFdLbdhWnaQqS8YaXW4NkpL98P3iSmWw39jMfxQ3?=
 =?us-ascii?Q?ZIdE99ahM+26Nht/INurXpxGNyBT1a7qxe8wPTRrY2sn1PAV+pXHS5RuibxO?=
 =?us-ascii?Q?hug/e6IgN1ZON/Bh1UR/ymngPjetIdv8Gqn/6LY7NAsmpeLnURsgwBbDA/eh?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c730d0cf-32cd-4428-c94c-08daf4e5f9d6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:00.4356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXP0UjRYpVxEqaRd9krStLG3VVjhBn4jfCU1BBYK+Q+goViMQIRxIZYdwGPbeGXn1vU0cjy2nOEcqZrmAWME3A==
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

Reorder some code to facilitate future work. No functional
change.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c | 68 +++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 1dbcbd9..f33c67e 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -235,40 +235,6 @@ void hv_ghcb_msr_read(u64 msr, u64 *value)
 EXPORT_SYMBOL_GPL(hv_ghcb_msr_read);
 #endif
 
-enum hv_isolation_type hv_get_isolation_type(void)
-{
-	if (!(ms_hyperv.priv_high & HV_ISOLATION))
-		return HV_ISOLATION_TYPE_NONE;
-	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
-}
-EXPORT_SYMBOL_GPL(hv_get_isolation_type);
-
-/*
- * hv_is_isolation_supported - Check system runs in the Hyper-V
- * isolation VM.
- */
-bool hv_is_isolation_supported(void)
-{
-	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
-		return false;
-
-	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
-		return false;
-
-	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
-}
-
-DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
-
-/*
- * hv_isolation_type_snp - Check system runs in the AMD SEV-SNP based
- * isolation VM.
- */
-bool hv_isolation_type_snp(void)
-{
-	return static_branch_unlikely(&isolation_type_snp);
-}
-
 /*
  * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
  *
@@ -387,3 +353,37 @@ void hv_unmap_memory(void *addr)
 {
 	vunmap(addr);
 }
+
+enum hv_isolation_type hv_get_isolation_type(void)
+{
+	if (!(ms_hyperv.priv_high & HV_ISOLATION))
+		return HV_ISOLATION_TYPE_NONE;
+	return FIELD_GET(HV_ISOLATION_TYPE, ms_hyperv.isolation_config_b);
+}
+EXPORT_SYMBOL_GPL(hv_get_isolation_type);
+
+/*
+ * hv_is_isolation_supported - Check system runs in the Hyper-V
+ * isolation VM.
+ */
+bool hv_is_isolation_supported(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return false;
+
+	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
+		return false;
+
+	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
+}
+
+DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
+
+/*
+ * hv_isolation_type_snp - Check system runs in the AMD SEV-SNP based
+ * isolation VM.
+ */
+bool hv_isolation_type_snp(void)
+{
+	return static_branch_unlikely(&isolation_type_snp);
+}
-- 
1.8.3.1

