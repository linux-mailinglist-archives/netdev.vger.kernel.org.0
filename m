Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B75645A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFZIRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfFZIRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 04:17:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D326356C4;
        Wed, 26 Jun 2019 08:17:00 +0000 (UTC)
Received: from ovpn-117-198.ams2.redhat.com (ovpn-117-198.ams2.redhat.com [10.36.117.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 676346012E;
        Wed, 26 Jun 2019 08:16:55 +0000 (UTC)
Message-ID: <24fab1f43190f4994e47da4c2fa3fd622cd4e8ca.camel@redhat.com>
Subject: Re: [PATCH net-next] net: ipvlan: forward ingress packet to slave's
 l2 in l3s mode
From:   Paolo Abeni <pabeni@redhat.com>
To:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>, davem@davemloft.net,
        idosch@mellanox.com, daniel@iogearbox.net, petrm@mellanox.com,
        jiri@mellanox.com, tglx@linutronix.de, linmiaohe@huawei.com
Cc:     zhabin@linux.alibaba.com, caspar@linux.alibaba.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 26 Jun 2019 10:16:54 +0200
In-Reply-To: <20190625064208.2256-1-zhiyuan2048@linux.alibaba.com>
References: <20190625064208.2256-1-zhiyuan2048@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 26 Jun 2019 08:17:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2019-06-25 at 14:42 +0800, Zhiyuan Hou wrote:
> In ipvlan l3s mode,  ingress packet is switched to slave interface and
> delivers to l4 stack. This may cause two problems:
> 
>   1. When slave is in an ns different from master, the behavior of stack
>   in slave ns may cause confusion for users. For example, iptables, tc,
>   and other l2/l3 functions are not available for ingress packet.
> 
>   2. l3s mode is not used for tap device, and cannot support ipvtap. But
>   in VM or container based VM cases, tap device is a very common device.
> 
> In l3s mode's input nf_hook, this patch calles the skb_forward_dev() to
> forward ingress packet to slave and uses nf_conntrack_confirm() to make
> conntrack work with new mode.
> 
> Signed-off-by: Zha Bin <zhabin@linux.alibaba.com>
> Signed-off-by: Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
> ---
>  drivers/net/ipvlan/ipvlan.h     |  9 ++++++++-
>  drivers/net/ipvlan/ipvlan_l3s.c | 16 ++++++++++++++--
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
> index 3837c897832e..48c814e24c3f 100644
> --- a/drivers/net/ipvlan/ipvlan.h
> +++ b/drivers/net/ipvlan/ipvlan.h
> @@ -172,6 +172,14 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head);
>  void ipvlan_link_setup(struct net_device *dev);
>  int ipvlan_link_register(struct rtnl_link_ops *ops);
>  #ifdef CONFIG_IPVLAN_L3S
> +
> +#include <net/netfilter/nf_conntrack_core.h>
> +
> +static inline int ipvlan_confirm_conntrack(struct sk_buff *skb)
> +{
> +	return nf_conntrack_confirm(skb);
> +}
> +
>  int ipvlan_l3s_register(struct ipvl_port *port);
>  void ipvlan_l3s_unregister(struct ipvl_port *port);
>  void ipvlan_migrate_l3s_hook(struct net *oldnet, struct net *newnet);
> @@ -206,5 +214,4 @@ static inline bool netif_is_ipvlan_port(const struct net_device *dev)
>  {
>  	return rcu_access_pointer(dev->rx_handler) == ipvlan_handle_frame;
>  }
> -
>  #endif /* __IPVLAN_H */
> diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
> index 943d26cbf39f..ed210002f593 100644
> --- a/drivers/net/ipvlan/ipvlan_l3s.c
> +++ b/drivers/net/ipvlan/ipvlan_l3s.c
> @@ -95,14 +95,26 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
>  {
>  	struct ipvl_addr *addr;
>  	unsigned int len;
> +	int ret = NF_ACCEPT;
> +	bool success;
>  
>  	addr = ipvlan_skb_to_addr(skb, skb->dev);
>  	if (!addr)
>  		goto out;
>  
> -	skb->dev = addr->master->dev;
>  	len = skb->len + ETH_HLEN;
> -	ipvlan_count_rx(addr->master, len, true, false);
> +
> +	ret = ipvlan_confirm_conntrack(skb);
> +	if (ret != NF_ACCEPT) {
> +		ipvlan_count_rx(addr->master, len, false, false);
> +		goto out;
> +	}
> +
> +	skb_push_rcsum(skb, ETH_HLEN);
> +	success = dev_forward_skb(addr->master->dev, skb) == NET_RX_SUCCESS;

This looks weird to me: if I read the code correctly, the skb will
traverse twice NF_INET_LOCAL_IN, once due to the l3s hooking and
another one due to dev_forward_skb().

Also, tc ingreess, etc will run after the first traversing of
NF_INET_LOCAL_IN.

All in all I think that if full l2 processing is required, a different
mode or a different virtual device should be used.

Cheers,

Paolo

