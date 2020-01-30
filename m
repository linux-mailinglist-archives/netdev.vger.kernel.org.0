Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E30C14E0D6
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 19:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgA3ScL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 13:32:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:53670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgA3ScL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 13:32:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C83EDAF21;
        Thu, 30 Jan 2020 18:32:08 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7A343E0095; Thu, 30 Jan 2020 19:32:07 +0100 (CET)
Date:   Thu, 30 Jan 2020 19:32:07 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH] netlink: add real_num_[tr]x_queues to ifinfo
Message-ID: <20200130183207.GD20720@unicorn.suse.cz>
References: <20200130175749.GA31391@zeil-osx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130175749.GA31391@zeil-osx>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 08:57:49PM +0300, Dmitry Yakunin wrote:
> This patch adds the number of active tx/rx queues to ifinfo message.
> 
> Now there are two ways of determining the number of active queues:
> 1) by counting entries in /sys/class/net/eth[0-9]+/queues/
> 2) by ioctl syscall if a driver implements ethtool_ops->get_channels()
> 
> Default mq qdisc sets up pfifo_fast only for active queues. So, if we want
> to reproduce this behavior with custom leaf qdiscs, we should use one
> of these methods which are foreign for the code where netlink was used.

Netlink interface for get_channels() and set_channels() ethtool_ops is
one of the first I plan to submit when net-next is open again after the
merge window.

Michal

> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  include/uapi/linux/if_link.h | 2 ++
>  net/core/rtnetlink.c         | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 8aec876..6566b63 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -169,6 +169,8 @@ enum {
>  	IFLA_MAX_MTU,
>  	IFLA_PROP_LIST,
>  	IFLA_ALT_IFNAME, /* Alternative ifname */
> +	IFLA_REAL_NUM_TX_QUEUES,
> +	IFLA_REAL_NUM_RX_QUEUES,
>  	__IFLA_MAX
>  };
>  
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index d9001b5..3ebae18 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1013,7 +1013,9 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
>  	       + nla_total_size(1) /* IFLA_CARRIER */
>  	       + nla_total_size(4) /* IFLA_PROMISCUITY */
>  	       + nla_total_size(4) /* IFLA_NUM_TX_QUEUES */
> +	       + nla_total_size(4) /* IFLA_REAL_NUM_TX_QUEUES */
>  	       + nla_total_size(4) /* IFLA_NUM_RX_QUEUES */
> +	       + nla_total_size(4) /* IFLA_REAL_NUM_RX_QUEUES */
>  	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
>  	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
>  	       + nla_total_size(1) /* IFLA_OPERSTATE */
> @@ -1687,10 +1689,12 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>  	    nla_put_u32(skb, IFLA_GROUP, dev->group) ||
>  	    nla_put_u32(skb, IFLA_PROMISCUITY, dev->promiscuity) ||
>  	    nla_put_u32(skb, IFLA_NUM_TX_QUEUES, dev->num_tx_queues) ||
> +	    nla_put_u32(skb, IFLA_REAL_NUM_TX_QUEUES, dev->real_num_tx_queues) ||
>  	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
>  	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
>  #ifdef CONFIG_RPS
>  	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
> +	    nla_put_u32(skb, IFLA_REAL_NUM_RX_QUEUES, dev->real_num_rx_queues) ||
>  #endif
>  	    put_master_ifindex(skb, dev) ||
>  	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
> @@ -1803,7 +1807,9 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>  	[IFLA_EXT_MASK]		= { .type = NLA_U32 },
>  	[IFLA_PROMISCUITY]	= { .type = NLA_U32 },
>  	[IFLA_NUM_TX_QUEUES]	= { .type = NLA_U32 },
> +	[IFLA_REAL_NUM_TX_QUEUES] = { .type = NLA_U32 },
>  	[IFLA_NUM_RX_QUEUES]	= { .type = NLA_U32 },
> +	[IFLA_REAL_NUM_RX_QUEUES] = { .type = NLA_U32 },
>  	[IFLA_GSO_MAX_SEGS]	= { .type = NLA_U32 },
>  	[IFLA_GSO_MAX_SIZE]	= { .type = NLA_U32 },
>  	[IFLA_PHYS_PORT_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },
> -- 
> 2.7.4
> 
