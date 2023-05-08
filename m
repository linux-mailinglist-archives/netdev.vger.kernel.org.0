Return-Path: <netdev+bounces-980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0490B6FBB0F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 00:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FD7A280DAA
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA2A125D9;
	Mon,  8 May 2023 22:28:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1CBDDB3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 22:28:06 +0000 (UTC)
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E2B7AB1
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 15:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683584883; x=1715120883;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oUit3/XkjL3fl0Ic6E4cIkujACVA+Bdue/sVmk9Hjqk=;
  b=tZJJHR2s0gHveaQKxjCoQ2CXrccymjl1suF97ZB/dUiXplPZDvab+zfz
   s+B96dNBCPd7oiMRRvMNhF0hVWYQffYfs+9DazlCvxViIvsTt/nHa9Khs
   XFOkJqwUV4oXHqVIuh0f/ZYRP+kl8EmuWb4cH1QVWBF15arb/i+YxUSJ1
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,259,1677542400"; 
   d="scan'208";a="1129657933"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 22:27:58 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id B273BC16A0;
	Mon,  8 May 2023 22:27:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 22:27:56 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 22:27:54 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>
CC: Mubashir Adnan Qureshi <mubashirq@google.com>, Neal Cardwell
	<ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, "Kuniyuki
 Iwashima" <kuni1840@gmail.com>, <netdev@vger.kernel.org>, Jon Zobrist
	<zob@amazon.com>
Subject: [PATCH v1 net-next] tcp: Add net.ipv4.tcp_reset_challenge.
Date: Mon, 8 May 2023 15:27:36 -0700
Message-ID: <20230508222736.13249-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.41]
X-ClientProxiedBy: EX19D039UWB003.ant.amazon.com (10.13.138.93) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Our Network Load Balancer (NLB) [0] consists of multiple nodes with unique
IP addresses.  These nodes forward TCP flows from clients to backend
targets by modifying the destination IP address.  NLB offers an option [1]
to preserve the client's source IP address and port when routing packets
to backend targets.

When a client connects to two different NLB nodes, they may select the same
backend target.  If the client uses the same source IP and port, the two
flows at the backend side will have the same 4-tuple.

                         +---------------+
            1st flow     |  NLB Node #1  |   src: 10.0.0.215:60000
         +------------>  |   10.0.3.4    |  +------------+
         |               |    :10000     |               |
         +               +---------------+               v
  +------------+                                   +------------+
  |   Client   |                                   |   Target   |
  | 10.0.0.215 |                                   | 10.0.3.249 |
  |   :60000   |                                   |   :10000   |
  +------------+                                   +------------+
         +               +---------------+               ^
         |               |  NLB Node #2  |               |
         +------------>  |   10.0.4.62   |  +------------+
            2nd flow     |    :10000     |   src: 10.0.0.215:60000
                         +---------------+

The kernel responds to the SYN of the 2nd flow with Challenge ACK.  In this
situation, there are multiple valid reply paths, but the flows behind NLB
are tracked to ensure symmetric routing [2].  So, the Challenge ACK is
routed back to the 2nd NLB node.

The 2nd NLB node forwards the Challenge ACK to the client, but the client
sees it as an invalid response to SYN in tcp_rcv_synsent_state_process()
and finally sends RST in tcp_v[46]_do_rcv() based on the sequence number
by tcp_v[46]_send_reset().  The RST effectively closes the first connection
on the target, and a retransmitted SYN successfully establishes the 2nd
connection.

  On client:
  10.0.0.215.60000 > 10.0.3.4.10000: Flags [S], seq 772948343  ... via NLB Node #1
  10.0.3.4.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack 772948344
  10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675

  10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743 ... via NLB Node #2
  10.0.4.62.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... Invalid Challenge ACK
  10.0.0.215.60000 > 10.0.4.62.10000: Flags [R], seq 772948344 ... RST w/ correct seq #
  10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743
  10.0.4.62.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack 248180744
  10.0.0.215.60000 > 10.0.4.62.10000: Flags [.], ack 4160908214

  On target:
  10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 772948343 ... via NLB Node #1
  10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack 772948344
  10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 3739044675

  10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743 ... via NLB Node #2
  10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... Forwarded to 2nd flow
  10.0.0.215.60000 > 10.0.3.249.10000: Flags [R], seq 772948344 ... Close the 1st connection
  10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743
  10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack 248180744
  10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 4160908214

