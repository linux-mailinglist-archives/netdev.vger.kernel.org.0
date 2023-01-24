Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A5367995B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbjAXNhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbjAXNhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:37:01 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D50FB774
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:36:58 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id az20so39121943ejc.1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhMgbNNUSZytFA/Y6WjKvuRpYf5a6aCaKOI18HdUwxM=;
        b=BHQMUQmTeL3Zn4fOd86j3nTAaOXjuwDhPHDP9kIAX1Tb6YYPazGF5zjVzJO7381NhI
         rt6R3gIbZV0zS5hMvpDCoyaU/i2PEz5h38pe7cVjp4hRTlA5pACAtb0i0r8GvTHDDSCV
         MuPFkInK6EmOVAnP+2/fIBcG2trNRMY07IpMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LhMgbNNUSZytFA/Y6WjKvuRpYf5a6aCaKOI18HdUwxM=;
        b=xj7r/84Hwt3R2ehBBh11oWSAjajUuW9QgHXSeeMXt1DHBY7kUGJfzPIb20zxLpnnjE
         uIB8fITklS/DHoBbo8f61JX4r4OIYb+C5mjPVhZH660j2ZRhz9MjtU+iZR6J/TKwCkUx
         LakY9ogf4cy2MWiBYfwmKf04lMTbLW6GPdXp3IhTpjT+UfkzhPDQY5g4zzJbQMYXdPJP
         iGVnXvsB/EIDs928GpyObWy2Mpuwz2d4WGtp1QYciCYYodj5kIW2C/RyBnx3/6KZEaBs
         4tE9BCrye5jbArddVZtgc4g67eaQikkVw9qObGcCGmAX34atD4SQohrNR3MTZfyyG8B0
         v67g==
X-Gm-Message-State: AFqh2krmBM7BYYzvkWmYw9Ia/LBLxVZr2DjuF4Fq2tWD6MgRs6Mt5DBR
        4gm4jD9DBDbBEzJGEtr78qKgUQ==
X-Google-Smtp-Source: AMrXdXv0n50uMIR/0Py+MZj7zFeyw+QF/8tcjQlYq080o0/bjpsSPvi/A7ic7kmo0cX5puKc+mgl3Q==
X-Received: by 2002:a17:907:98b2:b0:83f:1e04:b776 with SMTP id ju18-20020a17090798b200b0083f1e04b776mr27686914ejc.40.1674567416693;
        Tue, 24 Jan 2023 05:36:56 -0800 (PST)
Received: from cloudflare.com (79.184.123.123.ipv4.supernova.orange.pl. [79.184.123.123])
        by smtp.gmail.com with ESMTPSA id qc26-20020a170906d8ba00b00877a351cedcsm909597ejb.110.2023.01.24.05.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 05:36:56 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Tue, 24 Jan 2023 14:36:43 +0100
Subject: [PATCH net-next v6 1/2] inet: Add IP_LOCAL_PORT_RANGE socket option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221221-sockopt-port-range-v6-1-be255cc0e51f@cloudflare.com>
References: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
In-Reply-To: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>,
        Leon Romanovsky <leon@kernel.org>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
X-Mailer: b4 0.11.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users who want to share a single public IP address for outgoing connections
between several hosts traditionally reach for SNAT. However, SNAT requires
state keeping on the node(s) performing the NAT.

A stateless alternative exists, where a single IP address used for egress
can be shared between several hosts by partitioning the available ephemeral
port range. In such a setup:

1. Each host gets assigned a disjoint range of ephemeral ports.
2. Applications open connections from the host-assigned port range.
3. Return traffic gets routed to the host based on both, the destination IP
   and the destination port.

An application which wants to open an outgoing connection (connect) from a
given port range today can choose between two solutions:

1. Manually pick the source port by bind()'ing to it before connect()'ing
   the socket.

   This approach has a couple of downsides:

   a) Search for a free port has to be implemented in the user-space. If
      the chosen 4-tuple happens to be busy, the application needs to retry
      from a different local port number.

      Detecting if 4-tuple is busy can be either easy (TCP) or hard
      (UDP). In TCP case, the application simply has to check if connect()
      returned an error (EADDRNOTAVAIL). That is assuming that the local
      port sharing was enabled (REUSEADDR) by all the sockets.

        # Assume desired local port range is 60_000-60_511
        s = socket(AF_INET, SOCK_STREAM)
        s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
        s.bind(("192.0.2.1", 60_000))
        s.connect(("1.1.1.1", 53))
        # Fails only if 192.0.2.1:60000 -> 1.1.1.1:53 is busy
        # Application must retry with another local port

      In case of UDP, the network stack allows binding more than one socket
      to the same 4-tuple, when local port sharing is enabled
      (REUSEADDR). Hence detecting the conflict is much harder and involves
      querying sock_diag and toggling the REUSEADDR flag [1].

   b) For TCP, bind()-ing to a port within the ephemeral port range means
      that no connecting sockets, that is those which leave it to the
      network stack to find a free local port at connect() time, can use
      the this port.

      IOW, the bind hash bucket tb->fastreuse will be 0 or 1, and the port
      will be skipped during the free port search at connect() time.

