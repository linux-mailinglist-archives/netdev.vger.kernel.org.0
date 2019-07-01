Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2395489DC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfFQRSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:18:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55036 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQRSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:18:11 -0400
Received: from 162-237-133-238.lightspeed.rcsntx.sbcglobal.net ([162.237.133.238] helo=lindsey)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <tyhicks@canonical.com>)
        id 1hcvGf-0001hH-PV; Mon, 17 Jun 2019 17:18:06 +0000
Date:   Mon, 17 Jun 2019 12:18:01 -0500
From:   Tyler Hicks <tyhicks@canonical.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net 3/4] tcp: add tcp_min_snd_mss sysctl
Message-ID: <20190617171800.GA5577@lindsey>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-4-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617170354.37770-4-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-17 10:03:53, Eric Dumazet wrote:
> Some TCP peers announce a very small MSS option in their SYN and/or
> SYN/ACK messages.
> 
> This forces the stack to send packets with a very high network/cpu
> overhead.
> 
> Linux has enforced a minimal value of 48. Since this value includes
> the size of TCP options, and that the options can consume up to 40
> bytes, this means that each segment can include only 8 bytes of payload.
> 
> In some cases, it can be useful to increase the minimal value
> to a saner value.
> 
> We still let the default to 48 (TCP_MIN_SND_MSS), for compatibility
> reasons.
> 
> Note that TCP_MAXSEG socket option enforces a minimal value
> of (TCP_MIN_MSS). David Miller increased this minimal value
> in commit c39508d6f118 ("tcp: Make TCP_MAXSEG minimum more correct.")
> from 64 to 88.
> 
> We might in the future merge TCP_MIN_SND_MSS and TCP_MIN_MSS.
> 
> CVE-2019-11479 -- tcp mss hardcoded to 48
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Tyler Hicks <tyhicks@canonical.com>

I've given the two sysctl patches a close review and some testing.

Acked-by: Tyler Hicks <tyhicks@canonical.com>

Tyler

> Cc: Bruce Curtis <brucec@netflix.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.txt |  8 ++++++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             | 11 +++++++++++
>  net/ipv4/tcp_ipv4.c                    |  1 +
>  net/ipv4/tcp_output.c                  |  3 +--
>  5 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 288aa264ac26d98637a5bb1babc334bfc699bef1..22f6b8b1110ad20c36e7ceea6d67fd2cc938eb7b 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -255,6 +255,14 @@ tcp_base_mss - INTEGER
>  	Path MTU discovery (MTU probing).  If MTU probing is enabled,
>  	this is the initial MSS used by the connection.
>  
> +tcp_min_snd_mss - INTEGER
> +	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
> +	as described in RFC 1122 and RFC 6691.
> +	If this ADVMSS option is smaller than tcp_min_snd_mss,
> +	it is silently capped to tcp_min_snd_mss.
> +
> +	Default : 48 (at least 8 bytes of payload per segment)
> +
>  tcp_congestion_control - STRING
>  	Set the congestion control algorithm to be used for new
>  	connections. The algorithm "reno" is always available, but
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 7698460a3dd1e5070e12d406b3ee58834688cdc9..623cfbb7b8dcbb2a6d8325ec010aff78bbdf8839 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -117,6 +117,7 @@ struct netns_ipv4 {
>  #endif
>  	int sysctl_tcp_mtu_probing;
>  	int sysctl_tcp_base_mss;
> +	int sysctl_tcp_min_snd_mss;
>  	int sysctl_tcp_probe_threshold;
>  	u32 sysctl_tcp_probe_interval;
>  
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index fa213bd8e233b577114815ca2227f08264e7df06..b6f14af926faf80f1686549bee7154c584dc63e6 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -39,6 +39,8 @@ static int ip_local_port_range_min[] = { 1, 1 };
>  static int ip_local_port_range_max[] = { 65535, 65535 };
>  static int tcp_adv_win_scale_min = -31;
>  static int tcp_adv_win_scale_max = 31;
> +static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
> +static int tcp_min_snd_mss_max = 65535;
>  static int ip_privileged_port_min;
>  static int ip_privileged_port_max = 65535;
>  static int ip_ttl_min = 1;
> @@ -769,6 +771,15 @@ static struct ctl_table ipv4_net_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "tcp_min_snd_mss",
> +		.data		= &init_net.ipv4.sysctl_tcp_min_snd_mss,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &tcp_min_snd_mss_min,
> +		.extra2		= &tcp_min_snd_mss_max,
> +	},
>  	{
>  		.procname	= "tcp_probe_threshold",
>  		.data		= &init_net.ipv4.sysctl_tcp_probe_threshold,
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index bc86f9735f4577d50d94f42b10edb6ba95bb7a05..cfa81190a1b1af30d05f4f6cd84c05b025a6afeb 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2628,6 +2628,7 @@ static int __net_init tcp_sk_init(struct net *net)
>  	net->ipv4.sysctl_tcp_ecn_fallback = 1;
>  
>  	net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
> +	net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>  	net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>  	net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>  
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 1bb1c46b4abad100622d3f101a0a3ca0a6c8e881..00c01a01b547ec67c971dc25a74c9258563cf871 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1459,8 +1459,7 @@ static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
>  	mss_now -= icsk->icsk_ext_hdr_len;
>  
>  	/* Then reserve room for full set of TCP options and 8 bytes of data */
> -	if (mss_now < TCP_MIN_SND_MSS)
> -		mss_now = TCP_MIN_SND_MSS;
> +	mss_now = max(mss_now, sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss);
>  	return mss_now;
>  }
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 
