Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DDC21DDD2
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgGMQrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:47:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbgGMQrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 12:47:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jv1c0-004tPm-Cx; Mon, 13 Jul 2020 18:47:28 +0200
Date:   Mon, 13 Jul 2020 18:47:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, xiyou.wangcong@gmail.com,
        ap420073@gmail.com
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to get
 rid of lockdep warnings
Message-ID: <20200713164728.GH1078057@lunn.ch>
References: <20200713162443.2510682-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713162443.2510682-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 743caabeaaa6..a951b2a7d79a 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1994,6 +1994,13 @@ int dsa_slave_create(struct dsa_port *port)
>  			   ret, slave_dev->name);
>  		goto out_phy;
>  	}
> +	rtnl_lock();
> +	ret = netdev_upper_dev_link(master, slave_dev, NULL);
> +	rtnl_unlock();
> +	if (ret) {
> +		unregister_netdevice(slave_dev);
> +		goto out_phy;
> +	}

Hi Vladimir

A common pattern we see in bugs is that the driver sets up something
critical after calling register_netdev(), not realising that that call
can go off and really start using the interface before it returns. So
in general, i like to have register_netdev() last, nothing after it.

Please could you move this before register_netdev().

Thanks
	Andrew
