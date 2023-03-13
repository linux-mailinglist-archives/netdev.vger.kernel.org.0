Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67E46B8230
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCMUGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjCMUGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:06:18 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D7661A90
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678737977; x=1710273977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ADmqjwKIBQazpXj2teRRWy2ggTVdGClQa19UiXo4hAg=;
  b=g6cLO4xCibqPgU34lPdnDFUEcyY3daNP9EC+IkpPaHi6OKATVFdANFJU
   WwNxdbXhaw8nt1YkdzCe8ORbJrMbVIeZJXSEAInCgi0Rv5Ga2Gd0dWvX1
   E1enWn/KtKpTt4A0FGmcGmvZfPJvyWnFgopvclIJHDG0MbKz7sAfhV6qj
   k=;
X-IronPort-AV: E=Sophos;i="5.98,257,1673913600"; 
   d="scan'208";a="306698267"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 20:06:13 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id 561FCA480C;
        Mon, 13 Mar 2023 20:06:12 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 13 Mar 2023 20:06:11 +0000
Received: from 88665a182662.ant.amazon.com.com (10.142.135.145) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Mon, 13 Mar 2023 20:06:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <mfreemon@cloudflare.com>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <kuniyu@amazon.com>
Subject: Re: [RFC PATCH v2] Add a sysctl to allow TCP window shrinking in order to honor memory limits
Date:   Mon, 13 Mar 2023 13:06:01 -0700
Message-ID: <20230313200601.46663-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230308053353.675086-1-mfreemon@cloudflare.com>
References: <20230308053353.675086-1-mfreemon@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.142.135.145]
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Mike Freemon <mfreemon@cloudflare.com>
Date:   Tue,  7 Mar 2023 23:33:53 -0600
> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
> 
> Under certain circumstances, the tcp receive buffer memory limit
> set by autotuning is ignored, and the receive buffer can grow
> unrestrained until it reaches tcp_rmem[2].
> 
> To reproduce:  Connect a TCP session with the receiver doing
> nothing and the sender sending small packets (an infinite loop
> of socket send() with 4 bytes of payload with a sleep of 1 ms
> in between each send()).  This will fill the tcp receive buffer
> all the way to tcp_rmem[2], ignoring the autotuning limit
> (sk_rcvbuf).
> 
> As a result, a host can have individual tcp sessions with receive
> buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
> limits, causing the host to go into tcp memory pressure mode.
> 
> The fundamental issue is the relationship between the granularity
> of the window scaling factor and the number of byte ACKed back
> to the sender.  This problem has previously been identified in
> RFC 7323, appendix F [1].
> 
> The Linux kernel currently adheres to never shrinking the window.
> 
> In addition to the overallocation of memory mentioned above, this
> is also functionally incorrect, because once tcp_rmem[2] is
> reached, the receiver will drop in-window packets resulting in
> retransmissions and an eventual timeout of the tcp session.  A
> receive buffer full condition should instead result in a zero
> window and an indefinite wait.
> 
> In practice, this problem is largely hidden for most flows.  It
> is not applicable to mice flows.  Elephant flows can send data
> fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
> triggering a zero window.
> 
> But this problem does show up for other types of flows.  Good
> examples are websockets and other type of flows that send small
> amounts of data spaced apart slightly in time.  In these cases,
> we directly encounter the problem described in [1].
> 
> RFC 7323, section 2.4 [2], says there are instances when a retracted
> window can be offered, and that TCP implementations MUST ensure
> that they handle a shrinking window, as specified in RFC 1122,
> section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
> management have made clear that sender must accept a shrunk window
> from the receiver, including RFC 793 [4] and RFC 1323 [5].
> 
> This patch implements the functionality to shrink the tcp window
> when necessary to keep the right edge within the memory limit set
> by autotuning (sk_rcvbuf).  This new functionality is enabled by
> setting the sysctl net.ipv4.tcp_shrink_window to 1.
> 
> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> [4] https://www.rfc-editor.org/rfc/rfc793
> [5] https://www.rfc-editor.org/rfc/rfc1323
> 
> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 14 ++++++
>  include/net/netns/ipv4.h               |  2 +
>  net/ipv4/sysctl_net_ipv4.c             |  7 +++
>  net/ipv4/tcp_ipv4.c                    |  2 +
>  net/ipv4/tcp_output.c                  | 59 +++++++++++++++++++-------
>  5 files changed, 69 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 87dd1c5283e6..67dfcadfe350 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -968,6 +968,20 @@ tcp_tw_reuse - INTEGER
>  tcp_window_scaling - BOOLEAN
>  	Enable window scaling as defined in RFC1323.
>  
> +tcp_shrink_window - BOOLEAN
> +	This changes how the TCP receive window is calculated when window
> +	scaling is in effect.
> +
> +	RFC 7323, section 2.4, says there are instances when a retracted
> +	window can be offered, and that TCP implementations MUST ensure
> +	that they handle a shrinking window, as specified in RFC 1122.
> +
> +	- 0 - Disabled.	The window is never shrunk.
> +	- 1 - Enabled.	The window is shrunk when necessary to remain within
> +					the memory limit set by autotuning (sk_rcvbuf).
> +
> +	Default: 0
> +
>  tcp_wmem - vector of 3 INTEGERs: min, default, max
>  	min: Amount of memory reserved for send buffers for TCP sockets.
>  	Each TCP socket has rights to use it due to fact of its birth.
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index db762e35aca9..fbc67afac75a 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -237,5 +237,7 @@ struct netns_ipv4 {
>  
>  	atomic_t	rt_genid;
>  	siphash_key_t	ip_id_key;
> +
> +	unsigned int sysctl_tcp_shrink_window;

u8 can be used instead.
Also, please try filling a (hot if appropriate) hole.

  $ pahole -C netns_ipv4 net/ipv4/sysctl_net_ipv4.o


>  };
>  #endif
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 0d0cc4ef2b85..c6d181f79534 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -1467,6 +1467,13 @@ static struct ctl_table ipv4_net_table[] = {
>  		.extra1         = SYSCTL_ZERO,
>  		.extra2         = &tcp_plb_max_cong_thresh,
>  	},
> +	{
> +		.procname	= "tcp_shrink_window",
> +		.data		= &init_net.ipv4.sysctl_tcp_shrink_window,
> +		.maxlen		= sizeof(unsigned int),

s/unsigned int/u8/

> +		.mode		= 0644,
> +		.proc_handler	= proc_douintvec_minmax,

You can use u8 handler with min/max.

		.proc_handler   = proc_dou8vec_minmax,
		.extra1         = SYSCTL_ZERO,
                .extra2         = SYSCTL_ONE,

> +	},
>  	{ }
>  };
>  
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index ea370afa70ed..d976f01413d7 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -3275,6 +3275,8 @@ static int __net_init tcp_sk_init(struct net *net)
>  	else
>  		net->ipv4.tcp_congestion_control = &tcp_reno;
>  
> +	net->ipv4.sysctl_tcp_shrink_window = 0;
> +
>  	return 0;
>  }
>  
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 71d01cf3c13e..7f7a96e797fa 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -260,8 +260,8 @@ static u16 tcp_select_window(struct sock *sk)
>  	u32 old_win = tp->rcv_wnd;
>  	u32 cur_win = tcp_receive_window(tp);
>  	u32 new_win = __tcp_select_window(sk);
> +	struct net *net = sock_net(sk);
>  
> -	/* Never shrink the offered window */
>  	if (new_win < cur_win) {
>  		/* Danger Will Robinson!
>  		 * Don't update rcv_wup/rcv_wnd here or else
> @@ -270,11 +270,15 @@ static u16 tcp_select_window(struct sock *sk)
>  		 *
>  		 * Relax Will Robinson.
>  		 */
> -		if (new_win == 0)
> -			NET_INC_STATS(sock_net(sk),
> -				      LINUX_MIB_TCPWANTZEROWINDOWADV);
> -		new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
> +		if (!net->ipv4.sysctl_tcp_shrink_window) {

Let's use READ_ONCE() to silence KCSAN when reading sysctl knobs.
Same for other readers.

Thanks,
Kuniyuki


> +			/* Never shrink the offered window */
> +			if (new_win == 0)
> +				NET_INC_STATS(sock_net(sk),
> +					      LINUX_MIB_TCPWANTZEROWINDOWADV);
> +			new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
> +		}
>  	}
> +
>  	tp->rcv_wnd = new_win;
>  	tp->rcv_wup = tp->rcv_nxt;
>  
> @@ -2947,6 +2951,7 @@ u32 __tcp_select_window(struct sock *sk)
>  {
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
> +	struct net *net = sock_net(sk);
>  	/* MSS for the peer's data.  Previous versions used mss_clamp
>  	 * here.  I don't know if the value based on our guesses
>  	 * of peer's MSS is better for the performance.  It's more correct
> @@ -2968,16 +2973,24 @@ u32 __tcp_select_window(struct sock *sk)
>  		if (mss <= 0)
>  			return 0;
>  	}
> +
> +	if (net->ipv4.sysctl_tcp_shrink_window) {
> +		/* new window should always be an exact multiple of scaling factor */
> +		free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
> +	}
> +
>  	if (free_space < (full_space >> 1)) {
>  		icsk->icsk_ack.quick = 0;
>  
>  		if (tcp_under_memory_pressure(sk))
>  			tcp_adjust_rcv_ssthresh(sk);
>  
> -		/* free_space might become our new window, make sure we don't
> -		 * increase it due to wscale.
> -		 */
> -		free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
> +		if (!net->ipv4.sysctl_tcp_shrink_window) {
> +			/* free_space might become our new window, make sure we don't
> +			 * increase it due to wscale.
> +			 */
> +			free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
> +		}
>  
>  		/* if free space is less than mss estimate, or is below 1/16th
>  		 * of the maximum allowed, try to move to zero-window, else
> @@ -2988,10 +3001,24 @@ u32 __tcp_select_window(struct sock *sk)
>  		 */
>  		if (free_space < (allowed_space >> 4) || free_space < mss)
>  			return 0;
> +
> +		if (net->ipv4.sysctl_tcp_shrink_window && free_space < (1 << tp->rx_opt.rcv_wscale))
> +			return 0;
>  	}
>  
> -	if (free_space > tp->rcv_ssthresh)
> +	if (free_space > tp->rcv_ssthresh) {
>  		free_space = tp->rcv_ssthresh;
> +		if (net->ipv4.sysctl_tcp_shrink_window) {
> +			/* new window should always be an exact multiple of scaling factor
> +			 *
> +			 * For this case, we ALIGN "up" (increase free_space) because
> +			 * we know free_space is not zero here, it has been reduced from
> +			 * the memory-based limit, and rcv_ssthresh is not a hard limit
> +			 * (unlike sk_rcvbuf).
> +			 */
> +			free_space = ALIGN(free_space, (1 << tp->rx_opt.rcv_wscale));
> +		}
> +	}
>  
>  	/* Don't do rounding if we are using window scaling, since the
>  	 * scaled window will not line up with the MSS boundary anyway.
> @@ -2999,11 +3026,13 @@ u32 __tcp_select_window(struct sock *sk)
>  	if (tp->rx_opt.rcv_wscale) {
>  		window = free_space;
>  
> -		/* Advertise enough space so that it won't get scaled away.
> -		 * Import case: prevent zero window announcement if
> -		 * 1<<rcv_wscale > mss.
> -		 */
> -		window = ALIGN(window, (1 << tp->rx_opt.rcv_wscale));
> +		if (!net->ipv4.sysctl_tcp_shrink_window) {
> +			/* Advertise enough space so that it won't get scaled away.
> +			 * Import case: prevent zero window announcement if
> +			 * 1<<rcv_wscale > mss.
> +			 */
> +			window = ALIGN(window, (1 << tp->rx_opt.rcv_wscale));
> +		}
>  	} else {
>  		window = tp->rcv_wnd;
>  		/* Get the largest window that is a nice multiple of mss.
> -- 
> 2.39.2
