Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7AB3ED0A5
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhHPIxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:53:37 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:11851 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbhHPIxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:53:36 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 7AD4B520F14;
        Mon, 16 Aug 2021 11:52:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1629103976;
        bh=mnfB8AnvYpkWIrHTfLhyeBKQTr+GRxnA4e/Qa3DaACs=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=HJ5So8dCkyNS+tYWwn+75VV1ZxMoiupAncQIRr1LvQfjd2FTjHCCE8dxa3VHn7iye
         ymQVt0QC0Hmy+fECLfTtA8MxFIkQkPZ0VPNPHFhmHz+fVDilZXOoZyGAl1VBADlwLq
         PIF1tcwbVyQIiUpn40Rn2EGmP9WXfMQvCEfWqApxY4TFKCEwVTTglXoqmZr1Tias/r
         Vd0mQSQhxpnOeSayr6UsTUIxhPHi928pKRJsOtlB11u57625rCw+uYMeUxQKfwOyag
         ++WtEKmA9xnCtkKWB4ZKdSFaYtzsuDmSpsWdWBtoQj7QbZrOYUnEt8t6HhNC2Ld/2W
         WY5HPQiiTUp/w==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 2B834520FD0;
        Mon, 16 Aug 2021 11:52:56 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.16.171.77) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 16
 Aug 2021 11:52:55 +0300
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
Subject: [RFC PATCH v3 5/6] af_vsock: rename variables in receive loop
Date:   Mon, 16 Aug 2021 11:52:34 +0300
Message-ID: <20210816085237.4174476-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.16.171.77]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
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

Record is supported via MSG_EOR flag, while current logic operates
with message, so rename variables from 'record' to 'message'.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3e02cc3b24f8..e2c0cfb334d2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2014,7 +2014,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 {
 	const struct vsock_transport *transport;
 	struct vsock_sock *vsk;
-	ssize_t record_len;
+	ssize_t msg_len;
 	long timeout;
 	int err = 0;
 	DEFINE_WAIT(wait);
@@ -2028,9 +2028,9 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 	if (err <= 0)
 		goto out;
 
-	record_len = transport->seqpacket_dequeue(vsk, msg, flags);
+	msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
 
-	if (record_len < 0) {
+	if (msg_len < 0) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -2044,14 +2044,14 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 		 * packet.
 		 */
 		if (flags & MSG_TRUNC)
-			err = record_len;
+			err = msg_len;
 		else
 			err = len - msg_data_left(msg);
 
 		/* Always set MSG_TRUNC if real length of packet is
 		 * bigger than user's buffer.
 		 */
-		if (record_len > len)
+		if (msg_len > len)
 			msg->msg_flags |= MSG_TRUNC;
 	}
 
-- 
2.25.1

