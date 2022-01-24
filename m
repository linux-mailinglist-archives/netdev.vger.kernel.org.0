Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C15497C47
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiAXJnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:43:35 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:26492 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231812AbiAXJnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:43:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V2iRAzW_1643017409;
Received: from hao-A29R.hz.ali.com(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V2iRAzW_1643017409)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 Jan 2022 17:43:30 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     netdev@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/3] net-zerocopy: split zerocopy receive to several parts
Date:   Mon, 24 Jan 2022 17:43:18 +0800
Message-Id: <20220124094320.900713-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124094320.900713-1-haoxu@linux.alibaba.com>
References: <20220124094320.900713-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the zerocopy receive code to several parts so that we can use them
easily in other places like io_uring.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 include/net/tcp.h |   5 ++
 net/ipv4/tcp.c    | 128 +++++++++++++++++++++++++++-------------------
 2 files changed, 80 insertions(+), 53 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 44e442bf23f9..ba0e7957bdfb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -419,6 +419,11 @@ void tcp_data_ready(struct sock *sk);
 #ifdef CONFIG_MMU
 int tcp_mmap(struct file *file, struct socket *sock,
 	     struct vm_area_struct *vma);
+int zc_receive_check(struct tcp_zerocopy_receive *zc, int *lenp,
+		     char __user *optval, int __user *optlen);
+int zc_receive_update(struct sock *sk, struct tcp_zerocopy_receive *zc, int len,
+		      char __user *optval, struct scm_timestamping_internal *tss,
+		      int err);
 #endif
 void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3b75836db19b..d47e3ccf7cdb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3936,6 +3936,76 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	return stats;
 }
 
+int zc_receive_check(struct tcp_zerocopy_receive *zc, int *lenp,
+		     char __user *optval, int __user *optlen)
+{
+	int len = *lenp, err;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (len < 0 ||
+	    len < offsetofend(struct tcp_zerocopy_receive, length))
+		return -EINVAL;
+	if (unlikely(len > sizeof(*zc))) {
+		err = check_zeroed_user(optval + sizeof(*zc),
+					len - sizeof(*zc));
+		if (err < 1)
+			return err == 0 ? -EINVAL : err;
+		len = sizeof(*zc);
+		if (put_user(len, optlen))
+			return -EFAULT;
+	}
+	if (copy_from_user(zc, optval, len))
+		return -EFAULT;
+
+	if (zc->reserved)
+		return -EINVAL;
+	if (zc->msg_flags & ~(TCP_VALID_ZC_MSG_FLAGS))
+		return -EINVAL;
+
+	*lenp = len;
+	return 0;
+}
+
+int zc_receive_update(struct sock *sk, struct tcp_zerocopy_receive *zc, int len,
+		      char __user *optval, struct scm_timestamping_internal *tss,
+		      int err)
+{
+	sk_defer_free_flush(sk);
+	if (len >= offsetofend(struct tcp_zerocopy_receive, msg_flags))
+		goto zerocopy_rcv_cmsg;
+	switch (len) {
+	case offsetofend(struct tcp_zerocopy_receive, msg_flags):
+		goto zerocopy_rcv_cmsg;
+	case offsetofend(struct tcp_zerocopy_receive, msg_controllen):
+	case offsetofend(struct tcp_zerocopy_receive, msg_control):
+	case offsetofend(struct tcp_zerocopy_receive, flags):
+	case offsetofend(struct tcp_zerocopy_receive, copybuf_len):
+	case offsetofend(struct tcp_zerocopy_receive, copybuf_address):
+	case offsetofend(struct tcp_zerocopy_receive, err):
+		goto zerocopy_rcv_sk_err;
+	case offsetofend(struct tcp_zerocopy_receive, inq):
+		goto zerocopy_rcv_inq;
+	case offsetofend(struct tcp_zerocopy_receive, length):
+	default:
+		goto zerocopy_rcv_out;
+	}
+zerocopy_rcv_cmsg:
+	if (zc->msg_flags & TCP_CMSG_TS)
+		tcp_zc_finalize_rx_tstamp(sk, zc, tss);
+	else
+		zc->msg_flags = 0;
+zerocopy_rcv_sk_err:
+	if (!err)
+		zc->err = sock_error(sk);
+zerocopy_rcv_inq:
+	zc->inq = tcp_inq_hint(sk);
+zerocopy_rcv_out:
+	if (!err && copy_to_user(optval, zc, len))
+		err = -EFAULT;
+	return err;
+}
+
 static int do_tcp_getsockopt(struct sock *sk, int level,
 		int optname, char __user *optval, int __user *optlen)
 {
@@ -4192,64 +4262,16 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		struct tcp_zerocopy_receive zc = {};
 		int err;
 
-		if (get_user(len, optlen))
-			return -EFAULT;
-		if (len < 0 ||
-		    len < offsetofend(struct tcp_zerocopy_receive, length))
-			return -EINVAL;
-		if (unlikely(len > sizeof(zc))) {
-			err = check_zeroed_user(optval + sizeof(zc),
-						len - sizeof(zc));
-			if (err < 1)
-				return err == 0 ? -EINVAL : err;
-			len = sizeof(zc);
-			if (put_user(len, optlen))
-				return -EFAULT;
-		}
-		if (copy_from_user(&zc, optval, len))
-			return -EFAULT;
-		if (zc.reserved)
-			return -EINVAL;
-		if (zc.msg_flags &  ~(TCP_VALID_ZC_MSG_FLAGS))
-			return -EINVAL;
+		err = zc_receive_check(&zc, &len, optval, optlen);
+		if (err)
+			return err;
+
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc, &tss);
 		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
 							  &zc, &len, err);
 		release_sock(sk);
-		sk_defer_free_flush(sk);
-		if (len >= offsetofend(struct tcp_zerocopy_receive, msg_flags))
-			goto zerocopy_rcv_cmsg;
-		switch (len) {
-		case offsetofend(struct tcp_zerocopy_receive, msg_flags):
-			goto zerocopy_rcv_cmsg;
-		case offsetofend(struct tcp_zerocopy_receive, msg_controllen):
-		case offsetofend(struct tcp_zerocopy_receive, msg_control):
-		case offsetofend(struct tcp_zerocopy_receive, flags):
-		case offsetofend(struct tcp_zerocopy_receive, copybuf_len):
-		case offsetofend(struct tcp_zerocopy_receive, copybuf_address):
-		case offsetofend(struct tcp_zerocopy_receive, err):
-			goto zerocopy_rcv_sk_err;
-		case offsetofend(struct tcp_zerocopy_receive, inq):
-			goto zerocopy_rcv_inq;
-		case offsetofend(struct tcp_zerocopy_receive, length):
-		default:
-			goto zerocopy_rcv_out;
-		}
-zerocopy_rcv_cmsg:
-		if (zc.msg_flags & TCP_CMSG_TS)
-			tcp_zc_finalize_rx_tstamp(sk, &zc, &tss);
-		else
-			zc.msg_flags = 0;
-zerocopy_rcv_sk_err:
-		if (!err)
-			zc.err = sock_error(sk);
-zerocopy_rcv_inq:
-		zc.inq = tcp_inq_hint(sk);
-zerocopy_rcv_out:
-		if (!err && copy_to_user(optval, &zc, len))
-			err = -EFAULT;
-		return err;
+		return zc_receive_update(sk, &zc, len, optval, &tss, err);
 	}
 #endif
 	default:
-- 
2.25.1

