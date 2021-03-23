Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F171C345F55
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhCWNQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:16:38 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:32467 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhCWNPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:15:15 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 79F1576859;
        Tue, 23 Mar 2021 16:15:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505312;
        bh=OR8kR+7kRVbqH+d8r/EG2Iprd9hqIkh/rAcgS4VwKRk=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=O8LO0rX4gOkOTB1POg3ea6hi3CVu11NY0fWa3d/vF7OlbhwgBadyVDE44EfuTtIFt
         edF1qETTvJ8/ru9a+FMjZlczP76ltFkatfjuukp8ChMZ4Gdc72J0Zbm2sjmH/eDAMc
         26JxkjTstdKvjFsTwLSYhweYxIfFJhDklSkjuabUzsWCquw4bE01ohLgHJrWA055cR
         6RsnxmmdBA2I4w/VdnWbaAiW2JiQzb4e123XTrxduTA2gkAbUUEicHGVQD4cOs/9tw
         898NdedvnEg4RekqDMWgLmt0Xk+dODrl2UVTkKDITbI8gurs6Lfpvwo74mtvSrDcqV
         kfU/Xwdxb5xmg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 3B3007686F;
        Tue, 23 Mar 2021 16:15:12 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:15:11 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 20/22] virtio/vsock: SEQPACKET feature bit support
Date:   Tue, 23 Mar 2021 16:15:02 +0300
Message-ID: <20210323131505.2462107-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
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

This adds handling of SEQPACKET bit: guest tries to negotiate it
with vhost.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/virtio_transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 83ae2078c847..ee99bd919a12 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -624,6 +624,10 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
+
+	if (vdev->features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
+		virtio_transport.seqpacket_allow = true;
+
 	return 0;
 
 out:
@@ -707,6 +711,7 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
+	VIRTIO_VSOCK_F_SEQPACKET
 };
 
 static struct virtio_driver virtio_vsock_driver = {
-- 
2.25.1

