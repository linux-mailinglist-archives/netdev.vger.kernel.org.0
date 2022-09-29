Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEA85EF779
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiI2OZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiI2OZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:25:17 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA883687E
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:14 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id b23so829829qtr.13
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=7+XnK29oDbbevGTzb2Jj7dNBHIjzqU0RKOJT6t8yjWo=;
        b=kV4VsNwaTSBZMwZBWTS9vCbSJlxBtnnTCjahaMrkeg74+nQmoCeG2NfmCxJaYXS9qh
         bSG+hTVpCiYDzVdE2rOsoQ5U1kROMdubfLJt0mspHNiWdug/2SnAb/roNbrc7VoZRks9
         FeA27y5Hm57PncicUueksixwE9UHGJcVfShCl75NbOfXVKB16ShDTDAUAMjp8fIl+y1K
         hqxtrC24qTVFkg+rfw2sgKu1HTubIkFgxi05L/lV2Wau7weG62nFkqLez4wBYibZSTmQ
         qtSvHl0bLPd3HnHDpGd6STyuAtXA2WkpiHx2jmfnowwN2Qr9J9jXPRs1oatmUHZjldVv
         gaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=7+XnK29oDbbevGTzb2Jj7dNBHIjzqU0RKOJT6t8yjWo=;
        b=ZawgQU+UURwLUDDjaxECDDey5AMSV0bnF7lWwXf8ukPX78s5Bt1YU/YX8tLRuzAppJ
         qQ1/MXVAwXiQt0n9Xm/3egRtUWir3Fo6fOaQJxQ8qSeegIrCC9srk4jJHQQFS2RL9C2K
         KTsCDysQ1n/xPtmLQbMY9Jc6OpZ9jyel/T4ULRLPMmmzQraUhKao0VzwD4H4shvblyM5
         MGU094x+ULex6jzMy6x19q1jgrH5A7iwR211i2BpwhL8tPPdnoQ9d5TiVQdi2pWbezY5
         N9KCT2o7gudgyUksWYAaIxXrHrWC/s1XSZmeUs4hPcwQI6R2FzvsuP6E9PqVQ4eDti69
         tP0g==
X-Gm-Message-State: ACrzQf0hD2MJQCC+EJIzTwt9yDGuL/K6VoJ+daUwfnxKYRkcBXNk7tyG
        Mk7lDEbvesvYpxigy0Oe0Ts=
X-Google-Smtp-Source: AMsMyM5bVel8qAihSprnyq/52pga2RoPLXCjfcGkgt0RfGs1+/Tzxxln5S7x0uSuTERCmIirv2P0bA==
X-Received: by 2002:a05:622a:46:b0:35d:51c1:ee70 with SMTP id y6-20020a05622a004600b0035d51c1ee70mr2572852qtw.365.1664461513334;
        Thu, 29 Sep 2022 07:25:13 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id z21-20020ac87f95000000b00342f8984348sm5889952qtj.87.2022.09.29.07.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:25:12 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 4/5] tcp: add u32 counter in tcp_sock and an SNMP counter for PLB
Date:   Thu, 29 Sep 2022 14:24:46 +0000
Message-Id: <20220929142447.3821638-5-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220929142447.3821638-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mubashir Adnan Qureshi <mubashirq@google.com>

A u32 counter is added to tcp_sock for counting the number of PLB
triggered rehashes for a TCP connection. An SNMP counter is also
added to count overall PLB triggered rehash events for a host. These
counters are hooked up to PLB implementation for DCTCP.

TCP_NLA_REHASH is added to SCM_TIMESTAMPING_OPT_STATS that reports
the rehash attempts triggered due to PLB or timeouts. This gives
a historical view of sustained congestion or timeouts experienced
by the TCP connection.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h       | 1 +
 include/uapi/linux/snmp.h | 1 +
 include/uapi/linux/tcp.h  | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/tcp.c            | 3 +++
 net/ipv4/tcp_plb.c        | 2 ++
 6 files changed, 9 insertions(+)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a9fbe22732c3..332870bb09fc 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -417,6 +417,7 @@ struct tcp_sock {
 		u32		  probe_seq_start;
 		u32		  probe_seq_end;
 	} mtu_probe;
+	u32     plb_rehash;     /* PLB-triggered rehash attempts */
 	u32	mtu_info; /* We received an ICMP_FRAG_NEEDED / ICMPV6_PKT_TOOBIG
 			   * while socket was owned by user.
 			   */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 4d7470036a8b..6600cb0164c2 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -292,6 +292,7 @@ enum
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPPLBREHASH,			/* TCPPLBRehash */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 8fc09e8638b3..c9abe86eda5f 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -315,6 +315,7 @@ enum {
 	TCP_NLA_BYTES_NOTSENT,	/* Bytes in write queue not yet sent */
 	TCP_NLA_EDT,		/* Earliest departure time (CLOCK_MONOTONIC) */
 	TCP_NLA_TTL,		/* TTL or hop limit of a packet received */
+	TCP_NLA_REHASH,         /* PLB and timeout triggered rehash attempts */
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 5386f460bd20..f88daace9de3 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -297,6 +297,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPPLBRehash", LINUX_MIB_TCPPLBREHASH),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5702ca9b952d..f5902a965693 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3174,6 +3174,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->sacked_out = 0;
 	tp->tlp_high_seq = 0;
 	tp->last_oow_ack_time = 0;
+	tp->plb_rehash = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
 	tp->rack.mstamp = 0;
@@ -3970,6 +3971,7 @@ static size_t tcp_opt_stats_get_size(void)
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_BYTES_NOTSENT */
 		nla_total_size_64bit(sizeof(u64)) + /* TCP_NLA_EDT */
 		nla_total_size(sizeof(u8)) + /* TCP_NLA_TTL */
+		nla_total_size(sizeof(u32)) + /* TCP_NLA_REHASH */
 		0;
 }
 
@@ -4046,6 +4048,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 		nla_put_u8(stats, TCP_NLA_TTL,
 			   tcp_skb_ttl_or_hop_limit(ack_skb));
 
+	nla_put_u32(stats, TCP_NLA_REHASH, tp->plb_rehash + tp->timeout_rehash);
 	return stats;
 }
 
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
index 26ffc5a45f53..04f4cac8645b 100644
--- a/net/ipv4/tcp_plb.c
+++ b/net/ipv4/tcp_plb.c
@@ -73,6 +73,8 @@ void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb)
 	if (!plb->pause_until && (can_idle_rehash || can_force_rehash)) {
 		sk_rethink_txhash(sk);
 		plb->consec_cong_rounds = 0;
+		tcp_sk(sk)->plb_rehash++;
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPLBREHASH);
 	}
 }
 EXPORT_SYMBOL_GPL(tcp_plb_check_rehash);
-- 
2.37.3.998.g577e59143f-goog

