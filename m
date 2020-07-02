Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80280212C34
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 20:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgGBSXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 14:23:00 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:3350 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgGBSW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 14:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593714177; x=1625250177;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=RVQKYtcRWwNWuZmUzS3zKOFxRzkR229MYD6OqjQdblg=;
  b=NdsRZ2snflyOIiQBbCjZKak10ZUwltWSELv0tuqOotP7kx2aMnxD4Jy7
   CJzocvYTg6PMw3OWcQkAqQRIje778szTn3joTxV04qhael74DvVAjIYOd
   GSeHpsvLapQOYzov7dAkDzJY8s9TX3daU2RxWQg7VpDrDAzFnnzF5ugzW
   k=;
IronPort-SDR: CD+xWM+1+cIX2syWOyjPqbem2nqHCuYhZtRY9gc6NlNk+D4GhT+VRWopNGaFDnmYCsyAzUKHdD
 NlhAuEexncvg==
X-IronPort-AV: E=Sophos;i="5.75,305,1589241600"; 
   d="scan'208";a="56964654"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 02 Jul 2020 18:22:54 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 67EEAA2423;
        Thu,  2 Jul 2020 18:22:47 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:22:29 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:22:29 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 2 Jul 2020 18:22:28 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id B17DF40844; Thu,  2 Jul 2020 18:22:28 +0000 (UTC)
Date:   Thu, 2 Jul 2020 18:22:28 +0000
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
        <benh@kernel.crashing.org>
Subject: [PATCH v2 06/11] xen-blkfront: add callbacks for PM suspend and
 hibernation
Message-ID: <20200702182228.GA3586@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1593665947.git.anchalag@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

S4 power transisiton states are much different than xen
suspend/resume. Former is visible to the guest and frontend drivers should
be aware of the state transistions and should be able to take appropriate
actions when needed. In transition to S4 we need to make sure that at least
all the in-flight blkif requests get completed, since they probably contain
bits of the guest's memory image and that's not going to get saved any
other way. Hence, re-issuing of in-flight requests as in case of xen resume
will not work here. This is in contrast to xen-suspend where we need to
freeze with as little processing as possible to avoid dirtying RAM late in
the migration cycle and we know that in-flight data can wait.

Add freeze, thaw and restore callbacks for PM suspend and hibernation
support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
events, need to implement these xenbus_driver callbacks. The freeze handler
stops block-layer queue and disconnect the frontend from the backend while
freeing ring_info and associated resources. Before disconnecting from the
backend, we need to prevent any new IO from being queued and wait for
existing IO to complete. Freeze/unfreeze of the queues will guarantee
that there are no requests in use on the shared ring. However, for sanity
we should check state of the ring before disconnecting to make sure that
there are no outstanding requests to be processed on the ring.
The restore handler re-allocates ring_info, unquiesces and unfreezes the
queue and re-connect to the backend, so that rest of the kernel can
continue to use the block device transparently.

Note:For older backends,if a backend doesn't have commit'12ea729645ace'
xen/blkback: unmap all persistent grants when frontend gets disconnected,
the frontend may see massive amount of grant table warning when freeing
resources.
[   36.852659] deferring g.e. 0xf9 (pfn 0xffffffffffffffff)
[   36.855089] xen:grant_table: WARNING:e.g. 0x112 still in use!

In this case, persistent grants would need to be disabled.

[Anchal Agarwal: Changelog]:
RFC v1->v2: Removed timeout per request before disconnect during
	    blkfront freeze.
	    Added queue freeze/quiesce to the blkfront_freeze
	    Code cleanup
