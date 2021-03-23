Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28026345F24
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCWNMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:12:50 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:30586 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhCWNMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:12:35 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id DAB0875FBC;
        Tue, 23 Mar 2021 16:12:27 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505148;
        bh=hS1VyDTANdxSRI309WCg4gsvCflOnzV8XuLScTrV4o0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=4Vuz5h0RVOKXw34SQR4JlNQ0zmZ4ol1aXSMdWMYGUoXMLbskP+K8LkqE5ALCSQN7K
         SJ4cX8BbQkvuxUrMXAiz9KbGvVLr+ASY9KZrQ0iS6XtQgMJL1s56xzciR19BdDdiFz
         kDCdci7R/b95cdxeWHyfDJ4I1WD4itRp4pn/XJDo2kgcRZSPcDLi0WYDkbkCchKKIn
         QmerNsAAwjF1fHmz43wVFoROFRF6JnwF6HH+CuR8IM32h1vadfVNjXxl1OJRnEuoCO
         0qTRfnB75RhjnAudO6r8BeGoEJauWTGTjnKzrETaEnON33pp5MEk6PvPHZS1wrnTpQ
         zx8u6PIeBIIWg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id A7E6D75FB6;
        Tue, 23 Mar 2021 16:12:27 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:12:26 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 10/22] virtio/vsock: simplify credit update function API
Date:   Tue, 23 Mar 2021 16:12:18 +0300
Message-ID: <20210323131221.2460907-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
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

This function is static and 'hdr' arg was always NULL.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index f69993d67f89..833104b71a1c 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -271,8 +271,7 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_put_credit);
 
-static int virtio_transport_send_credit_update(struct vsock_sock *vsk,
-					       struct virtio_vsock_hdr *hdr)
+static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
@@ -384,7 +383,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	 * with different values.
 	 */
 	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
-		virtio_transport_send_credit_update(vsk, NULL);
+		virtio_transport_send_credit_update(vsk);
 
 	return total;
 
@@ -493,7 +492,7 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 
 	vvs->buf_alloc = *val;
 
-	virtio_transport_send_credit_update(vsk, NULL);
+	virtio_transport_send_credit_update(vsk);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
 
-- 
2.25.1

