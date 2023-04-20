Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D084E6E9A5F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjDTRN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDTRN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DB130DD
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD16E64A0A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 17:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B59AC4339B;
        Thu, 20 Apr 2023 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682010804;
        bh=oURqK4gBUAmEYzC7EMI2Y8FuMJ0+2W75yTvCc+G3SeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bvUPYGj83yiWeg6d69rXAXPZzuiuTnSnv59roM9JRtdNZsYPokWL+6sR7AWHX1EQj
         1A99EkY8oW7XGjii4P50YZS5nxSFR80pueSGgsuLzRgAtgDIa4DwA2Gfh+zoAwVpTW
         ALa0TBHXHjmW7PtRrK7BNclGUf1XoV21SNWiB2/z+TF4JxC4ExfY0NL5EfzjhWeUo1
         SG9KGK/fx1Yp4L4TBaTQjhPT1Zy2yVkOcQ6YU45vdJ8msiIs9otxdAujYlhO9mMuOH
         uZbSBF8/q0lKhGncs3rVo/hlzbDAFX7PBbS0UF558M7fzTtJ2YZ4lUPSLPET+zTely
         MzSOpqtk0GbsQ==
Date:   Thu, 20 Apr 2023 20:13:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 3/5] net/mlx5e: Compare all fields in IPv6
 address
Message-ID: <20230420171319.GE4423@unreal>
References: <cover.1681976818.git.leon@kernel.org>
 <269e24dc9fb30549d4f77895532603734f515650.1681976818.git.leon@kernel.org>
 <ZEEdY+qtAQQaFbZP@corigine.com>
 <20230420115243.GC4423@unreal>
 <ZEEqbUinuteJ148u@corigine.com>
 <ZEFNyb4zAA/2rh9s@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEFNyb4zAA/2rh9s@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:35:53PM +0200, Simon Horman wrote:
> On Thu, Apr 20, 2023 at 02:05:01PM +0200, Simon Horman wrote:
> > On Thu, Apr 20, 2023 at 02:52:43PM +0300, Leon Romanovsky wrote:
> > > On Thu, Apr 20, 2023 at 01:09:23PM +0200, Simon Horman wrote:
> > > > On Thu, Apr 20, 2023 at 11:02:49AM +0300, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > 
> > > > > Fix size argument in memcmp to compare whole IPv6 address.
> > > > > 
> > > > > Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
> > > > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > > > Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
> > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > ---
> > > > >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > > index f7f7c09d2b32..4e9887171508 100644
> > > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > > > > @@ -287,7 +287,7 @@ static inline bool addr6_all_zero(__be32 *addr6)
> > > > >  {
> > > > >  	static const __be32 zaddr6[4] = {};
> > > > >  
> > > > > -	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
> > > > > +	return !memcmp(addr6, zaddr6, sizeof(zaddr6));
> > > > 
> > > > 1. Perhaps array_size() is appropriate here?
> > > 
> > > It is overkill here, sizeof(zaddr6) is constant and can't overflow.
> > 
> > Maybe, but the original code had a bug because using sizeof()
> > directly is error prone.
> 
> Sorry, just to clarify.
> I now realise that ARRAY_SIZE() is what I meant to suggest earlier.

ARRAY_SIZE(zaddr6) will give us 4, so we will need to multiple in
sizeof(__be32) to get the right result (16 bytes).

sizeof(zaddr6) == ARRAY_SIZE(zaddr6) * sizeof(__be32)

Thanks
