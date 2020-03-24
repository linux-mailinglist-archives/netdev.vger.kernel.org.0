Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8481819113D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCXNeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:34:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:51922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgCXNeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:34:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 85979AC6C;
        Tue, 24 Mar 2020 13:34:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id BA75DE0FD3; Tue, 24 Mar 2020 14:34:12 +0100 (CET)
Date:   Tue, 24 Mar 2020 14:34:12 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Vladyslav Tarasiuk <vladyslavt@mellanox.com>, davem@davemloft.net,
        maximmi@mellanox.com, moshe@mellanox.com
Subject: Re: [PATCH net-next] ethtool: fix incorrect tx-checksumming settings
 reporting
Message-ID: <20200324133412.GO31519@unicorn.suse.cz>
References: <20200324115708.31186-1-vladyslavt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324115708.31186-1-vladyslavt@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 01:57:08PM +0200, Vladyslav Tarasiuk wrote:
> Currently, ethtool feature mask for checksum command is ORed with
> NETIF_F_FCOE_CRC_BIT, which is bit's position number, instead of the
> actual feature bit - NETIF_F_FCOE_CRC.
> 
> The invalid bitmask here might affect unrelated features when toggling
> TX checksumming. For example, TX checksumming is always mistakenly
> reported as enabled on the netdevs tested (mlx5, virtio_net).
> 
> Fixes: f70bb06563ed ("ethtool: update mapping of features to legacy ioctl requests")
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> ---

Stupid mistake... sorry for that. I even realized now how I managed to
miss it when I tested the patch: out of habit, I ran patched ethtool
which used netlink so that it did not call this function at all and
showed expected results. :-(

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

>  net/ethtool/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 3852a58d7f95..10d929abdf6a 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -196,7 +196,7 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
>  	switch (eth_cmd) {
>  	case ETHTOOL_GTXCSUM:
>  	case ETHTOOL_STXCSUM:
> -		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC_BIT |
> +		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC |
>  		       NETIF_F_SCTP_CRC;
>  	case ETHTOOL_GRXCSUM:
>  	case ETHTOOL_SRXCSUM:
> -- 
> 2.17.1
> 
