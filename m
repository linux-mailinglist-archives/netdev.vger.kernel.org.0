Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8995B63D5
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiILWxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiILWxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:53:13 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801D921264
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 15:53:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e20so17855847wri.13
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 15:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=lvI5kZPemOjKk2UtxEbWwdB/69XnBU6gPdfTYsM95Qg=;
        b=dT7MXce9EVLzf0eAbSFPZuE+D8EiZiNFfL2OFUElnjR8Zs+MftjsLE7OKpdp60b4RP
         wAor44xxrlUh6v0ihp5a5mzLwWx/MEL1h+gKGMn45XS37QE0M/S+9A2bANDTWi2M/DhY
         +o0fyxzZ8eTEPBXuU3hssRevywjzmCwRDBsZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lvI5kZPemOjKk2UtxEbWwdB/69XnBU6gPdfTYsM95Qg=;
        b=vvMywPLDbU/WT3kRRaSdtco/+3zn+v9PuWsolTXglhIK0eOFjOECeyFnPeKTyg6Ta1
         yWaha0t9OfZ+VNYf9lL35WtCxgwn89Zv77I1rS7ggfHEcd1IjmeN16Ye9vgfTRF2m1iM
         FFChxJpVz+oDTqfQSgDzrdT/e8khF65OcqMsP15uJxWzC5EoVW8PCSHwvbosXhR6ssjd
         9FYz2xBow2mAKO8E2Agfium3ACHins1kgrEFsUeLXoL/LhXOq/2eYOSYWUpcUcvjNiik
         GnyGTmXvGiWQeF0KSWny3Tpk3idNCNy+iYKTQxZk6UXqh7OQRHGVtZKYL9zAv73EY4zX
         DJLA==
X-Gm-Message-State: ACgBeo2Z5cmN9Gv0DjafxFmagHEI2xcbHsKT1eLm1wRvf5sh0Qs81iL1
        ME/yxLByIJNl2khLw3t0oAtAuomThtGaTQ==
X-Google-Smtp-Source: AA6agR5RZcwxvZOl0xSMRO+IhyOq8OY71GfXc6m/k9O0RBkCqgxCakGZx9wwjN315Y4BeH14I+SL1Q==
X-Received: by 2002:a5d:55c8:0:b0:226:d1d7:a15f with SMTP id i8-20020a5d55c8000000b00226d1d7a15fmr16468051wrw.249.1663023189651;
        Mon, 12 Sep 2022 15:53:09 -0700 (PDT)
Received: from cloudflare.com ([86.47.125.193])
        by smtp.gmail.com with ESMTPSA id az8-20020a05600c600800b003b27f644488sm11507588wmb.29.2022.09.12.15.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 15:53:09 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Subject: [RFC net-next] inet: Add IP_LOCAL_PORT_RANGE socket option
Date:   Tue, 13 Sep 2022 00:53:08 +0200
Message-Id: <20220912225308.93659-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC patch accompanying an LPC 2022 talk [1].

Users that want to multiplex outgoing connections from several hosts over a
single public IP address traditionally reach for SNAT. However, SNAT
requires either central or distributed state keeping.

As a stateless alternative, users can also share an IP address by
partitioning the available port range between hosts.

Such a setup has two pieces:

1. Applications which open connections from the host-assigned port range.
2. Return traffic routing based on both the destination IP and port.

If an application needs to open an outgoing connection from a given port
range (within the ephemeral port range), today it has two options:

1. Manually set the source port to a value within the desired range at
   bind() time.

   Local port sharing has to be enabled (REUSEADDR), or the number of
   outgoing connections will be limited to the number of ports within the
   range.

   Also, 4-tuple conflicts must be handled in user-space by checking for
   connect() errors, in TCP case, or resorting to hacks involving querying
   Netlink, in UDP case [2]. If the selected source port happens to be
   busy, user-space needs to retry with a different port number.

2. Use the per-netns sysctl to set the ephemeral port range to the desired
   interval. This affects all existing and created in the future sockets
   within the netns.

    system("sysctl -w net.ipv4.ip_local_port_range='60000 60511'")

    s = socket(AF_INET, SOCK_STREAM)
    s.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
    s.bind(("192.0.2.1", 0))
    s.connect(("1.1.1.1", 53))

