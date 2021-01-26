Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52CF304D8E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732456AbhAZXLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:46814 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395264AbhAZTOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 14:14:08 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4TmC-0009PS-56; Tue, 26 Jan 2021 20:13:20 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4TmB-0004TM-T0; Tue, 26 Jan 2021 20:13:19 +0100
Subject: Re: [PATCH nf-next v4 4/5] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <cover.1611304190.git.lukas@wunner.de>
 <979835dc887d3affc4e76464aa21da0e298fd638.1611304190.git.lukas@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4b36df57-ee60-78da-cc6a-fb443226c978@iogearbox.net>
Date:   Tue, 26 Jan 2021 20:13:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <979835dc887d3affc4e76464aa21da0e298fd638.1611304190.git.lukas@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26061/Tue Jan 26 13:29:51 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 9:47 AM, Lukas Wunner wrote:
> Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> handle_ing() under unique static key") introduced the ability to
> classify packets with netfilter on ingress.
> 
> Support the same on egress to satisfy user requirements such as:
> * outbound security policies for containers (Laura)
> * filtering and mangling intra-node Direct Server Return (DSR) traffic
>    on a load balancer (Laura)
> * filtering locally generated traffic coming in through AF_PACKET,
>    such as local ARP traffic generated for clustering purposes or DHCP
>    (Laura; the AF_PACKET plumbing is contained in a separate commit)
> * L2 filtering from ingress and egress for AVB (Audio Video Bridging)
>    and gPTP with nftables (Pablo)
> * in the future: in-kernel NAT64/NAT46 (Pablo)
> 
> A patch for nftables to hook up egress rules from user space has been
> submitted separately, so users may immediately take advantage of the
> feature.
> 
> The hook is positioned after packet handling by traffic control.
> Thus, if packets are redirected into and out of containers with tc,
> the data path is:
> ingress: host tc -> container tc -> container nft
> egress:  container tc -> host tc -> host nft
> 
> This was done to address an objection from Daniel Borkmann:  If desired,
> nft does not get into tc's way performance-wise.  The host is able to
> firewall malicious packets coming out of a container, but only after tc
> has done its duty.  An implication is that tc may set skb->mark on
> egress for nft to act on it, but not the other way round.
> 
> If egress netfilter handling is not enabled on any interface, it is
> patched out of the data path by way of a static_key and doesn't make a
> performance difference that is discernible from noise:
> 
[...]
> @@ -4096,13 +4098,18 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>   	qdisc_pkt_len_init(skb);
>   #ifdef CONFIG_NET_CLS_ACT
>   	skb->tc_at_ingress = 0;
> -# ifdef CONFIG_NET_EGRESS
> +#endif
> +#ifdef CONFIG_NET_EGRESS
>   	if (static_branch_unlikely(&egress_needed_key)) {
>   		skb = sch_handle_egress(skb, &rc, dev);
>   		if (!skb)
>   			goto out;
> +		if (nf_hook_egress_active()) {
> +			skb = nf_hook_egress(skb, &rc, dev);
> +			if (!skb)
> +				goto out;
> +		}

This won't work unfortunately, the issue is that this now creates an asymmetric path, for
example: [tc ingress] -> [nf ingress] -> [host] -> [tc egress] -> [nf egress]. So any NAT
translation done on tc ingress + tc egress will break on the nf hooks given nf is not able to
correlate inbound with outbound traffic. Likewise for container-based traffic that is in its
own netns, one of the existing paths is: [tc ingress (phys,hostns)] -> [tc ingress (veth,podns)] ->
[reply] -> [tc egress (veth,podns)] -> [tc ingress (veth,hostns)] -> [nf egress (phys,hostns)*] ->
[tc egress (phys,hostns)]. As can be seen the [nf ingress] hook is not an issue at all given
everything operates in tc layer but the [nf egress*] one is in this case, as it touches in tc
layer where existing data planes will start to break upon rule injection. Wrt above objection,
what needs to be done for the minimum case is to i) fix the asymmetry problem from here, and
ii) add a flag for tc layer-redirected skbs to skip the nf egress hook *; with that in place
this concern should be resolved. Thanks!

>   	}
> -# endif
>   #endif
>   	/* If device/qdisc don't need skb->dst, release it right now while
>   	 * its hot in this cpu cache.
