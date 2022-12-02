Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E70363FEE9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiLBDdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiLBDcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:32:47 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021020.outbound.protection.outlook.com [40.93.199.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C77DA22E;
        Thu,  1 Dec 2022 19:32:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHPPiR9yhrlvuG2SemGfchRIGdSeP4xATNyO5k4byPtXGOEd3/yYWDUh031sRn0mpFWoWSyEsNj+4AbTw2F9VebIUe15GKt9nUpXYhQ4WhSV4OJL32Oy4Q12FcJNnysycOxq1quZGbT8n/Wv0DTVPcoIaABp4chI6+zZaREp8mqZ18VGS2KThCIQKeimQ7Ba+SxBU+fPC87SDraRaE3xT6kHQ8Qb6Fxg0HzdA5Q0Ffo3jDo6WARFnQOOd7G2qn5puom/4suQ/q/FFQTXUbfDB8W6nVunTrW9U7v2xJl3IdkJG1NXID8naMwXxDUVvKFZ1hzF4cBX1afmPIzUdKCo3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MmvKlC2N8d9H1KlID4hNY8Dgzjf+zin3uI5uHOTsQU=;
 b=kH0khYMziJzOxnFS5067QsBOM5fDUdm6R+EnG/C8X0wiI/kjbEq5cz8kVGr+5ionFLESXf6ic1OgNVIgLh85WvH4gpk4iXeYZClypHTBKBmKMrk1sRKV2/hdjdirDzaGepjayHcFQa2bHnqnBXJuBYF0tIoQjfcS/38nZPSLwSNAQLcJuihCpC9PVFgf0zrRycenHcVo+y0ElYe8pvbNyKoS1MElamteomwRlvWlRfrvDWOETnjZWTwcb6kXGc1yJpjYXL25WD/68VSHkmauUvF5x1XPA9oQgdzRxBzoVzYEzNY1WdtvXTkF1mPjhZMZXRRxSS7zss7tdCgK96BPUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MmvKlC2N8d9H1KlID4hNY8Dgzjf+zin3uI5uHOTsQU=;
 b=WE8+khlUWXZ+dD8jLnROP4xuOBFvEmb4B+dJUyIZf2KY0G0NKvF6inOTvXfZkuBIAZmcsAxEDv1lmXFVcuVRZodjAA9SVTFldwmHZ+E8tFlSP/YMPLs2cWs8Jzsyy0qt9xym81i/AgA7DEnXXjfw8ZfySF8ViP8m7YtLTKq9Lqo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:11 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:11 +0000
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
Subject: [Patch v4 04/13] x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
Date:   Thu,  1 Dec 2022 19:30:22 -0800
Message-Id: <1669951831-4180-5-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3fba225d-e669-4df1-ba9e-08dad415cc47
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7Ciea5H4LCbtcpCC61yl7MzY/fg+EUB74pXSyIbrABRofgOa2/MUMRA/SDPqNzJDq6hneE78hQnVKDs2tTk5HLoc3jLur/rv9/uQdv0sog+CHFu9Oq4Thp383oNo4ycXuGC394/87LS02a9h/1JPUTMHGcs6I0XCHiL7e0Ou0y0HgcB2Dv/KTdpf+yRO7HAuUM5amtN/WuLZ46BuOL1PtLc74RPLanY0f8IVdRV3YC3AhNcMcntjQdm1YnyAdEvHOwYI3huVlou07JdFIDWuhTy2+Hv0We/cQ2Eyf4LGTWyDB8MXgViqMyfBOJe6vADE8Yaphl3G+1NAAImpew26y9AsuK4GRGuXkTJbUvUFUPdyKIWuDCnQ8dZSG6IGjzYL/bqeE6YEIrcmN0T3dEkMU5NuD9HE/aq9LS9CL3Y4xQsYefRP0XYGJhI65Pu1KNLmN5libUhOn9AEnDntMr+8CFNVcZxVK7NOqD5EwFDXLbLYOWCRGKzDP+5y/UCYBmtaVAzX4G8bIRz3a+ekifIQp6LxTkLMt9qfhhjLZUctGNx1ER3HizDTwaGSJDbbiVQ7O6LMXJD3Uc1Ja/Z/wOerZDXveSBVsJs1H1G8IHMKZ71xcq9EFBi3e2RS/p8FZkwlcztT1Q7uYkD7JoYkfhBUJ3nF2f6elGl5u8BY53WWtg0nGlyiKPVLB/7CLKoBPZXAYHrkuzuSZl4Fp3maELldVAWx9BXzQirQ5EBNnIweipLYY/zukv7RCXk5kW+P/tq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pAorPs2drsSUgfXNCQHEjXrKgvYn8dlKqzxJxiyVYo+u60UGGGs339KWd/b0?=
 =?us-ascii?Q?IKe6BVEdh5aWhNdemaV+bwyV+ry4sJuSOj9FzItAObdOXjKGjvMtIbfh0j+M?=
 =?us-ascii?Q?L+NByXnFG2ZWtYvgi7ugcPC6x4Nb0afDwxhwbnEr2AhhncK6r/9Bn3S64sV3?=
 =?us-ascii?Q?jmG7FoFnh7pI3Exds2l0LqkdSh2MB0cZNz+8x5Yyek6BLrKICY0DlsHzpzeZ?=
 =?us-ascii?Q?9za/Skd7E4M/MwMfy6HoCkbKMQULW+lJ8oX2YGopnKIDrN+D/wi5zwKgMjPx?=
 =?us-ascii?Q?ZWXpWZBmdzIqxh3c0+f8e+TV/DUuV274zORDR5fF+Pw14rA8t7NlIlbobEIS?=
 =?us-ascii?Q?ME9ptdb99qFl/UYkHM8lvZV7fxYQAA//zDzHgVrRPHRURfeAxAmLqj2AyJWT?=
 =?us-ascii?Q?xG5pqUHBQsMWs2K7We53ywPholxQDkryA/mhTPvHuKUZFdve1y1foOiBb/xE?=
 =?us-ascii?Q?hZyRRZBfeh86hJd3ybkJnSSW18Qg91jonGGt5F33Vf3E+rIhsgiUWfvDbjAV?=
 =?us-ascii?Q?Ai6w0l6v/mM1BPUaqpByg4w1eg300LzC4zf7jOnJCUUuz7uca5/sg0FSYrsI?=
 =?us-ascii?Q?JH3m7AS/zTMW71oZn4kh0m1reaBxKB/B3+oT9AbVQA4vJpcapVbxemwvaibc?=
 =?us-ascii?Q?WFpQkWDcbezR0rTANm1X2rEAHdE4BsQcB2C3ebVTqM1BANED8HcHz7gATf00?=
 =?us-ascii?Q?nRm3Wh8FKwbnZ8KrizPIPHgi2biCgHB1EsnxRtq+tERVezJP2ia7ufnk7ZDN?=
 =?us-ascii?Q?OXJO0+uWbUhgZLYJyPUbH/iGpGrkSnRRxA2evAUNw8e4MZAvaIgTbqpNDgT5?=
 =?us-ascii?Q?B3acm8IlPswg/uvP+W87gIwgIGp6bAGoDkT7PdlcaeAw9r9Ww9CfBagrMRJq?=
 =?us-ascii?Q?LgWk+INzS6xzSJ1v3nayaqjtSjzYJWtz0lzr1mhdLE9Z9+nmW2elgsCeBZQa?=
 =?us-ascii?Q?HYrD36kHca216L9ZtWwOk2EHXSujFW5SsOp8s9GpXsRAEnbWCHbsDdjMgvWW?=
 =?us-ascii?Q?HLx+aY7v1CuKLr1Ncmy6JHUq7ZlX96/05kLkyZtUJgYCrYjBbkTMdLSolayh?=
 =?us-ascii?Q?kllUQkQRBwcDZ/sFaWk1FCzSYLv+Z+0VaPFpvQJd9fOpnLV3QfWpl7JEN68P?=
 =?us-ascii?Q?eOdaL37ck4Wwmj5DSTwTakeKgX3nUbD1ojGRzejrdb9J8qZ7N1qlR3iXfSgJ?=
 =?us-ascii?Q?Ioj/vZi1tMd9Nbn67mewWWGMO+IusgkTt3qFREN/MhD0kaYQunvnIMzrDmiS?=
 =?us-ascii?Q?5p3UB6Koe6SihtAdrn9ic7rMqe1jmRlyrmaogvFkT9DSdr7fWw2WJbGGmUq2?=
 =?us-ascii?Q?dRrxiOo+/oZpNmUq3Q9Hbzuk0m2UuRFm15RUD/afqwsCAEUy9fyUZvsOyXCj?=
 =?us-ascii?Q?lXLXy/hKVQX1ZYZ/nDRs0gzk5AAFHmF286lEmgsnh0SBVyN4Uty2qH3pqSYo?=
 =?us-ascii?Q?qOyvA0IgWrvNAD9yTY5MyCjoczovSJz1eO09XljVTJNMFNl8UVB4/5CbNuLN?=
 =?us-ascii?Q?GEKHOBaWp6ipgM4E29Dg1/KBAAc4XXYYA3AJ6UOAbGQ8ooOpkbL/oDA8ln1m?=
 =?us-ascii?Q?zsIIlw9d1pJ46FmoLuIimyyQgO8jsYAc1xhdT571uip2jDOXGn8LS8oQlkRs?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fba225d-e669-4df1-ba9e-08dad415cc47
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:11.5500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPjsSO7WfKi091HVyH1+4c88yUJmywQ+R45n53SbDsdxTp6ZnhLpFDvgOoIQVnVOEi2vzJg/IJt3lUxRRbgexg==
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

Current code in sme_postprocess_startup() decrypts the bss_decrypted
section when sme_me_mask is non-zero.  But code in
mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based
on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
conditions are not equivalent as sme_me_mask is always zero when
using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
to re-encrypt memory that was never decrypted.

Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
guests using vTOM don't need the bss_decrypted section to be
decrypted, so skipping the decryption/re-encryption doesn't cause
a problem.

Fixes: e9d1d2bb75b2 ("treewide: Replace the use of mem_encrypt_active() with cc_platform_has()")
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

