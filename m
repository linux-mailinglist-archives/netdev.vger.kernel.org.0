Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F46CF340
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjC2Tjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC2Tjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:39:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2094.outbound.protection.outlook.com [40.107.220.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5094ED4;
        Wed, 29 Mar 2023 12:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6zyh4bImEv2LmxVVo2DvKAZRHaUdDeFsvM7kBfYnc7ivnHs5vaqZi0nbLfgdyEwyuFwjG0Ev19vwxv8HhGYCcYUYX6FO9Ptkq3p1R2/G/Ror5J0+Xf9eTQUERr4JlGN1sHHVSmxgfHiCDGwc8ZtXCPL7xcdwfHwIqltuRhi7oFE1SKXwS3KZtGiZTl0haeWAx02uKLv2ZTo0tUO/+xsRKM8QZVH25T6qd5zmANBpGvJchIsxYivBi9pMXTSZbG1FfUT1bwu8zhvprKFt5q+bI0t+6AK+iSLgPGrSXRCrN0nvkJBPg1S2XIq2EeevZ3McPDKJt+zAivRLRd3rrkDjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NM0ArS2HRYc4a1ewmxqhVYNSI1GP0OU36wxzyKIWQo4=;
 b=jlSgTyUt2N6TEp2cT4TyqAFCVgKg9gQiLzUO3WZ2y5ER5G+Mwem2wzn30AwN+wOuwMA11P+OXpsndGlVK4aRIbvvWdNfU0JS7QSYL5aPGPimCCWhV1/IdYg5Hy3sB1NuBg/3rWCc4YWmo12tCtnYfH1/OMpOAntRffhZM2i5Jiqi5cU6ytA/Zy2B6WGgplalcMQBdxIeRkK7YsLarGLk9Q/NfJiOwuBPz3rBJQvzWZQ+1IdGSWtcUpXvsDtB9YSVNx4+SPld9fJT4RGIHp0YFnzuUNwVW/JzkgvO6MXYKp+FoF25sRFX1ljDFftP+YYxTnf9A0N9gokqvuUIEisPPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NM0ArS2HRYc4a1ewmxqhVYNSI1GP0OU36wxzyKIWQo4=;
 b=tHl5JX+glGM/Xf01HqBtMUcj9O2F5k4PChxBe5rqcRb5WkVv7XdcQCO0914humMto9R7SanvxUybePNttYEdCnDKwIyqBkodZU+dYRyxY8xwTJDhUQrzartht5fRnIoFKhDa0yOgx4uwzpoYBKIiwQdnRom/vArQtprOaabZoRY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4108.namprd13.prod.outlook.com (2603:10b6:303:5b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 19:39:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 19:39:38 +0000
Date:   Wed, 29 Mar 2023 21:39:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mISDN: remove unneeded mISDN_class_release()
Message-ID: <ZCST8vuQDEo9GhsS@corigine.com>
References: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4108:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a51eb69-cf07-4521-6ccc-08db308d5545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yvu/L90jHn+A6t8t5cxCBEatFqnPRHbJ0IvZ6vqc/tbaGMzXpUfKBPmwVhTkNl+OE3vZRoZz+3NgzsUp5PMC+gCdUmM46IPWqDZcKiWBmq+e8cVfckyn9mKi0IZMl2VyrloK8ihYKpjJgsgHzctXZsbCcRgooW7iKk/fJCNvEg97wy8/O1NngW5F7jbyZkCKsX+o2LQYM+NmyUIcTc3rRVRFR5zWVBAPMoIXfl9q3MkxHHB/NHOuoEQt8NNnpifQd26D9zMDtYjYKKQ6SzSRIMtvSHsgUTVUC7r2VKOruGYs4y0oLsHOvFja+RJR74C0Yh636oC3K6UuHvGMkgX/X4JjxeTarnOTXP42iawbXBAWKXJg8KLA67cqP1LnGo/Xm5Y4dqzL+ZfuCNkxh7bKyWKhDWN9sqpvm4BOUxoBwUM/zxMlhgwuuMdf8YX0PPWKpAJLgiJ1NHaBtv4fR0WC52fjvjWgNzvKxXe/mRPIJc1FTAfiWGtb/yu8VADBbtUe729MLVrXaKwthh6EZt8vtYYJuryyjzsPakZtqpzTgPhXyY/wu3Hxz1WBQqTH030N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(346002)(396003)(366004)(136003)(451199021)(6666004)(38100700002)(6486002)(2616005)(478600001)(186003)(44832011)(5660300002)(8936002)(2906002)(6506007)(36756003)(316002)(6512007)(4326008)(41300700001)(6916009)(86362001)(66946007)(66476007)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bvERThQ0A3ZYsHYyouq/wOIeFxtFq6I8rm9RS32eW5SkTeQpWKs2uvicht4h?=
 =?us-ascii?Q?iJg+WJYlzPGY6NT4Xba7S6bu+fphZSWjNfud4uz5xalCyuDhW4LoT4llQyNP?=
 =?us-ascii?Q?LdMiGBbGjdbaBlAwUVxt1HuCx2sQToGc5DJL2oz0Je7cxWKl5XfVcbfNNH2y?=
 =?us-ascii?Q?u9wa2XIXXZWb2mJh5iyjSbkxvz7ZELW8yfCvY4Nhu3PZ+BKMZuKO0clKIsqi?=
 =?us-ascii?Q?UZEJ42Xjci4CYgbUbZbzkzhAHkFjXYFQSo5RmApRlESoXsY07zhOxh1CA3qz?=
 =?us-ascii?Q?qaZTC2wTe4ES/sEyCd/jU/V2M8RAPnh6rGKqIvZy9f5oN+jjfcPeBGaz2tx2?=
 =?us-ascii?Q?LoqiVI0gn+7/RKBA8cEMfQP4ZSGwKhiR/epNEYgPXttjIevJhGbyzPE7BEec?=
 =?us-ascii?Q?cYPx4dlOIS8OnKzHZnXFLAzq0cRiBu4kCaG2Tunk85MLW1oLsoJJ7bDiklgJ?=
 =?us-ascii?Q?6pzV6XD0VnDyYmmnns67Teh2g1i6WS2erS9OB416wzMmudIP32lnwsN7OZBf?=
 =?us-ascii?Q?4qlnFd+wrHViBBgE8WLdFVe8LCGdJ+bAaxUFnq4CyE6lyLxElNa+uo8HFw54?=
 =?us-ascii?Q?GO58jr/NCHQ3A0LOlpATVdWENK5CyS2cYmxpuPIkAmjvOiOnAkB/RXcfA+cm?=
 =?us-ascii?Q?Jipw7dx7gqlG+LD9TkVjop4054kCN18fjrik9n65Y9ClYPJWwik2IcvEvEHb?=
 =?us-ascii?Q?6THJM35vuaNlApNSUTzwIeKz5wLh+HmYJfik5c4DYnr6URPH4G+Ixv6y019s?=
 =?us-ascii?Q?pEDAcqLNvrUXuc7tLdMjJg++PfwwF59fo/birdzrP7loD/+7Rz/2tCPnmBRQ?=
 =?us-ascii?Q?gRPLWs4qYTNIcmRcjdn+gQYMPeqAON2o4EvkKjh4E8pCSKbunv4Hrc0B0RYU?=
 =?us-ascii?Q?5b0kAsg0A+7RmZcsOUdSrAQUeP5yDE8mhRww8LCQdxqqnNyK3BtDls/39noR?=
 =?us-ascii?Q?+Rfxft8inEmyRkr3nqiTE1wm9nq1XkTLwENzE54nwaAcE37nFRVclXCxwJxS?=
 =?us-ascii?Q?BlEkMnAL9KLHKouEwg0ATx9YLyZBPLu4aWZImTFpoMQzxbUU3bqKrYUVauKb?=
 =?us-ascii?Q?ZD7zFu09tyCNPSzYU9i/1903tPiTeyOFhIN4P2ycPtf6Yjywd+ueXvoBoTz0?=
 =?us-ascii?Q?NEvfTdxOUbdQF4s43FeoC/KHf0d2tIZ1MWGDY2bdR2FhgwnMNxpEw7P1rLGH?=
 =?us-ascii?Q?laf0QpE11wyQYdtXrdVXdkjQmOe3Lqw5IM3IaRO0rF7KE0DvU1hF1zmi1nQ4?=
 =?us-ascii?Q?4NKM+/M8LrL+rm7x+8QJz9GOP3m9Q2YTGHGb0Htvo6s/vOE03x3MSkNgEteG?=
 =?us-ascii?Q?Qm4cgFQjV/dYnn5JtOkm6nF81UvdfwCD2cvI+jwYZV1306RzU2pKAhxaMqC/?=
 =?us-ascii?Q?OCPVFSgya6T5Z8UdCcZbeTYIzBDvw09Cjpy4WDS/rbuiupy2lROnvjPpwYHq?=
 =?us-ascii?Q?b5o4vp8BGvV5BExC6rBa6fCStH1dUfCTaDAlY7Hsl80ozckziADAK7tO2lw2?=
 =?us-ascii?Q?jfDhEk3dtGaV+rFEPh49cj641BpCFKWLPrKAzPjNGkVhw9oBMBwa9H+UIWP7?=
 =?us-ascii?Q?r/BclE8W0jlvktlt/xqqi6Rl1S0K12hUOrJ1jN11enTDBm7XuOvIrHfIvix2?=
 =?us-ascii?Q?o9NwESEWRaiwWs17tIASG0JlKdcS70MDsTREQf4qDd5dEDmkKQ0By8f+FYHE?=
 =?us-ascii?Q?cQoLUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a51eb69-cf07-4521-6ccc-08db308d5545
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 19:39:38.6039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klsF3v3d3IwdBnVTsqQz9z0yUj0PX0sd20RKC+PvEb+7VGuD+5oSisBoiVBYoH5lA4EgloIT6j5AG4DJOYB31AhwWyz3CgzAv8gZWHw62Kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4108
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 08:01:27AM +0200, Greg Kroah-Hartman wrote:
> The mISDN_class_release() is not needed at all, as the class structure
> is static, and it does not actually do anything either, so it is safe to
> remove as struct class does not require a release callback.
> 
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Note: I would like to take this through the driver-core tree as I have
> later struct class cleanups that depend on this change being made to the
> tree if that's ok with the maintainer of this file.
> 
>  drivers/isdn/mISDN/core.c | 6 ------
>  1 file changed, 6 deletions(-)

I assume this will hit the following in drivers/base/class.c:class_release():

        if (class->class_release)
                class->class_release(class);
        else
		pr_debug("class '%s' does not have a release() function, "
		"be careful\n", class->name);

So I also assume that you are being careful :)

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
> index f5989c9907ee..ab8513a7acd5 100644
> --- a/drivers/isdn/mISDN/core.c
> +++ b/drivers/isdn/mISDN/core.c
> @@ -152,17 +152,11 @@ static int mISDN_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  	return 0;
>  }
>  
> -static void mISDN_class_release(struct class *cls)
> -{
> -	/* do nothing, it's static */
> -}
> -
>  static struct class mISDN_class = {
>  	.name = "mISDN",
>  	.dev_uevent = mISDN_uevent,
>  	.dev_groups = mISDN_groups,
>  	.dev_release = mISDN_dev_release,
> -	.class_release = mISDN_class_release,
>  };
>  
>  static int
> -- 
> 2.40.0
> 
