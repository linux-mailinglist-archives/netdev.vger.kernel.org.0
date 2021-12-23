Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692AD47E5B3
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349239AbhLWPlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349086AbhLWPk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:57 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18581C06179E;
        Thu, 23 Dec 2021 07:40:54 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id bm14so22945106edb.5;
        Thu, 23 Dec 2021 07:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z9+VVX02Zxra1y+xBUkqOBg1LWIZhyBsjoGF+s7cRTo=;
        b=JCCIQ84tLkPY7tor9teeVoP1UnFnmygyVLgQSyiUumutPh+6t8pKAn7Na+V8S2dS+i
         vWJ0cbA+jsedgtQU70OdZ6b8k8D51rETbbBbkiCLz/cpwID6jIaYAmWr0OwmeqCzoR56
         AEng+GRddx72BIGa1zbFYw9AAEOL4GzzpoEzpKVRMJIYFdR0cOhC8S52VxBD8ZLsQByp
         8C/GNVuHrZfV0QTQ8eVh4igPb5PSjkzcsHcO9ZBqy3AovGAfmPebhWtojgzLpFZtiNC0
         AksRD3eX1cEnqm6XScCCZgF7hoR6XHsBuZGyCQyyoeQS2sVs9NtLnuR8FFvMWVMELRDZ
         sjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z9+VVX02Zxra1y+xBUkqOBg1LWIZhyBsjoGF+s7cRTo=;
        b=rbj7sQtF2/lm1TFppM/1JdfTaRYxx/uUeWESmz28YkweMt40hepcP4YlpPzKelsgN8
         MQn1bRh6D+FIp5Lgw1GjnXvG8XQMkX9sHFdGKVjDvm4Gwqo07ni0Aioo3UEK83NIrCcH
         Fyz4pfXs58VZd9ys4OigepmfUHf2x/6GVMcv8QaaovlP+ySQ6IgRLo9c1ziTYUQ2Di33
         N90+gXizN7GO2kWRdOJtYvhKcbGuC4X1uAitLHIG8c/BC34dKRorgPQbj8qSxTMIlVQk
         AlVkbKZrbOcm6M9cRs3ZJJ+QU2NG2linlYqwYjNDoS/UyWVsJh2WF815C9R/KRTnsAmc
         Yj5g==
X-Gm-Message-State: AOAM532yozdvc4oSBAJulOmX0NM+lmk2/VqAKf1PutzSBVvxf1OHINGO
        PFfHdi46rQVIci84Bd3YuvM=
X-Google-Smtp-Source: ABdhPJynOCWb4csRGcnHRZFHUUvoucEokaV5h36cNp8gG1xw+k51SHveDrue8ZDhv+a930PH2fTOoQ==
X-Received: by 2002:a17:907:da1:: with SMTP id go33mr2462187ejc.280.1640274052683;
        Thu, 23 Dec 2021 07:40:52 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:52 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/19] tcp: ipv6: Add AO signing for tcp_v6_send_response
Date:   Thu, 23 Dec 2021 17:40:04 +0200
Message-Id: <f76a1ddb7fa0e2da5b03cac12dc14fde01450166.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a special code path for acks and resets outside of normal
connection establishment and closing.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  2 ++
 net/ipv6/tcp_ipv6.c    | 59 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 4a624a3a572d..dbe92c87af5a 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -369,10 +369,11 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 {
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 
 	return tcp_authopt_lookup_send(net, addr_sk, -1);
 }
+EXPORT_SYMBOL(__tcp_authopt_select_key);
 
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
@@ -1182,10 +1183,11 @@ int tcp_authopt_hash(char *hash_location,
 	 * try to make it obvious inside the packet.
 	 */
 	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
 	return err;
 }
+EXPORT_SYMBOL(tcp_authopt_hash);
 
 static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    struct sk_buff *skb,
 							    struct netns_tcp_authopt *net,
 							    int recv_id,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3105a367d6b5..a51fb759ecf2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -886,10 +886,48 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.init_seq	=	tcp_v6_init_seq,
 	.init_ts_off	=	tcp_v6_init_ts_off,
 	.send_synack	=	tcp_v6_send_synack,
 };
 
+#ifdef CONFIG_TCP_AUTHOPT
+static int tcp_v6_send_response_init_authopt(const struct sock *sk,
+					     struct tcp_authopt_info **info,
+					     struct tcp_authopt_key_info **key,
+					     u8 *rnextkeyid)
+{
+	/* Key lookup before SKB allocation */
+	if (!(tcp_authopt_needed && sk))
+		return 0;
+	if (sk->sk_state == TCP_TIME_WAIT)
+		*info = tcp_twsk(sk)->tw_authopt_info;
+	else
+		*info = rcu_dereference(tcp_sk(sk)->authopt_info);
+	if (!*info)
+		return 0;
+	*key = __tcp_authopt_select_key(sk, *info, sk, rnextkeyid);
+	if (*key)
+		return TCPOLEN_AUTHOPT_OUTPUT;
+	return 0;
+}
+
+static void tcp_v6_send_response_sign_authopt(const struct sock *sk,
+					      struct tcp_authopt_info *info,
+					      struct tcp_authopt_key_info *key,
+					      struct sk_buff *skb,
+					      struct tcphdr_authopt *ptr,
+					      u8 rnextkeyid)
+{
+	if (!(tcp_authopt_needed && key))
+		return;
+	ptr->num = TCPOPT_AUTHOPT;
+	ptr->len = TCPOLEN_AUTHOPT_OUTPUT;
+	ptr->keyid = key->send_id;
+	ptr->rnextkeyid = rnextkeyid;
+	tcp_authopt_hash(ptr->mac, key, info, (struct sock *)sk, skb);
+}
+#endif
+
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
 				 u8 tclass, __be32 label, u32 priority)
 {
@@ -901,13 +939,30 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	struct sock *ctl_sk = net->ipv6.tcp_sk;
 	unsigned int tot_len = sizeof(struct tcphdr);
 	__be32 mrst = 0, *topt;
 	struct dst_entry *dst;
 	__u32 mark = 0;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *aoinfo;
+	struct tcp_authopt_key_info *aokey;
+	u8 aornextkeyid;
+	int aolen;
+#endif
 
 	if (tsecr)
 		tot_len += TCPOLEN_TSTAMP_ALIGNED;
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Key lookup before SKB allocation */
+	aolen = tcp_v6_send_response_init_authopt(sk, &aoinfo, &aokey, &aornextkeyid);
+	if (aolen) {
+		tot_len += aolen;
+#ifdef CONFIG_TCP_MD5SIG
+		/* Don't use MD5 */
+		key = NULL;
+#endif
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	if (key)
 		tot_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
 
@@ -960,10 +1015,14 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 		tcp_v6_md5_hash_hdr((__u8 *)topt, key,
 				    &ipv6_hdr(skb)->saddr,
 				    &ipv6_hdr(skb)->daddr, t1);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	tcp_v6_send_response_sign_authopt(sk, aoinfo, aokey, buff,
+					  (struct tcphdr_authopt *)topt, aornextkeyid);
+#endif
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.daddr = ipv6_hdr(skb)->saddr;
 	fl6.saddr = ipv6_hdr(skb)->daddr;
 	fl6.flowlabel = label;
-- 
2.25.1

