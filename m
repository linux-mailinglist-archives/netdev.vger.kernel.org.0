Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B118E30F18
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfEaNkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfEaNk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 09:40:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 18D2B9FFE8;
        Fri, 31 May 2019 13:40:29 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-15.ams2.redhat.com [10.36.117.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16BEC5D719;
        Fri, 31 May 2019 13:40:25 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 5/5] vsock/virtio: change the maximum packet size allowed
Date:   Fri, 31 May 2019 15:39:54 +0200
Message-Id: <20190531133954.122567-6-sgarzare@redhat.com>
In-Reply-To: <20190531133954.122567-1-sgarzare@redhat.com>
References: <20190531133954.122567-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 31 May 2019 13:40:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since now we are able to split packets, we can avoid limiting
their sizes to VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE.
Instead, we can use VIRTIO_VSOCK_MAX_PKT_BUF_SIZE as the max
packet size.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d192cb91cf25..b6ec6f81018b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -182,8 +182,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	vvs = vsk->trans;
 
 	/* we can send less than pkt_len bytes */
-	if (pkt_len > VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE)
-		pkt_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
+	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
 
 	/* virtio_transport_get_credit might return less than pkt_len credit */
 	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
-- 
2.20.1