To address this use-case, add a new socket option at the SOL_IP level,
named IP_LOCAL_PORT_RANGE. The new option intended for clamping down the
per-netns ephemeral port range for each socket individually.

uAPIw-ise, the low and high range bounds are passed to the kernel as u16
values packed into a u32 to avoid pointer passing:

    PORT_LO = 40_000
    PORT_HI = 40_511

    s = socket(AF_INET, SOCK_STREAM)
    v = struct.pack("I", PORT_LO | (PORT_HI << 16))
    s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
    s.bind(("127.0.0.1", 0))
    s.getsockname() # Between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
                    # if there is a free port. EADDRINUSE otherwise.

As this is an RFC submission and there are still a few things left to do:

- split code into patches
- add support for IPv6 sockets
- add selftests/net
- add man page docs

[1] https://lpc.events/event/16/contributions/1349/
[2] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet_sock.h         |  4 ++++
 include/net/ip.h                |  3 ++-
 include/uapi/linux/in.h         |  1 +
 net/ipv4/inet_connection_sock.c | 22 ++++++++++++++++++++--
 net/ipv4/inet_hashtables.c      |  2 +-
 net/ipv4/ip_sockglue.c          | 15 +++++++++++++++
 net/ipv4/udp.c                  |  2 +-
 7 files changed, 44 insertions(+), 5 deletions(-)

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
index 038097c2a152..8daed4f49cb8 100644
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
index 578daa6f816b..7ea344e80a1c 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -159,6 +159,7 @@ struct in_addr {
 #define MCAST_MSFILTER			48
 #define IP_MULTICAST_ALL		49
 #define IP_UNICAST_IF			50
+#define IP_LOCAL_PORT_RANGE		51
 
 #define MCAST_EXCLUDE	0
 #define MCAST_INCLUDE	1
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f0038043b661..bd6cad27fd27 100644
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
@@ -300,7 +318,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 ports_exhausted:
 	attempt_half = (sk->sk_reuse == SK_CAN_REUSE) ? 1 : 0;
 other_half_scan:
-	inet_get_local_port_range(net, &low, &high);
+	inet_sk_get_local_port_range(sk, &low, &high);
 	high++; /* [32768, 60999] -> [32768, 61000[ */
 	if (high - low < 4)
 		attempt_half = 0;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 60d77e234a68..7710b417ec5b 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -941,7 +941,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
 
-	inet_get_local_port_range(net, &low, &high);
+	inet_sk_get_local_port_range(sk, &low, &high);
 	high++; /* [32768, 60999] -> [32768, 61000[ */
 	remaining = high - low;
 	if (likely(remaining > 1))
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 6e19cad154f5..718c74e10ad3 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -922,6 +922,7 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 	case IP_CHECKSUM:
 	case IP_RECVFRAGSIZE:
 	case IP_RECVERR_RFC4884:
+	case IP_LOCAL_PORT_RANGE:
 		if (optlen >= sizeof(int)) {
 			if (copy_from_sockptr(&val, optval, sizeof(val)))
 				return -EFAULT;
@@ -1364,6 +1365,20 @@ int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		WRITE_ONCE(inet->min_ttl, val);
 		break;
 
+	case IP_LOCAL_PORT_RANGE:
+	{
+		const __u16 lo = (__u32)val;
+		const __u16 hi = (__u32)val >> 16;
+
+		if (optlen != sizeof(__u32))
+			goto e_inval;
+		if (lo > hi)
+			goto e_inval;
+
+		inet->local_port_range.lo = lo;
+		inet->local_port_range.hi = hi;
+		break;
+	}
 	default:
 		err = -ENOPROTOOPT;
 		break;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cd72158e953a..ed75662bc33e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -243,7 +243,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		unsigned short first, last;
 		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
 
-		inet_get_local_port_range(net, &low, &high);
+		inet_sk_get_local_port_range(sk, &low, &high);
 		remaining = (high - low) + 1;
 
 		rand = prandom_u32();
-- 
2.37.2

