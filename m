Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448C1377316
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 18:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhEHQfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 12:35:50 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:63163 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhEHQfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 12:35:44 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 9D8EB520EE7;
        Sat,  8 May 2021 19:34:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620491680;
        bh=Cr6IfYZeeDv/mRFF3/dL1PUNQIYf9pPV/OeJKwrG9h4=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=DEqueHm4ILAqgpWzq7Cpsu2qv1XIkiTZ9VyZz30pko4wybJT1eSNPKyX3A2NP0f27
         7LLQCt9I8NoKlurVDGkrx4wlnhrUatLCANoIYEionFOZuq5J1HpBY0N2gDiuLARC/x
         vlOmuNnZBOgAu8m4PZbVvsD273lmBATQbERqFwKwS+8KNq49tlIHkslwQkCTZ7n4zo
         wDlcvZN/xZCjvf3evHpkPZ+g9hmG1XH11zuoE/rYAK4scj5f8XxDhdu2XiOYqmYFpr
         IQLiJ69yFRIsHOeDaijl/CHrQXkn36U3WDn/Tmov1uEr0f0EAK9aJIWE37pqTsBh9d
         sHxFavdirluRQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 61F15520DE7;
        Sat,  8 May 2021 19:34:40 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 8 May
 2021 19:34:39 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v9 08/19] virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
Date:   Sat, 8 May 2021 19:34:14 +0300
Message-ID: <20210508163418.3431582-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/08/2021 16:21:10
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163552 [May 08 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/08/2021 16:24:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 08.05.2021 12:32:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/08 15:50:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/08 12:32:00 #16600610
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves passing type of packet from 'info' structure to  'virtio_
transport_send_pkt_info()' function. There is no need to set type of
packet which differs from type of socket. Since at current time only
stream type is supported, set it directly in 'virtio_transport_send_
pkt_info()', so callers don't need to set it.

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

