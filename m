Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF38430195A
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 04:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbhAXD1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 22:27:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbhAXD1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 22:27:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90CB322D0A;
        Sun, 24 Jan 2021 03:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611458786;
        bh=+OOJlwiRevgXr+hw4L13I8DH0AsYtPCQi4EnGrYc5gM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bVGwaYitrqgUvCcJOYsC1tYWpRN4CdN8TKkLfKjCod6DpsRvHkz9rkU0B2RwfiXI+
         ykwg5qHnGPOQX1tgAB+8o4iM45MnLB+TdCkS2+sv78yWG6MERZJlSYR97VNWMCR/Zs
         RCkvsvEudcMYMX+e590qz7nEXQI+2OS4IAxsmec3F2bhuRTdGUg2fn7jQulwK02UEv
         oFv9qXKf01OlO4Ngw5lEEE1RC20WZqz8Kn7iLiUISwG2UVWLTfPAVPiVrC8Pmzib/X
         ddIA07xY0XV6QGGQJJvWN1/hjwNQre4zccWHcvs34vgirLYDPUPlxLTvibKFy0k0B0
         hNjc++Sv/eDGA==
Date:   Sat, 23 Jan 2021 19:26:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 1/5] net: sched: Micro-optimize egress
 handling
Message-ID: <20210123192624.4cee3b7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
        <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 09:47:01 +0100 Lukas Wunner wrote:
> sch_handle_egress() returns either the skb or NULL to signal to its
> caller __dev_queue_xmit() whether a packet should continue to be
> processed.
> 
> The skb is always non-NULL, otherwise __dev_queue_xmit() would hit a
> NULL pointer deref right at its top.
> 
> But the compiler doesn't know that.  So if sch_handle_egress() signals
> success by returning the skb, the "if (!skb) goto out;" statement
> results in a gratuitous NULL pointer check in the Assembler output.

Which exact compiler are we talking about it? Did you report this?
As Eric pointed the compiler should be able to figure this out quite
easily.

> Avoid by telling the compiler that __dev_queue_xmit() is never passed a
> NULL skb.  This also eliminates another gratuitous NULL pointer check in
> __dev_queue_xmit()
>   qdisc_pkt_len_init()
>     skb_header_pointer()
>       __skb_header_pointer()
> 
> The speedup is barely measurable:
> Before: 1877 1875 1878 1874 1882 1873 Mb/sec
> After:  1877 1877 1880 1883 1888 1886 Mb/sec
> 
> However we're about to add a netfilter egress hook to __dev_queue_xmit()
> and without the micro-optimization, it will result in a performance
> degradation which is indeed measurable:
> With netfilter hook:               1853 1852 1850 1848 1849 1851 Mb/sec
> With netfilter hook + micro-optim: 1874 1877 1881 1875 1876 1876 Mb/sec
> 
> The performance degradation is caused by a JNE instruction ("if (skb)")
> being flipped to a JE instruction ("if (!skb)") once the netfilter hook
> is added.  The micro-optimization removes the test and jump instructions
> altogether.
> 
> Measurements were performed on a Core i7-3615QM.  Reproducer:
> ip link add dev foo type dummy
> ip link set dev foo up
> tc qdisc add dev foo clsact
> tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'
> modprobe pktgen
> echo "add_device foo" > /proc/net/pktgen/kpktgend_3
> samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i foo -n 400000000 -m "11:11:11:11:11:11" -d 1.1.1.1
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Thomas Graf <tgraf@suug.ch>
> ---
>  net/core/dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7afbb642e203..4c16b9932823 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4072,6 +4072,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
>   *      the BH enable code must have IRQs enabled so that it will not deadlock.
>   *          --BLG
>   */
> +__attribute__((nonnull(1)))
>  static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>  {
>  	struct net_device *dev = skb->dev;

