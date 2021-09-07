Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2FC402B64
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbhIGPNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344964AbhIGPNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 11:13:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0510B610FE;
        Tue,  7 Sep 2021 15:12:02 +0000 (UTC)
Date:   Tue, 7 Sep 2021 11:12:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        hengqi.chen@gmail.com, yhs@fb.com, brendan.d.gregg@gmail.com,
        2228598786@qq.com
Subject: Re: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for
 tracing v4
Message-ID: <20210907111201.783d5ea2@gandalf.local.home>
In-Reply-To: <20210904064044.125549-1-yan2228598786@gmail.com>
References: <20210904064044.125549-1-yan2228598786@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Sep 2021 23:40:44 -0700
Zhongya Yan <yan2228598786@gmail.com> wrote:

> @@ -4708,7 +4710,7 @@ static void tcp_ofo_queue(struct sock *sk)
>  		rb_erase(&skb->rbnode, &tp->out_of_order_queue);
>  
>  		if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
> -			tcp_drop(sk, skb);
> +			tcp_drop(sk, skb, LINUX_MIB_TCPOFOQUEUE, "Tcp queue error");
>  			continue;
>  		}
>  
> @@ -4764,7 +4766,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
>  	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
>  		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
>  		sk->sk_data_ready(sk);
> -		tcp_drop(sk, skb);
> +		tcp_drop(sk, skb, LINUX_MIB_TCPOFODROP, "Tcp rmem failed");
>  		return;
>  	}
>  
> @@ -4827,7 +4829,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
>  				/* All the bits are present. Drop. */
>  				NET_INC_STATS(sock_net(sk),
>  					      LINUX_MIB_TCPOFOMERGE);
> -				tcp_drop(sk, skb);
> +				tcp_drop(sk, skb, LINUX_MIB_TCPOFOMERGE, "Tcp bits are present");

Just curious. Is "Tcp" the normal way to write "TCP" in the kernel? I see
it in snmp_seq_show_tcp_udp() in net/ipv4/proc.c, but no where else
(besides doing CamelCase words). Should these be written using "TCP"
instead of "Tcp". It just looks awkward to me.

But hey, I'm not one of the networking folks, so what do I know?

-- Steve
