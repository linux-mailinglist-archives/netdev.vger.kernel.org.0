Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D685C1293E6
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLWJ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 04:59:41 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:29281 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfLWJ7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 04:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1577095180; x=1608631180;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AXLA4oTaOxQEJPJrsHXELfBXcoU1aXhP5KDiSUct76c=;
  b=VzL6NakNmD7eUUuwec2teTcTV3pzRvnG4sYu9d5XcxZaRi9ohDDveBMp
   4HHovW5EyjTmzWbDzns/2rhCv49qR6uW+Ubian6jzgYpzwf2cMqSPIp2W
   ODhDzsfyOWCtK9QDJb2dtBqiBEsXKcVfDFN4CiSNJKqZ5w558Dj+luVb3
   g=;
IronPort-SDR: rLgT1+3QwmMpnM5bGo0ssD6aR/h2FMREnjuVxYeVCxnfm9Ui3zS68hR6AN9C/j+TMaPe1k5tmu
 bj8hhWJJy1zw==
X-IronPort-AV: E=Sophos;i="5.69,347,1571702400"; 
   d="scan'208";a="16521924"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Dec 2019 09:59:29 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 769FAA119C;
        Mon, 23 Dec 2019 09:59:27 +0000 (UTC)
Received: from EX13D32EUB002.ant.amazon.com (10.43.166.114) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 23 Dec 2019 09:59:27 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D32EUB002.ant.amazon.com (10.43.166.114) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Dec 2019 09:59:26 +0000
Received: from u2f063a87eabd5f.cbg10.amazon.com (10.125.106.135) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 23 Dec 2019 09:59:24 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paul Durrant <pdurrant@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        "Paul Durrant" <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] xen-netback: support dynamic unbind/bind
Date:   Mon, 23 Dec 2019 09:59:23 +0000
Message-ID: <20191223095923.2458-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By re-attaching RX, TX, and CTL rings during connect() rather than
assuming they are freshly allocated (i.e. assuming the counters are zero),
and avoiding forcing state to Closed in netback_remove() it is possible
for vif instances to be unbound and re-bound from and to (respectively) a
running guest.

Dynamic unbind/bind is a highly useful feature for a backend module as it
allows it to be unloaded and re-loaded (i.e. updated) without requiring
domUs to be halted.

This has been tested by running iperf as a server in the test VM and
then running a client against it in a continuous loop, whilst also
running:

while true;
  do echo vif-$DOMID-$VIF >unbind;
  echo down;
  rmmod xen-netback;
  echo unloaded;
  modprobe xen-netback;
  cd $(pwd);
  brctl addif xenbr0 vif$DOMID.$VIF;
  ip link set vif$DOMID.$VIF up;
  echo up;
  sleep 5;
  done

in dom0 from /sys/bus/xen-backend/drivers/vif to continuously unbind,
unload, re-load, re-bind and re-plumb the backend.

Clearly a performance drop was seen but no TCP connection resets were
observed during this test and moreover a parallel SSH connection into the
guest remained perfectly usable throughout.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Paul Durrant <paul@xen.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/xen-netback/interface.c | 10 +++++++++-
 drivers/net/xen-netback/netback.c   | 20 +++++++++++++++++---
 drivers/net/xen-netback/xenbus.c    |  5 ++---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index f15ba3de6195..0c8a02a1ead7 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -585,6 +585,7 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
 	struct net_device *dev = vif->dev;
 	void *addr;
 	struct xen_netif_ctrl_sring *shared;
+	RING_IDX rsp_prod, req_prod;
 	int err;
 
 	err = xenbus_map_ring_valloc(xenvif_to_xenbus_device(vif),
@@ -593,7 +594,14 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
 		goto err;
 
 	shared = (struct xen_netif_ctrl_sring *)addr;
-	BACK_RING_INIT(&vif->ctrl, shared, XEN_PAGE_SIZE);
+	rsp_prod = READ_ONCE(shared->rsp_prod);
+	req_prod = READ_ONCE(shared->req_prod);
+
+	BACK_RING_ATTACH(&vif->ctrl, shared, rsp_prod, XEN_PAGE_SIZE);
+
+	err = -EIO;
+	if (req_prod - rsp_prod > RING_SIZE(&vif->ctrl))
+		goto err_unmap;
 
 	err = bind_interdomain_evtchn_to_irq(vif->domid, evtchn);
 	if (err < 0)
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 0020b2e8c279..315dfc6ea297 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1453,7 +1453,7 @@ int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,
 	void *addr;
 	struct xen_netif_tx_sring *txs;
 	struct xen_netif_rx_sring *rxs;
-
+	RING_IDX rsp_prod, req_prod;
 	int err = -ENOMEM;
 
 	err = xenbus_map_ring_valloc(xenvif_to_xenbus_device(queue->vif),
@@ -1462,7 +1462,14 @@ int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,
 		goto err;
 
 	txs = (struct xen_netif_tx_sring *)addr;
-	BACK_RING_INIT(&queue->tx, txs, XEN_PAGE_SIZE);
+	rsp_prod = READ_ONCE(txs->rsp_prod);
+	req_prod = READ_ONCE(txs->req_prod);
+
+	BACK_RING_ATTACH(&queue->tx, txs, rsp_prod, XEN_PAGE_SIZE);
+
+	err = -EIO;
+	if (req_prod - rsp_prod > RING_SIZE(&queue->tx))
+		goto err;
 
 	err = xenbus_map_ring_valloc(xenvif_to_xenbus_device(queue->vif),
 				     &rx_ring_ref, 1, &addr);
@@ -1470,7 +1477,14 @@ int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,
 		goto err;
 
 	rxs = (struct xen_netif_rx_sring *)addr;
-	BACK_RING_INIT(&queue->rx, rxs, XEN_PAGE_SIZE);
+	rsp_prod = READ_ONCE(rxs->rsp_prod);
+	req_prod = READ_ONCE(rxs->req_prod);
+
+	BACK_RING_ATTACH(&queue->rx, rxs, rsp_prod, XEN_PAGE_SIZE);
+
+	err = -EIO;
+	if (req_prod - rsp_prod > RING_SIZE(&queue->rx))
+		goto err;
 
 	return 0;
 
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 17b4950ec051..286054b60d47 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -954,12 +954,10 @@ static int netback_remove(struct xenbus_device *dev)
 {
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
-	set_backend_state(be, XenbusStateClosed);
-
 	unregister_hotplug_status_watch(be);
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
-		xen_unregister_watchers(be->vif);
+		backend_disconnect(be);
 		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
@@ -1131,6 +1129,7 @@ static struct xenbus_driver netback_driver = {
 	.remove = netback_remove,
 	.uevent = netback_uevent,
 	.otherend_changed = frontend_changed,
+	.allow_rebind = true,
 };
 
 int xenvif_xenbus_init(void)
-- 
2.20.1

