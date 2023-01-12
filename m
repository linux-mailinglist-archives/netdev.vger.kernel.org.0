Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56BB668610
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbjALVuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240935AbjALVsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:39 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DF03B8;
        Thu, 12 Jan 2023 13:43:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3JwCE3WcOZ1f44ApQ4bzKj57LQsjmb0c5XgMHHV2esJv0cysDu3GQOMM7QhFkttyqCIjVmHhM0wDTFIuOjntVLTnr9aDF1Uvq3jJaR9DfP38NAX+ZdAYM0hf3OXSr7uIBqqmDyo8m1BhzuVv097hLokTcZYp80nodTdaGuSXgdQQK7PEbvOXZMtWsTPlox01DnUMaI7jKa8HpMgI38BZZhP0+yZnrIAcwxIxfrHfWBoNsjhu682LMZPEUY+u1jSXXC6CLgH5YaoggJn6ijT+AjyIO7OhHrbnq3S0opZyLm7+A3Xk7Av2AicAC+L/6MEoSET8nfi/SVlS55SDbOWCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vVCdaTFGXtkZXyLDOxaOfi/6PmqIHiJZMVI3+wmvEE=;
 b=A+pIfPzg6njRdKxlowCab/DbNopCpmJ/9r9VKCL+eAPFThzGKtfn1vt7b2s7kdlf88CQu8CtSwcfRy1kmhaAVwnrovd4xn7M2odnIbYLA36uJrZi6p+A6wiCcF09rt0DzLZQSv6LQg6pqobsh57YcxutspIisKK24iDvaGGowVjjmEKtN3c0TW3y/tg9zKqQ253jRRzxcteylJ+VVhzJb1fd3PFKrAsA9OzjbERBSPMKKmxz5xSWleaQ9ZJDrt3jyrcQwfih9c56Ycxd4DkmuCmtX+JgChNA+vsAJ3PmO8r+4OHGP1leGRj2fuoDlguPkp1Wwv6MjLvwvlctgd/ibQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vVCdaTFGXtkZXyLDOxaOfi/6PmqIHiJZMVI3+wmvEE=;
 b=GoreCbU4U3CdMCwrE7HsEwb2CfBqdVl48aK4fBzKep4MWmX2YULlWVSsxvOlbiPLRacgEBlh9fexmGx2L3Zs4yZaDNatp87gQicTqPPEwpSkeOwGLuipfcHrhkOCCAZe5fsTvoFQQrVutMRI1kS5BYkaQdjGI20Y4FS1YKT6wKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:05 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:04 +0000
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
Subject: [PATCH v5 04/14] x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
Date:   Thu, 12 Jan 2023 13:42:23 -0800
Message-Id: <1673559753-94403-5-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1a2c6a06-8d28-4389-73b1-08daf4e5fc64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcQqKzaPAjrREbEFAciWqlAwr8kiWOnJSZhbIC99d33UHB1bZQZU0hZXSV/f3xoFwgBgo8iK8EMgGssGZ+NspEklfuENc0/JPqxOdTimk5Z2JfpWNv3nsvwFWmFIuanrgXpi43KDwplEXItwDa6mAInVFML6/3eSp2Bcbc3zHldw7cSkKXvD54Vm76kFDNGvJFyP9RAZNE8M3rYRA3csXvBe3uvss6YeRSvPqj5sC8hxMLBOgXSieBk4iJVh2n7kDCHFQTvDVvmHp3Ns3WjCWKJsGca4pgFKNZ6jLD4HQJa4BBo6qdRLYXQ5sbDyil8JY0QHQXbeT2P2nRKxI3CznpqLXDGZNVtqjeSBOisCVV+uZC2U9chQzfHnddoyqA60/6vcsRwMNjNJCXFm6t9Svc4YgyMCaM50HdNkrarSXXpHR7sIiin5qdAdhdiWNW97vZZlUniicgUN9OZk/EkxT9nP+OXGDxBi8nHtPCHgbNhX0HuhwmhulUa83Da4fQyQSRGssfM6Nf+6pJz2PiugZUTOi/Bt659V1k9f4GZg+SOLju/KkGYLV7KOxagaiJ2Kl+IA5JdzBrfGE1/Mho9mKuYyuj184acDu5LaxVAKRS0fBsd95nUm7GVHz90teOKiuzaYCZxLIGWtcUWgEjEqodMhm+Ataos9JWrAE2GWTQeU9YnzvgIAiQc6AP3eoJGkrqmCAK0rxnKXg2zfSuBBu/CuoECqd3BAU/iUADHY6BQCMlSod7G8ySz8Jkd8qJfA0ho/yQWHXXwyKiaz/Ju/KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?afJ0XMNEb2wVPQOoJPZK3jRuv8XPQXtmvv8yJE86/FpKPJ09ntEM9o8YGrrZ?=
 =?us-ascii?Q?97/m4aHGiuADtkvHXxjD6JZeHfZM5WGJu1+n5VkL78PZUrKHcaExvCZ0/xYm?=
 =?us-ascii?Q?zQD/dBoFNdqrDPr4g3076+zAm+UhEJeq8yyQVai4g08JIONl2QU/nSLYTt4a?=
 =?us-ascii?Q?pkEOUjDFckmYxT3z1MiMNawgYtONPjHywMQFpk2H89ysshcbviXSei8wg/Bu?=
 =?us-ascii?Q?WdffmIMCdaVMwtPq086ND/hDgH4HHH6yD1lTZMhRDq4uD/jtCnOSNxUckm2S?=
 =?us-ascii?Q?0n541kaFDsAi6vG2hVLHXeVRe9cgkKpgXfDLuSSmua1GJnxaKm8ryqyldb0v?=
 =?us-ascii?Q?cQa8zbfMpl3QLdAliztoj+OPHy89X70ng5PMAqPItTwzjdniy5nux85wYPWS?=
 =?us-ascii?Q?I6bHysKqNJpVWdjdekYpuvb4SAymjCmTKo0q1YBFZ1ejSTF6eRFhOapYL9JF?=
 =?us-ascii?Q?z/dlAc3DQOFoI49/EjnWxarBvVqM3m8Gp0V0Gzxk7iZj34a/dHDwurSyxHQH?=
 =?us-ascii?Q?iA7+OdEH3xD8C2eODtkbe5VeEHV3T9co4dChoP56+1z5JzHwr9VmBVMwbWKc?=
 =?us-ascii?Q?cU2kAVrLyzYK811T4EIyiI+9gNlkKpsc2162OPXG/2P7qoxKlJLK66435YAf?=
 =?us-ascii?Q?bRuncYyu6Tku1dZzUKPGs9n7bmdXJ7B6ornTsKtRgZFPdktXIg1GNE2pl8Y6?=
 =?us-ascii?Q?g0GzTbUL/UP4zQCgVkVawzmtIFIHABYrIdUgSFX+pWqia+g/obxXMu+3dFGD?=
 =?us-ascii?Q?NK8Lk847YhiYZABcFqc6+vZ3EaffaWVcr4R+rBfePAiEP/4fq4NvRn+amOfV?=
 =?us-ascii?Q?nbw90wovO5YEdXASx1r+Vob0SCq5kcQQe8EE3TQFomFwTaxohAno3BWVyF68?=
 =?us-ascii?Q?yNmbXsRArmjZTFsJuoYZVjF8Leil5QIakO0Bi9vewzbAGgn/g/47Rqu8WSj8?=
 =?us-ascii?Q?8AdKpJprt4i83V/ZK7hD+CDWTeQQWLyvCyNLnAiPeyv14kabxXJnnp7cflbZ?=
 =?us-ascii?Q?u2+SHJYGCXR5Fg2hZxrMERZVGqflR1Q7Grjul/gc7cYjD5r+0fa3B9i1mfsy?=
 =?us-ascii?Q?jZ1nZsc493DWMJX2EXtkCH2Nqto8ge3N9KYaqUvBY7+zOaSMgZ831483N2Mp?=
 =?us-ascii?Q?Dfprrlj0HxpvRljGzybb6FR3lyzIBhynQur/Obf0rJldU7qGH4b4rgJMsPCz?=
 =?us-ascii?Q?IwRSDMFTkeezF2jXTOmGJb6AE72/PMCuTZyvy+AdKzDlytJHCggD44Yp9sj2?=
 =?us-ascii?Q?LDxJuIDWpAT68FUTok4wCt/iLv9rW+S8xWuHdIzFEPwQgFGsD00VZ0Rx3WDf?=
 =?us-ascii?Q?zyYoU+08zQXdjccCqs9EYmyNht6cesxPzjT7yAdWCC9zRT6jh5VokqudZXXt?=
 =?us-ascii?Q?bj4hgNv/NNaAmq9ZRvcoIdIYD+V+D8mQTE5YXamTAmgI7DPsSyOrYaW45snv?=
 =?us-ascii?Q?JVMDr7rHZpW0av7YNu8OColpqRk9YsOYlxVokvjYI8QhJWXOBTwnTHd6VYcR?=
 =?us-ascii?Q?WE/pEs/NmQPT40/Xot0C/5kcCTi1OHIaDWK599Ad9wwCLPKi4PJ81CdJlWVk?=
 =?us-ascii?Q?r+8YgxYq98aFoXToGBezJECH2GY5XGB189sRYhrm?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2c6a06-8d28-4389-73b1-08daf4e5fc64
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:04.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5T5mwDMl/XmQVUdR6mBBsBSKMs/kF7CkKhSPmOuuwnRQrnC5lGqXGgvxjCnQLv2c3KJ87wYE6rJ8FRoDHC3QIQ==
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

