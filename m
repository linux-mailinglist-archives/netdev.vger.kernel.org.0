Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307693D6404
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238737AbhGZPx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:53:59 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:31430 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbhGZPxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 11:53:52 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 503F176F79;
        Mon, 26 Jul 2021 19:34:16 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1627317256;
        bh=ryDfW+J/VW9hKhGCsjMSOFxd88HMnpxcIzleRIVZO2g=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=A75G3d7B5/Q0jvkijsglzttpRMdDr8BtyJECfmqyfPLy/hgg0Xqpr88v8ZBSXiOfx
         8/fC1N6OSuVMCtxPhom9765YU3E++dW//w7nkt4tvHnUe45Or7YoEpRDqp6sS30Rs/
         1oDnzc/yzVCFHnWgvyL65yRKTEmjWRK3Vu4lYZEnuCff2sgpy+0HJ4juKJWOv4ArkH
         ziw8I9Z7LMZpgpOSKYW2wBEH4XFhva/DnJV39hbsFbuXOyB5Pu9NO/+fx0NSP9Irmn
         sSSHSnrWcYB2LZ+7uMpoNsovdTRf8TvPRa1beAIJwv0C77DhDLt0EGPn/Sao7eweTN
         pvrXch8o/JsTQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 1973676E7D;
        Mon, 26 Jul 2021 19:34:16 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 26
 Jul 2021 19:34:15 +0300
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
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 5/7] af_vsock: rename variables in receive loop
Date:   Mon, 26 Jul 2021 19:34:06 +0300
Message-ID: <20210726163409.2589994-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 16:13:33
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165254 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 16:15:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 26.07.2021 14:57:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/26 14:52:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/26 14:01:00 #16958312
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Record is supported via MSG_EOR flag, while current logic operates
with message, so rename variables from 'record' to 'message'.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
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

