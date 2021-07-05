Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0597D3BB7AD
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 09:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGEHWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 03:22:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhGEHWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 03:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625469570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AsZSFMJJkoJGWjbavb6OT4THQJwUV8GZhfv+a3hztGw=;
        b=BuG0yfRk291+TgiriLkxeTmUyY+11wK33rjA0oA/mooeOKlR0qDaMlLXvXcsSDm3//cuKK
        hm0ablxOxmjtZYlqv9mDAxO4k6FAWHjiTqMEn+c1IM6C5VUHdfucmEsf42dVHLg20/Mi0i
        OL6DYagAcuXJ373kP6VLED/tIguj8PI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-88fkwEcTN6ymt989fu6u9Q-1; Mon, 05 Jul 2021 03:19:28 -0400
X-MC-Unique: 88fkwEcTN6ymt989fu6u9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B913E79EDC;
        Mon,  5 Jul 2021 07:19:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-21.pek2.redhat.com [10.72.13.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E95D85D9FC;
        Mon,  5 Jul 2021 07:19:23 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     netdev@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com
Subject: [PATCH 2/2] vdpa: vp_vdpa: don't use hard-coded maximum virtqueue size
Date:   Mon,  5 Jul 2021 15:19:10 +0800
Message-Id: <20210705071910.31965-2-jasowang@redhat.com>
In-Reply-To: <20210705071910.31965-1-jasowang@redhat.com>
References: <20210705071910.31965-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch switch to read virtqueue size from the capability instead
of depending on the hardcoded value. This allows the per virtqueue
size could be advertised.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 2926641fb586..198f7076e4d9 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -18,7 +18,6 @@
 #include <linux/virtio_pci.h>
 #include <linux/virtio_pci_modern.h>
 
-#define VP_VDPA_QUEUE_MAX 256
 #define VP_VDPA_DRIVER_NAME "vp_vdpa"
 #define VP_VDPA_NAME_SIZE 256
 
@@ -197,7 +196,10 @@ static void vp_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
 
 static u16 vp_vdpa_get_vq_num_max(struct vdpa_device *vdpa, u16 qid)
 {
-	return VP_VDPA_QUEUE_MAX;
+	struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
+	struct virtio_pci_modern_device *mdev = &vp_vdpa->mdev;
+
+	return vp_modern_get_queue_size(mdev, qid);
 }
 
 static int vp_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 qid,
-- 
2.25.1

