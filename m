Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6BC653C02
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 07:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiLVGFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 01:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLVGFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 01:05:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A7A1AF34
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671689087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GAjzue+lH37a/kIqerHns/kcNXWyklxnd9w2RHR+MA=;
        b=HBDvxq8NwmtzMx2Huu9JAOx9t09+ETQ8FM3BSW2x9yzQ//veWvZDRyAEqyyMfHFc2U9WeW
        yIv81hPaF3BYLvKTp9OVhxYAVPGifTBir2AQlVT9wvYYVv7sCqdj727vXkc2x1RzPkyrlE
        WKSXR8x1AULHxRWd/JTeUZwaaFu6bbM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-0k2Bq0LPNM6I-TjiEhT1eQ-1; Thu, 22 Dec 2022 01:04:44 -0500
X-MC-Unique: 0k2Bq0LPNM6I-TjiEhT1eQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CD581C04B7A;
        Thu, 22 Dec 2022 06:04:43 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-179.pek2.redhat.com [10.72.13.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DC3A112132C;
        Thu, 22 Dec 2022 06:04:36 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [RFC PATCH 1/4] virtio-net: convert rx mode setting to use workqueue
Date:   Thu, 22 Dec 2022 14:04:24 +0800
Message-Id: <20221222060427.21626-2-jasowang@redhat.com>
In-Reply-To: <20221222060427.21626-1-jasowang@redhat.com>
References: <20221222060427.21626-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch convert rx mode setting to be done in a workqueue, this is
a must for allow to sleep when waiting for the cvq command to
response since current code is executed under addr spin lock.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 64 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 86e52454b5b5..8225496ccb1e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -260,6 +260,15 @@ struct virtnet_info {
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
+	/* Work struct for config rx mode */
+	struct work_struct rx_mode_work;
+
+	/* Is rx_mode_work enabled? */
+	bool rx_mode_work_enabled;
+
+	/* The lock to synchronize the access to refill_enabled */
+	spinlock_t rx_mode_lock;
+
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
 
@@ -383,6 +392,22 @@ static void disable_delayed_refill(struct virtnet_info *vi)
 	spin_unlock_bh(&vi->refill_lock);
 }
 
+static void enable_rx_mode_work(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->rx_mode_lock);
+	vi->rx_mode_work_enabled = true;
+	spin_unlock_bh(&vi->rx_mode_lock);
+}
+
+static void disable_rx_mode_work(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->rx_mode_lock);
+	vi->rx_mode_work_enabled = false;
+	spin_unlock_bh(&vi->rx_mode_lock);
+
+	flush_work(&vi->rx_mode_work);
+}
+
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -2160,9 +2185,11 @@ static int virtnet_close(struct net_device *dev)
 	return 0;
 }
 
-static void virtnet_set_rx_mode(struct net_device *dev)
+static void virtnet_rx_mode_work(struct work_struct *work)
 {
-	struct virtnet_info *vi = netdev_priv(dev);
+	struct virtnet_info *vi =
+		container_of(work, struct virtnet_info, rx_mode_work);
+	struct net_device *dev = vi->dev;
 	struct scatterlist sg[2];
 	struct virtio_net_ctrl_mac *mac_data;
 	struct netdev_hw_addr *ha;
@@ -2175,8 +2202,12 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
 		return;
 
+	rtnl_lock();
+
+	netif_addr_lock_bh(dev);
 	vi->ctrl->promisc = ((dev->flags & IFF_PROMISC) != 0);
 	vi->ctrl->allmulti = ((dev->flags & IFF_ALLMULTI) != 0);
+	netif_addr_unlock_bh(dev);
 
 	sg_init_one(sg, &vi->ctrl->promisc, sizeof(vi->ctrl->promisc));
 
@@ -2192,14 +2223,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 		dev_warn(&dev->dev, "Failed to %sable allmulti mode.\n",
 			 vi->ctrl->allmulti ? "en" : "dis");
 
+	netif_addr_lock_bh(dev);
+
 	uc_count = netdev_uc_count(dev);
 	mc_count = netdev_mc_count(dev);
 	/* MAC filter - use one buffer for both lists */
 	buf = kzalloc(((uc_count + mc_count) * ETH_ALEN) +
 		      (2 * sizeof(mac_data->entries)), GFP_ATOMIC);
 	mac_data = buf;
-	if (!buf)
+	if (!buf) {
+		netif_addr_unlock_bh(dev);
+		rtnl_unlock();
 		return;
+	}
 
 	sg_init_table(sg, 2);
 
@@ -2220,6 +2256,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	netdev_for_each_mc_addr(ha, dev)
 		memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
 
+	netif_addr_unlock_bh(dev);
+
 	sg_set_buf(&sg[1], mac_data,
 		   sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
 
@@ -2227,9 +2265,21 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 				  VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
 		dev_warn(&dev->dev, "Failed to set MAC filter table.\n");
 
+	rtnl_unlock();
+
 	kfree(buf);
 }
 
+static void virtnet_set_rx_mode(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	spin_lock(&vi->rx_mode_lock);
+	if (vi->rx_mode_work_enabled)
+		schedule_work(&vi->rx_mode_work);
+	spin_unlock(&vi->rx_mode_lock);
+}
+
 static int virtnet_vlan_rx_add_vid(struct net_device *dev,
 				   __be16 proto, u16 vid)
 {
@@ -3000,6 +3050,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
+	disable_rx_mode_work(vi);
 
 	netif_tx_lock_bh(vi->dev);
 	netif_device_detach(vi->dev);
@@ -3022,6 +3073,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	virtio_device_ready(vdev);
 
 	enable_delayed_refill(vi);
+	enable_rx_mode_work(vi);
+	virtnet_set_rx_mode(vi->dev);
 
 	if (netif_running(vi->dev)) {
 		err = virtnet_open(vi->dev);
@@ -3799,7 +3852,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
 	spin_lock_init(&vi->refill_lock);
+	spin_lock_init(&vi->rx_mode_lock);
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
@@ -3905,6 +3960,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
+	enable_rx_mode_work(vi);
+
 	/* serialize netdev register + virtio_device_ready() with ndo_open() */
 	rtnl_lock();
 
@@ -3984,6 +4041,7 @@ static void virtnet_remove(struct virtio_device *vdev)
 
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vi->config_work);
+	disable_rx_mode_work(vi);
 
 	unregister_netdev(vi->dev);
 
-- 
2.25.1

