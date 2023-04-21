Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA066EA67B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjDUJFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjDUJFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:05:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2134.outbound.protection.outlook.com [40.107.93.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4593526B
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:04:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4srHalJyfVVEH4h2wgrO26DpiLuqnfvfh4iElR5y9ec5Y3s3hBppH4JiW5Vk/2fxH9eAl3LVGhaRGPNDzXA3jEIyDQqREIhgko62rWSJ34cnFni0wRZatsqlfkHQkkC8SejxJKsG0o2WihiL94mAldIacX5oxKtPFowv/B3RIWmVaLMBqo315fuGfoZdGM5k2P6R6MlKxV6K0t4K9+nGIjP0DBBTTc0GstpVIqEnZj+4BHkSKpv+8ZgqvJ0touaiZRw2kcuBElZL+KtCufrFMjEyolYcmFLfRz4zlvtOR22OFBwldElNzOgjfC4t8XjBkDU12ZBMBfI7bokasR7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jksCc3S1XvyPWIAo7YOhaUII1RrMpj3E+nZM8lvmcmc=;
 b=Ivvc5q6deZ9A+C2cd6EM21wFlhvA8AhShZXXJ6wyJo8aM1xNGRhTSh11JVHG+nOvhO174uvTr6+B5zG3dGdrb/1o5WO6mjf/8P04x6buEd53tJNxu0KJvFJkyPYLh6Xsu6S92Wb847Y0K+KPIEtWUlz7qB090SnG5ZmYyLpTo7HW0wu6CdqFpb7rOGPF6ql+7PsBXXRpeR/0xDJ8YdVhXnxyb7LIWVbiOnu5Q2X0zcXBLK/5WL5vzlsBy+WpdvPGqtjGRF6To9XEHVgVnsBfuo/R3dwXl8vWQ50tol1t3NRmNgmYbWdk4uDrapTKhgeWWThZiBg+kEzxc2mnfSygYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jksCc3S1XvyPWIAo7YOhaUII1RrMpj3E+nZM8lvmcmc=;
 b=n8O3DC8R/UuVQM1gvS3cYFz1X0q/8mPuz7TLzF6L5WI99XWhdyV3u3QYgR/0guFY7y0v56fuJoQEaTI2wHnQwCPcdADh14Gx3iu0nH9a/k9HNa+JIerLIXGw0rM9fbBowsAZBtK8xSYP3NlGbpNAKIts+/d1PVdrRePbtNOHKAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5158.namprd13.prod.outlook.com (2603:10b6:8:4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Fri, 21 Apr 2023 09:04:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:04:57 +0000
Date:   Fri, 21 Apr 2023 11:04:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 3/5] net/mlx5e: Compare all fields in IPv6
 address
Message-ID: <ZEJRsocoeE/Vr0Dw@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
 <ZEEdY+qtAQQaFbZP@corigine.com>
 <20230420115243.GC4423@unreal>
 <ZEEqbUinuteJ148u@corigine.com>
 <ZEFNyb4zAA/2rh9s@corigine.com>
 <20230420171319.GE4423@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420171319.GE4423@unreal>
X-ClientProxiedBy: AS4PR09CA0016.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: de138646-ec29-45e0-d076-08db42477a83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGwatfqaj/gvkuoba4Gx8jV8G0rxFIhf790g5ZMh+D9z4FK8NNNVOvIYkN5GJy0c7KsipEvkfU6P35YmggW1nTf2i1M/aU3N5Q9mF1OCBkrJtWJQ4nTv3t6LIXuDCPYmD3cyjuUsCluc/uVQANGHk3wZ5I1pMlDYiw9wH9vJyAG5XFHSE0BP4DXucQOhBZhB4xSM+OHB5FIUEFI1WPz9i7RL83qiUtGnx1gcfe8snKuwrNauLey+7UfeffezJt9EdQXv3jztwb69e7sIIxOrSU8oxsvNOv3KYsB9I4o4D2j8fiaxP87+ctXLsFu9vuHiae5/35s8sCqLsilGBq7MhWjxrTUxhCXxlqk4YVTS6K2j9MCBBfnq/h5TucrbthMcFYlWaOEdpkIlHLI9M0hG8Y1lBN5W9/o21RtiUGPL3p/GT9oVZah5jHZnx+vpPggFashHqXWpKAc2Ld7na4uVhHSYQ9CIPvKmvEGc+EyEhgP/4EOaZn4a1JQgwFGTBCGUH/d8T3qUcGHNutBmJu0Fp025c1SdV+uGXbi+3v3NRI/pSPLkBo2lW0YNAP4ouUcRlcD/xzgkG2UTKxouvnMlA7UfYWN9nkcO913Pmk30ONI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(396003)(346002)(376002)(451199021)(41300700001)(66476007)(66946007)(66556008)(54906003)(316002)(6916009)(4326008)(478600001)(8936002)(8676002)(83380400001)(2616005)(5660300002)(6506007)(6512007)(6666004)(6486002)(36756003)(186003)(44832011)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqo5m2o7VqeZwafXIQ1QmybxoaCO453MTa0bVflz6aWQ3GyFKHeUEbNAMo48?=
 =?us-ascii?Q?TuHbE8hzfbWvGZWMmTzFzFsbiqgHvyJTYf3GRAgBGtOS5BcLdGbLk6yaU0LP?=
 =?us-ascii?Q?P7WFM+1/FOqhUbJ5dbPQ8g//UZR0xqf+v7hds3ROllqBE52lazFwXjKV4uWj?=
 =?us-ascii?Q?edXzCIpsnf7GR5nVXUmyhmnmJ5tZBwJv+9/TNKEn1hFKn4eJ7n8e2yvPLeJG?=
 =?us-ascii?Q?CaAAXajVMKXObzjc6AeWSQLkQP35/Y3xHz+8xFsBoV3vdffgU2jrvkazE6dx?=
 =?us-ascii?Q?DKwT1DuVLACHGo0hyFFIcH3ntk0GEIIB6tgZJhq61o75PCusHla53d+qRh3i?=
 =?us-ascii?Q?oQXRkF6PbciSic6TA4LKUhR2s6PKNW0ZGctdfai+L8+BD9rkLmsoaP2fnMKM?=
 =?us-ascii?Q?sYyOZj0MpKUD/lHIlCmJoNxZ7/jnyzO/QTfAhLKfJEW/d2rSxXVfrGNsJssr?=
 =?us-ascii?Q?SSC9Df9HjnUv3W+8oB/KmGz6luh8RByA0gpW9YycHISIocIn04AudIOgjd01?=
 =?us-ascii?Q?fIC0hWb+M0SK6c+IvYtnH7nQwKN/oUz3mqQ827nBw8uGj/zL7zZcgyYxJ72U?=
 =?us-ascii?Q?BZhsZJMSnIX3rS3+UgN4QE9ooqeHFFufwtL7N0pWkxP4R03MwfgH6LcjgMt7?=
 =?us-ascii?Q?MwxnuTXi9WvdYcsNcXKNmkg0cbispBXKhSdwdzX0QVHRE5KioRDnz+/4rX2r?=
 =?us-ascii?Q?g6vDBeYn1yRGNTj3P0RbQpFxIzOV0SNBp/W5RMkt1y/2b3xTAS0vty65m0vu?=
 =?us-ascii?Q?RbfEae6q/WK5cjgnVjULlL8WvYUxZaFBsw/qHENDbSfP0fzhz9w1d8yJUQVX?=
 =?us-ascii?Q?rU5myEBwIqqshNHsBpxMskiGA78eINKldZEDu/45Nsf+HQmue+261cduvsU8?=
 =?us-ascii?Q?lg6UHKLlhrtU6EQ2tZdvk17GRn7PsyGOEcek1i4Sncwf9hOHb4gEJCMphPok?=
 =?us-ascii?Q?EiLe/YcGg+6T7uSBXLQKWcFQEF6ILXunnTDfEZfksHW13Kb7vxFj9q78/HjE?=
 =?us-ascii?Q?A3noY9cuNBTnmYxdxAmNZDSwePdCmNqd84PYV0YlPfegIubowVM0cw3Is/W/?=
 =?us-ascii?Q?7LxFPIhFAx8yh0EdXwPTXqZeYvZgf67nFHp+asUPSBZuEJkZ37ZcPhtFzlVS?=
 =?us-ascii?Q?mJjHdlL/wNCCdH8qss/YSuKH4oL01OGwjUz8H9HQTnILn3NqbvOrQgVXOgBg?=
 =?us-ascii?Q?ZEa0jnLObF2Jot+JzP/eibYUOOVBMJ18qzDJMkygKpbIddKxWGnJluOM5Psl?=
 =?us-ascii?Q?WfEvVapmc5hSGD3YbIzBjYP9hmG9II8hLHx8eFMjvPhdctOm6XByj0sRwbh9?=
 =?us-ascii?Q?Rt+vgGiVK0dk2qDo7hg8HVg3gRGWcNAU/hX3sktzDtuOSXQa9T0P5B1oFUKj?=
 =?us-ascii?Q?yrQDNd76yW9lVsFMWkt09dNTAABZa8RbUVgRkpwaliXq8S4HRa4yK5rh0H4W?=
 =?us-ascii?Q?H7PYG9um+amS7ZHF4G5VsxFRt2wwfslG1LUAZmaFdYmmBUw3VPPYh9/+RbvB?=
 =?us-ascii?Q?qy+AasujwlDlihnOMXHieckzVmi3//DLZyu5hJscYLs1vppaja5tkvNYRSDK?=
 =?us-ascii?Q?2F3T/SKFc+Ec2ltWUMKbA/Zt8uJRXxWUFtOQyP5TvKdhpWb2i+tz1OfzvAS5?=
 =?us-ascii?Q?WFaCAX4AUSUveUxr3vn+lHqVpQ8TjfhdXKnxSJv7c8jY5FGiFu3/IrjEmSh+?=
 =?us-ascii?Q?DwvePQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de138646-ec29-45e0-d076-08db42477a83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:04:57.3258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ALFPaWeDBZKo0+JdjzPXxOxd9b5ZA1iFrySVnas5Q4R9MFYqOIUANocVXcWJaJzw63k/TvkCj4q2OKxlcjzjiJJQh6OxTGnYJq0N/m6U84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 08:13:19PM +0300, Leon Romanovsky wrote:
> On Thu, Apr 20, 2023 at 04:35:53PM +0200, Simon Horman wrote:
> > On Thu, Apr 20, 2023 at 02:05:01PM +0200, Simon Horman wrote:
> > > On Thu, Apr 20, 2023 at 02:52:43PM +0300, Leon Romanovsky wrote:
> > > > On Thu, Apr 20, 2023 at 01:09:23PM +0200, Simon Horman wrote:
> > > > > On Thu, Apr 20, 2023 at 11:02:49AM +0300, Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > 
> > > > > > Fix size argument in memcmp to compare whole IPv6 address.
> > > > > > 
> > > > > > Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
> > > > > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > > > > Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> > > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > > ---
> > > > > >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > > > index f7f7c09d2b32..4e9887171508 100644
> > > > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > > > @@ -287,7 +287,7 @@ static inline bool addr6_all_zero(__be32 *addr6)
> > > > > >  {
> > > > > >  	static const __be32 zaddr6[4] = {};
> > > > > >  
> > > > > > -	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
> > > > > > +	return !memcmp(addr6, zaddr6, sizeof(zaddr6));
> > > > > 
> > > > > 1. Perhaps array_size() is appropriate here?
> > > > 
> > > > It is overkill here, sizeof(zaddr6) is constant and can't overflow.
> > > 
> > > Maybe, but the original code had a bug because using sizeof()
> > > directly is error prone.
> > 
> > Sorry, just to clarify.
> > I now realise that ARRAY_SIZE() is what I meant to suggest earlier.
> 
> ARRAY_SIZE(zaddr6) will give us 4, so we will need to multiple in
> sizeof(__be32) to get the right result (16 bytes).
> 
> sizeof(zaddr6) == ARRAY_SIZE(zaddr6) * sizeof(__be32)

Let's retire this thread.
