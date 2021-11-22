Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCBB459337
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbhKVQkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:40:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240287AbhKVQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637599053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FtiMabVFYcwNMDFttEd/wf2XPW5romYn4RuDWOa8zdA=;
        b=ahuZKvgfN3iNn85/FF6vt7hV8m0XHGmZDYk59xL1vGEW1EskK4qkaA+NwuGvMDoaSEaCAa
        nyl5SZb4nEpjhnlVCf/EVfJibv6Dji4nOic0pI5mPioe49s3OBrRYJ9oQyjiKGbPg2fE5r
        vri+F4DV9atmrHGum3+Gwy+RM+Rulwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-YXZzuXfLNl6_9piSG5gpeQ-1; Mon, 22 Nov 2021 11:37:30 -0500
X-MC-Unique: YXZzuXfLNl6_9piSG5gpeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED2501851723;
        Mon, 22 Nov 2021 16:37:28 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.39.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17B2B60CC4;
        Mon, 22 Nov 2021 16:36:45 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 2/2] vhost/vsock: cleanup removing `len` variable
Date:   Mon, 22 Nov 2021 17:35:25 +0100
Message-Id: <20211122163525.294024-3-sgarzare@redhat.com>
In-Reply-To: <20211122163525.294024-1-sgarzare@redhat.com>
References: <20211122163525.294024-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can increment `total_len` directly and remove `len` since it
is no longer used for vhost_add_used().

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 4e3b95af7ee4..d6ca1c7ad513 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -511,8 +511,6 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 
 	vhost_disable_notify(&vsock->dev, vq);
 	do {
-		u32 len;
-
 		if (!vhost_vsock_more_replies(vsock)) {
 			/* Stop tx until the device processes already
 			 * pending replies.  Leave tx virtqueue
@@ -540,7 +538,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			continue;
 		}
 
-		len = pkt->len;
+		total_len += sizeof(pkt->hdr) + pkt->len;
 
 		/* Deliver to monitoring devices all received packets */
 		virtio_transport_deliver_tap_pkt(pkt);
@@ -553,9 +551,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		else
 			virtio_transport_free_pkt(pkt);
 
-		len += sizeof(pkt->hdr);
 		vhost_add_used(vq, head, 0);
-		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 
-- 
2.31.1

