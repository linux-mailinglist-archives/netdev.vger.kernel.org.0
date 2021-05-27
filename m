Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF88392390
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhE0AIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234764AbhE0AIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:08:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E78776109E;
        Thu, 27 May 2021 00:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622073958;
        bh=UxD7gWGIQ0bdUuRoFV0swefHZfutmaB4wZBdJZ9oo8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rh33W4LrVIcjKRW/Std95AQrmx9Q1IRbTkiH33erP/LuFJ6MCLkFXyLLt8MTkifSX
         BXpQ0cDkalfZXXxorbTgkVzv96hdUtcSUl2w/baVVrnICM93EcqwKLD4ktFdsrFLtI
         AD/c1I/roe+t9jKtYXZxeuFryShcT41gGDFI5Wt/kuXoIWYCtrzu7N4pU6xGB45c3y
         prKqOuP/dPkd7y3VhgWNsQFRlb/uv0F8Lh95aLIaUnIRJd3Y1yOR3pujkk4jLzh9VU
         lRLJsBWjgBU/PiUxggJkRaTJYsRy+WL0BHvFjY7JP5QtAGTP5MmSlLNrDYZsMGGLOH
         wH/4U/9zEAGEA==
Date:   Wed, 26 May 2021 17:05:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com
Subject: Re: [patch net-next] devlink: append split port number to the port
 name
Message-ID: <20210526170556.31336a06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526103508.760849-1-jiri@resnulli.us>
References: <20210526103508.760849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 12:35:08 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Instead of doing sprintf twice in case the port is split or not, append
> the split port suffix in case the port is split.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 06b2b1941dce..c7754c293010 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -8632,12 +8632,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>  	switch (attrs->flavour) {
>  	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
>  	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
> -		if (!attrs->split)
> -			n = snprintf(name, len, "p%u", attrs->phys.port_number);
> -		else
> -			n = snprintf(name, len, "p%us%u",
> -				     attrs->phys.port_number,
> -				     attrs->phys.split_subport_number);
> +		n = snprintf(name, len, "p%u", attrs->phys.port_number);

snprintf() can return n > len, you need to check for this before
passing len - n as an unsigned argument below.

> +		if (attrs->split)
> +			n += snprintf(name + n, len - n, "s%u",
> +				      attrs->phys.split_subport_number);
>  		break;
>  	case DEVLINK_PORT_FLAVOUR_CPU:
>  	case DEVLINK_PORT_FLAVOUR_DSA:

