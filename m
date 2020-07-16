Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC4E222ED9
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgGPXPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgGPXPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:15:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 774CD20739;
        Thu, 16 Jul 2020 23:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594940800;
        bh=CiT1mXCUvKIGHdve5TcVmSARGVc9bnAAU90vRE5qTxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bXLTZp1Rb99ZWlg++hfw67PTew09V/pQIxOwAg6dn9dXuy27aILYKP+CrXnNir4FF
         PlGfYjm49ibS9D9ZJKKSRkklUG9ZwsljbwsJpSYeZBibsm4mblGPaPeZzyrUb8sfGC
         jApBDNUJ76wKqn3kswgPQWDa3w08u4jiiVJGVskM=
Date:   Thu, 16 Jul 2020 16:06:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        xiyou.wangcong@gmail.com, ap420073@gmail.com
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to
 get rid of lockdep warnings
Message-ID: <20200716160638.4ddf469f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713162443.2510682-1-olteanv@gmail.com>
References: <20200713162443.2510682-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 19:24:43 +0300 Vladimir Oltean wrote:
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

The error handling here looks sketchy.

First of all please move this unregister to the error path below, not
inside the body of the if.

Secondly as a rule of thumb the error path should resemble the destroy
function.

Here we have :

	unregister_netdevice(slave_dev);
out_phy:
	rtnl_lock();
	phylink_disconnect_phy(p->dp->pl);
	rtnl_unlock();
	phylink_destroy(p->dp->pl);
out_gcells:
	gro_cells_destroy(&p->gcells);
out_free:
	free_percpu(p->stats64);
	free_netdev(slave_dev);
	port->slave = NULL;
	return ret;

vs.

	netif_carrier_off(slave_dev);
	rtnl_lock();
	phylink_disconnect_phy(dp->pl);
	rtnl_unlock();

	dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
	unregister_netdev(slave_dev);
	phylink_destroy(dp->pl);
	gro_cells_destroy(&p->gcells);
	free_percpu(p->stats64);
	free_netdev(slave_dev);


Ordering is different, plus you're missing the dsa_slave_notify() and
netif_carrier_off().

> +		goto out_phy;
> +	}
>  
>  	return 0;
>  
> @@ -2013,11 +2020,13 @@ int dsa_slave_create(struct dsa_port *port)
>  
>  void dsa_slave_destroy(struct net_device *slave_dev)
>  {
> +	struct net_device *master = dsa_slave_to_master(slave_dev);
>  	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
>  	struct dsa_slave_priv *p = netdev_priv(slave_dev);
>  
>  	netif_carrier_off(slave_dev);
>  	rtnl_lock();
> +	netdev_upper_dev_unlink(master, slave_dev);
>  	phylink_disconnect_phy(dp->pl);
>  	rtnl_unlock();
