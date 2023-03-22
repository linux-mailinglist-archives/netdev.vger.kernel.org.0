Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BD16C4CE2
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjCVOF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjCVOFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:05:24 -0400
Received: from MW2PR02CU001-vft-obe.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD72B4AFF4;
        Wed, 22 Mar 2023 07:04:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IW4rIfn4pG47q7LZ2a+6/ofIEQ5bWG/yf1wkyl++G4H0IAtA/sDsTPY7i2WKvXLC7l6DO1vXp1dNHSoKXy5CZ3Xcqo+7U45Pa4Sr6GtR4qR6Y9cHXHp+k2B2K5Psrx0xyFSM9AwLUnnOtuP6CyhEJVsFPntLXD/6n6qsUgbt1VSy3D7iQOvUo7btEq3KEEASRYgkPrS5nFoNRS9xzRw6yOWBBIyA5tsA1Pxz3U1wy92ShjCPVtMMqEwU+igQgiWwBvKnB/CJ5LRDbV78u/QjhczhPFFXtYAlUGhaX27cCjwNawoTUVCxbg+wGSacugsvK1aeSFqv6umfktXSr5ohKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yUhGc2kEDGTvSg5ksdXnHj6g26KYzutBixjVJg9V0k=;
 b=nJkee0mgpU66L/QZpbjLRA8PQjvvH9aktw+YMU0nhIR0YguxQEJQMOiDsqenPXyIDWrj4mAz8G84hb7AGfTeWtORnl9IMN7i+rHTbtAB0a6W5gHhZekQGUkj2KtFVHIwAKJs7vTZTjACnCswCKZUkdOlaT+U8Kn65HTYQi3GTZh+LN8Q8rXrJy3FNwXTUc7IScOWK48LfsKBEz/7WD2F+wx3K039o0OPS0nJ0j03wDO/VQVw0fueWSUewsBzpZXS2JQ3+CjbjqrEhkGdX/AU7qJ33O7XjFEZ2gWAZlN1+NqQ27dDC4X7ossXFsjQp7B0qzP8PDDHqkMd47KwJMzGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yUhGc2kEDGTvSg5ksdXnHj6g26KYzutBixjVJg9V0k=;
 b=aPTa/A01UV++A+iI8wwseRgnhvgYBzZzzM4MUVWuEJf1KkHkWSJEFiwVcmftHp6ks24pEPUnelUROokmtBYqKEZYgG2qwOl4SEuPI/a1/Vo+MC6AFeBzvaAhQaGaYC8O/8sJrzPBWBX3A+P2DTm5CL6HGJs/b/q+FazXutI0f2c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from BL0PR05MB5409.namprd05.prod.outlook.com (2603:10b6:208:6e::17)
 by MN2PR05MB6368.namprd05.prod.outlook.com (2603:10b6:208:e2::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 14:04:54 +0000
Received: from BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::f634:136a:e2b9:a729]) by BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::f634:136a:e2b9:a729%4]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 14:04:54 +0000
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
        vsirnapalli@vmware.com, akaher@vmware.com, tkundu@vmware.com,
        keerthanak@vmware.com
