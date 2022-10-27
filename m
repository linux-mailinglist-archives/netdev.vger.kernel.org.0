Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBCC610364
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiJ0Uv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbiJ0Uvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:51:37 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035C2541B3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:12 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id b20-20020a05600c4e1400b003cc28585e2fso2118970wmq.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BO0mm+QEf5Np62JXxlh17iSFdxt4l5JfCFy1h9DfxFc=;
        b=bZ51BqO1op2Q3t8/SRCIkOpd+PNFcHn5mgtntOQdkUDwjAB0msiKkN7hquaoJxMIwV
         G32tPbu0ooycFl1It+qSg2dq/iXmlcZ+PSZdF1KQE5/1ax+zAV2LArjka0h0A+rlN9J+
         JpbS+X3doweyYS4edNiE7hDAhe1H1lleuUYvVYrKI1Nf/wAt/xZXIGcYRmiMijvs82VP
         VrV2b2NZbUjMuiDSa5Vl87PWduM86RTN/h645x8ItldiZSoo8VFPykijL3DznD2QasK5
         OEV580zOZRGh1U7eWQ9D+pIVmPYt7yL6IwFK05wOYq/1rY36NxgboaJGoSpb7GMyfHBx
         SnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BO0mm+QEf5Np62JXxlh17iSFdxt4l5JfCFy1h9DfxFc=;
        b=YSpyOFf7U/mOys6/zSqp307PCHWcHdaHOmwlEpiCZmtWTtPQMyKi/B4dpTrsax0vlG
         NZNz/ydQDUNS6PB+QYShRokiho2Wv1pKglKGqeYCAWaV/Ixa8bTCuOCUNKXPHiBttqbB
         C9vNJzsIz6Mcyj84BGORt/MVY4sXk6GKgs1A3pVHfSYWmOCeU3gazBrHbZwlqBFeEnaa
         FDkZpAak58VVrNetkVf2WspjKs3phfc0Mte21oUbT2EkP8HJ9hlpPcD25dfF1cTk3hLf
         /kK3+hiNYwSdBfeshQymAShTofnSjebETNwyL78AZZZc1LetpvAnO4DqfTAPU5AF+Cpz
         VWiA==
X-Gm-Message-State: ACrzQf0wQhlSrXgj3HEvs61T/jEmDwjRMjU7I05YJpzxuAk26f3a5d6Y
        m9qrUIMpi4jsCvPrl/knswZecg==
X-Google-Smtp-Source: AMsMyM7FOvCPRtKVdKEvgmd9b2ktktfqpf2g7L2IHRD1LA64D5sffuliYpA0bbFh0ci53XNDuvA8WQ==
X-Received: by 2002:a05:600c:4f93:b0:3cc:9bc5:c454 with SMTP id n19-20020a05600c4f9300b003cc9bc5c454mr7249457wmq.84.1666903473022;
        Thu, 27 Oct 2022 13:44:33 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:32 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 25/36] net/tcp-ao: Add static_key for TCP-AO
Date:   Thu, 27 Oct 2022 21:43:36 +0100
Message-Id: <20221027204347.529913-26-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to TCP-MD5, add a static key to TCP-AO that is patched out
when there are no keys on a machine and dynamically enabled with the
first setsockopt(TCP_AO) adds a key on any socket. The static key is as
well dynamically disabled later when the socket is destructed.

