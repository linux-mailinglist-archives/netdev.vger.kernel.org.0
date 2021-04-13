Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203CA35DF64
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbhDMMvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:51:04 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:59040 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345829AbhDMMsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:48:13 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 2DD4975FD9;
        Tue, 13 Apr 2021 15:47:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618318067;
        bh=T/iBLyY0/bbcse9xJzBWsyOYMbx9yUWYCR/JpsE3JkI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=RtCiRIk1oJ6rQejGyUYYWMUFUWm+Hw+zvQAFNVUDQdUCDD2ZjIDEaKLb9fhBp1SNd
         rxxY/JZaTqpeXbxhIb5gtkVTjUg1D4EguQZwXssLrUm2CDtBZ59SqnEgmKsF/+C+Nu
         oyuCC5RWOVqscWSwb1dQRjkHZ7qZbOGLMJF1i9VHjdc6BGfZQLYv+tpl/yNQQ+v7ra
         NGwCYHAsxu/+4ibRA2m8ERHco8c7tv9bOnTVgZ23zFOF9Hsbl/QuKldUPWz1Y3IZMp
         tigN3GD78EKYO/xUpJbRTZ/KG8r0tHlFtigNlDzwte9Flcqq6tzXOFRKGwd95UZSZ9
         bfYM3Dqv4+nMQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id ED50675FDE;
        Tue, 13 Apr 2021 15:47:46 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:47:46 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v8 19/19] af_vsock: serialize writes to shared socket
Date:   Tue, 13 Apr 2021 15:47:36 +0300
Message-ID: <20210413124739.3408031-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/13/2021 12:36:22
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163057 [Apr 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/13/2021 12:38:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.04.2021 10:53:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/13 07:05:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/13 03:14:00 #16587160
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This add logic, that serializes write access to single socket
by multiple threads. It is implemented be adding field with TID
of current writer. When writer tries to send something, it checks
that field is -1(free), else it sleep in the same way as waiting
for free space at peers' side.

This implementation is PoC and not related to SEQPACKET close, so
i've placed it after whole patchset.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/net/af_vsock.h   |  1 +
 net/vmw_vsock/af_vsock.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 53d3f33dbdbf..786df80b9fc3 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -69,6 +69,7 @@ struct vsock_sock {
 	u64 buffer_size;
 	u64 buffer_min_size;
 	u64 buffer_max_size;
+	pid_t tid_owner;
 
 	/* Private to transport. */
 	void *trans;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 54bee7e643f4..d00f8c07a9d3 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1765,7 +1765,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		ssize_t written;
 
 		add_wait_queue(sk_sleep(sk), &wait);
-		while (vsock_stream_has_space(vsk) == 0 &&
+		while ((vsock_stream_has_space(vsk) == 0 ||
+			(vsk->tid_owner != current->pid &&
+			 vsk->tid_owner != -1)) &&
 		       sk->sk_err == 0 &&
 		       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
 		       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
@@ -1796,6 +1798,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 				goto out_err;
 			}
 		}
+
+		vsk->tid_owner = current->pid;
 		remove_wait_queue(sk_sleep(sk), &wait);
 
 		/* These checks occur both as part of and after the loop
@@ -1852,7 +1856,10 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 			err = total_written;
 	}
 out:
+	vsk->tid_owner = -1;
 	release_sock(sk);
+	sk->sk_write_space(sk);
+
 	return err;
 }
 
@@ -2199,6 +2206,7 @@ static int vsock_create(struct net *net, struct socket *sock,
 		return -ENOMEM;
 
 	vsk = vsock_sk(sk);
+	vsk->tid_owner = -1;
 
 	if (sock->type == SOCK_DGRAM) {
 		ret = vsock_assign_transport(vsk, NULL);
-- 
2.25.1

