Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B24D663C7E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjAJJPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjAJJPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:15:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598D15131D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:15:20 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y5so8311911pfe.2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+xfZbEYbh/Q29ZJ4Nqg9QA8hyR4QarYUB/yXo5iriLM=;
        b=U3OKDoBTw4gnRy+Me/WwUJW4mTaUx8JyyvaTKsVBwMwrmKP1a7q9VzBRIQtdU5RdOm
         nEbsOA4OLakNcandN4kvkZyJ9t0C+HZo7FShk/OPeD46UoqzafDEwlTD2zu4cM96s4VW
         /+qEFVqlbh/y6JLicdA/feO/lyH5djLwq9U0sPS8HxjSqghCbBA5ThpigmXBq6NkvXVv
         oSF2aYwAGREx7PeZbtADxEVd10cd/LR1Jpx8XRPYYTSuLuE6Bk5K3fr/zOaoA7h8cY+l
         0xGkWoJj/gEpY3v7d9mPns9NcDJdZ0vBkE9cS8vy7OWwquL4TRgAgk4c6U9HHYNXNarS
         aiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+xfZbEYbh/Q29ZJ4Nqg9QA8hyR4QarYUB/yXo5iriLM=;
        b=byeMjM0kbx0+Z9pCV7AJGBV2pxQtzktQl4AMjKeiwfxSvI89396lGPxlR6OJz3K+1V
         lpW6d2t51MQbqtXVqzYgJc4HV3lexlB9EW0iCKKe6mEI3XYAajBe7ErzgVw1ftU8KaRP
         gxiYiWmksiTLUHN5mhiJTHPaaWEpzkCLCz/DIhefITArCBeaVYMT2TTzpDFCEBPM3Duo
         iM3NI138qaZuVITpf5qICtJsrapHadI6PpzCilbeKIrGbjYWyaXeonpKVxdA07t9n4J5
         HAfCQjfGBYZ3mQL+OHoN932FNZacZfD+RpHfvZVLg9tKSjAharnZlXdmALr8QBXJ+MHo
         idrg==
X-Gm-Message-State: AFqh2kqVAsX2r2vRPh/GfT8krWWsEIulQB0CvC9BXP17Jf49pMGn8SUn
        yOlv9WDudXOp0owtH0/1kMDLwg==
X-Google-Smtp-Source: AMrXdXtDUYsVu0U7Q8RRUGUSejDjcY0xJ5Fb2ueK+CHB4hvfEQHr3eZeP6ANT/6UyImFqWjLSchBaA==
X-Received: by 2002:a62:1d97:0:b0:578:ac9f:79a9 with SMTP id d145-20020a621d97000000b00578ac9f79a9mr63359945pfd.15.1673342119808;
        Tue, 10 Jan 2023 01:15:19 -0800 (PST)
Received: from PF2E59YH-BKX.inc.bytedance.com ([61.213.176.5])
        by smtp.gmail.com with ESMTPSA id z5-20020aa79f85000000b00575fbe1cf2esm7562856pfr.109.2023.01.10.01.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:15:19 -0800 (PST)
From:   Yunhui Cui <cuiyunhui@bytedance.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, cuiyunhui@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dust.li@linux.alibaba.com
Subject: [PATCH v5] sock: add tracepoint for send recv length
Date:   Tue, 10 Jan 2023 17:13:56 +0800
Message-Id: <20230110091356.1524-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.37.3.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 2 tracepoints to monitor the tcp/udp traffic
of per process and per cgroup.

Regarding monitoring the tcp/udp traffic of each process, there are two
existing solutions, the first one is https://www.atoptool.nl/netatop.php.
The second is via kprobe/kretprobe.

Netatop solution is implemented by registering the hook function at the
hook point provided by the netfilter framework.

These hook functions may be in the soft interrupt context and cannot
directly obtain the pid. Some data structures are added to bind packets
and processes. For example, struct taskinfobucket, struct taskinfo ...

Every time the process sends and receives packets it needs multiple
hashmaps,resulting in low performance and it has the problem fo inaccurate
tcp/udp traffic statistics(for example: multiple threads share sockets).

We can obtain the information with kretprobe, but as we know, kprobe gets
the result by trappig in an exception, which loses performance compared
to tracepoint.

We compared the performance of tracepoints with the above two methods, and
the results are as follows:

ab -n 1000000 -c 1000 -r http://127.0.0.1/index.html
without trace:
Time per request: 39.660 [ms] (mean)
Time per request: 0.040 [ms] (mean, across all concurrent requests)

netatop:
Time per request: 50.717 [ms] (mean)
Time per request: 0.051 [ms] (mean, across all concurrent requests)

