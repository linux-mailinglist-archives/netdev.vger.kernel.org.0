Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51D6E93A4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbjDTMFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjDTMFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:05:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2112.outbound.protection.outlook.com [40.107.94.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DCD30DF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 05:05:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HelDmi2ZfkMq8NMF1tJK2gNbSeWEBjevyU093VpgWGofGvTAzyUNrRVXW9PrLAT9WK1mCZVxFXcxrVTlADqVeWs1prrTHobUTZHvBo3yu8RFuudehQzKYpHOer3+ayWhE/uq7sAyT5GHZD4cDzFhAPfAH9K+x/zzUsRNg9YqCArfWjshpMGvqN72c4qH7b8zaE/XStuNGHue6fA9VwzHIRcdjXpAx+WjhSK2zBr93Dpx9vzmJUff+60slpkuZix+8JRtwf/1wjbNEVmoaEzJ8MoXx7ERFifIZz8zCA1iQnowbtGl/1Vo9qtZrvmaGmiTf/GuO0xLRH1DY1ySdkHE+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggbV9ep1UBndDHE9C+7Qb+JbRBLCrHjGiTfnrXZNY24=;
 b=ixanD8MAXPS2eKJU3AsTd+hhx9sfE6CPsza7DM5/6LDc+Ei2OL+JzjLcwHG8MRHGXLRDaF3AkF1sgOKNjXdyv6UWdr7euuBa6zEdKyLfHeXPtu8xyPizKbYhe+7DruqnT7XofOTVB03SW699v5dxpsxYXIF8KIDL7yGbM6IxlovsqdTuzxjd6LUU62nqAVJj73y+qVlBwre6JbANYSx9a4gB+VZOcv6RHOvOliBj3ozRvB7UyWHhIXq7skG09zL7zji5gRHf4IrqiC6TxtspemHe4omHGcJx6rPOmmRfuCqgEq3BS5Hk5f8ODdCivBex9x8y6bipiABMZN+qU2pZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggbV9ep1UBndDHE9C+7Qb+JbRBLCrHjGiTfnrXZNY24=;
 b=Gl/otB9EafA5UvFlLYrLBwjixq0E6BRc1e5VKKOy2Q7yC/OkbmAx7EeVVIORlBlsYP2pNZ383MaQpUg0DZKt+JtovQGFlmr0gX0JIr9roYQLdW9CD+0J4dIwm8VSyQ2j/5bR3nexg4QnjjhsDtGdll69o87GMhzRy6BXq68ZuZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6066.namprd13.prod.outlook.com (2603:10b6:806:32c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 12:05:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 12:05:07 +0000
Date:   Thu, 20 Apr 2023 14:05:01 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 3/5] net/mlx5e: Compare all fields in IPv6
 address
Message-ID: <ZEEqbUinuteJ148u@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
 <ZEEdY+qtAQQaFbZP@corigine.com>
 <20230420115243.GC4423@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420115243.GC4423@unreal>
X-ClientProxiedBy: AS4P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: 6daaf688-0f41-4810-d218-08db41977bb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQsSJchr6Z5LWxuuUQUiBvDqBoGzltvocbu3gwHE3HAVjorIqo5sYhmEYVy2+DqL50HNdjmyVu5x31OD69dxGXT1N2/wrLHPi9FT+RFsywagk+m/C5QYTffjOuW6CwMQItUnrgLMeeqBQDfYEkwUrAltbzj6Wkm+DJYluvUgTWHOJR2IuWTO4z65SPIV0xdG9WdajuK2ATZNMF6z1pGFXUeBqklEPVYtCtIYgsZGoW6XtjZrwBvAb0egIAJdhEf8XGkAH17HjwPOHo95Q995rYHYrAHMxkH0nhmrENNijB9puWmJJquUFHbevk+YBx+JvFUZZGDCg4a2EpESRaaqe9tYHX1yAnaRkRHq+OzybLO6UYqnhxK6XY5KbovxJEa7LAVdNTTW4qI9GgDXbfE3R0JJXNJOqwmREhsk/E3iS1dy4PIayHIEL/TycpNt1uShAQyNJBTBhdUZLY53zQB6c5zCaFQXCR+e188Ly34XlEi1N3aSMrnvawT78ucAs5mBDEZd3U70nXDAJHLipcgYutm8l68ka79hyopcBCPbtaJDrr8QeJ5c4AJvpn+oR1rNa+sUp8pTO05hTruk7q/grpwc+3wCee2HMmgOIkMTdzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(396003)(39840400004)(451199021)(8676002)(8936002)(44832011)(6486002)(6666004)(36756003)(2616005)(5660300002)(6512007)(186003)(6506007)(41300700001)(38100700002)(83380400001)(2906002)(54906003)(66946007)(66556008)(66476007)(4326008)(6916009)(316002)(478600001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L48+2XNgCAcwyK/LX+JFvS0Gsj5qZh1XUfOh85qj4R+Df3STb73pqcl7gvIp?=
 =?us-ascii?Q?aUdNdiFidwCdyySDk/n2KVjndHEOSeqS4ylOXKEg8l9YkMhLiAgsteekQ/KS?=
 =?us-ascii?Q?rmjvUjVbK7IQDHQFxyQ4mpk19x21RojRqhSZdc1kTR8KuE4DKNBFG/4VtQBD?=
 =?us-ascii?Q?OU6I/LX8cy/fWlfIhClox7PJrBWtIUd3p3OFYBuYfiPI6iln1hg2Mzl5fY65?=
 =?us-ascii?Q?U7je7Py/8NqkXFmmtb5mnDIOGjwKfflF7P6uDBSWV+bcw5tx2IXL+IOtb2jA?=
 =?us-ascii?Q?zPvirGLUpU9Ho289cljmc0V1gCsLzYfZOyYyuFx3MzRpVs/FsNJjtSHj56tH?=
 =?us-ascii?Q?OPS424FC7JWCtb7fuWUivukSbBk7Da3vrdTq50ipY2Z4seinCxViKbAmJ+Xe?=
 =?us-ascii?Q?PiMlJs8+RNLFsmPTlSPWKDZ83Q6S51kAceXiT++mdXeQCdOW20eq85gJ24V/?=
 =?us-ascii?Q?ccVJEHuv18EbwJs1smnY2jO5L0PYf/KXWkfe8ieNDkXOqmHF0tI9GNPacHI1?=
 =?us-ascii?Q?CLIdZuD/4RnOLUfLr68pQtpbwdZUuhGnit65T0kf0xJxk+GD0LNvAq6n53hJ?=
 =?us-ascii?Q?V1nNDVU/ADlL9KN22IY9ib5wkHuOqiQ2SOs+Jb0tlIs7Ebw/kmgEa1qor1f/?=
 =?us-ascii?Q?nRURqF+io3lHfwHXWE9YPmlKqrziqDYEGlFtSrYb//dQm2tLvGlf7DdwXBai?=
 =?us-ascii?Q?D4mdE/bildA6ZAAyaVxZiH4Wa0ZGKnCldslHhWg67vtUGFHjwL8v0+mAvt+n?=
 =?us-ascii?Q?VLSr9QbNMRddEHftOpc7sAg1rZWUkFwoFzzNVCJhWsbDEB4Dg6kZj+Sxz4DL?=
 =?us-ascii?Q?Xy/nbezGUDSbNdACO9YLXCsfcEvbgIc4KW77c9y3j6VPSnJgrzev5iyIzK4J?=
 =?us-ascii?Q?2kvl79dJm4+2mIUXSfMU0IxPW1GtClp0w1KRS3NWK6Tav6rnbvdIwh44+KDS?=
 =?us-ascii?Q?/NpsOlTChVvM09aty7NVjJPTL3l1AH8vqrdQGkRnFi4t3iioHrnmLBNZkbxu?=
 =?us-ascii?Q?j2IZlE+wdPG218NSXRicsgtV4qtjEdXR+Hw3aw3pFfFchyvfLiPNvWdUrMQZ?=
 =?us-ascii?Q?dedkfN1DnhCLih/Ul6zrZEk/kIqOLn+PBUTlfBNnD0YZTNYldMsPT6Gbi1j3?=
 =?us-ascii?Q?uBCmS82OiWqwoisVW2of8XQlyvXIpqjZIHllrGBAblMPcoLYV9PeWugczMnh?=
 =?us-ascii?Q?5E1Gk1JYanHIHmV60W6kLDNa9dCdoJEbYIHtLBh6ow30kOGm9rBpFdV2izPW?=
 =?us-ascii?Q?du8v3NsNHP8HNq+2jXbW4uTmjcWXVSI45clh+ePEzEqRCz3Hgdns2OyYz5sx?=
 =?us-ascii?Q?Sc1HeiTaivvqH6y2A0uGzv2P3eGuJzwD4nhjAYQCF0jAPNXFXYrSjVJiWbUU?=
 =?us-ascii?Q?rmlGBAZbsS8diXqr4lAuh0tHXAGT3PrxsJ4HwQ/nkpinJbyveyrNaRaiO6Dd?=
 =?us-ascii?Q?yOCp86S7XoQiHXhVSE8xeDnPzegzlvUQVAwgWfZ2/HvCoO4B4WnOeEEQkUao?=
 =?us-ascii?Q?Au4Z3iQViChdjr6l9G0nlJ2tNO+TW1FwCG0V9KaZ44NIzZgyU0w7GF1tV/Tz?=
 =?us-ascii?Q?s9FDfJrWhF2s4PbLMYpxNbdy1HWczPwvwdVzi4OELfZJ32/Fuj609O+nQMlo?=
 =?us-ascii?Q?MFW8r/GxK7xnr49JR6Fb1/TMzDMjvH29SlCpDAKboQVNx6IWqHV5CIos6JN+?=
 =?us-ascii?Q?qaEfQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6daaf688-0f41-4810-d218-08db41977bb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 12:05:07.6265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsDWYTR469ApNpwh+OKAbyNCcLkez/iduN/8/OUc7jKF0aAzzfr5EUU5uPTN2mRiM6D5LBWIRZzIsi3J4N5BRCOvyr9/yv2oKksHhEPQNeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6066
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 02:52:43PM +0300, Leon Romanovsky wrote:
> On Thu, Apr 20, 2023 at 01:09:23PM +0200, Simon Horman wrote:
> > On Thu, Apr 20, 2023 at 11:02:49AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Fix size argument in memcmp to compare whole IPv6 address.
> > > 
> > > Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
> > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > index f7f7c09d2b32..4e9887171508 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > @@ -287,7 +287,7 @@ static inline bool addr6_all_zero(__be32 *addr6)
> > >  {
> > >  	static const __be32 zaddr6[4] = {};
> > >  
> > > -	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
> > > +	return !memcmp(addr6, zaddr6, sizeof(zaddr6));
> > 
> > 1. Perhaps array_size() is appropriate here?
> 
> It is overkill here, sizeof(zaddr6) is constant and can't overflow.

Maybe, but the original code had a bug because using sizeof()
directly is error prone.

> 
>   238 /**
>   239  * array_size() - Calculate size of 2-dimensional array.
>   240  * @a: dimension one
>   241  * @b: dimension two
>   242  *
>   243  * Calculates size of 2-dimensional array: @a * @b.
>   244  *
>   245  * Returns: number of bytes needed to represent the array or SIZE_MAX on
>   246  * overflow.
>   247  */
>   248 #define array_size(a, b)        size_mul(a, b)
> 
> > 2. It's a shame that ipv6_addr_any() or some other common helper
> >    can't be used.
> 
> I didn't use ipv6_addr_any() as it required from me to cast "__be32 *addr6"
> to be "struct in6_addr *" just to replace one line memcmp to another one
> line function.
> 
> Do you want me to post this code instead?

No :)

I don't have a strong desire for churn.
Just for correct code.

As your patch is correct, it is fine by me in the current form.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

