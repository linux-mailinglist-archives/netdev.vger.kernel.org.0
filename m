Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5126560EF
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiLZHuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiLZHuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:50:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83246147
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 23:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672040967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izBQcDXRjlNbfrqUhUbxJNlz9mzMYpLOJS7BO6ADrsA=;
        b=iEWPWlcmtePyUcHaRJq2jpYI2aqodRzcZcNJYi2wIIq5pu/s0lbnVTkUWC/No7oIDGt6oD
        s1/BZIzST5sluGD1JTUTnxrcgJRw/zJgOEhMkqhV7qy3iEBnuAZ7gM6FxRiSy2dCByB5oM
        6NY01+kaILb/4ifIstmkh1WEqoPJACQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-ZJWa1mhENqKjQGQCishvyg-1; Mon, 26 Dec 2022 02:49:20 -0500
X-MC-Unique: ZJWa1mhENqKjQGQCishvyg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 832542A5956E;
        Mon, 26 Dec 2022 07:49:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-100.pek2.redhat.com [10.72.13.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C11D1492B00;
        Mon, 26 Dec 2022 07:49:15 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [PATCH 1/4] virtio-net: convert rx mode setting to use workqueue
Date:   Mon, 26 Dec 2022 15:49:05 +0800
Message-Id: <20221226074908.8154-2-jasowang@redhat.com>
In-Reply-To: <20221226074908.8154-1-jasowang@redhat.com>
References: <20221226074908.8154-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
 drivers/net/virtio_net.c | 66 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 86e52454b5b5..efd9dd55828b 100644
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
@@ -1974,6 +1999,8 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	/* Caller should know better */
 	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
 
+	ASSERT_RTNL();
+
 	vi->ctrl->status = ~0;
 	vi->ctrl->hdr.class = class;
 	vi->ctrl->hdr.cmd = cmd;
@@ -2160,9 +2187,11 @@ static int virtnet_close(struct net_device *dev)
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
@@ -2175,8 +2204,12 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
 		return;
 
+	rtnl_lock();
+
+	netif_addr_lock_bh(dev);
 	vi->ctrl->promisc = ((dev->flags & IFF_PROMISC) != 0);
 	vi->ctrl->allmulti = ((dev->flags & IFF_ALLMULTI) != 0);
+	netif_addr_unlock_bh(dev);
 
 	sg_init_one(sg, &vi->ctrl->promisc, sizeof(vi->ctrl->promisc));
 
@@ -2192,14 +2225,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
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
 
@@ -2220,6 +2258,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	netdev_for_each_mc_addr(ha, dev)
 		memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
 
+	netif_addr_unlock_bh(dev);
+
 	sg_set_buf(&sg[1], mac_data,
 		   sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
 
@@ -2227,9 +2267,21 @@ static void virtnet_set_rx_mode(struct net_device *dev)
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
@@ -3000,6 +3052,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
+	disable_rx_mode_work(vi);
 
 	netif_tx_lock_bh(vi->dev);
 	netif_device_detach(vi->dev);
@@ -3022,6 +3075,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	virtio_device_ready(vdev);
 
 	enable_delayed_refill(vi);
+	enable_rx_mode_work(vi);
+	virtnet_set_rx_mode(vi->dev);
 
 	if (netif_running(vi->dev)) {
 		err = virtnet_open(vi->dev);
@@ -3799,7 +3854,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
 	spin_lock_init(&vi->refill_lock);
+	spin_lock_init(&vi->rx_mode_lock);
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
@@ -3905,6 +3962,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
+	enable_rx_mode_work(vi);
+
 	/* serialize netdev register + virtio_device_ready() with ndo_open() */
 	rtnl_lock();
 
@@ -3984,6 +4043,7 @@ static void virtnet_remove(struct virtio_device *vdev)
 
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vi->config_work);
+	disable_rx_mode_work(vi);
 
 	unregister_netdev(vi->dev);
 
-- 
2.25.1

