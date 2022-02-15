Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA64B6968
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiBOKha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:37:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiBOKh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:37:29 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FA070F7C;
        Tue, 15 Feb 2022 02:37:18 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id m22so14949849pfk.6;
        Tue, 15 Feb 2022 02:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o7EA9TEAuJMo56GB1oxjqr4sMG5yZbF1t8svUxaUlWc=;
        b=nMU/2kft/oSs9PdmnYhOULCiNiCJ/N1FNKZ3dYRsPy4L7W+tiStxq/+4GwfhOig56g
         yuzlp8ySDrGp1c4Y9JdZjbA7EUqYKG9UgrBDxrYopRsZkYYB8wb5aoydChfKT5ophvNj
         8kpOZk3p6aafsvb71AwFzkq1fGQNA14iHngpQqTi1YcpdYAXD+LEzVjI6Hexex6Dy90Z
         KVBMfZXXLtSa92wJgtSextVLesT4PQJxh7as+fhE/pTF60vII7nppoczbLQOxEs3eB+R
         06LHsSMOzrPx887o5E3SQpoDH7+52gpoBhIYJ1t386dnyYuXoTAvmhba2lwjK2UDRklo
         9DJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o7EA9TEAuJMo56GB1oxjqr4sMG5yZbF1t8svUxaUlWc=;
        b=D1K6UrfNkCODbBzM82iIIyPfC7dFcZLh66hvKC1P8SnjpueEFwbG7NJN7alQg2a0Xq
         0Hg7c4xclyPqiSZnjlpwx1DLjZDJ7DeSR8xWvBcf+brDFvrp7pPDfFQb0SnllD/uDzEL
         rM9RQWf6j07hw1gTzhMobvszl/NRWJI1masvMoTXO9NIENfMdFVDWKnoeRagk78ogc51
         gU6iPZhKWqEuGHQW3e+auCQkDI1S/9MqyKiHahgVj6RyhS4WF1DUz4nX0KhydlNMED6n
         RnGT602ow5PxYoIpxfEqNC62EqVQ9dXVNfS9XjmfMt6rpaRkVbav69uT1phmI6/SKf7E
         Pqdw==
X-Gm-Message-State: AOAM5333HukllsSTi/8EZiH8bhiZZcrK6XkI4gmSXHfeNchVhUSqkQju
        wTBnIszLlNy03MoqmKA0jdY=
X-Google-Smtp-Source: ABdhPJwOLEVABPhET1mCtpLiwD7OASr6UCShYK71di9VS/O2Nue+QgDeTSCAYD3igXq+X6ki/obJKA==
X-Received: by 2002:a63:4e0e:: with SMTP id c14mr3006920pgb.490.1644921438118;
        Tue, 15 Feb 2022 02:37:18 -0800 (PST)
Received: from localhost.localdomain ([162.219.34.248])
        by smtp.gmail.com with ESMTPSA id a17sm16712622pju.15.2022.02.15.02.37.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Feb 2022 02:37:17 -0800 (PST)
From:   kerneljasonxing@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, edumazet@google.com, pabeni@redhat.com,
        weiwan@google.com, aahringo@redhat.com, yangbo.lu@nxp.com,
        fw@strlen.de, xiangxia.m.yue@gmail.com, tglx@linutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <xingwanli@kuaishou.com>
Subject: [PATCH] net: do not set SOCK_RCVBUF_LOCK if sk_rcvbuf isn't reduced
Date:   Tue, 15 Feb 2022 18:36:39 +0800
Message-Id: <20220215103639.11739-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

From: Jason Xing <xingwanli@kuaishou.com>

Normally, user doesn't care the logic behind the kernel if they're
trying to set receive buffer via setsockopt. However, if the new value
of the receive buffer is not smaller than the initial value which is
sysctl_tcp_rmem[1] implemented in tcp_rcv_space_adjust(), the server's
wscale will shrink and then lead to the bad bandwidth. I think it is
not appropriate.

Here are some numbers:
$ sysctl -a | grep rmem
net.core.rmem_default = 212992
net.core.rmem_max = 40880000
net.ipv4.tcp_rmem = 4096	425984	40880000

Case 1
on the server side
    # iperf -s -p 5201
on the client side
    # iperf -c [client ip] -p 5201
It turns out that the bandwidth is 9.34 Gbits/sec while the wscale of
server side is 10. It's good.

Case 2
on the server side
    #iperf -s -p 5201 -w 425984
on the client side
    # iperf -c [client ip] -p 5201
It turns out that the bandwidth is reduced to 2.73 Gbits/sec while the
wcale is 2, even though the receive buffer is not changed at all at the
very beginning.

Therefore, I added one condition where only user is trying to set a
smaller rx buffer. After this patch is applied, the bandwidth of case 2
is recovered to 9.34 Gbits/sec.

Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's rcv-buffer via setsockopt")
Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
---
 net/core/filter.c | 7 ++++---
 net/core/sock.c   | 8 +++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4603b7c..99f5d9c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4795,9 +4795,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		case SO_RCVBUF:
 			val = min_t(u32, val, sysctl_rmem_max);
 			val = min_t(int, val, INT_MAX / 2);
-			sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
-			WRITE_ONCE(sk->sk_rcvbuf,
-				   max_t(int, val * 2, SOCK_MIN_RCVBUF));
+			val = max_t(int, val * 2, SOCK_MIN_RCVBUF);
+			if (val < sock_net(sk)->ipv4.sysctl_tcp_rmem[1])
+				sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
+			WRITE_ONCE(sk->sk_rcvbuf, val);
 			break;
 		case SO_SNDBUF:
 			val = min_t(u32, val, sysctl_wmem_max);
diff --git a/net/core/sock.c b/net/core/sock.c
index 4ff806d..e5e9cb0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -923,8 +923,6 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
 	 * as a negative value.
 	 */
 	val = min_t(int, val, INT_MAX / 2);
-	sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
-
 	/* We double it on the way in to account for "struct sk_buff" etc.
 	 * overhead.   Applications assume that the SO_RCVBUF setting they make
 	 * will allow that much actual data to be received on that socket.
@@ -935,7 +933,11 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
 	 * And after considering the possible alternatives, returning the value
 	 * we actually used in getsockopt is the most desirable behavior.
 	 */
-	WRITE_ONCE(sk->sk_rcvbuf, max_t(int, val * 2, SOCK_MIN_RCVBUF));
+	val = max_t(int, val * 2, SOCK_MIN_RCVBUF);
+	if (val < sock_net(sk)->ipv4.sysctl_tcp_rmem[1])
+		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
+
+	WRITE_ONCE(sk->sk_rcvbuf, val);
 }
 
 void sock_set_rcvbuf(struct sock *sk, int val)
-- 
1.8.3.1

