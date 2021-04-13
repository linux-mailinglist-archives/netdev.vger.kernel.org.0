Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086D535DF50
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345762AbhDMMrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:47:16 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:58169 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344485AbhDMMq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:46:28 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 19EC175F0D;
        Tue, 13 Apr 2021 15:46:05 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618317965;
        bh=rjWHu1wyBRLN/ThZV4ZD4Oh4wKafvmcClIGoBbeasYA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=AJx6FIfluFebH3Ogtsblxkvjd/ToyZ6wMwAr5Mt+zarsIYwBU8mwVLpHkjG8tbPus
         nftrwAcI4kRu0dsQ0aqyOZK2FpXiVC47b7GLlY2Y2tzQQyxQeB8ncKxVpCaVhfL+hI
         FNBeeW8KQFfkYvi8iQYOKPcAPlkx2QJwhiN12CN8xFIhfQFvTTZ6NY9wIsmG3YG7yS
         3qq43O200oYFTisv3cz/AfVwio3YIhr8d5phH9qmlhDj72jFlOeU6DjpCeUi4JHdDs
         ECbGW4XdGpG8FvoaJY3zNZ/ksE/Ae1bDbnlOkJNLB+6l+N36NLAMYFhJ26ySSBWtac
         Y8L9nnppI8Eiw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id D74D275F24;
        Tue, 13 Apr 2021 15:46:04 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:46:04 +0300
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
Subject: [RFC PATCH v8 14/19] virtio/vsock: enable SEQPACKET for transport
Date:   Tue, 13 Apr 2021 15:45:49 +0300
Message-ID: <20210413124552.3404877-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
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

This adds
1) SEQPACKET ops for virtio transport and 'seqpacket_allow()' callback.
2) Handling of SEQPACKET bit: guest tries to negotiate it with vhost.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
v7 -> v8:
 - This patch merged with patch which adds SEQPACKET feature bit to
   virtio transport.

 net/vmw_vsock/virtio_transport.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2700a63ab095..ee99bd919a12 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -443,6 +443,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static bool virtio_transport_seqpacket_allow(void);
+
 static struct virtio_transport virtio_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -469,6 +471,10 @@ static struct virtio_transport virtio_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
+		.seqpacket_allow          = virtio_transport_seqpacket_allow,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
@@ -483,8 +489,14 @@ static struct virtio_transport virtio_transport = {
 	},
 
 	.send_pkt = virtio_transport_send_pkt,
+	.seqpacket_allow = false
 };
 
+static bool virtio_transport_seqpacket_allow(void)
+{
+	return virtio_transport.seqpacket_allow;
+}
+
 static void virtio_transport_rx_work(struct work_struct *work)
 {
 	struct virtio_vsock *vsock =
@@ -612,6 +624,10 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
+
+	if (vdev->features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
+		virtio_transport.seqpacket_allow = true;
+
 	return 0;
 
 out:
@@ -695,6 +711,7 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
+	VIRTIO_VSOCK_F_SEQPACKET
 };
 
 static struct virtio_driver virtio_vsock_driver = {
-- 
2.25.1

