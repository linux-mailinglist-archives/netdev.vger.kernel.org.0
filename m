Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46B46B1965
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjCICmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCIClt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:41:49 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20356C9C08;
        Wed,  8 Mar 2023 18:41:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFWjvHGZ15L7iJfEvlpF5vl5Zn17GCcWA3VLmu+W7jf5tYXM1XESIgrEnD/QTRG84tWI8LAXA5luxWOtI/IRdEqn/TFwy9n6KQTBXwDGlgdh3cNAvn0g1k/FSnN583Hvf9mQCCsfE8+M/+a1PuhIejlBA6suHwYm9Ef7E+aOpdHmcN5pl1hzpa6Xbg6bMVi/KP9BRRKJwBA7/O5nPDrNpX8SWUpTjJo1SweGFv61uE+q+ffWGGiu05ha+m/rEGVyBfKK9StSogICuO2KV0qV/6Zwn8p9mNhvkYNdRPuiFt8ZMlBBpfQgcqpS4GtGciC+N/n0p1IRuSseuoW1jeqKdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgpLwgl5yyhxkm8Wh28XIUSfBNAlS6z8nmd7fLV0eRI=;
 b=g3QmD/vsUczty2LCy0zv+QZriK2Mj76OUXkFxd1Qrf2H661j6skpwGkBmPqna2QtwsR0JP7kmuHXn0QEs6P13rqngxw/ooy3Z+1b4Go17BWabBR40rJNIrbyuW86HOq+og8L+TRH3EUgZZS4JezLOADolYVI3za8tzBPHUdcsokhLz8fi8+HkBk8GQe6cff2u7Q25dYn6ThhhemhtZnIdAb/RIPHfjzc4qmqlc7KuRpmZtGu9ELU371NR+FlNZ/12tcxAhIYmOP2XJxlCzlnAkP/cN0ZtINWDfCRFjHS9l2pmel194oyTdCugsrLNlIwosnmyj5HVIQCrujGq+B4bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgpLwgl5yyhxkm8Wh28XIUSfBNAlS6z8nmd7fLV0eRI=;
 b=OGvKe9LYmIKjbz62uV1gqg8VMECVugAgiQmR1aY6kOu2Y41xbt5okerUCRn+H49jg04MdCCKcUjg2FcMrkZg8Qk7CINx9mW0DqGkalDS5cojJaPVF+G2qHE20tNEBv2eaU/ndQxcBa98SYjXPoLmbNDcP/SORI9D/QvQ4VJZnSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:45 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:45 +0000
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
Subject: [PATCH v6 05/13] init: Call mem_encrypt_init() after Hyper-V hypercall init is done
Date:   Wed,  8 Mar 2023 18:40:06 -0800
Message-Id: <1678329614-3482-6-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 17f78769-4eba-486b-03fa-08db2047d24f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bG7JGgymHzzoTssk5vNlGSTTlKfgcBu0pSyCYXc8085yzIiVElBkXanUKnBMQM1XSAAmkpZ5CrudaqMYerVGmlsZQWeUGm7JTkSVwMtlDLHmKBVBOfIEmiXSyno0CUTl3s6fZ6zIi9ExdjEqTERglxfk1wiPECf6BqAUuS3IpY9wrHpFD9UKVsvEdf5n4l/FmluWuHU7ov/OxQqyd4SzVvqaTiYAhIgZBEwryKckuGgNW8l0KO+R+XjQGvHF6RMAWb7RmQoa7E+I9ItZpWrmZgU3IlNT+dcItLLkksKyVbnipXy7kKA8o3Txf9oFMyvI243Edx5sXl+V9DR2EOplQR+ddJBjR2MxWH4JCkQcAoTWeMEPJ1SSaicw7IJnzcDOarpNyfw9rHWjQ2TqzdyS6pByq56oQ/Ln/rowrDrCzXcBnlX9UGl860/gEjpfsirb3yFI74gfWubvH9JycweU64UNHzckyuGuK459HAmy+t0pxC7kgBSjlVZKRXB6c66uXBkDXtoqNazk7c718EuLxclZX9E6YUYfy41ENoTEagqfTuoqAjn+dDFnY0ch68O9Q500SHac+Vwtad98lkbttFNRaLkFlqiYqrDh3rLTh86EpxEu7kI8Lm3fwXh3AG7D9w1e4d3rcoXJ46ShLuq5vzoHE8OdJzB5cMQGhp/tGPsLPWvvhabmRNBdsxLRpChma31VuiytO05u71gg4HhsQpjpr2OT8rWsoRlJR7gvr2VBNIwDx5bM2v9wP91FEJ3xxZzoEW/J/woYekNwqh0ehQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dubR/IDeoAP+fNAFJtYzlsmzQBqsJORjXplEXP+SLgpLdyOKkF4GfNS6S2ZE?=
 =?us-ascii?Q?DJj83Qv6Zf51L2ZjVRZN8HusTgxbQqp6N9HR7qWIJpj+lY5cyZcP1oaWe1oO?=
 =?us-ascii?Q?kAyhrCSZJC6I6peePqt05E6q+5zH9fTfAZHr3b4FYSCPcuJTtJI5lANRCvci?=
 =?us-ascii?Q?IV852IVVeGrddefNyCuCHyPhR25nXVgdvdncfDae9ksCVQ0z7AHbZkGmQPc8?=
 =?us-ascii?Q?71VnXy13iEXLKhpplyVcLXmWZVBb0IIoBxSsL2MnG3PcGUDwejTSXSkh3wkY?=
 =?us-ascii?Q?UxMTGnpYkUvw6hBqZNxwvLRWqZJJThlZp7643iwDRQxV7hxZZ/J616n9ZV7U?=
 =?us-ascii?Q?dO26yH78rR86EWgdrchg3HgtNdmFeK0OKqddkp9Ov09FnJDLTjfol9vvctcm?=
 =?us-ascii?Q?P59HbuX8AduZ9J2ZdG4dNQ771UIV7pfdn3fahrbFXlMY7xzlcq6pYQ/HzgK2?=
 =?us-ascii?Q?Z4pOCDlewsRfK2ubFh5E0h5a0rJwxdmfTRiuVv4ncpBcfmezOFO7UERuXgpu?=
 =?us-ascii?Q?CyEbUOUT1NEBmAYaSC7foyz9+oHhASX8+FOmZwT0/BzgQD3vNNYqm/dudU+H?=
 =?us-ascii?Q?LyF0lkVuYioslsdf+q09dFuXJIA2zC0RnsrNi7R2buy6HJMGZwvP507UWGIn?=
 =?us-ascii?Q?nCVWh+aoAX8qZ5X6r2zfWP3HcbUJuPv0Zm9RjGkPGyEayb+od/mEcNZRj6sf?=
 =?us-ascii?Q?QacPK+QpbBj7nzBGVCOtOZFew5FakcRj0mVp1zvLKVnznnTnYBlTjbM36WZi?=
 =?us-ascii?Q?PZDIH+ePC9pi3lXQ88RXg/MyT7dX0HQNGntW+vBvzxXEht5odOETdM7eXZuo?=
 =?us-ascii?Q?QQD+d20j4/82CEfE2uDeOhYtxKgkbTYfkif5h5YWcb+Xjeopd15dRDnJPQXn?=
 =?us-ascii?Q?yK+paBnIXL6WCbrWFwDh4vsaqq2PAKQsWTSt3Dv2PVkBHmTXpwlNu+thuzwC?=
 =?us-ascii?Q?zSli0pZKWXqh68GKZ8nI9zltFB6g1mn6Lc7gIbn6vHSRlO/Ovw0/j+1vUOk4?=
 =?us-ascii?Q?+sMg3izPTgIZaDZEc8/WxhCeHTXvYrPNp3oNWYAn96GPS8Na4aDXRSZKq04z?=
 =?us-ascii?Q?9APS3y6R8fIyQUWfiI1x9znLq/lLGocSlR4JE6MAdP3FeQsJVApn5bVIf7Q3?=
 =?us-ascii?Q?faqn3XEYHZ+lE4e6N8G6q6JSBxQ94lD09v73Qkzrs/YdgZB0ojuB+bnZZ0Ui?=
 =?us-ascii?Q?v684KR6zVSHwjn7o6ciPPEV8qes6wojQ8TEvCqYQOaJAVoIXAtBsYOnqCW3m?=
 =?us-ascii?Q?SEI4v7dxcYUy22QwoXaiCYDExYjQhk1sijTGtWI/iwkNZRn1J9Am061LMHZD?=
 =?us-ascii?Q?Yrb3R9aX74gmV7a2lOZ3DuM1fOsb9Kqtn+8ytUM+kfbw7jNGRoySEm7IN82w?=
 =?us-ascii?Q?GaCBCCzupten7YlBx5uZ/Hcf7o9WKvS9sx53RJGQZUlRCTKAp7jOnjpAzje3?=
 =?us-ascii?Q?hC2ii99offba7tjiV2P7Ys2yFEux19egdjpRwWrUSvCXZ2dl7AiYdI4iZtxN?=
 =?us-ascii?Q?oT3ND3U30jIz7NrLWzls/mxbOEwsd1H0et/xYS7L8LITHJXyAi7xngvlNN5j?=
 =?us-ascii?Q?zwOyhChLSrPR2s9bqdKpQ8+/EGYa89hXFqUaEW2Zmn4rJ/tPxwTbM0BtDW2D?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f78769-4eba-486b-03fa-08db2047d24f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:44.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GFPFUdL3yklgQ0FzMRaMrblG9rylVkpc93gMcIpRQIQDUSAYSPP5T4jfptiwBIuy+AFIF9uUgfsp8tW7/WeJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 4425d17..7e9c0ca 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1088,14 +1088,6 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
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
@@ -1112,6 +1104,17 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
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

