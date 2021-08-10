Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208713E5940
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbhHJLku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:40:50 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:12142 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbhHJLkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:40:49 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 3DEF2520D7C;
        Tue, 10 Aug 2021 14:40:26 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1628595626;
        bh=ssYqFO/OhOF3WrszHkkKfIX5jswuVOzDkLjXQavbZfA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=lj56V8FnWF+p+5PipLmdhOq4HPOPy4e1Qph2yqfpXTX0B5ZkYnXb23SZkBoj4gRvH
         W/WkvSIV8z7fRkt7FlEozem/rbiaVDG7mZWykYZetJBcmQumUbvDCWmngjiNGjg3J+
         28bwM3wE7zPhYAi/51EMrbLYigyeOj1egzB0o29+1+AreMAibP38v3JKKkVR+ERFjr
         e3o5XvTsAVIOVYVL/uehO0J2Cw5/QD7LpDT+Olg8m0CNK4oxKgb6VczQiVLAGaRn8z
         fdgfje/JcpX+cjSG/5d/v712AMytahR5h3vOTWGtUnIZ3a+mm+8J81P0vTcSn9NLSb
         b9fHM6tuvPYJA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 72BE9520D32;
        Tue, 10 Aug 2021 14:40:25 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 10
 Aug 2021 14:40:24 +0300
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
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 2/5] vhost/vsock: support MSG_EOR bit processing
Date:   Tue, 10 Aug 2021 14:40:15 +0300
Message-ID: <20210810114018.1214619-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/10/2021 11:26:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165493 [Aug 10 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/10/2021 11:24:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10.08.2021 6:55:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/10 08:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/10 05:40:00 #17007547
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It works in the same way as 'end-of-message' bit: if packet has
'EOM' bit, also check for 'EOR' bit.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index feaf650affbe..06fc132b13c8 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -114,7 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		size_t nbytes;
 		size_t iov_len, payload_len;
 		int head;
-		bool restore_flag = false;
+		uint32_t flags_to_restore = 0;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -187,7 +187,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			 */
 			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
 				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
-				restore_flag = true;
+				flags_to_restore |= le32_to_cpu(VIRTIO_VSOCK_SEQ_EOM);
+
+				if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
+					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+					flags_to_restore |= le32_to_cpu(VIRTIO_VSOCK_SEQ_EOR);
+				}
 			}
 		}
 
@@ -224,8 +229,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 * to send it with the next available buffer.
 		 */
 		if (pkt->off < pkt->len) {
-			if (restore_flag)
-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
 
 			/* We are queueing the same virtio_vsock_pkt to handle
 			 * the remaining bytes, and we want to deliver it
-- 
2.25.1

