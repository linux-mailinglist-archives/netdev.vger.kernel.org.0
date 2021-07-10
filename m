Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7633C3867
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 01:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhGJXyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 19:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233544AbhGJXx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D120D613C3;
        Sat, 10 Jul 2021 23:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961063;
        bh=ghpaVWJ+td67lKFErmQY2um8C1Z1cHXdrgKEpehURYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rk41BMmB+7iWTqwy7/h92I/5l7GNOnfRi25vXwdFAoOwLUDl00yEOwNopyT8LEs/G
         g9UyrkshVP2/l9byd7xBTynrT2qngvtuMh7FwT52Ctk905XIVeIo4ZGRKxj6bmNfE4
         LDawvi0NWwNvco3qEtpw5i3uuWGu0GBAmQcrs+jL5o5dPG2UuOkHzLGhIZiCK8gbBC
         ytBD4qKqC0kW5vDHhpGdOO3ySs9i5KpyycsHezt7RAUpYZwQQFepyXXJD8vCmDIm5c
         Dda3SoQ25zjUiSJbjTycfdCiuARd3LS85RTJxR6Uzy8TBa2PRxcr4YBK+I8bbtJU8t
         viBdbl/tyo/Hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 35/37] virtio_net: Fix error handling in virtnet_restore()
Date:   Sat, 10 Jul 2021 19:50:13 -0400
Message-Id: <20210710235016.3221124-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
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
index 286f836a53bf..0e7a99424fc7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3228,8 +3228,11 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
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

