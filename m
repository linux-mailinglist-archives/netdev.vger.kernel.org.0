Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BFE144A79
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 04:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAVDdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 22:33:36 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:49418 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbgAVDdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 22:33:36 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0v2eG020009;
        Tue, 21 Jan 2020 16:57:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=Ws5pFalh4RDRIZS1tAT+Y9wtH/sKvA/98SzqjVBUANY=;
 b=UGOJ91q+P3dOAiX7zQhb+Yacy5S3/Phxr1QL6v73Sh0J3+SiUYfx+BEHbHLNAWvBHdro
 3pv2bYga1Yecw7cH8LQEcWLo4U784oBnKemE/OiTagafY6CArpqmXLm4+nWHhNkPr9Ue
 LBmkcemZgjieCvfHwrY+oBsPwwjDfC8U2nF6XtsBgXCFS03oFdfgfVeNKzBPYRyhwwsf
 Rt3+NIIfGP+w9fsEh5rCaj8IY7DtooDp4+l1FK6miFxW9iW8FGOdNSzelvU6dbAU8erG
 XIrWCOmBcafmKPAldsCy+6G7txS6YEpAJvAaG3u8QkKKQn5QjWkVexeEf2c3jVYp2F/h gg== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2xkyfq8e4a-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:03 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00064HAZD600@ma1-mtap-s03.corp.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00100GR2PR00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: 989caa25d36f1c7cbaae9b0a0f791d86
X-Va-R-CD: 4cff8adf6547868a0bf984429a97c194
X-Va-CD: 0
X-Va-ID: 304c95f1-bb8b-4755-be17-59e10820accf
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: 989caa25d36f1c7cbaae9b0a0f791d86
X-V-R-CD: 4cff8adf6547868a0bf984429a97c194
X-V-CD: 0
X-V-ID: fc5c6434-f1c7-4461-9bac-a61689a8ef7f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H0011ZHB04Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v3 07/19] mptcp: Add shutdown() socket operation
Date:   Tue, 21 Jan 2020 16:56:21 -0800
Message-id: <20200122005633.21229-8-cpaasch@apple.com>
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

From: Peter Krystad <peter.krystad@linux.intel.com>

Call shutdown on all subflows in use on the given socket, or on the
fallback socket.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3f66b6a3bb28..249b2506a66a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -196,6 +196,29 @@ static int mptcp_init_sock(struct sock *sk)
 	return 0;
 }
 
+static void mptcp_subflow_shutdown(struct sock *ssk, int how)
+{
+	lock_sock(ssk);
+
+	switch (ssk->sk_state) {
+	case TCP_LISTEN:
+		if (!(how & RCV_SHUTDOWN))
+			break;
+		/* fall through */
+	case TCP_SYN_SENT:
+		tcp_disconnect(ssk, O_NONBLOCK);
+		break;
+	default:
+		ssk->sk_shutdown |= how;
+		tcp_shutdown(ssk, how);
+		break;
+	}
+
+	/* Wake up anyone sleeping in poll. */
+	ssk->sk_state_change(ssk);
+	release_sock(ssk);
+}
+
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
@@ -273,6 +296,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			*err = -ENOBUFS;
 			local_bh_enable();
 			release_sock(sk);
+			mptcp_subflow_shutdown(newsk, SHUT_RDWR + 1);
 			tcp_close(newsk, 0);
 			return NULL;
 		}
@@ -544,6 +568,46 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static int mptcp_shutdown(struct socket *sock, int how)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct mptcp_subflow_context *subflow;
+	int ret = 0;
+
+	pr_debug("sk=%p, how=%d", msk, how);
+
+	lock_sock(sock->sk);
+
+	if (how == SHUT_WR || how == SHUT_RDWR)
+		inet_sk_state_store(sock->sk, TCP_FIN_WAIT1);
+
+	how++;
+
+	if ((how & ~SHUTDOWN_MASK) || !how) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (sock->state == SS_CONNECTING) {
+		if ((1 << sock->sk->sk_state) &
+		    (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_CLOSE))
+			sock->state = SS_DISCONNECTING;
+		else
+			sock->state = SS_CONNECTED;
+	}
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+
+		mptcp_subflow_shutdown(tcp_sk, how);
+	}
+
+out_unlock:
+	release_sock(sock->sk);
+
+	return ret;
+}
+
 static struct proto_ops mptcp_stream_ops;
 
 static struct inet_protosw mptcp_protosw = {
@@ -564,6 +628,7 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.accept = mptcp_stream_accept;
 	mptcp_stream_ops.getname = mptcp_v4_getname;
 	mptcp_stream_ops.listen = mptcp_listen;
+	mptcp_stream_ops.shutdown = mptcp_shutdown;
 
 	mptcp_subflow_init();
 
@@ -613,6 +678,7 @@ int mptcpv6_init(void)
 	mptcp_v6_stream_ops.accept = mptcp_stream_accept;
 	mptcp_v6_stream_ops.getname = mptcp_v6_getname;
 	mptcp_v6_stream_ops.listen = mptcp_listen;
+	mptcp_v6_stream_ops.shutdown = mptcp_shutdown;
 
 	err = inet6_register_protosw(&mptcp_v6_protosw);
 	if (err)
-- 
2.23.0

