Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6145471F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237515AbhKQN0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232163AbhKQN0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 08:26:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6815161B1E;
        Wed, 17 Nov 2021 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637155402;
        bh=Nj1uKc2EkifSQan/WNCoa5AVp4mItgc+N2imWgIyhas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s47RPcDC44PhuMahrkT3itzzSrNuE+3Sat8qCsS7AjC2M/RJXasQ2008XVizOEkx9
         7ILMW4LTRokn2HpQJ6Q5aEDByhLUNJwmBRYT0xipSA7tJo+sb5E+yG41t7RxQUmPJl
         Eoavq1qvL8SpYhNZF7/80NXg6YrVxryc664Omzr6mxLnlffFtkTo8litoOEbgaiaBN
         zk1BmjOczAPtjceY3YJJEfqAzmXEM0KqgBOVcQ99czc+TxjKzVRHl49cgnmthdNqI0
         HMGmRTbzXQREpKSHewnvFEOvY2xoc0dRX8KeFw2wxdNjWg5o+ouOO8r7B/JOhm006B
         mN9R1+alGrB/Q==
Date:   Wed, 17 Nov 2021 15:23:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] devlink: Remove extra assertion from flash
 notification logic
Message-ID: <YZUCRk8nz1rnnRRL@unreal>
References: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
 <20211115101437.33bd531f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZKmlzhu0gtKpvXW@unreal>
 <20211115171530.432f5753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115171530.432f5753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 05:15:30PM -0800, Jakub Kicinski wrote:
> On Mon, 15 Nov 2021 20:27:35 +0200 Leon Romanovsky wrote:
> > On Mon, Nov 15, 2021 at 10:14:37AM -0800, Jakub Kicinski wrote:
> > > On Mon, 15 Nov 2021 20:07:47 +0200 Leon Romanovsky wrote:  
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > The mlxsw driver calls to various devlink flash routines even before
> > > > users can get any access to the devlink instance itself. For example,
> > > > mlxsw_core_fw_rev_validate() one of such functions.
> > > > 
> > > > It causes to the WARN_ON to trigger warning about devlink not
> > > > registered, while the flow is valid.  
> > > 
> > > So the fix is to remove the warning and keep generating notifications
> > > about objects which to the best understanding of the user space do not
> > > exist?  
> > 
> > If we delay this mlxsw specific notification, the user will get
> > DEVLINK_CMD_FLASH_UPDATE and DEVLINK_CMD_FLASH_UPDATE_END at the
> > same time. I didn't like this, probably users won't like it either,
> > so decided to go with less invasive solution as possible.
> 
> I'd drop these notifications, the user didn't ask to flash the device,
> it's just code reuse in the driver, right?

Sorry, I missed your reply.

I'm not sure about code reuse, from the code, it looks like attempt to
burn FW during mlxsw register.

__mlxsw_core_bus_device_register
 -> mlxsw_core_fw_rev_validate
  -> mlxsw_core_fw_flash
   -> mlxfw_firmware_flash
    -> mlxfw_status_notify
     -> devlink_flash_update_status_notify
      -> __devlink_flash_update_notify
       -> WARN_ON(...)

The mlxfw_firmware_flash() routine is called by mlx5 too, so I can't
remove mlxfw_status_notify() calls without too much changes.

Easiest solution was to remove WARN_ON(), because no one really
interested in these events anyway. I searched in github and didn't
find any user who listened to them.

Thanks
