Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B1A38B728
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhETTS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:18:57 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:29080 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238676AbhETTSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:18:40 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 7D77152114E;
        Thu, 20 May 2021 22:17:15 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538235;
        bh=jYyMhKomlyLC02IgphUkHK3PVvgZGpWsyJQIM2N8EJE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=02Qsg4iYqdoTK8bhum3WfhzUVoIYSza/xUs8UjYOOmi62duwZfT77Ib437OHvuQAE
         vkC9TdFcIwGZVmYanySBG8uSC9Gsw9A0KrDflYvxqbK7ByggU9dlWxuF02mfjLkoLq
         eop4OGoq67btQ6qitx9EorYqt/1SERrQHJSYo3xOWHfCvPxl6AB75l5q/BkvuV5BvU
         FwrJncZojwm+3ZJpw8QzOsaP86rGDK2A1n2hWfRd7cXU/bIn0y6JKIc19jQzy0qIKV
         U301mLmExfVriovXSV4HzI87jOYEj+xrPnkgqpCHIGf+tW557TdshtM6PkZoDmhvM9
         66iJgGGUv1Akw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id E942C521145;
        Thu, 20 May 2021 22:17:14 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:17:14 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 08/18] virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
Date:   Thu, 20 May 2021 22:17:06 +0300
Message-ID: <20210520191709.1271652-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
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

There is no need to set type of packet which differs from type
of socket, so move passing type of packet from 'info' structure
to  'virtio_transport_send_pkt_info()' function. Since at current
time only stream type is supported, set it directly in 'virtio_
transport_send_pkt_info()', so callers don't need to set it.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 902cb6dd710b..6503a8370130 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -179,6 +179,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
+	info->type = VIRTIO_VSOCK_TYPE_STREAM;
+
 	t_ops = virtio_transport_get_ops(vsk);
 	if (unlikely(!t_ops))
 		return -EFAULT;
@@ -270,12 +272,10 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
 EXPORT_SYMBOL_GPL(virtio_transport_put_credit);
 
 static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
-					       int type,
 					       struct virtio_vsock_hdr *hdr)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
-		.type = type,
 		.vsk = vsk,
 	};
 
@@ -383,11 +383,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	 * messages, we set the limit to a high value. TODO: experiment
 	 * with different values.
 	 */
-	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
-		virtio_transport_send_credit_update(vsk,
-						    VIRTIO_VSOCK_TYPE_STREAM,
-						    NULL);
-	}
+	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+		virtio_transport_send_credit_update(vsk, NULL);
 
 	return total;
 
@@ -496,8 +493,7 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 
 	vvs->buf_alloc = *val;
 
-	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
-					    NULL);
+	virtio_transport_send_credit_update(vsk, NULL);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
 
@@ -624,7 +620,6 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_REQUEST,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.vsk = vsk,
 	};
 
@@ -636,7 +631,6 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.flags = (mode & RCV_SHUTDOWN ?
 			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
 			 (mode & SEND_SHUTDOWN ?
@@ -665,7 +659,6 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RW,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
@@ -688,7 +681,6 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.reply = !!pkt,
 		.vsk = vsk,
 	};
@@ -1000,7 +992,6 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RESPONSE,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
 		.remote_port = le32_to_cpu(pkt->hdr.src_port),
 		.reply = true,
-- 
2.25.1

