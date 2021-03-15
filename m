Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D4433C234
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhCOQg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:36:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234138AbhCOQgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KLOfu+3tvxBM9AOvHodnhHFlNdGDVuA5IWmra+LYM2A=;
        b=e5UUp/8HeyIDbLxJicpmn+TOApHIhjtHDzl/s1r1rzLLtrUsCOJRD9nLZ2xYDJZhqCAV3Z
        Bv48q+OB1Lt7jXRn5UPdIqhkVthbs7Ye7FwZUvLG1EehhJcEXROGjaVWX1ZmH6aclkHnrb
        wAkZnXEcPeOjfMQE/s2b51bQAuUtynQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-ScObpkMJPE2pysMQHktPLQ-1; Mon, 15 Mar 2021 12:36:24 -0400
X-MC-Unique: ScObpkMJPE2pysMQHktPLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FE7394DE2;
        Mon, 15 Mar 2021 16:36:23 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB0265FC17;
        Mon, 15 Mar 2021 16:36:20 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 09/14] vhost/vdpa: use get_config_size callback in vhost_vdpa_config_validate()
Date:   Mon, 15 Mar 2021 17:34:45 +0100
Message-Id: <20210315163450.254396-10-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's use the new 'get_config_size()' callback available instead of
using the 'virtio_id' to get the size of the device config space.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e0a27e336293..7ae4080e57d8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -188,13 +188,8 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
 				      struct vhost_vdpa_config *c)
 {
-	long size = 0;
-
-	switch (v->virtio_id) {
-	case VIRTIO_ID_NET:
-		size = sizeof(struct virtio_net_config);
-		break;
-	}
+	struct vdpa_device *vdpa = v->vdpa;
+	long size = vdpa->config->get_config_size(vdpa);
 
 	if (c->len == 0)
 		return -EINVAL;
-- 
2.30.2

