Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533E6345F43
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhCWNPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:15:04 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:49556 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhCWNOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:14:31 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 10B9A521EB6;
        Tue, 23 Mar 2021 16:14:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505268;
        bh=W/dHZJY2oae7Ra2cf+/urTcJsHpw9ZoLn22EpE2aI38=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=MzGaQkl8lSBgejucdfXI3jINwXAXXdLCPH6DvpShNgzXdUtLmwW238yX2iHRHaWJA
         O7DATBH16KOtnwxlD+RdDONsIO8mgYXhmTV0qiKrlQcYUAaG1TC68SkbRtRABEzYbq
         VxUcuLxO5E9hvzasxHApAt4B0CxQIFS8h2TYulYPozRhRV3DxHZ2pKI+jrL7c5nex/
         yjhgc3zHsdez+UqBdsQfAnPyJ85CxHgzv6pbpEWYxvfBP9e28f20Tfr+WmSOIWRSkH
         8kuuQQqQDU9fSx43dgW95VE0+0+sKnp02PDlKPiz2y+9xbrWiRp6AfLr5Pv9iLRYzq
         LoWONNS/ZOWxw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id B701D521EDF;
        Tue, 23 Mar 2021 16:14:27 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:14:27 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 17/22] vhost/vsock: setup SEQPACKET ops for transport
Date:   Tue, 23 Mar 2021 16:14:18 +0300
Message-ID: <20210323131421.2461760-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/23/2021 12:55:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162595 [Mar 23 2021]
X-KSE-AntiSpam-Info: LuaCore: 437 437 85ecb8eec06a7bf2f475f889e784f42bce7b4445
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/23/2021 12:58:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.03.2021 11:46:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/23 11:43:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/23 11:40:00 #16480199
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This also removes ignore of non-stream type of packets and adds
'seqpacket_allow()' callback.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..5af141772068 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -354,8 +354,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
-		pkt->len = le32_to_cpu(pkt->hdr.len);
+	pkt->len = le32_to_cpu(pkt->hdr.len);
 
 	/* No payload */
 	if (!pkt->len)
@@ -398,6 +397,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static bool vhost_transport_seqpacket_allow(void);
+
 static struct virtio_transport vhost_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -424,6 +425,10 @@ static struct virtio_transport vhost_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
+		.seqpacket_allow          = vhost_transport_seqpacket_allow,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
@@ -439,8 +444,14 @@ static struct virtio_transport vhost_transport = {
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
+	.seqpacket_allow = false
 };
 
+static bool vhost_transport_seqpacket_allow(void)
+{
+	return vhost_transport.seqpacket_allow;
+}
+
 static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
-- 
2.25.1

