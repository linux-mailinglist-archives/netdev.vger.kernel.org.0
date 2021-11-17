Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F9B4548FE
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbhKQOmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238655AbhKQOmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:42:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B21F96124B;
        Wed, 17 Nov 2021 14:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637159942;
        bh=Db5LuXyV7FsdYpqpBp+dzu9KUBKDuvEDZF/trZmGGhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQZUhZCOSp6dErS4rmYlLFIDY3Aoj5uw/qdd3MB32AEdInue5ex99iIgqZIzhct3/
         JDdXd7iaMFFzOpIXpOzBuwWRiBrsyyMQ1j69UdUdxk7NLhX0vRndqepf5Mgr1F/7WF
         AXAya9Y2n50qsED/2s1kTM0/9n9r+0XxMM8cwPkgA2pRzDvCh8TkgfVAP2jrKVocPA
         9tZBfjPvj1qkRul/GvPWLzbQ704D1bjJLcmuvBAq4reu8MB9+6bco8AiVbRiM4AOcm
         WwPV5NzxPsnh4mnoSCVP9SuXW51dxbCpgi7D58+8+NL2Z1Yg+oDh11svRApzyRnWt5
         VUlK42elF0DLg==
Date:   Wed, 17 Nov 2021 16:38:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] devlink: Remove extra assertion from flash
 notification logic
Message-ID: <YZUUAszdQ8jiZE10@unreal>
References: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
 <20211115101437.33bd531f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZKmlzhu0gtKpvXW@unreal>
 <20211115171530.432f5753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZUCRk8nz1rnnRRL@unreal>
 <20211117060228.65947629@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117060228.65947629@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 06:02:28AM -0800, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 15:23:18 +0200 Leon Romanovsky wrote:
> > > I'd drop these notifications, the user didn't ask to flash the device,
> > > it's just code reuse in the driver, right?  
> > 
> > Sorry, I missed your reply.
> > 
> > I'm not sure about code reuse, from the code, it looks like attempt to
> > burn FW during mlxsw register.
> > 
> > __mlxsw_core_bus_device_register
> >  -> mlxsw_core_fw_rev_validate
> >   -> mlxsw_core_fw_flash
> >    -> mlxfw_firmware_flash
> >     -> mlxfw_status_notify
> >      -> devlink_flash_update_status_notify
> >       -> __devlink_flash_update_notify
> >        -> WARN_ON(...)  
> > 
> > The mlxfw_firmware_flash() routine is called by mlx5 too, so I can't
> > remove mlxfw_status_notify() calls without too much changes.
> > 
> > Easiest solution was to remove WARN_ON(), because no one really
> > interested in these events anyway. I searched in github and didn't
> > find any user who listened to them.
> 
> Drop in the core. Like this?

Of course, sorry for overlooking of such simple solution.
I'm sending new version right now.

Thanks

> 
> 
>  	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
>  		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
>  		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
> -	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
> +
> +	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
> +		return;
>  
>  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!msg)
