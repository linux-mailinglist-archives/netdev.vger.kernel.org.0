Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC691B78DB
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgDXPI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:08:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37008 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726717AbgDXPI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587740935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9R6yjveOElwyTut93FZB4NDQJHLkZZ8HkoqOG3/TEPw=;
        b=H7fa5u3kq0iFqt+1pKZuspjKSk54jXe5JXcnYGxX/Rhxx+ehHdRj2Lf4nGqLnfw40lD6ZS
        Smvkc6VB0nnnalAclJXEXvFHlGiE1IUqCJ6H0ElI98ZF1AYJYEx6s1jmv9i87I0xJMQ9Ec
        JUQoqsfZnnbcNI8m98wTAhxQc3ve/do=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-iTW-gitIMiyiT6Du8TpJbg-1; Fri, 24 Apr 2020 11:08:51 -0400
X-MC-Unique: iTW-gitIMiyiT6Du8TpJbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBD7E1005510;
        Fri, 24 Apr 2020 15:08:36 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-43.ams2.redhat.com [10.36.114.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71AC55D70C;
        Fri, 24 Apr 2020 15:08:34 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jason Wang <jasowang@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net v2 1/2] vhost/vsock: fix packet delivery order to monitoring devices
Date:   Fri, 24 Apr 2020 17:08:29 +0200
Message-Id: <20200424150830.183113-2-sgarzare@redhat.com>
In-Reply-To: <20200424150830.183113-1-sgarzare@redhat.com>
References: <20200424150830.183113-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to deliver packets to monitoring devices before it is
put in the virtqueue, to avoid that replies can appear in the
packet capture before the transmitted packet.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 97669484a3f6..18aff350a405 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -181,14 +181,14 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vso=
ck,
 			break;
 		}
=20
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
-		added =3D true;
-
-		/* Deliver to monitoring devices all correctly transmitted
-		 * packets.
+		/* Deliver to monitoring devices all packets that we
+		 * will transmit.
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
=20
+		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
+		added =3D true;
+
 		pkt->off +=3D payload_len;
 		total_len +=3D payload_len;
=20
--=20
2.25.3

