Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BC76BF904
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 09:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCRIh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 04:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCRIh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 04:37:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2112.outbound.protection.outlook.com [40.107.244.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8794C5370A;
        Sat, 18 Mar 2023 01:37:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H09nDHZ2zc6WvmzB0wp2+Cgb62theqG1uliUzRd0q6uKhz+Vs/n//z2LlTcTYM/24IsUg3QCZc9Mhj95tGFvwkyRmhR3uTspN3yi31kAm7QiAc4+tKSUu2yrjNiC4essIEAuCBynjNW1sIFYf9mrEiyMNgPgJtbmw8jB7M4flS6dGJ5mybyGOpd6ECENkgu28mskZUo6A4ClCjB/niA3kdHfnxse385CUK1wpPbFlUcX3pfivTT7q/8mmVdzWBwBCscR/v6Iz2CxPLG0+xpZI37DcpIRYbmjzYNU8CnM8Iwno060Dp5i9HCSv/xcml1QiaYi6S2epC9QwlxIyN1VEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Rw/S28SXIUJJd8o7aeRVVEk+e+YJNoJezl+p/Pg7Qs=;
 b=NIPu1WObablpnysYaOw7VBsoXRB4mOs10E6CCuIOAl+Fi4F3cbWGLh/l+ENhiV3nVr93fn5h473VQV2w5MvezHsk2xSyFNXLxlAL/YSvw9tre4+kbKOppfuh0G+sYFmSl4aq+RMflrMfAl8Bb7MEG9+IZOMnqseFDE/jNYpivlZUYBadsOao6dC5kEbxHdZwFC5NryXMHo6FcyMyTvPtO4fZnyTv+8m4VADS39Uzwy/9s7Tsb6Zt0qWFiIzn4h6F8dZ7YfjkpVHFzI7u1rK6C1c/7QHTNbzar6tzR+5bL5pMo3T6VSZVjwur3UeAzrqAapv3g7N78OVKJ39t5VV+ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Rw/S28SXIUJJd8o7aeRVVEk+e+YJNoJezl+p/Pg7Qs=;
 b=cCDBjcadus4w/j3J0Ip2GNJ/WZgMZu01JB64KVMw9NeP3ZPhd9BQ0Mi7smaA+JLz6J36VCMxjycCrivEZIyAydIYcni+JtTAVZ65t/BPClOBaU+oNv959XUEkkUN+E/OqqT5BI1zvUzhq7rLSFr30FAV/HZ4MkjYx35KevsXrMQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4632.namprd13.prod.outlook.com (2603:10b6:408:116::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 08:37:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 08:37:19 +0000
Date:   Sat, 18 Mar 2023 09:37:01 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/9] net: sunhme: Just restart
 autonegotiation if we can't bring the link up
Message-ID: <ZBV4LSBOwEzSiAvA@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-2-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-2-seanga2@gmail.com>
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4632:EE_
X-MS-Office365-Filtering-Correlation-Id: cb0a4e3d-84b6-45ca-d8ee-08db278bfc47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m9XzZbF/FD+zFwryd6fVx1razRNveS35ftNGqXud2NQ2f4oFmykRSoh4zIcUFTbZzymrK3XcLS+Z+0+swDBcYJGRYpwU/+iN92WUHjH2Uj5j6F/PZCgYdkJ3oZVCD/LtLMAIiwH03XMOcVxbiGulBZqtGiPPbK2Qct68I613B1eVNjaD3HHmagKl48aJttKbd+b6qrWOrSWDFk0cQOYlrpLw8MuGi9vtxWRbayCYPNxe0BIMwe4xf5pC9xiBAUJmpnbHiI2ox1HU5IbTHPwWFQnoKsUuGO59zBY+SdlkBoWtIkK8teGmmh80PMrNvYKLqpoEGEGENC+D4Vb/wxhpJd1n3gw0mGuktcHUaLClmMu6XxUTNJc/qn0tlHt7rJjDdcDAJ5Xlm0zb5bZh/mH7CBCj0V3LKYhPqW6rwIxCYf0kONVxVKXnn1ZEUyH3uRcKjQpNZ/9XjnYNojLnYhBaUJzfgusFsQpoBuyzDQkNpEgs9Vi7+JAAt0fbVKi97CH7qBQpIxt8JoK39Ct72wnbfLsePPu9q3MUO4d4t9H61mu7+kqE+KI7OrIZzxgjdl5aV/I5CxVxQ5GP1OHnd4cpBQBpjm6DXM2PUPzhZrthNFjWnOKgR41uzY9Z0CzMjnHiXMsCrqZXdkZxIajls4AIHfWeVHQVze4kbbAWaXF7vSmGenWJPRHnnfabTvlXivD9sPrsT1Cor+l2oSUxu3RsMhVOANcjAjODT+qojzhE9UE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(396003)(136003)(39840400004)(451199018)(186003)(6666004)(478600001)(6486002)(83380400001)(6506007)(6512007)(54906003)(316002)(2616005)(66946007)(66476007)(66556008)(8676002)(4326008)(6916009)(8936002)(44832011)(5660300002)(41300700001)(38100700002)(2906002)(36756003)(86362001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A0AFVge41KP7Xh+XAIem9H99eEeIJYh4jqGOem2P4GvD7tQd9LEmAbOTJvTS?=
 =?us-ascii?Q?g0F/TJkMkVq5QBPKM5KEeYNersTMF1HHRrJ4ntkXXxcLqacSeW2UyfAjXFNQ?=
 =?us-ascii?Q?O+5u3dKAe6ggFYcj3n3h8Z1ihB+5gOXd286WasTIMSPrFIem+cBl8KFUqbA2?=
 =?us-ascii?Q?Rf9yQqdWc1/XSYvegIf7NkoFPC6nF/WO5gn9lXoodiyf50y3JgIN6Wl2dlID?=
 =?us-ascii?Q?3slAEpaeKuo+EMyZOU/pCGvQ/Ws7o+Ki3Amy/uAOoWkTuqGm06pWjLGzxTaw?=
 =?us-ascii?Q?/QBbmuev68kZ1iFzo9M9MOaDOLtXo+fJ8mZ4BQLsJAtIN72N9Xn6dxzaP20C?=
 =?us-ascii?Q?kHRGNTsCpMUGJdPiNQyyZY1QkBzIPJbJkL+WjCp/B+a/vXbqFyNrv1XX4leT?=
 =?us-ascii?Q?1J87hjmvHIUFskpoCUK6LEI1MGcE40kBfmEwWv9/hO5DA+tGKw7MUYe7Xf/L?=
 =?us-ascii?Q?0vFKvHTLVgPgpXYIsqUmVJwf45YUkjMIJjDTYw0ZErE44R/2v2TSvSgAEVZ5?=
 =?us-ascii?Q?dSUWJMzWH5eGL18mmA2qJtj1AOdwgmw3pJiADf2nuKX91oiKtSz1JoxigxvL?=
 =?us-ascii?Q?FVI2mopxJZZgRs+/yF2HxD4QeYWpQ3M+BoSP+Vh+zlYUWryLNL4JAn4ARJ+9?=
 =?us-ascii?Q?LZV+2cVWyTwQAJ6I7NB73X4vkmR+bCs5TFX/+he7kQpnJWB+416FMN981tiP?=
 =?us-ascii?Q?gZzfIcbUf5x/FoQRfxh10vvlSkgZ2HqTuQlTa2zijqqRNO/G7TCV0dX3/0UE?=
 =?us-ascii?Q?dDdTU+a7sFXgWPZP+ALIND7FOPB/lcqs/op06LPSoysZSDVFUM4S0iQVmFZ4?=
 =?us-ascii?Q?XuMHYC0vICRvF4sV5p7X8+gljdnUadpexHDbIPKtu34nGwPN3LmyHsHBPJga?=
 =?us-ascii?Q?pjLgqoOcneJJxq+6w2avVOGx6Qv1LOn85FWC/GG5T8PFib4cAF9rFKweJRh0?=
 =?us-ascii?Q?RMtkyv2I1imTwVuHmK7sIdj0RuRe0gkCr5unwcnVuDM8ekJyW69s/t15UWyo?=
 =?us-ascii?Q?4p7IF6GrRmZG8y+dg5zov8HBYprWDD7qrFA8l/vGPj9YTvur726GJkN3kldG?=
 =?us-ascii?Q?kkUTdVwGWfoFRQ9oYOarUcPZuQACDHfpq+R/YJFTXv67gx/lOSWnSTl0vq4x?=
 =?us-ascii?Q?KdToK+lflyOpHudY3nD4DGWwCtRSZvojSrl6FENyrHLJCZbytDonYcfb5tSF?=
 =?us-ascii?Q?qUW/EACxj+O8ha9aEIZYk7CoeUKkcIuRW7NwR1cqjU/FZYzcfcSI13YRj9mO?=
 =?us-ascii?Q?EnEOasjnzUEZke6phZQjOmD/1vqhkg9z1em3SKwyMsx1JWaFfcQ5plQQyYTW?=
 =?us-ascii?Q?Su6GJ7KrbyjeM3FX+vf/TG1+MnRKok2CDTxAvBDvB9KTjbbX5aPtKkT0zkEZ?=
 =?us-ascii?Q?c0wGCJkLEFGd5monrrCPGzCmrmx4cbVsBpqAGFzYvKfCUcMyCZ4r/wv27Ktm?=
 =?us-ascii?Q?5oo7qNZqf5HTdjkMwqlaSgv15j00ZbQzxmbpwF9t7RHCV83uo/qWEZQvFqDV?=
 =?us-ascii?Q?HXlbOORLsie0EAQTY5s50u+uLgBG5H9PhvGkfnixG/N1IZLdGLTs4CfkCxwx?=
 =?us-ascii?Q?TQnz54efiBrVytmWz6ic0an6e/eBO3+rLtRswajWzqb/c/lecEOSIPmr/TcL?=
 =?us-ascii?Q?snftqn3P7I9EidFdI5sfgJID2as+6HctIxIyizNLjw71kK2qBXOjtGBx5t6Z?=
 =?us-ascii?Q?ns+vIQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0a4e3d-84b6-45ca-d8ee-08db278bfc47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 08:37:19.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLXQUrJlSINE0UnTD+W7mddjl4wPpHr35+39PytDOGHwmSHNnvOwwgh+aIGs4xio6gvVawnZcrkWWqvZE2Sef3ls6tqSn4WWN2+SIZym6H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4632
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:05PM -0400, Sean Anderson wrote:
> If we've tried regular autonegotiation and forcing the link mode, just
> restart autonegotiation instead of reinitializing the whole NIC.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

...

> @@ -606,6 +604,124 @@ static int is_lucent_phy(struct happy_meal *hp)
>  	return ret;
>  }
>  
> +/* hp->happy_lock must be held */
> +static void
> +happy_meal_begin_auto_negotiation(struct happy_meal *hp,
> +				  void __iomem *tregs,
> +				  const struct ethtool_link_ksettings *ep)
> +{
> +	int timeout;
> +
> +	/* Read all of the registers we are interested in now. */
> +	hp->sw_bmsr      = happy_meal_tcvr_read(hp, tregs, MII_BMSR);
> +	hp->sw_bmcr      = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
> +	hp->sw_physid1   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID1);
> +	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
> +
> +	/* XXX Check BMSR_ANEGCAPABLE, should not be necessary though. */
> +
> +	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
> +	if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
> +		/* Advertise everything we can support. */
> +		if (hp->sw_bmsr & BMSR_10HALF)
> +			hp->sw_advertise |= (ADVERTISE_10HALF);
> +		else
> +			hp->sw_advertise &= ~(ADVERTISE_10HALF);
> +
> +		if (hp->sw_bmsr & BMSR_10FULL)
> +			hp->sw_advertise |= (ADVERTISE_10FULL);
> +		else
> +			hp->sw_advertise &= ~(ADVERTISE_10FULL);
> +		if (hp->sw_bmsr & BMSR_100HALF)
> +			hp->sw_advertise |= (ADVERTISE_100HALF);
> +		else
> +			hp->sw_advertise &= ~(ADVERTISE_100HALF);
> +		if (hp->sw_bmsr & BMSR_100FULL)
> +			hp->sw_advertise |= (ADVERTISE_100FULL);
> +		else
> +			hp->sw_advertise &= ~(ADVERTISE_100FULL);
> +		happy_meal_tcvr_write(hp, tregs, MII_ADVERTISE, hp->sw_advertise);
> +
> +		/* XXX Currently no Happy Meal cards I know off support 100BaseT4,
> +		 * XXX and this is because the DP83840 does not support it, changes
> +		 * XXX would need to be made to the tx/rx logic in the driver as well
> +		 * XXX so I completely skip checking for it in the BMSR for now.
> +		 */
> +
> +		ASD("Advertising [ %s%s%s%s]\n",
> +		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
> +		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
> +		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
> +		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : "");
> +
> +		/* Enable Auto-Negotiation, this is usually on already... */
> +		hp->sw_bmcr |= BMCR_ANENABLE;
> +		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
> +
> +		/* Restart it to make sure it is going. */
> +		hp->sw_bmcr |= BMCR_ANRESTART;
> +		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
> +
> +		/* BMCR_ANRESTART self clears when the process has begun. */
> +
> +		timeout = 64;  /* More than enough. */
> +		while (--timeout) {
> +			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
> +			if (!(hp->sw_bmcr & BMCR_ANRESTART))
> +				break; /* got it. */
> +			udelay(10);

nit: Checkpatch tells me that usleep_range() is preferred over udelay().
     Perhaps it would be worth looking into that for a follow-up patch.

> +		}
> +		if (!timeout) {
> +			netdev_err(hp->dev,
> +				   "Happy Meal would not start auto negotiation BMCR=0x%04x\n",
> +				   hp->sw_bmcr);
> +			netdev_notice(hp->dev,
> +				      "Performing force link detection.\n");
> +			goto force_link;
> +		} else {
> +			hp->timer_state = arbwait;
> +		}
> +	} else {
> +force_link:
> +		/* Force the link up, trying first a particular mode.
> +		 * Either we are here at the request of ethtool or
> +		 * because the Happy Meal would not start to autoneg.
> +		 */
> +
> +		/* Disable auto-negotiation in BMCR, enable the duplex and
> +		 * speed setting, init the timer state machine, and fire it off.
> +		 */
> +		if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
> +			hp->sw_bmcr = BMCR_SPEED100;
> +		} else {
> +			if (ep->base.speed == SPEED_100)
> +				hp->sw_bmcr = BMCR_SPEED100;
> +			else
> +				hp->sw_bmcr = 0;
> +			if (ep->base.duplex == DUPLEX_FULL)
> +				hp->sw_bmcr |= BMCR_FULLDPLX;
> +		}
> +		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
> +
> +		if (!is_lucent_phy(hp)) {
> +			/* OK, seems we need do disable the transceiver for the first
> +			 * tick to make sure we get an accurate link state at the
> +			 * second tick.
> +			 */
> +			hp->sw_csconfig = happy_meal_tcvr_read(hp, tregs,
> +							       DP83840_CSCONFIG);
> +			hp->sw_csconfig &= ~(CSCONFIG_TCVDISAB);
> +			happy_meal_tcvr_write(hp, tregs, DP83840_CSCONFIG,
> +					      hp->sw_csconfig);
> +		}
> +		hp->timer_state = ltrywait;
> +	}
> +
> +	hp->timer_ticks = 0;
> +	hp->happy_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */

nit: as a follow-up perhaps you could consider something like this.
     (* completely untested! * )

	hp->happy_timer.expires = jiffies + msecs_to_jiffies(1200);

> +	add_timer(&hp->happy_timer);
> +}
> +

...
