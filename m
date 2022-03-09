Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7684D2694
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiCIB7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiCIB7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:59:06 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DCD4C792
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 17:58:07 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id e15so936545pfv.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 17:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tSmFUu+ge0MP/jenrZcT7/NZQRt0kD5JNu6kc/qJIP4=;
        b=gkqKLDPJmr5z+cvLHAkTbHOUsJUWdsSPhOqf2zUuDCIsRcLq65UzO0D3ds2NE0zTO0
         i+slwQsf57CPAJIM+NbbYUKCJiLkJyh/4VF/cKSqB3Z8HIgnuAuHfDBWBx2ZxZJyw953
         Yfl2DCRZkn1Tiok/j3uWwJTt+H4Vm6uPejd7CQ4CiC3pF14lJaetz7Ezni0pYfX/m09N
         9tUo9DgZzR1rYdNpCOHpvMwnEPtIJ+Rqzcu22+zirCwlPyGhf+L3dKslU1DuKG+qmABj
         VlsVMu5xF+qN4C/C9Wmv6WBPNVbkEaaPLjLEzRaHDu7FiAEnVDe7gPcRMLNNmVViVmQE
         9ziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tSmFUu+ge0MP/jenrZcT7/NZQRt0kD5JNu6kc/qJIP4=;
        b=WCl3DzVtSb1DphwEqHHAYnEanP3KhTpZP1oApLGGfoDPnJ5ipOSh4a4Kc9hCx5hset
         8rC7t+4P4ktT0MvVdfiLvnmCeHjfEA1cIcpDJcmn+2EYdJ2euiC5BblJ37V232ldf+D5
         bx2xbsD8UujFcqK6OlxzE75zsBSOGpHWPzrOp4iFMWDzPNTwAXhb3hgU10lqPjtq5S8G
         hepP+W8nc1BSKRlh022fxcKwiI2jxvDc/WeaW9fnfgJWWI78CE5A4xzJQcX6X33eRlSw
         TQeoLdusN1MDTNT8hfQQzYpcoP+QUhI6390opyefc6w2t0n5iSEwrJUk2bQhrhKfy59C
         L2Kw==
X-Gm-Message-State: AOAM531q6qlsCfbO1XWyLTo3Dk3oDthM7hzLFd63GRG2dQgVMfA4Ck2Z
        L5H9GugH4BlTBajTA1McSXk=
X-Google-Smtp-Source: ABdhPJyYbDyOhvKmYK0mHZDmVxr6k+Aoao3pwl0TEzyUxpYXsxp7myDani1NPdNerac8wvSZFz+FXw==
X-Received: by 2002:a65:568b:0:b0:378:86b8:9426 with SMTP id v11-20020a65568b000000b0037886b89426mr16101788pgs.70.1646791087021;
        Tue, 08 Mar 2022 17:58:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ec26:3a58:d9f3:4e46])
        by smtp.gmail.com with ESMTPSA id 17-20020a056a00071100b004f0f941d1e8sm384453pfl.24.2022.03.08.17.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 17:58:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp: adjust TSO packet sizes based on min_rtt
Date:   Tue,  8 Mar 2022 17:57:57 -0800
Message-Id: <20220309015757.2532973-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Back when tcp_tso_autosize() and TCP pacing were introduced,
our focus was really to reduce burst sizes for long distance
flows.

The simple heuristic of using sk_pacing_rate/1024 has worked
well, but can lead to too small packets for hosts in the same
rack/cluster, when thousands of flows compete for the bottleneck.

Neal Cardwell had the idea of making the TSO burst size
a function of both sk_pacing_rate and tcp_min_rtt()

Indeed, for local flows, sending bigger bursts is better
to reduce cpu costs, as occasional losses can be repaired
quite fast.

This patch is based on Neal Cardwell implementation
done more than two years ago.
bbr is adjusting max_pacing_rate based on measured bandwidth,
while cubic would over estimate max_pacing_rate.

/proc/sys/net/ipv4/tcp_tso_rtt_log can be used to tune or disable
this new feature, in logarithmic steps.

Tested:

100Gbit NIC, two hosts in the same rack, 4K MTU.
600 flows rate-limited to 20000000 bytes per second.

Before patch: (TSO sizes would be limited to 20000000/1024/4096 -> 4 segments per TSO)

