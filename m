Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B74303248
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbhAYNpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 08:45:15 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:13371 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbhAYNnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:43:55 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 802D176100;
        Mon, 25 Jan 2021 14:16:03 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611573363;
        bh=47ZP7zPW9EGf6C09j+32Dro13hTpZ7GChyrVCNwgXXU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=JeSku9KfqqaWOkQnaIRshvcq+jNjMpMLpYiGAXkDqRazsPRZMkABL+3FuUKi9du5K
         sHJX1H2n8C9+FexvByWcnx/Hb/pkYwauVoCJnMX37E4g2OobFuOX98tdSHAGpmB7Ad
         tvwlHbKDmI2QUQr5+6bS9o/IBDu0Fusrt0Uk31Pg=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 42110760F3;
        Mon, 25 Jan 2021 14:16:03 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 25
 Jan 2021 14:16:02 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v3 11/13] virtio/vsock: setup SEQPACKET ops for transport
Date:   Mon, 25 Jan 2021 14:15:47 +0300
Message-ID: <20210125111550.599591-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/25/2021 10:59:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161363 [Jan 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 421 421 33a18ad4049b4a5e5420c907b38d332fafd06b09
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/25/2021 11:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 1/25/2021 10:11:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/25 10:04:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/25 10:14:00 #16023936
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds SEQPACKET ops for virtio transport

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/virtio_transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2700a63ab095..5a7ab1befee8 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -469,6 +469,10 @@ static struct virtio_transport virtio_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_seq_send_len	  = virtio_transport_seqpacket_seq_send_len,
+		.seqpacket_seq_get_len	  = virtio_transport_seqpacket_seq_get_len,
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
-- 
2.25.1