sme_postprocess_startup() decrypts the bss_decrypted section when
sme_me_mask is non-zero.

mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based
on CC_ATTR_MEM_ENCRYPT.

In a Hyper-V guest VM using vTOM, these conditions are not equivalent
as sme_me_mask is always zero when using vTOM. Consequently,
mem_encrypt_free_decrypted_mem() attempts to re-encrypt memory that was
never decrypted.

So check sme_me_mask in mem_encrypt_free_decrypted_mem() too.

Hyper-V guests using vTOM don't need the bss_decrypted section to be
decrypted, so skipping the decryption/re-encryption doesn't cause a
problem.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 9c4d8db..e0b51c0 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -513,10 +513,14 @@ void __init mem_encrypt_free_decrypted_mem(void)
 	npages = (vaddr_end - vaddr) >> PAGE_SHIFT;
 
 	/*
-	 * The unused memory range was mapped decrypted, change the encryption
-	 * attribute from decrypted to encrypted before freeing it.
+	 * If the unused memory range was mapped decrypted, change the encryption
+	 * attribute from decrypted to encrypted before freeing it. Base the
+	 * re-encryption on the same condition used for the decryption in
+	 * sme_postprocess_startup(). Higher level abstractions, such as
+	 * CC_ATTR_MEM_ENCRYPT, aren't necessarily equivalent in a Hyper-V VM
+	 * using vTOM, where sme_me_mask is always zero.
 	 */
-	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
+	if (sme_me_mask) {
 		r = set_memory_encrypted(vaddr, npages);
 		if (r) {
 			pr_warn("failed to free unused decrypted pages\n");
-- 
1.8.3.1