~# echo 0 >/proc/sys/net/ipv4/tcp_tso_rtt_log
~# nstat -n;perf stat ./super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000;nstat|egrep "TcpInSegs|TcpOutSegs|TcpRetransSegs|Delivered"
  96005

 Performance counter stats for './super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000':

         65,945.29 msec task-clock                #    2.845 CPUs utilized
         1,314,632      context-switches          # 19935.279 M/sec
             5,292      cpu-migrations            #   80.249 M/sec
           940,641      page-faults               # 14264.023 M/sec
   201,117,030,926      cycles                    # 3049769.216 GHz                   (83.45%)
    17,699,435,405      stalled-cycles-frontend   #    8.80% frontend cycles idle     (83.48%)
   136,584,015,071      stalled-cycles-backend    #   67.91% backend cycles idle      (83.44%)
    53,809,530,436      instructions              #    0.27  insn per cycle
                                                  #    2.54  stalled cycles per insn  (83.36%)
     9,062,315,523      branches                  # 137422329.563 M/sec               (83.22%)
       153,008,621      branch-misses             #    1.69% of all branches          (83.32%)

      23.182970846 seconds time elapsed

TcpInSegs                       15648792           0.0
TcpOutSegs                      58659110           0.0  # Average of 3.7 4K segments per TSO packet
TcpExtTCPDelivered              58654791           0.0
TcpExtTCPDeliveredCE            19                 0.0

After patch:

~# echo 9 >/proc/sys/net/ipv4/tcp_tso_rtt_log
~# nstat -n;perf stat ./super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000;nstat|egrep "TcpInSegs|TcpOutSegs|TcpRetransSegs|Delivered"
  96046

 Performance counter stats for './super_netperf 600 -H otrv6 -l 20 -- -K dctcp -q 20000000':

         48,982.58 msec task-clock                #    2.104 CPUs utilized
           186,014      context-switches          # 3797.599 M/sec
             3,109      cpu-migrations            #   63.472 M/sec
           941,180      page-faults               # 19214.814 M/sec
   153,459,763,868      cycles                    # 3132982.807 GHz                   (83.56%)
    12,069,861,356      stalled-cycles-frontend   #    7.87% frontend cycles idle     (83.32%)
   120,485,917,953      stalled-cycles-backend    #   78.51% backend cycles idle      (83.24%)
    36,803,672,106      instructions              #    0.24  insn per cycle
                                                  #    3.27  stalled cycles per insn  (83.18%)
     5,947,266,275      branches                  # 121417383.427 M/sec               (83.64%)
        87,984,616      branch-misses             #    1.48% of all branches          (83.43%)

      23.281200256 seconds time elapsed

TcpInSegs                       1434706            0.0
TcpOutSegs                      58883378           0.0  # Average of 41 4K segments per TSO packet
TcpExtTCPDelivered              58878971           0.0
TcpExtTCPDeliveredCE            9664               0.0

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.rst | 23 ++++++++++++++++++
 include/net/netns/ipv4.h               |  3 ++-
 net/ipv4/sysctl_net_ipv4.c             |  7 ++++++
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_output.c                  | 33 ++++++++++++++++----------
 5 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 2572eecc3e86a1eb8cbb96fb47c94a014186e7af..b0024aa7b0514f7174ebf7512e2c7da256b494d1 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -878,6 +878,29 @@ tcp_min_tso_segs - INTEGER
 
 	Default: 2
 
