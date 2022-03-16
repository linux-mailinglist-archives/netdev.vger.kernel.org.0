Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40704DAC83
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344268AbiCPIfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiCPIfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:35:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B933ED01
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:34:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4BDF61452
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F2AC340F2;
        Wed, 16 Mar 2022 08:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647419676;
        bh=/v6gVeNQGXnpppk/i03o8W+2ubxsawmfINTVhMw98is=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NM8Te1YS84sTAdCvST5G1j6oSadUHwg2dVE4idcLzHJ+hlW2N2BFZVWuGm5hsFhf7
         5Avughw1GGecR6UahmeBIgRNNua51f87FWGSmFwlk1XV0563aINOYIVwpsGVloIimC
         vitk+mlfPBSJJCnx3xdnJOPjgDQdq20qjJ1am3u8shmlLJIENjWGo+gDsl8UE3CfNK
         3a89eP/u1va7b7A/i0r4+6nZzrqhjZyGMopUGFriMlf41hLCVV/Ro+t4aSgFXHC5Xj
         BE1j7jJ9xdeUnvifb4ZdePKztVP+gM9qJAWLeDoiBVKNN3BrWv3CjIUpYRVKSfaR0K
         OiL6TWm7Q/LTg==
Date:   Wed, 16 Mar 2022 10:34:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com
Subject: Re: [PATCH net-next 3/6] eth: nfp: replace driver's "pf" lock with
 devlink instance lock
Message-ID: <YjGhF2AYAq/XNh+F@unreal>
References: <20220315060009.1028519-1-kuba@kernel.org>
 <20220315060009.1028519-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315060009.1028519-4-kuba@kernel.org>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:00:06PM -0700, Jakub Kicinski wrote:
> The whole reason for existence of the pf mutex is that we could
> not lock the devlink instance around port splitting. There are
> more types of reconfig which can make ports appear or disappear.
> Now that the devlink instance lock is exposed to drivers and
> "locked" helpers exist we can switch to using the devlink lock
> directly.
> 
> Next patches will move the locking inside .port_(un)split to
> the core.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_app.h  | 11 +++---
>  .../net/ethernet/netronome/nfp/nfp_devlink.c  | 16 ++++-----
>  drivers/net/ethernet/netronome/nfp/nfp_main.c | 19 ++++++-----
>  drivers/net/ethernet/netronome/nfp/nfp_main.h |  6 ++--
>  .../net/ethernet/netronome/nfp/nfp_net_main.c | 34 +++++++++++--------
>  drivers/net/ethernet/netronome/nfp/nfp_port.c |  3 +-
>  6 files changed, 48 insertions(+), 41 deletions(-)

<...>

> -#define nfp_app_is_locked(app)	lockdep_is_held(&(app)->pf->lock)
> +static inline bool nfp_app_is_locked(struct nfp_app *app)
> +{
> +	return devl_lock_is_held(priv_to_devlink(app->pf));
> +}

Does it compile if you set CONFIG_LOCKDEP=n?

Thanks