Subject: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is enabled
Date:   Wed, 22 Mar 2023 19:34:40 +0530
Message-Id: <1679493880-26421-1-git-send-email-kashwindayan@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0096.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::37) To BL0PR05MB5409.namprd05.prod.outlook.com
 (2603:10b6:208:6e::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR05MB5409:EE_|MN2PR05MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: 2889f2b8-967b-42a7-7bd2-08db2ade690c
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0qJVg/jLqWedrKD/yVwCnpjHPOJbhDowTV26NpegHRYRS9rtT3hGqOWgUgBlL+GRuRjiQ9HYnq7+5I4wUbLkGDagvO3xV0An9SismnbDdaZL5GPOZ1NfHGiqLaezsEJBG6iRyR8uIBHPEIEWWDDtn7R4ZgnYBG9tRKDqfF34gxp7Q6dBnDPdtwbtR3qzdLblob41VN73a2t6QiuX6JopassDiWiJvG4wgye2bCu2rP+tauIajaDUqc9P+RoMDz+6cCaYYZpyqOjbF3Z1a/5GgHt08YiAK1QopvnWI7uPJbE/d4rtykTPbAghAyxAL20A2ANK5WAjbVnF5TGH9byLmzTozWIRqF4lTctxs4JFoI1utPlVGrsvEnjrq/ML5pxt8bCh+2jq0QZLu++MX+Lj/6qxYDnKXCxAVG1wzYEkPHuAe5w0genjQGcLpgNkUBXuMkewdix7wf0PipumfdxLZzJfzNt70RlBaPviMli9e6yfDkDhr7QQ7um+c5IX/QcUUEPOlod1KX8eYF/MRh3oaXECF0j/A+lZkARedL1FJjwGlzM68HZc7G4/CxEX7PxgAKsMHJ0vkMn36Nlm3cOply46vYNi8uLK9Fhaqr99r4xQID8jDHx9ntA7GlgEro395yXGDpvpQdvtD1ZKO1HfEgmZGtQEoWCTZjs9EED2eLlCIE4BASC+XrpojR/I9SI/wf6g9gXBZ/QDJ2GKiDdsjvaH225Qb97fXd+UmcFv8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB5409.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199018)(5660300002)(8936002)(7416002)(41300700001)(921005)(86362001)(38100700002)(38350700002)(2906002)(36756003)(83380400001)(6512007)(26005)(478600001)(186003)(6666004)(6506007)(4326008)(6486002)(107886003)(52116002)(66556008)(66476007)(66946007)(2616005)(316002)(110136005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XaMaf8SUf4u4iGUKBGg8khHOtgr812EB6+eKRH0c/5GjKQMIXbw16PBEDigG?=
 =?us-ascii?Q?pAERVqgEm2GC1qZak5HVn/s+k9OJ6oda9kFy2ryKs2j0PTQmZ4yGuAQF7q9Z?=
 =?us-ascii?Q?vpU29B3L2Zg0KEV4E8uSNOKBMivsmdIUg8QDmsKuTsPE8nMAAzzwmSfFJdze?=
 =?us-ascii?Q?lsOtLvb9tpg6urvCTMdi1iapXJMsNh6qU78IOskctJp9YIyIiGYxSrW8W3zH?=
 =?us-ascii?Q?gFm3cK8WoVOFDwY51RVJZRQoKubI57v8Cx5LKw2TlnBc+PFZXbeLsaU7s3vn?=
 =?us-ascii?Q?1vGV+vAKPT7ESv0U0q+OGgLRIKoWdBw4mtU31LvXbePP05s+bO3G6QrmqKiu?=
 =?us-ascii?Q?oq8gNz0xSl3q95DztvH4zCAJa/faRfA2MagjgU2jKB9kQKDV8lUS+febRAhf?=
 =?us-ascii?Q?9Bw/e/f2c1Rcf7VshJP8Ef7ghO2eTt/H9LDVFjiM+zVlL6kpk/1Y+R5BwEFh?=
 =?us-ascii?Q?MN4BOiCcpLBXRzLEKqobpEJEbByoeVAeax04iwy4AXDo4PrbeYKjLT4u7utg?=
 =?us-ascii?Q?FPDsiyPmC05l5E7eNV55/XrAwY3LXwgi1UomTOrpTTez1YXdEtb68EXXA51l?=
 =?us-ascii?Q?TwhSNKYkJ8BcoHWNw5vVpNnnSqLHNU+IE2EVKDI4VNVWBXKZHyZCv7hl2l++?=
 =?us-ascii?Q?Gfp/2tTQp/DKjP7KTVpn8scTUuGcL+Te9vPoU/1iIwipNQMI2M2qKX6EUuJY?=
 =?us-ascii?Q?O3DK/eA9Cwmur93D7aj8YQp/vC2ZbVhCU5wtZojtY1Ki9ZaiLScu/uCyQ1tF?=
 =?us-ascii?Q?SAqw55Qo7Rl4MsyrJxpMsRwtv4YQosxmMfUzyiBHwvBlU6b4t/vc07A1Vqsg?=
 =?us-ascii?Q?WnpniZE/aKtzYNxpIbGXwhVNLGpnO5S7K24lgAnOn/7esSkwriTwlGb7l1Og?=
 =?us-ascii?Q?3PbhP5fyzBG/SJQnz0ETSzIQJfXIY79xmnyuiB2nX4MCRAmf2M1aMbXcpE3Z?=
 =?us-ascii?Q?MFXA+/hIzeuFkzKuSqJ8Qv9x3eXPACemJSWJVaAMCyGwqQihEVH9hTLJuw6S?=
 =?us-ascii?Q?baGeFFkQh4sa6dRO5JNMEwcTTn2pLO5enkZAWMjl8sEpQpg+mXT+ZzFCYxbd?=
 =?us-ascii?Q?DQ4TmfFEQNSTRbHLWa+QDcpXMjc6iG2DiUW8t7jGRCMnr99DxXqlzNvviVsn?=
 =?us-ascii?Q?Kd+/WKB0c9DH1RQYaDO4koNwwFkSKw0bmp8JmO2o6sbv3/8t5kO6sAmLGpEd?=
 =?us-ascii?Q?cYKmoca99LpKeQVXvLVIxOh1Ynz7GuLO5EYsYYq+QQqWnwR3yfUOKziXRNav?=
 =?us-ascii?Q?uPnmUArnCI4qGccj/GpmCRQm/dspSca29HvtAx6hfA7K1ZeME8ocbf/3Ur8H?=
 =?us-ascii?Q?EnMhlERCu7gB+sfOtrvhv7HAIrQadNgLn5rKBxLQPri4C6vCdmt5D0AG1I9K?=
 =?us-ascii?Q?uqSdt/RG66qdNPyQBSgHCEsVjKH0xbYX3p9IHteFXAMEIOxAeZlUduPhUo65?=
 =?us-ascii?Q?g3F91p+Dy35egnd9EOYO7iJwVK330aqadVohFmZsmFoWm9RlKOweckeueYfK?=
 =?us-ascii?Q?Bj5U7npl5Nr8TIV2rFzSE8D5pVq8m6+UuUhokKHE28pRDx8sk8rhmKMfGf/c?=
 =?us-ascii?Q?huUAUFQzuKAPi3HkPutIRAKWvS6NmdCOGEsHMRTjmvN1WXe5cZFLVn7iB3XO?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2889f2b8-967b-42a7-7bd2-08db2ade690c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB5409.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 14:04:53.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqSKfsPxsB2QqY8kD5HH+A6RCLX2t/PnMYpqGQoe/pTSN8rv4Fzomx4vF9fDfhR0ZAr/s/NWAx5UpgfVz9CbkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6368
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MD5 is not FIPS compliant. But still md5 was used as the default
algorithm for sctp if fips was enabled.
Due to this, listen() system call in ltp tests was failing for sctp
in fips environment, with below error message.

[ 6397.892677] sctp: failed to load transform for md5: -2

Fix is to not assign md5 as default algorithm for sctp
if fips_enabled is true. Instead make sha1 as default algorithm.

Fixes: ltp testcase failure "cve-2018-5803 sctp_big_chunk"
Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
---
v2:
the listener can still fail if fips mode is enabled after
that the netns is initialized. So taking action in sctp_listen_start()
and buming a ratelimited notice the selected hmac is changed due to fips.
---
 net/sctp/socket.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b91616f819de..a1107f42869e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -49,6 +49,7 @@
 #include <linux/poll.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/fips.h>
 #include <linux/file.h>
 #include <linux/compat.h>
 #include <linux/rhashtable.h>
@@ -8496,6 +8497,15 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	struct crypto_shash *tfm = NULL;
 	char alg[32];
 
+	if (fips_enabled && !strcmp(sp->sctp_hmac_alg, "md5")) {
+#if (IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1))
+		sp->sctp_hmac_alg = "sha1";
+#else
+		sp->sctp_hmac_alg = NULL;
+#endif
+		net_info_ratelimited("changing the hmac algorithm, as md5 is not supported when fips is enabled");
+	}
+
 	/* Allocate HMAC for generating cookie. */
 	if (!sp->hmac && sp->sctp_hmac_alg) {
 		sprintf(alg, "hmac(%s)", sp->sctp_hmac_alg);
-- 
2.39.0

