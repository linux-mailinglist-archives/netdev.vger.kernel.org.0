Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8663BAC08
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhGDINj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:13:39 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:54670 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhGDINh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:13:37 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 085B275BEE;
        Sun,  4 Jul 2021 11:11:01 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625386261;
        bh=LuJjRY82zTnA9mN/A9Qke4o/Lwm3BTwLfaEmmDDmvXQ=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=JMAdMTRYWA7Yi0xCQGA25BI9ElWtFAiZloQ4hbrE8LYmI1nPO2OeCUxrFKnOzhWCF
         sU6x1r/sHWXSIZB5Cyz48UYsnuxNfcKN9zYGaXUm3ntP5z28rQEz3EBh1HZb0NAwW1
         F2cl22MW3h02RHoUVV3FVx78onX7RcMy3IdvRG3GRBAy+TPLRQCX+W0eIraCMpSJ5e
         nisG3+2jPg5KxSL9X1JzipU81uZD04azZoHIguApEGh4H+K+k6Dkxzvjqsqhr+foVb
         4dKCh+/WZBOLH7o8VcjeQf6cxJADhtqWNA3vjwhime2rnwXI//aIGDDcv4SsYdccLK
         t+7vw7gq2DGCg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id C447C7708E;
        Sun,  4 Jul 2021 11:11:00 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Sun, 4
 Jul 2021 11:11:00 +0300
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
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 5/6] virtio/vsock: remove record size limit for SEQPACKET
Date:   Sun, 4 Jul 2021 11:10:52 +0300
Message-ID: <20210704081055.89685-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/04/2021 07:43:44
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164820 [Jul 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/04/2021 07:45:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.07.2021 5:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/04 06:12:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/04 01:03:00 #16855183
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove record size limit which was 'peer_buf_alloc' value.
New approach doesn't need this, because data is copied to
user's buffer in stream manner(we don't wait until whole
record is received).

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/virtio_transport_common.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 52765754edcd..5cfdf701a8af 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -507,17 +507,6 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
 				   size_t len)
 {
-	struct virtio_vsock_sock *vvs = vsk->trans;
-
-	spin_lock_bh(&vvs->tx_lock);
-
-	if (len > vvs->peer_buf_alloc) {
-		spin_unlock_bh(&vvs->tx_lock);
-		return -EMSGSIZE;
-	}
-
-	spin_unlock_bh(&vvs->tx_lock);
-
 	return virtio_transport_stream_enqueue(vsk, msg, len);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
-- 
2.25.1

