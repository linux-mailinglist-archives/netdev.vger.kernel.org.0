Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB606C94B8
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjCZNxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjCZNxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:53:20 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965ED7A93;
        Sun, 26 Mar 2023 06:53:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtG28dw5Eg9vw7JReRKjSNY8oHhY1H4dITSGMVwVFMPQMQGOHwDSBOxrsrGnOyNrvpA0JxLheEXnHHfODMagXPY5buJsSWfHNhJBN81kzmGUEqh76uigqHB+ztkAtutdWuuse4+yAKIbO39Nzt+ubDWyubn04Ya9V38lPVwieuL1Z8FCSTA6AhlS1MXvP/r9IRr9QO0NYlnmcz6YT0LzNrHIIt2oTYqrem7Py3rsF4JOW5tRi/ePVkp4Gn7VMU0jGR6IZJ615wH0SoDpHiZ/3a/e0zZktrDrQi7RFep1XwGfwATd/+7mUKkE5SQ2Hh/d79CazlHpCXePuMO2VD3+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI0Z5NqYyhBpz2WATYz1OMj1dRqVGimeG7liXqP/WG8=;
 b=LTwt0cqLy52JFpfBuIzUkI+GxVdJNfsplvHT4IopZ8JCu0E1eYQgGuX364pbLbMgecElDbLr6KoCdBywCiT5m7qg/wQhQmao3zmZLq2KsQEXnqYovcrEFxTRWSv5ItQvKctEp1aO+CDDTvKGe8DHay0mEKaC4SOAPkoObMXotIfWHDVfak7eGp+Rt0COKuAAEJxt6AKyWMeNqxLg4GVHDtMGlbvm52UhG4Kej/CcGfVZyO4/6wVBvv9SgqUGHI1OKxNOiPmXde4Ylrf17BmwVjBCCVDHGEvzOq5Ntc8xrsxty92JyfuNnXWCnXCMgrInCTR2VC5iYCfznPNuB5ydow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI0Z5NqYyhBpz2WATYz1OMj1dRqVGimeG7liXqP/WG8=;
 b=fPZLI+Qj6deMC2OGgQ+mU5PWnemtH87+VCkcVksVCoJExd7nG6845ZXKzjbyLQ6KV1OurA7f8p8S+wtHi3pJvcdjv5iNRCdGP77kESvz/nLuhQcblE8RbZ7TN2tlPeXFkRqVK1t4sBDdQNkowUGofuW+cPZEIYy2RcpoDP3x2ss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by PH7PR21MB3044.namprd21.prod.outlook.com (2603:10b6:510:1e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16; Sun, 26 Mar
 2023 13:53:17 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:17 +0000
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
Subject: [PATCH v7 05/12] init: Call mem_encrypt_init() after Hyper-V hypercall init is done
Date:   Sun, 26 Mar 2023 06:52:00 -0700
Message-Id: <1679838727-87310-6-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 81ba3182-375a-4446-26e5-08db2e0173d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6V6A+rQa4ZqdAHZzMP2wT8g76b55FLcujp9ZU32hg2Nx6ZFHm7aoWasNEZJQa0NRici5BpAunmCVDGilS7RPqfN43JmVCy1HH09Hdo+urlz+s1Tbhuc0vIqSBnofwqEBcxmq7NDsDkGe8XXb7hLyeLS1AdjgbCIl6J0QZIb0I7irzzJjvNjeizzSXySWp6gM98VdGDUcsnfcw4dLrTxZqtfN5b3FArZRkJBysQsd9YOceAwv+OW34X4wxP60OKT91gR+nPpSzAsCkRlUsYEdt4I1Q2J2KxE3kbfD1CfEBqNVPutWa/N/2pgwUaqZ+joHvT2d2r9Cg4LLBAYvNx/uZ7FSqDLty8Pre+v5u5Ra3PBO6Pah6BxLmELdUYKrgu+kt1GhKegIjibFn289z3qMnk0j0q3pLquo5w8fwT+jZz1uj95mBrF3ZcQ/xkJupldn3oTZrDyxAKIYiJ+GNISm13vvMR6oy8t8wTOPQz9zdrqj3Rsi+UpAj4OsEdkhTE6FvwMl1HeWYSNHS8/vhiLkQVD8c5UsAXypDrk00vbI9tX3MxaiYZtrQeIbpYlcW39LPyh1Wx2aZhjx80XpZgJMOcioCAB5SO5zoAdjZbMmc9zqCekdzaAoR1tHvP6tob14m2/5ygQ7uPtPoi5yj06fblU9c+71Orts40wOGqJKKm8iSItEDqTaY1Tp1Ok878kk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pu2n3UtzA2yxKK8wXMDtXmxgu0J7c6QU/XAffJfyvJdP/LAQuyeajQm/T0zi?=
 =?us-ascii?Q?Gepkedn9P97vpw5CsDAlMjPyLmU1GH0z+ltsbm13gFU9Z3ur7bBlbNtf8KEN?=
 =?us-ascii?Q?e1E/zgFsNal+0R1cqaxOWLELdfK+KQT2NCOZ0aFSwbF+mcFCEIhpg6hVIAdc?=
 =?us-ascii?Q?hzZnUFzLrA0s3iILZclDY8kpvZA8hMVVLDf+HCjQG5plDOR0FRJh2Hz1rZFG?=
 =?us-ascii?Q?F87LgVHLzcylRhvz+YuT20bjHQFvs7AmU4hy92FtYLBG3yBKZLCLrdX8ta5L?=
 =?us-ascii?Q?uQptk1wd5nK0IKswfy1kvgJDYz/+0mOY5kVLy3TUZL9LCXnK1BWNT01nURti?=
 =?us-ascii?Q?qBP9DUlo5rugKmX5EU6LjkGPesw1ieSpDfyeePbcHXhRh1RYFH1p7nbwNB5/?=
 =?us-ascii?Q?WhZuYiQIxz82sQ6Wo84g3hJzi2AGfiqkGst8FoN+O1mS1WGwRKhBWiHa0T8F?=
 =?us-ascii?Q?vt/pngC1b5dW/MlOgfuWEOwSATJUVxUPYVI6ZlFNycEwF/jmSyWfEWaHpTpG?=
 =?us-ascii?Q?U+xdZg/Ci8duw0kzPVWxMBlS6+imGZq1/rQ5CKhpYjRRujW9P3O1Q9hINIgF?=
 =?us-ascii?Q?f8hg/qeXsc5JEQpp5siiyvFYAo3F6N6b8yr0WqybeEko/Vy1YFxtZorx9+vf?=
 =?us-ascii?Q?f6LxN8vgPtGgSv8tmrG+HMDnhnYbxpghJXPvHsFalwDctG+cisIvPGEXIgHf?=
 =?us-ascii?Q?IvJG23wSAcezajE6DXZ5ZvK5dZQIECKxX5Wy9jm/8AsRxqaEenUhvCwBXMYE?=
 =?us-ascii?Q?BeFTj5+2kEI3+JDngtY2KK36TqhKErIS2AfTasmDBirq6/RYOAB44nv5kFfi?=
 =?us-ascii?Q?7e0qaZXI4Cait8MnNl1ChQQvEGBYt3p8pikvelW9DXF+smeE2R95yUxe3INq?=
 =?us-ascii?Q?eKYGngmO8SuPSayqjxAd8L/yR+WeASKHCHVM1wZxFCEW3cJ9g/LYrsN/rJnf?=
 =?us-ascii?Q?nvopY3UHroKRSZg1Ex1Xa3LoA+xd11vkpmm4CT5IUZA4CbFNGTqverareG1y?=
 =?us-ascii?Q?kBEqhfEf2PVf9REXPN0XYwhzEX48ETfz9EB+F7Z792rSbMDm9P1T7Ynm9Gsx?=
 =?us-ascii?Q?gF528qvzzoFUNxfb70hC0f+zw+xLY003s2hhortd4/UcK8SX5dlzEdrFgwFC?=
 =?us-ascii?Q?IKlPefWw/soatQWEag3CBUgEuvocaH4XRGX3wJ4wUG3iWgoAe0NrRBE4auDZ?=
 =?us-ascii?Q?8HRADbH9F0CgYaVHWuEjrV50B+kVMo9ejVSd0JMIQZbrGxbp3xjjft2bLnAL?=
 =?us-ascii?Q?5lJsBJ2PMNU/P2+t94puVLytGzGTzt5XYrPsnTUxmukkA967sZhTUMk7iiEk?=
 =?us-ascii?Q?0JVS8cGj2ceIGn9g/TNP0y5mQjUyD3tYTtNf96S/jy/ngr0ntRWLSKxxUbKN?=
 =?us-ascii?Q?4/yLfjIlRrgGAdt3GLwFeo1nXJin1mkFPk+7NZztwPdsxhLPca1ZEcZeUuan?=
 =?us-ascii?Q?eV0PF+qTBG4GRqgMPcwn+e4SXvsc2bNCukkJjB5YwfuULEovDcVjVJriHtWJ?=
 =?us-ascii?Q?4Y8LYf1YAWidyfIQWZCMa8OEm0CCBsg3udUQldZ08Ow3UvbuTLuwtScAnwEz?=
 =?us-ascii?Q?sHpS+Ja+w0UVsK9F3iY8i5d7TtRj3A2wpo9R89/2FCbpSeY/QNAAYoBpkiui?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ba3182-375a-4446-26e5-08db2e0173d0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:17.7481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sm/CV7/wWkMVOexXjBFCJUI1u1EfE1L1WoTXRSZGa/odN7ApzDhELdL3nkoKIldavAdlKKOnPkmmqA/qK9Ozrg==
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

Full Hyper-V initialization, including support for hypercalls, is done
as an apic_post_init callback via late_time_init().  mem_encrypt_init()
needs to make hypercalls when it marks swiotlb memory as decrypted.
But mem_encrypt_init() is currently called a few lines before
late_time_init(), so the hypercalls don't work.

Fix this by moving mem_encrypt_init() after late_time_init() and
related clock initializations. The intervening initializations don't
do any I/O that requires the swiotlb, so moving mem_encrypt_init()
slightly later has no impact.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 init/main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/init/main.c b/init/main.c
index c3a0602..b559540 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1025,14 +1025,6 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	 */
 	locking_selftest();
 
-	/*
-	 * This needs to be called before any devices perform DMA
-	 * operations that might use the SWIOTLB bounce buffers. It will
-	 * mark the bounce buffers as decrypted so that their usage will
-	 * not cause "plain-text" data to be decrypted when accessed.
-	 */
-	mem_encrypt_init();
-
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
 	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
@@ -1049,6 +1041,17 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 		late_time_init();
 	sched_clock_init();
 	calibrate_delay();
+
+	/*
+	 * This needs to be called before any devices perform DMA
+	 * operations that might use the SWIOTLB bounce buffers. It will
+	 * mark the bounce buffers as decrypted so that their usage will
+	 * not cause "plain-text" data to be decrypted when accessed. It
+	 * must be called after late_time_init() so that Hyper-V x86/x64
+	 * hypercalls work when the SWIOTLB bounce buffers are decrypted.
+	 */
+	mem_encrypt_init();
+
 	pid_idr_init();
 	anon_vma_init();
 #ifdef CONFIG_X86
-- 
1.8.3.1