+tcp_tso_rtt_log - INTEGER
+	Adjustment of TSO packet sizes based on min_rtt
+
+	Starting from linux-5.18, TCP autosizing can be tweaked
+	for flows having small RTT.
+
+	Old autosizing was splitting the pacing budget to send 1024 TSO
+	per second.
+
+	tso_packet_size = sk->sk_pacing_rate / 1024;
+
+	With the new mechanism, we increase this TSO sizing using:
+
+	distance = min_rtt_usec / (2^tcp_tso_rtt_log)
+	tso_packet_size += gso_max_size >> distance;
+
+	This means that flows between very close hosts can use bigger
+	TSO packets, reducing their cpu costs.
+
+	If you want to use the old autosizing, set this sysctl to 0.
+
+	Default: 9  (2^9 = 512 usec)
+
 tcp_pacing_ss_ratio - INTEGER
 	sk->sk_pacing_rate is set by TCP stack using a ratio applied
 	to current rate. (current_rate = cwnd * mss / srtt)
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index f0687867b5cd39d88a70fc19137a5fcaa2433758..ce0cc4e8d8c73f4b903108921281c734c98c38b3 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -127,6 +127,7 @@ struct netns_ipv4 {
 	u8 sysctl_tcp_synack_retries;
 	u8 sysctl_tcp_syncookies;
 	u8 sysctl_tcp_migrate_req;
+	u8 sysctl_tcp_comp_sack_nr;
 	int sysctl_tcp_reordering;
 	u8 sysctl_tcp_retries1;
 	u8 sysctl_tcp_retries2;
@@ -160,9 +161,9 @@ struct netns_ipv4 {
 	int sysctl_tcp_challenge_ack_limit;
 	int sysctl_tcp_min_rtt_wlen;
 	u8 sysctl_tcp_min_tso_segs;
+	u8 sysctl_tcp_tso_rtt_log;
 	u8 sysctl_tcp_autocorking;
 	u8 sysctl_tcp_reflect_tos;
-	u8 sysctl_tcp_comp_sack_nr;
 	int sysctl_tcp_invalid_ratelimit;
 	int sysctl_tcp_pacing_ss_ratio;
 	int sysctl_tcp_pacing_ca_ratio;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 1cae27b5dcd836f1c5ae1ba1b0d4bae5899b3e6f..ad80d180b60b52bdb9edea979a76dfc6466eefd2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1271,6 +1271,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "tcp_tso_rtt_log",
+		.data		= &init_net.ipv4.sysctl_tcp_tso_rtt_log,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+	},
 	{
 		.procname	= "tcp_min_rtt_wlen",
 		.data		= &init_net.ipv4.sysctl_tcp_min_rtt_wlen,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 411357ad9757585ccdd20a1a4756eff057795644..4d8f67a73571488090190902d89a08b633c3093c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3135,6 +3135,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	/* rfc5961 challenge ack rate limiting */
 	net->ipv4.sysctl_tcp_challenge_ack_limit = 1000;
 	net->ipv4.sysctl_tcp_min_tso_segs = 2;
+	net->ipv4.sysctl_tcp_tso_rtt_log = 9;  /* 2^9 = 512 usec */
 	net->ipv4.sysctl_tcp_min_rtt_wlen = 300;
 	net->ipv4.sysctl_tcp_autocorking = 1;
 	net->ipv4.sysctl_tcp_invalid_ratelimit = HZ/2;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2319531267c6830b633768dea7f0b40a46633ee1..81aaa7da3e8c0fa5e6cd3c4fd18543b75314e4a2 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1951,25 +1951,34 @@ static bool tcp_nagle_check(bool partial, const struct tcp_sock *tp,
 }
 
 /* Return how many segs we'd like on a TSO packet,
- * to send one TSO packet per ms
+ * depending on current pacing rate, and how close the peer is.
+ *
+ * Rationale is:
+ * - For close peers, we rather send bigger packets to reduce
+ *   cpu costs, because occasional losses will be repaired fast.
+ * - For long distance/rtt flows, we would like to get ACK clocking
+ *   with 1 ACK per ms.
+ *
+ * Use min_rtt to help adapt TSO burst size, with smaller min_rtt resulting
+ * in bigger TSO bursts. We we cut the RTT-based allowance in half
+ * for every 2^9 usec (aka 512 us) of RTT, so that the RTT-based allowance
+ * is below 1500 bytes after 6 * ~500 usec = 3ms.
  */
 static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
 			    int min_tso_segs)
 {
-	u32 bytes, segs;
+	unsigned long bytes;
+	u32 r;
 
-	bytes = min_t(unsigned long,
-		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
-		      sk->sk_gso_max_size);
+	bytes = sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift);
 
-	/* Goal is to send at least one packet per ms,
-	 * not one big TSO packet every 100 ms.
-	 * This preserves ACK clocking and is consistent
-	 * with tcp_tso_should_defer() heuristic.
-	 */
-	segs = max_t(u32, bytes / mss_now, min_tso_segs);
+	r = tcp_min_rtt(tcp_sk(sk)) >> sock_net(sk)->ipv4.sysctl_tcp_tso_rtt_log;
+	if (r < BITS_PER_TYPE(sk->sk_gso_max_size))
+		bytes += sk->sk_gso_max_size >> r;
 
-	return segs;
+	bytes = min_t(unsigned long, bytes, sk->sk_gso_max_size);
+
+	return max_t(u32, bytes / mss_now, min_tso_segs);
 }
 
 /* Return the number of segments we want in the skb we are transmitting.
-- 
2.35.1.616.g0bdcbb4464-goog

