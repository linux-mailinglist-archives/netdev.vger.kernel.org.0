Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5920469C246
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 21:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjBSUck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 15:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjBSUcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 15:32:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2125.outbound.protection.outlook.com [40.107.92.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF4214E8B;
        Sun, 19 Feb 2023 12:32:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1N55z2Qr9p5P1f3flMTj1b+TWtJQvzCWbZzKs8eRmP3vA/I0ll/xrJrKAFOyooa4vJ/pcUvjmAk0OL+Gn/U248RqGO1UW2WRe6xLj/KFmRR9/V4PolnHlT0BA8YCtR5SFanZ6ZjuD8qyjzBFV0ZNP8htlSuEvNIx+BHLIlVPm+Xka8cwWatpvuCWwbsUpR2t8BgWotdm9x1x6ccznPFlwjCccXfU6r42GCFLR8ep1mK/nTnl6scmhi6GFR6qiTRxFSSm2ipmyXThJcFM0Ke9urz6/55F7rGo/9Kx48RapntV5lLehKAssJ3NUVoYicX+EY+1ch6ukf6qZYLWEllEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5j2PIWwdtHMvStZBV9UuPeSbUnh0ulv0/rqh9Ln3tQ=;
 b=iE4Ja6fF225heGFC9C2ci6EM1vUN0TWDJujAHvYdjMd3x0kPui2nNyojKlGhrv7jVv+220elbu8Gda++thz8XrVHkFdc4zRyxqr1mGhFZKLVEkhnIXEu1IfAx+xPJ7yYK6ZXm07KXIskXcdWkB9X9B0vXRTLJyhkh4VlGCigyfmAuzl+ef2Y9JwC3OdglLo2P7zmDJNUJ3dhygHU7BTEaXOVS2Iv20+IWTYIW5bWNoQVVV2EN7h1DKswNSL5b6t2JKtnPT1HMJkNygWAYHHXGPlnt5lJ+ut0nnC4SbtIV9lNMSs3g+qn2nncoqS/yr3bjo5BFD7Ckq8/9OaWQNw42g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5j2PIWwdtHMvStZBV9UuPeSbUnh0ulv0/rqh9Ln3tQ=;
 b=f6yM6I81KClJPyfdbv+tiCCmvN7ej1yJ3U9qa4Ggq0QVlchsMx5SpiZxpNpOhsKaP7Yh40w1LiTNpraQKpSORkPuhhz6XKodaI00o5XX8BAHh3kL0VZChTyAYI027TWp7wbEZbfkZ6h6qaSO8GEuIc4EvR+WKOOdvkWdjhnfbvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4556.namprd13.prod.outlook.com (2603:10b6:610:35::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 20:32:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Sun, 19 Feb 2023
 20:32:36 +0000
Date:   Sun, 19 Feb 2023 21:32:27 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Message-ID: <Y/KHWxQWqyFbmi9Y@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-3-gavinl@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217033925.160195-3-gavinl@nvidia.com>
X-ClientProxiedBy: AM3PR05CA0140.eurprd05.prod.outlook.com
 (2603:10a6:207:3::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: 327af15a-f1d4-46f9-15f0-08db12b86f82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jLNMEkiBp3PZ19IxHQEqfcMsy81CkaDbvIEf2WpWf/FR3Q3dLwmyZXnzpN6lDRaLh+CMIrTRmqXhJzt15mVDO5umJ374wRZVdDaSCIO50Sl1s0rYSYhQwYSa38pP0D77gg1imKsdV4pCZgamDRbS5gdAqJfgSwWlBzu/mB7fTi/9O9kr10MmfinSWfT5vSlnGTju9gjokqDHD6LXovDGX9twnsMTsA45d3UoT7y+occ/97WtEEa2kCYNzeOQKYRQmo1xh6dWn5LElox5DwlBh+F11HMNWRW2VV1DMbIQYPVBypdZu06cK4X833pl+qPCcRUorCnABmN7JKlt909nrgIUQLe7+mBPmagAtSKztV7Rm9QIACFkjWXDAmGiXQBTrArjUNDp+hoaPh4mCkvHeQHUUM9nb6F72lzuMEUQSoHtEn5ZVpWZE6tcU17XSFwZdRpY/bTtxg8T/WGCQ4lWOgPYzRFMgRHXEANZDNePcB0XF4f13L+1S/ALXt1zDiFbVqUfHhu+mEkRaSlof2j1RynxCW+hEw7Em3nZ51DAJEIHAWB1qq/ViHHsObTFrxUDT9et9vnP9Tij14OfeuNjLJ0ZFWkNVI4qW5QWMlHUTbH2LPkoQ694feqHyJa67Q405yC7kYwr+wfeD61coEHm/0/vBr39ZGLQMm9DDy6iL6KY6cPnE8+ylRnlaUWHCL7Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(366004)(39830400003)(451199018)(44832011)(2906002)(83380400001)(38100700002)(86362001)(2616005)(66946007)(36756003)(316002)(41300700001)(8936002)(8676002)(4326008)(66476007)(5660300002)(7416002)(6916009)(6512007)(478600001)(6666004)(186003)(66556008)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zc1lwEGFY5jLM+LvY1na9wTNGKvJfNT25xrVLYUjvqoQBiXHnwcQAd2BeBFE?=
 =?us-ascii?Q?rKZ8N7jQell67HKlqudygPLUtLIXipxj1DUKfBK0NELv8E+wNTDtBJ13fiG3?=
 =?us-ascii?Q?+wpIoiOWjDE6F7ZLQGYudxZaWOAhqT0U9R0fMGbQZ4ZIZIZKLXLmsYt7eZfg?=
 =?us-ascii?Q?YQx+du3q8q4ejtRFaAfykQ89VWp5+6w7gpw0ylgQ/efVEGoVBiwsZHzCskNP?=
 =?us-ascii?Q?NQwiavQnSA0o5PNz93Xe6EkoH/SYJ8ngPW5TMf+lEMh6K/0xqWYaf5G2J7xB?=
 =?us-ascii?Q?bA38AOpK5kV6W/9lKfJEvez7A8V/sRfbE0VHQkYlNK2NTeDe56CWWvxkWQT/?=
 =?us-ascii?Q?Q3t1G8KJ4+dZzf92leXBMeu0OVGJAKgBATAcfJVtmtQFwKnAYNByS0X2LPOa?=
 =?us-ascii?Q?FetYKeTBDJJRPyt0LPN+VqGuFBUVBxO7cFuC4B+8eTeMaRI+rQBPOrni/9ij?=
 =?us-ascii?Q?pSZDs6OfGysz4ZxV0ldmzqvsYCUAR58C3pYw3YN8zsvGoXM1/4I8r2dHLNEt?=
 =?us-ascii?Q?fNodPXGrvFVdQ9++/S29ZpiDlljyd6e3cHN/IRaE+anUlKyzzaMi7mWk5WJv?=
 =?us-ascii?Q?TlbG7BDADUJ2BNjKyVpDFVVTcvVPsL8QBJ8ipEEEMf4nGJPiYYoi38yxnLzH?=
 =?us-ascii?Q?YfucNTtCeiESu6xpPRAWAv8fr1FDsK7HppK18ocliWaB8Oc0z9OgE+Zukvvh?=
 =?us-ascii?Q?h2yy750TfqQf/d3CkNePcYVjMweWKbwSbS9sWHwmSDXuWWl8jYE7c5ogG157?=
 =?us-ascii?Q?Kk3nZTLH1bmjjzLlp470KtFR2Kz9u8pi64olVu+exXVkhkcO7C4P4kcyIzLp?=
 =?us-ascii?Q?Y91r2ObHwr2GynnWZK9CxeusHZaThcAsJuwsT7gQBGp+jX9k/NL3U76oAmhe?=
 =?us-ascii?Q?GCnWfpnP6v/ALdYDCd7B7mygAr8ORlOHcA+4AADmExo8A8M/QGn0tyQS1QR7?=
 =?us-ascii?Q?txxpks/4TxnG+ccN13oKB1Ws2ax9RlCPtyRd58b0L2BuUdTK5egzaAKialNx?=
 =?us-ascii?Q?AquyQp1Nbus/R7sfTi35bqDyCvl47NM5PJYKS/svr5qWYD9wmQwFpl/EJNEj?=
 =?us-ascii?Q?yGMl+LgIdjjGkLKnPdEsd+6WkQzxhVtQDIWrftQGI96WsYDpARF3cCLCROU3?=
 =?us-ascii?Q?2NYF36S9ly+sveZz0yt8kwWkQBdHzDuLoM/tdeoj6I1oJNEOhYgZM8Cp5OZ+?=
 =?us-ascii?Q?WwZMremfLSIPxE9nzyhP6rTu1VO2f5r7wv4bLgL8//AVJJzt2xDQHr4nO/+g?=
 =?us-ascii?Q?TGxVj7BWhUKWHv7Y3mKzq/Yik0QejoOSrxiK9aG0I0JUylkhKzffXFm3F8a5?=
 =?us-ascii?Q?Ht+OJqftYUWW57GbkeHsWRw4GGgUhtF4F3WBUBvxx94CApkoJ2szVCW179PX?=
 =?us-ascii?Q?ZUISx3my21fpGPNpuyGTcrWqOJWGerrKe29BRVaC4yS6TFQiNDYCNn7LbXjy?=
 =?us-ascii?Q?gYnDspzNEisNCI38GY6Jf1zHDWDJljVDF8Nz06b2sib9CljGh6fHrrQYAqce?=
 =?us-ascii?Q?ziGMhl4l0jKvofkRP4mGu0c86d29CJ8XR5TgvqA/DkbebbU/BqNCICuC0heM?=
 =?us-ascii?Q?hPLd+XV49oe85mtIXSgSL9QvOB28Z2L69igYoNvXdBaaCnv6wbWKJEjwxQsY?=
 =?us-ascii?Q?f8gbSaYD3a8M+wRWgrhFnJN0bCz0R78PHIKR7J5YJC3JOUKmcHSOlWZ+1oYR?=
 =?us-ascii?Q?4lWriw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327af15a-f1d4-46f9-15f0-08db12b86f82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 20:32:35.9928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tg/i/lpQ+CFTmYx1DzLZzA7Mj6qcXO+Y6Jzjg+TL5uXfGs6en3wBSeGo6F9yjW0zOhzdfR3KzgrCS/Ci4g5XpmUTigcWSuiFxs5sVl25v6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4556
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:39:22AM +0200, Gavin Li wrote:
> vxlan_build_gbp_hdr will be used by other modules to build gbp option in
> vxlan header according to gbp flags.
> 
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>

I do wonder if this needs to be a static inline function.
But nonetheless,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/vxlan/vxlan_core.c | 19 -------------------
>  include/net/vxlan.h            | 19 +++++++++++++++++++
>  2 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index 86967277ab97..13faab36b3e1 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2140,25 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
>  	return false;
>  }
>  
> -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
> -{
> -	struct vxlanhdr_gbp *gbp;
> -
> -	if (!md->gbp)
> -		return;
> -
> -	gbp = (struct vxlanhdr_gbp *)vxh;
> -	vxh->vx_flags |= VXLAN_HF_GBP;
> -
> -	if (md->gbp & VXLAN_GBP_DONT_LEARN)
> -		gbp->dont_learn = 1;
> -
> -	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
> -		gbp->policy_applied = 1;
> -
> -	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
> -}
> -
>  static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
>  {
>  	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index bca5b01af247..b6d419fa7ab1 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -566,4 +566,23 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
>  	return true;
>  }
>  
> +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct vxlan_metadata *md)
> +{
> +	struct vxlanhdr_gbp *gbp;
> +
> +	if (!md->gbp)
> +		return;
> +
> +	gbp = (struct vxlanhdr_gbp *)vxh;
> +	vxh->vx_flags |= VXLAN_HF_GBP;
> +
> +	if (md->gbp & VXLAN_GBP_DONT_LEARN)
> +		gbp->dont_learn = 1;
> +
> +	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
> +		gbp->policy_applied = 1;
> +
> +	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
> +}
> +
>  #endif
> -- 
> 2.31.1
> 
