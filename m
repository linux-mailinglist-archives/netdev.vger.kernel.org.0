Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B7C3ED0A0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhHPIxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:53:09 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:11698 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbhHPIxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:53:05 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 0C864520F2C;
        Mon, 16 Aug 2021 11:52:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1629103950;
        bh=K9e95vKrX+vI3giEHBb/r5WlATln69n3y2C0yRMrXCE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=bN/U1BU2frI9QgVluNQAqwDiIJb5xslpeOfJftuQrbhZpdS+0fcvBsF0YaMpJfHgW
         btf7Ag0tn5esRF0j1O+X1o6i1Z7yc7eSdeUAj64eDyRVrNycVS+TTZAsMPqSG8ZTI8
         cCyNO1DuEdp6N/qPUsqs+1EsfxduVj1e4neNdRY+jayjVnSuGu5j90606FxbB4sHWl
         FoA1UvsBnNUIXcyLYu/4OGJh0dj1jShv+js/syELXISfVNfPca/XqtsuI5yMOKr93h
         UcG+HhvCmSnroiQESOReg8n7VdsmHoovRoRwvSXSmCvKMWK5iidCiDTgDs/H6pwYJG
         0ZUKHuTCAwnHg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id C1EA0520FCD;
        Mon, 16 Aug 2021 11:52:29 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.16.171.77) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 16
 Aug 2021 11:52:29 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.co>
Subject: [RFC PATCH v3 4/6] virtio/vsock: support MSG_EOR bit processing
Date:   Mon, 16 Aug 2021 11:52:20 +0300
Message-ID: <20210816085223.4174366-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.16.171.77]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/16/2021 08:40:34
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165570 [Aug 16 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/16/2021 08:42:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 16.08.2021 4:09:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/16 06:42:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/16 02:10:00 #17042267
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If packet has 'EOR' bit - set MSG_EOR in 'recvmsg()' flags.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 4d5a93beceb0..59ee1be5a6dd 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -76,8 +76,12 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 			goto out;
 
 		if (msg_data_left(info->msg) == 0 &&
-		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
+		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
 			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+
+			if (info->msg->msg_flags & MSG_EOR)
+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+		}
 	}
 
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
@@ -460,6 +464,9 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
 			msg_ready = true;
 			vvs->msg_count--;
+
+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
+				msg->msg_flags |= MSG_EOR;
 		}
 
 		virtio_transport_dec_rx_pkt(vvs, pkt);
-- 
2.25.1

