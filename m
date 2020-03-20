Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C6F18C562
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCTCir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:38:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40522 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbgCTCiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 22:38:46 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0B8B4BE8674E10677D2D;
        Fri, 20 Mar 2020 10:38:39 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 10:38:28 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <lmb@cloudflare.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <john.fastabend@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrii.nakryiko@gmail.com>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next 1/2] bpf: tcp: Fix unused function warnings
Date:   Fri, 20 Mar 2020 10:34:25 +0800
Message-ID: <20200320023426.60684-2-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200320023426.60684-1-yuehaibing@huawei.com>
References: <20200319124631.58432-1-yuehaibing@huawei.com>
 <20200320023426.60684-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If BPF_STREAM_PARSER is not set, gcc warns:

net/ipv4/tcp_bpf.c:483:12: warning: 'tcp_bpf_sendpage' defined but not used [-Wunused-function]
net/ipv4/tcp_bpf.c:395:12: warning: 'tcp_bpf_sendmsg' defined but not used [-Wunused-function]
net/ipv4/tcp_bpf.c:13:13: warning: 'tcp_bpf_stream_read' defined but not used [-Wunused-function]

Moves the unused functions into the #ifdef

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: f747632b608f ("bpf: sockmap: Move generic sockmap hooks from BPF TCP")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/tcp_bpf.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index fe7b4fbc31c1..37c91f25cae3 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -10,19 +10,6 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
-static bool tcp_bpf_stream_read(const struct sock *sk)
-{
-	struct sk_psock *psock;
-	bool empty = true;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (likely(psock))
-		empty = list_empty(&psock->ingress_msg);
-	rcu_read_unlock();
-	return !empty;
-}
-
 static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 			     int flags, long timeo, int *err)
 {
@@ -298,6 +285,20 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 }
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
+#ifdef CONFIG_BPF_STREAM_PARSER
+static bool tcp_bpf_stream_read(const struct sock *sk)
+{
+	struct sk_psock *psock;
+	bool empty = true;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (likely(psock))
+		empty = list_empty(&psock->ingress_msg);
+	rcu_read_unlock();
+	return !empty;
+}
+
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
@@ -528,7 +529,6 @@ static int tcp_bpf_sendpage(struct sock *sk, struct page *page, int offset,
 	return copied ? copied : err;
 }
 
-#ifdef CONFIG_BPF_STREAM_PARSER
 enum {
 	TCP_BPF_IPV4,
 	TCP_BPF_IPV6,
-- 
2.17.1


