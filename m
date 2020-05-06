Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734FC1C6849
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgEFGQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:16:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55916 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727824AbgEFGQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588745812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AfWTvjFJDL5wYV2ZbXSYiOFLkMGDFarHl694AF23Z14=;
        b=SUq4VIRSvhNrPF02oF7vGSV/n45+gnN90jC4enyCCu9dhG++bdqrmuM9SWAzKAZ6ik/6SZ
        0ihb/gLxbGy+HQZviJb+kwimx+DtyN/gD/7O3gtarpYLoxbPDw2AajfVzx0AjSjLAHVIHH
        vIKwNx4bq3IhmgSGTNonlRO2Tg80pko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-Uxs1rhM2N06BGeh0kM_DQw-1; Wed, 06 May 2020 02:16:48 -0400
X-MC-Unique: Uxs1rhM2N06BGeh0kM_DQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23811464;
        Wed,  6 May 2020 06:16:47 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EEFF5C241;
        Wed,  6 May 2020 06:16:43 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH net-next 2/2] virtio-net: fix the XDP truesize calculation for mergeable buffers
Date:   Wed,  6 May 2020 14:16:33 +0800
Message-Id: <20200506061633.16327-2-jasowang@redhat.com>
In-Reply-To: <20200506061633.16327-1-jasowang@redhat.com>
References: <20200506061633.16327-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not exclude headroom and tailroom when XDP is set. So this
patch fixes this by initializing the truesize from PAGE_SIZE when XDP
is set.

Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 98dd75b665a5..3f3aa8308918 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1184,7 +1184,7 @@ static int add_recvbuf_mergeable(struct virtnet_inf=
o *vi,
 	char *buf;
 	void *ctx;
 	int err;
-	unsigned int len, hole;
+	unsigned int len, hole, truesize;
=20
 	/* Extra tailroom is needed to satisfy XDP's assumption. This
 	 * means rx frags coalescing won't work, but consider we've
@@ -1194,6 +1194,7 @@ static int add_recvbuf_mergeable(struct virtnet_inf=
o *vi,
 	if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
 		return -ENOMEM;
=20
+	truesize =3D headroom ? PAGE_SIZE : len;
 	buf =3D (char *)page_address(alloc_frag->page) + alloc_frag->offset;
 	buf +=3D headroom; /* advance address leaving hole at front of pkt */
 	get_page(alloc_frag->page);
@@ -1205,11 +1206,12 @@ static int add_recvbuf_mergeable(struct virtnet_i=
nfo *vi,
 		 * the current buffer.
 		 */
 		len +=3D hole;
+		truesize +=3D hole;
 		alloc_frag->offset +=3D hole;
 	}
=20
 	sg_init_one(rq->sg, buf, len);
-	ctx =3D mergeable_len_to_ctx(len, headroom);
+	ctx =3D mergeable_len_to_ctx(truesize, headroom);
 	err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0)
 		put_page(virt_to_head_page(buf));
--=20
2.20.1

