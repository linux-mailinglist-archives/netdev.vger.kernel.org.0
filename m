Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A995035DF57
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhDMMsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:48:35 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:20511 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244403AbhDMMrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:47:13 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 4ACE152149D;
        Tue, 13 Apr 2021 15:46:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618318011;
        bh=+ejsH25XE8amilkeKtEGYvfpOp7lf1cuY7Vjpl0znKU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=eAUple99ePL4P/3UKbgspPg1mJjdJ3RwG52jfUSqo/zmhHyhYKytSs2RuYP7Cx8Dr
         +P4pVO0XulzKJkFM34rLcgWx/zjYNzbAhFYNLh16oEIuV2bYQ0CWbT26QbBrLsQ9Wc
         CbIYovlcphd7c/ef2vkGIap8++w2TR2B4NlRP+yWvLkCof31K+UrW/IgiuYlSnm39x
         u4cvcR/ShR8zFuLheOqwcJLnbppoxci2EvkwPATgsZcoUZCyAhWKZRciIPkopRwR1Q
         8nbscP2KenS62Y7CXL6RrO3NutBTxCrVnljCeaI3/DaQb1RN0viZM3Xro5qj3pZdGb
         FCji1gjSttMiA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id F0F835214CB;
        Tue, 13 Apr 2021 15:46:50 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:46:50 +0300
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
Subject: [RFC PATCH v8 16/19] vsock/loopback: enable SEQPACKET for transport
Date:   Tue, 13 Apr 2021 15:46:39 +0300
Message-ID: <20210413124642.3406320-1-arseny.krasnov@kaspersky.com>
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

This adds SEQPACKET ops for loopback transport and 'seqpacket_allow()'
callback.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vsock_loopback.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index a45f7ffca8c5..d38ffdbecc84 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -63,6 +63,8 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 	return 0;
 }
 
+static bool vsock_loopback_seqpacket_allow(void);
+
 static struct virtio_transport loopback_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -89,6 +91,10 @@ static struct virtio_transport loopback_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
+		.seqpacket_allow          = vsock_loopback_seqpacket_allow,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
@@ -103,8 +109,14 @@ static struct virtio_transport loopback_transport = {
 	},
 
 	.send_pkt = vsock_loopback_send_pkt,
+	.seqpacket_allow = true
 };
 
+static bool vsock_loopback_seqpacket_allow(void)
+{
+	return loopback_transport.seqpacket_allow;
+}
+
 static void vsock_loopback_work(struct work_struct *work)
 {
 	struct vsock_loopback *vsock =
-- 
2.25.1

