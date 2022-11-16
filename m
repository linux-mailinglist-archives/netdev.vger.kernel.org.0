Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3282362C804
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbiKPSpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239343AbiKPSo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:44:28 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB52654F9;
        Wed, 16 Nov 2022 10:43:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUx07j+Ieta5NM5z50yxG0+/HKjZczao3j2WtDhbb0LojOSogz4z1Eu/LD5E/0S26Nfnsm+xBpg0NascrDNgwxWgCL/xbzToLJzP9dB71c4+fJSedHpaGrPDXZxIKlRduJ7cdpNFal/8NBtk1EImuf3Pc042eFXdL2tVRq8CDFCczwcHSpwxbdkFfbBDKqaFC9ZEGP7ABoWuJ5nklepH1P8S9qzzoIdcXcAFFVgb5+bpG7YdaPdKSIong+nmp5piDvyVQMRDr4H46j5JM0vr24MmbSPpL9b25eOuihkm1f3daC54jlcMIr8hh13IUd4iWDWCr5Eiqs/3iTRAf51xSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAFlpt88t8Ntbfh5LtgzKHnItvReHr+mauMNQKBarg4=;
 b=nQV6xEoSeQtcKRB+vgIUUHKZdZA6FmF+AjuC0LIIQrQcHVFpY4NV2Z7+rzPWx9DSWSC0nkEs9VuPRDhxYVheq8hUT97oRF8BA4Z59AW1I68tzxV4QfkVMxAYBd5buMr/8Q99v5glm6ws07wuD9eY7tG4W6Ni4r9NWDQDrFQOxMudsHTdhhnmiw2HPLPT0fJwSGUA29MS71M3b3+dqbVyzEHeRBP+qasdNVCT2s17bTCdanIRnhljBT4hNJE944IHSEEZMHdkJx4eaAu7RJGyhH0RauxBJ/hAIpRE0L4HU1J0o/RG18QfWk/mZ7X9kXlL9BjZHIFxnLY9l3BHj04CZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAFlpt88t8Ntbfh5LtgzKHnItvReHr+mauMNQKBarg4=;
 b=Rrm2QLHmN5MnCz1PJC/4j/mGjXJ8ts5gamRba9gP6zBlWDjDSZq0yevtuOmi46pf6WoYGL0BqgpaG4Ose0LHtrc4a1+PlkBEt4l89jrzrk2M4cC7yaeeP9v4ixer2UZE9OJtW83e8Jr2aam6Aic3z4rMX7FEPME21SgbTL0PrbA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:49 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:49 +0000
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
Subject: [Patch v3 12/14] Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
Date:   Wed, 16 Nov 2022 10:41:35 -0800
Message-Id: <1668624097-14884-13-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1a89cabf-34c4-42a2-3a1c-08dac8025c21
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZATUwa7iviBPa3uDhcChSj3J5gSrUyGSStGLus8VUO+8I06io1Q3q/nGKHqkx+7PidRvZk+tc311jdiaxkOzyWWAtrMh1LVOS9sbdAAsKnVNE473qE1bQS0uVi1M8laAebP2RrCNksRZnTffULMa5iijuzooD681i7aK88eYmaKwaU3oKejwDsXMJ3363IzrlgCFYv/6GlPnjfhRwj4+OcR9RVyVX7wlN6R9L42yybHV2IfPzGVx5aiI+zY61Bmi0W8dTAOpoqli1+fGTtcillhgFTUg+53LSPfOAcbaylY+TgpEl2MEQQaRwoeVtgclk1rwrKUPhLSgXUsrxXMn7++rww0ZGUtmlPyDVtokHbxsdzNsrBfxtyodIUU7H/aoDGbLIY+DbSXK3DjDHOmCVgAz6wtMbqvP2yWqeC8qRbvqZ9pk3BjBEyBD+phrQb9EOI/7bVL4DVud0b7LEXgWDrnNRRPUEULVV5Oa23oEHXQizo1sTxmThefeR1H2gQuRc5gIEK1dgtiBrzCSdSFNzSvQKOx5vc1+Eaz9tPr2iEjQ+M4RIqxSofcA4Aqnye4s71d8UuHX7pBUefeVTrKl1fp6YA0BED6sAhy1uWg6TrqjzY18vvAEqyaAqrwePRlUOaq+OHgIWW3yhDPj6PMmrvp/qEpedq9REofeV6DNK7GDnmZQIDhbVCc0qgbIGqfmRp6gU2tgK2zHPN3EhSIGwzJGy43lsibYhjEZOdwB+Ny5VbiihDqTaQcwWSFLfzpbADxMTm7btDM1rWxAM30OaCeISJTENdQf2eyJYn35fifNaEhZLPGdnSrqo93581mASgDrMk0tPMYNsZJxGFUlsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CzesoaN1gj4s3PFVDXo8cncydupbmpKmLPSLcPy4z+J51j5iV6cw1oBNY28i?=
 =?us-ascii?Q?7yj1RytK1hdlQI1qNq860QV+KgtIao+RlmAwmAL7rEWUNXsgXW/x5VxUe1Ek?=
 =?us-ascii?Q?u2nK4HMIenxsFo4Zer2kQZvg4ctZd8OwP6UJRtmyzkBnIHEALBwHgPxOAdfU?=
 =?us-ascii?Q?lR3qfAcbAgiaoAEfv78WFAvN0Z1DNM81SasSudUW3F2TnPsKfKjazhVbFZ6c?=
 =?us-ascii?Q?j9s+2QVjPzMzz/5dfIOq4yEt4WiXyngEfAC0sejdkhItiRKFUnfipdtLqXJ9?=
 =?us-ascii?Q?niu4zaAhtLJ6OOhtQf9EeHEHlv7wRFq04jLXjQy9/pdnPNb6IORw5Wbz98fT?=
 =?us-ascii?Q?wvl9bubuGjiA+oGAmgM4Az7laxnH0wI1pNjEa+5bOuJBlzlCAg2xB43iv9om?=
 =?us-ascii?Q?mMYQtD7BgtpO0+fc3Rstlhcw3wcL63fpZW6dMFO17jwtJzv1GQxOgLST6nqP?=
 =?us-ascii?Q?qPtM1obJwrPdO2HfSWFPZx2AtZ1eQLlSJkPvDbsSWrICDAF3Rrn4h32eLs2n?=
 =?us-ascii?Q?xNCRijq06LCn5qd7K2CDMAH9BH8J03ogFC+y6N/vJS23i+UOZk4AbIoAt5u+?=
 =?us-ascii?Q?68fXOhu/rtCy2vjxsYpSe3EYOVTh9v+LSC1CsyuGQPPPm0cSWTIQYczA1+em?=
 =?us-ascii?Q?7g8sEMNq6Eo60bM0q8RncESrrL/EHS79suBH2vpnup+3Q5uepYWzon8VJSci?=
 =?us-ascii?Q?x21DbqNGa/yF9NVSj6okFCK+rssPJHL69JUwFHODIflN6axA8fiZ+ofnTiP0?=
 =?us-ascii?Q?wwT1IRPFLn7MUIIUhg2Hz3qEH5jMbC1SQe72K/m7QJb7EDZ6EMP5zagj/OQE?=
 =?us-ascii?Q?v2UI2r26WsSJ0S46cfLKnsPqh7Vs61swJtVxaMvF0qjlfpGy5FmGxesUcvRu?=
 =?us-ascii?Q?JdKZ4rFh91KBfxGywy9YrCv5xK4YIfZrY7OuAEPVa8OxXSWD0uh5lI5hYrfm?=
 =?us-ascii?Q?NiPg75+kiKXom3DjXbMsB0PCpPsv7QTrKeJIA3g4N5p9FOMfNYBuon6M20jc?=
 =?us-ascii?Q?MWYXrNpV+NYXJPqVg5WhOLJvHqJAygAZqksAZdE1JrwkRbnAyuttQYApN8QM?=
 =?us-ascii?Q?LyJ2+SxdoJ5mOTqOD01TcqoqNj5T1RfibOP71uyVlagNqM/FRg7PhsaRCinl?=
 =?us-ascii?Q?h8/SJ1v6E2K59a7Sf8IswAhjvEty5iux+4Lb8nOj4pWhEevSdvb7smqUZkGS?=
 =?us-ascii?Q?7CYpZOKyc8GFFBzdMGYbiBG7psDibIY3wKQxBCTTpw/xi4McY+Lnz2shEUeI?=
 =?us-ascii?Q?GzT9jh18qdnerfP3OouqVfqFBilkgNdOz9AgRLyiEFwVRdC9C74meuzK/dJ+?=
 =?us-ascii?Q?Mm3fOKhU0xup4C4dztw6MGCySojNxdiGrtZBiLJ/vrm7MN+2P06aUeuJUmSP?=
 =?us-ascii?Q?IRnwKkI8aERI0LjEmvHbbfXIX3+L06lFtA/icV+tDP7KyyhrTMp/msUa9X0K?=
 =?us-ascii?Q?saz+y9KaHX+VtXHQaZqRD56BHA9ziVSRInZWNf+PQAPADa9jKGP8wH/NxjbN?=
 =?us-ascii?Q?ofpBxCyAG7bOL9/noxRuOCGzX4/Eu3pEqUJD9U2ZYkfiaocV5IrKWlKqxN6j?=
 =?us-ascii?Q?hsg6mGDnuH/hn8HAXoUnNKF0lbF+oPvmhKdz0vHm?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a89cabf-34c4-42a2-3a1c-08dac8025c21
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:48.9861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPZyoKktdGZlN2jm4PhOfNa2pY4WrTfCzAcZeT6lLHiGITvpUJzCofBfaamlnCQiI/qvVQz3ljE8xCMJ71h7cA==
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

With the vTOM bit now treated as a protection flag and not part of
the physical address, avoid remapping physical addresses with vTOM set
since technically such addresses aren't valid.  Use ioremap_cache()
instead of memremap() to ensure that the mapping provides decrypted
access, which will correctly set the vTOM bit as a protection flag.

While this change is not required for correctness with the current
implementation of memremap(), for general code hygiene it's better to
not depend on the mapping functions doing something reasonable with
a physical address that is out-of-range.

While here, fix typos in two error messages.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/hv_init.c |  7 +++++--
 drivers/hv/hv.c           | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 89a97d7..1346627 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -63,7 +63,10 @@ static int hyperv_init_ghcb(void)
 	 * memory boundary and map it here.
 	 */
 	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
-	ghcb_va = memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+
+	/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+	ghcb_gpa &= ~ms_hyperv.shared_gpa_boundary;
+	ghcb_va = (void *)ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
 	if (!ghcb_va)
 		return -ENOMEM;
 
@@ -219,7 +222,7 @@ static int hv_cpu_die(unsigned int cpu)
 	if (hv_ghcb_pg) {
 		ghcb_va = (void **)this_cpu_ptr(hv_ghcb_pg);
 		if (*ghcb_va)
-			memunmap(*ghcb_va);
+			iounmap(*ghcb_va);
 		*ghcb_va = NULL;
 	}
 
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 4d6480d..410e6c4 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -217,11 +217,13 @@ void hv_synic_enable_regs(unsigned int cpu)
 	simp.simp_enabled = 1;
 
 	if (hv_isolation_type_snp()) {
+		/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+		u64 base = (simp.base_simp_gpa << HV_HYP_PAGE_SHIFT) &
+				~ms_hyperv.shared_gpa_boundary;
 		hv_cpu->synic_message_page
-			= memremap(simp.base_simp_gpa << HV_HYP_PAGE_SHIFT,
-				   HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+			= (void *)ioremap_cache(base, HV_HYP_PAGE_SIZE);
 		if (!hv_cpu->synic_message_page)
-			pr_err("Fail to map syinc message page.\n");
+			pr_err("Fail to map synic message page.\n");
 	} else {
 		simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
 			>> HV_HYP_PAGE_SHIFT;
@@ -234,12 +236,13 @@ void hv_synic_enable_regs(unsigned int cpu)
 	siefp.siefp_enabled = 1;
 
 	if (hv_isolation_type_snp()) {
-		hv_cpu->synic_event_page =
-			memremap(siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT,
-				 HV_HYP_PAGE_SIZE, MEMREMAP_WB);
-
+		/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+		u64 base = (siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT) &
+				~ms_hyperv.shared_gpa_boundary;
+		hv_cpu->synic_event_page
+			= (void *)ioremap_cache(base, HV_HYP_PAGE_SIZE);
 		if (!hv_cpu->synic_event_page)
-			pr_err("Fail to map syinc event page.\n");
+			pr_err("Fail to map synic event page.\n");
 	} else {
 		siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
 			>> HV_HYP_PAGE_SHIFT;
@@ -316,7 +319,7 @@ void hv_synic_disable_regs(unsigned int cpu)
 	 */
 	simp.simp_enabled = 0;
 	if (hv_isolation_type_snp())
-		memunmap(hv_cpu->synic_message_page);
+		iounmap(hv_cpu->synic_message_page);
 	else
 		simp.base_simp_gpa = 0;
 
@@ -326,7 +329,7 @@ void hv_synic_disable_regs(unsigned int cpu)
 	siefp.siefp_enabled = 0;
 
 	if (hv_isolation_type_snp())
-		memunmap(hv_cpu->synic_event_page);
+		iounmap(hv_cpu->synic_event_page);
 	else
 		siefp.base_siefp_gpa = 0;
 
-- 
1.8.3.1

