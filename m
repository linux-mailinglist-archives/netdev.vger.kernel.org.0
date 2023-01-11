Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D909E6650CE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 01:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbjAKA7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 19:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbjAKA7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 19:59:46 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B01F50F7B
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 16:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673398784; x=1704934784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F8g9DaIJqO9u7mIOwPWPZlTbR7KEN8Atv3wglnZkNGQ=;
  b=u66T7IjXH46B00xwg5E33+AOjt8BHzDWOjnpU6+xiCaO0AZyPZXS9i4j
   Wp834tLjPHaBJES65XVWw9M2l8DWrUX+j5oM/AYpDtm/lbcLrC/mjX/+4
   tSbAN9AzvAh3HCnyGFVUz8pYLB1IIiTaJ+ekfAh1HW7SCWsbm8mkjnV+h
   M=;
X-IronPort-AV: E=Sophos;i="5.96,315,1665446400"; 
   d="scan'208";a="298900939"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 00:59:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id D21C0434EA;
        Wed, 11 Jan 2023 00:59:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 00:59:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Wed, 11 Jan 2023 00:59:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <jakub@cloudflare.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <kernel-team@cloudflare.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <marek@cloudflare.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] inet: Add IP_LOCAL_PORT_RANGE socket option
Date:   Wed, 11 Jan 2023 09:59:23 +0900
Message-ID: <20230111005923.47037-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221221-sockopt-port-range-v2-1-1d5f114bf627@cloudflare.com>
References: <20221221-sockopt-port-range-v2-1-1d5f114bf627@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13P01UWA003.ant.amazon.com (10.43.160.197) To
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

