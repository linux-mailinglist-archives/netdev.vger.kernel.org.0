Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9563A115352
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 15:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfLFOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 09:39:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42049 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726258AbfLFOjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 09:39:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575643163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=t9EmvdK1AgBEeVtyIdQhFEC+nCx5dAL/M6REGeRF2KI=;
        b=A8u6dFx7I3AQ9vPjpD4oHMpe5QOUPE3N36xPugfLKDuaA98+bb1h7mDn/rQXjtk0m8xxt7
        I3Ug+bSW+15uBh2M0pUS4zhx+U12Klw/EVJOJn/Dnyy4AdnzqDZ8/L2ePuR/T35v4b3UFz
        kceOEZ5bil4v/g+AhHRp6U7jQlu49nA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-vn1BWFynNbyWxKfbUzJhhg-1; Fri, 06 Dec 2019 09:39:20 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F30F64A9B;
        Fri,  6 Dec 2019 14:39:19 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-106.ams2.redhat.com [10.36.117.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECF4D5C1C3;
        Fri,  6 Dec 2019 14:39:12 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Date:   Fri,  6 Dec 2019 15:39:12 +0100
Message-Id: <20191206143912.153583-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: vn1BWFynNbyWxKfbUzJhhg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we receive a new packet from the guest, we check if the
src_cid is correct, but we forgot to check the dst_cid.

The host should accept only packets where dst_cid is
equal to the host CID.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 50de0642dea6..c2d7d57e98cf 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -480,7 +480,9 @@ static void vhost_vsock_handle_tx_kick(struct vhost_wor=
k *work)
 =09=09virtio_transport_deliver_tap_pkt(pkt);
=20
 =09=09/* Only accept correctly addressed packets */
-=09=09if (le64_to_cpu(pkt->hdr.src_cid) =3D=3D vsock->guest_cid)
+=09=09if (le64_to_cpu(pkt->hdr.src_cid) =3D=3D vsock->guest_cid &&
+=09=09    le64_to_cpu(pkt->hdr.dst_cid) =3D=3D
+=09=09    vhost_transport_get_local_cid())
 =09=09=09virtio_transport_recv_pkt(&vhost_transport, pkt);
 =09=09else
 =09=09=09virtio_transport_free_pkt(pkt);
--=20
2.23.0

