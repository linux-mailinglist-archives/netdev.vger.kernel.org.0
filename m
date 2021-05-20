Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E9038B73C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbhETTUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:20:16 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:29679 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbhETTUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:20:12 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id C0956521428;
        Thu, 20 May 2021 22:18:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538326;
        bh=ynHxPwASThf1EJnj3clRfhUuzSRHxC2klA5K8rmsOPI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=3vvc9LZWgrbqOT+yVMbNAQzbXxWlQSVS19v6ng4KGgMrFM5MfrWaK1YMptR5pB3ds
         hfW6wgsPxKr/T9eq9XCl0nxqfXFSr35CjQaX7MQPUE4glnd2SGiJRuV3ACfZGe5nJS
         AGVjm42kg9iXgeSTML0UenFV8T863HEhY/VExf7xmDqr2Wyev8qwL/oD2AHa1FQ+fC
         WHBb8SJr7/SRr9asUNzTJzsTNPfLbt4aPqViojNVMG91xAhLgsEqgMfLvLgj//0lix
         BhLu+PFI1JqH/eJywk4OogvNYVl5o+k0Bn7KvZn7YvLryq5LNWayFSUtPI6T85/oG1
         m043uql8nc1HA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 700F452144A;
        Thu, 20 May 2021 22:18:46 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:18:45 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 13/18] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Thu, 20 May 2021 22:18:37 +0300
Message-ID: <20210520191840.1272290-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/20/2021 18:58:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163818 [May 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/20/2021 19:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 20.05.2021 14:47:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/20 17:27:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/20 14:47:00 #16622423
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small updates to make SOCK_SEQPACKET work:
1) Send SHUTDOWN on socket close for SEQPACKET type.
2) Set SEQPACKET packet type during send.
3) Set 'VIRTIO_VSOCK_SEQ_EOR' bit in flags for last
   packet of message.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v9 -> v10:
 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
 2) Commit message updated.
 3) Add check for socket type when setting SEQ_EOR bit.

 include/linux/virtio_vsock.h            |  4 ++++
 net/vmw_vsock/virtio_transport_common.c | 18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 02acf6e9ae04..7360ab7ea0af 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -80,6 +80,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len);
 ssize_t
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a6f8b0f39775..f7a3281b3eab 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -74,6 +74,11 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 		err = memcpy_from_msg(pkt->buf, info->msg, len);
 		if (err)
 			goto out;
+
+		if (msg_data_left(info->msg) == 0 &&
+		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
+			pkt->hdr.flags = cpu_to_le32(info->flags |
+						VIRTIO_VSOCK_SEQ_EOR);
 	}
 
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
@@ -187,7 +192,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
-	info->type = VIRTIO_VSOCK_TYPE_STREAM;
+	info->type = virtio_transport_get_type(sk_vsock(vsk));
 
 	t_ops = virtio_transport_get_ops(vsk);
 	if (unlikely(!t_ops))
@@ -478,6 +483,15 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len)
+{
+	return virtio_transport_stream_enqueue(vsk, msg, len);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
@@ -912,7 +926,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
 		remove_sock = virtio_transport_close(vsk);
 
 	if (remove_sock) {
-- 
2.25.1

