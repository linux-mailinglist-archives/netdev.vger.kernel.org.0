Return-Path: <netdev+bounces-4894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA3E70F07A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D361280DE2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF40C153;
	Wed, 24 May 2023 08:19:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7B2C152
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:19:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DAD198
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684916338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0A1CCn6mOjf73oyU9qaprGe0kd5llpOEwIqRiZpOsU=;
	b=bJqrCTBQC8SWiy60PxBx4wXLJuHyG74x/ADg+dkxr7eDuh5uaXkeX9X4/pYi5F4k/17gWg
	PzLPo+/eOLBAvbg+6YWBRu3HSMtzLnGE7Lqnk/75AExPqwaJF/8c38woHE2LgP63ywAlUl
	b86dz2wr948JCm92Vnsu2U9clcbr7LU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-mOwrqCLGMSKS5jJMRdZM7w-1; Wed, 24 May 2023 04:18:55 -0400
X-MC-Unique: mOwrqCLGMSKS5jJMRdZM7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81D3D280BC53;
	Wed, 24 May 2023 08:18:54 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-76.pek2.redhat.com [10.72.13.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 565AD140E95D;
	Wed, 24 May 2023 08:18:50 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alvaro.karsz@solid-run.com
Subject: [PATCH V3 net-next 1/2] virtio-net: convert rx mode setting to use workqueue
Date: Wed, 24 May 2023 16:18:41 +0800
Message-Id: <20230524081842.3060-2-jasowang@redhat.com>
In-Reply-To: <20230524081842.3060-1-jasowang@redhat.com>
References: <20230524081842.3060-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch convert rx mode setting to be done in a workqueue, this is
a must for allow to sleep when waiting for the cvq command to
response since current code is executed under addr spin lock.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V1:
- use RTNL to synchronize rx mode worker
---
 drivers/net/virtio_net.c | 55 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 56ca1d270304..5d2f1da4eaa0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -265,6 +265,12 @@ struct virtnet_info {
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
+	/* Work struct for config rx mode */
+	struct work_struct rx_mode_work;
+
+	/* Is rx mode work enabled? */
+	bool rx_mode_work_enabled;
+
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
 
@@ -388,6 +394,20 @@ static void disable_delayed_refill(struct virtnet_info *vi)
 	spin_unlock_bh(&vi->refill_lock);
 }
 
+static void enable_rx_mode_work(struct virtnet_info *vi)
+{
+	rtnl_lock();
+	vi->rx_mode_work_enabled = true;
+	rtnl_unlock();
+}
+
+static void disable_rx_mode_work(struct virtnet_info *vi)
+{
+	rtnl_lock();
+	vi->rx_mode_work_enabled = false;
+	rtnl_unlock();
+}
+
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -2341,9 +2361,11 @@ static int virtnet_close(struct net_device *dev)
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
@@ -2356,6 +2378,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_RX))
 		return;
 
+	rtnl_lock();
+
 	vi->ctrl->promisc = ((dev->flags & IFF_PROMISC) != 0);
 	vi->ctrl->allmulti = ((dev->flags & IFF_ALLMULTI) != 0);
 
@@ -2373,14 +2397,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
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
 
@@ -2401,6 +2430,8 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	netdev_for_each_mc_addr(ha, dev)
 		memcpy(&mac_data->macs[i++][0], ha->addr, ETH_ALEN);
 
+	netif_addr_unlock_bh(dev);
+
 	sg_set_buf(&sg[1], mac_data,
 		   sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
 
@@ -2408,9 +2439,19 @@ static void virtnet_set_rx_mode(struct net_device *dev)
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
+	if (vi->rx_mode_work_enabled)
+		schedule_work(&vi->rx_mode_work);
+}
+
 static int virtnet_vlan_rx_add_vid(struct net_device *dev,
 				   __be16 proto, u16 vid)
 {
@@ -3181,6 +3222,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
+	disable_rx_mode_work(vi);
+	flush_work(&vi->rx_mode_work);
 
 	netif_tx_lock_bh(vi->dev);
 	netif_device_detach(vi->dev);
@@ -3203,6 +3246,7 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	virtio_device_ready(vdev);
 
 	enable_delayed_refill(vi);
+	enable_rx_mode_work(vi);
 
 	if (netif_running(vi->dev)) {
 		err = virtnet_open(vi->dev);
@@ -4002,6 +4046,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
 	spin_lock_init(&vi->refill_lock);
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
@@ -4110,6 +4155,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
+	enable_rx_mode_work(vi);
+
 	/* serialize netdev register + virtio_device_ready() with ndo_open() */
 	rtnl_lock();
 
@@ -4207,6 +4254,8 @@ static void virtnet_remove(struct virtio_device *vdev)
 
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vi->config_work);
+	disable_rx_mode_work(vi);
+	flush_work(&vi->rx_mode_work);
 
 	unregister_netdev(vi->dev);
 
-- 
2.25.1


