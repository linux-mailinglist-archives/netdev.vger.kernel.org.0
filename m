Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E4C35DF4B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbhDMMrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:47:03 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:57848 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344341AbhDMMqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:46:04 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 9CF4F75F59;
        Tue, 13 Apr 2021 15:45:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618317938;
        bh=HXjck+kTeYVnQSfuYTKg11i6dIEsjUlmR/oFTm7ERXw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Q1LLCVhb2NKMW5Wv2RR+xU6E17sRL9JV/Z9dWX6zNWojEZcpLJS+QruKTj8OJeGgb
         jBzTxreFbF4L/jkjv7YxYjsWgg/CvOnlVt29nkjbg6yH23yfvwBTRN6IYEgSztG88U
         c7UgZ7nPt3N2FLvseogz6KTs83R8YyZJtDXFDy5aYa6MdGnzdAEWoIf5Vlyvuc6q7/
         Gc0ScPckgSOxUhAGgqpjs7aoC7vzVZXLwcpVX7y4iSpOJZDGfw4qnYZpLKZt6naGcd
         nHFyPr7xKDYS1/dn+d4/3lsKYU92gB0dR74dsxAy9d3yo3ykOCg+etSiLuoujZ6Ux+
         G7YBQvKgq5oXw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 6BC7F75F24;
        Tue, 13 Apr 2021 15:45:38 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:45:37 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v8 13/19] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Tue, 13 Apr 2021 15:45:25 +0300
Message-ID: <20210413124528.3404287-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/13/2021 12:36:22
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163057 [Apr 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/13/2021 12:38:00
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

This adds rest of logic for SEQPACKET:
1) Send SHUTDOWN on socket close for SEQPACKET type.
2) Set SEQPACKET packet type during send.
3) 'seqpacket_allow' flag to virtio transport.
4) Set 'VIRTIO_VSOCK_SEQ_EOR' bit in flags for last
   packet of message.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
v7 -> v8:
 - MSG_EOR handling is removed, i didn't found exact description about
   how it works in POSIX.
 - SEQ_BEGIN, SEQ_END, etc. now removed.

 include/linux/virtio_vsock.h            |  6 ++++++
 net/vmw_vsock/virtio_transport_common.c | 16 ++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 02acf6e9ae04..f00a01bfdd7e 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -68,6 +68,8 @@ struct virtio_transport {
 
 	/* Takes ownership of the packet */
 	int (*send_pkt)(struct virtio_vsock_pkt *pkt);
+
+	bool seqpacket_allow;
 };
 
 ssize_t
@@ -80,6 +82,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
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
index 572869fef832..4c5b63601308 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -74,6 +74,9 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 		err = memcpy_from_msg(pkt->buf, info->msg, len);
 		if (err)
 			goto out;
+
+		if (info->msg->msg_iter.count == 0)
+			pkt->hdr.flags |= VIRTIO_VSOCK_SEQ_EOR;
 	}
 
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
@@ -187,7 +190,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
-	info->type = VIRTIO_VSOCK_TYPE_STREAM;
+	info->type = virtio_transport_get_type(sk_vsock(vsk));
 
 	t_ops = virtio_transport_get_ops(vsk);
 	if (unlikely(!t_ops))
@@ -486,6 +489,15 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
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
@@ -905,7 +917,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
 		remove_sock = virtio_transport_close(vsk);
 
 	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
-- 
2.25.1

