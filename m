Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901B7473AD
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 09:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfFPHif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 03:38:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:61026 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfFPHif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 03:38:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jun 2019 00:38:34 -0700
X-ExtLoop1: 1
Received: from shbuild888.sh.intel.com (HELO localhost) ([10.239.147.114])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2019 00:38:33 -0700
Date:   Sun, 16 Jun 2019 15:38:43 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net 2/4] tcp: add tcp_rx_skb_cache sysctl
Message-ID: <20190616073843.l7ba4oaokzuxk6sp@shbuild888>
References: <20190614232221.248392-1-edumazet@google.com>
 <20190614232221.248392-3-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614232221.248392-3-edumazet@google.com>
User-Agent: NeoMutt/20170609 (1.8.3)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 04:22:19PM -0700, Eric Dumazet wrote:
> Instead of relying on rps_needed, it is safer to use a separate
> static key, since we do not want to enable TCP rx_skb_cache
> by default. This feature can cause huge increase of memory
> usage on hosts with millions of sockets.

Thanks for the effort!

Acked-by: Feng Tang <feng.tang@intel.com>

> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  Documentation/networking/ip-sysctl.txt | 8 ++++++++
>  include/net/sock.h                     | 6 ++----
>  net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
>  3 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 14fe93049d28e965d7349b03c5c8782c3d386e7d..288aa264ac26d98637a5bb1babc334bfc699bef1 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -772,6 +772,14 @@ tcp_challenge_ack_limit - INTEGER
>  	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
>  	Default: 100
>  
> +tcp_rx_skb_cache - BOOLEAN
> +	Controls a per TCP socket cache of one skb, that might help
> +	performance of some workloads. This might be dangerous
> +	on systems with a lot of TCP sockets, since it increases
> +	memory usage.
> +
> +	Default: 0 (disabled)
> +
>  UDP variables:
>  
>  udp_l3mdev_accept - BOOLEAN
> diff --git a/include/net/sock.h b/include/net/sock.h
> index e9d769c04637a3c0b967c9bfa6def724834796b9..b02645e2dfad722769c1455bcde76e46da9fc5ac 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2433,13 +2433,11 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
>   * This routine must be called with interrupts disabled or with the socket
>   * locked so that the sk_buff queue operation is ok.
>  */
> +DECLARE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
>  static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
>  {
>  	__skb_unlink(skb, &sk->sk_receive_queue);
> -	if (
> -#ifdef CONFIG_RPS
> -	    !static_branch_unlikely(&rps_needed) &&
> -#endif
> +	if (static_branch_unlikely(&tcp_rx_skb_cache_key) &&
>  	    !sk->sk_rx_skb_cache) {
>  		sk->sk_rx_skb_cache = skb;
>  		skb_orphan(skb);
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 875867b64d6a6597bf4fcd3498ed55741cbe33f7..886b58d31351df44725bdc34081e798bcb89ecf0 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -51,6 +51,9 @@ static int comp_sack_nr_max = 255;
>  static u32 u32_max_div_HZ = UINT_MAX / HZ;
>  static int one_day_secs = 24 * 3600;
>  
> +DEFINE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
> +EXPORT_SYMBOL(tcp_rx_skb_cache_key);
> +
>  /* obsolete */
>  static int sysctl_tcp_low_latency __read_mostly;
>  
> @@ -559,6 +562,12 @@ static struct ctl_table ipv4_table[] = {
>  		.extra1		= &sysctl_fib_sync_mem_min,
>  		.extra2		= &sysctl_fib_sync_mem_max,
>  	},
> +	{
> +		.procname	= "tcp_rx_skb_cache",
> +		.data		= &tcp_rx_skb_cache_key.key,
> +		.mode		= 0644,
> +		.proc_handler	= proc_do_static_key,
> +	},
>  	{ }
>  };
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