2. Isolate the app in a dedicated netns and use the use the per-netns
   ip_local_port_range sysctl to adjust the ephemeral port range bounds.

   The per-netns setting affects all sockets, so this approach can be used
   only if:

   - there is just one egress IP address, or
   - the desired egress port range is the same for all egress IP addresses
     used by the application.

   For TCP, this approach avoids the downsides of (1). Free port search and
   4-tuple conflict detection is done by the network stack:

     system("sysctl -w net.ipv4.ip_local_port_range='60000 60511'")

     s = socket(AF_INET, SOCK_STREAM)
     s.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
     s.bind(("192.0.2.1", 0))
     s.connect(("1.1.1.1", 53))
     # Fails if all 4-tuples 192.0.2.1:60000-60511 -> 1.1.1.1:53 are busy

  For UDP this approach has limited applicability. Setting the
  IP_BIND_ADDRESS_NO_PORT socket option does not result in local source
  port being shared with other connected UDP sockets.

  Hence relying on the network stack to find a free source port, limits the
  number of outgoing UDP flows from a single IP address down to the number
  of available ephemeral ports.

To put it another way, partitioning the ephemeral port range between hosts
using the existing Linux networking API is cumbersome.

To address this use case, add a new socket option at the SOL_IP level,
named IP_LOCAL_PORT_RANGE. The new option can be used to clamp down the
ephemeral port range for each socket individually.

The option can be used only to narrow down the per-netns local port
range. If the per-socket range lies outside of the per-netns range, the
latter takes precedence.

UAPI-wise, the low and high range bounds are passed to the kernel as a pair
of u16 values in host byte order packed into a u32. This avoids pointer
passing.

  PORT_LO = 40_000
  PORT_HI = 40_511

  s = socket(AF_INET, SOCK_STREAM)
  v = struct.pack("I", PORT_HI << 16 | PORT_LO)
  s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
  s.bind(("127.0.0.1", 0))
  s.getsockname()
  # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
  # if there is a free port. EADDRINUSE otherwise.

[1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116

Reviewed-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
v4 -> v5:
 * Use the fact that netns port range starts at 1 when clamping. (Kuniyuki)

v3 -> v4:
 * Clarify that u16 values are in host byte order (Neal)

v2 -> v3:
 * Make SCTP bind()/bind_add() respect IP_LOCAL_PORT_RANGE option (Eric)

v1 -> v2:
 * Fix the corner case when the per-socket range doesn't overlap with the
   per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
---
 include/net/inet_sock.h         |  4 ++++
 include/net/ip.h                |  3 ++-
 include/uapi/linux/in.h         |  1 +
 net/ipv4/inet_connection_sock.c | 25 +++++++++++++++++++++++--
 net/ipv4/inet_hashtables.c      |  2 +-
 net/ipv4/ip_sockglue.c          | 18 ++++++++++++++++++
 net/ipv4/udp.c                  |  2 +-
 net/sctp/socket.c               |  2 +-
 8 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index bf5654ce711e..51857117ac09 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -249,6 +249,10 @@ struct inet_sock {
 	__be32			mc_addr;
 	struct ip_mc_socklist __rcu	*mc_list;
 	struct inet_cork_full	cork;
+	struct {
+		__u16 lo;
+		__u16 hi;
+	}			local_port_range;
 };
 
 #define IPCORK_OPT	1	/* ip-options has been held in ipcork.opt */
diff --git a/include/net/ip.h b/include/net/ip.h
index 144bdfbb25af..c3fffaa92d6e 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -340,7 +340,8 @@ static inline u64 snmp_fold_field64(void __percpu *mib, int offt, size_t syncp_o
 	} \
 }
 
