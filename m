Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7AB698376
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBOSgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBOSfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:35:10 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE453E084
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:13 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m20-20020a05600c3b1400b003e1e754657aso2295858wms.2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hl7En8l9enlD7IV/XkIclALr8wUGcK1oLOcQr2oaW9I=;
        b=YkGKp2O5+DEX7jQLbdyq4NwtrvtRy/iKoqepJwivpUN0IBBJJ5Q1ljqX2XBupqK8cq
         8TDzY28x4NnuLPFqx2n2C1wThLdQMSGsT/rXtBrJ8aGqauRLypJipWNtE0/WwU1vSxwU
         DZ0tqLI76NWv+7A1whqegfTdVbrKGYIGlBwst4SbVCTf5SfqtbYhpvL1cR2c/BEt2LH2
         CAXxTmJ9YrYDCwh6ikTIrtj/lqnclkCCoOTTTnyL60/ZAZ2/GXPXlWJh9nk0IPiFPfIE
         Rc+FGVrxRD1d5k9LBqXEqxcBRM421o/yO8Ttf8xoBD4awDbAigYA6+9mVJo13+cyfjQA
         MIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hl7En8l9enlD7IV/XkIclALr8wUGcK1oLOcQr2oaW9I=;
        b=r9QnMhP7kFMGFp3Vl5o0L9h3ZBXGJIcmVdGxIDP7EyMGO7nisawQJAI7YEa+Y9CIVc
         TeGNdPoFHL8Roap0VMYgaipT6ME1zsJnPkhvmdu5Ki4HX4W6bhZyy6rjb6Pt1n1KwIuo
         MFoTFK2FNQvEVbWlYx+bSZ5uP7H66HbAGOUzfjd1xXqm/C5737dRfuMs+s3a4woxX7T0
         2Cgsw6mQwBS6g3ksBlcxJh6OgTJmA3/1w2hgDPF3O6hXeH4m90wW7DmximWtwKB+IiyP
         0Ukm1QR20nkKXCsiQXIDw5PIi5PVICFKLZ5gjQd7OkPglsMA0KV7TVWiT60jWsMXNOzS
         lwLw==
X-Gm-Message-State: AO0yUKWS8LnUiM1MdXq1+ggmqBQ6btLdbmcwRK4AtxxgkZ34Pp0IbTMT
        7oh1qD2owJyX3l/xRm5SGobdfw==
X-Google-Smtp-Source: AK7set+BO3JePQRJYGb+7Qt3pr4fyYpY1zIlstAX60ZVv+IpsXvwBScczlK5TPxOusQ03HnjHIF9bQ==
X-Received: by 2002:a05:600c:4447:b0:3da:28a9:a900 with SMTP id v7-20020a05600c444700b003da28a9a900mr2613322wmn.41.1676486052603;
        Wed, 15 Feb 2023 10:34:12 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:12 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v4 16/21] net/tcp: Ignore specific ICMPs for TCP-AO connections
Date:   Wed, 15 Feb 2023 18:33:30 +0000
Message-Id: <20230215183335.800122-17-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to IPsec, RFC5925 prescribes:
  ">> A TCP-AO implementation MUST default to ignore incoming ICMPv4
  messages of Type 3 (destination unreachable), Codes 2-4 (protocol
  unreachable, port unreachable, and fragmentation needed -- ’hard
  errors’), and ICMPv6 Type 1 (destination unreachable), Code 1
  (administratively prohibited) and Code 4 (port unreachable) intended
  for connections in synchronized states (ESTABLISHED, FIN-WAIT-1, FIN-
  WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT) that match MKTs."

