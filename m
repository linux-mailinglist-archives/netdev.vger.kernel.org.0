Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE84A6D21AF
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjCaNtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjCaNtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:49:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2101.outbound.protection.outlook.com [40.107.94.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA01C19A6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:49:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D02ziJgWUsLuZbcQMZrKkTdYm6fyBQNGxyiif0DCxAyhGsBLx8G1W72NHJe42uhy68HL+P9JQunMYYM40z8SlMGfyf+scUCKzxfW3fKfUzSapFEdtdcG7khRCjgAN0ZNy+T7RcNElpvEBNFrf5oq8FIGa62+vXEMG87X4E/J+2AD0tO4OgE/XH1ka7hya28xvCimXGuK5LOYVVzZ82nDxlabjP40zGVm5ua/M78XKCU1f5ho8djnzq2pZ+Eym1VXuVX3ArnTtAEeY2wsPJA1p+33CUF9h/6S57gmIDpPAay321bStR/VqbpRI8shP9aQCno3J0bg6qEfZTAHooO/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqaxINOxJ13IXDADjolsD/ZH64JvN69M2kyzyxretpA=;
 b=hurPudkbEc1LnpnyMd1wM/7QXimIiRd8d1aJZFe85mSDqboJz+YFzOs6edT2tnyjBaJ9kwFZmZPUm9VcSI92NGpfD1fYVRLDGKgZOGVSUimC0S10ablffE8XK6KKwqP5+5VWZoLJk68QSW1Ri8B4wBq4HiTWGGRZ1qjlk9/tjsfaxpp/a/7tgzMuO69RcIALYOgZBP89S954EYrVVt5gUoNfk7zyMNdfWlRwFO9mZSUS3kvwF4vU0QSEf7GyGzIa4IupLGsccoc0A/G0m1ahqNG9qgIExEvslUvo7jOuXaLUfVonuqBntG4OArSWXxQpFaM39wocQCjT/RQsjGrsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqaxINOxJ13IXDADjolsD/ZH64JvN69M2kyzyxretpA=;
 b=R+qhaH0ZNkv/+sNmVWydN5MrJE9QZIQwjXwBk+KuW+HfuFcRReqj+a5DX46MvlohdDqAB8ArP5C2u40I0a1b21qEdIYOz6t6BihNTrHJXmklxVpOK52OwQxPiS4T5Xq9At3slRemuyMSNvszcXmwplaIcOFa9eRC29kBu1e78QY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6157.namprd13.prod.outlook.com (2603:10b6:806:350::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 13:49:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 13:49:03 +0000
Date:   Fri, 31 Mar 2023 15:48:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, netdev@vger.kernel.org,
        leon@kernel.org
Subject: Re: [PATCH net-next v3 2/4] net/mlx5: Support MACsec over VLAN
Message-ID: <ZCbkyXyhXEsULUVh@corigine.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
 <20230330135715.23652-3-ehakim@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330135715.23652-3-ehakim@nvidia.com>
X-ClientProxiedBy: AM3PR07CA0070.eurprd07.prod.outlook.com
 (2603:10a6:207:4::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 686c155c-3f9b-4bf7-c6c6-08db31eeb067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFuChGJEkGz5kf2bieWyJMyoC4sTL9+N75BBnMrwULSsFJuudNvXylZ3hd4jOWuMUlmd8uyPf2YK+kFftdkcBa7+k635p4nU8wV8TcmAWNo/aZ0ZNUa7Jr9b5h4UY6ZisKEixvP8l2d2Dh48RSng2W/i6Z6XLGhtptPUSU5htslZyj+e1QCAQwvoKuNrrlv2KI1648+C6j5bxN4iMrx0yDGw+Ni7Oh5Adr0RgSAMYH7MIg2iCwkQVc6CBd9kFEay/l819OVKp1WBtAmZKCo1WkE10/R1fpfT230gM5RJjHgYsADUPQkV+4zDKlPzme7cCWOaCvemtufiHNtawQOGlosrLrToSw4XaWL7wkcFPNJrwPHiLqo5AWKL80ob7mFvH1duAb9xMOe841KBnMrHmKxwUX3rIb6FZ/o4paQh81Jf3JARysjWeJag/RZQ7+Pe6SdX5Cve4n1Z0HtdJj8KK4A7tbEXGR5CjgAezm3iByW0HnTwYR72LZwTeuQe/aIZwXb06cFhOssCodmhn4epCZRZ/PdlYLB2oUOVcuk+1deoA2yylVCIOeEWMsJkrpx3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(396003)(39840400004)(451199021)(478600001)(41300700001)(6666004)(4326008)(66946007)(66476007)(66556008)(6916009)(316002)(8676002)(8936002)(5660300002)(44832011)(6486002)(2906002)(86362001)(6512007)(83380400001)(6506007)(38100700002)(36756003)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Izwv2ZDLH/qt+gWJaNoFby4rfWwJNHoJmVgTu3e1AN3rGUXfqbLYFsqWmo1?=
 =?us-ascii?Q?QJrAf5PifHi8dwh4lmzLIZOsR3PiGZwmE+Api6lMcxVtMrtHRQ7qV2yH7HTl?=
 =?us-ascii?Q?JXMnSHMO4EXytogwzMPIZ41WvMY+S2o5yQlw5AGMOX+kiOPEbyRifAP43eZa?=
 =?us-ascii?Q?eHDmSjKN0/SHknVSj19qbYjiHbNIDRhtMUw/G7opwm4PiFec3ImtM4XVfxVJ?=
 =?us-ascii?Q?TlZYMXY/5ye4UCnmXI2VX0S/M0PZwARIRyim8LLOdvmIemAj1WyyIsVXtS/M?=
 =?us-ascii?Q?tp3jm1tsus0WHzMFuE+3r/4LXJvV6Eav9WTd/QgIbl1mcSGD/nYi1D22+xvO?=
 =?us-ascii?Q?W9QLed0H88hFccF4qe2OyeAn1gDFoCytp6N2FnRBWM/07kjVIrWU/xfBzxz/?=
 =?us-ascii?Q?YSw9JSnOUe5vf8XbQjqmU9DmIHxudSN8a+1JoXRyINZi/m3mnJd4BGchAfcB?=
 =?us-ascii?Q?RAq0jO8FlP9rpEYwwu48yFRQZl1hTjltGeh4JVBocJkRAtlBqkUWs34T6m7i?=
 =?us-ascii?Q?BnCmZAc+wjhfVaGBPZ07++Q8j+zmCEfVI7j5QI1vII91SPL48ZFi0/5LRyN9?=
 =?us-ascii?Q?44QqBw+oI/tckW4TQnjPaWK4fl7DZ8lm8+02TLSP13hQif5yj/RtVJHOdk3U?=
 =?us-ascii?Q?Ns4/BP9+PovhV8x6AllggcUNsFsZPVgZx5JG2HlrH3n4FQ/+INq5gRxky6OZ?=
 =?us-ascii?Q?zPwUsckEYbyDxYKRxMtyGUsBGGhBKEZvyZ7+ycu6sqT2F1VONpvQmjlA/u/z?=
 =?us-ascii?Q?NH11VtoNXurrAf6XW+LDV2nC/pwouCLmzCdXG41B8VOtVbVKhL4WBmSLYeFp?=
 =?us-ascii?Q?+Ik709lWZEedTnms6slYm2fUVfVDhI8eFm+J1MPx75pr4r6Q3LUefQhZgpq6?=
 =?us-ascii?Q?VsyvOdktEZuUiubC+9Hqb5zJb75NWp696zJOY5xartcIaBSdJBUkYABqhwjI?=
 =?us-ascii?Q?x2olCIJioyf0tmHmAIYo5UkTjAOLVQD/0gyBn86PPfhgPI/7Xm9XFqG12Viq?=
 =?us-ascii?Q?oMurRaAqpTmgiAekQ3VwTrDxJRorh2I35+Dki58AGdag8Y1ZVhojmft9pQ/P?=
 =?us-ascii?Q?McOgiSr+yM7gas8kaTR+5NClvRsv4XfVgSDqBP7cw68yjTuXoXOF5BYFNYeu?=
 =?us-ascii?Q?UDLWLBgNz/etHIZBajVcof4pBfAZMS55nPjHkmpky2sIwBbWfawc0KIfjRn6?=
 =?us-ascii?Q?Fujs5jafZSgQ37OVTl4GJt/vVQ2OGyM4iEgfqAoNYNSxkhld7lBPzcUey/Ot?=
 =?us-ascii?Q?qo0g12qiKixuzvgqqpiXR0DOCse7alZl1wnFJKVpIVbXmhBVVkakLwavGUV3?=
 =?us-ascii?Q?udDcrrtUBAg5sS42i6Ot2o9EHn4/wzInURouhwE8Y2jvYZQdZ82jb6o5n7bJ?=
 =?us-ascii?Q?wK9+nmAYjNa6ILSMorthrJIvSBsItK+inF/omKM7dDm2hUBlepnekRB6T02W?=
 =?us-ascii?Q?n2LnP8wkVv2IGZTlf4pMN+x7F69FqfhiUdXOczBPYfEvsYpO+OzI3uvHlC5k?=
 =?us-ascii?Q?2dFZOb8Zkg+sz92GXKwj3zGXp5GB08eGfnGKZraVoQ5EJsrfIir+qF0rtfVn?=
 =?us-ascii?Q?fFwztMqRxJ+S2KSX0Ap+j67XExRGz0vWxANBJH9uQONVkWJJIUv7g3yHLARa?=
 =?us-ascii?Q?Vf6+PGVWEyEx9uBXvDL5etbZPvyy1PyAZGrBNwcENAiElypoP7PWWPaYBjJt?=
 =?us-ascii?Q?k0uDsA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 686c155c-3f9b-4bf7-c6c6-08db31eeb067
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 13:49:03.6580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tF7MmL+llEMxrLlkGHG87P1/DY7HaW45RgJe701X4uyTsaga4dDs1KK53BQF77x1tJLubOhcffKPadJr5xh+dZd/AzTQv8hPatUocN7tXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6157
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:57:13PM +0300, Emeel Hakim wrote:
> MACsec device may have a VLAN device on top of it.
> Detect MACsec state correctly under this condition,
> and return the correct net device accordingly.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> @@ -510,7 +520,7 @@ static int mlx5e_macsec_add_txsa(struct macsec_context *ctx)
>  {
>  	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
>  	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
> -	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
> +	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);

nit: If you need to respin for some other reason you may wish
     to consider reverse xmas tree - longest line to shortest -
     for local variable declarations

>  	const struct macsec_secy *secy = ctx->secy;
>  	struct mlx5e_macsec_device *macsec_device;
>  	struct mlx5_core_dev *mdev = priv->mdev;
> @@ -585,7 +595,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
>  {
>  	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
>  	const struct macsec_tx_sa *ctx_tx_sa = ctx->sa.tx_sa;
> -	struct mlx5e_priv *priv = netdev_priv(ctx->netdev);
> +	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);

ditto.

>  	struct mlx5e_macsec_device *macsec_device;
>  	u8 assoc_num = ctx->sa.assoc_num;
>  	struct mlx5e_macsec_sa *tx_sa;
