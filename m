Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE0C33C23F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhCOQh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:37:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234451AbhCOQhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:37:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/EEuFoOcyPn1SUcWyeJ5vYdXnhD/91DvFQCCSz3fhQ=;
        b=VvCVULxMs36bpAwlbyCQSQo2/D/hx1NWFkQaGaWE9RLVioZfw3GQ67zORJia8bO6XHbBlm
        cfFtLQpf/Lsk2zIJDewjC1q/1n2SR+trwT8mLBrtPCdy+WKegfVuer0ES7RVW1Fx0sg4Si
        sApL2+swntNNWs9jcOWaPMsYKrLxtGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-FebLI3jpM9CFVelpKa80mQ-1; Mon, 15 Mar 2021 12:37:01 -0400
X-MC-Unique: FebLI3jpM9CFVelpKa80mQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 787228015BD;
        Mon, 15 Mar 2021 16:37:00 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 295415D745;
        Mon, 15 Mar 2021 16:36:57 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 13/14] vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID
Date:   Mon, 15 Mar 2021 17:34:49 +0100
Message-Id: <20210315163450.254396-14-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle VIRTIO_BLK_T_GET_ID request, always answering the
"vdpa_blk_sim" string.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
- made 'vdpasim_blk_id' static [Jason]
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index a31964e3e5a4..643ae3bc62c0 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -38,6 +38,7 @@
 #define VDPASIM_BLK_VQ_NUM	1
 
 static struct vdpasim *vdpasim_blk_dev;
+static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
 
 static bool vdpasim_blk_check_range(u64 start_sector, size_t range_size)
 {
@@ -153,6 +154,20 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 		}
 		break;
 
+	case VIRTIO_BLK_T_GET_ID:
+		bytes = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
+					      vdpasim_blk_id,
+					      VIRTIO_BLK_ID_BYTES);
+		if (bytes < 0) {
+			dev_err(&vdpasim->vdpa.dev,
+				"vringh_iov_push_iotlb() error: %zd\n", bytes);
+			status = VIRTIO_BLK_S_IOERR;
+			break;
+		}
+
+		pushed += bytes;
+		break;
+
 	default:
 		dev_warn(&vdpasim->vdpa.dev,
 			 "Unsupported request type %d\n", type);
-- 
2.30.2

