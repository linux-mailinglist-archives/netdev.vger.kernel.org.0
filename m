Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4C1C684C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEFGQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:16:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726937AbgEFGQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588745808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9cPGlRr13R9dEpHsCHTbKzUmba6essHkh9NkHk5FoYQ=;
        b=i59nsQnXXKKJ5S4BEVPJ98gY8k3YkRjplXbnXCpFypjRDzXu9WO/jIK9Z0OD1ZwFMpkvJw
        l43KVe8SDaoLiK8dPPpa1YiTLCSqqJ2US0qfNdMS7wS94vlGYrBSxqiDdo4GArAj4wvFMh
        YWAjaLgft+Of5qSYnDRJ+9u2h2gv830=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-IzUrd-WrNhCFIgkZxw2F0w-1; Wed, 06 May 2020 02:16:44 -0400
X-MC-Unique: IzUrd-WrNhCFIgkZxw2F0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2B97EC1A0;
        Wed,  6 May 2020 06:16:43 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70BBC5C1D4;
        Wed,  6 May 2020 06:16:35 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH net-next 1/2] virtio-net: don't reserve space for vnet header for XDP
Date:   Wed,  6 May 2020 14:16:32 +0800
Message-Id: <20200506061633.16327-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We tried to reserve space for vnet header before
xdp.data_hard_start. But this is useless since the packet could be
modified by XDP which may invalidate the information stored in the
header and there's no way for XDP to know the existence of the vnet
header currently.

So let's just not reserve space for vnet header in this case.

Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 11f722460513..98dd75b665a5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -684,8 +684,8 @@ static struct sk_buff *receive_small(struct net_devic=
e *dev,
 			page =3D xdp_page;
 		}
=20
-		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD + vi->hdr_len;
-		xdp.data =3D xdp.data_hard_start + xdp_headroom;
+		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD;
+		xdp.data =3D xdp.data_hard_start + xdp_headroom + vi->hdr_len;
 		xdp.data_end =3D xdp.data + len;
 		xdp.data_meta =3D xdp.data;
 		xdp.rxq =3D &rq->xdp_rxq;
@@ -845,7 +845,7 @@ static struct sk_buff *receive_mergeable(struct net_d=
evice *dev,
 		 * the descriptor on if we get an XDP_TX return code.
 		 */
 		data =3D page_address(xdp_page) + offset;
-		xdp.data_hard_start =3D data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
+		xdp.data_hard_start =3D data - VIRTIO_XDP_HEADROOM;
 		xdp.data =3D data + vi->hdr_len;
 		xdp.data_end =3D xdp.data + (len - vi->hdr_len);
 		xdp.data_meta =3D xdp.data;
--=20
2.20.1

