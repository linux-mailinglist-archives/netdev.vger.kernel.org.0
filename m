Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961283A40E1
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhFKLMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:12:45 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:14316 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhFKLMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:12:44 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id F047B520CD4;
        Fri, 11 Jun 2021 14:10:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623409844;
        bh=hshi7mdAZndaX/lzoPfG/AFcODjk4xMTNI2P0h3Xzfs=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=J5LnP1MErvAYsqGEfuqNOAZQo3GgpFBVHIl+9TTAse0wc/eRSLJXl+kks8GBA7hFI
         tTXPx4nBf/1ewV4GK38M1loBoWf04fLcVza9/c70jJKA0guST3ZMrjl4tHlyNxXCXh
         Wg0SysbzsybY617+yHbw+r2sV1EFB6okuANGgLKqaQIFD74dzafhdni+jtht6viS+I
         cJgBy9mQ8hqhNUf/EzlNgGFntdSftxfY+c3QbM5PvI9335b83Ev46Ot6Etj6I5gaBr
         epICIk6bylMsSGzAaMYf37VTGbgfZKn4FyqPM1I+Z88W7PqRB71z7pXJV0M7XujIKe
         0W3OGOc/sr7rA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 96E2C520CC8;
        Fri, 11 Jun 2021 14:10:43 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:10:43 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v11 04/18] af_vsock: implement SEQPACKET receive loop
Date:   Fri, 11 Jun 2021 14:10:34 +0300
Message-ID: <20210611111037.3651404-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/11/2021 10:44:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164266 [Jun 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/11/2021 10:48:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.06.2021 5:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/11 09:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/10 21:54:00 #16707142
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add receive loop for SEQPACKET. It looks like receive loop for
STREAM, but there are differences:
1) It doesn't call notify callbacks.
2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
   there is no sense for these values in SEQPACKET case.
3) It waits until whole record is received.
4) It processes and sets 'MSG_TRUNC' flag.

So to avoid extra conditions for two types of socket inside one loop, two
independent functions were created.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v10 -> v11:
 1) 'msg_ready' input argument removed.
 2) On 'vsock_wait_data()' error, error is returned(not 0).
 3) Receive loop removed as user is woken up when it is possible
    to dequeue whole message.

 include/net/af_vsock.h   |  4 +++
 net/vmw_vsock/af_vsock.c | 55 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b1c717286993..4d7cf6b2aca2 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -135,6 +135,10 @@ struct vsock_transport {
 	bool (*stream_is_active)(struct vsock_sock *);
 	bool (*stream_allow)(u32 cid, u32 port);
 
+	/* SEQ_PACKET. */
+	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
+				     int flags);
+
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c4f6bfa1e381..87ae26b2e3e1 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1974,6 +1974,56 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 	return err;
 }
 
+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
+				     size_t len, int flags)
+{
+	const struct vsock_transport *transport;
+	struct vsock_sock *vsk;
+	ssize_t record_len;
+	long timeout;
+	int err = 0;
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+
+	err = vsock_wait_data(sk, &wait, timeout, NULL, 0);
+	if (err <= 0)
+		goto out;
+
+	record_len = transport->seqpacket_dequeue(vsk, msg, flags);
+
+	if (record_len < 0) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	if (sk->sk_err) {
+		err = -sk->sk_err;
+	} else if (sk->sk_shutdown & RCV_SHUTDOWN) {
+		err = 0;
+	} else {
+		/* User sets MSG_TRUNC, so return real length of
+		 * packet.
+		 */
+		if (flags & MSG_TRUNC)
+			err = record_len;
+		else
+			err = len - msg_data_left(msg);
+
+		/* Always set MSG_TRUNC if real length of packet is
+		 * bigger than user's buffer.
+		 */
+		if (record_len > len)
+			msg->msg_flags |= MSG_TRUNC;
+	}
+
+out:
+	return err;
+}
+
 static int
 vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			  int flags)
@@ -2029,7 +2079,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		goto out;
 	}
 
-	err = __vsock_stream_recvmsg(sk, msg, len, flags);
+	if (sk->sk_type == SOCK_STREAM)
+		err = __vsock_stream_recvmsg(sk, msg, len, flags);
+	else
+		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
 
 out:
 	release_sock(sk);
-- 
2.25.1

