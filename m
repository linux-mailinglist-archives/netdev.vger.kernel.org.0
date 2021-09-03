Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5359F3FFA34
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbhICGQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:16:50 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:42914 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344995AbhICGQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 02:16:48 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 51834759BD;
        Fri,  3 Sep 2021 09:15:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1630649747;
        bh=BqPoCBij9vew1YAREWzZw8o1lWcwQO0IauqQhBCy4lM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=CUurtfQEksnzeycgwv9Kfcww+g5tJnzPevWvtIEUhRflfzCocj+4ehRNZdv0ctq04
         wUADFKz73DWLaznqJ9LWUDS1Jpl5Bdi4Vxe5U7OX58Vu53ZTM1S2vTdylKipSrzmKR
         2E6F5ileagM1AOjz84hXLb7OBEy52EuGORiIPlojszuRz16DJYSPLXTLAgyDwOnweW
         8mLRLwl2rOEnpaRKxYFzZ4VD43YB+Sf3tC0+tqx8DS5JpGEvcfoeXFeWZeZXymgFUp
         nZPsWFATba+zrQxF85HRGArVVS9DadJZKNBdiw79taxnxWLppBjFCl7FY+DnNF6y5A
         SdlHrlNCd7i4Q==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 0D3B2759B7;
        Fri,  3 Sep 2021 09:15:47 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 3
 Sep 2021 09:15:46 +0300
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
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [PATCH net-next v4 3/6] vhost/vsock: support MSG_EOR bit processing
Date:   Fri, 3 Sep 2021 09:15:38 +0300
Message-ID: <20210903061541.3187840-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
References: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 09/03/2021 05:49:39
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165946 [Sep 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 461 461 c95454ca24f64484bdf56c7842a96dd24416624e
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/03/2021 05:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 03.09.2021 4:06:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/09/03 04:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/09/03 02:56:00 #17151492
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'MSG_EOR' handling has similar logic as 'MSG_EOM' - if bit present
in packet's header, reset it to 0. Then restore it back if packet
processing wasn't completed. Instead of bool variable for each
flag, bit mask variable was added: it has logical OR of 'MSG_EOR'
and 'MSG_EOM' if needed, to restore flags, this variable is ORed
with flags field of packet.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index feaf650affbe..93e8d635e18f 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -114,7 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		size_t nbytes;
 		size_t iov_len, payload_len;
 		int head;
-		bool restore_flag = false;
+		u32 flags_to_restore = 0;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -179,15 +179,20 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			 * created dynamically and are initialized with header
 			 * of current packet(except length). But in case of
 			 * SOCK_SEQPACKET, we also must clear message delimeter
-			 * bit(VIRTIO_VSOCK_SEQ_EOM). Otherwise, instead of one
-			 * packet with delimeter(which marks end of message),
-			 * there will be sequence of packets with delimeter
-			 * bit set. After initialized header will be copied to
-			 * rx buffer, this bit will be restored.
+			 * bit (VIRTIO_VSOCK_SEQ_EOM) and MSG_EOR bit
+			 * (VIRTIO_VSOCK_SEQ_EOR) if set. Otherwise,
+			 * there will be sequence of packets with these
+			 * bits set. After initialized header will be copied to
+			 * rx buffer, these required bits will be restored.
 			 */
 			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
 				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
-				restore_flag = true;
+				flags_to_restore |= VIRTIO_VSOCK_SEQ_EOM;
+
+				if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
+					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
+				}
 			}
 		}
 
@@ -224,8 +229,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 * to send it with the next available buffer.
 		 */
 		if (pkt->off < pkt->len) {
-			if (restore_flag)
-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
 
 			/* We are queueing the same virtio_vsock_pkt to handle
 			 * the remaining bytes, and we want to deliver it
-- 
2.25.1

