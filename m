Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A002B8A9B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 05:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgKSEQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 23:16:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKSEQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 23:16:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfbMT-007rUA-A7; Thu, 19 Nov 2020 05:15:57 +0100
Date:   Thu, 19 Nov 2020 05:15:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
Message-ID: <20201119041557.GR1804098@lunn.ch>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 9ca87bc..afd8de2 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -433,6 +433,7 @@ struct ethtool_modinfo {
>   *	a TX interrupt, when the packet rate is above @pkt_rate_high.
>   * @rate_sample_interval: How often to do adaptive coalescing packet rate
>   *	sampling, measured in seconds.  Must not be zero.
> + * @use_dim: Use DIM for IRQ coalescing, if adaptive coalescing is enabled.
>   *
>   * Each pair of (usecs, max_frames) fields specifies that interrupts
>   * should be coalesced until
> @@ -483,6 +484,7 @@ struct ethtool_coalesce {
>  	__u32	tx_coalesce_usecs_high;
>  	__u32	tx_max_coalesced_frames_high;
>  	__u32	rate_sample_interval;
> +	__u32	use_dim;
>  };

You cannot do this.

static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
                                                   void __user *useraddr)
{
        struct ethtool_coalesce coalesce;
        int ret;

        if (!dev->ethtool_ops->set_coalesce)
                return -EOPNOTSUPP;

        if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
                return -EFAULT;

An old ethtool binary is not going to set this extra last byte to
anything meaningful. You cannot tell if you have an old or new user
space, so you have no idea if it put anything into use_dim, or if it
is random junk.

You have to leave the IOCTL interface unchanged, and limit this new
feature to the netlink API.

> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index e2bf36e..e3458d9 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -366,6 +366,7 @@ enum {
>  	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
>  	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
>  	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
> +	ETHTOOL_A_COALESCE_USE_DIM,			/* u8 */

This appears to be a boolean? So /* flag */ would be better. Or do you
think there is scope for a few different algorithms, and an enum would
be better. If so, you should add the enum with the two current
options.

	Andrew
