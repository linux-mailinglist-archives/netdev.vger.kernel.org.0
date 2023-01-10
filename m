Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BB0663771
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 03:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjAJCky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 21:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjAJCkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 21:40:53 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAACB7F0;
        Mon,  9 Jan 2023 18:40:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VZH2mQG_1673318444;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VZH2mQG_1673318444)
          by smtp.aliyun-inc.com;
          Tue, 10 Jan 2023 10:40:45 +0800
Date:   Tue, 10 Jan 2023 10:40:44 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Yunhui Cui <cuiyunhui@bytedance.com>, rostedt@goodmis.org,
        mhiramat@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        xiyou.wangcong@gmail.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] sock: add tracepoint for send recv length
Message-ID: <20230110024044.GA74595@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20230108025545.338-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108025545.338-1-cuiyunhui@bytedance.com>
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NUMERIC_HTTP_ADDR,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 08, 2023 at 10:55:45AM +0800, Yunhui Cui wrote:
>Add 2 tracepoints to monitor the tcp/udp traffic
>of per process and per cgroup.
>
>Regarding monitoring the tcp/udp traffic of each process, there are two
>existing solutions, the first one is https://www.atoptool.nl/netatop.php.
>The second is via kprobe/kretprobe.
>
>Netatop solution is implemented by registering the hook function at the
>hook point provided by the netfilter framework.
>
>These hook functions may be in the soft interrupt context and cannot
>directly obtain the pid. Some data structures are added to bind packets
>and processes. For example, struct taskinfobucket, struct taskinfo ...
>
>Every time the process sends and receives packets it needs multiple
>hashmaps,resulting in low performance and it has the problem fo inaccurate
>tcp/udp traffic statistics(for example: multiple threads share sockets).
>
>We can obtain the information with kretprobe, but as we know, kprobe gets
>the result by trappig in an exception, which loses performance compared
>to tracepoint.
>
>We compared the performance of tracepoints with the above two methods, and
>the results are as follows:
>
>ab -n 1000000 -c 1000 -r http://127.0.0.1/index.html

AFAIK, ab are relatively slow compared to some network benchmarks since
it's a http benchmark.
Can you test other benchmarks like sockperf or redis-benchmark with small
packets, and check the PPS drop ? Those benchmarks should have larger PPS.

Like Eric pointed out, those tracepoints in the datapath are not free,
its better to make sure we don't get a noticeable PPS drop after adding
those tracepoints.

Thanks.

>without trace:
>Time per request: 39.660 [ms] (mean)
>Time per request: 0.040 [ms] (mean, across all concurrent requests)
>
>netatop:
>Time per request: 50.717 [ms] (mean)
>Time per request: 0.051 [ms] (mean, across all concurrent requests)
>
>kr:
>Time per request: 43.168 [ms] (mean)
>Time per request: 0.043 [ms] (mean, across all concurrent requests)
>
>tracepoint:
>Time per request: 41.004 [ms] (mean)
>Time per request: 0.041 [ms] (mean, across all concurrent requests
>
>It can be seen that tracepoint has better performance.
>
>Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
>Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
>---
> include/trace/events/sock.h | 48 +++++++++++++++++++++++++++++++++++++
> net/socket.c                | 23 ++++++++++++++----
> 2 files changed, 67 insertions(+), 4 deletions(-)
>
>diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
>index 777ee6cbe933..d00a5b272404 100644
>--- a/include/trace/events/sock.h
>+++ b/include/trace/events/sock.h
>@@ -263,6 +263,54 @@ TRACE_EVENT(inet_sk_error_report,
> 		  __entry->error)
> );
> 
>+/*
>+ * sock send/recv msg length
>+ */
>+DECLARE_EVENT_CLASS(sock_msg_length,
>+
>+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
>+		 int flags),
>+
>+	TP_ARGS(sk, family, protocol, ret, flags),
>+
>+	TP_STRUCT__entry(
>+		__field(void *, sk)
>+		__field(__u16, family)
>+		__field(__u16, protocol)
>+		__field(int, length)
>+		__field(int, error)
>+		__field(int, flags)
>+	),
>+
>+	TP_fast_assign(
>+		__entry->sk = sk;
>+		__entry->family = sk->sk_family;
>+		__entry->protocol = sk->sk_protocol;
>+		__entry->length = ret > 0 ? ret : 0;
>+		__entry->error = ret < 0 ? ret : 0;
>+		__entry->flags = flags;
>+	),
>+
>+	TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
>+		  __entry->sk, show_family_name(__entry->family),
>+		  show_inet_protocol_name(__entry->protocol),
>+		  __entry->length,
>+		  __entry->error, __entry->flags)
>+);
>+
>+DEFINE_EVENT(sock_msg_length, sock_send_length,
>+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
>+		 int flags),
>+
>+	TP_ARGS(sk, family, protocol, ret, flags)
>+);
>+
>+DEFINE_EVENT(sock_msg_length, sock_recv_length,
>+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
>+		 int flags),
>+
>+	TP_ARGS(sk, family, protocol, ret, flags)
>+);
> #endif /* _TRACE_SOCK_H */
> 
> /* This part must be outside protection */
>diff --git a/net/socket.c b/net/socket.c
>index 888cd618a968..60a1ff95b4b1 100644
>--- a/net/socket.c
>+++ b/net/socket.c
>@@ -106,6 +106,7 @@
> #include <net/busy_poll.h>
> #include <linux/errqueue.h>
> #include <linux/ptp_clock_kernel.h>
>+#include <trace/events/sock.h>
> 
> #ifdef CONFIG_NET_RX_BUSY_POLL
> unsigned int sysctl_net_busy_read __read_mostly;
>@@ -715,6 +716,9 @@ static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
> 				     inet_sendmsg, sock, msg,
> 				     msg_data_left(msg));
> 	BUG_ON(ret == -EIOCBQUEUED);
>+
>+	trace_sock_send_length(sock->sk, sock->sk->sk_family,
>+			       sock->sk->sk_protocol, ret, 0);
> 	return ret;
> }
> 
>@@ -992,9 +996,15 @@ INDIRECT_CALLABLE_DECLARE(int inet6_recvmsg(struct socket *, struct msghdr *,
> static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
> 				     int flags)
> {
>-	return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
>-				  inet_recvmsg, sock, msg, msg_data_left(msg),
>-				  flags);
>+	int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
>+				     inet_recvmsg, sock, msg,
>+				     msg_data_left(msg), flags);
>+
>+	trace_sock_recv_length(sock->sk, sock->sk->sk_family,
>+			       sock->sk->sk_protocol,
>+			       !(flags & MSG_PEEK) ? ret :
>+			       (ret < 0 ? ret : 0), flags);
>+	return ret;
> }
> 
> /**
>@@ -1044,6 +1054,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
> {
> 	struct socket *sock;
> 	int flags;
>+	int ret;
> 
> 	sock = file->private_data;
> 
>@@ -1051,7 +1062,11 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
> 	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
> 	flags |= more;
> 
>-	return kernel_sendpage(sock, page, offset, size, flags);
>+	ret = kernel_sendpage(sock, page, offset, size, flags);
>+
>+	trace_sock_send_length(sock->sk, sock->sk->sk_family,
>+			       sock->sk->sk_protocol, ret, 0);
>+	return ret;
> }
> 
> static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
>-- 
>2.20.1
