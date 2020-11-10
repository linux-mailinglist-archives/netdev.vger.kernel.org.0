Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA522AE3E7
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgKJXM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:12:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKJXM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:12:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7781720781;
        Tue, 10 Nov 2020 23:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049977;
        bh=r1XIHDLnVVppsNVdPm6iiEsiEcANo/69NHDTb/ORlHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=czftW3jppBUq/W8daxxIyhaRcc7SXtqcmlPLIH2PrvuRfXPTJB8ZGo5SZyOplip/L
         6ny3b4PwiQcDsK52cr2kOtgtMK5oPdUAEXTcYIffyoZJZHlfHAuNW/DnCBUdDnXMBs
         kxOmEUaJrmnaS/7HqNEpROY75G0jru0HmN1IlNKs=
Date:   Tue, 10 Nov 2020 15:12:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4
 behavior
Message-ID: <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107153139.3552-5-andrea.mayer@uniroma2.it>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-5-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 16:31:38 +0100 Andrea Mayer wrote:
> SRv6 End.DT4 is defined in the SRv6 Network Programming [1].
> 
> The SRv6 End.DT4 is used to implement IPv4 L3VPN use-cases in
> multi-tenants environments. It decapsulates the received packets and it
> performs IPv4 routing lookup in the routing table of the tenant.
> 
> The SRv6 End.DT4 Linux implementation leverages a VRF device in order to
> force the routing lookup into the associated routing table.

How does the behavior of DT4 compare to DT6?

The implementation looks quite different.

