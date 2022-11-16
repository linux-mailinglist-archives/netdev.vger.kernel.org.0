Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CE462C7E2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiKPSmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbiKPSmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:42:31 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022026.outbound.protection.outlook.com [40.93.200.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF37C5B5B0;
        Wed, 16 Nov 2022 10:42:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKdAfdgeZQ7JnW9dcnGXR1yHClAPTceGupNYRaBuzspOFKBCcic4SNFSVrXLKi+JaPXSbQXDOvXGONTisYWPLXUpPvM+HL9r3tWlJJVbp0go20b+DEu4xL7i1eV22hrvel0QR4sMAXxapvk8zOT63r1sdxosf6voD4naM/ZjNPNMZY2jB0YldFk/lgEV5/nUulyasZ4FqNtp1X0zunVzWcCde8c4McBiwgHKakt0Q9AF4Dr/A/C8fVdiYqvUjUSfw+YBSfqTM8xLTRSJ10OqFjk+B7E3yz3r4rxuju0uHEGrMKIFSSut3rVIGm0D9ygAFNnLrFbrJHbdKpbrmIApOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=My+3F4xeoCZ4C3uLqj81e5Dg1XL4CiWYfO/yE8xDujE=;
 b=jLup3y50yD/Qu/tBepqLjxzFNU1W1qkMUw64GjsVhJLw/OjuG0j7+hzfHiAAD+PiKqOCSWIkcL2OFDQjHhQQZEEi/WcHcKaY4o/fBkv+gK1LffldX9v3LeAbn9GsZ21IYCANVlvJrFiarIHTvoxYxn6PkmvzqozquWAIlxDs/fDUuWQs2SICmt2WzEiPm6n62RyJ7QyOECnonyRLWciyafjEO7lT+XBB0wcSk/CgVDW+oQKoA/2M2nPdeXj0zB9PPkGzDP+CCeEMb6/A8K/xEub8i7aLTKA3TWX51KeZ68FdSZ28UmUfeI6HK8SEPtcntxNMbECbToVKClahCp0S7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My+3F4xeoCZ4C3uLqj81e5Dg1XL4CiWYfO/yE8xDujE=;
 b=hbbFkC9eY6RFyeis1iwMSKXOEwv+Q3jXEzjnh9HWi7iaO1tBDcXmleyL0oG+YxOsDgs0aJIR3Sw+SDyXS0UcNUWzOh09MPx3Dd1F7LakD1158PGR/AJojHluwABd5hopfNgXeC6t7frg6WydFzm7fiUxDOZE4bz2c01mr8djuu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:28 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:28 +0000
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
Subject: [Patch v3 03/14] x86/hyperv: Reorder code in prep for subsequent patch
Date:   Wed, 16 Nov 2022 10:41:26 -0800
Message-Id: <1668624097-14884-4-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM4PR21MB3130:EE_
X-MS-Office365-Filtering-Correlation-Id: d13389da-5585-4ea7-2445-08dac8024fdb
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBhqk/qQeMlfL5oU5uJdXIj2Hxdb9roKN/yFOds86t8V15oFaDJs82YLM5RtLD1g6+S1kxXB3gg45SA4JsUaJSlDwkYoXWr+UR5x6Va7dEa97e4oAHPuG8ffuBPqupRcpo3bfl+PXJ/IGYUEdTWMvCuyoS++6mdSMxFSJQXmkD5mB/YgmE6e0AyKNuKo629Ys9Zjc8uAbQuRNCkppspAWfC6ny2XZd5qeJahNHK79dXfS23Jw2BzA4l4GUxymfMQlro7bv+9DgthqURuVCvE/QqxuZsXThl+ZwsjXGZ16C3rLNANjSrSGyhKMZ3HDMhMzkU8fhiuCtK3B9s4zUxmopGnvrxg/XfnSLnlDqxXIudu+OzB9MShX5OPQjoRtQjknABYERlAJUfjrawxVq0iOynnSptZO9Mz/1IbzUyDZIcQEiEowXfCtlLTNtWa7kgHl0vfkV3K2gsbyLCySql1Yj/f/zgmbkCxw3qIeZs2kPy3rIgrmePXIpz8nEr18wv2biTWvn/P8xNqzOJnACA0l1Pc8vZfLFhyDnoLub8XawYkuKPn3UCFiLRC0hXLa0usOFhy6vm2+0HboUGkXNfVjOibq/f0d2W/a+fvGo/qxddp76Ebm6qQctzc/PwtqcmqzHFOwu1pFb7WK5/S0l3MO6/RFOp96rzfslxpzrgQJBIiryJRdSf6/7lSij9A0bGRi20xumSnGUKqt7tvTGCBG8KDj4TrtbdvKouFZWRWQtobMXoHSrg4+FEvq1OZkbcYnVnjwNWfU7tB0kcOLjAGAsI/fsWqIPahin5qVv00/jeLq4JQQjUQ0dRmzFzwyt4T8l0+mM7bodtjPZ3yhmUcUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?suf0yUwN+d9fjgPrh9k+ph13SD/KISbuF2kaFlQK90CfRwj4A0qPlSgb24qT?=
 =?us-ascii?Q?t5Mqy31R9Y6uMb5z7t4MVhw0uao6oV2dGWHK13zJbV87J+NpMST+9Ka4FvNs?=
 =?us-ascii?Q?n0NoSughw6t/Xjfr4M97KAjnfRYiVZjqf9gC3TjkGB68yhFqqlvA8Mw3zMZg?=
 =?us-ascii?Q?9d1ZuXccPsbL/Ok9Yv3w+XXdfadkJifBV9s0Rly9LxzAdjHfK8F8+PgqQSb1?=
 =?us-ascii?Q?aZaK4XpUQXnrXWXr81MXpk/6XVhexE67CsRuk2ovCtfDFDcUrr4WlrnS19aE?=
 =?us-ascii?Q?EtzbHJged60i9Jj1Q2KzZyMA95HunclLghBxX4Pc6RA5EZm/rYQUP9uoGTwG?=
 =?us-ascii?Q?z9Ppnb4cpLHfpnEhwV6lURe2dP2iAZC0N+w75jtwo4rdMJiST6IguYUJk/3P?=
 =?us-ascii?Q?u8LfB1GVwn5KIHfaqoSHwzsvkjbietzqAFYST/IyrjeLdNvIBtlT0Mz2uAT1?=
 =?us-ascii?Q?siBCa3yLThKkuFQmhephkWIc0k060UlND3ebwbsJHV4Fk1SavDRmMmsT/Fad?=
 =?us-ascii?Q?ZIHzn59VXHyfI3Y1IvmjhRAFo3+ayKhPImzFvTtFdrDXED8RLMoIIJrHXEo4?=
 =?us-ascii?Q?rrrn4hn98JaAw3Pp9rye2xCeft5Nhf1mWkNDv/FwctbpInV0YsDN9mwC8Kbu?=
 =?us-ascii?Q?CRPtIyWE9ML5vLgj7Z72vJWj+zXN+V/9rvcnlAGtdEIqM1PEbcbheOU3sYrx?=
 =?us-ascii?Q?eSrLpCegsn8RVGt1+SIjWRqkf3Rer3/pzJLGVMiGDjmmQZXNRfKACM0juWpE?=
 =?us-ascii?Q?3fTtpz7+6vNmSV6L07byyt7ACpQoQ4og7Mmx7V7TE5bisfVNj8wMSRrMs0ve?=
 =?us-ascii?Q?Aj8+dKDRVsTM71PIU5vxtcCt2KjDiNR4bLMxJnrCKK1piM6eFOD+C+pwHKUK?=
 =?us-ascii?Q?RyMiVq/Otk00flN5fCv4eZmLl1qtxitWNrXrN4wKb62abLITtNdBg8P158Co?=
 =?us-ascii?Q?HZ8kkh25SR9vnHcJZBhEefi0897GOYi6KAi/Iz+Fd3qHyW7uI/Yv8Na+85V8?=
 =?us-ascii?Q?3Di9fTJkjW+ZdKbB1FS0LOM9zQey1tGOV6xk8KCrCR0vy9H8I7w8yNCd8En7?=
 =?us-ascii?Q?mZccbZXui45Xzt5792/ttS7uwsaBPKTlXfRfbJ2fq8XpHCF0Z5gPlqWT6ulC?=
 =?us-ascii?Q?HCn+21n3tY6BZ6rUFZpxxgv3v4gnn6gLj2ap9UQcXsPpv4HKsHzpXyZVNF5o?=
 =?us-ascii?Q?u4ggz4ZFr9owbxAy1emNjm1jcBudZ0LhRj1N1qcyAKzkGNq7fM8msNlhEbbT?=
 =?us-ascii?Q?mGVTlgVuUzZBEA4wZXVMNhhP/xaNT0F+pQB+84wL3tQ4cFVovdigjpT62QAI?=
 =?us-ascii?Q?T/yaysq2qL+BQ3xNpAgJ9Py4i04wzMmBgC1is1C/rGCwt2D+YbxQAm6ZC5qH?=
 =?us-ascii?Q?o5ymHhC6aINKf9I6dKXYqmX5MwjTP68gsK+Hnvo/Wx6eMocNQ9AIwr0O0cxm?=
 =?us-ascii?Q?1wrcsdqEq59bAGHs3YlYvauhfEXGcPcyDSQBlzcSf7j5MKsbmFLSsUhInG+X?=
 =?us-ascii?Q?Pklsc/2+tZC9l2F6HNACJHSqJe5NWeH55wkQGHoSB9zavDi2eKyyJLt9Fva/?=
 =?us-ascii?Q?hSOXVpM7yOh3bRuq1C+tPhE/QZnIlbkLKhJTVpaQ?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13389da-5585-4ea7-2445-08dac8024fdb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:28.3941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XF7n+MH2AFwhyzYQ6jhPZcJs4C43Dqp7OyAFG5VcL3yZiYYTt32ooAEf4Tebd9MM9wDRpogx6cgUnLU5cVZy9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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

