Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A60BC2232
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbfI3Nia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:38:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730266AbfI3Nia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 09:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6HWsDLNMnB4aAwH+pLe7bo6EFz7DNwMADmVFpQIl97o=; b=k0kSW7W6Usm4lkpQmZVuHYnfkn
        pvpolDDcU6xv+Abbo7HK35qI7+3dvG/9x3T26ZoHF3FzP4tiqQC1gj9JROsSni6JTBb8pDDgnQHN1
        9HojC7HVSgLevKy/HEfZeBFVJXxu6clhFULUztN1ZyzZZMr02H0u5sBlvtKvTXmtkEEQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iEvse-0003tf-A0; Mon, 30 Sep 2019 15:38:24 +0200
Date:   Mon, 30 Sep 2019 15:38:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        pabeni@redhat.com, edumazet@google.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/3] net: introduce per-netns netdevice notifiers
Message-ID: <20190930133824.GA14745@lunn.ch>
References: <20190930081511.26915-1-jiri@resnulli.us>
 <20190930081511.26915-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930081511.26915-3-jiri@resnulli.us>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int call_netdevice_notifiers_info(unsigned long val,
>  					 struct netdev_notifier_info *info)
>  {
> +	struct net *net = dev_net(info->dev);
> +	int ret;
> +
>  	ASSERT_RTNL();
> +
> +	/* Run per-netns notifier block chain first, then run the global one.
> +	 * Hopefully, one day, the global one is going to be removed after
> +	 * all notifier block registrators get converted to be per-netns.
> +	 */

Hi Jiri

Is that really going to happen? register_netdevice_notifier() is used
in 130 files. Do you plan to spend the time to make it happen?

> +	ret = raw_notifier_call_chain(&net->netdev_chain, val, info);
> +	if (ret & NOTIFY_STOP_MASK)
> +		return ret;
>  	return raw_notifier_call_chain(&netdev_chain, val, info);
>  }

Humm. I wonder about NOTIFY_STOP_MASK here. These are two separate
chains. Should one chain be able to stop the other chain? Are there
other examples where NOTIFY_STOP_MASK crosses a chain boundary?

      Andrew
