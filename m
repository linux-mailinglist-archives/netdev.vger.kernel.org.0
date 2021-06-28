Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BD43B5BEE
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhF1KFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:05:03 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:20425 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbhF1KEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:04:51 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 3B26F77F6D;
        Mon, 28 Jun 2021 13:02:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874540;
        bh=eYh6K+ePYeQJ6C5XBc8TtM+gZlfJ2qvcaB8K0mfIGX0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=0GtGZd8aVYxBnerP+jX5p/uzauCYFQ5pb6rlSuMSTv4MVMhbpCL3TYaQTquui2ePY
         xivnprkRzCfxqyB9OErc2LRo7FX3KC0dXjybfjZ1dE3axDsTXAwLsIEehkDUeetoQX
         X2j44rERBDDQ+LvJW80WfhjqqXveakbTcF4P4bLl5oAwZR8afcnjcF+g/iONKRp021
         zemrg/g7WjbP7oHYB5e37+Ibj6zoidcpMW+gjtY2QQyDaEdw9/t+akCPjSfSkAaKYB
         GgsYrOTfJbYVQzey2anAnOXaHbYcfuaU83q7LR2op3ihnjR42Tn7bHUixPnXHmitaQ
         0dLYVJp2RAD4w==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 06C3477F6A;
        Mon, 28 Jun 2021 13:02:20 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:02:19 +0300
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
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 03/16] virtio/vsock: don't set 'seqpacket_has_data()' callback
Date:   Mon, 28 Jun 2021 13:02:12 +0300
Message-ID: <20210628100215.570476-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
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
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
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

Clean 'seqpacket_has_data()' callback in transport struct.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/virtio_transport.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ed1664e7bd88..e8b8108f3a29 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -475,7 +475,6 @@ static struct virtio_transport virtio_transport = {
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
 		.seqpacket_allow          = virtio_transport_seqpacket_allow,
-		.seqpacket_has_data       = virtio_transport_seqpacket_has_data,
 
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
-- 
2.25.1

