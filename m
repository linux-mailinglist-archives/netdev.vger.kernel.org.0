Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EDF3A4100
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhFKLP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:15:27 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:36996 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhFKLPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:15:18 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 319CB76514;
        Fri, 11 Jun 2021 14:13:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623409997;
        bh=0awcMGHqUiZXFlmjJ88I337F8zpSrIzZ1HlWq1Y0DY0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=plFxFiTJpeQBG+rtKRrSAD179z0LESUKD4VzeWeXmLIGIUjE3KUPeBtJUTlKcGQbV
         vh898ik5TvEmJxcYK7JPb+slVC1hr9WSprDgNIvx9Sfec5oYVksAtvzPinaXBBLkrk
         lAYJ9DpXkclefLd9vVZetX80jm5JTZSI6O+eCAxcWXyfHXX7L5l6p0Nu8+/N320UTg
         pJToKg+YlHA0DJ/FqvSDZjc6dYu2MQtW0G2QQaCZkIVNr14YrhM4XIWa9eg/pgvsGZ
         OSTsMEZku9CFv/qNi6Zot2B1JvO+kkwfUUcteBz7nDTagareoaOcJNA3WFvuzlE5cf
         m3RHqBAbXQ44g==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id BF5B4762CD;
        Fri, 11 Jun 2021 14:13:16 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:13:16 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v11 13/18] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Fri, 11 Jun 2021 14:13:06 +0300
Message-ID: <20210611111309.3652500-1-arseny.krasnov@kaspersky.com>
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

Small updates to make SOCK_SEQPACKET work:
1) Send SHUTDOWN on socket close for SEQPACKET type.
2) Set SEQPACKET packet type during send.
3) Set 'VIRTIO_VSOCK_SEQ_EOR' bit in flags for last
   packet of message.
4) Implement data check function for SEQPACKET.
5) Check for max datagram size.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v10 -> v11:
 1) 'flags' set way was changed, now '|=' used.
 2) Check for max datagram length added, EMSGSIZE
    returned.
 3) 'virtio_transport_seqpacket_has_data()' function added.

 include/linux/virtio_vsock.h            |  5 +++
 net/vmw_vsock/virtio_transport_common.c | 41 +++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 1d9a302cb91d..35d7eedb5e8e 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -81,12 +81,17 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len);
 ssize_t
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
 				   int flags);
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
+u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
 
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 				 struct vsock_sock *psk);
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 3a658ff8fccb..23704a6bc437 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -74,6 +74,10 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 		err = memcpy_from_msg(pkt->buf, info->msg, len);
 		if (err)
 			goto out;
+
+		if (msg_data_left(info->msg) == 0 &&
+		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
+			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
 	}
 
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
@@ -187,7 +191,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
-	info->type = VIRTIO_VSOCK_TYPE_STREAM;
+	info->type = virtio_transport_get_type(sk_vsock(vsk));
 
 	t_ops = virtio_transport_get_ops(vsk);
 	if (unlikely(!t_ops))
@@ -497,6 +501,26 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+
+	spin_lock_bh(&vvs->tx_lock);
+
+	if (len > vvs->peer_buf_alloc) {
+		spin_unlock_bh(&vvs->tx_lock);
+		return -EMSGSIZE;
+	}
+
+	spin_unlock_bh(&vvs->tx_lock);
+
+	return virtio_transport_stream_enqueue(vsk, msg, len);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
@@ -519,6 +543,19 @@ s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_has_data);
 
+u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	u32 msg_count;
+
+	spin_lock_bh(&vvs->rx_lock);
+	msg_count = vvs->msg_count;
+	spin_unlock_bh(&vvs->rx_lock);
+
+	return msg_count;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_has_data);
+
 static s64 virtio_transport_has_space(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
@@ -931,7 +968,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
 		remove_sock = virtio_transport_close(vsk);
 
 	if (remove_sock) {
-- 
2.25.1

