Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA713A40E8
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhFKLNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:13:19 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:35991 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhFKLNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:13:00 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id BD1F875A25;
        Fri, 11 Jun 2021 14:11:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623409860;
        bh=wHOwrSnr0q1N+27yO0Onxs9WUcwWmlUKa8vdMXM6Tdo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=bVE9/XYH4M9sy20vEk9IsvL9HYKM4VWRrjG73ECNT7iGC2Lz1+hxCw1I3Jv9GpWfD
         YqH7eYF1FpkUNv5fr0w29srbFXMmmRHjgqBgM5+yC/w9oEafOLn1vQn7KTpLoYb0E/
         fDQKrYyEBxNPcB2bQ63dQjBC92FMpUsCV+73qI0qS8/wWWrcplT3jgrhswWG89E8te
         DrnqGDJmXGaMErjI9DqFRqWkN018yGjrPSwVAoyYVr1RGQdmonTQbW8JbhXpBTEzOZ
         H/sXOZfC0ub9V7bFwoaxkHyznAWYtE6b8CNJXdtAkF6MX7CuBwxPJfMyM2ybpJBLpw
         3b+5jZfVT9MsQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 06E8375A22;
        Fri, 11 Jun 2021 14:10:59 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:10:59 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v11 05/18] af_vsock: implement send logic for SEQPACKET
Date:   Fri, 11 Jun 2021 14:10:49 +0300
Message-ID: <20210611111052.3651521-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/11/2021 10:44:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164266 [Jun 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/11/2021 10:48:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.06.2021 5:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/11 09:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/10 21:54:00 #16707142
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update current stream enqueue function for SEQPACKET
support:
1) Call transport's seqpacket enqueue callback.
2) Return value from enqueue function is whole record length or error
   for SOCK_SEQPACKET.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 4d7cf6b2aca2..d6745d8b8f3e 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -138,6 +138,8 @@ struct vsock_transport {
 	/* SEQ_PACKET. */
 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
 				     int flags);
+	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
+				 size_t len);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 87ae26b2e3e1..9e0cc07e3caf 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1808,9 +1808,13 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		 * responsibility to check how many bytes we were able to send.
 		 */
 
-		written = transport->stream_enqueue(
-				vsk, msg,
-				len - total_written);
+		if (sk->sk_type == SOCK_SEQPACKET) {
+			written = transport->seqpacket_enqueue(vsk,
+						msg, len - total_written);
+		} else {
+			written = transport->stream_enqueue(vsk,
+					msg, len - total_written);
+		}
 		if (written < 0) {
 			err = -ENOMEM;
 			goto out_err;
@@ -1826,8 +1830,14 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out_err:
-	if (total_written > 0)
-		err = total_written;
+	if (total_written > 0) {
+		/* Return number of written bytes only if:
+		 * 1) SOCK_STREAM socket.
+		 * 2) SOCK_SEQPACKET socket when whole buffer is sent.
+		 */
+		if (sk->sk_type == SOCK_STREAM || total_written == len)
+			err = total_written;
+	}
 out:
 	release_sock(sk);
 	return err;
-- 
2.25.1

