Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105566C94AD
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjCZNxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjCZNxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:53:15 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021021.outbound.protection.outlook.com [52.101.62.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CDE7A89;
        Sun, 26 Mar 2023 06:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFkMcEEfN6Eaew1sSrLK1ORQeOP4NkftsFmbxf4LkofkuZQOeaS+9wiFPvrkFpZZfQVfSmuw/8k1hGf/OFokJ9pH3EcPNCieEt5jZ0jiqdgNqGvg04HqHMnVgwQeBwQvB1fweYD7YZDczVQ1HRfHUOb/SDQQSyTgk3wC8SCUZ2dzDWT9W966x/cGmT+wJx9+aGx81bZQrO0wjsBvUaAfbYpqnJfIrBr7oZOquRJuGCgWqNVw9+IyF0fULHbJs4KKBEvZcDbU5mGW0D+0bxyDW0sIg8YUIGWpazxgTyS9erFb4VGhsfV3Yf5lqa0psPTnYYQti7378aXjsA2bNUvL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbHFPFmTeMZYHHAR+6LzRBCkRR+Lt6NfcAGOTQF+av8=;
 b=FNO1fcBPVe2OxWbm9XXU9EJ/ca3k6eZJLneyDLYJ7TuneJFc83GJmTAffhLjta8YeBlBcgwqZOvu3n0VFtZ07BfD/xmevaHzrd6hcgShFVbWiqaVC09+d9bEcQZdN85O5OU19RrPiQOcJHl2Ql7/QDyiVFZLbO3VhS7pGhtud7r3AcIakyWQAuYCemwmoHCb2OpujcpaEZu59TtVoD3kX3TIeGj0lj4werWk5XJQ0YQ4CMTQUgN111Yac0ItaX6qnYD78ModEiBSO5xgcz1Cni/ZnSL7/41feSq3Ir99nco9HLrMehxB+aNjpz90dwgiVZhJypp9kbA+hCMLKlUUVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbHFPFmTeMZYHHAR+6LzRBCkRR+Lt6NfcAGOTQF+av8=;
 b=AVX3jDlStLE9e3KvVi77HwgAJln49xPn5vi/oD6K04i7ELbw19l35sBsE0zPbc4x7VS3E2SPesl4U8OgNXhPqnOZSKr9nizlkZoswQCGkhbL0V80zCLCIp0wh+sCmsWVqFMYIPBPF+ONiSsrFPKOvlq5ZXV8xYDQHjNtJdeSNsQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by PH7PR21MB3044.namprd21.prod.outlook.com (2603:10b6:510:1e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16; Sun, 26 Mar
 2023 13:53:11 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:11 +0000
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
Subject: [PATCH v7 02/12] x86/hyperv: Reorder code to facilitate future work
Date:   Sun, 26 Mar 2023 06:51:57 -0700
Message-Id: <1679838727-87310-3-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
References: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:303:8d::23) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|PH7PR21MB3044:EE_
X-MS-Office365-Filtering-Correlation-Id: 13065b9f-497c-44b8-dc8f-08db2e01701f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZntesHanzRvcU9VMRAOeAR2ha6yE+L31xCMmWQM+LDWhF1gns+RqYw9Nn3D1RE+xp4wYWFZtfMFt8uB0J+WIl14FtD2qOt5y3SoBt4IUbrhT6p7pYLzMwmZGimLkArcNidMLcWMXAA/tyj5TQbX2I5fS6cusVoFbaGJW97UVEuw1UUMxcbIIpZjwP3sMd0FQcrK/n3xdjT/NddvOyg1CuVeLAKnWwTzUZQycBaPlrRGQqm1mCuzYbAHpN9xQF2riEZ7UCKL+BX2DFsOQxl7LeTIfFq7+KiOy4x5Tr9kEnmZxzKtARcCwdDB5BInkn6EdAEG1egY1Dyu1jxyD7RyDC+BctIztnLs7XgNHNvFa+k3URwmKMQJ3CUvitq8YcTYx0eV/UGBrMLiO+7sVqJL82SHpt8TVib6DuqpMTNaELcqS8J6P8e5TxKMqpAngSINpsXKPG5djfIihzkbGJq6U21Ko9nW2KUDnhyY2lWNB47yYT7G9uxE1m+lhyy2sK80ccnxsmROJ9881VLbCuVxUpY/fD+uuI4yq4Q4YPG26GGDKmUzZenf9iiWycCMr/RUAbJ4987xkuznff/L7nv/7nOhUbk5XZkA923wuuVA4xUwp19kA3zg4RDILt3OAU/vQpyLfpsZfVoi4lQJ8mj5UIxfProc0zIgMF4zkCLwtX90sY7jo+BMxzypA8zjxamsp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VNgrl0FZZLqk71xZ/0I0xlP523LFKQOCp2Y7ZgxxyDqglDlQKPbMgPa7SV0J?=
 =?us-ascii?Q?BuIuOOW7t0re+gl8n7s2ABQqwaxs3gJ9ZZJDQahalyuD+RimyuSa40RKkbfH?=
 =?us-ascii?Q?4+h5OxAiBZ2ot5GKqPosz+JZRXkjmTYt/w8goC6Ocec9yhuWwMHobqeSlj/d?=
 =?us-ascii?Q?p0x3iUaErw+1spTN0nbRAigRHPt2d/S37ZPt2wZ2piTY7kJnV4YFFzrKPkQV?=
 =?us-ascii?Q?fP3Mf94Y9Zd3i9esCbuQupvhE8+L0GibB/mb3PDPvEDpfc+Hnb8Cqp2lIJSj?=
 =?us-ascii?Q?dWo8giJPswX7D0ubPbqOZnwMbGAom70AXNZHyve97YIRNG2VZcuzUmWcNU9a?=
 =?us-ascii?Q?3jO8rhqp2Gt5KHGca6HS0epjfUH117yNXFQlBurKdp0xxA1nAqHRa1mmEdny?=
 =?us-ascii?Q?einPOqLEsWvTjEcJhQOKdnD3JmQRDypgLSxrFHr6j0FOoBMLLXikKbiD/wfh?=
 =?us-ascii?Q?EJaiD9yMnDWkRTGW/1+50/p1EUCPuuC0OSrgR7hC25tRq8TuiqAO2eDmrG2H?=
 =?us-ascii?Q?0AzkyndTOLSBis7L2KYg3K4tdlyEOlDDxlTdin+stTamMKF8HMNk3RugFcWw?=
 =?us-ascii?Q?3DWXSfvnXvuWVxpC95R6jx7eXyYfk7TDqSRi7N1U3FiSgjbZRKwEIKf3mT1E?=
 =?us-ascii?Q?2O+6Cq36yMz7CRiea1AAUUc7sJGC31PfirVDfeDBVCBDy3Lc5lTsDQMjlywN?=
 =?us-ascii?Q?Bn12vmRN/1wCqFdNM2L3hnHw7jrhl9gGmv75aVDI6ijUe6RmqaTFGQos+qWg?=
 =?us-ascii?Q?xFf1E+38lNIxdEDYQ45znhh3+o+xIvgEj+sCv0eBY2am1zM3S/ORUSUQAWw3?=
 =?us-ascii?Q?MntvUFoiTOQ7ElZf3rAFVAUKm/Zjr0HXwg8l3jwoSdX9MJ45XNmbz0oR7V0w?=
 =?us-ascii?Q?OXOwgXHKR0/qUz/04hF55lbTnRlNy6uxm16boZmu2vl/xyjXIKMzVEZbZ5Rn?=
 =?us-ascii?Q?pgDV2rja/pinO5Bm1FUOuSrpkkYTsF/GbNyNdDCuymUzB+dI/AK/TrIbZ2t+?=
 =?us-ascii?Q?kuUVp5vSj/xDHb25gumZ+T97Mze8lBjiiT8MPO9sVO8G1H8DLzQzN+UylKBT?=
 =?us-ascii?Q?7U1JzdX8MA6lQ0qId6npUfCTq0D1+fcl0Q1v8O/XKPGl9HAm3gS6E7OHEQGE?=
 =?us-ascii?Q?RQzKLyd401EIg3jh8Sc6VeG0V0eAIrUpko1N4HKWUc47nx1KqYrJI6mYmHOK?=
 =?us-ascii?Q?HwumzwsbpUNTLtBPz2j7CelPhqF91J2WHIIZlQYl0N2mGco0tLtQCXxwUEo2?=
 =?us-ascii?Q?BR5eLvZdoFBkqtgmfe99eKr34Lz797asr9Zxx/YH6szPywkgn+6oX0rs9AIL?=
 =?us-ascii?Q?fgqT/9CqoydjRhd2ss2TEtNyuKxC0sDrWrVGVqFf9izt2WDxtEIkfEgtwGb3?=
 =?us-ascii?Q?UB8VFQHmcL2Z5nZRhnHYc5h3zeBt0wolTEvkhGvI/Kh28WzoVXfFrYIfQ6f3?=
 =?us-ascii?Q?B6Dux9cbIOFfSgKp+SR9Vih10ttZN4nG2+kz66dL3EFIEzN6jbmb67jGYYaf?=
 =?us-ascii?Q?2e+YPrO3BNO/ZeL0dy41YC+2X7vPJFzX6CWzh1yenNZbLdKzd7QaTIvqbEGi?=
 =?us-ascii?Q?7XOkfUHoBgUeK0uKsoN/cKi8UxE/n4y9rpckGkAvceOx6MFY9Nvn5IkKiu+Y?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13065b9f-497c-44b8-dc8f-08db2e01701f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:11.5617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7nO6aSWZ/yklBxjaikoTL3ylm3C1mSx9h5TNdos8OH9epmy6xqi//pGNbnqoGiBOpLyPckI8gw9Z0QUYsGXcQ==
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

