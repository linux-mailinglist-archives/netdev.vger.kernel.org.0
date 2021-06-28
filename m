Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB543B5C17
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhF1KHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:07:23 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:61522 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhF1KHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:07:18 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 9BA35521DD5;
        Mon, 28 Jun 2021 13:04:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874691;
        bh=nJ3CVmXNvkiXgk+hkdyEWyiTTYjnZRN33KoZQsVXAmQ=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=j/bEtK8pGF0MI3+ZB8uSvVfz32G+STE/T4I2G1Wxa+go8nrvb0JWkQCyaT1ypZslW
         VpoKVzm72BL5aWscvlVo6EBOE3ULO1EhJE8AGpWduri7CtINN8Mmmm4uT+H7KneMn+
         jqhG2DePajxtEnM7Rs5IrDAY333AetLDHXHI8y6Y9DZNOnXil5zVvEEAkitKlZYqik
         8PheMsjF9/xBsTeup7+mEtvxDv5nQYdq6PZfPCnb9PvFf/v/gXDpoSj7mQ0LMt+eG0
         Iv7u48LZx7/TINavk2RhSWCySv/E7nG0pZ/+GFrn37FHjdERLwssv0sJ2GExTGvRnu
         hTB2LE7hyWA8Q==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 531C4521056;
        Mon, 28 Jun 2021 13:04:51 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:04:50 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 13/16] vhost/vsock: enable 'seqpacket_drop' callback in transport
Date:   Mon, 28 Jun 2021 13:04:42 +0300
Message-ID: <20210628100445.571625-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/28/2021 09:47:58
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164664 [Jun 28 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/28/2021 09:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 28.06.2021 5:59:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/28 08:23:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/28 05:40:00 #16806866
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set 'seqpacket_drop()' callback in transport struct.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 4118390aeab6..0c154c2ca596 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -447,6 +447,7 @@ static struct virtio_transport vhost_transport = {
 		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
+		.seqpacket_drop           = virtio_transport_seqpacket_drop,
 
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
-- 
2.25.1