kr:
Time per request: 43.168 [ms] (mean)
Time per request: 0.043 [ms] (mean, across all concurrent requests)

tracepoint:
Time per request: 41.004 [ms] (mean)
Time per request: 0.041 [ms] (mean, across all concurrent requests

It can be seen that tracepoint has better performance.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
---
 include/trace/events/sock.h | 44 +++++++++++++++++++++++++++++++++++++
 net/socket.c                | 36 ++++++++++++++++++++++++++----
 2 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 777ee6cbe933..2c380cb110a3 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -263,6 +263,50 @@ TRACE_EVENT(inet_sk_error_report,
 		  __entry->error)
 );
 
+/*
+ * sock send/recv msg length
+ */
+DECLARE_EVENT_CLASS(sock_msg_length,
+
+	TP_PROTO(struct sock *sk, int ret, int flags),
+
+	TP_ARGS(sk, ret, flags),
+
+	TP_STRUCT__entry(
+		__field(void *, sk)
+		__field(__u16, family)
+		__field(__u16, protocol)
+		__field(int, length)
+		__field(int, error)
+		__field(int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->family = sk->sk_family;
+		__entry->protocol = sk->sk_protocol;
+		__entry->length = ret > 0 ? ret : 0;
+		__entry->error = ret < 0 ? ret : 0;
+		__entry->flags = flags;
+	),
+
+	TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
+		  __entry->sk, show_family_name(__entry->family),
+		  show_inet_protocol_name(__entry->protocol),
+		  __entry->length, __entry->error, __entry->flags)
+);
+
+DEFINE_EVENT(sock_msg_length, sock_send_length,
+	TP_PROTO(struct sock *sk, int ret, int flags),
+
+	TP_ARGS(sk, ret, flags)
+);
+
+DEFINE_EVENT(sock_msg_length, sock_recv_length,
+	TP_PROTO(struct sock *sk, int ret, int flags),
+
+	TP_ARGS(sk, ret, flags)
+);
 #endif /* _TRACE_SOCK_H */
 
 /* This part must be outside protection */
diff --git a/net/socket.c b/net/socket.c
index 888cd618a968..6180d0ad47f9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -106,6 +106,7 @@
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
 #include <linux/ptp_clock_kernel.h>
+#include <trace/events/sock.h>
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 unsigned int sysctl_net_busy_read __read_mostly;
@@ -709,12 +710,22 @@ INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
 					   size_t));
 INDIRECT_CALLABLE_DECLARE(int inet6_sendmsg(struct socket *, struct msghdr *,
 					    size_t));
+
+static noinline void call_trace_sock_send_length(struct sock *sk, int ret,
+						 int flags)
+{
+	trace_sock_send_length(sk, ret, 0);
+}
+
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 {
 	int ret = INDIRECT_CALL_INET(sock->ops->sendmsg, inet6_sendmsg,
 				     inet_sendmsg, sock, msg,
 				     msg_data_left(msg));
 	BUG_ON(ret == -EIOCBQUEUED);
+
+	if (trace_sock_send_length_enabled())
+		call_trace_sock_send_length(sock->sk, ret, 0);
 	return ret;
 }
 
@@ -989,12 +1000,24 @@ INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
 					   size_t, int));
 INDIRECT_CALLABLE_DECLARE(int inet6_recvmsg(struct socket *, struct msghdr *,
 					    size_t, int));
+
+static noinline void call_trace_sock_recv_length(struct sock *sk, int ret, int flags)
+{
+	trace_sock_recv_length(sk, !(flags & MSG_PEEK) ? ret :
+			       (ret < 0 ? ret : 0), flags);
+}
+
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				     int flags)
 {
-	return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
-				  inet_recvmsg, sock, msg, msg_data_left(msg),
-				  flags);
+	int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
+				     inet_recvmsg, sock, msg,
+				     msg_data_left(msg), flags);
+
+	if (trace_sock_recv_length_enabled())
+		call_trace_sock_recv_length(sock->sk, !(flags & MSG_PEEK) ?
+					    ret : (ret < 0 ? ret : 0), flags);
+	return ret;
 }
 
 /**
@@ -1044,6 +1067,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 {
 	struct socket *sock;
 	int flags;
+	int ret;
 
 	sock = file->private_data;
 
@@ -1051,7 +1075,11 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
 	flags |= more;
 
-	return kernel_sendpage(sock, page, offset, size, flags);
+	ret = kernel_sendpage(sock, page, offset, size, flags);
+
+	if (trace_sock_send_length_enabled())
+		call_trace_sock_send_length(sock->sk, ret, 0);
+	return ret;
 }
 
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
-- 
2.20.1

