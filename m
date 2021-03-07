Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39F43303B1
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 19:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhCGSEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 13:04:00 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:58178 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhCGSDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 13:03:53 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id D59AC77860;
        Sun,  7 Mar 2021 21:03:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615140231;
        bh=LueituxC7On/h0SmCJvR/UXKnimX9FnQgNh7NYBbuHw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=j5kyQHeDeQz+1vfvqHqNEs4I/ytA1UC3EkIN8KPjf4SM6LiAlAB/1sDl8tqAzjuyB
         B6CqvokTYqyb6mfxd/vn7VOk0d6/GyoyWJfarEo3UgoAbXgVKvL1n9DDihuuT94uTi
         vN/LD5QRSBQ/IuQVkXc0X9tHDwYWQt0hRAB62XEIM5umh8QTTCL4rb7PTRjjVchTNT
         XZwAgFAaHq+xpw71Mx1Hq6LpNc0cstxA0V6O+Z2SKkdS23HbQL7DdpvXA6kxPeGW5m
         yluXqPNzbldScVBX8PMUI1ue8FSHJy3PqKd4jZ2n4nwmy3BoK2AmjQ7mVvZW5ZV2HR
         ZKSfEf9Wo6Rew==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 2E70077869;
        Sun,  7 Mar 2021 21:03:51 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 7 Mar
 2021 21:03:50 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v6 16/22] vhost/vsock: SEQPACKET feature bit support
Date:   Sun, 7 Mar 2021 21:03:41 +0300
Message-ID: <20210307180344.3466469-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
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
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
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

This adds handling of SEQPACKET bit: if guest sets features with
this bit cleared, then SOCK_SEQPACKET support will be disabled.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..3b0a50e6de12 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -31,7 +31,8 @@
 
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
 };
 
 enum {
@@ -785,6 +786,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 			goto err;
 	}
 
+	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
+		vhost_transport.seqpacket_allow = true;
+
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
 		mutex_lock(&vq->mutex);
-- 
2.25.1

