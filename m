Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922C331E5EC
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhBRFsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:48:18 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:48242 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhBRFmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:42:12 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 9858E761D8;
        Thu, 18 Feb 2021 08:39:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613626772;
        bh=D3ih6UqBmeFmXQNrkHmtdAOXODzVOQMRPTRXGXzJRUo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=HT2Xshpu69YMbrr+Q8F4+tbX0cjcgBZzlBtR/O4b2ANULjitLiiuirwTWfNkC0YR3
         dODsYzWm0p68Pdn7SnseRXGdAp+hZUT+w6kbULJiiu53J7i5Mjs8LhdnW9v1XkI1q/
         tEl6fxh0oYWuPb718ZJkvQiuKZSXLxqZ2+i1kocO7dftGjzk5QpdYovQK6AgYQl9Ue
         9QyGZbczIV92K/rWgaJ8X3rWUe3dylxl+yRl5Fi82Hkd5yVE3KEFHyVUsIfZCaMYsY
         lmHvv4tusBxfzYMbcssSvD4X3XuDiC2ZsJsifBMn51K5HKyMYVYxd5DxTps3oHnyIG
         VM9LyFYNSJfzw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 2EC1C761CB;
        Thu, 18 Feb 2021 08:39:32 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 18
 Feb 2021 08:39:31 +0300
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
Subject: [RFC PATCH v5 10/19] virtio/vsock: simplify credit update function API
Date:   Thu, 18 Feb 2021 08:39:23 +0300
Message-ID: <20210218053926.1068053-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
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
X-KSE-Antivirus-Info: Clean, bases: 06.02.2021 21:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/18 04:51:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/18 04:31:00 #16269527
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
 net/vmw_vsock/virtio_transport_common.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 1c9d71ca5e8e..833104b71a1c 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -271,13 +271,10 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
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
 
@@ -385,11 +382,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	 * messages, we set the limit to a high value. TODO: experiment
 	 * with different values.
 	 */
-	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
-		virtio_transport_send_credit_update(vsk,
-						    VIRTIO_VSOCK_TYPE_STREAM,
-						    NULL);
-	}
+	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+		virtio_transport_send_credit_update(vsk);
 
 	return total;
 
@@ -498,8 +492,7 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 
 	vvs->buf_alloc = *val;
 
-	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
-					    NULL);
+	virtio_transport_send_credit_update(vsk);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
 
-- 
2.25.1

