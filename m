Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55BF3379FD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhCKQtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhCKQtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:49:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1FE564FEC;
        Thu, 11 Mar 2021 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615481364;
        bh=7Vbgzj85x/apgNtQq0ozYI03LJ3hz8OFnAGJql/BU7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JYkYePsqXtscMrC5YRHkRSIP12rghiudIqaYzNbn/VUWXrgAzEGevjYdsJKKwb12L
         Y2cCGjHVksnEOQS9KYeyuQt0MCD/W4ps6mmkHCwuJwax51II1uiSxIk/ityWmG3A5J
         74pKddjwdDnQwCfe2lZpKsrfcDoj8RInzUmQ6Ex7kRqqtACA1Ku7zrh16Ra18GwSSr
         ZwoA8Wyq3HAaI/sN7MUAqx82UwlgwzI4ea5uZXEp2XSzZI6iON0VjHyfinWDK1neYO
         abl2NJhx4EzSK5qhcUJhT/wQb3fh3/dYFhVOWsZCikuKsH9Kbc4WBZGfD3b/UcgZl1
         U1EoD1NUJEMlg==
Date:   Thu, 11 Mar 2021 08:49:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <f242ed68-d31b-527d-562f-c5a35123861a@intel.com>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [RFC net-next v2 3/3] devlink: add more failure modes
Message-ID: <20210311084922.12bc884b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8d61628c-9ca7-13ac-2dcd-97ecc9378a9e@nvidia.com>
References: <20210311032613.1533100-1-kuba@kernel.org>
        <20210311032613.1533100-3-kuba@kernel.org>
        <8d61628c-9ca7-13ac-2dcd-97ecc9378a9e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 16:23:09 +0200 Eran Ben Elisha wrote:
> On 3/11/2021 5:26 AM, Jakub Kicinski wrote:
> >>> Pending vendors adding the right reporters. <<  
> 
> Would you like Nvidia to reply with the remedy per reporter or to 
> actually prepare the patch?

You mean the patch adding .remedy? If you can that'd be helpful.

Or do you have HW error reporters to add?

> > Extend the applicability of devlink health reporters
> > beyond what can be locally remedied. Add failure modes
> > which require re-flashing the NVM image or HW changes.
> > 
> > The expectation is that driver will call
> > devlink_health_reporter_state_update() to put hardware
> > health reporters into bad state.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >   include/uapi/linux/devlink.h | 7 +++++++
> >   net/core/devlink.c           | 3 +--
> >   2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> > index 8cd1508b525b..f623bbc63489 100644
> > --- a/include/uapi/linux/devlink.h
> > +++ b/include/uapi/linux/devlink.h
> > @@ -617,10 +617,17 @@ enum devlink_port_fn_opstate {
> >    * @DL_HEALTH_STATE_ERROR: error state, running health reporter's recovery
> >    *			may fix the issue, otherwise user needs to try
> >    *			power cycling or other forms of reset
> > + * @DL_HEALTH_STATE_BAD_IMAGE: device's non-volatile memory needs
> > + *			to be re-written, usually due to block corruption
> > + * @DL_HEALTH_STATE_BAD_HW: hardware errors detected, device, host
> > + *			or the connection between the two may be at fault
> >    */
> >   enum devlink_health_state {
> >   	DL_HEALTH_STATE_HEALTHY,
> >   	DL_HEALTH_STATE_ERROR,
> > +
> > +	DL_HEALTH_STATE_BAD_IMAGE,
> > +	DL_HEALTH_STATE_BAD_HW,
> >   };
> >   
> >   /**
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 09d77d43ff63..4a9fa6288a4a 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -6527,8 +6527,7 @@ void
> >   devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
> >   				     enum devlink_health_state state)
> >   {
> > -	if (WARN_ON(state != DL_HEALTH_STATE_HEALTHY &&
> > -		    state != DL_HEALTH_STATE_ERROR))
> > +	if (WARN_ON(state > DL_HEALTH_STATE_BAD_HW))
> >   		return;
> >   
> >   	if (reporter->health_state == state)
> >   
> 
> devlink_health_reporter_recover() requires an update as well.
> something like:
> 
> @@ -6346,8 +6346,15 @@ devlink_health_reporter_recover(struct 
> devlink_health_reporter *reporter,
>   {
>          int err;
> 
> -   if (reporter->health_state == DL_HEALTH_STATE_HEALTHY)
> + switch (reporter->health_state) {
> + case DL_HEALTH_STATE_HEALTHY:
>                  return 0;
> + case DL_HEALTH_STATE_ERROR:
> +         break;
> + case DL_HEALTH_STATE_BAD_IMAGE:
> + case DL_HEALTH_STATE_BAD_HW:
> +         return -EOPNOTSUPP;
> + }
> 
>          if (!reporter->ops->recover)
>                  return -EOPNOTSUPP;
> 

Thanks!
