Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FD143CD65
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbhJ0PWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235563AbhJ0PWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7FBC604E9;
        Wed, 27 Oct 2021 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635348017;
        bh=kXSukUAIQjzJgGNoV83qZPsvQj3t/qN7XQ7LyUFaGeE=;
        h=From:To:Cc:Subject:Date:From;
        b=s8N1RwnWPSI4+6Rw0oZ+PTUMW4jRKpOccvAyUlzv7b5XzT+YCqI/UF5h4eUUaqLF4
         Koi7hq1CKwYD7raND6dr5GGeGFLMPXdrrDqgJ85Hb49VAVmippvgJ/A1NjUIEj31LX
         CAS+rcMInMKxlLaTxJE5TfWzI+oiJ8PLf1C7cFcefwRWH/vaW2sIZCOs5m2dL/uwyv
         032KY7dB2peEtcq6nqoBNdRlc/USvmmubVYqloWY63dyj5OXayQpNZuDabILaZ+471
         LytOoXgiF/hlUCa2pCI0eIUIKXlwwHTsd2dCREDpzgDInLdEkhzRI2jw1tk5eCHlnx
         F03oY+3EpUkrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next v2] net: virtio: use eth_hw_addr_set()
Date:   Wed, 27 Oct 2021 08:20:12 -0700
Message-Id: <20211027152012.3393077-1-kuba@kernel.org>
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

Even though the current code uses dev->addr_len the we can switch
to eth_hw_addr_set() instead of dev_addr_set(). The netdev is
always allocated by alloc_etherdev_mq() and there are at least two
places which assume Ethernet address:
 - the line below calling eth_hw_addr_random()
 - virtnet_set_mac_address() -> eth_commit_mac_addr_change()

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: - actually switch to eth_hw_addr_set() not dev_addr_set()
    - resize the buffer to ETH_ALEN
    - pass ETH_ALEN instead of dev->dev_addr to virtio_cread_bytes()

CC: mst@redhat.com
CC: jasowang@redhat.com
CC: virtualization@lists.linux-foundation.org
---
 drivers/net/virtio_net.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c501b5974aee..cc79343cd220 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->max_mtu = MAX_MTU;
 
 	/* Configuration may specify what MAC to use.  Otherwise random. */
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
+		u8 addr[ETH_ALEN];
+
 		virtio_cread_bytes(vdev,
 				   offsetof(struct virtio_net_config, mac),
-				   dev->dev_addr, dev->addr_len);
-	else
+				   addr, ETH_ALEN);
+		eth_hw_addr_set(dev, addr);
+	} else {
 		eth_hw_addr_random(dev);
+	}
 
 	/* Set up our device-specific information */
 	vi = netdev_priv(dev);
-- 
2.31.1

