Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA1F15B3C2
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgBLWcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:32:39 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:19456 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727692AbgBLWcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581546758; x=1613082758;
  h=date:from:to:subject:message-id:mime-version;
  bh=+zXTnUkKMKFgalRZdwxTzRNR5GJFShLVu/RYZfBNJ1E=;
  b=bTV+6D7xYgf4WMFiUNc1JKH/pUztJ98EkU3NF5RlK42bWsLedr6mbODB
   WE+CgvDp/BEbacnpC5He9PZlheL+JNHBe5QLYgJyfFZ+KCWFCqbVRNtr9
   3XfyuBydk1PBBIPbUwJfwcmVNYbdEN3VgDRRVR3YCJ9s2yPy4BijfMWFV
   c=;
IronPort-SDR: 77EBN9MgMbUwDv9LWl4gOIf/QNV8FXtGYDzmsxpHs1JZq+U748pBK+5Sy5PmhtEG6P6qMcuEDc
 460r1jycdjLg==
X-IronPort-AV: E=Sophos;i="5.70,434,1574121600"; 
   d="scan'208";a="26088733"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Feb 2020 22:32:34 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 8A604A219B;
        Wed, 12 Feb 2020 22:32:27 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:32:08 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Feb 2020 22:32:07 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 12 Feb 2020 22:32:07 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 805CC400D1; Wed, 12 Feb 2020 22:32:07 +0000 (UTC)
Date:   Wed, 12 Feb 2020 22:32:07 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <fllinden@amaozn.com>, <benh@kernel.crashing.org>
Subject: [RFC PATCH v3 05/12] xen-netfront: add callbacks for PM suspend and
 hibernation support
Message-ID: <20200212223207.GA4169@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Add freeze, thaw and restore callbacks for PM suspend and hibernation
support. The freeze handler simply disconnects the frotnend from the
backend and frees resources associated with queues after disabling the
net_device from the system. The restore handler just changes the
frontend state and let the xenbus handler to re-allocate the resources
and re-connect to the backend. This can be performed transparently to
the rest of the system. The handlers are used for both PM suspend and
hibernation so that we can keep the existing suspend/resume callbacks
for Xen suspend without modification. Freezing netfront devices is
normally expected to finish within a few hundred milliseconds, but it
can rarely take more than 5 seconds and hit the hard coded timeout,
it would depend on backend state which may be congested and/or have
complex configuration. While it's rare case, longer default timeout
seems a bit more reasonable here to avoid hitting the timeout.
Also, make it configurable via module parameter so that we can cover
broader setups than what we know currently.

[Anchal changelog: Variable name fix and checkpatch.pl fixes]
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>

---
Changes since V2: None
---
 drivers/net/xen-netfront.c | 98 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c8b0fb7..65edcdd6e05f 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -43,6 +43,7 @@
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/completion.h>
 #include <net/ip.h>
 
 #include <xen/xen.h>
@@ -56,6 +57,12 @@
 #include <xen/interface/memory.h>
 #include <xen/interface/grant_table.h>
 
+enum netif_freeze_state {
+	NETIF_FREEZE_STATE_UNFROZEN,
+	NETIF_FREEZE_STATE_FREEZING,
+	NETIF_FREEZE_STATE_FROZEN,
+};
+
 /* Module parameters */
 #define MAX_QUEUES_DEFAULT 8
 static unsigned int xennet_max_queues;
@@ -63,6 +70,12 @@ module_param_named(max_queues, xennet_max_queues, uint, 0644);
 MODULE_PARM_DESC(max_queues,
 		 "Maximum number of queues per virtual interface");
 
