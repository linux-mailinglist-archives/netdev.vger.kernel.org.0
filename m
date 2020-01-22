Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EEE1449D6
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgAVCd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:33:58 -0500
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:57456 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbgAVCd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:33:57 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0uwKK005654;
        Tue, 21 Jan 2020 16:57:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=9DpUkEE1hQqMvpowGbm9a1ANRZcsZC2me7f7WEkKvHA=;
 b=a/QvTUbtr874c+U53ccyvGTiqCWy+aCxlrkt/+WHGafVAVL5oIQA7gaq7VgOwX/1EIgW
 6QZHt9MVPERQmRwnfWk4yojFgSRJ0RDbTS/vlLLWPCSW/p/vEf15i72BdRR/GsyQluBZ
 WN/WeS/LKWmTK1eElxtbUgFbYmK+2iu/DHwM5SQ/shROGuM6dguFGrZoNptjkExF8Y6D
 2bM+Gi1J3YKOpxVs+C491Jv/f8WzIqbQkfqF5fJmSWnMoL18kIZQAnI8KA6aGVprCXf4
 0mHoZXDzh4gs+Dt1rjAh7QmzP+qKC5gRHhJ7GPYQnSogGjaNiVWxhMvruQdxvXPtEfzv Jw== 
Received: from ma1-mtap-s02.corp.apple.com (ma1-mtap-s02.corp.apple.com [17.40.76.6])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 2xm1w0q03h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:09 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s02.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H0018HHB4F030@ma1-mtap-s02.corp.apple.com>; Tue,
 21 Jan 2020 16:57:04 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00500GU2WL00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:04 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: a2fb2f7069aca739eb7b193888fb8781
X-Va-R-CD: 28d5f2ab3b4ba4452e361aa80a15662e
X-Va-CD: 0
X-Va-ID: 2b96e8d1-09a9-4ba9-8f74-78dcfe1b64df
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: a2fb2f7069aca739eb7b193888fb8781
X-V-R-CD: 28d5f2ab3b4ba4452e361aa80a15662e
X-V-CD: 0
X-V-ID: 98c092a9-5d96-42b8-a0d7-346ad2619ca9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00127HB04Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>
Subject: [PATCH net-next v3 11/19] mptcp: add subflow write space signalling
 and mptcp_poll
Date:   Tue, 21 Jan 2020 16:56:25 -0800
Message-id: <20200122005633.21229-12-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add new SEND_SPACE flag to indicate that a subflow has enough space to
accept more data for transmission.

It gets cleared at the end of mptcp_sendmsg() in case ssk has run
below the free watermark.

It is (re-set) from the wspace callback.

This allows us to use msk->flags to determine the poll mask.

Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 53 ++++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 71250149180b..408efbe34753 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -176,6 +176,23 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	return ret;
 }
 
+static void ssk_check_wmem(struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct socket *sock;
+
+	if (likely(sk_stream_is_writeable(ssk)))
+		return;
+
+	sock = READ_ONCE(ssk->sk_socket);
+
+	if (sock) {
+		clear_bit(MPTCP_SEND_SPACE, &msk->flags);
+		smp_mb__after_atomic();
+		/* set NOSPACE only after clearing SEND_SPACE flag */
+		set_bit(SOCK_NOSPACE, &sock->flags);
+	}
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -219,6 +236,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (copied > 0)
 		ret = copied;
 
+	ssk_check_wmem(msk, ssk);
 	release_sock(ssk);
 	release_sock(sk);
 	return ret;
@@ -315,6 +333,7 @@ static int mptcp_init_sock(struct sock *sk)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	INIT_LIST_HEAD(&msk->conn_list);
+	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 
 	return 0;
 }
@@ -576,6 +595,13 @@ static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
+static bool mptcp_memory_free(const struct sock *sk, int wake)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	return wake ? test_bit(MPTCP_SEND_SPACE, &msk->flags) : true;
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
@@ -591,6 +617,7 @@ static struct proto mptcp_prot = {
 	.hash		= inet_hash,
 	.unhash		= inet_unhash,
 	.get_port	= mptcp_get_port,
+	.stream_memory_free	= mptcp_memory_free,
 	.obj_size	= sizeof(struct mptcp_sock),
 	.no_autobind	= true,
 };
@@ -767,8 +794,34 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
+	const struct mptcp_sock *msk;
+	struct sock *sk = sock->sk;
+	struct socket *ssock;
 	__poll_t mask = 0;
 
+	msk = mptcp_sk(sk);
+	lock_sock(sk);
+	ssock = __mptcp_nmpc_socket(msk);
+	if (ssock) {
+		mask = ssock->ops->poll(file, ssock, wait);
+		release_sock(sk);
+		return mask;
+	}
+
+	release_sock(sk);
+	sock_poll_wait(file, sock, wait);
+	lock_sock(sk);
+
+	if (test_bit(MPTCP_DATA_READY, &msk->flags))
+		mask = EPOLLIN | EPOLLRDNORM;
+	if (sk_stream_is_writeable(sk) &&
+	    test_bit(MPTCP_SEND_SPACE, &msk->flags))
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+
+	release_sock(sk);
+
 	return mask;
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c6d8217e24d4..59a83eb64d37 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -56,6 +56,7 @@
 
 /* MPTCP socket flags */
 #define MPTCP_DATA_READY	BIT(0)
+#define MPTCP_SEND_SPACE	BIT(1)
 
 /* MPTCP connection sock */
 struct mptcp_sock {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 528351e26371..9fb3eb87a20f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -529,6 +529,9 @@ static void subflow_write_space(struct sock *sk)
 
 	sk_stream_write_space(sk);
 	if (parent && sk_stream_is_writeable(sk)) {
+		set_bit(MPTCP_SEND_SPACE, &mptcp_sk(parent)->flags);
+		smp_mb__after_atomic();
+		/* set SEND_SPACE before sk_stream_write_space clears NOSPACE */
 		sk_stream_write_space(parent);
 	}
 }
-- 
2.23.0

