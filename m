Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED62D6BB66
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 13:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731919AbfGQLbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 07:31:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731609AbfGQLa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 07:30:56 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B716C3082B3F;
        Wed, 17 Jul 2019 11:30:56 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-116-100.ams2.redhat.com [10.36.116.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A42EB5C28C;
        Wed, 17 Jul 2019 11:30:54 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v4 5/5] vsock/virtio: change the maximum packet size allowed
Date:   Wed, 17 Jul 2019 13:30:30 +0200
Message-Id: <20190717113030.163499-6-sgarzare@redhat.com>
In-Reply-To: <20190717113030.163499-1-sgarzare@redhat.com>
References: <20190717113030.163499-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 17 Jul 2019 11:30:56 +0000 (UTC)
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
index 56fab3f03d0e..94cc0fa3e848 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -181,8 +181,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
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