From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Tue, 10 Jan 2023 14:37:29 +0100
> Users who want to share a single public IP address for outgoing connections
> between several hosts traditionally reach for SNAT. However, SNAT requires
> state keeping on the node(s) performing the NAT.
> 
> A stateless alternative exists, where a single IP address used for egress
> can be shared between several hosts by partitioning the available ephemeral
> port range. In such a setup:
> 
> 1. Each host gets assigned a disjoint range of ephemeral ports.
> 2. Applications open connections from the host-assigned port range.
> 3. Return traffic gets routed to the host based on both, the destination IP
>    and the destination port.
> 
> An application which wants to open an outgoing connection (connect) from a
> given port range today can choose between two solutions:
> 
> 1. Manually pick the source port by bind()'ing to it before connect()'ing
>    the socket.
> 
>    This approach has a couple of downsides:
> 
>    a) Search for a free port has to be implemented in the user-space. If
>       the chosen 4-tuple happens to be busy, the application needs to retry
>       from a different local port number.
> 
>       Detecting if 4-tuple is busy can be either easy (TCP) or hard
>       (UDP). In TCP case, the application simply has to check if connect()
>       returned an error (EADDRNOTAVAIL). That is assuming that the local
>       port sharing was enabled (REUSEADDR) by all the sockets.
> 
>         # Assume desired local port range is 60_000-60_511
>         s = socket(AF_INET, SOCK_STREAM)
>         s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>         s.bind(("192.0.2.1", 60_000))
>         s.connect(("1.1.1.1", 53))
>         # Fails only if 192.0.2.1:60000 -> 1.1.1.1:53 is busy
>         # Application must retry with another local port
> 
>       In case of UDP, the network stack allows binding more than one socket
>       to the same 4-tuple, when local port sharing is enabled
>       (REUSEADDR). Hence detecting the conflict is much harder and involves
>       querying sock_diag and toggling the REUSEADDR flag [1].
> 
>    b) For TCP, bind()-ing to a port within the ephemeral port range means
>       that no connecting sockets, that is those which leave it to the
>       network stack to find a free local port at connect() time, can use
>       the this port.
> 
>       IOW, the bind hash bucket tb->fastreuse will be 0 or 1, and the port
>       will be skipped during the free port search at connect() time.
> 
> 2. Isolate the app in a dedicated netns and use the use the per-netns
>    ip_local_port_range sysctl to adjust the ephemeral port range bounds.
> 
>    The per-netns setting affects all sockets, so this approach can be used
>    only if:
> 
>    - there is just one egress IP address, or
>    - the desired egress port range is the same for all egress IP addresses
>      used by the application.
> 
>    For TCP, this approach avoids the downsides of (1). Free port search and
>    4-tuple conflict detection is done by the network stack:
> 
>      system("sysctl -w net.ipv4.ip_local_port_range='60000 60511'")
> 
>      s = socket(AF_INET, SOCK_STREAM)
>      s.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
>      s.bind(("192.0.2.1", 0))
>      s.connect(("1.1.1.1", 53))
>      # Fails if all 4-tuples 192.0.2.1:60000-60511 -> 1.1.1.1:53 are busy
> 
>   For UDP this approach has limited applicability. Setting the
>   IP_BIND_ADDRESS_NO_PORT socket option does not result in local source
>   port being shared with other connected UDP sockets.
> 
>   Hence relying on the network stack to find a free source port, limits the
>   number of outgoing UDP flows from a single IP address down to the number
>   of available ephemeral ports.
> 
> To put it another way, partitioning the ephemeral port range between hosts
> using the existing Linux networking API is cumbersome.
> 
> To address this use case, add a new socket option at the SOL_IP level,
> named IP_LOCAL_PORT_RANGE. The new option can be used to clamp down the
> ephemeral port range for each socket individually.
> 
> The option can be used only to narrow down the per-netns local port
> range. If the per-socket range lies outside of the per-netns range, the
> latter takes precedence.
> 
> UAPI-wise, the low and high range bounds are passed to the kernel as a pair
> of u16 values packed into a u32. This avoids pointer passing.
> 
>   PORT_LO = 40_000
>   PORT_HI = 40_511
> 
>   s = socket(AF_INET, SOCK_STREAM)
>   v = struct.pack("I", PORT_HI << 16 | PORT_LO)
>   s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
>   s.bind(("127.0.0.1", 0))
>   s.getsockname()
>   # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
>   # if there is a free port. EADDRINUSE otherwise.
> 
> [1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116
> 
> v1 -> v2:
>  * Fix the corner case when the per-socket range doesn't overlap with the
>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
> 
> Reviewed-by: Marek Majkowski <marek@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/net/inet_sock.h         |  4 ++++
>  include/net/ip.h                |  3 ++-
>  include/uapi/linux/in.h         |  1 +
>  net/ipv4/inet_connection_sock.c | 25 +++++++++++++++++++++++--
>  net/ipv4/inet_hashtables.c      |  2 +-
>  net/ipv4/ip_sockglue.c          | 18 ++++++++++++++++++
>  net/ipv4/udp.c                  |  2 +-
>  7 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index bf5654ce711e..51857117ac09 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -249,6 +249,10 @@ struct inet_sock {
>  	__be32			mc_addr;
>  	struct ip_mc_socklist __rcu	*mc_list;
>  	struct inet_cork_full	cork;
> +	struct {
> +		__u16 lo;
> +		__u16 hi;
> +	}			local_port_range;
>  };
>  
>  #define IPCORK_OPT	1	/* ip-options has been held in ipcork.opt */
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 144bdfbb25af..c3fffaa92d6e 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -340,7 +340,8 @@ static inline u64 snmp_fold_field64(void __percpu *mib, int offt, size_t syncp_o
>  	} \
>  }
>  
> -void inet_get_local_port_range(struct net *net, int *low, int *high);
> +void inet_get_local_port_range(const struct net *net, int *low, int *high);
> +void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high);
>  
>  #ifdef CONFIG_SYSCTL
>  static inline bool inet_is_local_reserved_port(struct net *net, unsigned short port)
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index 07a4cb149305..4b7f2df66b99 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -162,6 +162,7 @@ struct in_addr {
>  #define MCAST_MSFILTER			48
>  #define IP_MULTICAST_ALL		49
>  #define IP_UNICAST_IF			50
> +#define IP_LOCAL_PORT_RANGE		51
>  
>  #define MCAST_EXCLUDE	0
>  #define MCAST_INCLUDE	1
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index d1f837579398..1049a9b8d152 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -117,7 +117,7 @@ bool inet_rcv_saddr_any(const struct sock *sk)
>  	return !sk->sk_rcv_saddr;
>  }
>  
> -void inet_get_local_port_range(struct net *net, int *low, int *high)
> +void inet_get_local_port_range(const struct net *net, int *low, int *high)
>  {
>  	unsigned int seq;
>  
> @@ -130,6 +130,27 @@ void inet_get_local_port_range(struct net *net, int *low, int *high)
>  }
>  EXPORT_SYMBOL(inet_get_local_port_range);
>  
> +void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high)
> +{
> +	const struct inet_sock *inet = inet_sk(sk);
> +	const struct net *net = sock_net(sk);
> +	int lo, hi, sk_lo, sk_hi;
> +
> +	inet_get_local_port_range(net, &lo, &hi);
> +
> +	sk_lo = inet->local_port_range.lo;
> +	sk_hi = inet->local_port_range.hi;
> +
> +	if (unlikely(sk_lo && sk_lo <= hi))
> +		lo = max(lo, sk_lo);
> +	if (unlikely(sk_hi && sk_hi >= lo))
> +		hi = min(hi, sk_hi);

nit: The min of sysctl lo/hi is 1, so

        if (unlikely(lo <= sk_lo && sk_lo <= hi))
                lo = sk_lo;
        if (unlikely(lo <= sk_hi && sk_hi <= hi))
                hi = sk_hi;

this seems cleaner.


> +
> +	*low = lo;
> +	*high = hi;
> +}
> +EXPORT_SYMBOL(inet_sk_get_local_port_range);
> +
>  static bool inet_use_bhash2_on_bind(const struct sock *sk)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> @@ -316,7 +337,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
>  ports_exhausted:
>  	attempt_half = (sk->sk_reuse == SK_CAN_REUSE) ? 1 : 0;
>  other_half_scan:
> -	inet_get_local_port_range(net, &low, &high);
> +	inet_sk_get_local_port_range(sk, &low, &high);
>  	high++; /* [32768, 60999] -> [32768, 61000[ */
>  	if (high - low < 4)
>  		attempt_half = 0;
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 24a38b56fab9..22ee5f23ee5b 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -1013,7 +1013,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  
>  	l3mdev = inet_sk_bound_l3mdev(sk);
>  
> -	inet_get_local_port_range(net, &low, &high);
> +	inet_sk_get_local_port_range(sk, &low, &high);
>  	high++; /* [32768, 60999] -> [32768, 61000[ */
>  	remaining = high - low;
>  	if (likely(remaining > 1))
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 9f92ae35bb01..b511ff0adc0a 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -923,6 +923,7 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
>  	case IP_CHECKSUM:
>  	case IP_RECVFRAGSIZE:
>  	case IP_RECVERR_RFC4884:
> +	case IP_LOCAL_PORT_RANGE:
>  		if (optlen >= sizeof(int)) {
>  			if (copy_from_sockptr(&val, optval, sizeof(val)))
>  				return -EFAULT;
> @@ -1365,6 +1366,20 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
>  		WRITE_ONCE(inet->min_ttl, val);
>  		break;
>  
> +	case IP_LOCAL_PORT_RANGE:
> +	{
> +		const __u16 lo = val;
> +		const __u16 hi = val >> 16;
> +
> +		if (optlen != sizeof(__u32))
> +			goto e_inval;
> +		if (lo != 0 && hi != 0 && lo > hi)
> +			goto e_inval;
> +
> +		inet->local_port_range.lo = lo;
> +		inet->local_port_range.hi = hi;
> +		break;
> +	}
>  	default:
>  		err = -ENOPROTOOPT;
>  		break;
> @@ -1743,6 +1758,9 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
>  	case IP_MINTTL:
>  		val = inet->min_ttl;
>  		break;
> +	case IP_LOCAL_PORT_RANGE:
> +		val = inet->local_port_range.hi << 16 | inet->local_port_range.lo;
> +		break;
>  	default:
>  		sockopt_release_sock(sk);
>  		return -ENOPROTOOPT;
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 9592fe3e444a..c605d171eb2d 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -248,7 +248,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
>  		int low, high, remaining;
>  		unsigned int rand;
>  
> -		inet_get_local_port_range(net, &low, &high);
> +		inet_sk_get_local_port_range(sk, &low, &high);
>  		remaining = (high - low) + 1;
>  
>  		rand = get_random_u32();
> 
> -- 
> 2.39.0
