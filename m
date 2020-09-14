Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90F2697BE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINVdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgINVdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:33:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3E620759;
        Mon, 14 Sep 2020 21:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600119188;
        bh=V+P1X8VC4JsERiUXw7iot+idRi6jC6V9C36vEtjNvyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WgZuChsrB0e4d8z/5eqq6wJtTbFIGPzTLgBvuDy2FLzX9VMg6XQukLIE+nbNYqnyO
         uQnCrmmoi+mKWebxdCDxNSKV78z+fYm11boRbrGeA3N8ANJkLiWuVl+YmDwki+srAI
         X5Hn+R/mJTCg+F5icKwklzpJ7XhtrBp3gpTbYU6I=
Date:   Mon, 14 Sep 2020 14:33:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200914143306.4ab0f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1600063682-17313-2-git-send-email-moshe@mellanox.com>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
        <1600063682-17313-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 09:07:48 +0300 Moshe Shemesh wrote:
> @@ -3011,12 +3060,41 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>  			return PTR_ERR(dest_net);
>  	}
>  
> -	err = devlink_reload(devlink, dest_net, info->extack);
> +	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
> +		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
> +	else
> +		action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
> +
> +	if (action == DEVLINK_RELOAD_ACTION_UNSPEC || action > DEVLINK_RELOAD_ACTION_MAX) {
> +		NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
> +		return -EINVAL;
> +	} else if (!devlink_reload_action_is_supported(devlink, action)) {
> +		NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>  
>  	if (dest_net)
>  		put_net(dest_net);
>  
> -	return err;
> +	if (err)
> +		return err;
> +
> +	WARN_ON(!actions_performed);
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	err = devlink_nl_reload_actions_performed_fill(msg, devlink, actions_performed,
> +						       DEVLINK_CMD_RELOAD, info->snd_portid,
> +						       info->snd_seq, 0);
> +	if (err) {
> +		nlmsg_free(msg);
> +		return err;
> +	}
> +
> +	return genlmsg_reply(msg, info);

I think generating the reply may break existing users. Only generate
the reply if request contained DEVLINK_ATTR_RELOAD_ACTION (or any other
new attribute which existing users can't pass).
