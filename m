Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4173B598D72
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345889AbiHRUGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbiHRUEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:04:15 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23464D25D5;
        Thu, 18 Aug 2022 13:01:07 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id w19so5178946ejc.7;
        Thu, 18 Aug 2022 13:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=snEf9OD+gQs4ZebjjnqGpAcw3jq2Lx6aCo0inZJ5Zo4=;
        b=QwN2QCrSjmsdi98whEUUFujiZDlZK1nzjGSWCJW0jYDdiQkr+L3GLfC5fbl3nYYA0j
         t2JvtzU7ufiA/qttGmoNuJ3minGhGHoMCZj5RwI/W3tTeejJMW7nXMvlkBUHCIh3QxgD
         Ggn6N46x9LNBwBmi0jUI6MHSl8y+kiuh9FeOp4SUrYRnSQPZ1FF7iJHso0hqYukM7Jc4
         hEcaH7X6S7NxBtvcWn8hl2XQFq1/OUckfcVFi7DURKdnj+kfuU0HjbsWXwbwI+QINgyO
         H9D4SypAl5KR4efFILgyf/w33OJvTjjHobo4bLeVu2JKhFpPyDHHqDNSIkjGbj2e/Gf3
         i+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=snEf9OD+gQs4ZebjjnqGpAcw3jq2Lx6aCo0inZJ5Zo4=;
        b=tjMSLw78ZpDAvzpXuCsw56vR6QYl3Nh1uNzqzwxwuYOb7aTiaCS3W7ftPfsL5kmZhD
         SCVzpm+He9XZ6BiwcuyZrL1VMleybdGtzjd5iIURN58S56h9FmLIOurrPRXy0IUkhd1w
         CuJdXPuunVlbmG2fC0lCfbIpgwveaRRPWt5+i8FA4hRqESXxf3ifPaLhz5r7cCoi7JhI
         rI1rd9oIlpKiQc7R1ZygFBA4iHL+8KqIN2N44KsRzOn+B+MbqOFaS6JQW5vTUu+7KmOx
         EWBd3u1ZJiNkyXpyJyxIgcu5an3IwIGrTbIdv4iIaqp7VFZ5t6AYmseEmPWSXhJEFJyJ
         SUEQ==
X-Gm-Message-State: ACgBeo2/fVRSe14ExdzpXsJUeFYSbDAByPKCoKAq8fPWrS0Wxk1EVcgN
        YZpr2QaI1WUmSGW6fT1uzkc=
X-Google-Smtp-Source: AA6agR5pu60HdIqBlook7t+r1LQxKBqXsv/pbYMnQ1gFBZ+l+8hPH31KNXIEok2B2uOJPIhdrVdn8w==
X-Received: by 2002:a17:907:b02:b0:731:3f2d:f09 with SMTP id h2-20020a1709070b0200b007313f2d0f09mr2902611ejl.122.1660852865525;
        Thu, 18 Aug 2022 13:01:05 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:01:04 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 26/26] tcp: authopt: Initial implementation of TCP_REPAIR_AUTHOPT
Date:   Thu, 18 Aug 2022 23:00:00 +0300
Message-Id: <817b877b44d6946bc9285d1518dda48787555644.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
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

In order to support TCP_REPAIR for connections using RFC5925
Authentication Option add a sockopt to get/set ISN and SNE values.

The TCP_REPAIR_AUTHOxpTP sockopt is only allowed when the socket is
already in "repair" mode, this behavior is shared with other sockopts
relevant to TCP_REPAIR.

The setsockopt further requires the TCP_ESTABLISHED state, this is
because it relies on snd_nxt which is only initialized after connect().

For SNE restoration we provide a full 64-bit sequence number on "get" and
handle any recent 64-bit sequence number on "set", where recent means
"within ~2GB to the current window".

Linux tracks snd_sne and rcv_sne as the extension of snd_nxt and
rcv_nxt but this is an implementation detail and snd_nxt doesn't even
seem to be one of the values that can be read by userspace. Handling SNE
with 64-bit values means userspace doesn't need to worry about matching
snd_nxt.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  2 ++
 include/uapi/linux/tcp.h  | 19 +++++++++++
 net/ipv4/tcp.c            | 23 ++++++++++++++
 net/ipv4/tcp_authopt.c    | 66 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 4f83d8e54fef..fda6dc4b5d57 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -231,10 +231,12 @@ static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
 						 lockdep_sock_is_held((struct sock *)tp));
 		if (info)
 			__tcp_authopt_update_snd_sne(tp, info, seq);
 	}
 }
