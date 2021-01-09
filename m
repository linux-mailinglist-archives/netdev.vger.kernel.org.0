Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988582EFCC9
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 02:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAIBnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 20:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAIBnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 20:43:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3003F23A79;
        Sat,  9 Jan 2021 01:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610156582;
        bh=pJwMrQJRE12fxl4ZGrJsZ3VpleKY3qI5hkQXV3HljjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Js7Dd2hu4B3Uj+abW12mLB84hCxq6KGDIH3geAQP0eef+h+mxYiBsoNNNTjYTV9HT
         eyGlmkMIFYAZaj+hxX4uf9wMqzP+RigByw2Vchb5kcGkZ++SuzLZIQz1EI9/dqj9TJ
         ctgxw7Dxrfz0nEv7w3CgiSKXvZ+j/wwWT5I796FZSh39bgRovENmyc0NlEbS4b/oC0
         mtDyTUg9flqfm1g74oUJZOOWM1i3YI35AB2Va9m1/ckDr6XnEuwVs3BohL/k2kDF/O
         EfLDZXsao82aJqw4bQenTL503IzM2DF3bnieOcrv+lenfGmW8UshV4D2Ry0kkqpH5E
         HReYVD5DgRI/w==
Date:   Fri, 8 Jan 2021 17:43:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v5 net-next 15/16] net: bonding: ensure .ndo_get_stats64
 can sleep
Message-ID: <20210108174300.6bd0082f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108163159.358043-16-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
        <20210108163159.358043-16-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse says that you...

On Fri,  8 Jan 2021 18:31:58 +0200 Vladimir Oltean wrote:
> +	rcu_read_lock();
> +
> +	bond_for_each_slave_rcu(bond, slave, iter) {
> +		struct bonding_slave_dev *s;
> +
> +		s = kzalloc(sizeof(*s), GFP_ATOMIC);
> +		if (!s) {
> +			rcu_read_unlock();

..unlock..

> +			bond_put_slaves(slaves);
> +			break;
> +		}
> +
> +		s->ndev = slave->dev;
> +		dev_hold(s->ndev);
> +		list_add_tail(&s->list, slaves);
> +		(*num_slaves)++;
> +	}
> +
> +	rcu_read_unlock();

..twice:

drivers/net/bonding/bond_main.c: note: in included file (...):
include/linux/rcupdate.h:700:9: warning: context imbalance in 'bond_get_stats' - unexpected unlock
