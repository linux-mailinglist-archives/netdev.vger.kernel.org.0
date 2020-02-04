Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C90151A16
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 12:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgBDLqN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Feb 2020 06:46:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727030AbgBDLqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 06:46:12 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-_8z0QKeYOqG3upxsRo6zLQ-1; Tue, 04 Feb 2020 06:46:08 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7BAD18A6EC0;
        Tue,  4 Feb 2020 11:46:07 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-117-217.ams2.redhat.com [10.36.117.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FCE5811F8;
        Tue,  4 Feb 2020 11:46:05 +0000 (UTC)
Date:   Tue, 4 Feb 2020 12:46:04 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH ipsec v2] vti[6]: fix packet tx through bpf_redirect() in
 XinY cases
Message-ID: <20200204114604.GA59185@bistromath.localdomain>
References: <202002041523.F56NC2Bi%lkp@intel.com>
 <20200204105248.28729-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
In-Reply-To: <20200204105248.28729-1-nicolas.dichtel@6wind.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: _8z0QKeYOqG3upxsRo6zLQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020-02-04, 11:52:48 +0100, Nicolas Dichtel wrote:
> I forgot the 4in6/6in4 cases in my previous patch. Let's fix them.
> 
> Fixes: 95224166a903 ("vti[6]: fix packet tx through bpf_redirect()")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 
> v1 -> v2:
>  - fix compilation when IPv6 is disabled
> 
>  net/ipv4/ip_vti.c  | 38 ++++++++++++++++++++++++++++++--------
>  net/ipv6/ip6_vti.c | 32 +++++++++++++++++++++++++-------
>  2 files changed, 55 insertions(+), 15 deletions(-)
> 
> diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
> index 37cddd18f282..1b4e6f298648 100644
> --- a/net/ipv4/ip_vti.c
> +++ b/net/ipv4/ip_vti.c
> @@ -187,17 +187,39 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
>  	int mtu;
>  
>  	if (!dst) {
> -		struct rtable *rt;
> -
> -		fl->u.ip4.flowi4_oif = dev->ifindex;
> -		fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
> -		rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
> -		if (IS_ERR(rt)) {
> +		switch (skb->protocol) {
> +		case htons(ETH_P_IP): {
> +			struct rtable *rt;
> +
> +			fl->u.ip4.flowi4_oif = dev->ifindex;
> +			fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
> +			rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
> +			if (IS_ERR(rt)) {
> +				dev->stats.tx_carrier_errors++;
> +				goto tx_error_icmp;
> +			}
> +			dst = &rt->dst;
> +			skb_dst_set(skb, dst);
> +			break;
> +		}
> +#if IS_ENABLED(CONFIG_IPV6)
> +		case htons(ETH_P_IPV6):
> +			fl->u.ip6.flowi6_oif = dev->ifindex;
> +			fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
> +			dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);

I don't think that works with CONFIG_IPV6=m and CONFIG_NET_IPVTI=y:

ld: net/ipv4/ip_vti.o: in function `ip6_route_output':
/home/sab/linux/net/./include/net/ip6_route.h:98: undefined reference to `ip6_route_output_flags'

You probably have to do like ipvlan did in commit 7f897db37b76
("ipvlan: fix building with modular IPV6").

-- 
Sabrina

