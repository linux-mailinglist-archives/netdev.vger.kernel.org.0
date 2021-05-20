Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C138B74B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhETTVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:21:07 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:30025 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbhETTVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:21:06 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id F39A25211D7;
        Thu, 20 May 2021 22:19:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538382;
        bh=T7/K2lVYIflQ6mGIDVsFNHYbWNdFHhzdVGTFpFem/30=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=iuF/E7a3nVlLnqRdW/swMpj10WCDjH9KqTH9cY7DqyGejrUl0tZN4LaO8huGsX6Ja
         GsO9j2Pf5FhMl8D5/x9lmA0gL0D7M7DolyFirJJeHOgsPcOLxorRgrtk94KN8UjFT9
         pjLMR1AJo4Y+7z2z00gxU3zrkdvRJHjdSad8TXFdqP7I8ENGe8UgL+KugcrW516mk1
         b7mV7gph2SboycyVwxYXvaIVt6h7Xg/dY+q/B8bAmBS/EwcNUmp/FlvT6dz8GXTZh4
         FmT79ET7guBIujrvo0x4UT03ietpSdCygOtuMoBFnQf5pI+6M+K5nuKH1aEmYIDx7u
         E7H8Zl3ouCKCQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id B0B2D5211BC;
        Thu, 20 May 2021 22:19:41 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:19:40 +0300
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
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 16/18] vsock/loopback: enable SEQPACKET for transport
Date:   Thu, 20 May 2021 22:19:32 +0300
Message-ID: <20210520191935.1272676-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
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

Add SEQPACKET ops for loopback transport and 'seqpacket_allow()'
callback.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vsock_loopback.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index a45f7ffca8c5..809f807d0710 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -63,6 +63,8 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 	return 0;
 }
 
+static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
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
@@ -105,6 +111,11 @@ static struct virtio_transport loopback_transport = {
 	.send_pkt = vsock_loopback_send_pkt,
 };
 
+static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
+{
+	return true;
+}
+
 static void vsock_loopback_work(struct work_struct *work)
 {
 	struct vsock_loopback *vsock =
-- 
2.25.1

