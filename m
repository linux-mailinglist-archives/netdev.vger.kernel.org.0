Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30AB625390
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKKGWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiKKGW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:28 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022026.outbound.protection.outlook.com [52.101.53.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5A565E56;
        Thu, 10 Nov 2022 22:22:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXMXHN8pcs730U166+emPYKoaS9NOnvOxYMX6EmwTBoN3ksTgRq2nJCNZTM6dITp9rtSAbIOETj2rRBrfuNJ8omUPxWWiTZ0LYAYFkYwS9jCMBSs/YCqVNYmLmBnGRgQcx2u6JpQ357xNaeFfsjbPeJL9jGJSITLnxvC2oYDdaZjKqyeNq5aaq/j4vubi3HUzZbiN2bacKtf9eL5UwfpbwIirEc+kMqij1ZtBtDmuR6NYI75kKcCJcVc+BAPzFZ59bsT8cGj+Sc3DM9dkryHe0cMsaL6cPiP3QBpfoC9XXHBxq1QFXdugWu89b1PSsti1PKoSnsrafhNqz62Fa1tmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=My+3F4xeoCZ4C3uLqj81e5Dg1XL4CiWYfO/yE8xDujE=;
 b=fqQUiQMsOvLPWh8q4yN2s9lsiWnQcTVQxUHYobAy2wWqKli8wKhpDmgxu24ZCqZU+NyjCNj4p1GEAaNCuxzptgp3VW7kuADZ/Wl8FzbAsSFiacJlpF2mkAVa13R49vnzAhA3ve/t6NtEtCOupCzjkj92M98m20QsAssUw1jjmUC8bSBPFDsQWBWrrfjxJPOpZTyg/cDOl7WL5XX32Vod8hqHdl1muNsm6vO9CaT/JtN5NcKxw+XYQTR6zizBdau/4RF4CCs+fAcGkUWF3N8dyvlds20cBxtUvJopIPW4/qoKFM/4QAhT+WXv2BmQTayJoddcCtGda9z5mTPYMURW3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My+3F4xeoCZ4C3uLqj81e5Dg1XL4CiWYfO/yE8xDujE=;
 b=XRhaIDFimPBI1yWp/4pfDVDXc/wSzQZX2g7QpMrnu3dX+Te4Qc8NDUroCy2fUgBA5sqSvnx5+aoYdD2Tz0l5DhRQs/XABBflQ1IThl0NLygw8dXOlftpqFxhtqjuYIUjFe87kOJ7hPc7SWe+i/kseBPn2OgGmUdJgtCmvsS7+uY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:16 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:16 +0000
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
Subject: [PATCH v2 03/12] x86/hyperv: Reorder code in prep for subsequent patch
Date:   Thu, 10 Nov 2022 22:21:32 -0800
Message-Id: <1668147701-4583-4-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: e26b72df-ecc6-48e9-8ee8-08dac3ad142f
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kjb9tGC1C3wU40pP8KOe8p1wJnlsJNnKGCmgfDvvWguVTqlxkSAZ2LF/B78VYBLuibXfnN6AwckynYWXKhbxbZuZ1futgn0/SaelO6a+ByiCuB6n04Xm7ZU7OFgsQWoLA0499ZsKXtCL3rbCVDxuhNm0AVmFgEL5I+LdoANfzBVYHdbQbN8T1uRA6BGOQ6bGPiUzH8GSZa9u5PA0OeeSjTzRZJSezeAejxu2iPpbxWGFpXH46fcw+Z//WQb2YGWeNejN89I7Fe9jJXry3ub2modwIZ9RR2RfTS56XxGTSOJtv1DpQzur7/aXbvyXJhPk78J2yfcmpxhtheHTp6/2rvMLXEXuRxf9GZ5RSO5IO4vWpwOXWhcSawRM7pV9VTv0RgKpv+He1TvpUR27O6pWJxLtyoUvLFUO5QNtnQVdAXcAEdkDazPoKGQ9PpY2OKjAYaZmN+7Kq87k5auocQuN8ZDblC7aOERYl8mRq8QRiVjyVTO5PVcX54f0Ss++ntKh6z80l0W57u/xbNCTA622/OoSRzV+2NVhu6Rxa3+uq97IUQotEIzO2d6TDQL9OR0B1zgZsC6GlauNU4cWeUZHxA8BlO+4tUBmNHU3zrggPn8qe5LD5YiZbNnTXZQH5PmxFl9sH5Y+djUsfEVVXAa41TAKo+HVNy5ATWxOqDcehN9iehsoNYGcUQl2UXl8ZVC1FBuf5FUu68EZx1ZAxdiTsmdXNdol0Yc2pkeaJOO8rxRwC8/8oApw01FTL4IA5eLbyVRawnkCveCpBQH0Mf561UFw5upnsf3s9BDicAob9GN0/6wfgxVsHB1tzg3bGrM4dKHVKBUo109firlwv2ehgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HJtr3GSn9Gwv3XBW9/xl4DI4UlQXrdY0cl7xmDlS9G44f6zOvE534peyJW5L?=
 =?us-ascii?Q?nW5q41cliqtZHHMb8plOG49MC8+8PVCl1Wnsj89/ANDNJfi6cVXPw7NMW0GU?=
 =?us-ascii?Q?Ihn7DzgOJBEjkBkchEHNoXrOj+iN1WyWhLHKDLDM+69L0CrXG/e45Y2BvIiI?=
 =?us-ascii?Q?fVuVmAxnWNcEXY3iqRogLJziLQAC95sjqy+2x0+eKTrUhm7/K8J3EhW+AGpX?=
 =?us-ascii?Q?AncQ6McZjoht3EBE3gHWJ8MzmMay1bwqu/8U4I7pUnE6CkLkkkVgdCrPu59u?=
 =?us-ascii?Q?lNqRiS9ZucWFNU7cKew5GggkBkOfvw6TY3+BWiGTyz+CQcmlePFh1gVDVafb?=
 =?us-ascii?Q?2HchKzp0rK17PxOk5j2SBVKdwShWHll9XxWj/aQLn/tPlCKhaq4a75+RZvXX?=
 =?us-ascii?Q?LQ764o+NgOfddXExMSakgRwi1ZVuEleiGJFlGVJFcl9iQqozGIsLmAPcBHg2?=
 =?us-ascii?Q?gzfC3/Xt5ixndt51zMTNYtEbSwTk9HerBxUtiARSL8GRFeInqReAZl69HCdd?=
 =?us-ascii?Q?PlfSYMz97qQcpITQFRXqWHZS2tEXEBLYhpXR2S6Jub8X5FxDKL9RtbABC8vi?=
 =?us-ascii?Q?o3+T9o9B1FR/jIWXYD4Wdv7dd27lQUjx65GmrPkZRsImfp5v0XsQtHbuOQCm?=
 =?us-ascii?Q?huCFhy47v5RpEoHDpNvDMkyBLw4W8CL1Jl98M3NDC9Hg3KgHjm+6m6jSfeVy?=
 =?us-ascii?Q?UmRW2WdH0w+GRk/mkwHE7pIhtcD1ETPvItTzY2vO8vmrJ5lS+ZqgnrsWVUlW?=
 =?us-ascii?Q?Ar+tOZqafejHri35Hm5I1qNQ41A6qPcqluwwovZqw2U8XlqINHoSzdcpZVws?=
 =?us-ascii?Q?uuJnMVSHTleA3xjcKuACAQYhKeV4JuRlzfpiTd2xVMv2BkLnRPKZZpc8D317?=
 =?us-ascii?Q?RSKC+PG3UA/H+3LCxsnxJ/BWRz7/ZsTtZyGjDsJF6Fh1tHTScDeJWVKPD8Vf?=
 =?us-ascii?Q?U6qgnqtmdD740uJvC9jmTcHEStOe5961m+IzOmQxEI6wkqlMqQOVCeF+2Ej6?=
 =?us-ascii?Q?RytI3czkQDMqmjEtzUBVtA7ScM1l63IUZFUy+JhAu+BcEE6B4PA50OTWAU34?=
 =?us-ascii?Q?KPrfS7bjE7UPaZlsPubO+THVCEcpIEJjLsiQip7jYLzzMCHywpoy5ZyB4fQ9?=
 =?us-ascii?Q?MrWd+8GgP2Hx3e6ghF9KCa3KcIe1CUn9HodOwZzaAAjFyY5BlvsqrifsIeeH?=
 =?us-ascii?Q?wSwsHlsS7yEiRx7/yjHbJyx6aUsLkAg1D9WtfCqYADgZs+cE54OzlkeDi55i?=
 =?us-ascii?Q?D04hSoIWsEdZHHUc2hm2/fAus6OfaHfBeHf7/NRR2qOpOeH/CdvhE4DK1yWZ?=
 =?us-ascii?Q?2hHKWGtY6Vyh8VU/MBSFwHta6a8xLS8f7xXVMs/ErtZnnv4No5GCcDkdP8kQ?=
 =?us-ascii?Q?lmk+OZYbQvNnn7WgO22tlXppioGJHLax63wm7x0IO5k/Gh0di5YSZqQBKAwQ?=
 =?us-ascii?Q?2we37xDH3CF0OcxhSucqe67KdOH5MaAq2M6vrndLJdTeDl4m0ZwCGFAk4a3/?=
 =?us-ascii?Q?XqiizoFYq8aNYyxY9zCSOn/AhwFMiWLbN04Y/A/LyrixCrAx/oDztlQ6hBJp?=
 =?us-ascii?Q?Rm13fTErudMVCUjXVXZY5q7i379iTdA0Aqf97aEHVSvcCqJzohWVNTJ4p1g1?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26b72df-ecc6-48e9-8ee8-08dac3ad142f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:16.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y159C0QRE0uTL2z1KZubA2FqGg6gOBjQBNDazA7pR1D3+TnZw/+A0Lz8z4cTKe8ibLkMpJr20gPtdz5aDJsFRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
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

