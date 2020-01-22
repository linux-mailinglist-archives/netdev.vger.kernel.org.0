Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C189144CA7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAVHxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:53:05 -0500
Received: from nwk-aaemail-lapp03.apple.com ([17.151.62.68]:43860 "EHLO
        nwk-aaemail-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbgAVHxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:53:05 -0500
Received: from pps.filterd (nwk-aaemail-lapp03.apple.com [127.0.0.1])
        by nwk-aaemail-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0urnW013197;
        Tue, 21 Jan 2020 16:57:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=FF49Fb9RtWXZBsApzlxTuyZuf2p3VUaT3kxHzi0eDgE=;
 b=De5+OqOM+5xjiZ0JVE6IwulVnSKr/zcPnGCyxygYACkjPLfI4q44Olwyvt/3LbXPDIrS
 MJHzajdZ+Bql1ywUIIKDzXGXq8uqdA2aQuU5iRTMeqcvHn6dRyySQF9qPyQtiTBDidpB
 0Xxc5tXm9W57xFtATQff9AiTePWt8pULYTY2a0uiIa6Y48WqwKgBggoZG52atW4nGZWy
 ECNRUPvcvypPnQ2l42mttba8nb53Ui98grJqsV1+MGeTC0DG/5uBB81wSgPpElcUmF2i
 WKxICRQEZ8iflwREKw2erQPjxlcmS4CRilEmd3hjVvVEzV4TTX3j2JnW6salQDnVgOSw Tw== 
Received: from ma1-mtap-s01.corp.apple.com (ma1-mtap-s01.corp.apple.com [17.40.76.5])
        by nwk-aaemail-lapp03.apple.com with ESMTP id 2xmk4p1699-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:05 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s01.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00HWQHAUJ720@ma1-mtap-s01.corp.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00F00F5G4K00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: 61e38c1bbc7fdb1247ea00964b0bc440
X-Va-R-CD: 3afddc4f4a9cd05e809fcf9591776af4
X-Va-CD: 0
X-Va-ID: b4a56e74-af19-4d30-9986-16dc7a389bdf
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: 61e38c1bbc7fdb1247ea00964b0bc440
X-V-R-CD: 3afddc4f4a9cd05e809fcf9591776af4
X-V-CD: 0
X-V-ID: 77619e81-b082-4c5f-a6a1-831e82c3bfaf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DSOHB0DC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v3 12/19] mptcp: recvmsg() can drain data from
 multiple subflows
Date:   Tue, 21 Jan 2020 16:56:26 -0800
Message-id: <20200122005633.21229-13-cpaasch@apple.com>
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

From: Paolo Abeni <pabeni@redhat.com>

With the previous patch in place, the msk can detect which subflow
has the current map with a simple walk, let's update the main
loop to always select the 'current' subflow. The exit conditions now
closely mirror tcp_recvmsg() to get expected timeout and signal
behavior.

Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 178 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 168 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 408efbe34753..ad9c73cc20e1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -9,6 +9,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/sched/signal.h>
+#include <linux/atomic.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -105,6 +107,21 @@ static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
 	return !!msk->cached_ext;
 }
 
+static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+
+	sock_owned_by_me(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		if (subflow->data_avail)
+			return mptcp_subflow_tcp_sock(subflow);
+	}
+
+	return NULL;
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct msghdr *msg, long *timeo)
 {
@@ -269,13 +286,37 @@ int mptcp_read_actor(read_descriptor_t *desc, struct sk_buff *skb,
 	return copy_len;
 }
 
+static void mptcp_wait_data(struct sock *sk, long *timeo)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
+	sk_wait_event(sk, timeo,
+		      test_and_clear_bit(MPTCP_DATA_READY, &msk->flags), &wait);
+
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+}
+
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_subflow_context *subflow;
+	bool more_data_avail = false;
+	struct mptcp_read_arg arg;
+	read_descriptor_t desc;
+	bool wait_data = false;
 	struct socket *ssock;
+	struct tcp_sock *tp;
+	bool done = false;
 	struct sock *ssk;
 	int copied = 0;
+	int target;
+	long timeo;
 
 	if (msg->msg_flags & ~(MSG_WAITALL | MSG_DONTWAIT))
 		return -EOPNOTSUPP;
@@ -290,16 +331,124 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return copied;
 	}
 
