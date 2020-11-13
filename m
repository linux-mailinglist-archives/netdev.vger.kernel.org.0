Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC7F2B1A88
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgKMMD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:03:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:45066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgKMLpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 06:45:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2A544AC23;
        Fri, 13 Nov 2020 11:45:23 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D1432603A0; Fri, 13 Nov 2020 12:45:22 +0100 (CET)
Date:   Fri, 13 Nov 2020 12:45:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] netdevsim: support ethtool ring and
 coalesce settings
Message-ID: <20201113114522.pn5ap6m4a2aqoz2j@lion.mk-sys.cz>
References: <20201112151229.1288504-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112151229.1288504-1-acardace@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:12:29PM +0100, Antonio Cardace wrote:
> Add ethtool ring and coalesce settings support for testing.
> 
> Signed-off-by: Antonio Cardace <acardace@redhat.com>
> ---
>  drivers/net/netdevsim/ethtool.c   | 65 +++++++++++++++++++++++++++----
>  drivers/net/netdevsim/netdevsim.h |  9 ++++-
>  2 files changed, 65 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
> index f1884d90a876..25acd3bc1781 100644
> --- a/drivers/net/netdevsim/ethtool.c
> +++ b/drivers/net/netdevsim/ethtool.c
> @@ -7,15 +7,18 @@
>  
>  #include "netdevsim.h"
>  
> +#define UINT32_MAX 0xFFFFFFFFU

We already have U32_MAX in <linux/limits.h>

> +#define ETHTOOL_COALESCE_ALL_PARAMS UINT32_MAX

I would rather prefer this constant to include only bits corresponding
to parameters which actually exist, i.e. either GENMASK(21, 0) or
combination of existing ETHTOOL_COALESCE_* macros. It should probably
be defined in include/linux/ethtool.h then.

[...]
> +static void nsim_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(ring, &ns->ethtool.ring, sizeof(ns->ethtool.ring));
> +}
> +
> +static int nsim_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(&ns->ethtool.ring, ring, sizeof(ns->ethtool.ring));
>  	return 0;
>  }
[...]
>  
> +static void nsim_ethtool_coalesce_init(struct netdevsim *ns)
> +{
> +	ns->ethtool.ring.rx_max_pending = UINT32_MAX;
> +	ns->ethtool.ring.rx_jumbo_max_pending = UINT32_MAX;
> +	ns->ethtool.ring.rx_mini_max_pending = UINT32_MAX;
> +	ns->ethtool.ring.tx_max_pending = UINT32_MAX;
> +}

This way an ETHTOOL_MSG_RINGS_SET request would never fail. It would be
more useful for selftests if the max values were more realistic and
ideally also configurable via debugfs.

Michal
