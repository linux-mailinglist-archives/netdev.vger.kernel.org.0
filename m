Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31C0149033
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgAXVeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:34:36 -0500
Received: from mail-qk1-f201.google.com ([209.85.222.201]:48276 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgAXVeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:34:36 -0500
Received: by mail-qk1-f201.google.com with SMTP id z1so1977064qkl.15
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 13:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZAW+wqLhuL3AIHde2BcOQb0apMqRk0RwXD4C5JnXRq4=;
        b=NfARvS46ovTVDhr9GBWFdA+8ieBIpvE5UT6WJkyPVIBFSCDJ6VQluRY9Fks9e3kEHl
         Oqc7v7Dc4QjDRnUUDvbcOWYPV8SVzrNgXSAzyIhyYPShAcfK/duULFKN8oQRaSnkWBRL
         58Xd7oRNOrA4BvfaYG4zdewiEoITxZZGxR+d7zeydVa1UCsXDuXV1vfr7wXLjftASkJM
         OYHom8cSBhixqG/NBF5bbH2g/pcOzu9nMihfbeDR19W3kSkt1XYGxXkhhYCj16D0Rk/E
         l4VGGJJYKV7GWM20T3GVITJXRsVjaCm5+jPnWSxgFxpFVrjN/lZWwpR7J6PvR0AabL/W
         PB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZAW+wqLhuL3AIHde2BcOQb0apMqRk0RwXD4C5JnXRq4=;
        b=hWz3b+AyPta+ZIiW16sy0+pM/9RW8jpB2GCUlpLT4Z9hJQFlaly+KMJ015l55pY0Mm
         qmotdU6/KbOWLYQTOiLyPBuADTEVW1gjVCO7Xgv3gJnBalrYduv+q5kaZj6q5SiXDuUO
         b3v+E85F7mmRRes88eqqRLs5fAipb2r4zzjPNZ/tdlk1aA5QhZ9bcqzbzSpgT3rS7+hq
         9BoTyXQbq8IDey/IS4eK31bYXqO60r/7yLzI5Zbg8z/wQgDcHI3jR+3wC1x5w03uGFmQ
         BuQ78Ud6e2GllMXAUhRAO6teM3vZsFhCSyCqgBtwAksGPYKo1TxfX1zYVMNWSI3Gnp8f
         Lq1g==
X-Gm-Message-State: APjAAAVcfqHCs9z/BYGCmCbqBeNG+7sFb3jVHgA2fYWbg7R7DJnLbRZJ
        CbMCqxHaL2LuklRXoMWmQ7A6sVo=
X-Google-Smtp-Source: APXvYqziIN/4NH4K0nCSBRq9aDpUCYLnTXcS3jfVhjQkGkZ239uAphdhuEUspMOpn04GawzH3vxI+fo=
X-Received: by 2002:aed:3109:: with SMTP id 9mr4700525qtg.166.1579901674609;
 Fri, 24 Jan 2020 13:34:34 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:34:02 -0500
Message-Id: <20200124213402.83353-1-yyd@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net-next] tcp: export count for rehash attempts
From:   "Kevin(Yudong) Yang" <yyd@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Abdul Kabbani <akabbani@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abdul Kabbani <akabbani@google.com>

Using IPv6 flow-label to swiftly route around avoid congested or
disconnected network path can greatly improve TCP reliability.

This patch adds SNMP counters and a OPT_STATS counter to track both
host-level and connection-level statistics. Network administrators
can use these counters to evaluate the impact of this new ability better.

Export count for rehash attempts to
1) two SNMP counters: TcpTimeoutRehash (rehash due to timeouts),
   and TcpDuplicateDataRehash (rehash due to receiving duplicate
   packets)
2) Timestamping API SOF_TIMESTAMPING_OPT_STATS.

