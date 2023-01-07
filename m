Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6F7660C5C
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 05:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbjAGD76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 22:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjAGD75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 22:59:57 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07648392C7
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 19:59:34 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so3813469pjj.4
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 19:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eV3FSIzZsaSG9EL9HIoGOx0jsNw0iQIYn8B4hfLW3Gc=;
        b=CXPGgMoXLWmPllaPizHteLaIZ0VU/hrloXV1SAF6SOp2syhNfGQbGru4GQH14RyKdm
         AVBIUkO8nMjgIgwwEp2POSYQyl3CojnR+skrdjojVXyVT/bm5a7d51jft1LhBrRuphtt
         ixr8FOHLpM/hzKyi6L7Mvy1tXhx5VoO5h+c4n7Zn7TjGL+1oOoFKDu65X1i3l1vD2gS/
         09PAr/cD+jpTxCxdGpbVYZcF5CEoR0CMHs0Sn5C2yuZ7UmLmYzUjbgZzLbLUS8RcoBk3
         NKTK62Iutu5TnMZcahpfvdCuek674obWJurNOYFXTYGozAcIej8WpuIx3kxey2taJlBi
         LXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eV3FSIzZsaSG9EL9HIoGOx0jsNw0iQIYn8B4hfLW3Gc=;
        b=6qIPOo64NIzC+UcZ0i68NLHLDKNp+CUIPwe8YuEHbfKLkpJBL2/bDmRcsyUw9cyUAf
         syDPla/igj5hBThNNbhEk1P1IthnyxUIcX45Qkmu9chgox81vMIo7v+eYgSf8qiXcgZR
         n0eNq0Ebj2N8fushSasqwLNRhKssDixdp4WNHSkHn+oCpC3QCKi8yQived7iYJ4IAM0a
         BtiTjZLT+nazwna0AGERC8PM2Fzkh5nBGyVTO3jSbDZE5oVgiRJy0JeeyhDM28AFdu+d
         g/LBRQmxf5WXHskF3vbeGpbpNMcdnIuWpvtqY4d63aUNuD6+AzXUshouzZq3WN5kSvZn
         WWIA==
X-Gm-Message-State: AFqh2kpJhOoOQdSeST6pdFwhE+ZiZPzbUgpxFhKLl40dUR7PbUFMissa
        kpdOYIv59uYudGsYoEXJpPCKbQ==
X-Google-Smtp-Source: AMrXdXuLro1czlc5oFdOkmqnea29RoiOJuWKXVNejtdK6VUAjprrID7neufYssPD66oqA2F90wPEqw==
X-Received: by 2002:a05:6a20:1455:b0:ae:661c:5553 with SMTP id a21-20020a056a20145500b000ae661c5553mr86163772pzi.4.1673063973478;
        Fri, 06 Jan 2023 19:59:33 -0800 (PST)
Received: from PF2E59YH-BKX.inc.bytedance.com ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id j17-20020a635511000000b00478b930f970sm1512682pgb.66.2023.01.06.19.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 19:59:33 -0800 (PST)
From:   Yunhui Cui <cuiyunhui@bytedance.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, cuiyunhui@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3] sock: add tracepoint for send recv length
Date:   Sat,  7 Jan 2023 11:59:23 +0800
Message-Id: <20230107035923.363-1-cuiyunhui@bytedance.com>
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
 include/trace/events/sock.h | 49 +++++++++++++++++++++++++++++++++++++
 net/socket.c                | 20 +++++++++++++--
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 777ee6cbe933..16092c0406a2 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -263,6 +263,55 @@ TRACE_EVENT(inet_sk_error_report,
 		  __entry->error)
 );
 
+/*
+ * sock send/recv msg length
+ */
+DECLARE_EVENT_CLASS(sock_msg_length,
+
+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
+		 int flags),
+
+	TP_ARGS(sk, family, protocol, ret, flags),
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
+			__entry->sk,
+			show_family_name(__entry->family),
+			show_inet_protocol_name(__entry->protocol),
+			__entry->length,
+			__entry->error, __entry->flags)
+);
+
+DEFINE_EVENT(sock_msg_length, sock_sendmsg_length,
+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
+		 int flags),
+
+	TP_ARGS(sk, family, protocol, ret, flags)
+);
+
+DEFINE_EVENT(sock_msg_length, sock_recvmsg_length,
+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
+		 int flags),
+
+	TP_ARGS(sk, family, protocol, ret, flags)
+);
 #endif /* _TRACE_SOCK_H */
 
 /* This part must be outside protection */
diff --git a/net/socket.c b/net/socket.c
index 888cd618a968..37578e8c685b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -106,6 +106,7 @@
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
 #include <linux/ptp_clock_kernel.h>
+#include <trace/events/sock.h>
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 unsigned int sysctl_net_busy_read __read_mostly;
@@ -715,6 +716,9 @@ static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 				     inet_sendmsg, sock, msg,
 				     msg_data_left(msg));
 	BUG_ON(ret == -EIOCBQUEUED);
+
+	trace_sock_sendmsg_length(sock->sk, sock->sk->sk_family,
+				  sock->sk->sk_protocol, ret, 0);
 	return ret;
 }
 
@@ -992,9 +996,16 @@ INDIRECT_CALLABLE_DECLARE(int inet6_recvmsg(struct socket *, struct msghdr *,
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				     int flags)
 {
-	return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
+	int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
 				  inet_recvmsg, sock, msg, msg_data_left(msg),
 				  flags);
+
+	trace_sock_recvmsg_length(sock->sk, sock->sk->sk_family,
+				  sock->sk->sk_protocol,
+				  !(flags & MSG_PEEK) ? ret :
+				  (ret < 0 ? ret : 0),
+				  flags);
+	return ret;
 }
 
 /**
@@ -1044,6 +1055,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 {
 	struct socket *sock;
 	int flags;
+	int ret;
 
 	sock = file->private_data;
 
@@ -1051,7 +1063,11 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
 	flags |= more;
 
-	return kernel_sendpage(sock, page, offset, size, flags);
+	ret = kernel_sendpage(sock, page, offset, size, flags);
+
+	trace_sock_sendmsg_length(sock->sk, sock->sk->sk_family,
+				  sock->sk->sk_protocol, ret, 0);
+	return ret;
 }
 
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
-- 
2.20.1

