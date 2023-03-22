Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B226C4DDC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjCVOex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjCVOei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:34:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE8765C63
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdbTpCtPO5qLvWCSjsva2EF/PMRGkdH2DLMQ7MgCIs41mUtkIt2FRflqeFZ4YicTV9Iv5CyMBuIRIM4uysBXeh1s8ZLGGISt4HYR+zTsKgEEtcW5wNI3pPvo9zI+IvvlNnNmF30p1tL/02FlWxUkFh9xPqVust7ujAz/pRuLpul7Ox0Z879oYJkEarBeUOXxnIJeo3vwVLfByaVrV6ayuxqc2k8QAqed4LNmbDG26Dx6otAb9ILIP3HLR17PODdqiTRz+4NuSXFZlNyGQKGUGlnyyd6HOJ7lB+QrzjIHcC53LBRbPmHZoWrY76S13msxDLn1/ky7o7eodlqW+Tet8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QRbm74Ug5U+Jqdf9K7nQjf3jYDEx91657kKVe+BAvI=;
 b=JQN4dtbsaEVMFfqAXzqY8mCcGG1ccQa3F09dD14IditcPnDVUJyS7edRpFe9SoxpWMszvNDs+HC/+tx/l0OZ4ZVV9QUWvCrVwK9o+XYrXXmN1CJQHWhRh2i2X5kSo9G50NQ/PQVvCRNeZiVgcMBh35pIU3IJ6l06FH4aRhq1gM4An/XCKImZYRCIKqs4JtdmPOrXkNe0N5F/tR9K4BXFN82hllbRyLmrFRFy0/24rP0BTvSJqjrLWNtDsMoqwAMPGzBV8uQFeQyHzqWSGIqTz/GDy8ljP707zj2cOPNOIuABc5bWnyu6gZXxArlFoyOtQQKjj4RKPRB1LPlYf9KUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QRbm74Ug5U+Jqdf9K7nQjf3jYDEx91657kKVe+BAvI=;
 b=DnwWpNT88wzSoKqZ3fTsZR2IUgvMuvBo/29ZExT8CxGa2DVHRFgPmh8sYRsCfQkQxtQOruU5kxGvFz97zeNsBEO0uDJZ9vqpQfKIPyW3Vr4Alb3LBjkV1sZhUcKk8z6qr4bJ3Pg1htOaSliK/TgS6DCazoOCqySZEVQOm2Xkg2w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5932.namprd13.prod.outlook.com (2603:10b6:8:52::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Wed, 22 Mar 2023 14:33:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 14:33:58 +0000
Date:   Wed, 22 Mar 2023 15:33:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: ethernet: mtk_eth_soc: fix flow block
 refcounting
Message-ID: <ZBsR0C/3+0ZsWnhf@corigine.com>
References: <20230321133719.49652-1-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321133719.49652-1-nbd@nbd.name>
X-ClientProxiedBy: AM0PR04CA0058.eurprd04.prod.outlook.com
 (2603:10a6:208:1::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5932:EE_
X-MS-Office365-Filtering-Correlation-Id: eb18955b-e0d6-4fe2-6d37-08db2ae278c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMlqGHWSw+VvQ3EBVcC/mPldUMXHactcd/bs5jHXFfRHdhN1Ga6Pi1RW5zxtOBGI9lmeLd8W5fct6CblgImUKy9nCte3n4ywkV7ZmHxTckPF4MhFUD4UU85c9JNR/OnwlVhRqoLa3R3rKkiaCNCJHVJgasXq7CqPVnchYslisjTGJkH5IsHUkEE4s5vcWw729NwWODIFa0gNYEM+7j9WROImftJv8RpJawZxUU64EooST7Lp6u8zn6QZwa7OmuYRUVUf+CLmtJY0ULhw8VCetmQgPOw/29gabNcCXeiw3lYG2C589jKexwbE6RrBlKWnH71X06KrlEx2xhjre3VJSdtkLiYUVFx6XQHb5rUlkYd8FomuVfocUyu1jZdDe3Yf0QkGCV+r1PNEeiUHBAnMmwj3Z1bHdHZrohGa1ZmRQxQz1F353M3NP7/1PWK/1ZsRdH9Pgv6IRd/O/+GU2i2HnONNvryfW4JJ6pf1MdxOG7BjrOZcQM7OMWw8qpkFgKhtFyEpqq3HqPJfpPaUL0y3AYYomwQ0urjWRD/eXhqKr20PRShQfFpKuCnFwfr040Wp98eiixPRY0HRhco1r2k2Etlm+sTVIbBb7y6bo8Q1DdavSdjB0PYqlecNLbt+M0blGQ16U9rRBCcvxBjwIAwQQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(376002)(396003)(366004)(136003)(451199018)(2616005)(186003)(6506007)(6666004)(6486002)(83380400001)(66476007)(4326008)(66556008)(8676002)(6512007)(66946007)(478600001)(316002)(5660300002)(44832011)(41300700001)(8936002)(2906002)(38100700002)(6916009)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4FDor3SX6WEmZFyzyoVP0AEle61JYf/pmkXeUdgWqH/TD/TToNa4tWqXtRcA?=
 =?us-ascii?Q?PBBIhvldbVCDg3Bz491Ix0FTxFyYia8XZOOUCBqweuU+XxLTiymGT4MnJcUI?=
 =?us-ascii?Q?cuROjoydb/1X/OY82Vw1er2TInbAFO0Mg2S7LuX1uikronLHO+GWSmyNBmgl?=
 =?us-ascii?Q?iIDLYcv6aJz3hHIS4Nre3RA3tbZMjUV13PK5Z7ceRibC5XVSQwSlfGGiocTn?=
 =?us-ascii?Q?qmZhd8L0I0fHcP/xOte7jsJzoAKX5G8ROhOF+H9gicpYg6+gEKQFlS+1Qmoh?=
 =?us-ascii?Q?m81uA6GJLXV2AysBU75l1dOJYGYIUHquqFFGBPKF/ebOalchWSusLQZnsipm?=
 =?us-ascii?Q?nuzv/uzUgXA8rhZgEDg6j8ZiYrs/4eVQiMvg0Kv/cXDUjzxPzJ5uYa4yJ6VD?=
 =?us-ascii?Q?/wvROxe07R04zufF2SQDAqSClKFw3BvVYS4YwCULKBPqwkBPYRQJ29K38fbM?=
 =?us-ascii?Q?1xsbM/rJPABB/1+7jPzS89XZftE8IAo/V/rxHJ7E1U+Bx7L0iEfq3FJHkUkQ?=
 =?us-ascii?Q?8fCliNlDUctaDqdaOabGTmI0HYtR+tRlIhXtSaXnJvZKpY3nMX8CJNIjG+63?=
 =?us-ascii?Q?CGLRC+x7yQJsDP+9XWgJXsrKq3W1q/Z3HkbIsMeZguQhk26VH2sPIWG5SGqy?=
 =?us-ascii?Q?jUEbtKULOKQVdlH06XJikZ6tcSx48efXF23H4Y7X4OrwvwguIjYpN0iW95Az?=
 =?us-ascii?Q?zwbPoE2d6VN8RWoxdxFqPQMShFbF3qOSEiEUaxxpfELD7sCQ8ym4oWoVQbI1?=
 =?us-ascii?Q?nEiKrpji7EoCPfRG9GC5yiZWPgjfAWQ827JuZoI3ZHG+mDszmQ89Y18SwbTU?=
 =?us-ascii?Q?oXt9IVq89dIJFrIGhO4fL61cg3FYdO+iiyxtcZNklrgemkrNv03liqhKibxu?=
 =?us-ascii?Q?PBT9t8X0eUBhdoFqZxHLD36q75lZnVVuVT3RGgD224VxsK001JTG+Ob+7OOR?=
 =?us-ascii?Q?VJyJ8ATW+uAoHcb5Ra4uhOWGnLr+HNmvVOTMgRB7l1zd4V3l6HUnrN3KPb/Z?=
 =?us-ascii?Q?PaCbAiOdz2/zid9mHtkC1p6dlOu111GxMOCw7MlHSulR2IRKtWTKZ7I+QAzY?=
 =?us-ascii?Q?In4zMTTwEOWkPce+NwTvswuMReRpOph9eNVVCMMttEZD24igPd5DKlvX8XUy?=
 =?us-ascii?Q?tn8AML34x1RbURSx61MZPzfuSwn9cyrnJhB/AYeC6iRsM6Uh2tmbZKfZ09oC?=
 =?us-ascii?Q?YT6jvHq5vf3NzJsYNJNfEvcnTQXFgl4PyTf7DrwXJFQvGDUZJWnosaTdOaE3?=
 =?us-ascii?Q?1/kWJiQ+bmhRB7f/0GaDlSewpPFdvvFH/6+BDfjhnbY3ollUVMUC0kjJLl/s?=
 =?us-ascii?Q?qk6afniPPu6RWcYmB2vZFk6kBCfLfFGRmZBeA5U9YVA6z76Q77Ec1xkWfurh?=
 =?us-ascii?Q?7lck51DVy1n6A3727KV47uZXUIB3diGSDUdjVcoCmYiHpeMJwetLb1bqMDZd?=
 =?us-ascii?Q?MS4W7ROhqv75afcgKmfbc+apHwh77StjUo1TTS1Elps3S1ZCscNeHHqqHImd?=
 =?us-ascii?Q?aDE6TnY7kSzjIsojhisr+/yHdKJeCG+NJ6kIwZF44jx7461+nn+a3pqEqK9U?=
 =?us-ascii?Q?Qun6EGOtCs0HNE3XpCqA7SOOFb6w2Ey1SAAk1ikf6a6bx7x89G2fQ0lo0ZCn?=
 =?us-ascii?Q?yuzxI3AYS/xLo11y8c/f0Qq/qpCEINJy+tDBqLXaFbRRIg2Qw5bp2UeFYvLx?=
 =?us-ascii?Q?3/CWqw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb18955b-e0d6-4fe2-6d37-08db2ae278c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 14:33:58.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRypFvmHj7Gvwkc5YlyD8+Lm8UaBemzhUgYivqHEIITXhy0Cch60jwcncZlKRzWDpTR+aX5ukmpfC2osrHbznfWV1wX7rQiW5kKRdh4kjy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5932
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:37:18PM +0100, Felix Fietkau wrote:
> Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we need to call
> flow_block_cb_incref unconditionally, even for a newly allocated cb.
> Fixes a use-after-free bug. Also fix the accidentally inverted refcount
> check on unbind.

Hi Felix,

my 2c worth.

Firstly, it's usually best to have one fix per patch.

Second, this seems to conflicts with:

  [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for
        offloading flows from wlan devices

So I guess that series will need to be rebased on this one at some point.

> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   | 23 +++++++++++--------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> index 81afd5ee3fbf..43cc510b51bd 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -554,6 +554,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
>  	struct mtk_eth *eth = mac->hw;
>  	static LIST_HEAD(block_cb_list);
>  	struct flow_block_cb *block_cb;
> +	bool register_block = false;
>  	flow_setup_cb_t *cb;
>  
>  	if (!eth->soc->offload_version)
> @@ -568,23 +569,27 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
>  	switch (f->command) {
>  	case FLOW_BLOCK_BIND:
>  		block_cb = flow_block_cb_lookup(f->block, cb, dev);
> -		if (block_cb) {
> -			flow_block_cb_incref(block_cb);
> -			return 0;
> +		if (!block_cb) {
> +			block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
> +			if (IS_ERR(block_cb))
> +				return PTR_ERR(block_cb);
> +
> +			register_block = true;
>  		}
> -		block_cb = flow_block_cb_alloc(cb, dev, dev, NULL);
> -		if (IS_ERR(block_cb))
> -			return PTR_ERR(block_cb);
>  
> -		flow_block_cb_add(block_cb, f);
> -		list_add_tail(&block_cb->driver_list, &block_cb_list);
> +		flow_block_cb_incref(block_cb);
> +
> +		if (register_block) {
> +			flow_block_cb_add(block_cb, f);
> +			list_add_tail(&block_cb->driver_list, &block_cb_list);
> +		}
>  		return 0;

I think the existing code was more idiomatic, and could
be maintained by simply adding a call to flow_block_cb_incref()
before the call to flow_block_cb_add().

@@ -576,6 +576,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
+		flow_block_cb_incref(block_cb);
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &block_cb_list);
 		return 0;

>  	case FLOW_BLOCK_UNBIND:
>  		block_cb = flow_block_cb_lookup(f->block, cb, dev);
>  		if (!block_cb)
>  			return -ENOENT;
>  
> -		if (flow_block_cb_decref(block_cb)) {
> +		if (!flow_block_cb_decref(block_cb)) {
>  			flow_block_cb_remove(block_cb, f);
>  			list_del(&block_cb->driver_list);
>  		}
> -- 
> 2.39.0
> 
