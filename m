Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980A7302524
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 13:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbhAYMol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 07:44:41 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:38325 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbhAYMoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:44:03 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id A9017760E9;
        Mon, 25 Jan 2021 14:14:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611573269;
        bh=wtf1/n4aKELbk5F4Hv99lkJ06H90dKTGwnKtc1Uw5P4=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=aKLG89Edp7p4sdmDZKud8QUjxtjI0QiysphhQoL1au2gMRt9Cw9Kr8XKZTj84gLpu
         zi6WbYKFpISHXtKUuTmLrphqiU3+D0cTnE0TecZ+ZicZyCFBAIKHrbVc5f2DL4h3jQ
         FoA2X69e8mH2S3c+eSoQyqF5yCWZ4SzgpybZbq1c=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 76168760E5;
        Mon, 25 Jan 2021 14:14:29 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 25
 Jan 2021 14:14:28 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v3 08/13] virtio/vsock: fetch length for SEQPACKET record
Date:   Mon, 25 Jan 2021 14:14:19 +0300
Message-ID: <20210125111422.599066-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/25/2021 10:59:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161363 [Jan 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 421 421 33a18ad4049b4a5e5420c907b38d332fafd06b09
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/25/2021 11:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 1/25/2021 10:11:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/25 10:04:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/25 05:31:00 #16022694
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds transport callback which tries to fetch record begin marker
from socket's rx queue. It is called from af_vsock.c before reading data
packets of record.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 33 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 7f0ef5204e33..af8705ea8b95 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -84,6 +84,7 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e66ec39445ff..dcce35d7b462 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -420,6 +420,39 @@ static size_t virtio_transport_drop_until_seq_begin(struct virtio_vsock_sock *vv
 	return bytes_dropped;
 }
 
+size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	size_t bytes_dropped;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	/* Fetch all orphaned 'RW', packets, and
+	 * send credit update.
+	 */
+	bytes_dropped = virtio_transport_drop_until_seq_begin(vvs);
+
+	if (list_empty(&vvs->rx_queue))
+		goto out;
+
+	pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+
+	vvs->user_read_copied = 0;
+	vvs->user_read_seq_len = le32_to_cpu(pkt->hdr.flags);
+	virtio_transport_del_n_free_pkt(pkt);
+out:
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (bytes_dropped)
+		virtio_transport_send_credit_update(vsk,
+						    VIRTIO_VSOCK_TYPE_SEQPACKET,
+						    NULL);
+
+	return vvs->user_read_seq_len;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_get_len);
+
 static ssize_t virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 						     struct msghdr *msg,
 						     size_t user_buf_len)
-- 
2.25.1

