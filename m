Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B36543B8B6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhJZR7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232088AbhJZR7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 007C36108D;
        Tue, 26 Oct 2021 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635270998;
        bh=l1yQidB2p97QAej6h16i3H/pSkwI/eNWBpe8swoCeq0=;
        h=From:To:Cc:Subject:Date:From;
        b=s5b9HoaFlE6RNMikaaHMS93P/09XDU/7Tq7GmSvyrIGmC3/iiM0glrEjP2/gPNCsl
         NuZ9xayYOQ5WjCTPbC75fCD00/nnZUY5W7YkmQbnM5tXvX9fNP4+UNShZsQBsPvCVZ
         6+DaMgLBHlZ3SKDRXhcvdCEnN4mS2X3KRzBKupJ65/H6p0yFLK35vfzDqbxtSiRLA1
         eqfT6i3nU9nDinnjX+FbiWoasv3Jig9QnDfZUb4L8WlIOezMWXbRmpu7uqj1VZPUXv
         ILf2Z2bT2YLKAw0INI5KJHSnRjkxngX4ujGHbIr3uibSWvLvGjfV3seXJSBdwvQ0Iy
         85raS8HDHLAcQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next] net: virtio: use eth_hw_addr_set()
Date:   Tue, 26 Oct 2021 10:56:34 -0700
Message-Id: <20211026175634.3198477-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mst@redhat.com
CC: jasowang@redhat.com
CC: virtualization@lists.linux-foundation.org
---
 drivers/net/virtio_net.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c501b5974aee..b7f35aff8e82 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->max_mtu = MAX_MTU;
 
 	/* Configuration may specify what MAC to use.  Otherwise random. */
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
+		u8 addr[MAX_ADDR_LEN];
+
 		virtio_cread_bytes(vdev,
 				   offsetof(struct virtio_net_config, mac),
-				   dev->dev_addr, dev->addr_len);
-	else
+				   addr, dev->addr_len);
+		dev_addr_set(dev, addr);
+	} else {
 		eth_hw_addr_random(dev);
+	}
 
 	/* Set up our device-specific information */
 	vi = netdev_priv(dev);
-- 
2.31.1

