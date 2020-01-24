Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49ED147CE9
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388473AbgAXJz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:55:27 -0500
Received: from www62.your-server.de ([213.133.104.62]:49370 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgAXJz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:55:26 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvgO-00084A-EU; Fri, 24 Jan 2020 10:55:20 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuvgO-000SAy-6H; Fri, 24 Jan 2020 10:55:20 +0100
Subject: Re: [PATCH net-next] v2 net-xdp: netdev attribute to control
 xdpgeneric skb linearization
To:     Luigi Rizzo <lrizzo@google.com>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        toke@redhat.com
References: <20200123232054.183436-1-lrizzo@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3a7e66da-7506-47a0-8733-8d48674176f9@iogearbox.net>
Date:   Fri, 24 Jan 2020 10:55:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200123232054.183436-1-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 12:20 AM, Luigi Rizzo wrote:
> Add a netdevice flag to control skb linearization in generic xdp mode.
> Among the various mechanism to control the flag, the sysfs
> interface seems sufficiently simple and self-contained.
> The attribute can be modified through
> 	/sys/class/net/<DEVICE>/xdp_linearize
> The default is 1 (on)
> 
> On a kernel instrumented to grab timestamps around the linearization
> code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
> mtu, I see the following times (nanoseconds/pkt)
> 
> The receiver generally sees larger packets so the difference is more
> significant.
> 
> ns/pkt                   RECEIVER                 SENDER
> 
>                      p50     p90     p99       p50   p90    p99
> 
> LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
> NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns
> 
> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
> ---
>   include/linux/netdevice.h |  3 ++-
>   net/core/dev.c            |  5 +++--
>   net/core/net-sysfs.c      | 15 +++++++++++++++
>   3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5ec3537fbdb1..b182f3cb0bf0 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1959,7 +1959,8 @@ struct net_device {
>   
>   	struct netdev_rx_queue	*_rx;
>   	unsigned int		num_rx_queues;
> -	unsigned int		real_num_rx_queues;
> +	unsigned int		real_num_rx_queues:31;
> +	unsigned int		xdp_linearize : 1;
>   
>   	struct bpf_prog __rcu	*xdp_prog;
>   	unsigned long		gro_flush_timeout;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4dcc1b390667..13a671e45b61 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4484,8 +4484,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>   	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
>   	 * native XDP provides, thus we need to do it here as well.
>   	 */
> -	if (skb_is_nonlinear(skb) ||
> -	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> +	if (skb->dev->xdp_linearize && (skb_is_nonlinear(skb) ||
> +	    skb_headroom(skb) < XDP_PACKET_HEADROOM)) {
>   		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
>   		int troom = skb->tail + skb->data_len - skb->end;

I still think in order for this knob to be generally useful, we would need to
provide an equivalent of bpf_skb_pull_data() helper, which in generic XDP would then
pull in more data from non-linear section, and in native XDP would be a "no-op" since
the frame is already linear. Otherwise, as mentioned in previous thread, users would
have no chance to examine headers if they are not pre-pulled by the driver.

> @@ -9756,6 +9756,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>   	dev->gso_max_segs = GSO_MAX_SEGS;
>   	dev->upper_level = 1;
>   	dev->lower_level = 1;
> +	dev->xdp_linearize = 1;
>   
>   	INIT_LIST_HEAD(&dev->napi_list);
>   	INIT_LIST_HEAD(&dev->unreg_list);
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 4c826b8bf9b1..ec59aa296664 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -442,6 +442,20 @@ static ssize_t proto_down_store(struct device *dev,
>   }
>   NETDEVICE_SHOW_RW(proto_down, fmt_dec);
>   
> +static int change_xdp_linearize(struct net_device *dev, unsigned long val)
> +{
> +	dev->xdp_linearize = !!val;
> +	return 0;
> +}
> +
> +static ssize_t xdp_linearize_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t len)
> +{
> +	return netdev_store(dev, attr, buf, len, change_xdp_linearize);
> +}
> +NETDEVICE_SHOW_RW(xdp_linearize, fmt_dec);
> +
>   static ssize_t phys_port_id_show(struct device *dev,
>   				 struct device_attribute *attr, char *buf)
>   {
> @@ -536,6 +550,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
>   	&dev_attr_phys_port_name.attr,
>   	&dev_attr_phys_switch_id.attr,
>   	&dev_attr_proto_down.attr,
> +	&dev_attr_xdp_linearize.attr,
>   	&dev_attr_carrier_up_count.attr,
>   	&dev_attr_carrier_down_count.attr,
>   	NULL,
> 

