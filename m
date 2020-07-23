Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8265A22A7EF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgGWGL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgGWGJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED8CC0619E3;
        Wed, 22 Jul 2020 23:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=FYcs44yoYK35f4AWKo/oBKg4WT6Lxy2mEQ4X9UWOEVM=; b=sGtRnqYdkZcPfYZRzM5+T6BC7g
        mhzEiZfizA260w/TsQecExreOl8sSzsN1E3mIXeoxHZU36ivBxA2nf5wopiR6Xmx/cQvYW2P/ynSC
        Xe1nrgJEf8JieAdBjc+O1SmiuDErWv514IwyHESk6utAUAijDnTteN+yeaXikk8ne4xYjJ8zHfG6u
        opDvToneN0P5tYC+PE7YvJfTgEyM3HlKL9UuVCORhwsrhnbMPetCBFN6bdXX0rq5XUUW7YFejw1P+
        xHdieh/2tilcdHvGOXeaSMCYhuDDkM89QNbs529lpilLHSQLeMBqu6mV+cHiTQTFRT5zNKUXz2iEt
        SkT72xJg==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUQ3-0003ll-36; Thu, 23 Jul 2020 06:09:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 13/26] bpfilter: switch bpfilter_ip_set_sockopt to sockptr_t
Date:   Thu, 23 Jul 2020 08:08:55 +0200
Message-Id: <20200723060908.50081-14-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is mostly to prepare for cleaning up the callers, as bpfilter by
design can't handle kernel pointers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bpfilter.h     | 6 +++---
 net/bpfilter/bpfilter_kern.c | 6 +++---
 net/ipv4/bpfilter/sockopt.c  | 8 ++++----
 net/ipv4/ip_sockglue.c       | 3 ++-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpfilter.h b/include/linux/bpfilter.h
index 9b114c718a7617..2ae3c8e1d83c43 100644
--- a/include/linux/bpfilter.h
+++ b/include/linux/bpfilter.h
@@ -4,9 +4,10 @@
 
 #include <uapi/linux/bpfilter.h>
 #include <linux/usermode_driver.h>
+#include <linux/sockptr.h>
 
 struct sock;
-int bpfilter_ip_set_sockopt(struct sock *sk, int optname, char __user *optval,
+int bpfilter_ip_set_sockopt(struct sock *sk, int optname, sockptr_t optval,
 			    unsigned int optlen);
 int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
 			    int __user *optlen);
@@ -16,8 +17,7 @@ struct bpfilter_umh_ops {
 	struct umd_info info;
 	/* since ip_getsockopt() can run in parallel, serialize access to umh */
 	struct mutex lock;
-	int (*sockopt)(struct sock *sk, int optname,
-		       char __user *optval,
+	int (*sockopt)(struct sock *sk, int optname, sockptr_t optval,
 		       unsigned int optlen, bool is_set);
 	int (*start)(void);
 };
diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 00540457e5f4d3..f580c3344cb3ac 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -60,17 +60,17 @@ static int bpfilter_send_req(struct mbox_request *req)
 }
 
 static int bpfilter_process_sockopt(struct sock *sk, int optname,
-				    char __user *optval, unsigned int optlen,
+				    sockptr_t optval, unsigned int optlen,
 				    bool is_set)
 {
 	struct mbox_request req = {
 		.is_set		= is_set,
 		.pid		= current->pid,
 		.cmd		= optname,
-		.addr		= (uintptr_t)optval,
+		.addr		= (uintptr_t)optval.user,
 		.len		= optlen,
 	};
-	if (uaccess_kernel()) {
+	if (uaccess_kernel() || sockptr_is_kernel(optval)) {
 		pr_err("kernel access not supported\n");
 		return -EFAULT;
 	}
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 9063c6767d3410..1b34cb9a7708ec 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -21,8 +21,7 @@ void bpfilter_umh_cleanup(struct umd_info *info)
 }
 EXPORT_SYMBOL_GPL(bpfilter_umh_cleanup);
 
-static int bpfilter_mbox_request(struct sock *sk, int optname,
-				 char __user *optval,
+static int bpfilter_mbox_request(struct sock *sk, int optname, sockptr_t optval,
 				 unsigned int optlen, bool is_set)
 {
 	int err;
@@ -52,7 +51,7 @@ static int bpfilter_mbox_request(struct sock *sk, int optname,
 	return err;
 }
 
-int bpfilter_ip_set_sockopt(struct sock *sk, int optname, char __user *optval,
+int bpfilter_ip_set_sockopt(struct sock *sk, int optname, sockptr_t optval,
 			    unsigned int optlen)
 {
 	return bpfilter_mbox_request(sk, optname, optval, optlen, true);
@@ -66,7 +65,8 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	return bpfilter_mbox_request(sk, optname, optval, len, false);
+	return bpfilter_mbox_request(sk, optname, USER_SOCKPTR(optval), len,
+				     false);
 }
 
 static int __init bpfilter_sockopt_init(void)
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 42befbf12846c0..36f746e01741f6 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1414,7 +1414,8 @@ int ip_setsockopt(struct sock *sk, int level,
 #if IS_ENABLED(CONFIG_BPFILTER_UMH)
 	if (optname >= BPFILTER_IPT_SO_SET_REPLACE &&
 	    optname < BPFILTER_IPT_SET_MAX)
-		err = bpfilter_ip_set_sockopt(sk, optname, optval, optlen);
+		err = bpfilter_ip_set_sockopt(sk, optname, USER_SOCKPTR(optval),
+					      optlen);
 #endif
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
-- 
2.27.0

