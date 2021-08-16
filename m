Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145DE3ED099
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhHPIwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:52:24 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:11498 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhHPIwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:52:22 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id BD3C9520F27;
        Mon, 16 Aug 2021 11:51:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1629103909;
        bh=tQkI5EXZ6GROwNbMqIylt8assDN8JNTnsdFeet3QqG0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=DE+/qglqK+co0oA0mQbY/JRpKcGcHI8NhLPO7HaVGDlSq52dB5CGQnTl6sbKM74pW
         Z+CJxO63nU5TzCEroYoxNeRjla2hjizthDOQIijCIX2qa7TNm/K1W7r3v7ZUFM0N1z
         FKd7ksen+BUl4Mxd4ABFj0c/eJaQx+8857+JOsFNzjriaMnhdiqt5D7qsbErsT86mi
         KxpI+NQfhN+bZi8vpBxmcyV5b4OCYPq8JaE9ZUbr6/nqTHgpNwHtE135z5NAhOb18p
         Z2LaRGAPwbt9zCpCxXGF6DST9s9Nhcrf6oJj/qA2QhOGX58SItUfOz6QDYHhD5kKJ1
         /LNWd4rf3QNEA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 7B0E7520F26;
        Mon, 16 Aug 2021 11:51:49 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.16.171.77) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 16
 Aug 2021 11:51:48 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.co>
Subject: [RFC PATCH v3 3/6] vhost/vsock: support MSG_EOR bit processing
Date:   Mon, 16 Aug 2021 11:51:40 +0300
Message-ID: <20210816085143.4174099-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.16.171.77]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/16/2021 08:40:34
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165570 [Aug 16 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/16/2021 08:42:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 16.08.2021 4:09:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/16 06:42:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/16 02:10:00 #17042267
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'MSG_EOR' handling has same logic as 'MSG_EOM' - if bit present
in packet's header, reset it to 0. Then restore it back if packet
processing wasn't completed. Instead of bool variable for each
flag, bit mask variable was added: it has logical OR of 'MSG_EOR'
and 'MSG_EOM' if needed, to restore flags, this variable is ORed
with flags field of packet.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index feaf650affbe..d217955bbcd4 100644
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
+				flags_to_restore |= VIRTIO_VSOCK_SEQ_EOM;
+
+				if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
+					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
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