RFC v2->v3: None
RFC v3->v1: Code cleanup, Refractoring
    v1->v2: * remove err variable in blkfront_freeze
            * BugFix: error handling if rings are still busy
              after queue freeze/quiesce and returnign driver to
              connected state
            * add TODO if blkback fails to disconnect on freeze
            * Code formatting

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 drivers/block/xen-blkfront.c | 122 +++++++++++++++++++++++++++++++++--
 1 file changed, 118 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 3b889ea950c2..9e3ed1b9f509 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -48,6 +48,8 @@
 #include <linux/list.h>
 #include <linux/workqueue.h>
 #include <linux/sched/mm.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -80,6 +82,8 @@ enum blkif_state {
 	BLKIF_STATE_DISCONNECTED,
 	BLKIF_STATE_CONNECTED,
 	BLKIF_STATE_SUSPENDED,
+	BLKIF_STATE_FREEZING,
+	BLKIF_STATE_FROZEN,
 };
 
 struct grant {
@@ -219,6 +223,7 @@ struct blkfront_info
 	struct list_head requests;
 	struct bio_list bio_list;
 	struct list_head info_list;
+	struct completion wait_backend_disconnected;
 };
 
 static unsigned int nr_minors;
@@ -1005,6 +1010,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 	info->sector_size = sector_size;
 	info->physical_sector_size = physical_sector_size;
 	blkif_set_queue_limits(info);
+	init_completion(&info->wait_backend_disconnected);
 
 	return 0;
 }
@@ -1353,6 +1359,8 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	unsigned int i;
 	struct blkfront_ring_info *rinfo;
 
+	if (info->connected == BLKIF_STATE_FREEZING)
+		goto free_rings;
 	/* Prevent new requests being issued until we fix things up. */
 	info->connected = suspend ?
 		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
@@ -1360,6 +1368,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	if (info->rq)
 		blk_mq_stop_hw_queues(info->rq);
 
+free_rings:
 	for_each_rinfo(info, rinfo, i)
 		blkif_free_ring(rinfo);
 
@@ -1563,8 +1572,10 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
 	struct blkfront_info *info = rinfo->dev_info;
 
-	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
+	if (unlikely(info->connected != BLKIF_STATE_CONNECTED &&
+			info->connected != BLKIF_STATE_FREEZING)) {
 		return IRQ_HANDLED;
+	}
 
 	spin_lock_irqsave(&rinfo->ring_lock, flags);
  again:
@@ -2026,6 +2037,7 @@ static int blkif_recover(struct blkfront_info *info)
 	struct bio *bio;
 	unsigned int segs;
 	struct blkfront_ring_info *rinfo;
+	bool frozen = info->connected == BLKIF_STATE_FROZEN;
 
 	blkfront_gather_backend_features(info);
 	/* Reset limits changed by blk_mq_update_nr_hw_queues(). */
@@ -2048,6 +2060,9 @@ static int blkif_recover(struct blkfront_info *info)
 		kick_pending_request_queues(rinfo);
 	}
 
+	if (frozen)
+		return 0;
+
 	list_for_each_entry_safe(req, n, &info->requests, queuelist) {
 		/* Requeue pending requests (flush or discard) */
 		list_del_init(&req->queuelist);
@@ -2364,6 +2379,7 @@ static void blkfront_connect(struct blkfront_info *info)
 
 		return;
 	case BLKIF_STATE_SUSPENDED:
+	case BLKIF_STATE_FROZEN:
 		/*
 		 * If we are recovering from suspension, we need to wait
 		 * for the backend to announce it's features before
@@ -2481,12 +2497,37 @@ static void blkback_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosed:
-		if (dev->state == XenbusStateClosed)
+		if (dev->state == XenbusStateClosed) {
+			if (info->connected == BLKIF_STATE_FREEZING) {
+				blkif_free(info, 0);
+				info->connected = BLKIF_STATE_FROZEN;
+				complete(&info->wait_backend_disconnected);
+			}
 			break;
+		}
+		/*
+		 * We receive backend's Closed again while thawing
+		 * or restoring and it causes thawing or restoring to fail.
+		 * During blkfront_restore, backend is still in Closed state
+		 * and we receive backend as closed here while frontend's
+		 * dev->state is set to XenBusStateInitialized.
+		 * Ignore such unexpected state regardless of the backend's
+		 * state.
+		 */
+		if (info->connected == BLKIF_STATE_FROZEN) {
+			dev_dbg(&dev->dev, "Thawing/Restoring, ignore the backend's Closed state: %s",
+				dev->nodename);
+			break;
+		}
+
 		/* fall through */
 	case XenbusStateClosing:
-		if (info)
-			blkfront_closing(info);
+		if (info) {
+			if (info->connected == BLKIF_STATE_FREEZING)
+				xenbus_frontend_closed(dev);
+			else
+				blkfront_closing(info);
+		}
 		break;
 	}
 }
