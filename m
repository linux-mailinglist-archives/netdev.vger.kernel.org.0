Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6132C1703DD
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgBZQMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:12:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:37604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgBZQMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 11:12:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D64CCAE2B;
        Wed, 26 Feb 2020 16:12:48 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 208E8E2FD5; Wed, 26 Feb 2020 17:12:48 +0100 (CET)
Date:   Wed, 26 Feb 2020 17:12:48 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Cris Forno <cforno12@linux.vnet.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH, net-next, v6, 1/2] ethtool: Factored out similar ethtool
 link settings for virtual devices to core
Message-ID: <20200226161248.GC22401@unicorn.suse.cz>
References: <20200225214111.4135-1-cforno12@linux.vnet.ibm.com>
 <20200225214111.4135-2-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225214111.4135-2-cforno12@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 03:41:10PM -0600, Cris Forno wrote:
> Three virtual devices (ibmveth, virtio_net, and netvsc) all have
> similar code to get link settings and validate ethtool command. To
> eliminate duplication of code, it is factored out into core/ethtool.c.
> 
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
[...]
> +int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
> +				       const struct ethtool_link_ksettings *cmd,
> +				       u32 *dev_speed, u8 *dev_duplex,
> +				       bool (*dev_virtdev_validate_cmd)
> +				       (const struct ethtool_link_ksettings *))
> +{
> +	bool (*validate)(const struct ethtool_link_ksettings *);
> +	u32 speed;
> +	u8 duplex;
> +
> +	validate = dev_virtdev_validate_cmd ?: ethtool_virtdev_validate_cmd;
> +	speed = cmd->base.speed;
> +	duplex = cmd->base.duplex;
> +	/* don't allow custom speed and duplex */
> +	if (!ethtool_validate_speed(speed) ||
> +	    !ethtool_validate_duplex(duplex) ||
> +	    !(*validate)(cmd))
> +		return -EINVAL;
> +	*dev_speed = speed;
> +	*dev_duplex = duplex;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ethtool_virtdev_set_link_ksettings);

I didn't realize it when I asked about netvsc_validate_ethtool_ss_cmd() 
while reviewing v5 but after you got rid of it, all three callers of
ethtool_virtdev_set_link_ksettings() call it with NULL as validator,
i.e. use the default ethtool_virtdev_validate_cmd().

This brings a question if we really need the possibility to provide
a custom validator function. Do you think we should expect some driver
needing a custom validator function soon? If not, we should probably use
the default validation unconditionally for now and only add the option
to provide custom validator function when (if) there is use for it.

Michal
