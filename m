Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2EF3B5BFB
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhF1KF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:05:26 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:20842 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhF1KFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:05:24 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 8D7CE77F59;
        Mon, 28 Jun 2021 13:02:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874576;
        bh=NJOZMhSgQ+s/Y883Y1pEuov5228wix81ySV27bjgqwQ=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=sm7tj7Dmaootfaa78M8a29yr4tXPkR2Iyps1CVsju5TF9ie3V9SBiwYAuXiHImoJB
         fZ1iSFtlScj50RNM8lYgoXforHhCo7ZLqJ6FqMv7HiIUgVZgRgwmzpEg1lOLs7c8kp
         ZrEeS9ylrgAL580aaQiz3MrEXrwlDOT92IYpTX6j85OUfjcMjZmDsulbSqeH0iadvj
         jqnqOtdM8IpWvS+72RS9SkSnuUxRPb295Br+kBZ8LABQkxSo9RT1mwbI80vlPk1/cu
         o/68AoABP3rkOrRMfMkc/o7VBkH4D+rh5PFDBogRlEpYmu4wwD0YH4BzxP/I4LtX73
         ga37u4Ie1byyg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 5606677F5E;
        Mon, 28 Jun 2021 13:02:56 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:02:55 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 05/16] af_vsock: use SOCK_STREAM function to check data
Date:   Mon, 28 Jun 2021 13:02:47 +0300
Message-ID: <20210628100250.570726-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/28/2021 09:47:58
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164664 [Jun 28 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/28/2021 09:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 28.06.2021 5:59:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/28 08:23:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/28 05:40:00 #16806866
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also remove 'seqpacket_has_data' callback from transport.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/net/af_vsock.h   |  1 -
 net/vmw_vsock/af_vsock.c | 12 +-----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index ab207677e0a8..bf5ea1873e6f 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -141,7 +141,6 @@ struct vsock_transport {
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
 	bool (*seqpacket_allow)(u32 remote_cid);
-	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 21ccf450e249..59ce35da2e5b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -860,16 +860,6 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
 
-static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
-{
-	struct sock *sk = sk_vsock(vsk);
-
-	if (sk->sk_type == SOCK_SEQPACKET)
-		return vsk->transport->seqpacket_has_data(vsk);
-	else
-		return vsock_stream_has_data(vsk);
-}
-
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
 	return vsk->transport->stream_has_space(vsk);
@@ -1881,7 +1871,7 @@ static int vsock_connectible_wait_data(struct sock *sk,
 	err = 0;
 	transport = vsk->transport;
 
-	while ((data = vsock_connectible_has_data(vsk)) == 0) {
+	while ((data = vsock_stream_has_data(vsk)) == 0) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
 
 		if (sk->sk_err != 0 ||
-- 
2.25.1