+static unsigned int netfront_freeze_timeout_secs = 10;
+module_param_named(freeze_timeout_secs,
+		   netfront_freeze_timeout_secs, uint, 0644);
+MODULE_PARM_DESC(freeze_timeout_secs,
+		 "timeout when freezing netfront device in seconds");
+
 static const struct ethtool_ops xennet_ethtool_ops;
 
 struct netfront_cb {
@@ -160,6 +173,10 @@ struct netfront_info {
 	struct netfront_stats __percpu *tx_stats;
 
 	atomic_t rx_gso_checksum_fixup;
+
+	int freeze_state;
+
+	struct completion wait_backend_disconnected;
 };
 
 struct netfront_rx_info {
@@ -721,6 +738,21 @@ static int xennet_close(struct net_device *dev)
 	return 0;
 }
 
+static int xennet_disable_interrupts(struct net_device *dev)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	unsigned int num_queues = dev->real_num_tx_queues;
+	unsigned int queue_index;
+	struct netfront_queue *queue;
+
+	for (queue_index = 0; queue_index < num_queues; ++queue_index) {
+		queue = &np->queues[queue_index];
+		disable_irq(queue->tx_irq);
+		disable_irq(queue->rx_irq);
+	}
+	return 0;
+}
+
 static void xennet_move_rx_slot(struct netfront_queue *queue, struct sk_buff *skb,
 				grant_ref_t ref)
 {
@@ -1301,6 +1333,8 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	np->queues = NULL;
 
+	init_completion(&np->wait_backend_disconnected);
+
 	err = -ENOMEM;
 	np->rx_stats = netdev_alloc_pcpu_stats(struct netfront_stats);
 	if (np->rx_stats == NULL)
@@ -1794,6 +1828,50 @@ static int xennet_create_queues(struct netfront_info *info,
 	return 0;
 }
 
+static int netfront_freeze(struct xenbus_device *dev)
+{
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
+	unsigned long timeout = netfront_freeze_timeout_secs * HZ;
+	int err = 0;
+
+	xennet_disable_interrupts(info->netdev);
+
+	netif_device_detach(info->netdev);
+
+	info->freeze_state = NETIF_FREEZE_STATE_FREEZING;
+
+	/* Kick the backend to disconnect */
+	xenbus_switch_state(dev, XenbusStateClosing);
+
+	/* We don't want to move forward before the frontend is diconnected
+	 * from the backend cleanly.
+	 */
+	timeout = wait_for_completion_timeout(&info->wait_backend_disconnected,
+					      timeout);
+	if (!timeout) {
+		err = -EBUSY;
+		xenbus_dev_error(dev, err, "Freezing timed out;"
+				 "the device may become inconsistent state");
+		return err;
+	}
+
+	/* Tear down queues */
+	xennet_disconnect_backend(info);
+	xennet_destroy_queues(info);
+
+	info->freeze_state = NETIF_FREEZE_STATE_FROZEN;
+
+	return err;
+}
+
+static int netfront_restore(struct xenbus_device *dev)
+{
+	/* Kick the backend to re-connect */
+	xenbus_switch_state(dev, XenbusStateInitialising);
+
+	return 0;
+}
+
 /* Common code used when first setting up, and when resuming. */
 static int talk_to_netback(struct xenbus_device *dev,
 			   struct netfront_info *info)
@@ -1999,6 +2077,8 @@ static int xennet_connect(struct net_device *dev)
 		spin_unlock_bh(&queue->rx_lock);
 	}
 
+	np->freeze_state = NETIF_FREEZE_STATE_UNFROZEN;
+
 	return 0;
 }
 
@@ -2036,10 +2116,23 @@ static void netback_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosed:
-		if (dev->state == XenbusStateClosed)
+		if (dev->state == XenbusStateClosed) {
+		     /* dpm context is waiting for the backend */
+			if (np->freeze_state == NETIF_FREEZE_STATE_FREEZING)
+				complete(&np->wait_backend_disconnected);
 			break;
+		}
+
 		/* Fall through - Missed the backend's CLOSING state. */
 	case XenbusStateClosing:
+	       /* We may see unexpected Closed or Closing from the backend.
+		* Just ignore it not to prevent the frontend from being
+		* re-connected in the case of PM suspend or hibernation.
+		*/
+		if (np->freeze_state == NETIF_FREEZE_STATE_FROZEN &&
+		    dev->state == XenbusStateInitialising) {
+			break;
+		}
 		xenbus_frontend_closed(dev);
 		break;
 	}
@@ -2186,6 +2279,9 @@ static struct xenbus_driver netfront_driver = {
 	.probe = netfront_probe,
 	.remove = xennet_remove,
 	.resume = netfront_resume,
+	.freeze = netfront_freeze,
+	.thaw	= netfront_restore,
+	.restore = netfront_restore,
 	.otherend_changed = netback_changed,
 };
 
-- 
2.24.1.AMZN

