Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E0D3C38C3
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 01:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhGJX4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 19:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233969AbhGJXzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 19:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B395E613F8;
        Sat, 10 Jul 2021 23:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961100;
        bh=bcj9nyXcOe/9f6DTm6knVzJnwMfrk0aJTZnC+FA1jM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kG/57zUYDBCWugpGgaWUrU2WfJDqqbc52cih822csPKsOwpkNJ3rACggNP/Iezwby
         EvmQe3K70FRq4HL8Qb6hz/JVFQ6/XkjBwXFgijYA45T7c46zYuNnTZEiJw00kom4Tu
         q8OHvDaUPHKVy+gUf6+kfZj5EHihZh1e5AoJqR9tIslrJEQG7KImEQsJ+SCH9t+Qw+
         lzD03t8BNLSZGGBO5irVLHTWSkyAzuUqCedCEAMigLd+eqTFyknXSRUNfQD2i9hAqQ
         QOquN6Mp/8+2pVkWAdrOO5XYMnT8ifuudqkAGmLPVPZ/miasNWNnfHkKsU7f7h22nF
         niwFlHUXLKgRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/28] virtio_net: Fix error handling in virtnet_restore()
Date:   Sat, 10 Jul 2021 19:51:05 -0400
Message-Id: <20210710235107.3221840-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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
index d8ee001d8e8e..feb9941819f0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3282,8 +3282,11 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
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

