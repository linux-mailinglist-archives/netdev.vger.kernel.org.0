Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C6063FEDF
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiLBDcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiLBDcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:32:33 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021020.outbound.protection.outlook.com [40.93.199.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D5ADA208;
        Thu,  1 Dec 2022 19:32:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkUuYKAPTuLoq2Ak/ssOO4P2DvqhZRdmTVpsFRnAG3d2QjxmbZX03OxOIEBbJ+4fMwaEAmTtft86bS7CbFnY8aWjcJqsxfNED1q+M1fINLJLj7GlJeQXpV09yXq8N3j1aUexmrEW2YagDj2mk+7JdMqrD9dSsw07onjUQxdL0u0GmS4uxwxLTZFye6YsMLJmXAm3xXhzaHfw69A0iBEzm/GyzttxOtYRcMlTD8CH1c4EAiPVsBqWoNsBwF0m2YE0ni2hMqUIIMX3aEBScPsHoY/IN1fSOSzqQJnr/v28c0Pg1gBZu6zRa7aPHM2t2pUE3aJ1JByGqH9FDMTK5aHumg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=My+3F4xeoCZ4C3uLqj81e5Dg1XL4CiWYfO/yE8xDujE=;
 b=DD/Qmda2+SbPSf4T8WBpXGwmxgnskmT4Rjy6skx/Ny7qk00Wk6CYYiCxaPbSUAqji0nvtOeoNkmRESrXliQBhzkSwKNbzfSqLcTejccsBLqvjsj5pxYoBFWB9tUT4is3iZ7QROfLUNotMtDvXDbgVyra+yk7pw6rYSksdI9eKVNFW8LvVjtUpvSsQ/OlUxlEpHYdLC3fgSu0+pNYbNNRK4xWn8VTErNlmmPg1hbkYXXhJgc6dvzNKIUAcSLTJyeGbj0ndcdjU3X3/ds9IumuZofX4JZnGFA2T2GHy0Dq2fEWkP5kgQHd2sXN3tD/8YoGwIGuvAI3xM4exF3JMZFacw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My+3F4xeoCZ4C3uLqj81e5Dg1XL4CiWYfO/yE8xDujE=;
 b=bZ1F1mUiLIdzulNSaVVD8gvuxzngphyUqS5gZN4QKk0ElC67exuUrSBqB9ZspHtJlcfhhnJB8udY3gt6A8nN8vqIb23q8kYDvaB6Gj3ymjN+VTKY/z7wxGVtHz7+rCkqS2R3yDtwd6iw+GMA06lf5FrJR6w6EvXHE95u2aEnuio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:07 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:07 +0000
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
Subject: [Patch v4 02/13] x86/hyperv: Reorder code in prep for subsequent patch
Date:   Thu,  1 Dec 2022 19:30:20 -0800
Message-Id: <1669951831-4180-3-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: 05cf62b7-47ea-4b4d-390c-08dad415c9a7
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VsDVGJxIZsDzgbUvCed+nL94IByovZKi2QE4ZDsYVKbrRPVt7tlucaQ8Yy33pREcoZIEvhwk8YWvknFIuRRoT7VrsSO+mcZDVhqdvUVTw4nm9xw3BZk+KAE4fJHV1JTuKgBBGIWllRFnYfHXl6kU8ohjTRrx5sp1duLqBBGKrldMPDHBP3s0Rj6iulNsu+pvc+BuvGvOf4zMvA8rnoJsAhallruWOGjqcHlxMRYbtNdu4GgL53VG9/f4vtZCYsN1JhmYujt6wyqL2/ay+z6B5g73RapZQIdFwOoF8f7q/50U2ItYO5yyBT3Cffn46YtgoPyYHEF/LDsKJSbgnWXEoZf1iHZeiuPOpvZPVkiQVn+TOc280I5nMs9VPgN4hhK53ptz0WkxqimfZzCdX0KtpGxJlCiFqjwEbS00hWu4wkhsWgDuZ0NbZqVtZ3nIkO6QV/2qGzTPPgGjpV/k8912+esPPlNDrL1g13ZzmN9Mt5YKzM+fAB5Lc0fwFTtrF099Hwc5rIwC0KctPhIKJOyTvyR74fzGRs7eTJbN3z3BuqILVQX7AA9TJTEyuE9R/XRqqky08g9GSW9zBgxMoc8VxcgIeE4HLB7ArdgKznGoQ+ZtJwtj6blx4rFTc1RgdIlpsrBaU0+qdlJkrgB0ncUiUWdr5vf159y4bIWfGF2AcJKJ0Iz6+OJjFPENAEgaZ6hmgNrR52KoCgQ1dWJ+4hrRTgc94shoAUxXexd2bXQAommfj1sC+okkLfMeFeIRHhaZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3QzDZycjFG0ZjOmhnB7P3sG1vI046PZBw6dvujls9hMVwHb3a28upmVw9Lrb?=
 =?us-ascii?Q?LhbrNB4yW+s4/ax1QmxWWv9iR0rn1/Eo0BW1vbYRtQ73i1me4SmgQsg1WruB?=
 =?us-ascii?Q?zKVyDgMExnJ7Dv90w2DvO3uzLGzFi3J7l51ZLQCeGhOpl+xscParIILrjzJA?=
 =?us-ascii?Q?pjtUif9Q4eGBtFysIbyEJsrzXMYVyopMkaekNjfBe+ZjNa1u19KiyI5cLb0a?=
 =?us-ascii?Q?mW6D0Ssp08+/d3YWI1PJKowGrxuFqCV4x3/RAiir2SZblAw4aeiOo9Iqze9V?=
 =?us-ascii?Q?7FVNqUg2+Gq5tsPQZDSsDwg/Vl16+xhRoB3p2PCFB99bjmbsq/EqGpMco9ek?=
 =?us-ascii?Q?47ly/xwG6tSoHh9cqk2Pn4IhwKvpAW3SbBOMH3yQUQcaXZLIHQ+C2OZ2IkNU?=
 =?us-ascii?Q?K4fceNhm0ej4l3astpln3WO09tyf50XVL2+jLQjayQi9nGT5Z2cezf+YgtUI?=
 =?us-ascii?Q?WtSReGcta89E2Uq/a2xDg9ERidBwiV3qAc3oRgOAV9WV6UQ3DB10Y91wjnWe?=
 =?us-ascii?Q?x+syxPDCH88XafeNvV5Qf+BKnm/ofgO7HnoYqsUZfzFdpoFansRmw7oELJLF?=
 =?us-ascii?Q?1U1ld9dUOrrZmn8GygwK0mjKUSKX0i4NiZyfd/efgbaor1njaCUwFp/OoboW?=
 =?us-ascii?Q?muafaDz2H/eXXppuDjaZuxw57Ut1PnDsDy6TCdb2Fh8rtUynI8JrvIVhNacQ?=
 =?us-ascii?Q?dwpRF+TF6PDqeT2BVCS4zVUd31WLIBzdHSOoluIKF0jhXS1g1vmn2DpnqZxY?=
 =?us-ascii?Q?IMGvR/phTuxN+bSORQuEaWQzLXIEjEtlozWpdaJXf48XybXDlkO/YoMYujjo?=
 =?us-ascii?Q?ZlalB56vYB7RzGWNb7Mrm4oycupA5wxhpuVaSVCR/eApJdiINmB8NDdBe8WZ?=
 =?us-ascii?Q?/aXjx8V1HYdR30R2PpISYwtlAvV1h5e9/4sChymSamrxdNQFZel4n8GK+ZGV?=
 =?us-ascii?Q?Bk3WboDXL2nRpuGaya/uBDnxttNVbWS1PFuOBsQ64CaVQKI2QfTGMBuIPMb4?=
 =?us-ascii?Q?z/obrWmtnkFnpEwff50dtNSfG2x58gAVteUdbBveVMAGdsCB40iH/S09sHj3?=
 =?us-ascii?Q?tzLsSwp/3eCdVT5y1UAoQhFVPizBpval4tOMnu4ddqxTyYPjtaSXoQha+JRk?=
 =?us-ascii?Q?nvqaRzqX0+YALquzQE5ITChhcZ7nuVXNUbQUjKTLYz8f/cyFhaw7ulHtSAiJ?=
 =?us-ascii?Q?wzcf+hM4kRjdY09fkqCT2dS3TI03JHuNx2XDq6RAR0hMLYcPrrOiasZjMz0c?=
 =?us-ascii?Q?1QJnQ1TxzmrXfku+fMcVYVGQ4ye/yhKPF+FQ7bzJJ+EYou6kueSgNzd9bDyY?=
 =?us-ascii?Q?w7MhUwp/S4bWMRlaSIuQmNX7BzyQs7bN9Nu6cPoOHv7Uderc1cjybzG9Fe8P?=
 =?us-ascii?Q?hV805mBBNfvGtN9e/xaPEozjf+WXPeAq3asJK5R+LjVySNehaTCf3dcxp/sy?=
 =?us-ascii?Q?aQN0wrtjVyxPmaBH32IcapmdBZTTsxYSGv2cPGd4ZLDW//D3bYcEEZ1YeKDs?=
 =?us-ascii?Q?RYeOkCICqRSSD8RmZk0+U7virEQHorvB51MGz1IssZW3Zj/BucP079Ksjz0L?=
 =?us-ascii?Q?Z3R4roVNZyp0ED/fbWOIH8h8dcoj1cJcbXjWx5gKrcpaTHWrJP7HgEqt3AZ8?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05cf62b7-47ea-4b4d-390c-08dad415c9a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:07.1752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S82k+ZnyTB7SQXdiFPaNc6wA0dRJRtNoF2OvlbiJBQqUGfrX6zh+jbYpsp3wTdKWqr3WokklhGLnsYGviBpGpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder some code as preparation for a subsequent patch.  No
functional change.

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