The lifetime of enabled static key here is the same as ao_info: it is
enabled on allocation, passed over from full socket to twsk and
destructed when ao_info is scheduled for destruction.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h |  2 ++
 net/ipv4/tcp_ao.c    | 15 +++++++++++++++
 net/ipv4/tcp_input.c | 42 ++++++++++++++++++++++++++++--------------
 3 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 67f5273396ec..0923cd3b6b45 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -131,6 +131,8 @@ do {									\
 
 #ifdef CONFIG_TCP_AO
 /* TCP-AO structures and functions */
+#include <linux/jump_label.h>
+extern struct static_key_false_deferred tcp_ao_needed;
 
 struct tcp4_ao_context {
 	__be32		saddr;
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 46df1d455889..494fa5e1428c 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -17,6 +17,9 @@
 #include <net/ipv6.h>
 #include <net/icmp.h>
 
+DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_ao_needed, HZ);
+EXPORT_SYMBOL(tcp_ao_needed);
+
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len)
 {
@@ -58,6 +61,9 @@ bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
 	struct tcp_ao_info *ao;
 	bool ignore_icmp = false;
 
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return false;
+
 	/* RFC5925, 7.8:
 	 * >> A TCP-AO implementation MUST default to ignore incoming ICMPv4
 	 * messages of Type 3 (destination unreachable), Codes 2-4 (protocol
@@ -148,6 +154,9 @@ struct tcp_ao_key *tcp_ao_do_lookup_sndid(const struct sock *sk, u8 keyid)
 	struct tcp_ao_key *key;
 	struct tcp_ao_info *ao;
 
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return NULL;
+
 	if (sk->sk_state == TCP_TIME_WAIT)
 		ao = rcu_dereference_check(tcp_twsk(sk)->ao_info,
 					   lockdep_sock_is_held(sk));
@@ -232,6 +241,9 @@ struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 	struct tcp_ao_key *key;
 	struct tcp_ao_info *ao;
 
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return NULL;
+
 	ao = rcu_dereference_check(tcp_sk(sk)->ao_info,
 				   lockdep_sock_is_held(sk));
 	if (!ao)
@@ -319,6 +331,7 @@ void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
 	}
 
 	kfree_rcu(ao, rcu);
+	static_branch_slow_dec_deferred(&tcp_ao_needed);
 }
 
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp)
@@ -1078,6 +1091,7 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 
 		sk_gso_disable(newsk);
 		rcu_assign_pointer(tcp_sk(newsk)->ao_info, new_ao);
+		atomic_inc(&tcp_ao_needed.key.key.enabled);
 	}
 
 	return 0;
@@ -1605,6 +1619,7 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	if (first) {
 		sk_gso_disable(sk);
 		rcu_assign_pointer(tcp_sk(sk)->ao_info, ao_info);
+		static_branch_inc(&tcp_ao_needed.key);
 	}
 
 	/* Can't fail: the key with sndid/rcvid was just added */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2ba46d5db421..3f1f5c0e78ae 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3524,17 +3524,14 @@ static inline bool tcp_may_update_window(const struct tcp_sock *tp,
 		(ack_seq == tp->snd_wl1 && nwin > tp->snd_wnd);
 }
 
-/* If we update tp->snd_una, also update tp->bytes_acked */
-static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
+static void tcp_snd_sne_update(struct tcp_sock *tp, u32 ack)
 {
-	u32 delta = ack - tp->snd_una;
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao;
-#endif
 
-	sock_owned_by_me((struct sock *)tp);
-	tp->bytes_acked += delta;
-#ifdef CONFIG_TCP_AO
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return;
+
 	ao = rcu_dereference_protected(tp->ao_info,
 				       lockdep_sock_is_held((struct sock *)tp));
 	if (ao) {
@@ -3543,20 +3540,27 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 		ao->snd_sne_seq = ack;
 	}
 #endif
+}
+
+/* If we update tp->snd_una, also update tp->bytes_acked */
+static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
+{
+	u32 delta = ack - tp->snd_una;
+
+	sock_owned_by_me((struct sock *)tp);
+	tp->bytes_acked += delta;
+	tcp_snd_sne_update(tp, ack);
 	tp->snd_una = ack;
 }
 
-/* If we update tp->rcv_nxt, also update tp->bytes_received */
-static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
+static void tcp_rcv_sne_update(struct tcp_sock *tp, u32 seq)
 {
-	u32 delta = seq - tp->rcv_nxt;
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao;
-#endif
 
-	sock_owned_by_me((struct sock *)tp);
-	tp->bytes_received += delta;
-#ifdef CONFIG_TCP_AO
+	if (!static_branch_unlikely(&tcp_ao_needed.key))
+		return;
+
 	ao = rcu_dereference_protected(tp->ao_info,
 				       lockdep_sock_is_held((struct sock *)tp));
 	if (ao) {
@@ -3565,6 +3569,16 @@ static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 		ao->rcv_sne_seq = seq;
 	}
 #endif
+}
+
+/* If we update tp->rcv_nxt, also update tp->bytes_received */
+static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
+{
+	u32 delta = seq - tp->rcv_nxt;
+
+	sock_owned_by_me((struct sock *)tp);
+	tp->bytes_received += delta;
+	tcp_rcv_sne_update(tp, seq);
 	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
-- 
2.38.1

