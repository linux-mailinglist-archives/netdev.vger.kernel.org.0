Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5EA4BA6A9
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiBQRFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:05:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiBQRFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:05:21 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F0D27908F
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:05:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y9so6195891pjf.1
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S4gUCWWbQNnD9n6hOQFJfcvZNKv6DCzq4+r0yrsWHF0=;
        b=bwKsy7PGAfkFqmXfAKzHjywmT47otTF33bLE2Yz7sBJBO7mHgwH/4Lyf9erO83nqS/
         KJ0qzE1wwnFQ0Yj3yZcpj/hmhlJGBTTPmkorBBYxpsThbMno8EYJHZfvHTjPOJXHBlp5
         Yos+qbLkV/50GL6lD12bnpEo82umi4ffCW3JlSAxAmLGck4ylYROxdyHljQwbtpcMkL+
         5yhTEt3thtLlQHS/2BvVQUknaeG+jRa6kwyZi2VAdSiIvkAXF+K/S6dPwB5P62wFBMwC
         9y6dBXmEeVRArTJw53dSXtlbo1TuNpIxHQ6AcW/WRCwqtp5nzMA6KMooBZjEhcufE5M6
         dRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S4gUCWWbQNnD9n6hOQFJfcvZNKv6DCzq4+r0yrsWHF0=;
        b=j46jxcGcYtgzj9F31gA7b48uBNy2qtNXZ12JNLM+2xD07J2/z/o5OIZlJg54p7hP7q
         B4HsL7xMGov0LYdVtz3EM9Zvc/J/WTwSkIGh2uMVFQoveVhcdrTsrAp/BbG8u0pdJdv3
         WRCr1qef2wh36S2zRIp1WXlzmhEc3bJPMdVTGfaZWBaO+MjLSx+kLP6KL0082U+ffshZ
         7eIfEDC1Oz1VQPU/NPs7XGdTAW4UHTx7V+3WvI0C7K25KkUb2SAF4ouFs5BOrKIYOSrP
         Q6quOlt1tIOTYuEqqMuOdoNNXjxDFnJlSqyuwKq9ZkqdjKtrKdbz7BUX6WzYGewqiuSv
         H2ng==
X-Gm-Message-State: AOAM532n3JEj9mQqGP0lktkWhKSVT1Ai2weYRJxUUQV6kN8UFlXAYDxL
        oXu7kEFeD5G94eyILsonT10=
X-Google-Smtp-Source: ABdhPJzKVr4EvThUPA4pgETI+vMSaHJ8nb/f731iIcl6zMjhmCCESBDwJfYcqgMc93zFV0D+08he5w==
X-Received: by 2002:a17:902:7b85:b0:14e:fbca:9af9 with SMTP id w5-20020a1709027b8500b0014efbca9af9mr3665134pll.29.1645117506418;
        Thu, 17 Feb 2022 09:05:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8878:fd78:2268:60a3])
        by smtp.gmail.com with ESMTPSA id h27sm8612639pgb.20.2022.02.17.09.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 09:05:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net-timestamp: convert sk->sk_tskey to atomic_t
Date:   Thu, 17 Feb 2022 09:05:02 -0800
Message-Id: <20220217170502.641160-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

UDP sendmsg() can be lockless, this is causing all kinds
of data races.

This patch converts sk->sk_tskey to remove one of these races.

BUG: KCSAN: data-race in __ip_append_data / __ip_append_data

read to 0xffff8881035d4b6c of 4 bytes by task 8877 on cpu 1:
 __ip_append_data+0x1c1/0x1de0 net/ipv4/ip_output.c:994
 ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
 udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff8881035d4b6c of 4 bytes by task 8880 on cpu 0:
 __ip_append_data+0x1d8/0x1de0 net/ipv4/ip_output.c:994
 ip_make_skb+0x13f/0x2d0 net/ipv4/ip_output.c:1636
 udp_sendmsg+0x12bd/0x14c0 net/ipv4/udp.c:1249
 inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000054d -> 0x0000054e

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 8880 Comm: syz-executor.5 Not tainted 5.17.0-rc2-syzkaller-00167-gdcb85f85fa6f-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/sock.h        | 4 ++--
 net/can/j1939/transport.c | 2 +-
 net/core/skbuff.c         | 2 +-
 net/core/sock.c           | 4 ++--
 net/ipv4/ip_output.c      | 2 +-
 net/ipv6/ip6_output.c     | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ff9b508d9c5ffcb9a30deb730b27046e463bda37..50aecd28b355082bce495a89a8a871b15e3e7e2c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -507,7 +507,7 @@ struct sock {
 #endif
 	u16			sk_tsflags;
 	u8			sk_shutdown;
-	u32			sk_tskey;
+	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
 
 	u8			sk_clockid;
@@ -2667,7 +2667,7 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
 		__sock_tx_timestamp(tsflags, tx_flags);
 		if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
 		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
-			*tskey = sk->sk_tskey++;
+			*tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 	}
 	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
 		*tx_flags |= SKBTX_WIFI_STATUS;
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index a271688780a2c1a3bff6c2578502f972da34a30b..307ee1174a6e2e3d8cb9edd2c7485ddd22014ce6 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2006,7 +2006,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		/* set the end-packet for broadcast */
 		session->pkt.last = session->pkt.total;
 
-	skcb->tskey = session->sk->sk_tskey++;
+	skcb->tskey = atomic_inc_return(&session->sk->sk_tskey) - 1;
 	session->tskey = skcb->tskey;
 
 	return session;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9d0388bed0c1d2166214c95081f4778afe9f50ed..6a15ce3eb1d338616d6ab52d6c5c21baa9db993b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4730,7 +4730,7 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 	if (sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID) {
 		serr->ee.ee_data = skb_shinfo(skb)->tskey;
 		if (sk_is_tcp(sk))
-			serr->ee.ee_data -= sk->sk_tskey;
+			serr->ee.ee_data -= atomic_read(&sk->sk_tskey);
 	}
 
 	err = sock_queue_err_skb(sk, skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index 4ff806d71921618e2dbf7d5bb041040cbc72b674..6eb174805bf022f2e143c52b68aec3684a8d0956 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -879,9 +879,9 @@ int sock_set_timestamping(struct sock *sk, int optname,
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
-			sk->sk_tskey = tcp_sk(sk)->snd_una;
+			atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
 		} else {
-			sk->sk_tskey = 0;
+			atomic_set(&sk->sk_tskey, 0);
 		}
 	}
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 139cec29ed06cd092ebdfd2bf0d13aaf67c5359d..7911916a480bd9a8ef0e17414a6dcf6def6475dd 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -991,7 +991,7 @@ static int __ip_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2995f8d89e7e923203be2dfe8674be4ab424d323..304a295de84f9c05bbc99fc1db5f4507004c0769 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1465,7 +1465,7 @@ static int __ip6_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
-- 
2.35.1.265.g69c8d7142f-goog

