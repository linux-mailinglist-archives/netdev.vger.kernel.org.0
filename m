Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE1F330391
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 19:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhCGSAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 13:00:46 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:49884 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbhCGSAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 13:00:40 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id EB889520CE2;
        Sun,  7 Mar 2021 21:00:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615140039;
        bh=TJeMY4YP+rzEGk8tfXexYeG6YAphN+7CHCqVuzFa/yM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=MCaqx+2hZRlO3sMPR2rSy8ZTmLtoNcF4N41yz4wm9ebkjEtiKUZJgtI/iNw6HIAND
         KZu+3BRuNPe1gKWLvBXeSLpWZVJz23Tger2zaE4O8iVetBSLkmzeO3UAl4u4AFXmpi
         hFkrt/KY5YKWEci237CTjPji+MI9H6UGtm37XmANY+NFG+yufWt9vh71NWRo6QY7b3
         BCNxsJEobqO3jKvpGtQmhh7Lqc6GBkgAUvndzqpS+tPE2sW+uZG3Ce4NftIwOqU/KC
         2MmHwR5gAcfz52/1ohVKo13GZF4ElehRCWeXE5BZykueLLZzuKukMMsubfkg4rB41D
         MNqRaOvBmzxiw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 9FF4B520CBD;
        Sun,  7 Mar 2021 21:00:38 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 7 Mar
 2021 21:00:37 +0300
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
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v6 06/22] af_vsock: implement send logic for SEQPACKET
Date:   Sun, 7 Mar 2021 21:00:26 +0300
Message-ID: <20210307180030.3465161-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/07/2021 17:49:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162254 [Mar 07 2021]
X-KSE-AntiSpam-Info: LuaCore: 431 431 6af1f0c9661e70e28927a654c0fea10ff13ade05
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_JAPANESE}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_RUS}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_MISSED}
X-KSE-AntiSpam-Info: {Macro_DATE_DOUBLE_SPACE}
X-KSE-AntiSpam-Info: {Macro_DATE_MOSCOW}
X-KSE-AntiSpam-Info: {Macro_FROM_DOUBLE_ENG_NAME}
X-KSE-AntiSpam-Info: {Macro_FROM_LOWCAPS_DOUBLE_ENG_NAME_IN_EMAIL}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RU}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RUS_CHARSET}
X-KSE-AntiSpam-Info: {Macro_FROM_REAL_NAME_MATCHES_ALL_USERNAME_PROB}
X-KSE-AntiSpam-Info: {Macro_HEADERS_NOT_LIST}
X-KSE-AntiSpam-Info: {Macro_MAILER_OTHER}
X-KSE-AntiSpam-Info: {Macro_MISC_X_PRIORITY_MISSED}
X-KSE-AntiSpam-Info: {Macro_NO_DKIM}
X-KSE-AntiSpam-Info: {Macro_REPLY_TO_MISSED}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_AT_LEAST_2_WORDS}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_LONG_TEXT}
X-KSE-AntiSpam-Info: {Macro_TO_CONTAINS_5_EMAILS}
X-KSE-AntiSpam-Info: {Macro_TO_CONTAINS_SEVERAL_EMAILS}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/07/2021 17:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 07.03.2021 15:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/07 17:11:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/07 15:50:00 #16360637
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
---
 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index a8c4039e40cf..aed306292ab3 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -139,6 +139,8 @@ struct vsock_transport {
 	size_t (*seqpacket_seq_get_len)(struct vsock_sock *vsk);
 	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 int flags, bool *msg_ready);
+	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
+				 int flags, size_t len);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5bf64a3e678a..a031f165494d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1830,9 +1830,14 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		 * responsibility to check how many bytes we were able to send.
 		 */
 
-		written = transport->stream_enqueue(
-				vsk, msg,
-				len - total_written);
+		if (sk->sk_type == SOCK_SEQPACKET) {
+			written = transport->seqpacket_enqueue(vsk,
+						msg, msg->msg_flags,
+						len - total_written);
+		} else {
+			written = transport->stream_enqueue(vsk,
+					msg, len - total_written);
+		}
 		if (written < 0) {
 			err = -ENOMEM;
 			goto out_err;
@@ -1844,12 +1849,17 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 				vsk, written, &send_data);
 		if (err < 0)
 			goto out_err;
-
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