> To make the End.DT4 work properly, it must be guaranteed that the routing
> table used for routing lookup operations is bound to one and only one
> VRF during the tunnel creation. Such constraint has to be enforced by
> enabling the VRF strict_mode sysctl parameter, i.e:
>  $ sysctl -wq net.vrf.strict_mode=1.
> 
> At JANOG44, LINE corporation presented their multi-tenant DC architecture
> using SRv6 [2]. In the slides, they reported that the Linux kernel is
> missing the support of SRv6 End.DT4 behavior.
> 
> The iproute2 counterpart required for configuring the SRv6 End.DT4
> behavior is already implemented along with the other supported SRv6
> behaviors [3].
> 
> [1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming
> [2] https://speakerdeck.com/line_developers/line-data-center-networking-with-srv6
> [3] https://patchwork.ozlabs.org/patch/799837/
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 205 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 205 insertions(+)
> 
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index 4b0f155d641d..a41074acd43e 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -57,6 +57,14 @@ struct bpf_lwt_prog {
>  	char *name;
>  };
>  
> +struct seg6_end_dt4_info {
> +	struct net *net;
> +	/* VRF device associated to the routing table used by the SRv6 End.DT4
> +	 * behavior for routing IPv4 packets.
> +	 */
> +	int vrf_ifindex;
> +};
> +
>  struct seg6_local_lwt {
>  	int action;
>  	struct ipv6_sr_hdr *srh;
> @@ -66,6 +74,7 @@ struct seg6_local_lwt {
>  	int iif;
>  	int oif;
>  	struct bpf_lwt_prog bpf;
> +	struct seg6_end_dt4_info dt4_info;
>  
>  	int headroom;
>  	struct seg6_action_desc *desc;
> @@ -413,6 +422,194 @@ static int input_action_end_dx4(struct sk_buff *skb,
>  	return -EINVAL;
>  }
>  
> +#ifdef CONFIG_NET_L3_MASTER_DEV
> +

no need for this empty line.

> +static struct net *fib6_config_get_net(const struct fib6_config *fib6_cfg)
> +{
> +	const struct nl_info *nli = &fib6_cfg->fc_nlinfo;
> +
> +	return nli->nl_net;
> +}
> +
> +static int seg6_end_dt4_build(struct seg6_local_lwt *slwt, const void *cfg,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct seg6_end_dt4_info *info = &slwt->dt4_info;
> +	int vrf_ifindex;
> +	struct net *net;
> +
> +	net = fib6_config_get_net(cfg);
> +
> +	vrf_ifindex = l3mdev_ifindex_lookup_by_table_id(L3MDEV_TYPE_VRF, net,
> +							slwt->table);
> +	if (vrf_ifindex < 0) {
> +		if (vrf_ifindex == -EPERM) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Strict mode for VRF is disabled");
> +		} else if (vrf_ifindex == -ENODEV) {
> +			NL_SET_ERR_MSG(extack, "No such device");

That's what -ENODEV already says.

> +		} else {
> +			NL_SET_ERR_MSG(extack, "Unknown error");

Useless error.

> +			pr_debug("seg6local: SRv6 End.DT4 creation error=%d\n",
> +				 vrf_ifindex);
> +		}
> +
> +		return vrf_ifindex;
> +	}
> +
> +	info->net = net;
> +	info->vrf_ifindex = vrf_ifindex;
> +
> +	return 0;
> +}
> +
> +/* The SRv6 End.DT4 behavior extracts the inner (IPv4) packet and routes the
> + * IPv4 packet by looking at the configured routing table.
> + *
> + * In the SRv6 End.DT4 use case, we can receive traffic (IPv6+Segment Routing
> + * Header packets) from several interfaces and the IPv6 destination address (DA)
> + * is used for retrieving the specific instance of the End.DT4 behavior that
> + * should process the packets.
> + *
> + * However, the inner IPv4 packet is not really bound to any receiving
> + * interface and thus the End.DT4 sets the VRF (associated with the
> + * corresponding routing table) as the *receiving* interface.
> + * In other words, the End.DT4 processes a packet as if it has been received
> + * directly by the VRF (and not by one of its slave devices, if any).
> + * In this way, the VRF interface is used for routing the IPv4 packet in
> + * according to the routing table configured by the End.DT4 instance.
> + *
> + * This design allows you to get some interesting features like:
> + *  1) the statistics on rx packets;
> + *  2) the possibility to install a packet sniffer on the receiving interface
> + *     (the VRF one) for looking at the incoming packets;
> + *  3) the possibility to leverage the netfilter prerouting hook for the inner
> + *     IPv4 packet.
> + *
> + * This function returns:
> + *  - the sk_buff* when the VRF rcv handler has processed the packet correctly;
> + *  - NULL when the skb is consumed by the VRF rcv handler;
> + *  - a pointer which encodes a negative error number in case of error.
> + *    Note that in this case, the function takes care of freeing the skb.
> + */
> +static struct sk_buff *end_dt4_vrf_rcv(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	/* based on l3mdev_ip_rcv; we are only interested in the master */
> +	if (unlikely(!netif_is_l3_master(dev) && !netif_has_l3_rx_handler(dev)))
> +		goto drop;
> +
> +	if (unlikely(!dev->l3mdev_ops->l3mdev_l3_rcv))
> +		goto drop;
> +
> +	/* the decap packet (IPv4) does not come with any mac header info.
> +	 * We must unset the mac header to allow the VRF device to rebuild it,
> +	 * just in case there is a sniffer attached on the device.
> +	 */
> +	skb_unset_mac_header(skb);
> +
> +	skb = dev->l3mdev_ops->l3mdev_l3_rcv(dev, skb, AF_INET);
> +	if (!skb)
> +		/* the skb buffer was consumed by the handler */
> +		return NULL;
> +
> +	/* when a packet is received by a VRF or by one of its slaves, the
> +	 * master device reference is set into the skb.
> +	 */
> +	if (unlikely(skb->dev != dev || skb->skb_iif != dev->ifindex))
> +		goto drop;
> +
> +	return skb;
> +
> +drop:
> +	kfree_skb(skb);
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static struct net_device *end_dt4_get_vrf_rcu(struct sk_buff *skb,
> +					      struct seg6_end_dt4_info *info)
> +{
> +	int vrf_ifindex = info->vrf_ifindex;
> +	struct net *net = info->net;
> +
> +	if (unlikely(vrf_ifindex < 0))
> +		goto error;
> +
> +	if (unlikely(!net_eq(dev_net(skb->dev), net)))
> +		goto error;
> +
> +	return dev_get_by_index_rcu(net, vrf_ifindex);
> +
> +error:
> +	return NULL;
> +}
> +
> +static int input_action_end_dt4(struct sk_buff *skb,
> +				struct seg6_local_lwt *slwt)
> +{
> +	struct net_device *vrf;
> +	struct iphdr *iph;
> +	int err;
> +
> +	if (!decap_and_validate(skb, IPPROTO_IPIP))
> +		goto drop;
> +
> +	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> +		goto drop;
> +
> +	vrf = end_dt4_get_vrf_rcu(skb, &slwt->dt4_info);
> +	if (unlikely(!vrf))
> +		goto drop;
> +
> +	skb->protocol = htons(ETH_P_IP);
> +
> +	skb_dst_drop(skb);
> +
> +	skb_set_transport_header(skb, sizeof(struct iphdr));
> +
> +	skb = end_dt4_vrf_rcv(skb, vrf);
> +	if (!skb)
> +		/* packet has been processed and consumed by the VRF */
> +		return 0;
> +
> +	if (IS_ERR(skb)) {
> +		err = PTR_ERR(skb);
> +		return err;

return PTR_ERR(skb)

> +	}
> +
> +	iph = ip_hdr(skb);
> +
> +	err = ip_route_input(skb, iph->daddr, iph->saddr, 0, skb->dev);
> +	if (err)
> +		goto drop;
> +
> +	return dst_input(skb);
> +
> +drop:
> +	kfree_skb(skb);
> +	return -EINVAL;
> +}
> +
> +#else
> +

new line not needed

> +static int seg6_end_dt4_build(struct seg6_local_lwt *slwt, const void *cfg,
> +			      struct netlink_ext_ack *extack)
> +{
> +	NL_SET_ERR_MSG(extack, "Operation is not supported");

This extack message probably could be more helpful. As it stands it's
basically 

> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int input_action_end_dt4(struct sk_buff *skb,
> +				struct seg6_local_lwt *slwt)

Maybe just ifdef out the part of the action table instead of creating
those stubs?

> +{
> +	kfree_skb(skb);
> +	return -EOPNOTSUPP;
> +}
> +
> +#endif
> +
>  static int input_action_end_dt6(struct sk_buff *skb,
>  				struct seg6_local_lwt *slwt)
>  {
> @@ -601,6 +798,14 @@ static struct seg6_action_desc seg6_action_table[] = {

BTW any idea why the action table is not marked as const?

Would you mind sending a patch to fix that?

>  		.attrs		= (1 << SEG6_LOCAL_NH4),
>  		.input		= input_action_end_dx4,
>  	},
> +	{
> +		.action		= SEG6_LOCAL_ACTION_END_DT4,
> +		.attrs		= (1 << SEG6_LOCAL_TABLE),
> +		.input		= input_action_end_dt4,
> +		.slwt_ops	= {
> +					.build_state = seg6_end_dt4_build,
> +				  },
> +	},
>  	{
>  		.action		= SEG6_LOCAL_ACTION_END_DT6,
>  		.attrs		= (1 << SEG6_LOCAL_TABLE),

