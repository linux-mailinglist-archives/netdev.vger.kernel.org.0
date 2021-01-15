Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9DF2F727B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732203AbhAOFoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:44:46 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:61882 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbhAOFoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:44:44 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 3BD56760B9;
        Fri, 15 Jan 2021 08:44:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610689440;
        bh=IELbGz8B2ptUBq2V/0RqwOMwBhdGllE386IQ2FPPdrU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=QskCExrIVxQLLK0ITZFhAChtEtpM4O/RmslLlWYEX0Rf0ikMvobPYZMGZW1bQsdZc
         dzl4sp3lM97AqsRbZxoioa/r+kdnf2w9M3DRipjtueOG3ZyeaNgxik9gFza2tKpE72
         fiUNrkgn75kJrMlGNS1N8mJL1hZ4Wk/ZyIgW126s=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id EFE397616C;
        Fri, 15 Jan 2021 08:43:59 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 15
 Jan 2021 08:43:59 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 09/13] virtio/vsock: implement fetch of record length
Date:   Fri, 15 Jan 2021 08:43:49 +0300
Message-ID: <20210115054352.1456795-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/15/2021 05:18:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161159 [Jan 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 420 420 0b339e70b2b1bb108f53ec9b40aa316bba18ceea
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/15/2021 05:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.01.2021 2:12:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/15 05:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/15 02:12:00 #16041563
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds transport callback which tries to fetch record begin marker from
socket's rx queue. It is called from af_vsock.c before reading data
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
index 4328f653a477..fe1272e74517 100644
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

