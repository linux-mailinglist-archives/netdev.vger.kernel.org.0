Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1E68D345
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 10:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjBGJyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 04:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjBGJyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 04:54:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C593AEC5D;
        Tue,  7 Feb 2023 01:54:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A519612AE;
        Tue,  7 Feb 2023 09:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08648C433D2;
        Tue,  7 Feb 2023 09:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675763641;
        bh=iBAiyOJD9nZ0VgXU1EdkPkfj9/VaFGKFn/84CXU+6gA=;
        h=From:To:Cc:Subject:Date:From;
        b=QDaDHbvakOQ5R6ExVmsWtIJ/xqPc0Ua+GXZFSrw8+N9zkXmxM6k80wW2bzlWjnnDZ
         FC3G/YtHgZoC4tm+AvFHNyMP3R3LwyENad6dDSpXvii8CUZsKPkB6e/AcDQZ5rxCC/
         nY70C2KMjShItN02R5ZfMNyNyvjrgavKl4IOWCuW1/hwzVtRtjgSUNxcklScNdelAY
         UZFDnVGaI4iJkWwSLvMc8B2NUktN3VHi9vcJxA/ayhrmgU71Vp11C9trbt/UlvTa5V
         IcMI/kjwjQLCu2jmNsknDqe+wJ9Tk5H/Axc33ixKHWB5HzIuDjqitOIc9xGVD1m7qs
         xqsj6XwDqZfwg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, mst@redhat.com, jasowang@redhat.com,
        hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH bpf-next] virtio_net: update xdp_features with xdp multi-buff
Date:   Tue,  7 Feb 2023 10:53:40 +0100
Message-Id: <60c76cd63a0246db785606e8891b925fd5c9bf06.1675763384.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now virtio-net supports xdp multi-buffer so add it to xdp_features

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 692dff071782..ddc3dc7ea73c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3281,7 +3281,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 				virtnet_clear_guest_offloads(vi);
 		}
 		if (!old_prog)
-			xdp_features_set_redirect_target(dev, false);
+			xdp_features_set_redirect_target(dev, true);
 	} else {
 		xdp_features_clear_redirect_target(dev);
 		vi->xdp_enabled = false;
@@ -3940,8 +3940,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
 	spin_lock_init(&vi->refill_lock);
 
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
 		vi->mergeable_rx_bufs = true;
+		dev->xdp_features |= NETDEV_XDP_ACT_RX_SG;
+	}
 
 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
 		vi->rx_usecs = 0;
-- 
2.39.1