A selftest (later in patch series) verifies that this attack is not
possible in this TCP-AO implementation.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h      | 10 ++++++
 include/uapi/linux/snmp.h |  1 +
 include/uapi/linux/tcp.h  |  1 +
 net/ipv4/proc.c           |  1 +
 net/ipv4/tcp_ao.c         | 70 ++++++++++++++++++++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c       |  5 +++
 net/ipv6/tcp_ipv6.c       |  4 +++
 7 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index d953105f5f73..01cdba46591c 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -25,6 +25,7 @@ struct tcp_ao_counters {
 	atomic64_t	pkt_bad;
 	atomic64_t	key_not_found;
 	atomic64_t	ao_required;
+	atomic64_t	dropped_icmp;
 };
 
 struct tcp_ao_key {
@@ -77,6 +78,9 @@ static inline unsigned int tcp_ao_digest_size(struct tcp_ao_key *key)
 	return key->digest_size;
 }
 
+/* bits in 'ao_flags' */
+#define AO_ACCEPT_ICMPS		BIT(0)
+
 struct tcp_ao_info {
 	struct hlist_head	head;
 	struct rcu_head		rcu;
@@ -167,6 +171,7 @@ u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key);
+bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
 			const struct request_sock *req,
@@ -246,6 +251,11 @@ static inline void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 {
 }
 
+static inline bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
+{
+	return false;
+}
+
 static inline enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 		const struct sk_buff *skb, unsigned short int family,
 		const struct request_sock *req, const struct tcp_ao_hdr *aoh)
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 55176bf83320..7d9094df04a1 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -297,6 +297,7 @@ enum
 	LINUX_MIB_TCPAOBAD,			/* TCPAOBad */
 	LINUX_MIB_TCPAOKEYNOTFOUND,		/* TCPAOKeyNotFound */
 	LINUX_MIB_TCPAOGOOD,			/* TCPAOGood */
