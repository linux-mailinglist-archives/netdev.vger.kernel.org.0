Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EA718B3AF
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 13:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgCSMrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 08:47:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12102 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbgCSMrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 08:47:04 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9810353EC2277E87DC44;
        Thu, 19 Mar 2020 20:46:57 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 19 Mar 2020
 20:46:51 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <lmb@cloudflare.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <john.fastabend@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] bpf: tcp: Fix unused function warnings
Date:   Thu, 19 Mar 2020 20:46:31 +0800
Message-ID: <20200319124631.58432-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
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
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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


