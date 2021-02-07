Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D759312537
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhBGPYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:24:04 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:14036 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhBGPUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:20:44 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id BBAB0759B2;
        Sun,  7 Feb 2021 18:19:11 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612711151;
        bh=YA2kZ0rtd9LWy9mwBKezwHuJUnNbYwBs39DL982InAM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=e/LbW+g4EQJSjAKh5yNiznR2y6u17dLrpfxEMjIuffYV7AVgbmdZ7MHwEDnpR/UjP
         AyW8a72axjfkw58c7SKQk4IfVfara4plpLEYQRum+UnQk4T2u3jeSmnVnjeaHjG/lQ
         uXOD2dIVoPKUuWA45lwGwnqJaoF79V/kworWnUAs=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 7C2327593C;
        Sun,  7 Feb 2021 18:19:11 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:19:10 +0300
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
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v4 17/17] virtio/vsock: simplify credit update function API
Date:   Sun, 7 Feb 2021 18:19:03 +0300
Message-ID: <20210207151906.806343-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/06/2021 23:52:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161679 [Feb 06 2021]
X-KSE-AntiSpam-Info: LuaCore: 422 422 763e61bea9fcfcd94e075081cb96e065bc0509b4
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2021 23:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 2/6/2021 9:17:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/07 14:21:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/07 10:49:00 #16133380
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'virtio_transport_send_credit_update()' has some extra args:
1) 'type' may be set in 'virtio_transport_send_pkt_info()' using type
   of socket.
2) This function is static and 'hdr' arg was always NULL.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/virtio_transport_common.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 0aa0fd33e9d6..46308679c8a4 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -286,13 +286,10 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_put_credit);
 
-static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
-					       int type,
-					       struct virtio_vsock_hdr *hdr)
+static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
-		.type = type,
 		.vsk = vsk,
 	};
 
@@ -401,9 +398,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	 * with different values.
 	 */
 	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
-		virtio_transport_send_credit_update(vsk,
-						    VIRTIO_VSOCK_TYPE_STREAM,
-						    NULL);
+		virtio_transport_send_credit_update(vsk);
 	}
 
 	return total;
@@ -525,9 +520,7 @@ size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
 	spin_unlock_bh(&vvs->rx_lock);
 
 	if (bytes_dropped)
-		virtio_transport_send_credit_update(vsk,
-						    VIRTIO_VSOCK_TYPE_SEQPACKET,
-						    NULL);
+		virtio_transport_send_credit_update(vsk);
 
 	return vvs->user_read_seq_len;
 }
@@ -624,8 +617,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 
 	spin_unlock_bh(&vvs->rx_lock);
 
-	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_SEQPACKET,
-					    NULL);
+	virtio_transport_send_credit_update(vsk);
 
 	return err;
 }
@@ -735,15 +727,13 @@ EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
 void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	int type;
 
 	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
 		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
 
 	vvs->buf_alloc = *val;
 
-	type = virtio_transport_get_type(sk_vsock(vsk));
-	virtio_transport_send_credit_update(vsk, type, NULL);
+	virtio_transport_send_credit_update(vsk);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
 
-- 
2.25.1