-void inet_get_local_port_range(struct net *net, int *low, int *high);
+void inet_get_local_port_range(const struct net *net, int *low, int *high);
+void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high);
 
 #ifdef CONFIG_SYSCTL
 static inline bool inet_is_local_reserved_port(struct net *net, unsigned short port)
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 07a4cb149305..4b7f2df66b99 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -162,6 +162,7 @@ struct in_addr {
 #define MCAST_MSFILTER			48
 #define IP_MULTICAST_ALL		49
 #define IP_UNICAST_IF			50
+#define IP_LOCAL_PORT_RANGE		51
 
 #define MCAST_EXCLUDE	0
 #define MCAST_INCLUDE	1
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index d1f837579398..6ed7e65de494 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -117,7 +117,7 @@ bool inet_rcv_saddr_any(const struct sock *sk)
 	return !sk->sk_rcv_saddr;
 }
 
-void inet_get_local_port_range(struct net *net, int *low, int *high)
+void inet_get_local_port_range(const struct net *net, int *low, int *high)
 {
 	unsigned int seq;
 
@@ -130,6 +130,27 @@ void inet_get_local_port_range(struct net *net, int *low, int *high)
 }
 EXPORT_SYMBOL(inet_get_local_port_range);
 
+void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high)
+{
+	const struct inet_sock *inet = inet_sk(sk);
+	const struct net *net = sock_net(sk);
+	int lo, hi, sk_lo, sk_hi;
+
+	inet_get_local_port_range(net, &lo, &hi);
+
+	sk_lo = inet->local_port_range.lo;
+	sk_hi = inet->local_port_range.hi;
+
+	if (unlikely(lo <= sk_lo && sk_lo <= hi))
+		lo = sk_lo;
+	if (unlikely(lo <= sk_hi && sk_hi <= hi))
+		hi = sk_hi;
+
+	*low = lo;
+	*high = hi;
+}
+EXPORT_SYMBOL(inet_sk_get_local_port_range);
+
 static bool inet_use_bhash2_on_bind(const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
@@ -316,7 +337,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 ports_exhausted:
 	attempt_half = (sk->sk_reuse == SK_CAN_REUSE) ? 1 : 0;
 other_half_scan:
-	inet_get_local_port_range(net, &low, &high);
+	inet_sk_get_local_port_range(sk, &low, &high);
 	high++; /* [32768, 60999] -> [32768, 61000[ */
 	if (high - low < 4)
 		attempt_half = 0;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7a13dd7f546b..e41fdc38ce19 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1016,7 +1016,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
 
-	inet_get_local_port_range(net, &low, &high);
+	inet_sk_get_local_port_range(sk, &low, &high);
 	high++; /* [32768, 60999] -> [32768, 61000[ */
 	remaining = high - low;
 	if (likely(remaining > 1))
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 9f92ae35bb01..b511ff0adc0a 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -923,6 +923,7 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 	case IP_CHECKSUM:
 	case IP_RECVFRAGSIZE:
 	case IP_RECVERR_RFC4884:
+	case IP_LOCAL_PORT_RANGE:
 		if (optlen >= sizeof(int)) {
 			if (copy_from_sockptr(&val, optval, sizeof(val)))
 				return -EFAULT;
@@ -1365,6 +1366,20 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		WRITE_ONCE(inet->min_ttl, val);
 		break;
 
+	case IP_LOCAL_PORT_RANGE:
+	{
+		const __u16 lo = val;
+		const __u16 hi = val >> 16;
+
+		if (optlen != sizeof(__u32))
+			goto e_inval;
+		if (lo != 0 && hi != 0 && lo > hi)
+			goto e_inval;
+
+		inet->local_port_range.lo = lo;
+		inet->local_port_range.hi = hi;
+		break;
+	}
 	default:
 		err = -ENOPROTOOPT;
 		break;
@@ -1743,6 +1758,9 @@ int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_MINTTL:
 		val = inet->min_ttl;
 		break;
+	case IP_LOCAL_PORT_RANGE:
+		val = inet->local_port_range.hi << 16 | inet->local_port_range.lo;
+		break;
 	default:
 		sockopt_release_sock(sk);
 		return -ENOPROTOOPT;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9592fe3e444a..c605d171eb2d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -248,7 +248,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		int low, high, remaining;
 		unsigned int rand;
 
-		inet_get_local_port_range(net, &low, &high);
+		inet_sk_get_local_port_range(sk, &low, &high);
 		remaining = (high - low) + 1;
 
 		rand = get_random_u32();
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a98511b676cd..b91616f819de 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8322,7 +8322,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		int low, high, remaining, index;
 		unsigned int rover;
 
-		inet_get_local_port_range(net, &low, &high);
+		inet_sk_get_local_port_range(sk, &low, &high);
 		remaining = (high - low) + 1;
 		rover = get_random_u32_below(remaining) + low;
 

-- 
2.39.0