@@ -2630,6 +2671,76 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 	mutex_unlock(&blkfront_mutex);
 }
 
+static int blkfront_freeze(struct xenbus_device *dev)
+{
+	unsigned int i;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
+	struct blkfront_ring_info *rinfo;
+	/* This would be reasonable timeout as used in xenbus_dev_shutdown() */
+	unsigned int timeout = 5 * HZ;
+	unsigned long flags;
+
+	info->connected = BLKIF_STATE_FREEZING;
+
+	blk_mq_freeze_queue(info->rq);
+	blk_mq_quiesce_queue(info->rq);
+
+	for_each_rinfo(info, rinfo, i) {
+		/* No more gnttab callback work. */
+		gnttab_cancel_free_callback(&rinfo->callback);
+		/* Flush gnttab callback work. Must be done with no locks held. */
+		flush_work(&rinfo->work);
+	}
+
+	for_each_rinfo(info, rinfo, i) {
+		spin_lock_irqsave(&rinfo->ring_lock, flags);
+		if (RING_FULL(&rinfo->ring) ||
+			RING_HAS_UNCONSUMED_RESPONSES(&rinfo->ring)) {
+			spin_unlock_irqrestore(&rinfo->ring_lock, flags);
+			xenbus_dev_error(dev, -EBUSY, "Hibernation Failed. The ring is still busy");
+			info->connected = BLKIF_STATE_CONNECTED;
+			blk_mq_unquiesce_queue(info->rq);
+			blk_mq_unfreeze_queue(info->rq);
+			return -EBUSY;
+		}
+		spin_unlock_irqrestore(&rinfo->ring_lock, flags);
+	}
+	/* Kick the backend to disconnect */
+	xenbus_switch_state(dev, XenbusStateClosing);
+
+	/*
+	 * We don't want to move forward before the frontend is diconnected
+	 * from the backend cleanly.
+	 * TODO:Handle timeout by falling back to the normal
+	 * disconnect path and just wait for the backend to close before
+	 * reconnecting. Bring the system back to its original state by
+	 * failing hibernation gracefully.
+	 */
+	timeout = wait_for_completion_timeout(&info->wait_backend_disconnected,
+						timeout);
+	if (!timeout) {
+		xenbus_dev_error(dev, -EBUSY, "Freezing timed out;"
+			"the device may become inconsistent state");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int blkfront_restore(struct xenbus_device *dev)
+{
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
+	int err;
+
+	err = talk_to_blkback(dev, info);
+	if (!err) {
+		blk_mq_update_nr_hw_queues(&info->tag_set, info->nr_rings);
+		blk_mq_unquiesce_queue(info->rq);
+		blk_mq_unfreeze_queue(info->rq);
+	}
+	return err;
+}
+
 static const struct block_device_operations xlvbd_block_fops =
 {
 	.owner = THIS_MODULE,
@@ -2653,6 +2764,9 @@ static struct xenbus_driver blkfront_driver = {
 	.resume = blkfront_resume,
 	.otherend_changed = blkback_changed,
 	.is_ready = blkfront_is_ready,
+	.freeze = blkfront_freeze,
+	.thaw = blkfront_restore,
+	.restore = blkfront_restore
 };
 
 static void purge_persistent_grants(struct blkfront_info *info)
-- 
2.20.1

