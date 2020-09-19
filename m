Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D48270B05
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 07:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgISFsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 01:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 01:48:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902D1C0613CE;
        Fri, 18 Sep 2020 22:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=T/EF9iYDehI6xhCxAkipRiS7TE++tGlFRWKaqy0qmVc=; b=jw2+kluGth7FQQN19thw4Hh11C
        XuDJie3yU6KYqIH21tPspP1J2xco9FzaKqqsPsuLyGokpzwLgR4KR3xUuXShUH9joZXB77/+R8YKK
        l6qBeMmYH1ieFHWh8JT+hI+isLmtw4d/y+/25Niut4vCmybyJk7ZkwC8N3gUlaigqwJ31yQ7T8dbR
        /EJ7GNBNugGUMmLBnmogPOUeTNS7vK6UKdWzdb3FUkw+xT8/DsuVsVdNjtgqmVtNTKCxbLn0awNnW
        qcw0vDBFf/HiDiVWilEgKMorP/CPoT4zka6q5gatbJZlF3Bl3QGaGaDh3NgqTkd2Dl3MTEBuKo/s/
        MSQDuP7w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVjb-0001XF-TZ; Sat, 19 Sep 2020 05:48:31 +0000
Date:   Sat, 19 Sep 2020 06:48:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jens Axboe <axboe@kernel.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dev_ioctl: split out SIOC?IFMAP ioctls
Message-ID: <20200919054831.GN30063@infradead.org>
References: <20200918120536.1464804-1-arnd@arndb.de>
 <20200918120536.1464804-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918120536.1464804-2-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> index 797ba2c1562a..a332d6ae4dc6 100644
> --- a/include/uapi/linux/if.h
> +++ b/include/uapi/linux/if.h
> @@ -247,7 +247,13 @@ struct ifreq {
>  		short	ifru_flags;
>  		int	ifru_ivalue;
>  		int	ifru_mtu;
> +#ifndef __KERNEL__
> +		/*
> +		 * ifru_map is rarely used but causes the incompatibility
> +		 * between native and compat mode.
> +		 */
>  		struct  ifmap ifru_map;
> +#endif

Do we need a way to verify that this never changes the struct size?

> +int dev_ifmap(struct net *net, struct ifreq __user *ifr, unsigned int cmd)
> +{
> +	struct net_device *dev;
> +	char ifname[IFNAMSIZ];
> +	char *colon;
> +	struct compat_ifmap cifmap;
> +	struct ifmap ifmap;
> +	int ret;
> +
> +	if (copy_from_user(ifname, ifr->ifr_name, sizeof(ifname)))
> +		return -EFAULT;
> +	ifname[IFNAMSIZ-1] = 0;
> +	colon = strchr(ifname, ':');
> +	if (colon)
> +		*colon = 0;
> +	dev_load(net, ifname);
> +
> +	switch (cmd) {
> +	case SIOCGIFMAP:
> +		rcu_read_lock();
> +		dev = dev_get_by_name_rcu(net, ifname);
> +		if (!dev) {
> +			rcu_read_unlock();
> +			return -ENODEV;
> +		}
> +
> +		if (in_compat_syscall()) {
> +			cifmap.mem_start = dev->mem_start;
> +			cifmap.mem_end   = dev->mem_end;
> +			cifmap.base_addr = dev->base_addr;
> +			cifmap.irq       = dev->irq;
> +			cifmap.dma       = dev->dma;
> +			cifmap.port      = dev->if_port;
> +			rcu_read_unlock();
> +
> +			ret = copy_to_user(&ifr->ifr_data,
> +					   &cifmap, sizeof(cifmap));
> +		} else {
> +			ifmap.mem_start  = dev->mem_start;
> +			ifmap.mem_end    = dev->mem_end;
> +			ifmap.base_addr  = dev->base_addr;
> +			ifmap.irq        = dev->irq;
> +			ifmap.dma        = dev->dma;
> +			ifmap.port       = dev->if_port;
> +			rcu_read_unlock();
> +
> +			ret = copy_to_user(&ifr->ifr_data,
> +					   &ifmap, sizeof(ifmap));
> +		}
> +		ret = ret ? -EFAULT : 0;
> +		break;
> +
> +	case SIOCSIFMAP:
> +		if (!capable(CAP_NET_ADMIN) ||
> +		    !ns_capable(net->user_ns, CAP_NET_ADMIN))
> +			return -EPERM;
> +
> +		if (in_compat_syscall()) {
> +			if (copy_from_user(&cifmap, &ifr->ifr_data,
> +					   sizeof(cifmap)))
> +				return -EFAULT;
> +
> +			ifmap.mem_start  = cifmap.mem_start;
> +			ifmap.mem_end    = cifmap.mem_end;
> +			ifmap.base_addr  = cifmap.base_addr;
> +			ifmap.irq        = cifmap.irq;
> +			ifmap.dma        = cifmap.dma;
> +			ifmap.port       = cifmap.port;
> +		} else {
> +			if (copy_from_user(&ifmap, &ifr->ifr_data,
> +					   sizeof(ifmap)))
> +				return -EFAULT;
> +		}
> +
> +		rtnl_lock();
> +		dev = __dev_get_by_name(net, ifname);
> +		if (!dev || !netif_device_present(dev))
> +			ret = -ENODEV;
> +		else if (!dev->netdev_ops->ndo_set_config)
> +			ret = -EOPNOTSUPP;
> +		else
> +			ret = dev->netdev_ops->ndo_set_config(dev, &ifmap);
> +		rtnl_unlock();
> +		break;
> +	}
> +	return ret;

I'd rather split this into a separate hepers for each ioctl command
instead of having anothr multiplexer here, maybe with another helper
for the common code.

I also find the rcu unlock inside the branches rather strange, but
I can't think of a good alternative.
