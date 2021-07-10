Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D73C390E
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 01:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhGJX53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 19:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhGJX4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1266361407;
        Sat, 10 Jul 2021 23:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961130;
        bh=AtQ45QQQqHhh/34OBA8KypqyY7xs+UXYwL35LOhT1eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfcMkmxJQzfydkdm2C44xbOb21Sy38uzBmIq9Q/r0NdD7Bl4dUcz2zuRc2Mh9RMvC
         lurgPJhyjEq7PGl/7L+RkcTA0ibmEt0i1wpHNbsYN9VV2c22Z3/1VfPH1aAq/sqhYo
         Xoxxrkwnw9qf3ICDp69gXGfk7TvQ01YhhqA8fOajzMhjezQ4x+qBV9RnW90T927D7j
         4KConvfak4q45goO4JR15TZgemJdS5kX2E/bOc3hx9fUK5h2zOr0LpqEIBa/+QwjBl
         6NLH6DZaTRm/32mR7jVOzFn9mliGCFt7cp/7eMrYFTGCLK3kSLH/c67u9eUe2PD6LH
         Le2fm27zK5e+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/22] virtio_net: Fix error handling in virtnet_restore()
Date:   Sat, 10 Jul 2021 19:51:42 -0400
Message-Id: <20210710235143.3222129-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235143.3222129-1-sashal@kernel.org>
References: <20210710235143.3222129-1-sashal@kernel.org>
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
index 0b1c6a8906b9..61cc69a8de2d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3199,8 +3199,11 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
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

