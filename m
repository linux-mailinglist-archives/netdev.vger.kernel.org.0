Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEEB45D48F
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347154AbhKYGLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:11:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346397AbhKYGJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:09:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637820365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1irKUJW33SWAxC/Ee23IycmsJtDByo2UcVUyInCyu64=;
        b=ZxB/8Erqy/7ViRShwWs901n0AH/Ro5ZFzk3YCrr/mnYAsMUIKibEPOy2vw6eD3Ey+/5Mru
        yTqUHIDTpM9vU2OvjzrsN74BNgmYQdnwtnKzhZCiBFNoThknwFFYq8Lr8JpgOs/GCKqrwu
        xq/HT4xL8mw+CouINxgb7OOAamA8oJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-Yjjv7UETM-aFQhwCBHqOUA-1; Thu, 25 Nov 2021 01:06:04 -0500
X-MC-Unique: Yjjv7UETM-aFQhwCBHqOUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3D778042E2;
        Thu, 25 Nov 2021 06:06:02 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-162.pek2.redhat.com [10.72.12.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EA545F4ED;
        Thu, 25 Nov 2021 06:05:49 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eli Cohen <elic@nvidia.com>
Subject: [PATCH net] virtio-net: enable big mode correctly
Date:   Thu, 25 Nov 2021 14:05:47 +0800
Message-Id: <20211125060547.11961-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
large max_mtu. In this case, using small packet mode is not correct
since it may breaks the networking when MTU is grater than
ETH_DATA_LEN.

To have a quick fix, simply enable the big packet mode when
VIRTIO_NET_F_MTU is not negotiated. We can do optimization on top.

Reported-by: Eli Cohen <elic@nvidia.com>
Cc: Eli Cohen <elic@nvidia.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7c43bfc1ce44..83ae3ef5eb11 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
 		dev->mtu = mtu;
 		dev->max_mtu = mtu;
 
-		/* TODO: size buffers correctly in this case. */
-		if (dev->mtu > ETH_DATA_LEN)
-			vi->big_packets = true;
 	}
 
+	/* TODO: size buffers correctly in this case. */
+	if (dev->max_mtu > ETH_DATA_LEN)
+		vi->big_packets = true;
+
 	if (vi->any_header_sg)
 		dev->needed_headroom = vi->hdr_len;
 
-- 
2.25.1

