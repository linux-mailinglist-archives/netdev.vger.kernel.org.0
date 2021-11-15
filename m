Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06FC451492
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345211AbhKOUKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245059AbhKOTTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4CB6634FC;
        Mon, 15 Nov 2021 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637000859;
        bh=c4rKqolsFa5L4Lhy2KpKzJKmcv9pZ2S6SqbkLfJgsys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bfrtgOkT6rk/zJPMp85nDy1Qym1+h15FXKghT1m5nWHBFSjYlzG/de+3s9iyd0p9Q
         IQ9msohxZq/V0g+mxJmZW8LYXXyQUxnLHqMHubX+Scd+9NheoBQboAf3UhzDbqO7D3
         UEiBY2u5xlElpNtnMIRJ3LPWo0fhWlt0GHsV7Nsgd+pFCclMMrPbiV003jXSxr3xK2
         /so8YLYBi5/g/bZT7VAVdfs+itRACtGb/uZqzLhFrrarhE4UaMbfraj1qetaDWFoQW
         WD/nP5TfIN8P+bWkB4Supd6VDP5El8ngDdCjCLB4eEhZU/3hMx7bU9YVSKHQdSbwTh
         HYrRqNpJ6qLVw==
Date:   Mon, 15 Nov 2021 20:27:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] devlink: Remove extra assertion from flash
 notification logic
Message-ID: <YZKmlzhu0gtKpvXW@unreal>
References: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
 <20211115101437.33bd531f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115101437.33bd531f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 10:14:37AM -0800, Jakub Kicinski wrote:
> On Mon, 15 Nov 2021 20:07:47 +0200 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The mlxsw driver calls to various devlink flash routines even before
> > users can get any access to the devlink instance itself. For example,
> > mlxsw_core_fw_rev_validate() one of such functions.
> > 
> > It causes to the WARN_ON to trigger warning about devlink not
> > registered, while the flow is valid.
> 
> So the fix is to remove the warning and keep generating notifications
> about objects which to the best understanding of the user space do not
> exist?

If we delay this mlxsw specific notification, the user will get
DEVLINK_CMD_FLASH_UPDATE and DEVLINK_CMD_FLASH_UPDATE_END at the
same time. I didn't like this, probably users won't like it either,
so decided to go with less invasive solution as possible.

Thanks

> 
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 5ba4f9434acd..6face738b16a 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -4229,7 +4229,6 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
> >  	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
> >  		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
> >  		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
> > -	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
> >  
> >  	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >  	if (!msg)
> 
