Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96C62C432C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgKYPgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbgKYPgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1042E205CB;
        Wed, 25 Nov 2020 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318576;
        bh=2iKQUJsUQI9l2vvcbu3mNWUXjhNPMztzv4VhPexSgrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WA8TWMn9+KtlFj1b9Zq2wt3FHwXCEq0K1FZ5p8UV9i3QQuW0u2c9ZBH9BaMqFtRKQ
         iGX3T8XdHixNbMKiVeSBbxsL6Zyo4msKmy6zY9wu8iVQMs8IwB5PHT9CMqrbYyjqjS
         7+bCUT+b+Pw33M3tBx7puQNpZUcE9wviUgmbez5U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 19/33] vhost: add helper to check if a vq has been setup
Date:   Wed, 25 Nov 2020 10:35:36 -0500
Message-Id: <20201125153550.810101-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 6bcf34224ac1e94103797fd68b9836061762f2b2 ]

This adds a helper check if a vq has been setup. The next patches
will use this when we move the vhost scsi cmd preallocation from per
session to per vq. In the per vq case, we only want to allocate cmds
for vqs that have actually been setup and not for all the possible
vqs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/1604986403-4931-2-git-send-email-michael.christie@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 6 ++++++
 drivers/vhost/vhost.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ad45e1d27f0f..23e7b2d624511 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -305,6 +305,12 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
 	spin_lock_init(&call_ctx->ctx_lock);
 }
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
+{
+	return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
+
 static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9032d3c2a9f48..3d30b3da7bcf5 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -190,6 +190,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
 int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-- 
2.27.0

