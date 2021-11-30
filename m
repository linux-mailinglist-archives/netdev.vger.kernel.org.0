Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F1463794
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243241AbhK3Oyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:54:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47336 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242744AbhK3Ox3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:53:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 204E5B81A22;
        Tue, 30 Nov 2021 14:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD23C53FC1;
        Tue, 30 Nov 2021 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283807;
        bh=HNxKbjB96XxCJFowlbjGxNOiW3Tjj8GTqWkuCBB7DGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7biZn8imblMLA8gd2rqI6G8NZEGuStcPdlox/bQ+uZ1QUE+JO52helIL67wH6Jq+
         f28CKv7Eq8uwPP51+FGJB15/vHOX5BIFtDNGpDvZRyOtVnqHRpoUiUiOoDoAqNHRek
         f4e7Db1IWPXIx9Q6d/NWnncSQik9THy2hRA7aP0BlYV9zWiETc5cuRc5BE4QQ5rxPl
         2tZGMCFtm31PeROXdyR6XqHoCk+K4VLiBIY2RXXZIeaY/mQ938Yqg1uUw8u1rc/jBA
         3fld6Sayg7Ux/CF0IDARBrQwjiGlVpC7xfm3qVxkhMGGcfqEx3GMunt5Zap6A+hqVt
         583tNCrf2P9rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 61/68] vhost-vdpa: clean irqs before reseting vdpa device
Date:   Tue, 30 Nov 2021 09:46:57 -0500
Message-Id: <20211130144707.944580-61-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wu Zongyong <wuzongyong@linux.alibaba.com>

[ Upstream commit ea8f17e44fa7d54fae287ccbe30ce269afb5ee42 ]

Vdpa devices should be reset after unseting irqs of virtqueues, or we
will get errors when killing qemu process:

>> pi_update_irte: failed to update PI IRTE
>> irq bypass consumer (token 0000000065102a43) unregistration fails: -22

Signed-off-by: Wu Zongyong <wuzongyong@linux.alibaba.com>
Link: https://lore.kernel.org/r/a2cb60cf73be9da5c4e6399242117d8818f975ae.1636946171.git.wuzongyong@linux.alibaba.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 39039e0461175..e73bff6fcff98 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1015,12 +1015,12 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 
 	mutex_lock(&d->mutex);
 	filep->private_data = NULL;
+	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
 	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
-	vhost_vdpa_clean_irq(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
 	mutex_unlock(&d->mutex);
-- 
2.33.0

