Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3784A312518
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBGPRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:17:23 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:12837 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhBGPQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:16:57 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 1331F76025;
        Sun,  7 Feb 2021 18:16:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612710967;
        bh=uANF9Dt/jyoEWxI+z7y39eNU33lRwyhj71CV4j/FKm8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=NspIp0g7xewsNYMINY/tIfLP4jarPOX5ojqV5petbvUGHf3sC3aPaAlo+1eyiFh0f
         OMLZt9AYV4kaAzHOTRU790ZGaKqJXe23mcTVsK/FnfMy7vT23Rfpy1MBHJU6mFCsYv
         GAiMymRmv274u6xOM6VeUVjISQCfQ0sWqGrYRmsc=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id D4E3E7601F;
        Sun,  7 Feb 2021 18:16:06 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:16:06 +0300
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
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v4 06/17] af_vsock: implement send logic for SEQPACKET
Date:   Sun, 7 Feb 2021 18:15:57 +0300
Message-ID: <20210207151600.804998-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/06/2021 23:52:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161679 [Feb 06 2021]
X-KSE-AntiSpam-Info: LuaCore: 422 422 763e61bea9fcfcd94e075081cb96e065bc0509b4
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2021 23:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 2/6/2021 9:17:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/07 14:21:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/07 10:49:00 #16133380
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some logic to current stream enqueue function for SEQPACKET
support:
1) Send record's begin/end marker.
2) Return value from enqueue function is whole record length or error
   for SOCK_SEQPACKET.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 19f6f22821ec..198d58c4c7ee 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -136,6 +136,8 @@ struct vsock_transport {
 	bool (*stream_allow)(u32 cid, u32 port);
 
 	/* SEQ_PACKET. */
+	int (*seqpacket_seq_send_len)(struct vsock_sock *, size_t len, int flags);
+	int (*seqpacket_seq_send_eor)(struct vsock_sock *, int flags);
 	size_t (*seqpacket_seq_get_len)(struct vsock_sock *);
 	int (*seqpacket_dequeue)(struct vsock_sock *, struct msghdr *,
 				     int flags, bool *msg_ready);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ea99261e88ac..a033d3340ac4 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1806,6 +1806,12 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err < 0)
 		goto out;
 
+	if (sk->sk_type == SOCK_SEQPACKET) {
+		err = transport->seqpacket_seq_send_len(vsk, len, msg->msg_flags);
+		if (err < 0)
+			goto out;
+	}
+
 	while (total_written < len) {
 		ssize_t written;
 
@@ -1852,9 +1858,21 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	}
 
+	if (sk->sk_type == SOCK_SEQPACKET) {
+		err = transport->seqpacket_seq_send_eor(vsk, msg->msg_flags);
+		if (err < 0)
+			goto out;
+	}
+
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

