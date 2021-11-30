Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0814638F0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245042AbhK3PGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243216AbhK3O6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:58:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF45C0613B8;
        Tue, 30 Nov 2021 06:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9425BB81A4D;
        Tue, 30 Nov 2021 14:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7293BC53FD1;
        Tue, 30 Nov 2021 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283910;
        bh=rG5KoghkyfV7pz9bOTRLk+mJ5sE6VXKu+6Aw2KfwALs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSWbO6Wl8mkWUWZb0MZTPDpEd4fKnV21ullPuVPeHLmrWgmjuXnXFVp5n5U8iutea
         UNuPojMMcHTIM/ORAiUWk0LmF+nzqyR65orluwgdHOqGhzY27CfCpOtcBxrILYVsnB
         E7B2LdWEbdmhyYCoNrtHXEObxVZw4dEN37n0C5qUZ7fUSoCM47pPd3rgIuB+oEZFHJ
         Izi2st7ME7GGBgYNOsoRGhCaWRrtAdxZE30dSzt2lyZCgWF3GBAuB3hEGdoGpMwAvA
         7aslSIFd+uPbsssuYTTKvv2UBJ/VFZuVfVqEDD1T+cHN8hrE35PdxLNsxfAwPz1JDE
         Jelk/vReB9nGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 40/43] vhost-vdpa: clean irqs before reseting vdpa device
Date:   Tue, 30 Nov 2021 09:50:17 -0500
Message-Id: <20211130145022.945517-40-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index fdeb20f2f174c..dc4dccd35f59b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -928,12 +928,12 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 
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

