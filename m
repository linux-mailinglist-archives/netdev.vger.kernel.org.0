Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF1338B741
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhETTUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:20:36 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:53997 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239489AbhETTUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:20:32 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 35D9478584;
        Thu, 20 May 2021 22:19:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538347;
        bh=IregU34X8IEVQFvS6fNfC+XqIktBmYKjT4kmSksRqAg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=eMNx5HtBLDB9RmdeWLPvYRDd67Cq6kM7uWQcj4a2fSittWd8A3OKX6Cg0pND9ELk6
         BgLQRNE6r8k1jSLxCRIBmwrANaDkw/73QluNiOvyy5HdxJwuxx6jq1rbDxIUTkSYHO
         vJGiZSVq7OR3yoUDtyvpfhqgtgCQ2Q/54l2c1fRKbL0f+Xaf/Z7x3QTJGQQKwvhNlh
         QEzasNlDm+0b/f1PV0uXGq7QXFq7BisRoX086G9fZLkxqM0k22hNchnmWOhhwSa99o
         Nt00TyktODlnIxTlsEOI70NGiSKwduh+u94rGbsPPSRKFDqey5CcUwpFJXN9w+8SI7
         a2VSIAzV9vJjw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id F31CF78594;
        Thu, 20 May 2021 22:19:06 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:19:06 +0300
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
Subject: [PATCH v10 14/18] virtio/vsock: enable SEQPACKET for transport
Date:   Thu, 20 May 2021 22:18:57 +0300
Message-ID: <20210520191901.1272423-1-arseny.krasnov@kaspersky.com>
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

To make transport work with SOCK_SEQPACKET two updates were
added:
1) SOCK_SEQPACKET ops for virtio transport and 'seqpacket_allow()'
   callback.
2) Handling of SEQPACKET bit: guest tries to negotiate it with vhost.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v9 -> v10:
 1) Use 'virtio_has_feature()' to check feature bit.
 2) Move assignment to 'seqpacket_allow' before 'rcu_assign_pointer()'.

 net/vmw_vsock/virtio_transport.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2700a63ab095..bc5ee8df723a 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -62,6 +62,7 @@ struct virtio_vsock {
 	struct virtio_vsock_event event_list[8];
 
 	u32 guest_cid;
+	bool seqpacket_allow;
 };
 
 static u32 virtio_transport_get_local_cid(void)
@@ -443,6 +444,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static bool virtio_transport_seqpacket_allow(u32 remote_cid);
+
 static struct virtio_transport virtio_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -469,6 +472,10 @@ static struct virtio_transport virtio_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
+		.seqpacket_allow          = virtio_transport_seqpacket_allow,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
@@ -485,6 +492,19 @@ static struct virtio_transport virtio_transport = {
 	.send_pkt = virtio_transport_send_pkt,
 };
 
+static bool virtio_transport_seqpacket_allow(u32 remote_cid)
+{
+	struct virtio_vsock *vsock;
+	bool seqpacket_allow;
+
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
+	seqpacket_allow = vsock->seqpacket_allow;
+	rcu_read_unlock();
+
+	return seqpacket_allow;
+}
+
 static void virtio_transport_rx_work(struct work_struct *work)
 {
 	struct virtio_vsock *vsock =
@@ -608,6 +628,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
 	vdev->priv = vsock;
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
@@ -695,6 +718,7 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
+	VIRTIO_VSOCK_F_SEQPACKET
 };
 
 static struct virtio_driver virtio_vsock_driver = {
-- 
2.25.1

