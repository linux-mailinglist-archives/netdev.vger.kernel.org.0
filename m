Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7BB38B734
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhETTTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:19:42 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:53661 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhETTTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:19:32 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 563DE78578;
        Thu, 20 May 2021 22:18:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538287;
        bh=bWDXjnusAw0GqGde8Fo03zr/rla806XOlO/i15vi3PU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=yP8N7NW6CzTaTE30tPQnUAABTuFzCcUoeQZmFs0z1ju5e1UJMiqY/neoc0g67fm07
         nToSK2M1fotvgM0C87stdZg7K1PBBoSvbNW+fBO+zAfdYB+7wsl9I2PjPn+AXFr24O
         E1YNw8zAqdAJXmel7eskg+EN34nCwyknKZ3xgK/Y5GF4Zs2+KBM3HApddl0XgNzchk
         gCRy5J/VreuK8eHECMfCRcGU5akIKN8HX4jg9N2ndkCihVcAIFglj+JbxLu31yufCK
         XOIa3b0NRwUkebjQXuaNtYpu7DCiJ58U8xxz7KtFf6XI0sKX4W7PFC4yeKIy/5pzTy
         5bU+ldoHMF9Mw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 12C7E7857D;
        Thu, 20 May 2021 22:18:07 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:18:06 +0300
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
Subject: [PATCH v10 11/18] virtio/vsock: dequeue callback for SOCK_SEQPACKET
Date:   Thu, 20 May 2021 22:17:58 +0300
Message-ID: <20210520191801.1272027-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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

Callback fetches RW packets from rx queue of socket until whole record
is copied(if user's buffer is full, user is not woken up). This is done
to not stall sender, because if we wake up user and it leaves syscall,
nobody will send credit update for rest of record, and sender will wait
for next enter of read syscall at receiver's side. So if user buffer is
full, we just send credit update and drop data.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v9 -> v10:
 1) Number of dequeued bytes incremented even in case when
    user's buffer is full.
 2) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
 3) Rename variable 'err' to 'dequeued_len', in case of error
    it has negative value.

 include/linux/virtio_vsock.h            |  5 ++
 net/vmw_vsock/virtio_transport_common.c | 65 +++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index dc636b727179..02acf6e9ae04 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -80,6 +80,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+ssize_t
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags,
+				   bool *msg_ready);
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ad0d34d41444..61349b2ea7fe 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -393,6 +393,59 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
+						 struct msghdr *msg,
+						 int flags,
+						 bool *msg_ready)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	int dequeued_len = 0;
+	size_t user_buf_len = msg_data_left(msg);
+
+	*msg_ready = false;
+	spin_lock_bh(&vvs->rx_lock);
+
+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && dequeued_len >= 0) {
+		size_t bytes_to_copy;
+		size_t pkt_len;
+
+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
+		bytes_to_copy = min(user_buf_len, pkt_len);
+
+		if (bytes_to_copy) {
+			/* sk_lock is held by caller so no one else can dequeue.
+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 */
+			spin_unlock_bh(&vvs->rx_lock);
+
+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy))
+				dequeued_len = -EINVAL;
+			else
+				user_buf_len -= bytes_to_copy;
+
+			spin_lock_bh(&vvs->rx_lock);
+		}
+
+		if (dequeued_len >= 0)
+			dequeued_len += pkt_len;
+
+		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
+			*msg_ready = true;
+
+		virtio_transport_dec_rx_pkt(vvs, pkt);
+		list_del(&pkt->list);
+		virtio_transport_free_pkt(pkt);
+	}
+
+	spin_unlock_bh(&vvs->rx_lock);
+
+	virtio_transport_send_credit_update(vsk);
+
+	return dequeued_len;
+}
+
 ssize_t
 virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 				struct msghdr *msg,
@@ -405,6 +458,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
 
+ssize_t
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags, bool *msg_ready)
+{
+	if (flags & MSG_PEEK)
+		return -EOPNOTSUPP;
+
+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags, msg_ready);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
-- 
2.25.1

