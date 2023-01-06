Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8809965FF0B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjAFKhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjAFKhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:37:45 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2626C2A0
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:37:44 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ud5so2624069ejc.4
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 02:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PcKgZJ+P+SVP0hDiVyMH1T7PA6ZiK6DYMeWb6TJB5DE=;
        b=a9rdlVtcdYHy2N3YIpJU24BGhabHMiZSBEk5MG2RLE4ff2fMVfB5RE91SwntgWJmJs
         0fSIxSzU3iTTTSkPGtkY388s6JJPWjnMOAlBf1O6aM4MUsll2Oh/90RwIMOmyVKkXDPm
         pL7g5OekTaCPbVzCCLfAB91OyFOuVyGk9U+9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PcKgZJ+P+SVP0hDiVyMH1T7PA6ZiK6DYMeWb6TJB5DE=;
        b=d1I9ZtFn3teqMDPd/tYcls/aaNt1CkffTFhNOZrVf3jlqz0uzHyvNxwAgz5mF5lW5F
         laA4/8gu1SGvsqI5grG+IsSjIZYjvAMcI5a+0bnJzqE/NCV1pj9BKSgY1b1ll0+O1NgM
         eetrSOKaWT1n7lF2QNc1LW41ubfwe3ctTIiKhHaNLp8+XHqE3G1ur8MkXd/ShKRFNr2E
         MYbio93Xa+xIYcrjW8rJIJW/OwKtnAl4RyHXEmNlJW6hlKE6xJy0xH5MDnY33YSw+Tnd
         dSI0Y835EKPOTT3dSCoudSL2zJM3Y9wZ3AyeXObB39pD7ouh8sPA2MXcOeU7hy1CLsOO
         8WYg==
X-Gm-Message-State: AFqh2kofoXUE5OlFJOwB6zExEbrkeATUPSzFSVxozEOA0bMxYP4FFsBE
        0U3mj3oWe4wP1nazBfd5dwyScJVsNKnXR8mf
X-Google-Smtp-Source: AMrXdXuN00eFR49/AmE9orjfe0ug55vhSeROBbrftojJzrs+r+SwJkpVxn+T1+K5tPTIGN8xJ8Ys1w==
X-Received: by 2002:a17:907:6d0c:b0:7c1:652:d109 with SMTP id sa12-20020a1709076d0c00b007c10652d109mr55920501ejc.35.1673001462236;
        Fri, 06 Jan 2023 02:37:42 -0800 (PST)
Received: from cloudflare.com (79.184.146.66.ipv4.supernova.orange.pl. [79.184.146.66])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906539000b0084cb26c3b71sm282877ejo.1.2023.01.06.02.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 02:37:41 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel-team@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH net-next 1/2] inet: Add IP_LOCAL_PORT_RANGE socket option
Date:   Fri,  6 Jan 2023 11:37:37 +0100
Message-Id: <20221221-sockopt-port-range-v1-1-e2b094b60ffd@cloudflare.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221-sockopt-port-range-v1-0-e2b094b60ffd@cloudflare.com>
References: <20221221-sockopt-port-range-v1-0-e2b094b60ffd@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
of u16 values packed into a u32. This avoids pointer passing.

  PORT_LO = 40_000
  PORT_HI = 40_511

  s = socket(AF_INET, SOCK_STREAM)
  v = struct.pack("I", PORT_LO | (PORT_HI << 16))
  s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
  s.bind(("127.0.0.1", 0))
  s.getsockname()
  # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
  # if there is a free port. EADDRINUSE otherwise.

[1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116

Reviewed-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet_sock.h         |  4 ++++
 include/net/ip.h                |  3 ++-
 include/uapi/linux/in.h         |  1 +
 net/ipv4/inet_connection_sock.c | 22 ++++++++++++++++++++--
 net/ipv4/inet_hashtables.c      |  2 +-
 net/ipv4/ip_sockglue.c          | 18 ++++++++++++++++++
 net/ipv4/udp.c                  |  2 +-
 7 files changed, 47 insertions(+), 5 deletions(-)

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
index d1f837579398..ec40c9ee753c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -117,7 +117,7 @@ bool inet_rcv_saddr_any(const struct sock *sk)
 	return !sk->sk_rcv_saddr;
 }
 
-void inet_get_local_port_range(struct net *net, int *low, int *high)
+void inet_get_local_port_range(const struct net *net, int *low, int *high)
 {
 	unsigned int seq;
 
@@ -130,6 +130,24 @@ void inet_get_local_port_range(struct net *net, int *low, int *high)
 }
 EXPORT_SYMBOL(inet_get_local_port_range);
 
+void inet_sk_get_local_port_range(const struct sock *sk, int *low, int *high)
+{
+	const struct inet_sock *inet = inet_sk(sk);
+	const struct net *net = sock_net(sk);
+	int lo, hi;
+
+	inet_get_local_port_range(net, &lo, &hi);
+
+	if (unlikely(inet->local_port_range.lo))
+		lo = clamp_val(inet->local_port_range.lo, lo, hi);
+	if (unlikely(inet->local_port_range.hi))
+		hi = clamp_val(inet->local_port_range.hi, lo, hi);
+
+	*low = lo;
+	*high = hi;
+}
+EXPORT_SYMBOL(inet_sk_get_local_port_range);
+
 static bool inet_use_bhash2_on_bind(const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
@@ -316,7 +334,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 ports_exhausted:
 	attempt_half = (sk->sk_reuse == SK_CAN_REUSE) ? 1 : 0;
 other_half_scan:
-	inet_get_local_port_range(net, &low, &high);
+	inet_sk_get_local_port_range(sk, &low, &high);
 	high++; /* [32768, 60999] -> [32768, 61000[ */
 	if (high - low < 4)
 		attempt_half = 0;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 24a38b56fab9..22ee5f23ee5b 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1013,7 +1013,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
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

-- 
2.38.1
