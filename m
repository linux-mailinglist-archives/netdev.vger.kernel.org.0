Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA750520F0A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbiEJHxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbiEJHxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:53:09 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2139.outbound.protection.outlook.com [40.107.236.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51893219C1E
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:49:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvDP009jiOo8fhQJ5/1VXH9VJI1EvbY4b5/gRUXhlr7yT3nms8DaZiM0xZR3bvVZOa0crS+tZlHmRVFysgyNNozR0fWLxlhliFveyxJmpQZ2DU4HO7dy2n6VWLcdGtxlJy1zMGaBfSxI6jmZY6T2UQERo72gyxVGZiU5pzj7/KU7rRgOwONrEE/pcOOfYEBZyoAMH6mdXEBuzlgKgWJ5KUcmosQ9tTKDytm+mJ0knDMox0D918S76TgegkzOlrucAF/W9zum5sil+c+Dxl1kX8/YFST8bc4y/Q1qhHDo253dI+WXCBSknI365CuqVrfscUz2YaYtWxWspd0kup8QPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYJRSXf8AyxGRUAw1SkXbBYJbwgFFjUY0BgxZ4at3Ko=;
 b=OEw1ZJxC88QS50PUegwfjXJ1cXNNOyc4j3ZJ9BQDcVpxjJKDjDPrbCaRETPz9akT3N5UIl09HeQr4vrQ2R3l0ZpDzMCtS7ynhGmHc7KbdM8AYTfWtrk/LUU8aVN/1saoJDYGsMu9n9b4XaCUpMe3HFb1EUACxaI2KAtWJT/CYuebEDeSOfrqHdYgTfWE1AWS3zl4gGHIsXYGC8I1HWM91wT1Xd0x9DNdjJ2cn0GEqWu5wqx90kWS0mNFxACZPKEuapYq6ySm4NCC6Nl8BM3j5ZUo42zjJ0JYQJ/s7WZyweTrmoAkH4WRzXgOT03l/qRGlK2K1Ve1DHvMY4zYz/fq2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYJRSXf8AyxGRUAw1SkXbBYJbwgFFjUY0BgxZ4at3Ko=;
 b=sUdxPRSQUPhLadEH7iXKBd7CPCKlk2mWngLE8r1kD0deyiDbg2WUGPihFOJ3RsoO6GzmCt589fKmYmBwR7J5w8i55REUFo+5GvDtxYwjHDMHgQb9h/lpSGitNP/AyJ+0LEUAGBrhyZy4Ggb3Vh0mxlHeh0XOjfrNiiY85dPJp3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB2605.namprd13.prod.outlook.com (2603:10b6:208:f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Tue, 10 May
 2022 07:49:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5250.012; Tue, 10 May 2022
 07:49:04 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        kernel test robot <lkp@intel.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: fix 'variable 'flow6' set but not used'
Date:   Tue, 10 May 2022 09:48:45 +0200
Message-Id: <20220510074845.41457-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0032.eurprd03.prod.outlook.com
 (2603:10a6:208:14::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bbe0283-12c0-4434-1942-08da32598dfa
X-MS-TrafficTypeDiagnostic: MN2PR13MB2605:EE_
X-Microsoft-Antispam-PRVS: <MN2PR13MB260564F2F03CF3083F1B9594E8C99@MN2PR13MB2605.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aU0T1v/I0rnJWRY1z2WfQ6Ou9+PNH/VjM2risDxipY97iDL+QFu06vyEdqhQaNqeNiYy/OzZH3FCS46DCH5YyFmerpeE1vS/BBlkMZY5gqzHk3zvmb7Umi921z2SSzoKsrp/i/7elfT6Kos7ZMzBROi+gLtnZUsj1AOiXkq296rnULDmfqF8GT7+uKh1a9w9fogqCyKwy+nDJ0oZIa5dvK4gvj/LYYpslw1tyyPLRFbJjBiS6IiBJze5JOyp2W75QeoERT1iuk1sglKCRmVkUndUTqpeDdPaqaV0KDOzs9a9tDhRxh68YhA3NiWrpj7b/TMeqBeW1MS9ejvsdXuyV9wPCdETDI4A8qqPRgOuQvexstDADgD6P4qu52kZRiDHke0iufLw781HNYeVNZ/sLXQujuMGBhhcFAr4/M1fyHfSeM3+5/FK15ghGDWzXZPYY3xTkY1M0JrIc0Bh5CG/HyI4YT5QbbADFPIdl0aq65RN4HjBO7zgC5xd3SWLieguit92j/QC4e/Pdd8VHq+NvbQDp7qag201iDrhCMRfw+xmmU8aTgwp3XcfZR9t5IwCnVN2giGDjOCvlt0LuSWUBCLF2eVSg1UGcdj55tB/AuDQeLL/KyDMPRs2XBzkZqfesINrwIG3fS8w50nll8+00g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(396003)(346002)(376002)(39830400003)(36756003)(8936002)(2906002)(44832011)(5660300002)(66476007)(66556008)(66946007)(8676002)(4326008)(86362001)(107886003)(110136005)(38100700002)(6486002)(186003)(83380400001)(54906003)(2616005)(1076003)(6506007)(52116002)(316002)(6666004)(508600001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4svKP4+Vql3IWCQIHLj38cHMm6iNtmqiqG+Yclq7s1ufYdeRlJOQYksTdqVL?=
 =?us-ascii?Q?xBmXOrUwxgXnYt+fItHZEiKtDhunNz1kWih/LpgFwtFS/MmmaRFn5tvS3du1?=
 =?us-ascii?Q?DLLIize8Vrp1wXcNaCvJS8rEDtqf9BamVK5z6jZjoMYP3ZtZNoFfEuv6A0CI?=
 =?us-ascii?Q?9oeBpmTp5s8ckgNhAZ/8wklhx9fDPL2SXW0ZWY2RZZlf/kHQ2KGOLvchYiSj?=
 =?us-ascii?Q?+u8mjqeBofKfAdvDlm21Ru5xg0b66aDpxfZQRVn6jA5YwGcusxI0fWle3cLv?=
 =?us-ascii?Q?cWMPJAL8ZIhF0pVLbgqaIf7P69canvd1In7hTdhRj3EBp0Lq0IQl0Rv3YvVH?=
 =?us-ascii?Q?xTnq5fX+hntPzps+/kMp4nvAKZS8iVGKPip8ByBH0fi6SUU5hrMNHgFUT22Q?=
 =?us-ascii?Q?NWTfJI+LHUdOCfIUTcl0E7zTrkUksMFnOXPQOQ29TDr3qQeuc1wJh8Zb6Lqj?=
 =?us-ascii?Q?WSuSrQkb4GMcqo96W4d5DusHMA2/kj+/WF7iEZUdLEhnN4ldnn+OwSQJzlOU?=
 =?us-ascii?Q?FZdWpTfmbo9tTNeQRUW3+sG6K7Xb3NssLB5NLxciTpdoRam7SEwrE663tpY+?=
 =?us-ascii?Q?9cJbyFetp9rOAeydrHwKG08RED2jW7F76hdSYQTrWRH+0SGTJtoX70e5EB6z?=
 =?us-ascii?Q?WeJxez7gujUhH58PAnAn4pBK57dyL4Nt+UGTj4gAayKurmjTDPxxd5sVOX/B?=
 =?us-ascii?Q?OTqKafIxkaodaKtsNcLxPIKBQ2t6m6w4PEp3ZxyulAuc1+80QPUwb5ZQucQW?=
 =?us-ascii?Q?RtPFJMoJfP4YrVdqpqa+CxeLfXFltGoXZvwe+8y1KLRpcfJNQUsQIlcvmX1p?=
 =?us-ascii?Q?x1H4v6WHQWxmEZMqwmsHT9Aopesyxl5PFxeqnex62p8IQfG4F4CmXMmDE/EU?=
 =?us-ascii?Q?dylUyIU+kAby71plTMjQ9qeAJdgLemtbBF2Oasng4Wc4mTtoC8m407PmAOny?=
 =?us-ascii?Q?nAdyXYnL4etHKTAPpq4uLfuQAeoF+ZIYLwKBC8ZX4EXYwJKYprdriyLdHop4?=
 =?us-ascii?Q?cJfynD08VqIZIz3zcHKmx3nX1r6MvalS3n72QwgvRuL0lopgN8MFAkcoeCSD?=
 =?us-ascii?Q?ASNBFpRU2AvklD3Is1h9wS0Wfbz45RwYfgcFGjwU/lktZwR4Op/lnK4EsYZm?=
 =?us-ascii?Q?d9qFJ4WzCJCFnmHWpiga6ypV641m4bVv1no3FWHIhgZ8RUZurhzUHuhDQakd?=
 =?us-ascii?Q?8Pw2ieZfBfsLLNATLM4unAUXVgIYzJGTUlGiRm26z7i7SJ0FT6nAapl/X/m7?=
 =?us-ascii?Q?BEBFt+rnENJYrPC3yTC5YUZH2O0jZfRv4eVCh1pNASJ2AH2Ov/m6x1yfS8Jk?=
 =?us-ascii?Q?6bMn9eS6IzNaKLljMcrEj60wH2gV1zdWHwsq1NHYfyZJqNEYE3ej54sDcXJ6?=
 =?us-ascii?Q?ssKXXbpT4UQCdqC4dN1ag52Uox25B9QnY1Smd+l69H7mz7NV11l+CplfnFEO?=
 =?us-ascii?Q?l6yHCTp4b1u/iKCuSZPFcwJQ7eD4SZmGBR6Xze+CVvE7mQx7oAu7AQI44ati?=
 =?us-ascii?Q?GOBw23Tf0SVRtdL+/wsHHmml3nI1J0aJfMrB1n/8RY61p9vVqkwP3/HJnbmC?=
 =?us-ascii?Q?phlGDDVXw3tZ9CDq0hgmzzGEA5fGmAobfUC8TBIMMOWHUHeTjl2c8g1cMCVT?=
 =?us-ascii?Q?pyyEdbtjJRcgrUiY97ev62fn2b5CNZXAdh9J0cr1n56uMaClqUKcH+0Ab8Ig?=
 =?us-ascii?Q?MoTGIRNlyPEwBnLlUzuqbt3G/lgBEeJ6mGpun0BZRKkxkzeNSPOGHmyYb0Xa?=
 =?us-ascii?Q?p7IzCaI0XW6t1StUy0WS1cb+QJa7a3UfhrY7zAeHxw8Kv/IjVmMXfkn7NOY4?=
X-MS-Exchange-AntiSpam-MessageData-1: RdwyHPV5TlSNnhE3SqmgLhP4LjLS4WprPAc=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbe0283-12c0-4434-1942-08da32598dfa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 07:49:04.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imNcDjw3SC+Fs1IlePKpehi8gAlkWlCBpNTzzv2wLVWKky9+DlW2a4m31su6AU26uYlorTMQ0gLsFSk9tcoRYLhSqrMRwtOq4v5Q6VZu8PE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB2605
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Kernel test robot reported an issue after a recent patch about an
unused variable when CONFIG_IPV6 is disabled. Move the variable
declaration to be inside the #ifdef, and do a bit more cleanup. There
is no need to use a temporary ipv6 bool value, it is just checked once,
remove the extra variable and just do the check directly.

Fixes: 9d5447ed44b5 ("nfp: flower: fixup ipv6/ipv4 route lookup for neigh events")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../netronome/nfp/flower/tunnel_conf.c        | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 9c37ed6943d0..6bf3ec448e7e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -563,12 +563,9 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 {
 	struct nfp_flower_priv *app_priv;
 	struct netevent_redirect *redir;
-	struct flowi4 flow4 = {};
-	struct flowi6 flow6 = {};
 	struct neighbour *n;
 	struct nfp_app *app;
 	bool neigh_invalid;
-	bool ipv6 = false;
 	int err;
 
 	switch (event) {
@@ -583,16 +580,8 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 	}
 
-	if (n->tbl->family == AF_INET6)
-		ipv6 = true;
-
 	neigh_invalid = !(n->nud_state & NUD_VALID) || n->dead;
 
-	if (ipv6)
-		flow6.daddr = *(struct in6_addr *)n->primary_key;
-	else
-		flow4.daddr = *(__be32 *)n->primary_key;
-
 	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
 	app = app_priv->app;
 
@@ -601,8 +590,11 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 
 #if IS_ENABLED(CONFIG_INET)
-	if (ipv6) {
+	if (n->tbl->family == AF_INET6) {
 #if IS_ENABLED(CONFIG_IPV6)
+		struct flowi6 flow6 = {};
+
+		flow6.daddr = *(struct in6_addr *)n->primary_key;
 		if (!neigh_invalid) {
 			struct dst_entry *dst;
 			/* Use ipv6_dst_lookup_flow to populate flow6->saddr
@@ -623,6 +615,9 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 		return NOTIFY_DONE;
 #endif /* CONFIG_IPV6 */
 	} else {
+		struct flowi4 flow4 = {};
+
+		flow4.daddr = *(__be32 *)n->primary_key;
 		if (!neigh_invalid) {
 			struct rtable *rt;
 			/* Use ip_route_output_key to populate flow4->saddr and
-- 
2.30.2