+int tcp_get_authopt_repair_val(struct sock *sk, struct tcp_authopt_repair *opt);
+int tcp_set_authopt_repair(struct sock *sk, sockptr_t optval, unsigned int optlen);
 #else
 static inline void tcp_authopt_clear(struct sock *sk)
 {
 }
 static inline int tcp_authopt_openreq(struct sock *newsk,
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 5ca8aa9d5e43..ee6836f87cf8 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -128,10 +128,11 @@ enum {
 #define TCP_CM_INQ		TCP_INQ
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
 #define TCP_AUTHOPT		38	/* TCP Authentication Option (RFC5925) */
 #define TCP_AUTHOPT_KEY		39	/* TCP Authentication Option Key (RFC5925) */
+#define TCP_REPAIR_AUTHOPT	40
 
 
 #define TCP_REPAIR_ON		1
 #define TCP_REPAIR_OFF		0
 #define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
@@ -490,10 +491,28 @@ struct tcp_authopt_key {
 	 * address match is performed.
 	 */
 	int	prefixlen;
 };
 
+/**
+ * struct tcp_authopt_repair - TCP_REPAIR information related to Authentication Option
+ * @src_isn: Local Initial Sequence Number
+ * @dst_isn: Remote Initial Sequence Number
+ * @snd_sne: Sequence Number Extension for Send (upper 32 bits of snd_seq)
+ * @rcv_sne: Sequence Number Extension for Recv (upper 32 bits of rcv_seq)
+ * @snd_seq: Recent Send Sequence Number (lower 32 bits of snd_sne)
+ * @rcv_seq: Recent Recv Sequence Number (lower 32 bits of rcv_sne)
+ */
+struct tcp_authopt_repair {
+	__u32	src_isn;
+	__u32	dst_isn;
+	__u32	snd_sne;
+	__u32	rcv_sne;
+	__u32	snd_seq;
+	__u32	rcv_seq;
+};
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
 struct tcp_zerocopy_receive {
 	__u64 address;		/* in: address of mapping */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 205534d501ec..ad0af4efd265 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3715,10 +3715,13 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		err = tcp_set_authopt(sk, optval, optlen);
 		break;
 	case TCP_AUTHOPT_KEY:
 		err = tcp_set_authopt_key(sk, optval, optlen);
 		break;
+	case TCP_REPAIR_AUTHOPT:
+		err = tcp_set_authopt_repair(sk, optval, optlen);
+		break;
 #endif
 	case TCP_USER_TIMEOUT:
 		/* Cap the max time in ms TCP will retry or probe the window
 		 * before giving up and aborting (ETIMEDOUT) a connection.
 		 */
@@ -4387,10 +4390,30 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			return -EFAULT;
 		if (copy_to_user(optval, &info, len))
 			return -EFAULT;
 		return 0;
 	}
+	case TCP_REPAIR_AUTHOPT: {
+		struct tcp_authopt_repair val;
+		int err;
+
+		if (get_user(len, optlen))
+			return -EFAULT;
+
+		lock_sock(sk);
+		err = tcp_get_authopt_repair_val(sk, &val);
+		release_sock(sk);
+
+		if (err)
+			return err;
+		len = min_t(unsigned int, len, sizeof(val));
+		if (put_user(len, optlen))
+			return -EFAULT;
+		if (copy_to_user(optval, &val, len))
+			return -EFAULT;
+		return 0;
+	}
 #endif
 
 	default:
 		return -ENOPROTOOPT;
 	}
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 933a4bbddb70..a77067c0498b 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1775,10 +1775,76 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 
 	return 1;
 }
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
 
+int tcp_get_authopt_repair_val(struct sock *sk, struct tcp_authopt_repair *opt)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+	int err;
+
+	memset(opt, 0, sizeof(*opt));
+	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
+	if (!tp->repair)
+		return -EPERM;
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -ENOENT;
+
+	opt->dst_isn = info->dst_isn;
+	opt->src_isn = info->src_isn;
+	opt->rcv_sne = info->rcv_sne;
+	opt->snd_sne = info->snd_sne;
+	opt->rcv_seq = tp->rcv_nxt;
+	opt->snd_seq = tp->snd_nxt;
+
+	return 0;
+}
+
+int tcp_set_authopt_repair(struct sock *sk, sockptr_t optval, unsigned int optlen)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_authopt_info *info;
+	struct tcp_authopt_repair val;
+	int err;
+
+	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
+
+	if (optlen != sizeof(val))
+		return -EFAULT;
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
+		return -EFAULT;
+
+	/* tcp_authopt repair relies on fields that are only initialized after
+	 * tcp_connect. Doing this setsockopt before connect() can't be correct
+	 * so return an error.
+	 */
+	if (sk->sk_state != TCP_ESTABLISHED)
+		return -EPERM;
+
+	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return -ENOENT;
+	if (!tp->repair)
+		return -EPERM;
+
+	info->dst_isn = val.dst_isn;
+	info->src_isn = val.src_isn;
+	info->rcv_sne = compute_sne(val.rcv_sne, val.rcv_seq, tp->rcv_nxt);
+	info->snd_sne = compute_sne(val.snd_sne, val.snd_seq, tp->snd_nxt);
+
+	return 0;
+}
+
 #ifdef CONFIG_PROC_FS
 struct tcp_authopt_iter_state {
 	struct seq_net_private p;
 };
 
-- 
2.25.1

