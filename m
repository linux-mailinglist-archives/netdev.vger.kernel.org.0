Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56D5345F14
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhCWNLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:11:18 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:29753 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhCWNLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:11:00 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 4CC0F75F9D;
        Tue, 23 Mar 2021 16:10:57 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505057;
        bh=4m0TCbUysCCU3w12V8ocGMHQUai7xcDnP1vg5HLlHo8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=ak5xNt/tXuevMGHEt2WTLf04ZVnu4pmtmTSf24P+zG+cdRulyc8psbGFIcosB0YAE
         sM6UrGZimpyhEtOX+MjYXgrMj7YARNJtXjzeUXXdIsq72JzNou6gCtFfbu920iMMP7
         j20C9V8zuZb6ZxLgl9abDcnP9Z9bpR06tgyaETwUtki2IVt6ktoJyqvicD4XIcUf6y
         HssAN5py91xBkJ84TmMAzfStF9s2BN9M5VSXnzzLezCAWfPruB21/BAaVwD8E7mAgZ
         LEccmef2mUG03SaoDBWGbZAvXZgkY/JVal2rfHhwyh0b38k9scusMo4NmIsr+edehR
         /ycFESeHwxDRQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 06B7976226;
        Tue, 23 Mar 2021 16:10:57 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:10:56 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 06/22] af_vsock: implement send logic for SEQPACKET
Date:   Tue, 23 Mar 2021 16:10:42 +0300
Message-ID: <20210323131045.2460319-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/23/2021 12:55:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162595 [Mar 23 2021]
X-KSE-AntiSpam-Info: LuaCore: 437 437 85ecb8eec06a7bf2f475f889e784f42bce7b4445
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/23/2021 12:58:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.03.2021 11:46:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/23 11:43:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/23 11:40:00 #16480199
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
 v6 -> v7:
 'seqpacket_enqueue' callback interface changed, 'flags' argument was
 removed, because it was 'msg_flags' field of 'msg' argument which is
 already exists.

 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 21 +++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 7232f6c42a36..b7063820d0bc 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -138,6 +138,8 @@ struct vsock_transport {
 	/* SEQ_PACKET. */
 	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 int flags, bool *msg_ready, size_t *record_len);
+	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
+				 size_t len);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 617ffe42693d..a98e5daa06b7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1830,9 +1830,13 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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
@@ -1844,12 +1848,17 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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

