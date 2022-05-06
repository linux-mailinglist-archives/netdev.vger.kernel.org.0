Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AF551CE40
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387981AbiEFBoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387978AbiEFBoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:44:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6E653710
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:40:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F275CE323F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF00C385A4;
        Fri,  6 May 2022 01:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651801235;
        bh=GzQ3Ss3XstGvZURNpS+MMpmajRzsNiPwnuHLG7Xh9iA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PH3BwHV5dwaqD1BUe/k+1ZoPtlX/E4QlBPu3+I+3xnz+8ovyIGN7KAEoXMB1wDfzo
         qAo/VR1MaCSwyjAV1X6cQHkmAaFcGGZuUMiMTl5gmCq3kpGhml64QxuMFkLJH2gA8e
         uB66MluzkJlcoGuV3E9VeDNmUiyYKZqCXWHVon7vaiMDhZ8OYBKt5RglUH/94+0zm4
         TgOosTf/gsODWeoWuaNGoRAKQ8IUIVn3fvwWzPZ1M3r8k4zpWN4fQSiuPBgASsKbWQ
         /1U/WLkxst5a5ECECJ4XUxupOwMXlUYFJGnkrT/LAj26Edk4SCvF6vjRjzjUe01VEW
         dAG8xKGdYEq/A==
Date:   Thu, 5 May 2022 18:40:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com
Subject: Re: [PATCH net v1] dim: initialize all struct fields
Message-ID: <20220505184033.65d7a6e5@kernel.org>
In-Reply-To: <20220504185832.1855538-1-jesse.brandeburg@intel.com>
References: <20220504185832.1855538-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 May 2022 11:58:32 -0700 Jesse Brandeburg wrote:
> The W=3D2 build pointed out that the code wasn't initializing all the
> variables in the dim_cq_moder declarations with the struct initializers.
> The net change here is zero since these structs were already static
> const globals and were initialized with zeros by the compiler, but
> removing compiler warnings has value in and of itself.
>=20
> lib/dim/net_dim.c: At top level:
> lib/dim/net_dim.c:54:9: warning: missing initializer for field =E2=80=98c=
omps=E2=80=99 of =E2=80=98const struct dim_cq_moder=E2=80=99 [-Wmissing-fie=
ld-initializers]
>    54 |         NET_DIM_RX_EQE_PROFILES,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~
> In file included from lib/dim/net_dim.c:6:
> ./include/linux/dim.h:45:13: note: =E2=80=98comps=E2=80=99 declared here
>    45 |         u16 comps;
>       |             ^~~~~
>=20
> and repeats for the tx struct, and once you fix the comps entry then
> the cq_period_mode field needs the same treatment.
>=20
> Add the necessary initializers so that the fields in the struct all have
> explicit values.
>=20
> While here and fixing these lines, clean up the code slightly with
> a conversion to explicit field initializers from anonymous ones, and fix
> the super long lines by removing the word "_MODERATION" from a couple
> defines only used in this file.
> anon to explicit conversion example similar to used in this patch:
> - struct foo foo_struct =3D { a, b}
> + struct foo foo_struct =3D { .foo_a =3D a, .foo_b =3D b)
>=20
> Fixes: f8be17b81d44 ("lib/dim: Fix -Wunused-const-variable warnings")
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  lib/dim/net_dim.c | 55 ++++++++++++++++++++++++++---------------------
>  1 file changed, 31 insertions(+), 24 deletions(-)
>=20
> diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
> index 06811d866775..286b5220e360 100644
> --- a/lib/dim/net_dim.c
> +++ b/lib/dim/net_dim.c
> @@ -12,41 +12,48 @@
>   *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
>   */
>  #define NET_DIM_PARAMS_NUM_PROFILES 5
> -#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
> -#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
> +#define NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE 256
> +#define NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE 128
>  #define NET_DIM_DEF_PROFILE_CQE 1
>  #define NET_DIM_DEF_PROFILE_EQE 1
> =20
> +#define DIM_CQ_MODER(u, p, c, m) { \
> +	.usec =3D (u),		   \
> +	.pkts =3D (p),		   \
> +	.comps =3D (c),		   \
> +	.cq_period_mode =3D (m)	   \
> +}
> +
>  #define NET_DIM_RX_EQE_PROFILES { \
> -	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> -	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> -	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> -	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> -	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
> +	DIM_CQ_MODER(1,   NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
> +	DIM_CQ_MODER(8,   NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
> +	DIM_CQ_MODER(64,  NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
> +	DIM_CQ_MODER(128, NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
> +	DIM_CQ_MODER(256, NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0)  \
>  }

That may give people the false impression that we always have=20
to initialize all the fields to appease W=3D2. The most common
way of fixing this warning is to tell the compiler that we know
what we're doing and add a comma after the last member:

-	{2,  256},             \
+	{2,  256,},             \

The commit message needs to at least discuss why this direction=20
was not taken. My preference would actually be to do it, tho.

Also please CC maintainers and authors of patches under Fixes:.
