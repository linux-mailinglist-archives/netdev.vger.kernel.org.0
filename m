Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF30651A2D
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 06:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiLTFLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 00:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTFLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 00:11:10 -0500
Received: from CY4PR02CU008-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11012008.outbound.protection.outlook.com [40.93.200.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6741825DC;
        Mon, 19 Dec 2022 21:11:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kl/Qn8yJfF94inzX5BoLLVTdjmsoEW8Mpoj2ThLoNfeyZzbuZOhgktW9EkvLN0YPM253MRawHU4rRL7iQ91W3lYCn0rG3WuVOHseDy4Od8XHBhaWwc63xypzbxkjZwL5gfCFltkdUbiWkURZU97s3k5k4aUjGquRaGBV/S7zRmOvSlwTA9YnDt7BzCUKDADVQwT1T3Gz+adsStT9jRqbSsb7AVN0OZZHm5h3rzs9wvl8a9FoxInC7t+qEZmCvXBlZB18bUZayqhGgPubp7+ZLFn1MBdU2EAhKq0R/WK7Epm+rRat31IyYuh1Ng5Q5o7heEc+/Upm7KSlH+x+XgU8YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UFDfs7b3/bwMdbKf70e8PDm8fyhWoj4KVpSoOoZozc=;
 b=OpskxuV2/Y4jgEDQuefQgT+k9c9zbwiQhRwNAV+wSaw+pPJKe///HrMnm/mfSa5kczkMxRAO/7Dtv1MMhPWWlI8Pq7Sp04ENbEGuGSOJ1cmxcwBZGS8C4GP8C76xWowB9yeQtiLQ3t909vZeU+nYj3E29fdTDR5yq0271hyf076CBuxaT+HJ2de/bgQISj42gT3t3xsGuGG5gsXGeRSes3rQ0b+VldnVGiPOBJY24jQQX0vXTlPw/1J25oPgTHgWIFoldjMtGtx0BOHfG1SygCrFmPY6L5VTGUSptQExXIpI1Skg2OdAqW8hg7BCVahn1dkP+A53/FBkZGb0xsJ+UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UFDfs7b3/bwMdbKf70e8PDm8fyhWoj4KVpSoOoZozc=;
 b=tt+qfGQMC2f27w1TfdnpKjJf+Q8qq+XHhpSrLkdtlox73jG68JyUV7c1/2Vnuwaq50B5LCVm4KqPTXvw+81BlOnU/DrT4u4AMyokKAZg4Z/gyTfT0ftOLR/qgrtjv6Hf8E5flUB9eUhl7EMWiHBl2YdlXJeRGzo8138hvzPb4Ok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from BL0PR05MB5409.namprd05.prod.outlook.com (2603:10b6:208:6e::17)
 by SN6PR05MB5552.namprd05.prod.outlook.com (2603:10b6:805:bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 05:11:02 +0000
Received: from BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::c41d:81f4:d7b:3073]) by BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::c41d:81f4:d7b:3073%7]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 05:11:02 +0000
From:   Ashwin Dayanand Kamat <kashwindayan@vmware.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ashwin Dayanand Kamat <kashwindayan@vmware.com>,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        vsirnapalli@vmware.com, akaher@vmware.com
Subject: [PATCH] sctp: Make sha1 as default algorithm if fips is enabled
Date:   Tue, 20 Dec 2022 10:40:37 +0530
Message-Id: <1671513037-8958-1-git-send-email-kashwindayan@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::8) To BL0PR05MB5409.namprd05.prod.outlook.com
 (2603:10b6:208:6e::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR05MB5409:EE_|SN6PR05MB5552:EE_
X-MS-Office365-Filtering-Correlation-Id: d2eebb17-0b54-4c92-bbc2-08dae24896f4
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mOqrsrVuJ0h9Wbaz0UjimqM/+E4pvc0offc0t+2QaK79Q/48wSWJ8H4ZFYy4bPlCE+VyPD30cak/HRlafzW17rbo7imn9ZrJMDJV50JeNicChVxP09wj3NydCBEU2CxQcSRvEKBsdlwMMd9N3Y0VIqWDbYTeO42GjWIst8ZbsAxnTXzlq3VdpFadBKjWe/DrId5qqOvK9DO19vxuHFyT/s05Wtz6Zh6Qn5aD1FS4Iy8yoldRTfim7LXeBVJskbSv1vH57Vc62x/guAt3e0ZmSAzIJtPZQ3SfSbSojtTrxhxQDUI1l1PT5aynEaouEAGJgbaW8MNAwDm1DiT5EEPpCPlmTA2zeGCwdb3INvEIBL+8RFEI/dzkIS2IhL85gOxlvatRiiZdkIn8/6BWQFeLaRYrWz8ENgMSCB8HaGUZAj77T7rUNQTX/ZNdr1aOTuLaztYlk36TXoVr5c3dvjUzPhXOluF7sHxQGK0tgI/fhIm/ionHgEvJ0AMAe4NL7V34Gtx/Ane24t0zQTdUxitIk0iAihHdDokusNbUfeltjZWNT4tDAwuwnz68MREQ5UnkjmAei7Fc0/GsKPI0iFMyFF1oIULQLEYmbsMxZ4xKL89/pQXB3WbIw1F0GfvvZq+YCLSNykytqaZWyRueRMHDlmg22m2nna40TvS06xIgpFI0DUJznixjphM1UxW06kpayUmLu+evrjdUwhUitufAyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB5409.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(8676002)(4326008)(38350700002)(41300700001)(38100700002)(921005)(36756003)(5660300002)(7416002)(8936002)(83380400001)(2906002)(52116002)(6666004)(107886003)(478600001)(6486002)(86362001)(66946007)(6506007)(110136005)(316002)(26005)(66556008)(66476007)(2616005)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y36s/Rk1A0g76gv7BxYAOb5ml0PBFQiiwXjYkDtF6y/D3cufg6mbAGKRUhqj?=
 =?us-ascii?Q?FffIrI/7zQmQZWXftcuJwRkZrPNwfkwyraKXBFqs5LdKUDonCzGIVUBwo7I/?=
 =?us-ascii?Q?78z53SoECDLzL1lowK1V3C+fDpuT6qYy4fc6IGjivTjySU6dJ2bJzbYZNd/w?=
 =?us-ascii?Q?NO+ZEVQrAhq8Gf0D5FoFA7M7KUyhCQc+CKG0Oqb6nf/lIxZI/pvzWhwVy/q8?=
 =?us-ascii?Q?nd7yp4yJEDP7s63siwD1mjBBwQYX4WZkuudDhcDx1bemaNEz5X9KBo4PZTdg?=
 =?us-ascii?Q?qiuQAxLXjdlbxHjSPqztVEzm4s5L6zgrVFQLY6bMxdMyqcCg66kqff9Wf3UV?=
 =?us-ascii?Q?Ua0Go9PUrAVY64FVYVfGajRRQ3Ek8Ej1jRAktLW8cpA0xskoKrRvTsRNeTwe?=
 =?us-ascii?Q?ASAc++azjuGi6IJKa7+PVtQqBsuNT4jbuZn5qLS6a2KY1lNw63M4QYz3zdOr?=
 =?us-ascii?Q?ZMMHDiN/awM/6vSSgnfnGHZtgtjAO9e5riJ0ap+zisGK2lxRljwJzTF10MXm?=
 =?us-ascii?Q?+27YtQLozIBUan1hnDEWgRaz/+3/GI1dlDWKM3hV5Oq//0JkfMHeEt8M1jqG?=
 =?us-ascii?Q?n1FM95zXdl6LmSdub+BhpJp3vvMZFCjQku/nDRsQNxejAEB9h8R5nE8eCtQu?=
 =?us-ascii?Q?Tt+q7GVM5fPngZCOO0TUZuZuPy+ct1WZdvIqrf3e13n+InzARbwmSy/Kcu9n?=
 =?us-ascii?Q?FgpBb8HBdmFI1Q3TuyhNeAkeZCjQMW6bCkqzHSAWNidzHUr51HrH5tRwIflF?=
 =?us-ascii?Q?Ziji6MyGIkQX+4tBMJAnlTOhD1R7izX/AWWQCSLbqy+1TfqABN2FRcFIMfAb?=
 =?us-ascii?Q?t64UEu/xthyF6KOeRpfwjr5JIRE+JY19a14nNi+prIedBAw78e8R9LFUNslH?=
 =?us-ascii?Q?bywwFXm5DKngsdyatIS/FC4IahmsNAAMn9Rv7HFWya4gP0ReYmio+VmyTMOK?=
 =?us-ascii?Q?2Fwl/1Y8KCiz2CaRXHS6N/Vs5omndiNmQ1grokyD46sKIWf+i18fenLih9TU?=
 =?us-ascii?Q?9Ewd/FJs0a6nUcRBUMgKfQmewM4Zm7JiM7lcz2St0fN5hkZJaFiJhkdvMQSL?=
 =?us-ascii?Q?R699z84iU/tEMreXxUOTlVYFJM2lvxMMxBhZSm3onqD2Er2t4ezYiIi4WAB9?=
 =?us-ascii?Q?XmaTg3mMXJoG8bitZxmexqjJMsyTj+Ft5JxVE8TwM2C7M2wrPR5Yei2lFYGi?=
 =?us-ascii?Q?7Jjww3RlyerK2EIGnR+E0Bz2uIJ/77bwpThyG/rem7R5GSrLkthirDBzoquG?=
 =?us-ascii?Q?e7bcCmrLwpQWpUerPZ74p0t3ZHAtDOOSs+PRhcAJODntN2HpkDmjhXtYsBso?=
 =?us-ascii?Q?D3CVqEwaz2rEC1pcrJgE/URfX9cEtNszWQD8BROBZrBFgogsD57l+Cu1PC1f?=
 =?us-ascii?Q?tLzNsQGzkVkiknjM/Yy7y7e4ElBnWzZ1rv3YAGex1o0OUOUBkvX/zSN9P1a1?=
 =?us-ascii?Q?zX8NkLXdwZZh2ju/ZbwFNW1Yu6X2Wu96mx4G7ct1xp8VoCODNlwx14Hmrmzb?=
 =?us-ascii?Q?rTeGSTsJS8rMzSKRROz1kziJLdDnwtYGAZWkfUtTgMwBvbnTDYeDnDRggh+Z?=
 =?us-ascii?Q?sbDjJcAX9N4qf2mNzy02m5WN24gCVtZDY46yJ1GD?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2eebb17-0b54-4c92-bbc2-08dae24896f4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB5409.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 05:11:02.5896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: giHW+muOgBRkZnV+ptTqa6P5Mmb8NX76UBFrG5/swq7SIjSH/WJ/4a8JVtZCB+8DntJxjUL9g74hUv3aPv65BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB5552
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MD5 is not FIPS compliant. But still md5 was used as the default algorithm
for sctp if fips was enabled.
Due to this, listen() system call in ltp tests was failing for sctp
in fips environment, with below error message.

[ 6397.892677] sctp: failed to load transform for md5: -2

Fix is to not assign md5 as default algorithm for sctp
if fips_enabled is true. Instead make sha1 as default algorithm.

Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
---
 net/sctp/protocol.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 909a89a..b6e9810 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -34,6 +34,7 @@
 #include <linux/memblock.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
+#include <linux/fips.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>
 #include <net/ip.h>
@@ -1321,14 +1322,13 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Whether Cookie Preservative is enabled(1) or not(0) */
 	net->sctp.cookie_preserve_enable 	= 1;
 
-	/* Default sctp sockets to use md5 as their hmac alg */
-#if defined (CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5)
-	net->sctp.sctp_hmac_alg			= "md5";
-#elif defined (CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1)
-	net->sctp.sctp_hmac_alg			= "sha1";
-#else
-	net->sctp.sctp_hmac_alg			= NULL;
-#endif
+	/* Default sctp sockets to use md5 as default only if fips is not enabled */
+	if (!fips_enabled && IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5))
+		net->sctp.sctp_hmac_alg = "md5";
+	else if (IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1))
+		net->sctp.sctp_hmac_alg = "sha1";
+	else
+		net->sctp.sctp_hmac_alg = NULL;
 
 	/* Max.Burst		    - 4 */
 	net->sctp.max_burst			= SCTP_DEFAULT_MAX_BURST;
-- 
2.7.4