The first connection is still alive from the client's point of view.  When
the client sends data over the first connection, the target responds with
Challenge ACK.  The Challenge ACK is routed back to the 1st connection, and
the client responds with Dup ACK, and the target responds to the Dup ACK
with Challenge ACK, and this continues.

  On client:
  10.0.0.215.60000 > 10.0.3.4.10000: Flags [P.], seq 772948344:772948349, ack 3739044675, length 5
  10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0  ... Challenge ACK
  10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675, length 0 ... Dup ACK
  10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0  ... Challenge ACK
  ...

In RFC 5961, Challenge ACK assumes that it will be routed back via an
asymmetric path to the peer of the established connection.  However, in
a situation where multiple valid reply paths are tracked, Challenge ACK
gives a hint to snipe another connection and also triggers the Challenge
ACK Dup ACK war on the connection.

A new sysctl knob, net.ipv4.tcp_reset_challenge, allows us to respond to
invalid packets described in RFC 5961 with RST and keep the established
socket open.

  After sysctl -w net.ipv4.tcp_reset_challenge=1 :

  On client:
  IP 10.0.0.215.60000 > 10.0.3.4.10000: Flags [S], seq 2603746121  ... via NLB Node #1
  IP 10.0.3.4.10000 > 10.0.0.215.60000: Flags [S.], seq 1274876087, ack 2603746122
  IP 10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 1274876088

  IP 10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 1657678296 ... via NLB Node #2
  IP 10.0.4.62.10000 > 10.0.0.215.60000: Flags [R.], seq 0, ack 1657678297

  On target:
  10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2603746121   ... via NLB Node #1
  10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 1274876087, ack 2603746122
  10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 1274876088

  10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 1657678296   ... via NLB Node #2
  10.0.3.249.10000 > 10.0.0.215.60000: Flags [R.], seq 0, ack 1657678297

Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html [0]
Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation [1]
Link: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/security-group-connection-tracking.html#automatic-tracking [2]
Suggested-by: Jon Zobrist <zob@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 Documentation/networking/ip-sysctl.rst | 10 ++++++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 net/ipv4/tcp_input.c                   | 20 ++++++++++++++------
 net/ipv4/tcp_ipv4.c                    |  1 +
 5 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 6ec06a33688a..fe90fdd60cc8 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1045,6 +1045,16 @@ tcp_challenge_ack_limit - INTEGER
 	TCP stack implements per TCP socket limits anyway.
 	Default: INT_MAX (unlimited)
 
