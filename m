Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C126B1955
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCIClp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjCICll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:41:41 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021017.outbound.protection.outlook.com [52.101.57.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAEE67731;
        Wed,  8 Mar 2023 18:41:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf9HYmQIAyeY3OoV/a7KKq0wZKp/Ld3oGLbTiF5aTGcT6+utxRiyFKJrfrjrg0ntQZyLaA1/PBevZic3B7RuWU1D9DoZ5moqheKUvm9Ra/LYg+sg5WY9hgZ6a7Ibu3EHutTVFD3ygNH8xSn9mi5Ki16VlbCh6vjVVxVFP6ZwayjlES5QdcZakxclDnuxOAvvwk20dzDL+ubZRLBQKJg/1w1HJ8vAY4OrgBuelTkrDgD9fqydUrllCfRSBepeMKBgCRb5HG9qZsniiS0vAUmAydtB2VU5J/0n8c3PW709GBtr+QKeK80dSqpkhud+xRhing8Bz+VVKuvIv3IdA0ARiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbHFPFmTeMZYHHAR+6LzRBCkRR+Lt6NfcAGOTQF+av8=;
 b=FAORj/CKq6fSzplsV4Me39SkADngK9aYlJXiQEBB6Q3pMhlzT70aQ+lLNUZypDPv9Sqqxb9PhBZyckayQlhi5sbgyAuWDJCz3vVpUtl7zlYsATWokq6AJEd6wwLUs+jOMakP8LAF+RJNvU/7BefB+1rU8wj6Xp4elpobkf9mtGyjwY0rdqQLUqS8T0MgsMTG6vcDPcO6mXYIkF9SYIBhCzkbqzpIzRYCT1//OyOmMPYC0B16PUo0hsfjNyUiwNw7N+uJHuwaKgQVH191UXhQSIx+WbcENdHFvDmaTDu7kGBiAqu7LYev8sJGQR+pNaW11SLJICr0U6fDtHvcfShPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbHFPFmTeMZYHHAR+6LzRBCkRR+Lt6NfcAGOTQF+av8=;
 b=iORG/Sv83Yt04F6grUfMhOgNekx2TH2SwSlPJ3ehSbo3eujQotiphDqKl0K1+NJTWv0+A11nMThX417klzY/0YLvvAVjoita0gsO2iKALhidHEPuppYfrlW7iLaRq3z0C4LDmSuzw88oDEK5JVZ/L5K9CwYUbWrrI40V6BT6e+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:38 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:38 +0000
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
Subject: [PATCH v6 02/13] x86/hyperv: Reorder code to facilitate future work
Date:   Wed,  8 Mar 2023 18:40:03 -0800
Message-Id: <1678329614-3482-3-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 86e0b62c-f4f3-47fa-00fb-08db2047ce68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJBLSZ5YlPQbYGB/IEFsSR2qoK6tjuJv24RGWfjPYnnBhq4pHMT7Oj9B9uGGqjzvLTNaSRUr1Vgpe8RKFWNxJVfVQcuX0IG2h4z5nGYhAXxndRqBiVMkPpns95vK7Y/J6W0jz0qx88QrEU2zozyG37QPdUCLL2WRKl3NCRb1RybtSGFcjk1Ht4skq/eamkBo1aiSkjst3G4yRJjANi1X4vlSVFfSgWYeN4CSqM5Z1jR6JtWh59S3xTU6Gp1erIBYFNZYmVdO+pfiIhmwtTfb+6/fB5h2poBwrDOW6KiLB6gfgYB7X1MQ4buHdZ528FiUjGfAisFpIqzqXg3dNB2/0fNd1WAinvGNaqpUnNEG6r4ux4nAwW6Hk/Jqo6+p31tig5Rx6+3WZXYfB0J2mBsNlJyfmF5akoq2Dhz/7qDV21UNOm7omVslBwUFopWWtaEK8GbX9npqxK95upj50WaBl3vsM+2/uaEWr4bXZNzT13Pt7G8vWVaYjkyhjR/OtusQishmrLCsyxhUtp8hD5byRqwV1TCIeP1zp20IKczXaIcb2IGuK+CvLEMLp2F0gvzJxsL/UdyltClutNmx81wsSv7WzXATJ1GTHZTEdvKTFyaFM9R1+1B+LutxSi5Kvvm4CFTDsjaBIixb1K+tn6LEhQ3x2aovSlGUSQf9R0lWS1pZGAWL/G0cB2uFvAHbp/IfkxWqpi7q7+6uvY6qRUSMtv00O76ZjNy3mSud0vm3aQH5EmPXoS2RHf413VIrxdbRILulWU/AP2C+gmb9tjXayg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0H3u+svFKZ1kWGX82WIdLmpXyy3cpSi5TvnT+/R63fn7i8zdL3XxHdII3XQL?=
 =?us-ascii?Q?WQ8WwJV9qf+M+rQVDQfAsxY3GDP9FtPB4x4Vyj21a9CnBuQA4fSdrRrFgqa0?=
 =?us-ascii?Q?r1hygPwesViMLq80L3jMkh5EP5DU7jc5knm9q784Az68LV2E5LTahIGmQbRr?=
 =?us-ascii?Q?JwsfkidAIyIymdnXGYcBh/dINP2ufancu2w0ZVNepT4pbyDUZX/4Ga7Ghoun?=
 =?us-ascii?Q?gDzPBU3g0qPRreWL1aqFjuWK6W0DTBR5OqtMwcUR2e+sO1XkQF1hh5v8/wux?=
 =?us-ascii?Q?rWzapjTsR6TZbngWbiGQVNQ957zzS/sTlyLKbekFc+5DtQ28iio3KZY4xq6s?=
 =?us-ascii?Q?6JEUwdCGP0XJ2cDBMbNkzqMjSFbRn2Qe3YLQoF7EsDZ1yyP/WqMFMeJxFD/n?=
 =?us-ascii?Q?w7xOQxhJw0rLh5ss3ZJXQ+9kCACIizhMcVterPON8XMt1oPIlk6mkd2y911O?=
 =?us-ascii?Q?8hHzx4nLPcu/Brl+EK6MFRN9kr7G39WhVTSHRrjJkZstOUAA5L32p+VD5scO?=
 =?us-ascii?Q?3v5nvFBh/cwW20EsAvjEjiZG3o/6JXKg2TwzB3O6g/1I++s3yak6vwZcykKU?=
 =?us-ascii?Q?dDGt1WriK4rBPQ/OqbwU5u+O5VtTVtw2iUkRRYG9irQ81T4eq64nu5uqCWb6?=
 =?us-ascii?Q?lz/gA67DsTqMCpuo0rvLtZL931pmdZ20xdqzddH1spsJiNoFexFlGlA0jhv0?=
 =?us-ascii?Q?RYQZPQMTxFei4FosIbpBdVVeZDXKEBxbGNVuqR3xq22lXCpqfzIxSKrcMGKE?=
 =?us-ascii?Q?2W9rasv8Zms5/QuFimI9VPLOPc86KQlbxOODc0pm05bNadw97yu3CLufGjBO?=
 =?us-ascii?Q?73w3FW2ns1H6pRlAd3IJEY6qkSYSRQMnADIeHFmzcc64GgHaGBRByYhi98ys?=
 =?us-ascii?Q?0Wzz5V+St4NW9pEkTCwZQ9JTvE4YinEs7C0gqgs4H7AU2LZ2HD6231d8OUc5?=
 =?us-ascii?Q?9p3UyockBwvzCoKbwrlilep8e4UpoI5gpn6z2U/mbMjLYJsowRIL0xDeMpBh?=
 =?us-ascii?Q?hG7UVfXv7kJMkhWCbAWNGR9SMeffLJ9GydLkD96EdZSyWu6su26g7B2nbZad?=
 =?us-ascii?Q?tjusWPYai8Ef7uYfq3axrqMcB1h7gk+HbHCRE7EHZHI6bTyd+bZSCTTkGMVi?=
 =?us-ascii?Q?1oxNRyLp/8Ivrn80ruyLKkEp8Lcaac8M7g0Ld38plq6JAgWjLa9iXLLCkSns?=
 =?us-ascii?Q?jo4NRVmlOEDAp27zRC30SJ9fl1ajAokV0vs753JtPcEbujABFE3WPmMK55Wv?=
 =?us-ascii?Q?mj8PRUOsueYLGnrLBDUfTWFtpOTQpHEp/ufXzJA+sRGxIxWSohAVmudL2DTh?=
 =?us-ascii?Q?wFq85R8LYFgDxV+Nyx//uxo6FIZhuEnvTTJnFP7KLJJWSuooEJByc5n+JjuI?=
 =?us-ascii?Q?64mpvw5wrxbsRj5rASZUcXxGn9zwLSVDFb90XNZn8WVIr0PhCHu9G6Ki57Bc?=
 =?us-ascii?Q?58uk78jbDWOlVzksPJzplACCAtUXEUQmfGpRHIkmVnlSBUo6ekyZtWN8jYty?=
 =?us-ascii?Q?FtNMOfmns2GHwphLhhcgdzAiz8IUUC1XX2W/F0PwKXEk1S47Fir8iM7Epz7o?=
 =?us-ascii?Q?qSDtefBzB0O/lJVOw22Rvm1Zgqk//1+Zy0nskejTiSrTD0mnBZNTK6hMKnUf?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e0b62c-f4f3-47fa-00fb-08db2047ce68
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:38.3090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ni/wo6H/GTBmecSTW8/rFR5IfFg4aHeSFyjOb2qfgZNP7UDTcITSTUfDSbHXcnloId6NuYBCcvee5rjfBTADwg==
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

