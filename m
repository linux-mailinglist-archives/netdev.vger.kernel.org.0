Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6D38B72B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbhETTTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:19:09 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:29214 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbhETTS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:18:56 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 1A77C5210B5;
        Thu, 20 May 2021 22:17:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538249;
        bh=dvl72yBvDEfKQVnsDxElM8SjyllWSEaALTzt6tq043w=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=N71ijAMuL56POIqZ3YdmoYmWO2EUqzkJSwakca92DcoFZEuT7BzumTDPM4anolbpS
         DwvbNQJlMMx2yRij4vx87XJegjV2B5+rR1ygXSlRyr2P28JInXirIwqWt5z9sR5ovf
         tDvHawUIDkmMZNrNe2joLIqmLONY98vr+jWVgOdLen/7Vzh8WwHfKrUh5VbW66sN9w
         VwxZedfF6PuJI8Rp7uQD6+Ih0nuTrL7OoPpCpG0sgYzeNApQd3D4U/E+ioV2ElJw0s
         c3wIM3SF8USsunWfxJWnQ0WchGE/qjT0LKsrlTZ5iGP8Ucc1gybcpDCB7ntNPOQIT+
         PG3lI8BBsK2IA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id CBB3252105E;
        Thu, 20 May 2021 22:17:28 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:17:28 +0300
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
Subject: [PATCH v10 09/18] virtio/vsock: simplify credit update function API
Date:   Thu, 20 May 2021 22:17:19 +0300
Message-ID: <20210520191722.1271762-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
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

This function is static and 'hdr' arg was always NULL.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6503a8370130..ad0d34d41444 100644
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

