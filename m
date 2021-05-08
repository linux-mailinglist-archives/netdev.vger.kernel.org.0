Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D5A37730D
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 18:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhEHQev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 12:34:51 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:62826 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhEHQer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 12:34:47 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id D5823521AFF;
        Sat,  8 May 2021 19:33:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620491621;
        bh=z87BLeFYzvdgqmI4WL+CeQwKb1piBcPhXcD7Mzkn3xs=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=lpCIg7TsicUP5RLZy0EEd+oD4ny/KCZrInihPQkwTxuXbuzDiTvTNfBXiEYNE9CrD
         wZGjLe+RHiQadokh6JHP3+1Nh+stgtuU3TUO7wsaVSu7iKcbto2szAjHBsEEukHNf7
         KWneE+TSva0arXW6MuM7a9GAKu4C/cTmtFD5W63CNjbRKsn0gzQOdvoJrI9RdV5rHv
         g6DPBYhM6j/mSk6rvMvn+2jpwpo94l92dBm/CkNhRO0J+Y/3bRlvXnrCqAc7uwgw0h
         e6QRJzgHA7Miz0uv3lMhffZnPFc2fya+l64ltRZDxE+zHcDHCg/F/kKm2NTQMcslsj
         o9Oza4qg2/M5A==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 8D238521974;
        Sat,  8 May 2021 19:33:41 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 8 May
 2021 19:33:41 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v9 05/19] af_vsock: implement send logic for SEQPACKET
Date:   Sat, 8 May 2021 19:33:28 +0300
Message-ID: <20210508163332.3431236-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/08/2021 16:21:10
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163552 [May 08 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/08/2021 16:24:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 08.05.2021 12:32:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/08 15:50:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/08 12:32:00 #16600610
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some logic to current stream enqueue function for SEQPACKET
support:
1) Use transport's seqpacket enqueue callback.
2) Return value from enqueue function is whole record length or error
   for SOCK_SEQPACKET.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 5175f5a52ce1..5860027d5173 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -138,6 +138,8 @@ struct vsock_transport {
 	/* SEQ_PACKET. */
 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
 				     int flags, bool *msg_ready);
+	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
+				 size_t len);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 78b9af545ca8..3f9cfcce1e42 100644
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

