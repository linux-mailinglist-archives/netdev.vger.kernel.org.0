Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969301B22A2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgDUJZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:25:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36985 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728383AbgDUJZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 05:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587461137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s6kZIJazKnfeWw9rqRwxCTiV7lo+E1jRmgFL7mG8v1w=;
        b=PU/ARCnzbHoIRw+5duN7yCVlaG+rYGBTgq6xo5xCGcjPJGdPAfoI5Y/KFqgvNJuEh2cLdE
        QEM63eIFH43krdmX1Pahv763B0cevLwlT1LGgCGnqZbdkvA4D/taptJdFz/qSszOibq9ep
        xbqwtS7ZLK2sQVfapxH9e5eTDlDlcC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-pZMfjWLMOayjYnBl4uIC7Q-1; Tue, 21 Apr 2020 05:25:36 -0400
X-MC-Unique: pZMfjWLMOayjYnBl4uIC7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFCE48017F3;
        Tue, 21 Apr 2020 09:25:34 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-101.ams2.redhat.com [10.36.114.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A499A60C87;
        Tue, 21 Apr 2020 09:25:28 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Gerard Garcia <ggarcia@abra.uab.cat>
Subject: [PATCH net] vsock/virtio: postpone packet delivery to monitoring devices
Date:   Tue, 21 Apr 2020 11:25:27 +0200
Message-Id: <20200421092527.41651-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We delivering packets to monitoring devices, before to check if
the virtqueue has enough space.

If the virtqueue is full, the transmitting packet is queued up
and it will be sent in the next iteration. This causes the same
packet to be delivered multiple times to monitoring devices.

This patch fixes this issue, postponing the packet delivery
to monitoring devices, only when it is properly queued in the
virqueue.

Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
index dfbaf6bd8b1c..d8db837a96fe 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -115,8 +115,6 @@ virtio_transport_send_pkt_work(struct work_struct *wo=
rk)
 		list_del_init(&pkt->list);
 		spin_unlock_bh(&vsock->send_pkt_list_lock);
=20
-		virtio_transport_deliver_tap_pkt(pkt);
-
 		reply =3D pkt->reply;
=20
 		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
@@ -137,6 +135,11 @@ virtio_transport_send_pkt_work(struct work_struct *w=
ork)
 			break;
 		}
=20
+		/* Deliver to monitoring devices all correctly transmitted
+		 * packets.
+		 */
+		virtio_transport_deliver_tap_pkt(pkt);
+
 		if (reply) {
 			struct virtqueue *rx_vq =3D vsock->vqs[VSOCK_VQ_RX];
 			int val;
--=20
2.25.3

