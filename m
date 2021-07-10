Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1823C3946
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 01:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhGJX6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 19:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230417AbhGJX5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 19:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF076141E;
        Sat, 10 Jul 2021 23:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961158;
        bh=zTRVc9r2u+aj1HVr78CitjoH2EHWc/GHm1GJ0PMYVvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWNENnAo1urka7fwXeF+NeMvaYyD8UVaiH9QpghcrbsiM1yguAsC1YhxjfzlaLgQD
         UhKWSPCH0MDsOqiZqF7yFTf48oIyXZctZWIp0gC4QNpEv+T19VDvJbSznF+pMvcFyp
         ni1UxCMQ3A/yfp71KiFs4y40OSmoDm/w5ViT7vu8PthQY7NCx8sgXAJRfFZa0BQRaQ
         3kLoDTsErHK4+fNPmJKvrs76+bHKui6RTPw2x28SEGQmxV0+p1i79dM6HYHctsCRei
         8xJDw0q9HV8/rKmBnKO67c1N9Rxb0Dvz999EtOlJslFU6tJ373J09Hcm331f6tYxVR
         IPh3lyA6vLflw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/21] virtio_net: Fix error handling in virtnet_restore()
Date:   Sat, 10 Jul 2021 19:52:11 -0400
Message-Id: <20210710235212.3222375-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 3f2869cace829fb4b80fc53b3ddaa7f4ba9acbf1 ]

Do some cleanups in virtnet_restore() when virtnet_cpu_notif_add() failed.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20210517084516.332-1-xieyongji@bytedance.com
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2d2a307c0231..dbc944c5759e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2765,8 +2765,11 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
 
 	err = virtnet_cpu_notif_add(vi);
-	if (err)
+	if (err) {
+		virtnet_freeze_down(vdev);
+		remove_vq_common(vi);
 		return err;
+	}
 
 	return 0;
 }
-- 
2.30.2

