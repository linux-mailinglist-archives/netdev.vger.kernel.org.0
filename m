Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C5A2FACF8
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388175AbhARVto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:49:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387918AbhARVtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:49:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57AEE22CB1;
        Mon, 18 Jan 2021 21:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611006537;
        bh=u/D3EQa7YtUqoK3OrRwR4wx81dkPRTv7AmjPXlMS6Ug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SC714gzu4Osrd7N/adutIbJtW+nBBgz9dWla91oFT88acKPLFTYa59qAOiJmPmjBH
         NSWV5HR9zgTRWXkjKzTMAPab+Gfe3MQav7IJLAEZp2N8PbRFixWXd4XdmAsTp5B/FW
         XsN3sT1yz2HyOH5xtUtiqD2z++4okW7ie3xpzHbqUjOHr0mmASGGNxbPzn7KHR313Z
         UaOLfboJkGs0el3I/uvwOtS4Du5KQkFlkECDYgsyvUUPx38COtMU9P6ZIBkPkOP9aX
         CYT7JXLoPPKPsZNNqlNw5zUWxvkBvy5iIowwlQNfjEeHk4+33XYgozPgzQLXgKTsBl
         MB+yQbVUAg8TQ==
Date:   Mon, 18 Jan 2021 13:48:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [RESEND PATCH] net: core: devlink: use right genl user_ptr when
 handling port param get/set
Message-ID: <20210118134856.11df03a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118173954.17530-1-vadym.kochan@plvision.eu>
References: <20210118173954.17530-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 19:39:54 +0200 Vadym Kochan wrote:
> From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> Fix incorrect user_ptr dereferencing when handling port param get/set:
> 
>     idx [0] stores the 'struct devlink' pointer;
>     idx [1] stores the 'struct devlink_port' pointer;
> 
> Fixes: f4601dee25d5 ("devlink: Add port param get command")
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> ---
> 1) Fixed plvision.com -> plvision.eu

LGTM, but the fixes tag is wrong:

Fixes: 637989b5d77e ("devlink: Always use user_ptr[0] for devlink and simplify post_doit")

right?

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index ee828e4b1007..738d4344d679 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4146,7 +4146,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
>  static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
>  					      struct genl_info *info)
>  {
> -	struct devlink_port *devlink_port = info->user_ptr[0];
> +	struct devlink_port *devlink_port = info->user_ptr[1];
>  	struct devlink_param_item *param_item;
>  	struct sk_buff *msg;
>  	int err;
> @@ -4175,7 +4175,7 @@ static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
>  static int devlink_nl_cmd_port_param_set_doit(struct sk_buff *skb,
>  					      struct genl_info *info)
>  {
> -	struct devlink_port *devlink_port = info->user_ptr[0];
> +	struct devlink_port *devlink_port = info->user_ptr[1];
>  
>  	return __devlink_nl_cmd_param_set_doit(devlink_port->devlink,
>  					       devlink_port->index,

