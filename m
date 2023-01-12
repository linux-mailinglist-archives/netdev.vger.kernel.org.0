Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13EC668627
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbjALVu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241042AbjALVsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:46 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CCA389A;
        Thu, 12 Jan 2023 13:43:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8FiUSKzwF5exMoWdp8/O6UOv5PsQMXxGW2VpjasXIL7tqCx08Ivek+TwLa1I+d8Ck63w4RtA1R56rpFdemiJbkvX5H8RS0OYYuCxj2Wys+fNu30YHI5DjOLLrTUifh5y9lgxbMQrn9TypIRpgmzD8eqc8L9bhOXQWotadSzl30o6gjDVx2lSM00jEAUsC+T+ipB3B4YGc9l/CYsLsKN4LBNTCNQpwjthwq3H1/2CJVO6C71dvR44DvvDXX/XIIpCm6S54A2iAKGcJOmo2y8wZdtUWe8XmfJm+x8rDhpQXYiMMy8zdfz1Aj8bzK8xCIktgo6EG0Q9WmyeOKPYIkGdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhqYaUVvCGoXTFbigkpwdviSAiVGP+4IiVWor9azP/0=;
 b=RysvgL7IYJYZLPJoq4DOzZZ5KmSIf/JDAXoT1EsK47NzVJ/zJ8AO0ekQRkTDpvS08AE2plfCrhYcG+OlHiD6TQ7ye6sXzG9OTPzMKqWych67wKxLr6zqMjZ+vvqHoZiUthbNP7j5UAOkrFDLyriwBlj1kTlgy+ftP2uSTE9am3CeqckagyqKqi2UWV1OV3RyrJEYSP0gQCJGlM8GGqrC9dX5k79WK35CsKhiTU7qigtCuvyS/AsNCsBdR9/z75GW8bwQdykmRA2lznCDdr8fYwH40Us89/+JO0AbhhTJ4IMsibpUewNF68IjvZS6A+tQSWXC7eXrjIXbgkUO8i/jeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhqYaUVvCGoXTFbigkpwdviSAiVGP+4IiVWor9azP/0=;
 b=VWW+/D1vJIwpnAZje+FVO166nMH+1d0Iol3wXGWC33ZTALanuHDF0Bx5RbrOhm72icHa48kDGMzS/+06wDlUrJlMNuOBQbShFARdhhv0YZxexb46gJnTKbWBCquvBlDTGAY9jP3Da1s0fmfoDddTtTuXV5WoGGMHCzdmiemT4gk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:22 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:22 +0000
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
Subject: [PATCH v5 12/14] Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
Date:   Thu, 12 Jan 2023 13:42:31 -0800
Message-Id: <1673559753-94403-13-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0e65d253-3731-4b59-0372-08daf4e606ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZ6ZvO9PMGnEUIWlEsxYJ8g5W0U3yFWKuVifsPbRYX1uOpdnuPxKmi+0gSttTociH3TXyO+07YKchvbYs9LklwaHjdVsSYcfUPCaZIbual5rN6NFwZgatYekcRttjA6XLBIiJCiiCHKrb3ThK4c8+O5IYxRRst646LyG2yzfD4DJdm4awGAxzdgS+WL29f0bhSm482m5kdLyXt2lSq62gqqq3szqJRiqs9PFNRMolINj/QpNMb/5rfrIcvM6BvmCjhrxq82ik4loPLfjJenOW/oomlSPgbAyLZXczoj9Yhne0oQXtIbdw1fcEWK7CF0qQbRLjmjlFpliFtz8pr38yK8hG0/dLvlbKlycai955D8Hc+sGYWfTqT7LCNXFSJfXpewTGcQREI4hukeU9Acqe+RB17F0rBCwBikZYD524physiPMbAYJkZGK6pyUq7s17tn6yYHoEs59CroKzKuc3aO7zOvZEcMzoOT8ww/huRVt94myJff7CM3OPuusNLsNAq834WCbjr9XVeIkON6HAJwOWPr6qj9W7sTGjPXY7w9J+SbS9ufZhmK1OIKSNxqNh81qgyQ5FhcSTPmkb8eB9q7f1JXkjZtZIr/fL3QCnUkxqKMw4d+2bPR0vOZ4L/OLlcjoiyt/bJ8DRS4hXbV7/BK2eKKD6szre17yVXM3vx9vxTEkv9qelS/N30KmVDE43RiaPmSuRBPVlSxxh0I/m6rnWuBIj1YEvz8Autt/Ok71TvXHdJTM5+rLGgZhZBUHwOn9EwnWnxAoKbHX7at9Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4S9xlEUN20fs4A+FklWjD/1bQdQaXDss8nT0WeUgCKMl/Z0dU1Wk3Kr/jjOG?=
 =?us-ascii?Q?3knbLmFspj5bQ+e+/sYpc7x2UOCjYqMyQCg3Q5h6QazKZ9wfmhSj2zgGXoxF?=
 =?us-ascii?Q?ZuwKJtsKEAbPNgQM/3fp9fU8hjNa+iM9dqfkhkyDFWiSXPuRwbBSHUarPnlR?=
 =?us-ascii?Q?hlEhpBf/fFguambRFi8WiSh26JqtkQAcQ2Rku+QveOuhS8er0C5+PtGOnDXD?=
 =?us-ascii?Q?obZVu/oBNaThi/qaqXk7kEmx4mq/RELckyxJna85Ihk0agY6d/GT2xR3RFVt?=
 =?us-ascii?Q?wCyX+w2TA1RH8jC8b9QU1otU4lBUM1hHJK9g3tAR/saVbI2V0nMiuO6wvHA/?=
 =?us-ascii?Q?yFJzbDFB7ViC/5O6OU0YaJ2gHNlOBhdLqymLQR9yWIFMKyrLr6ypycYtDDXO?=
 =?us-ascii?Q?8o6I9Kfd4DYyvQ+5urFFv7Ch/x98H4fU9rFcj4a6eMquWNRTDn95NcByQXIm?=
 =?us-ascii?Q?z/z1asFslWtoUY021T7PbHvtr4DfMZNPLT+dFoo/aGROkDuR6TAu7i4SFhk1?=
 =?us-ascii?Q?WM0lM0X/XGe0L6xEG2q6JdIptwIQp5GcFyk9pDgFO2Krqmz3n95yxW03ES2O?=
 =?us-ascii?Q?AVx1dD5ERl8lXANc2dbzdP/KJo/rIiuaoWy5phsUlDSUrAH9wk1ujZOqkzFt?=
 =?us-ascii?Q?XhOuWThddFLHfBTWfnk0syzDhmN1SS6ae0S318Fui6nVUBUD6kJthbKAMoK1?=
 =?us-ascii?Q?MplidyGJrKp8nW/CkJY6wSHagNq0Lk+funxPp6rX+0LeQzuaprj5jbR2Odrq?=
 =?us-ascii?Q?L7DtIBOWvI+2RzAeA5pRm9HkgFF1PCy0SB9yOlFEaFEjg4LKtudS05c8ck3n?=
 =?us-ascii?Q?YPRK0dJ9L7XR2C6zCd4YrIntIL3xgu1HXQlt1KkluAFWVQhC84rhwmp8RWUW?=
 =?us-ascii?Q?BTKTRynwAFDHFmcPNwYADbvFnJEfoXXx02gWOlgfsZn2MAcnULPstmgzA8Bf?=
 =?us-ascii?Q?yAtS5GYv2lE/1EaXg13C9pRczQsu3tbS28/YueRSbrRsqvjD+HNK1uhRLydk?=
 =?us-ascii?Q?VPYM+gp8RpqUVU/NhIH+fxt96fGUq6jK9hAy8gscfmQ2GnHkia8mUEt0aSCb?=
 =?us-ascii?Q?MX+c9QiSeZcvXJa8SWhG6B/dCpM+HJ9hLCnnGx94U32KgXBjosZLTxxm77Yj?=
 =?us-ascii?Q?yK3dqjGrKg2F06ABzpnO6aMTIKJzVn3BeIWl1ZoZ9uSmfK9tlQNMIN6pyqUQ?=
 =?us-ascii?Q?En6TElkNVCBCagaARjXgIf7BsThtf0Y07WxQwa10105gkAZJs6FWzv8E6fSO?=
 =?us-ascii?Q?9YMV5wlKlzL0QMfTON9RNnh6xddpmP54Ab4JoqStZjTDkpFyhKIQGyenQJAg?=
 =?us-ascii?Q?RP1gx7dCxHYjLGtVtohXg3e5r8RpDDM3bS24/Z1Mr6JqEVOrpg5lwcfvPTEZ?=
 =?us-ascii?Q?wG+0F4SHVydlkemO3cMRmCCZzydW56JYAnn8xq7/ASU+2hVnqThu44YvecvI?=
 =?us-ascii?Q?BL9UbrJ+ca33g1gqHs9Da8XXkukHztuqgzqZ5b6+b46Pa1cA9eBNJ3P123bc?=
 =?us-ascii?Q?6ZDz+UI43ZWJvOE/y3kdtAeuwmGJ45lv4JOsQUekxct0plqmwdNe3zuSqS/3?=
 =?us-ascii?Q?IAHTS+M/B9So870aPOC0rVAAY3x9bmEsq+fjgwgn?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e65d253-3731-4b59-0372-08daf4e606ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:22.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8vrkjm65WbsZ7gnDQ5L8/pksjsN4jxo8GN2v7ZoejAcYOkAy8zcLYgIoABmCDqg9e4Py9+X2+dffnaRHpdGqA==
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
index edbc67e..a5f9474 100644
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
 
@@ -217,7 +220,7 @@ static int hv_cpu_die(unsigned int cpu)
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

