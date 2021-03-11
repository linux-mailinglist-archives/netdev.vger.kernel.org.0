Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE213379CE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhCKQpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:45:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhCKQpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:45:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F2264FA7;
        Thu, 11 Mar 2021 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615481104;
        bh=EXpi1LOxV+xj3fzXv+kV9gwkiBBydCLwnB5P7s0smHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HxbsPwE9ANzDBI/bZ6Ua9jqd52csVeOtmJFyAWc7375NJd3E12wm2fcL8kS7SdS7c
         6eIOiVcH7XTEzWTwd8zVLnd3X07uHlT8dyMbi3LOoiLvT+wE1CCMi8LJIMFfcXYEu3
         glhByyJa9IbW1CHr5FlI0zeGE4x90dBrsNUi2ObN+yiwdOXNJEyzBPkSXRucZ1V/JB
         eeopcQh3Xb47HArstGK2/A5yf+gWoSgXibUL3GhZ1BbrflxIS5nOSHVHlwH5Wx3Dzj
         wvVVJ/EP/EUI3WULZauwKRpq2zNT2BxpoUcSAHHMvVNaCI5dFuW3LP+ZnyM4aWWSM9
         iBOXiO7yD6oAw==
Date:   Thu, 11 Mar 2021 08:45:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
Subject: Re: [RFC net-next v2 2/3] devlink: health: add remediation type
Message-ID: <20210311084502.40c146d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <53f182d0-e1f6-5e18-ac04-ff7f6ec56af8@nvidia.com>
References: <20210311032613.1533100-1-kuba@kernel.org>
        <20210311032613.1533100-2-kuba@kernel.org>
        <53f182d0-e1f6-5e18-ac04-ff7f6ec56af8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 16:32:44 +0200 Eran Ben Elisha wrote:
> > +/**
> > + * enum devlink_health_reporter_remedy - severity of remediation procedure
> > + * @DL_HEALTH_REMEDY_NONE: transient error, no remediation required
> > + * @DL_HEALTH_REMEDY_KICK: device stalled, processing will be re-triggered
> > + * @DL_HEALTH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
> > + *			will be reset
> > + * @DL_HEALTH_REMEDY_RESET: full device reset, will result in temporary
> > + *			unavailability of the device, device configuration
> > + *			should not be lost
> > + * @DL_HEALTH_REMEDY_REINIT: device will be reinitialized and configuration lost
> > + *
> > + * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
> > + * by the severity of the remediation.
> > + */
> > +enum devlink_health_remedy {
> > +	DL_HEALTH_REMEDY_NONE = 1,  
> 
> What is the reason zero is skipped?
> 
> > +	DL_HEALTH_REMEDY_KICK,
> > +	DL_HEALTH_REMEDY_COMP_RESET,
> > +	DL_HEALTH_REMEDY_RESET,
> > +	DL_HEALTH_REMEDY_REINIT,
> > +};
> > +
> >   #endif /* _UAPI_LINUX_DEVLINK_H_ */
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 8e4e4bd7bb36..09d77d43ff63 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
> >   {
> >   	struct devlink_health_reporter *reporter;
> >   
> > -	if (WARN_ON(graceful_period && !ops->recover))
> > +	if (WARN_ON(graceful_period && !ops->recover) ||
> > +	    WARN_ON(ops->recover && !ops->remedy))  
> 
> It allows drivers to set recover callback and report DL_HEALTH_REMEDY_NONE.
> Defining DL_HEALTH_REMEDY_NONE = 0  would make this if clause to catch it.

I was intending for "none" to mean no remediation from the driver side.
E.g. device sees bad descriptor and tosses it away. 

That's different from cases where remediation is fully manual.

I will improve the kdoc.