+	LINUX_MIB_TCPAODROPPEDICMPS,		/* TCPAODroppedIcmps */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 7de4558469e1..6c8b4dcc51ee 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -357,6 +357,7 @@ struct tcp_diag_md5sig {
 
 #define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
+#define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
 
 struct tcp_ao { /* setsockopt(TCP_AO) */
 	struct __kernel_sockaddr_storage tcpa_addr;
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index a4e012afd378..e3d9ab1cfb08 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -302,6 +302,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPAOBad", LINUX_MIB_TCPAOBAD),
 	SNMP_MIB_ITEM("TCPAOKeyNotFound", LINUX_MIB_TCPAOKEYNOTFOUND),
 	SNMP_MIB_ITEM("TCPAOGood", LINUX_MIB_TCPAOGOOD),
+	SNMP_MIB_ITEM("TCPAODroppedIcmps", LINUX_MIB_TCPAODROPPEDICMPS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 6f650ebe01c4..07935e8a1066 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -15,6 +15,7 @@
 
 #include <net/tcp.h>
 #include <net/ipv6.h>
+#include <net/icmp.h>
 
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len)
@@ -52,6 +53,63 @@ int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 	return 1;
 }
 
+bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
+{
+	struct tcp_ao_info *ao;
+	bool ignore_icmp = false;
+
+	/* RFC5925, 7.8:
+	 * >> A TCP-AO implementation MUST default to ignore incoming ICMPv4
+	 * messages of Type 3 (destination unreachable), Codes 2-4 (protocol
+	 * unreachable, port unreachable, and fragmentation needed -- ’hard
+	 * errors’), and ICMPv6 Type 1 (destination unreachable), Code 1
+	 * (administratively prohibited) and Code 4 (port unreachable) intended
+	 * for connections in synchronized states (ESTABLISHED, FIN-WAIT-1, FIN-
+	 * WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT) that match MKTs.
+	 */
+	if (sk->sk_family == AF_INET) {
+		if (type != ICMP_DEST_UNREACH)
+			return false;
+		if (code < ICMP_PROT_UNREACH || code > ICMP_FRAG_NEEDED)
+			return false;
+	} else if (sk->sk_family == AF_INET6) {
+		if (type != ICMPV6_DEST_UNREACH)
+			return false;
+		if (code != ICMPV6_ADM_PROHIBITED && code != ICMPV6_PORT_UNREACH)
+			return false;
+	} else {
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	rcu_read_lock();
+	switch (sk->sk_state) {
+	case TCP_TIME_WAIT:
+		ao = rcu_dereference(tcp_twsk(sk)->ao_info);
+		break;
+	case TCP_SYN_SENT:
+	case TCP_SYN_RECV:
+	case TCP_LISTEN:
+	case TCP_NEW_SYN_RECV:
+		/* RFC5925 specifies to ignore ICMPs *only* on connections
+		 * in synchronized states.
+		 */
+		rcu_read_unlock();
+		return false;
+	default:
+		ao = rcu_dereference(tcp_sk(sk)->ao_info);
+	}
+
+	if (ao && !(ao->ao_flags & AO_ACCEPT_ICMPS)) {
+		ignore_icmp = true;
+		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAODROPPEDICMPS);
+		atomic64_inc(&ao->counters.dropped_icmp);
+	}
+	rcu_read_unlock();
+
+	return ignore_icmp;
+}
+
 /* Optimized version of tcp_ao_do_lookup(): only for sockets for which
  * it's known that the keys in ao_info are matching peer's
  * family/address/port/VRF/etc.
@@ -1442,7 +1500,7 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 
 #define TCP_AO_KEYF_ALL		(0)
 #define TCP_AO_CMDF_ADDMOD_VALID					\
-	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
 
@@ -1528,6 +1586,11 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	atomic64_set(&key->pkt_good, 0);
 	atomic64_set(&key->pkt_bad, 0);
 
+	if (cmd.tcpa_flags & TCP_AO_CMDF_ACCEPT_ICMP)
+		ao_info->ao_flags |= AO_ACCEPT_ICMPS;
+	else
+		ao_info->ao_flags &= ~AO_ACCEPT_ICMPS;
+
 	ret = tcp_ao_parse_crypto(&cmd, key);
 	if (ret < 0)
 		goto err_free_sock;
@@ -1690,6 +1753,11 @@ static int tcp_ao_mod_cmd(struct sock *sk, unsigned short int family,
 	if (!ao_info)
 		return -ENOENT;
 	/* TODO: make tcp_ao_current_rnext() and flags set atomic */
+	if (cmd.tcpa_flags & TCP_AO_CMDF_ACCEPT_ICMP)
+		ao_info->ao_flags |= AO_ACCEPT_ICMPS;
+	else
+		ao_info->ao_flags &= ~AO_ACCEPT_ICMPS;
+
 	return tcp_ao_current_rnext(sk, cmd.tcpa_flags,
 			cmd.tcpa_current, cmd.tcpa_rnext);
 }
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f6a3dde66c12..64a81f1dd4d4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -492,6 +492,8 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		return -ENOENT;
 	}
 	if (sk->sk_state == TCP_TIME_WAIT) {
+		/* To increase the counter of ignored icmps for TCP-AO */
+		tcp_ao_ignore_icmp(sk, type, code);
 		inet_twsk_put(inet_twsk(sk));
 		return 0;
 	}
@@ -506,6 +508,9 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 	}
 
 	bh_lock_sock(sk);
+	if (tcp_ao_ignore_icmp(sk, type, code))
+		goto out;
+
 	/* If too many ICMPs get dropped on busy
 	 * servers this needs to be solved differently.
 	 * We do take care of PMTU discovery (RFC1191) special case :
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 96a4b62b1fef..5c5c8509a6e2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -398,6 +398,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (sk->sk_state == TCP_TIME_WAIT) {
+		/* To increase the counter of ignored icmps for TCP-AO */
+		tcp_ao_ignore_icmp(sk, type, code);
 		inet_twsk_put(inet_twsk(sk));
 		return 0;
 	}
@@ -409,6 +411,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	bh_lock_sock(sk);
+	if (tcp_ao_ignore_icmp(sk, type, code))
+		goto out;
 	if (sock_owned_by_user(sk) && type != ICMPV6_PKT_TOOBIG)
 		__NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
 
-- 
2.39.1

