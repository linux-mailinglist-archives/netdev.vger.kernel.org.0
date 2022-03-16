Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D7B4DAC75
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347261AbiCPIal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343653AbiCPIaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:30:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA52517FD
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FF7AB81A5E
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B66DC340EE;
        Wed, 16 Mar 2022 08:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647419361;
        bh=HuewrOZ40Q3G4rIerHfXmcBJAYewIatYIshS4rIw54g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZzeiNcziZrylN42zG7jxjZxM05+yKt7Psl87lCtn+kba87PWyMoBdOWFhA9RwJgnL
         aj4wcjliwxqInRV5dkznx0qWAp9UnipELrsNLQ4X+8zUB5r6RaB8rfcOmIx9yAQ/Sg
         nAsSh6ojbOXLK3KqDEwVcVSTfovNE7OJXa/XDEQhDXpB97JY3+sNrnZstaMt+K4Cdw
         nyBCQf20XA8ruohQMsPpGtVEWP2JC8/Gl6zRZComaUDDqhM92ecnE3dX8Sd5h0vjhU
         RqvVGKGgDuZbtwkGjcwmu3EGWQNk2el19a5HhtY9gEekjUr2bLaWm5WI3t6xijiGSM
         UHe5rdjlw+Oaw==
Date:   Wed, 16 Mar 2022 10:29:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com
Subject: Re: [PATCH net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <YjGf3OqijAiqSNE/@unreal>
References: <20220315060009.1028519-1-kuba@kernel.org>
 <20220315060009.1028519-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315060009.1028519-2-kuba@kernel.org>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:00:04PM -0700, Jakub Kicinski wrote:
> It should be familiar and beneficial to expose devlink instance
> lock to the drivers. This way drivers can block devlink from
> calling them during critical sections without breakneck locking.
> 
> Add port helpers, port splitting callbacks will be the first
> target.
> 
> Use 'devl_' prefix for "explicitly locked" API. Initial RFC used
> '__devlink' but that's too much typing.
> 
> devl_lock_is_held() is not defined without lockdep, which is
> the same behavior as lockdep_is_held() itself.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v1: - add a small section to the docs
>     - redo the lockdep ifdef
> ---
>  Documentation/networking/devlink/index.rst | 16 ++++
>  include/net/devlink.h                      | 11 +++
>  net/core/devlink.c                         | 95 ++++++++++++++++------
>  3 files changed, 98 insertions(+), 24 deletions(-)

<...>

> +void devl_assert_locked(struct devlink *devlink)
> +{
> +	lockdep_assert_held(&devlink->lock);
> +}
> +EXPORT_SYMBOL_GPL(devl_assert_locked);
> +
> +#ifdef CONFIG_LOCKDEP
> +/* For use in conjunction with LOCKDEP only e.g. rcu_dereference_protected() */
> +bool devl_lock_is_held(struct devlink *devlink)
> +{
> +	return lockdep_is_held(&devlink->lock);
> +}
> +EXPORT_SYMBOL_GPL(devl_lock_is_held);
> +#endif

Sorry that I'm asking you again same question.
How will this devl_lock_is_held() be used in drivers?

Right now, if I decide to use this function in mlx5 (or in any other driver),
the code will be something like this:

void func(...)
{
   ....
   if (IS_ENABLED(CONFIG_LOCKDEP))
   	if (rcu_dereference_protected(a, devl_lock_is_held(devlink) == b) {
		....
}

The line "if (IS_ENABLED(CONFIG_LOCKDEP))" needs to be in every driver
or it won't compile in release mode.

Thanks
