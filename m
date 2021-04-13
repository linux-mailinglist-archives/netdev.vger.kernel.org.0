Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5A835DF41
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345797AbhDMMpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:45:40 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:57473 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245671AbhDMMpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:45:10 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 4825375EF3;
        Tue, 13 Apr 2021 15:44:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618317888;
        bh=RoyjsQW08fIil+KEIdc80TbymhraMjsxC8+vWzKyWjo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=DEWbSpsd2fALH2/kq48+byEzlwnN9s4uvGDEsQxn8qXl4m3oNwbq59FQytOA9iTvd
         TkC+B/bjXseo1dhTaC/+YpYWoo8+VS1SJAHTCQIn53d5fmATq4YVj/imQKmtm4mygU
         ygsW5b5xkwDSpN0vTzsopMWiIbfGx2k49rwjFrlB3SuzPuPPYYkbhkHbJBin11tav7
         kEIsKFUmIaUW3SIkEI3jaOA+iER5DD4y5yeNrzRINz+oRInPd4E0Xtu+DTn3apLnVB
         nXicmT+FwTz2pooAnMse9035DncqJriJcecgv3ADBoxG3BNMxdQg1Q7b6z8Zrp+ToH
         8JHkZ+Ego9wdQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 0FDC375EE4;
        Tue, 13 Apr 2021 15:44:48 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:44:47 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v8 11/19] virtio/vsock: dequeue callback for SOCK_SEQPACKET
Date:   Tue, 13 Apr 2021 15:44:40 +0300
Message-ID: <20210413124443.3403382-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/13/2021 12:26:17
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163057 [Apr 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/13/2021 12:28:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.04.2021 10:53:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/13 07:05:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/13 03:14:00 #16587160
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds transport callback and it's logic for SEQPACKET dequeue.
Callback fetches RW packets from rx queue of socket until whole record
is copied(if user's buffer is full, user is not woken up). This is done
to not stall sender, because if we wake up user and it leaves syscall,
nobody will send credit update for rest of record, and sender will wait
for next enter of read syscall at receiver's side. So if user buffer is
full, we just send credit update and drop data.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
v7 -> v8:
 - Things like SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id' now removed.
   This callback fetches and copies RW packets to user's buffer, until
   last packet of message found(this packet is marked in 'flags' field
   of header).

 include/linux/virtio_vsock.h            |  5 ++
 net/vmw_vsock/virtio_transport_common.c | 73 +++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

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
index 833104b71a1c..8492b8bd5df5 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -393,6 +393,67 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
+						 struct msghdr *msg,
+						 int flags,
+						 bool *msg_ready)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	int err = 0;
+	size_t user_buf_len = msg->msg_iter.count;
+
+	*msg_ready = false;
+	spin_lock_bh(&vvs->rx_lock);
+
+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && err >= 0) {
+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+
+		if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RW) {
+			size_t bytes_to_copy;
+			size_t pkt_len;
+
+			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
+			bytes_to_copy = min(user_buf_len, pkt_len);
+
+			/* sk_lock is held by caller so no one else can dequeue.
+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 */
+			spin_unlock_bh(&vvs->rx_lock);
+
+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) {
+				err = -EINVAL;
+				break;
+			}
+
+			spin_lock_bh(&vvs->rx_lock);
+
+			/* If user sets 'MSG_TRUNC' we return real length
+			 * of message.
+			 */
+			if (flags & MSG_TRUNC)
+				err += pkt_len;
+			else
+				err += bytes_to_copy;
+
+			user_buf_len -= bytes_to_copy;
+
+			if (pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)
+				*msg_ready = true;
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
+	return err;
+}
+
 ssize_t
 virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 				struct msghdr *msg,
@@ -405,6 +466,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
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

