Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5712047EAE9
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbhLXD2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245574AbhLXD2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:28:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3519C061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:28:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73803CE2238
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 03:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424AFC36AE5;
        Fri, 24 Dec 2021 03:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640316526;
        bh=TBBl18G0iz+RQT4nV5WDDU6NNkcU02/L2sMSlUWhags=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TXo/aD3Fd7/32b1KWywcZYC6dP7fD3vW42IrfBCIT+kSzuNdjjZ/6mOKrQe2bpTzC
         8R8xonitIhvjjxJwhQPtIuceTwPz+X75n7Kn+XsGzaJuDhNKxuaalMavKZ10hk9jYn
         T4Zx7lwOo+wTzc3K87ZAalYFm+0TAcij26WJsan1vmFeaxmkWsYJS1yqj9pfTooKKQ
         PXx70lzqsRQsYleppouBcvmSR0p02fuu7y+e79vvjbFZT4UJ66N9i4ij6wHrLDNc49
         6Iyixg1JOOO6pnzJev6kNu4mUOZLMTeACwBjpFFzhRK1hd0UhZItwrwm+lVm8C74jK
         IONajT07Dt/eQ==
Date:   Thu, 23 Dec 2021 19:28:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ipv6: ioam: Support for Queue depth data field
Message-ID: <20211223192845.1586b5b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223155515.15564-1-justin.iurman@uliege.be>
References: <20211223155515.15564-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 16:55:15 +0100 Justin Iurman wrote:
> This patch adds support for the queue depth in IOAM trace data fields.
> 
> The draft [1] says the following:
> 
>    The "queue depth" field is a 4-octet unsigned integer field.  This
>    field indicates the current length of the egress interface queue of
>    the interface from where the packet is forwarded out.  The queue
>    depth is expressed as the current amount of memory buffers used by
>    the queue (a packet could consume one or more memory buffers,
>    depending on its size).
> 
> An existing function (i.e., qdisc_qstats_qlen_backlog) is used to
> retrieve the current queue length without reinventing the wheel.
> 
> Note: it was tested and qlen is increasing when an artificial delay is
> added on the egress with tc.
> 
>   [1] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.2.7
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  net/ipv6/ioam6.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
> index 122a3d47424c..088eb2f877bc 100644
> --- a/net/ipv6/ioam6.c
> +++ b/net/ipv6/ioam6.c
> @@ -13,10 +13,12 @@
>  #include <linux/ioam6.h>
>  #include <linux/ioam6_genl.h>
>  #include <linux/rhashtable.h>
> +#include <linux/netdevice.h>
>  
>  #include <net/addrconf.h>
>  #include <net/genetlink.h>
>  #include <net/ioam6.h>
> +#include <net/sch_generic.h>
>  
>  static void ioam6_ns_release(struct ioam6_namespace *ns)
>  {
> @@ -717,7 +719,17 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
>  
>  	/* queue depth */
>  	if (trace->type.bit6) {
> -		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> +		struct netdev_queue *queue;
> +		__u32 qlen, backlog;
> +
> +		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
> +			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> +		} else {
> +			queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
> +			qdisc_qstats_qlen_backlog(queue->qdisc, &qlen, &backlog);
> +
> +			*(__be32 *)data = cpu_to_be32(qlen);
> +		}
>  		data += sizeof(__be32);
>  	}
>  

sparse complains that:

net/ipv6/ioam6.c:729:56: warning: incorrect type in argument 1 (different address spaces)
net/ipv6/ioam6.c:729:56:    expected struct Qdisc *sch
net/ipv6/ioam6.c:729:56:    got struct Qdisc [noderef] __rcu *qdisc
