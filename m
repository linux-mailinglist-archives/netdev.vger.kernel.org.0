Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16B96B195F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCICly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCIClq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:41:46 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43035C9C17;
        Wed,  8 Mar 2023 18:41:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVFohgUgCQOW2y4vGA8maAo/0xSjTSmN0/lNTX4KfK0C+bc4+mN3c9UWPhxw07wZWlqsv5q+E7YkxUj2lZx/GFIXXJZBheFHfD/wJb5msHJ23BDJ7G/STvKwu+EAsvNCJe3QkM94MmvSyAJlHsTURWoTBnEOiBQHCWuxdxc9bHMbvswOFqKOTIkPFIM2vibaujxyvAjJcoU3Oq/tDnbH9b4BDYJ92EBuwsfNftbkmByFpjDGchBtXmBz3GisIT22UqZSrXLfSdRUqkneldL5BaREVLXsFsDOQi2XEFHS8zFjmCb4wgUSTLXAzPiGYRLrHOywxYfJD5xp+P1/Msj+yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vVCdaTFGXtkZXyLDOxaOfi/6PmqIHiJZMVI3+wmvEE=;
 b=kbYcka06ayGtLQ1t6YiFfUu0h5TRN7AjhAkyky7h4YTIfDtag7pzVINiXSaS7T5wMKo4tJhkcSmhvxV+8BHE4kuh4kbce+TYd/uMfdr/dtMIE41g+WB9DmrVmiGnx08hQbDQnxC4OdGTVpeRgWN1OYt3AFERezg4cMlj4MEDY0WV7hpPloqKtIFQcrLK+bRP1/PDvFhIrAmGXIf/QBA4d6aaelrFzjyDVcVEroNvzRC98nP0fTZjesCYyxSA8zVAdm7LAOwX2r/8JD2nMMquV7db4vIbUCslZttlnqsXijonOLS/ATq873JyDo5godQQZF2GDszM+lxwV0gSLwNIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vVCdaTFGXtkZXyLDOxaOfi/6PmqIHiJZMVI3+wmvEE=;
 b=fIb7tzXlQYvbp2bRl8y1jQmuLIW6lx8prZEnNISSBQEv7IzYtBgXMExFNHJJo15hjreXsnFUJ9+fNRTR6B7NM8eg1P9OMUCOH2mSNXUhWnvB/Vp6FWV60yNqPziFtfWuVOZuZ9S5MU0d1a72/nb0Uk8bQjIcTU7HRkO/Otso0A4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:42 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:42 +0000
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
Subject: [PATCH v6 04/13] x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
Date:   Wed,  8 Mar 2023 18:40:05 -0800
Message-Id: <1678329614-3482-5-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 02555359-c78f-4286-8dc1-08db2047d108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYc7DGq4fKEe8gyeZXG/6NO8MxJ0d9obDl4zufaZ/GIvjF7cx1PGx5SiYyJAtqMn8yON4cPiqyb5jAMBaib0jiK6FpqXB5PnmAj9jVRWB+YSkptrSvsHAq0LfaRpFBkWPdi1XoGnSZsfxEEgEahHvNWMdvUIXoVHuKbF9sXHXwnFzlJ6az5BYdiaf4m+YTxLldE1aADae8Ryuqpp8w0OhdNDmj9yU+9XZb67BMUtSVTnfzG02jxudDK7CvB2PlbKzO+e2Cv7L6LesQ6JkLWyuX8E4ztpfWKCh3oAnuNCKXSeJ8+3d+MeHvs8S1VFfisKszYx2C3U1v6UUKT2OF110Qy/j5H5OfC3rKeiBu7RBCCkyQN527jPfQen1Pa+GknEfSY4hhxRraRncTDTU1Maexx1PZ2WK/yJ/LGQC/ag0ak84SmRj4lJl/wcvV/k0MDzQXvfBr+rXkjhUbBYnr6cBXWDZrDS0Wz1fGdzaMRYEcC6NPlGsrd5uV7muMCkatA55ywxarcMwSCfM4zCy8FSyePGkpLwnG/CXB5N4AsBMGzSjFOE4t/2oc5k1ospC9puJczwovpMo0ljRmlpJ7Q/KXVLgr6fEb63ggB6WavnG2oaSQqBemCEmrttP1K6hAZ6B71vLhYQot2kIZeHoSn1XC7R7/zt8bJm/bieDdPMrqjZt8Jaziovi5hJ8wWrF4XrB9kLkhYJ7ggmZ+HzP5a8+I/22K7CxoWZAEBjH8FtXrurrqelP/JJ0rLFhIynD3uafxLD3GxlIztJdi2pU45StQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mun6Pw4MLTQr50T/vTFw6QOFATLN2EZykFB4UrLtc+j7dooJGPv+eHYCXEuB?=
 =?us-ascii?Q?oxG/YXoJV0kMn49n6xlqktur1wll9ENoCMDR6KyuLMYbf7OMu94dsCu24hST?=
 =?us-ascii?Q?PfiDSisWf012Tz33fM7WOEsXE55HtX2QFuq7aYTb+9tGBmuKmrfSNYs4gOIQ?=
 =?us-ascii?Q?QNsbVZLi7pLkcwLyGU05dw4CqxYT/1FmfwRYEYULZ04fvUC7B5s0apaL6iex?=
 =?us-ascii?Q?XFXSpgN7fJWsVjmKSVzm5FKwNQWB5CRdxkGEhSWBh6R1XiJnCH9+zJLYoKRL?=
 =?us-ascii?Q?C4UUZeo+waq7OcDZgilef8Ey6GyKAT+ppZHnrqE4rURM83Ur4h5Db1XlyHf3?=
 =?us-ascii?Q?XLTTH5hWI70xH+ukm9Qyo79C5V5i+aZvkwWHSDTOz5YR5IHI9oTKO/0/fT1u?=
 =?us-ascii?Q?9+xDEtxpC9QWs7cbYRqhGzvVnkzApGfXZlY0nsxEHgYF6qRkg2TnUGJunSGq?=
 =?us-ascii?Q?YVk9WvxN4YzApoQ3XXr1AzxUaeIj+M+DX7OTTPTNvcE+5DdzNOBrvmzpCn6I?=
 =?us-ascii?Q?xdFe9waqCDRARgZopMTjrKuHQAAqSWzzyoS6NByxYTef50fZh39UZi0T9fiJ?=
 =?us-ascii?Q?QOFiSaetMQMFLkUOsTLDPLiQzO6cIgOzDd7XUCUXPTR0kYdZHcOTRHm+Jw/4?=
 =?us-ascii?Q?Yg7/0KMCvpOMe2y1dahltxaCTVyxxk8uq/ELf+RZnq9VvifOtlGs3sc50OXn?=
 =?us-ascii?Q?tQNdYADEnQjCz8p6MDPRn34AUODdlBBFAwRNFKvA9WukI/mEuAXvRaAy6C2y?=
 =?us-ascii?Q?DFa/SkizdbGvId7Ik4Oihgd1M3L0b3cquw78h5UUSa0IreSvUXKpPE+ciDxS?=
 =?us-ascii?Q?G3eKbcYPBdvAzOsi16yUPrtnKC7Y57ZTDh9XJ/zVB4wEsmOUt/X0iMswTd4Y?=
 =?us-ascii?Q?NV6sjnRqErMiVBVtJcYygnUhp0TTTx/8tQhE+YcI4q5NDFSw80M6Qb/oaLbC?=
 =?us-ascii?Q?RGcmOHa9RVqav/01eIHTBgO0833jAOlSizyjokLywuEAPXmHZPJ9BR3EJWJM?=
 =?us-ascii?Q?yAJDqzuww0a35dPAUocSdXASvUqXddyQOwn6k7Q/zb/chgeY/xbI+ctGIDFm?=
 =?us-ascii?Q?uBh2QrUE8y2cvIXscpeccnXmi+XN7ZkPRf3ebIveYX6fhr+97UciWzqOn6PN?=
 =?us-ascii?Q?1v4lFxqjnRZqzQb9lcQhHQpe2jK5oRZf0Sd3FDIs1hG1pWmuz5AOivjlRmcv?=
 =?us-ascii?Q?uBrAAZKyKlHYoTBwXRjNHF4Ab+Ou8gbYAVoNKwv2MciONPFcXM5etkk+lkf7?=
 =?us-ascii?Q?QPAy4ZTOyH5b5vK+JlLVx3Gdn3ikaqYDqmovujAAO0qHH/xLLt1ZxyFvtHdk?=
 =?us-ascii?Q?qkj+/jrFNfJSlZutCxjx3m2VPQEFZjBI7Di59nR+QNXpD3xqIcgHMp2uGOlk?=
 =?us-ascii?Q?dq/yzPiG1PWVGMYThmssuRwNx/bsHDzK7vVBGGg4Q3VHN6sqtjbdQnidiZAR?=
 =?us-ascii?Q?/5tcMWh+t8kTcXiLi32iqBAisFjq1FIhT6c+UripReb+eX7dH5ox0cnsmlJD?=
 =?us-ascii?Q?NpvOAV4XLkrXJz97CQmsvsr+DduOog6pMMY2DZyYY+FnP1WXKmF9Ght/rmXr?=
 =?us-ascii?Q?qAx6mF4+zezy9QE8spqUEprtMEpj3xrcDW23ap7YBFsXRz/BzpVUeNjIEiYc?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02555359-c78f-4286-8dc1-08db2047d108
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:42.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDx/vAuCUrX8CCm+rCLcH57jcs+t+FmhfqUY7HWEV2Tz/GCD4QEK2kTXGtk5u5h49o7g10P/fOg2UZIZHswPpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