-	ssk = mptcp_subflow_get(msk);
-	if (!ssk) {
-		release_sock(sk);
-		return -ENOTCONN;
+	arg.msg = msg;
+	desc.arg.data = &arg;
+	desc.error = 0;
+
+	timeo = sock_rcvtimeo(sk, nonblock);
+
+	len = min_t(size_t, len, INT_MAX);
+	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
+
+	while (!done) {
+		u32 map_remaining;
+		int bytes_read;
+
+		ssk = mptcp_subflow_recv_lookup(msk);
+		pr_debug("msk=%p ssk=%p", msk, ssk);
+		if (!ssk)
+			goto wait_for_data;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		tp = tcp_sk(ssk);
+
+		lock_sock(ssk);
+		do {
+			/* try to read as much data as available */
+			map_remaining = subflow->map_data_len -
+					mptcp_subflow_get_map_offset(subflow);
+			desc.count = min_t(size_t, len - copied, map_remaining);
+			pr_debug("reading %zu bytes, copied %d", desc.count,
+				 copied);
+			bytes_read = tcp_read_sock(ssk, &desc,
+						   mptcp_read_actor);
+			if (bytes_read < 0) {
+				if (!copied)
+					copied = bytes_read;
+				done = true;
+				goto next;
+			}
+
+			pr_debug("msk ack_seq=%llx -> %llx", msk->ack_seq,
+				 msk->ack_seq + bytes_read);
+			msk->ack_seq += bytes_read;
+			copied += bytes_read;
+			if (copied >= len) {
+				done = true;
+				goto next;
+			}
+			if (tp->urg_data && tp->urg_seq == tp->copied_seq) {
+				pr_err("Urgent data present, cannot proceed");
+				done = true;
+				goto next;
+			}
+next:
+			more_data_avail = mptcp_subflow_data_available(ssk);
+		} while (more_data_avail && !done);
+		release_sock(ssk);
+		continue;
+
+wait_for_data:
+		more_data_avail = false;
+
+		/* only the master socket status is relevant here. The exit
+		 * conditions mirror closely tcp_recvmsg()
+		 */
+		if (copied >= target)
+			break;
+
+		if (copied) {
+			if (sk->sk_err ||
+			    sk->sk_state == TCP_CLOSE ||
+			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+			    !timeo ||
+			    signal_pending(current))
+				break;
+		} else {
+			if (sk->sk_err) {
+				copied = sock_error(sk);
+				break;
+			}
+
+			if (sk->sk_shutdown & RCV_SHUTDOWN)
+				break;
+
+			if (sk->sk_state == TCP_CLOSE) {
+				copied = -ENOTCONN;
+				break;
+			}
+
+			if (!timeo) {
+				copied = -EAGAIN;
+				break;
+			}
+
+			if (signal_pending(current)) {
+				copied = sock_intr_errno(timeo);
+				break;
+			}
+		}
+
+		pr_debug("block timeout %ld", timeo);
+		wait_data = true;
+		mptcp_wait_data(sk, &timeo);
 	}
 
-	copied = sock_recvmsg(ssk->sk_socket, msg, flags);
+	if (more_data_avail) {
+		if (!test_bit(MPTCP_DATA_READY, &msk->flags))
+			set_bit(MPTCP_DATA_READY, &msk->flags);
+	} else if (!wait_data) {
+		clear_bit(MPTCP_DATA_READY, &msk->flags);
 
-	release_sock(sk);
+		/* .. race-breaker: ssk might get new data after last
+		 * data_available() returns false.
+		 */
+		ssk = mptcp_subflow_recv_lookup(msk);
+		if (unlikely(ssk))
+			set_bit(MPTCP_DATA_READY, &msk->flags);
+	}
 
+	release_sock(sk);
 	return copied;
 }
 
@@ -460,10 +609,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->write_seq = subflow->idsn + 1;
 		ack_seq++;
 		msk->ack_seq = ack_seq;
-		subflow->map_seq = ack_seq;
-		subflow->map_subflow_seq = 1;
-		subflow->rel_write_seq = 1;
-		subflow->tcp_sock = ssk;
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
@@ -475,6 +620,19 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		bh_unlock_sock(new_mptcp_sock);
 		local_bh_enable();
 		release_sock(sk);
+
+		/* the subflow can already receive packet, avoid racing with
+		 * the receive path and process the pending ones
+		 */
+		lock_sock(ssk);
+		subflow->map_seq = ack_seq;
+		subflow->map_subflow_seq = 1;
+		subflow->rel_write_seq = 1;
+		subflow->tcp_sock = ssk;
+		subflow->conn = new_mptcp_sock;
+		if (unlikely(!skb_queue_empty(&ssk->sk_receive_queue)))
+			mptcp_subflow_data_available(ssk);
+		release_sock(ssk);
 	}
 
 	return newsk;
-- 
2.23.0