+tcp_reset_challenge - BOOLEAN
+	If set, the TCP stack respond to invalid packets decribed in
+	RFC 5961 with RST without close()ing TCP socket.
+
+	This feature is useful where multiple valid reply paths are
+	tracked	and the response is sent back via symmetric path to
+	the original sender of the invalid packets.
+
+	Default: 0
+
 tcp_ehash_entries - INTEGER
 	Show the number of hash buckets for TCP sockets in the current
 	networking namespace.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index db762e35aca9..c70f26f49e9e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -131,6 +131,7 @@ struct netns_ipv4 {
 	u8 sysctl_tcp_syncookies;
 	u8 sysctl_tcp_migrate_req;
 	u8 sysctl_tcp_comp_sack_nr;
+	u8 sysctl_tcp_reset_challenge;
 	int sysctl_tcp_reordering;
 	u8 sysctl_tcp_retries1;
 	u8 sysctl_tcp_retries2;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 40fe70fc2015..e6cf1cd310bf 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1269,6 +1269,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "tcp_reset_challenge",
+		.data		= &init_net.ipv4.sysctl_tcp_reset_challenge,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{
 		.procname	= "tcp_min_tso_segs",
 		.data		= &init_net.ipv4.sysctl_tcp_min_tso_segs,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a057330d6f59..18370dd7c68b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -98,7 +98,7 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define FLAG_SET_XMIT_TIMER	0x1000 /* Set TLP or RTO timer */
 #define FLAG_SACK_RENEGING	0x2000 /* snd_una advanced to a sacked seq */
 #define FLAG_UPDATE_TS_RECENT	0x4000 /* tcp_replace_ts_recent() */
-#define FLAG_NO_CHALLENGE_ACK	0x8000 /* do not call tcp_send_challenge_ack()	*/
+#define FLAG_NO_CHALLENGE_ACK	0x8000 /* do not call tcp_respond_challenge() */
 #define FLAG_ACK_MAYBE_DELAYED	0x10000 /* Likely a delayed ACK */
 #define FLAG_DSACK_TLP		0x20000 /* DSACK for tail loss probe */
 
@@ -3658,6 +3658,14 @@ static void tcp_send_challenge_ack(struct sock *sk)
 	}
 }
 
+static void tcp_respond_challenge(struct sock *sk, struct sk_buff *skb)
+{
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reset_challenge))
+		sk->sk_prot->rsk_prot->send_reset(sk, skb);
+	else
+		tcp_send_challenge_ack(sk);
+}
+
 static void tcp_store_ts_recent(struct tcp_sock *tp)
 {
 	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
@@ -3757,7 +3765,7 @@ static u32 tcp_newly_delivered(struct sock *sk, u32 prior_delivered, int flag)
 }
 
 /* This routine deals with incoming acks, but not outgoing ones. */
-static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
+static int tcp_ack(struct sock *sk, struct sk_buff *skb, int flag)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -3788,7 +3796,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		/* RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation] */
 		if (before(ack, prior_snd_una - tp->max_window)) {
 			if (!(flag & FLAG_NO_CHALLENGE_ACK))
-				tcp_send_challenge_ack(sk);
+				tcp_respond_challenge(sk, skb);
 			return -SKB_DROP_REASON_TCP_TOO_OLD_ACK;
 		}
 		goto old_ack;
@@ -5787,7 +5795,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		if (tp->syn_fastopen && !tp->data_segs_in &&
 		    sk->sk_state == TCP_ESTABLISHED)
 			tcp_fastopen_active_disable(sk);
-		tcp_send_challenge_ack(sk);
+		tcp_respond_challenge(sk, skb);
 		SKB_DR_SET(reason, TCP_RESET);
 		goto discard;
 	}
@@ -5802,7 +5810,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		if (syn_inerr)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
-		tcp_send_challenge_ack(sk);
+		tcp_respond_challenge(sk, skb);
 		SKB_DR_SET(reason, TCP_INVALID_SYN);
 		goto discard;
 	}
@@ -6542,7 +6550,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	if (!acceptable) {
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
-		tcp_send_challenge_ack(sk);
+		tcp_respond_challenge(sk, skb);
 		SKB_DR_SET(reason, TCP_OLD_ACK);
 		goto discard;
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39bda2b1066e..fcd809d11e46 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3236,6 +3236,7 @@ static int __net_init tcp_sk_init(struct net *net)
 
 	/* rfc5961 challenge ack rate limiting, per net-ns, disabled by default. */
 	net->ipv4.sysctl_tcp_challenge_ack_limit = INT_MAX;
+	net->ipv4.sysctl_tcp_reset_challenge = 0;
 
 	net->ipv4.sysctl_tcp_min_tso_segs = 2;
 	net->ipv4.sysctl_tcp_tso_rtt_log = 9;  /* 2^9 = 512 usec */
-- 
2.30.2


