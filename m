Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B236450898
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhKOPgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236744AbhKOPfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:35:53 -0500
X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Nov 2021 07:32:54 PST
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B9DC061746;
        Mon, 15 Nov 2021 07:32:53 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 409852E19E8;
        Mon, 15 Nov 2021 18:30:12 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 4kjSL7beQi-UAsOdLEL;
        Mon, 15 Nov 2021 18:30:12 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636990212; bh=GlOkmmUmvZe+2AHwSMb9cmJpOchbYOYLJWd/enrIgu4=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=0mmMm9uhNOX1N2sppJ2E77jr/2P7+txxsmUsHKJOD+NSi5lBV+wBRWWpi8EYiq5un
         F6G3aZSKlKk04QOd9X896tDgrEICeLaCGv5FwHJn6a3uSCMuc+3Z+FjlU136hb5zaJ
         B9bR+tNPRM72AIQXBtmNA+f/dVnhUwZSX4IaNkQw=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id wuqDqjnGag-UAxaSEYM;
        Mon, 15 Nov 2021 18:30:10 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andrey Ryabinin <arbn@yandex-team.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] vhost_net: get rid of vhost_net_flush_vq() and extra flush calls
Date:   Mon, 15 Nov 2021 18:29:59 +0300
Message-Id: <20211115153003.9140-2-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115153003.9140-1-arbn@yandex-team.com>
References: <20211115153003.9140-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_net_flush_vq() calls vhost_work_dev_flush() twice passing
vhost_dev pointer obtained via 'n->poll[index].dev' and
'n->vqs[index].vq.poll.dev'. This is actually the same pointer,
initialized in vhost_net_open()/vhost_dev_init()/vhost_poll_init()

Remove vhost_net_flush_vq() and call vhost_work_dev_flush() directly.
Do the flushes only once instead of several flush calls in a row
which seems rather useless.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/vhost/net.c   | 11 ++---------
 drivers/vhost/vhost.h |  1 +
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 11221f6d11b8..b1feb5e0571e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1373,16 +1373,9 @@ static void vhost_net_stop(struct vhost_net *n, struct socket **tx_sock,
 	*rx_sock = vhost_net_stop_vq(n, &n->vqs[VHOST_NET_VQ_RX].vq);
 }
 
-static void vhost_net_flush_vq(struct vhost_net *n, int index)
-{
-	vhost_work_dev_flush(n->poll[index].dev);
-	vhost_work_dev_flush(n->vqs[index].vq.poll.dev);
-}
-
 static void vhost_net_flush(struct vhost_net *n)
 {
-	vhost_net_flush_vq(n, VHOST_NET_VQ_TX);
-	vhost_net_flush_vq(n, VHOST_NET_VQ_RX);
+	vhost_work_dev_flush(&n->dev);
 	if (n->vqs[VHOST_NET_VQ_TX].ubufs) {
 		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
 		n->tx_flush = true;
@@ -1572,7 +1565,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	}
 
 	if (oldsock) {
-		vhost_net_flush_vq(n, index);
+		vhost_work_dev_flush(&n->dev);
 		sockfd_put(oldsock);
 	}
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 638bb640d6b4..ecbaa5c6005f 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -15,6 +15,7 @@
 #include <linux/vhost_iotlb.h>
 #include <linux/irqbypass.h>
 
+struct vhost_dev;
 struct vhost_work;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
 
-- 
2.32.0

