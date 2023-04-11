Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB056DE2B7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjDKRiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKRiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:38:51 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2095.outbound.protection.outlook.com [40.107.92.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CD3448E
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:38:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfG8LvgOco1tP3oFxF0PvjQiOzsBkyV695dmKFe27xXsTvenMK+CARU/kT2ejLshR7o8UjCKJ36DDl1FZbDplJnMewoMgwMMnsTXoHzPUjoiWhYIa03Dw3eAFtyEQYn33Zx2ZXbxBLshNal2TkggAxqgsSETdx6XKvIlKsTXwK6Ja/NXtOaNs6JkFLHfmuX87seE1QHdjdk8cQgNoYwYKfQuBCnEmZT2TYWuZuhEtoTO5T5HsLGWx11yIIP94P1oV6r0KTXvd765oEgbJVelCZn46ZLT24EsDryLsiHik2xhZ9cYCOZREzVyiBKvDGYEIlE4zD/uV43bMJU57lZasQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC7EjY32DGfwnYevijbo3fuJzac7/zYhvOWErHs8I9Q=;
 b=BAehNvX8PhST0wXX+sf5/4o9lU7XEd3UeuL0VVoqU9vqEUfH7zCfjKSM2+IebUtQqU6vkWV+QyzmV+31EUW7Sq6nzslzqOprWyO1+Q2Q4EJ/b46Ac0mfL3oeuBboFG4miQQb8QFowanI+FPUM3O2ImaD3TfCP5YZ3ldUKkYjrb/dc7dtW97ndAmM+1WgcCdHiIY9FzFzLJg/IyReHYfjURW1ILOQo3zxnRCes1OO09g8rF5E8i6N5D7FjSzmzZ2rjeflQpb0GRdmcHHYwoMcHClIdJ8tP9m0VIsLKsGPuqnOn0gJWCRAMkX2q/yLWwoo00WxAxls8E3IesSWtdks6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC7EjY32DGfwnYevijbo3fuJzac7/zYhvOWErHs8I9Q=;
 b=JZ85TRaa7M5XvJnRGpYcqQTIitbtxu6/IEheREMrq0Ji7+Y0EBht4+GFPQ/4c8ipAz7MTF6qHOkDn4Ha6amrLU8qSslvc66i1Z7qJ9sk+GBsdJget14ppYua00wtnQ9lnaqVjqg2uoF5eYpQpQEoOBxOK7IyqJpN8dqMqmcuiLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3669.namprd13.prod.outlook.com (2603:10b6:610:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 17:38:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 17:38:47 +0000
Date:   Tue, 11 Apr 2023 19:38:41 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 04/10] net/mlx5e: Prepare IPsec packet reformat
 code for tunnel mode
Message-ID: <ZDWbIWB/W7T99wy+@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <2f80bcfa0f7afdfa65848de9ddcba2c4c09cfe32.1681106636.git.leonro@nvidia.com>
 <ZDWEACmSLgk83pIw@corigine.com>
 <20230411163729.GA182481@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411163729.GA182481@unreal>
X-ClientProxiedBy: AM4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3669:EE_
X-MS-Office365-Filtering-Correlation-Id: b8e55d9a-8092-49e9-6b21-08db3ab39aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iL2RCjtGzqf5HRreYTleT8DJkkmLBFDXfhBbI1bLqdwVSUPus/W1gARDRC2qf0BM0qLVKWiH9K7jz/MlM5OQwxq+ZkTgQIP8JrubSZSMvi3hzWEvulQqkE4V6rRYQ4jll5FJnTJ79/LEoKkObFrBkpH/UFZVtAfjhWC54ttwsa/I26qFIzgsMkpICH0LuRv++tq2AfCT/xKzcrOekERoaG/QA6IIj28djB5/rJk3LQ6JF5PCMgG5oTwH8ET6iCK3F4mAkzC3FzWWWbaiu7FxAlD8NSscDuOo2uFzhA+AASTNBpPpz9LsdzL7vM1WRNJSZk4qpa3u9wYMpjFeh+9gUxRzTmVnTRdK+emuX1b3g1/pRd2WTecBUWU7BVhumTao6neAHpHRRiCMWzmlsBOL0NvLyE4Y4kJ+fOl0YEpohxWYzW0tKrrQrqMWNq0Ls0Zs7eJXTu/cera+jm2vldP1M6rhEy+IGRh+EU2XGOFlQ3czb1W/V4Y8XPyj+tBp6qOKiO8PkSGjd3vTV5TD/pB37Utz3E86tZFuLHn7HTAsHlYag3BMoC0jOwNU4MDyjBU+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(366004)(136003)(396003)(346002)(451199021)(36756003)(5660300002)(8936002)(7416002)(41300700001)(54906003)(316002)(44832011)(478600001)(6666004)(6486002)(2616005)(66899021)(186003)(66946007)(66556008)(66476007)(86362001)(6916009)(4326008)(2906002)(8676002)(38100700002)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q6lm/JKq8NjWWdnzj2dY9/fqRCgBZtuCU6PW2qyaxF0vaeop5y1kIPAvLlMv?=
 =?us-ascii?Q?UdYwdCQX7eNQwF89O5sytNGuSQHueOR8DsLLvnh1x8xWGEYy8vUZGrJ811Rz?=
 =?us-ascii?Q?xHsxf1WNzNJEQPzqkJH9+YReaj8jGuTmhjNv0bqMQ8hJUlGH87bQJg4N9aTU?=
 =?us-ascii?Q?sg3vkzN3xnPBzzKsxndGs46atDv9aL56tnNpUaFsLsMuV8b1RUuN3PhO2/nA?=
 =?us-ascii?Q?/QMT9tYvSBq4Jdcke4kyD/+rFY7JZVEb8p5L4WZUHv+wSz3zSWAfUb29/f4E?=
 =?us-ascii?Q?pcJ6EwtNEq/cY/phAv534VFwDsCIu6kl4e1wVgVN/eANxc5neEM+misHI4kH?=
 =?us-ascii?Q?0p0zMg90zQJAP5OWdq7J+9WRt7wmycs7MKdhnwuKtxAENfT7g0V3ohw/CfXT?=
 =?us-ascii?Q?/0dbeqfI+3ModFO8wjSrb4lFQve5+j44pP9DcuXPhAOmtU3jgRA7dy4Tlcdg?=
 =?us-ascii?Q?EREjZbLVQONekLYwQVKmzlvFcZEs9Q9jGgwtKbxn0wxyXR3mLOR0CJ3ib35D?=
 =?us-ascii?Q?4N4OWWYlLB5HBa5K8f556HKGJ+d7zO3viKcJN4YwjFQ55ZsWL0Wjk2QGPO2S?=
 =?us-ascii?Q?vIYxNlT4c8uwLWtXICQ39QrhR6eRwwFOJ8y/nKU+Gzkev3owfM1cfqVUqdEL?=
 =?us-ascii?Q?CVQWyBK4A8w8RpZwYwRaDifpNu31dU+p04vxmSeXt5VToetyCemO396MzFku?=
 =?us-ascii?Q?8OgqVRocVKhOnRifPUvOHePohQG3enN6ETmvceXDS3s2dWOPq/8IQZPhg1+H?=
 =?us-ascii?Q?XjH7Qeq64NDmFaM6PwkeQAU6xz0LqNXjOTz1jAVVrCTHVFkageuYAhZTNbll?=
 =?us-ascii?Q?avqE5L5xPVrLtMaP4m9gKRqRznGYQ4JJFa5XNEOUR8JBQIDoRbG9YMxEgfZK?=
 =?us-ascii?Q?oNTWFhs7xbTRJbGMqaUPh0hk0ZsgyKekUwZq7ZJSQK765odlcXzz39pDwdaD?=
 =?us-ascii?Q?6MZvQk/HkfSP3+RKTKs/IoHKwxxeBKra9NhogiLUtMqT1belumy1+frbkVLp?=
 =?us-ascii?Q?qdGT/NeBkPp8f1G0L5u/p0CcLo6Ostwa8YG2/MN2IF3UKNRKpmElQFYyIMcw?=
 =?us-ascii?Q?2GkSHyy5/SFtTgu7jNwrZ4bEmdmb4UPTB2DNB8E7fYbd+42bIWFtrI5bEruA?=
 =?us-ascii?Q?scHgSb2WrzqDVFgcksB/XSL5eG7NuCVDj5sC9hvjORU9RpRMxD+XEX71Xuvg?=
 =?us-ascii?Q?qVejuuBUh1Q09uOO/GzloeGyeBGWnFDDMqCKenozX6wv4l/XQHq5dxiih0jU?=
 =?us-ascii?Q?dmvgo3oFtOzsmH5jILg650pa60Qdg1CyHtRHrHNIpT+UQoMKjdYB63wToAcU?=
 =?us-ascii?Q?wGXQjzufej1AIoXUUaRfWK367nuaCGKzVR49kzvbZ0tCvg7ukQgzqMKSlpD5?=
 =?us-ascii?Q?8IW6CHG+MAgHQ41MN/BHtAHuLFEP7wkagRmNai2pqAqi+Wg3mhbTbBtIg6y5?=
 =?us-ascii?Q?m2ysQigpMUJTw6LWXv8x45B0AV96WuwRo8WBRSJ8l2H8J3hhY8z2dtVSMOnn?=
 =?us-ascii?Q?9g9J/aHxfXzWQJvtIc0gtAlc3ApMq/6tNjGOJ/Mz6ZwMXPkPM7zCzMc0L3ww?=
 =?us-ascii?Q?MBU5C+PfDJbU8O7sY9ARNkfruH07Net98Zv5KMyca83ZDVNxPQkrBOHu8Z4E?=
 =?us-ascii?Q?Co41a8JzJZ/kW8p797Qax+fDfHd2ZCM76zTwdIuC/92pQmuX6mKQVJpQ7sgQ?=
 =?us-ascii?Q?wv5b8w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e55d9a-8092-49e9-6b21-08db3ab39aea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:38:47.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k66chroMt2iIIUoZ6nWQopqAGmYU4d3xEPRf595yDEYdBMReAOktScz9PDVcXx3ZK9FPRKwE8w6CQyY+0cgN5zTuqGe3CkKZdpisMSpPrN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3669
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 07:37:29PM +0300, Leon Romanovsky wrote:
> On Tue, Apr 11, 2023 at 06:00:00PM +0200, Simon Horman wrote:
> > On Mon, Apr 10, 2023 at 09:19:06AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Refactor setup_pkt_reformat() function to accommodate future extension
> > > to support tunnel mode.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > ...
> > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > > index 060be020ca64..980583fb1e52 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > > @@ -836,40 +836,78 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
> > >  	return 0;
> > >  }
> > >  
> > > +static int
> > > +setup_pkt_transport_reformat(struct mlx5_accel_esp_xfrm_attrs *attrs,
> > > +			     struct mlx5_pkt_reformat_params *reformat_params)
> > > +{
> > > +	u8 *reformatbf;
> > > +	__be32 spi;
> > > +
> > > +	switch (attrs->dir) {
> > > +	case XFRM_DEV_OFFLOAD_IN:
> > > +		reformat_params->type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
> > > +		break;
> > > +	case XFRM_DEV_OFFLOAD_OUT:
> > > +		if (attrs->family == AF_INET)
> > > +			reformat_params->type =
> > > +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
> > > +		else
> > > +			reformat_params->type =
> > > +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;
> > 
> > Maybe this is nicer? Maybe not.
> > 
> > 		reformat_params->type = attrs->family == AF_INET ?
> 
> I didn't like it because of the line above, IMHO it is too long and has
> too many indirection.

Yeah, it's not ideal.

> > 			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4 :
> > 			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;

...
