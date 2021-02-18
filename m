Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC29C31E5DF
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhBRFp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:45:28 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:44810 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhBRFlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:41:06 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 09B8B521479;
        Thu, 18 Feb 2021 08:38:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613626723;
        bh=UkMA/saO6FvbZvuFcdHqPerLc60kErife37FsL0ZOvg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=oPMkp8PVgh4PXD9YhA8Nn2edl19drI7vAMuI7hB7cpCkqVHHYEBkCaW6zioDquzQX
         RIy3J71tWCh6WUWF9gHxqIOn7B7AL3/sE8YVDMlca52HGwa23/kS66Ak0rHeKVmVpv
         G/+pJ+eB45MTm2xr61BErUiSUk+wdtArIYr/ChGXc6HJHjGTgJiXBDxZ9ppD4l5NQb
         bUJkeKQDSq4hgyaD2KunICz9c5LQQKjAIHTebC5j6lGlixnIu3IHGGJZm4w0Iu2cMW
         SA7S6J50e8TprWHYA67fchIEJOidhcTjWVquNkiaTsu7MkK5HrWlO+WBsV2Mob2lne
         UjajgbGLLyZHw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id AA761521245;
        Thu, 18 Feb 2021 08:38:42 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 18
 Feb 2021 08:38:19 +0300
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
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v5 06/19] af_vsock: implement send logic for SEQPACKET
Date:   Thu, 18 Feb 2021 08:38:11 +0300
Message-ID: <20210218053814.1067553-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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
X-KSE-Antivirus-Info: Clean, bases: 06.02.2021 21:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/18 04:51:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/18 04:31:00 #16269527
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
index 6fbe88306403..0d4dd9386fb1 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -136,6 +136,8 @@ struct vsock_transport {
 	bool (*stream_allow)(u32 cid, u32 port);
 
 	/* SEQ_PACKET. */
+	int (*seqpacket_seq_send_len)(struct vsock_sock *vsk, size_t len, int flags);
+	int (*seqpacket_seq_send_eor)(struct vsock_sock *vsk, int flags);
 	size_t (*seqpacket_seq_get_len)(struct vsock_sock *vsk);
 	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
 				     int flags, bool *msg_ready);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 09b377422b1e..f352cd9d91ce 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1801,6 +1801,12 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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
 
@@ -1847,9 +1853,21 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 
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

