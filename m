Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4AB139169
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgAMMvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:51:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:44914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgAMMvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 07:51:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CEAC2ACC9;
        Mon, 13 Jan 2020 12:51:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 28CC0E3C1F; Mon, 13 Jan 2020 13:51:29 +0100 (CET)
Date:   Mon, 13 Jan 2020 13:51:29 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>, davem@davemloft.ne,
        jeffrey.t.kirsher@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Li RongQing <lirongqing@baidu.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ethtool: Call begin() and complete() in
 __ethtool_get_link_ksettings()
Message-ID: <20200113125129.GD25361@unicorn.suse.cz>
References: <20200110074159.18473-1-kai.heng.feng@canonical.com>
 <20200110074159.18473-2-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110074159.18473-2-kai.heng.feng@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 03:41:59PM +0800, Kai-Heng Feng wrote:
> Device like igb gets runtime suspended when there's no link partner. We
> can't get correct speed under that state:
> $ cat /sys/class/net/enp3s0/speed
> 1000
> 
> In addition to that, an error can also be spotted in dmesg:
> [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
> 
> It's because the igb device doesn't get runtime resumed before calling
> get_link_ksettings().
> 
> So let's call begin() and complete() like what dev_ethtool() does, to
> runtime resume/suspend or power up/down the device properly.
> 
> Once this fix is in place, igb can show the speed correctly without link
> partner:
> $ cat /sys/class/net/enp3s0/speed
> -1

I agree that we definitely should make sure ->begin() and ->complete()
are always called around ethtool_ops calls. But even if nesting should
be safe now (for in-tree drivers, that is), I'm not really happy about
calling them even in places where we positively know we are always
inside a begin / complete block as e.g. vxlan or net_failover do. (And
also linkinfo.c and linkmodes.c but it may be easier to call
->get_link_ksettings() directly there.)

How about having two helpers: one simple for "ethtool context" where we
know we already are between ->begin() and ->complete() and one with the
begin/complete calls for the rest? Another interesting question is if
any of the callers which do not have their own begin()/complete() wrap
does actually need anything more than speed and duplex (I didn't do
a full check).

Michal

> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  net/ethtool/ioctl.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 182bffbffa78..c768dbf45fc4 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -423,13 +423,26 @@ struct ethtool_link_usettings {
>  int __ethtool_get_link_ksettings(struct net_device *dev,
>  				 struct ethtool_link_ksettings *link_ksettings)
>  {
> +	int rc;
> +
>  	ASSERT_RTNL();
>  
>  	if (!dev->ethtool_ops->get_link_ksettings)
>  		return -EOPNOTSUPP;
>  
> +	if (dev->ethtool_ops->begin) {
> +		rc = dev->ethtool_ops->begin(dev);
> +		if (rc  < 0)
> +			return rc;
> +	}
> +
>  	memset(link_ksettings, 0, sizeof(*link_ksettings));
> -	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
> +	rc = dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
> +
> +	if (dev->ethtool_ops->complete)
> +		dev->ethtool_ops->complete(dev);
> +
> +	return rc;
>  }
>  EXPORT_SYMBOL(__ethtool_get_link_ksettings);
>  
> -- 
> 2.17.1
> 
