Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C105D3BABFE
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhGDIMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:12:51 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:33399 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhGDIMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:12:49 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 920A4521554;
        Sun,  4 Jul 2021 11:10:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625386212;
        bh=16Hz9RnjdCapDIkGUAR892872Da61ymJD2UMBa+syBc=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=VEglJ9aHRl4Pfq/wTmHciD1tqNoEXAaYflCz8kOli+6Hc9DdAXZaL5KHquq0I16y3
         ZO/h09R56PGFKZT2ZeIfBhkBmU/8H8Timqn4KFP4ExvCVRLbxGoi17gSJlI5GNmRQl
         vMy2GubYJY8bby11LLcbzZEQrrPFQMDoGNvSfZplFtR5XCaR9lkwMmRL6nyXAf1pxp
         FTfeY2nk8K7eDASAKeaeC/4vbi9ARPA/RG1ER64bdGGU5z5PWU/viqDkpnkAHt7qq+
         5GOlRXQu8j93KTzTlbDvZnDKWAa9JCzD5BEAoDpiyxV4p7t6pFqb2eXWp00v/z8qSW
         6v+2VN/M71CVA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6A02C521548;
        Sun,  4 Jul 2021 11:10:11 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Sun, 4
 Jul 2021 11:10:10 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 2/6] af_vsock/virtio/vsock: remove 'seqpacket_has_data' callback
Date:   Sun, 4 Jul 2021 11:10:02 +0300
Message-ID: <20210704081005.89319-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/04/2021 07:43:44
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164820 [Jul 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/04/2021 07:45:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.07.2021 5:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/04 06:12:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/04 01:03:00 #16855183
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'rx_bytes' is used to check data presence on both SOCK_STREAM
and SOCK_SEQPACKET socket types for virtio/vsock.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c                   |  1 -
 include/linux/virtio_vsock.h            |  1 -
 include/net/af_vsock.h                  |  1 -
 net/vmw_vsock/af_vsock.c                | 10 ----------
 net/vmw_vsock/virtio_transport.c        |  1 -
 net/vmw_vsock/virtio_transport_common.c | 13 -------------
 net/vmw_vsock/vsock_loopback.c          |  1 -
 7 files changed, 28 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index d38c996b4f46..c9713d8db0f4 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -451,7 +451,6 @@ static struct virtio_transport vhost_transport = {
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
 		.seqpacket_allow          = vhost_transport_seqpacket_allow,
-		.seqpacket_has_data       = virtio_transport_seqpacket_has_data,
 
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index e68b4029f038..8d34f3d73bbb 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -92,7 +92,6 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   bool *msg_ready);
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
-u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
 
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 				 struct vsock_sock *psk);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index c40d341611b0..1747c0b564ef 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -141,7 +141,6 @@ struct vsock_transport {
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
 	bool (*seqpacket_allow)(u32 remote_cid);
-	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index b66884def8e8..87955f9ff065 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -860,16 +860,6 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
 
-static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
-{
-	struct sock *sk = sk_vsock(vsk);
-
-	if (sk->sk_type == SOCK_SEQPACKET)
-		return vsk->transport->seqpacket_has_data(vsk);
-	else
-		return vsock_stream_has_data(vsk);
-}
-
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
 	return vsk->transport->stream_has_space(vsk);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e0c2c992ad9c..2a7c56fcb062 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -475,7 +475,6 @@ static struct virtio_transport virtio_transport = {
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
 		.seqpacket_allow          = virtio_transport_seqpacket_allow,
-		.seqpacket_has_data       = virtio_transport_seqpacket_has_data,
 
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 053bcea1a03f..37d4ed526750 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -530,19 +530,6 @@ s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_has_data);
 
-u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
-{
-	struct virtio_vsock_sock *vvs = vsk->trans;
-	u32 msg_count;
-
-	spin_lock_bh(&vvs->rx_lock);
-	msg_count = vvs->msg_count;
-	spin_unlock_bh(&vvs->rx_lock);
-
-	return msg_count;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_has_data);
-
 static s64 virtio_transport_has_space(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 169a8cf65b39..809f807d0710 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -94,7 +94,6 @@ static struct virtio_transport loopback_transport = {
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
 		.seqpacket_allow          = vsock_loopback_seqpacket_allow,
-		.seqpacket_has_data       = virtio_transport_seqpacket_has_data,
 
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
-- 
2.25.1

