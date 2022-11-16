Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF7662C7EE
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiKPSnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbiKPSmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:42:50 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A5461B89;
        Wed, 16 Nov 2022 10:42:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OW2NXnReaPtASGxM0HEYucKddOoZZ2m7pbFRakDkpgDpfJEMefrcPC9xRsZ7uYgNfSeyvgG2d6Y/b8PJoSzvf1OX8I5Yj4Pc7MBDvc/vSbMD/G43Oez8FIJga4G+xCnhkehUc0tGgYP9mzAFmT7xf79oWtDIOb33T5H4mROzy4BJ3ftf2qIfGgFuDBuOWr4PImwUG3Ajpu5CuCwQfS5L8XA3QSRIPxjB07OMMHihBhpx5ddUJURfmf25IOz9gQyRn9ptAMOuELmTrhNXq2KQrFvt5nhw8ruP/Gj9HyBRllJAgzMCsLff+XzA2zBcy3e/UzbtUF17CU6vni5u7vterw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+eO9zbEWa8pN7ZegOF0MHZo7JisuGqbugG0NAnzUu4=;
 b=KTjDYhw05IQCl6l/3EhDMz2/W6nBOIcZHNk8yhs9CKERVUoRuh/UaOUXhMWdwuA37u1HcoSykpZMC7Mvzl/PbK1e6SyU5Tfj9nVIEDibmPy1RG/kKXSIBjKMeTn1fm64pqVwgm0C+8POq5OX0Svp8iRGx08OmnP871JGneRNJnWWxya/7Lx2nGaWQehCWSVMKqvlSSWFjBkn9Ul7SGjYXb1hjFRy2lysMqnXvTzZxtESZCmlBgBE4XCgrYDqqDnc3E3mLWSEvsKdVOORLjLc98n0iVZJXkhBSl+QYTvr3CIbhLE36P87XkZKttoNpYVPFRDfvmgZqlqTeAG1hxnsMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+eO9zbEWa8pN7ZegOF0MHZo7JisuGqbugG0NAnzUu4=;
 b=NKZGxiEBQqUm7i+6xwrYZCj+o4WgoNJ4wQuHDoJnaehFhjLbSodRW/upac8IVgkgCaJznSvu6JMeoyp433IEJFFkjUq8fZafEZCbkGvIki+AW2sQNpKWlyEguaYSau01m6+lKtemE3T7MPuErf7DblUzgx+YDYDAWM52De0aw9E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:32 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:32 +0000
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
Subject: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
Date:   Wed, 16 Nov 2022 10:41:28 -0800
Message-Id: <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 57a8e9ba-f984-4329-3e68-08dac8025291
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RU2ToKQWW7Bp59x2qq+bWZOknrDDaJgZpuANGvG81bM/zegXdsIEA4Nh9FCDfQEeGTWol55BfiRVgHLByMGiAf6f73RHVntDMGKdF9a9B1U4l+gDQOuagpyDPd8czweltTPN5w7Tv015c7itBvyw47z6aZwdCazi6qRLmRhurdX82ioVI6qyDtWVdg3TnwN4ulBSpbPFprNJbipZheKwgWnwGnzfh+dT+kVJ8tmbFeyDO2Hf85Zh4EiBHxMtBSpoduuZ33CO1UbMFUJ2EOe5S7J3R6SZZVjPYZHAl31OHBSU8pK7tTpbGAP7a9w1ZUCsQ+gKgyd+U64PJI4bYjQC+93R+l/biLqpl2u0Fsi9WxeffwlLPXP+6gJfuGtSB9QyNSXhO08+Zte77r2/5+Gtjd8qAu6NFV0VDMIIGcfSa1oaX1JtMHcZZafKnaq8L0TGRSFq8wiQ3lUML5x/ha+RcIXsUiQaU2iBnqCyqy0cpNf1IaVyEFs93rEKwP39TFacmm5IbxQj7QkQTq6IQ5uniwuBvxLtsIJdBRmGsqekv0actreXfQDt2R7HcMExKY3GsVxBjiB+/ujvpjGvmWkbFnzslp8nPtvYiKkP6B5N6iZ0N/3NbcvppVcuoFD/S3GRo0c55TJBQSlVBbX06ECswhjZruIiqG1Nx52a1k+H/yiY2SBgpCbVI3WlqdJ3lpbPUyD1X8N3ksHX9wmhc5cXZVIV93xklqCFtdF7fz8FKi9HPaficCNqPWw2w9LKGgj5VD2wpN0R1Vj4Rz+5DG9C4VXGEJcQ8P6BNltc7p7/+P+vQtfoGpvy8KHqXCCPiENNKxbt+fiCRU+AFA3D6a4sgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ABIIoF96kXQwloAfoVVOps0wQ4BpkUKlW47+AOUqfikQdeWNuRS3SGvZfEdX?=
 =?us-ascii?Q?Tjbp82UBXtuXrQQwYU5VyS+C6sN4w4vwWLeYpkEUJ3xaW8TJxP3azjB+CCLS?=
 =?us-ascii?Q?wWheUocSQC618ixMmiiIktKk2wzZrdqw2e02ShXfpKCs3SZknHBhD2/SBSoL?=
 =?us-ascii?Q?h0odHPRW7wvHOtN5L0Rkdd5Mlm0RugvcYDoDgKSwA13/yo2vHyf3JjlrtetY?=
 =?us-ascii?Q?DvLdAidko+a4BDcVC6ksVp+FmbiFaOfPDCJQMdvRDfCLLd3WAa5fPe+UOYRc?=
 =?us-ascii?Q?JMSaNhUHCR35E7sq2F+PE1TCznHvAX0PbOdoVVz43g4qwM8fZ+q15SNFR9DC?=
 =?us-ascii?Q?c9hb5xXZKKCqjCLlf69JftSpBtYBvUuy3Zs3ccVIL2ANrrrROhOuldtXbGF6?=
 =?us-ascii?Q?YQkWmNMVy5WXb5hH50Dya+RHVW1N9hmLxfQn6V5DOl+2/u9LLx0sWhhEpmPm?=
 =?us-ascii?Q?E6YCfuaVrwop+y/7VcU4DIngMIoP7l9yapMSAwP+PdWiDGO8synJJ3g6DfJj?=
 =?us-ascii?Q?UFKL6EQ5fovTboPrXiE6DZdLxzlB9+iyCQa76jzyyFM9KCn6iHArj/9OCT7a?=
 =?us-ascii?Q?FRQvjgW17vyZBV8+KVqTOVLN2QV9mPzlR6p+8XVRskDewoxPYghhU6ALieqE?=
 =?us-ascii?Q?hsOBM5/oEX8L0gsr0S/RfdijstNL5d63kXagwpvk3x8ZgAaU+J+4QLH+8d9L?=
 =?us-ascii?Q?hd9SYgfqtzXubocvdJVB3C1eC3+MpncVgb7UUOj2f+9/B+jXjIvaJXBzu0nc?=
 =?us-ascii?Q?cmTR9JfftDcBVjCJAMA2+RKyr9WwpKc/FtqLveAk6IWMVkC/1YLZkLo3icK9?=
 =?us-ascii?Q?5c8l0aYsg2HRY0BQfjbzQrIL/XBfVnvVG04kG7jGJSsZaXmIPLXQKFIdqSsL?=
 =?us-ascii?Q?hRiJGawvEUaCcCSiEtcNypRUv8BywWdaHltOksZE4MOkFeZQzOS6HBrZJn/A?=
 =?us-ascii?Q?SldhAbaeLxXS2pxTDaZ67gwFBp+WJnl69Uad36vK4iOcPFAkm0GUDdelty1Y?=
 =?us-ascii?Q?Q/YwxXKHY5+HcqaYCFsSYv7g7FHbqyNS1s+Vd4E/2kUP+1l43PoxjfX6lLIk?=
 =?us-ascii?Q?GX9wyTtCxcUlxy/z1o6p/1cIyIadbIgP8Bc4asU8Ppwph8xvJSqKfkHPUGRO?=
 =?us-ascii?Q?TXHWg4RsLg/RpCX4Hv4BmbuKHIYw6hsfV0z1ndXjZCD0Zg3wFjJLnp+gWzC0?=
 =?us-ascii?Q?XPageFMmiR4oCVZLjgPxVPF1iqbWX66mguBCk2kj57hRXAeu9ZI7ovxA52u/?=
 =?us-ascii?Q?jCphzuodVx/f/KnnnN3mFXOUqFHFFtKgt9G+9Bp0R37s9MO3b85HT5EONdVp?=
 =?us-ascii?Q?mW2Wqw+AcKgeO41r1XbxXWW/yP/bTPxAQUrtpKX+ybKGGu/5MnDgRoSyCd/l?=
 =?us-ascii?Q?HyAXX+MIo+0Szljd1ED9hIsmTX+zSaMDwDk1CGABXq0jlmeTVS1HPVqlMhcS?=
 =?us-ascii?Q?1Yzm6J8zRXXMxim/zLIwYjpbVnYVCjKvux0zTbWKOV242bvEncptgnVeFNsQ?=
 =?us-ascii?Q?xXCJL3RSqVyQoL/3UkoiLa4hOOGZwGR+RtBZe8CP4y/87i4xRr+zcSy+s7Xf?=
 =?us-ascii?Q?Mh6bsqVp4PsmKdDZxEAyGIakPOOfQh3Y3IFH6JC4?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a8e9ba-f984-4329-3e68-08dac8025291
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:32.8961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkAfaQFTmKXtBqNZ/KJARBebdcNeUWNHIpbfcKHyBpduKFNwLtXaoF5sVWdwWoKT2AUoVJ7e+zNaMrILvzXBSg==
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

Current code in sme_postprocess_startup() decrypts the bss_decrypted
section when sme_me_mask is non-zero.  But code in
mem_encrypt_free_decrytped_mem() re-encrypts the unused portion based
on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
conditions are not equivalent as sme_me_mask is always zero when
using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
to re-encrypt memory that was never decrypted.

Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
guests using vTOM don't need the bss_decrypted section to be
decrypted, so skipping the decryption/re-encryption doesn't cause
a problem.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 9c4d8db..5a51343 100644
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
+	if (sme_get_me_mask()) {
 		r = set_memory_encrypted(vaddr, npages);
 		if (r) {
 			pr_warn("failed to free unused decrypted pages\n");
-- 
1.8.3.1