Signed-off-by: Abdul Kabbani <akabbani@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h       | 2 ++
 include/uapi/linux/snmp.h | 2 ++
 include/uapi/linux/tcp.h  | 1 +
 net/ipv4/proc.c           | 2 ++
 net/ipv4/tcp.c            | 2 ++
 net/ipv4/tcp_input.c      | 4 +++-
 net/ipv4/tcp_timer.c      | 6 ++++++
 7 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 4e2124607d325..1cf73e6f85ca8 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -386,6 +386,8 @@ struct tcp_sock {
 #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
 #endif
 
+	u16 timeout_rehash;	/* Timeout-triggered rehash attempts */
+
 	u32 rcv_ooopack; /* Received out-of-order packets, for tcpinfo */
 
 /* Receiver side RTT estimation */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 7eee233e78d27..7d91f4debc483 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -285,6 +285,8 @@ enum
 	LINUX_MIB_TCPRCVQDROP,			/* TCPRcvQDrop */
 	LINUX_MIB_TCPWQUEUETOOBIG,		/* TCPWqueueTooBig */
 	LINUX_MIB_TCPFASTOPENPASSIVEALTKEY,	/* TCPFastOpenPassiveAltKey */
+	LINUX_MIB_TCPTIMEOUTREHASH,		/* TCPTimeoutRehash */
+	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index d87184e673ca8..fd9eb8f6bcae3 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -311,6 +311,7 @@ enum {
 	TCP_NLA_DSACK_DUPS,	/* DSACK blocks received */
 	TCP_NLA_REORD_SEEN,	/* reordering events seen */
 	TCP_NLA_SRTT,		/* smoothed RTT in usecs */
+	TCP_NLA_TIMEOUT_REHASH, /* Timeout-triggered rehash attempts */
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index cc90243ccf767..2580303249e23 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -289,6 +289,8 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPRcvQDrop", LINUX_MIB_TCPRCVQDROP),
 	SNMP_MIB_ITEM("TCPWqueueTooBig", LINUX_MIB_TCPWQUEUETOOBIG),
 	SNMP_MIB_ITEM("TCPFastOpenPassiveAltKey", LINUX_MIB_TCPFASTOPENPASSIVEALTKEY),
+	SNMP_MIB_ITEM("TcpTimeoutRehash", LINUX_MIB_TCPTIMEOUTREHASH),
+	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7dfb78caedaf6..4e9e812b375f9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3337,6 +3337,7 @@ static size_t tcp_opt_stats_get_size(void)
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_DSACK_DUPS */
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_REORD_SEEN */
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_SRTT */
+		nla_total_size(sizeof(u16)) + /* TCP_NLA_TIMEOUT_REHASH */
 		0;
 }
 
@@ -3391,6 +3392,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk)
 	nla_put_u32(stats, TCP_NLA_DSACK_DUPS, tp->dsack_dups);
 	nla_put_u32(stats, TCP_NLA_REORD_SEEN, tp->reord_seen);
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
+	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 
 	return stats;
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2f475b897c116..d175319beacae 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4270,8 +4270,10 @@ static void tcp_rcv_spurious_retrans(struct sock *sk, const struct sk_buff *skb)
 	 * The receiver remembers and reflects via DSACKs. Leverage the
 	 * DSACK state and change the txhash to re-route speculatively.
 	 */
-	if (TCP_SKB_CB(skb)->seq == tcp_sk(sk)->duplicate_sack[0].start_seq)
+	if (TCP_SKB_CB(skb)->seq == tcp_sk(sk)->duplicate_sack[0].start_seq) {
 		sk_rethink_txhash(sk);
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPDUPLICATEDATAREHASH);
+	}
 }
 
 static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 1097b438befe1..c3f26dcd6704e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -223,6 +223,9 @@ static int tcp_write_timeout(struct sock *sk)
 			dst_negative_advice(sk);
 		} else {
 			sk_rethink_txhash(sk);
+			tp->timeout_rehash++;
+			__NET_INC_STATS(sock_net(sk),
+					LINUX_MIB_TCPTIMEOUTREHASH);
 		}
 		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
 		expired = icsk->icsk_retransmits >= retry_until;
@@ -234,6 +237,9 @@ static int tcp_write_timeout(struct sock *sk)
 			dst_negative_advice(sk);
 		} else {
 			sk_rethink_txhash(sk);
+			tp->timeout_rehash++;
+			__NET_INC_STATS(sock_net(sk),
+					LINUX_MIB_TCPTIMEOUTREHASH);
 		}
 
 		retry_until = net->ipv4.sysctl_tcp_retries2;
-- 
2.25.0.341.g760bfbb309-goog

