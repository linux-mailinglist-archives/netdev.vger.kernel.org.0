Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70243A40FB
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhFKLOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:14:55 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:15238 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhFKLOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:14:48 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id A3F45520CBD;
        Fri, 11 Jun 2021 14:12:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623409968;
        bh=iJM6evmgCgC+zmZGJEjpiU4V7TP2e7xc1Zzb8Twtt88=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=4VRElhQ8xwsOpC3ppa7Q2nkold/JgY13To5B89AQREUYvfJ1bzoXhEcVhXX5HsLLi
         uyjdgh+CaFsHBcTpKXn2dMOTfIVBo4rXpvjH3T37CMhJli0zUSdGckBBZPCe5sIDJR
         qtTfTQICWDSPHW7piS1wJGeJlGpLnuIUxaHOJSRsARKSeM5MGoa5bq2ibF7OUqqA3V
         70TTR9wsJMGkcU7kHtZ2SFlyyaLC2JMMtOFnexyQWcd2agEDkU16r0nz6WheqDewPa
         /YwC+0+VMoJcLPgajUtMPqJW4jlZM8xPRlFtzVV/WVX34rmugC8KguHlJVuFoWHa02
         rPMvnkD089MXg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 54E7E520CA6;
        Fri, 11 Jun 2021 14:12:48 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:12:47 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v11 11/18] virtio/vsock: dequeue callback for SOCK_SEQPACKET
Date:   Fri, 11 Jun 2021 14:12:38 +0300
Message-ID: <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
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

Callback fetches RW packets from rx queue of socket until whole record
is copied(if user's buffer is full, user is not woken up). This is done
to not stall sender, because if we wake up user and it leaves syscall,
nobody will send credit update for rest of record, and sender will wait
for next enter of read syscall at receiver's side. So if user buffer is
full, we just send credit update and drop data.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v10 -> v11:
 1) 'msg_count' field added to count current number of EORs.
 2) 'msg_ready' argument removed from callback.
 3) If 'memcpy_to_msg()' failed during copy loop, there will be
    no next attempts to copy data, rest of record will be freed.

 include/linux/virtio_vsock.h            |  5 ++
 net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index dc636b727179..1d9a302cb91d 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -36,6 +36,7 @@ struct virtio_vsock_sock {
 	u32 rx_bytes;
 	u32 buf_alloc;
 	struct list_head rx_queue;
+	u32 msg_count;
 };
 
 struct virtio_vsock_pkt {
@@ -80,6 +81,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+ssize_t
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags);
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ad0d34d41444..1e1df19ec164 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -393,6 +393,78 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
+						 struct msghdr *msg,
+						 int flags)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	int dequeued_len = 0;
+	size_t user_buf_len = msg_data_left(msg);
+	bool copy_failed = false;
+	bool msg_ready = false;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	if (vvs->msg_count == 0) {
+		spin_unlock_bh(&vvs->rx_lock);
+		return 0;
+	}
+
+	while (!msg_ready) {
+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+
+		if (!copy_failed) {
+			size_t pkt_len;
+			size_t bytes_to_copy;
+
+			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
+			bytes_to_copy = min(user_buf_len, pkt_len);
+
+			if (bytes_to_copy) {
+				int err;
+
+				/* sk_lock is held by caller so no one else can dequeue.
+				 * Unlock rx_lock since memcpy_to_msg() may sleep.
+				 */
+				spin_unlock_bh(&vvs->rx_lock);
+
+				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
+				if (err) {
+					/* Copy of message failed, set flag to skip
+					 * copy path for rest of fragments. Rest of
+					 * fragments will be freed without copy.
+					 */
+					copy_failed = true;
+					dequeued_len = err;
+				} else {
+					user_buf_len -= bytes_to_copy;
+				}
+
+				spin_lock_bh(&vvs->rx_lock);
+			}
+
+			if (dequeued_len >= 0)
+				dequeued_len += pkt_len;
+		}
+
+		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
+			msg_ready = true;
+			vvs->msg_count--;
+		}
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
@@ -405,6 +477,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
 
+ssize_t
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags)
+{
+	if (flags & MSG_PEEK)
+		return -EOPNOTSUPP;
+
+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
-- 
2.25.1

