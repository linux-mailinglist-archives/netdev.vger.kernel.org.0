Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FFC133795
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 00:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgAGXm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 18:42:57 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49444 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgAGXm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 18:42:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578440575; x=1609976575;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=sgXQv4HvJqf6D8SBsviwIGss++68y1oAXrGUWnu7jvU=;
  b=Nk9iZD9EoqPb4RmsNroiCSNKDg/uYCfxMD7e5NjCro4T0IRel75xtB6N
   uJCcuL+pOovyhT8XaNbSeNYwTkvBO26sE6q2MPq+ghkbEHn0PGQx+XVuy
   lI+2WjMjejeKpiWac22+ZibWb3zbDdcvaX0Gy9Iykm4s3uu7CKH/uGfot
   A=;
IronPort-SDR: 57VXmmoMg6hbEEZWTqehsLwBen+n3tl5ousARI1x9jy4QLiZ16ebtWxRwKwT3oYp1H7pdP4u8n
 4i+h94Q8irww==
X-IronPort-AV: E=Sophos;i="5.69,407,1571702400"; 
   d="scan'208";a="11335300"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Jan 2020 23:42:53 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 0C74B141884;
        Tue,  7 Jan 2020 23:42:44 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:42:23 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:42:23 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 7 Jan 2020 23:42:23 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 9A4CE40E65; Tue,  7 Jan 2020 23:42:23 +0000 (UTC)
Date:   Tue, 7 Jan 2020 23:42:23 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.co>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>
CC:     <anchalag@amazon.com>
Subject: [RFC PATCH V2 06/11] xen-blkfront: add callbacks for PM suspend and
 hibernation
Message-ID: <20200107234223.GA18539@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
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
support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
events, need to implement these xenbus_driver callbacks.
The freeze handler stops a block-layer queue and disconnect the
frontend from the backend while freeing ring_info and associated resources.
The restore handler re-allocates ring_info and re-connect to the
backend, so the rest of the kernel can continue to use the block device
transparently. Also, the handlers are used for both PM suspend and
hibernation so that we can keep the existing suspend/resume callbacks for
Xen suspend without modification. Before disconnecting from backend,
we need to prevent any new IO from being queued and wait for existing
IO to complete. Freeze/unfreeze of the queues will guarantee that there
are no requests in use on the shared ring.

Note:For older backends,if a backend doesn't have commit'12ea729645ace'
xen/blkback: unmap all persistent grants when frontend gets disconnected,
the frontend may see massive amount of grant table warning when freeing
resources.
[   36.852659] deferring g.e. 0xf9 (pfn 0xffffffffffffffff)
[   36.855089] xen:grant_table: WARNING:e.g. 0x112 still in use!

In this case, persistent grants would need to be disabled.

[Anchal Changelog: Removed timeout/request during blkfront freeze.
Fixed major part of the code to work with blk-mq]
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 drivers/block/xen-blkfront.c | 119 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 112 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a74d03913822..b1d38ca4600f 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -47,6 +47,8 @@
 #include <linux/bitmap.h>
 #include <linux/list.h>
 #include <linux/workqueue.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -79,6 +81,8 @@ enum blkif_state {
 	BLKIF_STATE_DISCONNECTED,
 	BLKIF_STATE_CONNECTED,
 	BLKIF_STATE_SUSPENDED,
+	BLKIF_STATE_FREEZING,
+	BLKIF_STATE_FROZEN
 };
 
 struct grant {
@@ -220,6 +224,7 @@ struct blkfront_info
 	struct list_head requests;
 	struct bio_list bio_list;
 	struct list_head info_list;
+	struct completion wait_backend_disconnected;
 };
 
 static unsigned int nr_minors;
@@ -261,6 +266,7 @@ static DEFINE_SPINLOCK(minor_lock);
 static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo);
 static void blkfront_gather_backend_features(struct blkfront_info *info);
 static int negotiate_mq(struct blkfront_info *info);
+static void __blkif_free(struct blkfront_info *info);
 
 static int get_id_from_freelist(struct blkfront_ring_info *rinfo)
 {
@@ -995,6 +1001,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 	info->sector_size = sector_size;
 	info->physical_sector_size = physical_sector_size;
 	blkif_set_queue_limits(info);
+	init_completion(&info->wait_backend_disconnected);
 
 	return 0;
 }
@@ -1218,6 +1225,8 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 /* Already hold rinfo->ring_lock. */
 static inline void kick_pending_request_queues_locked(struct blkfront_ring_info *rinfo)
 {
+	if (unlikely(rinfo->dev_info->connected == BLKIF_STATE_FREEZING))
+		return;
 	if (!RING_FULL(&rinfo->ring))
 		blk_mq_start_stopped_hw_queues(rinfo->dev_info->rq, true);
 }
@@ -1341,8 +1350,6 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 
 static void blkif_free(struct blkfront_info *info, int suspend)
 {
-	unsigned int i;
-
 	/* Prevent new requests being issued until we fix things up. */
 	info->connected = suspend ?
 		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
@@ -1350,6 +1357,13 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	if (info->rq)
 		blk_mq_stop_hw_queues(info->rq);
 
+	__blkif_free(info);
+}
+
+static void __blkif_free(struct blkfront_info *info)
+{
+	unsigned int i;
+
 	for (i = 0; i < info->nr_rings; i++)
 		blkif_free_ring(&info->rinfo[i]);
 
@@ -1553,8 +1567,10 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
 	struct blkfront_info *info = rinfo->dev_info;
 
-	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
-		return IRQ_HANDLED;
+	if (unlikely(info->connected != BLKIF_STATE_CONNECTED)) {
+		if (info->connected != BLKIF_STATE_FREEZING)
+			return IRQ_HANDLED;
+	}
 
 	spin_lock_irqsave(&rinfo->ring_lock, flags);
  again:
@@ -2020,6 +2036,7 @@ static int blkif_recover(struct blkfront_info *info)
 	struct bio *bio;
 	unsigned int segs;
 
+	bool frozen = info->connected == BLKIF_STATE_FROZEN;
 	blkfront_gather_backend_features(info);
 	/* Reset limits changed by blk_mq_update_nr_hw_queues(). */
 	blkif_set_queue_limits(info);
@@ -2046,6 +2063,9 @@ static int blkif_recover(struct blkfront_info *info)
 		kick_pending_request_queues(rinfo);
 	}
 
+	if (frozen)
+		return 0;
+
 	list_for_each_entry_safe(req, n, &info->requests, queuelist) {
 		/* Requeue pending requests (flush or discard) */
 		list_del_init(&req->queuelist);
@@ -2359,6 +2379,7 @@ static void blkfront_connect(struct blkfront_info *info)
 
 		return;
 	case BLKIF_STATE_SUSPENDED:
+	case BLKIF_STATE_FROZEN:
 		/*
 		 * If we are recovering from suspension, we need to wait
 		 * for the backend to announce it's features before
@@ -2476,12 +2497,37 @@ static void blkback_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosed:
-		if (dev->state == XenbusStateClosed)
+		if (dev->state == XenbusStateClosed) {
+			if (info->connected == BLKIF_STATE_FREEZING) {
+				__blkif_free(info);
+				info->connected = BLKIF_STATE_FROZEN;
+				complete(&info->wait_backend_disconnected);
+				break;
+			}
+
 			break;
+		}
+
+		/*
+		 * We may somehow receive backend's Closed again while thawing
+		 * or restoring and it causes thawing or restoring to fail.
+		 * Ignore such unexpected state anyway.
+		 */
+		if (info->connected == BLKIF_STATE_FROZEN &&
+				dev->state == XenbusStateInitialised) {
+			dev_dbg(&dev->dev,
+					"ignore the backend's Closed state: %s",
+					dev->nodename);
+			break;
+		}
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
@@ -2625,6 +2671,62 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 	mutex_unlock(&blkfront_mutex);
 }
 
+static int blkfront_freeze(struct xenbus_device *dev)
+{
+	unsigned int i;
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
+	struct blkfront_ring_info *rinfo;
+	/* This would be reasonable timeout as used in xenbus_dev_shutdown() */
+	unsigned int timeout = 5 * HZ;
+	int err = 0;
+
+	info->connected = BLKIF_STATE_FREEZING;
+
+	blk_mq_freeze_queue(info->rq);
+	blk_mq_quiesce_queue(info->rq);
+
+	for (i = 0; i < info->nr_rings; i++) {
+		rinfo = &info->rinfo[i];
+
+		gnttab_cancel_free_callback(&rinfo->callback);
+		flush_work(&rinfo->work);
+	}
+
+	/* Kick the backend to disconnect */
+	xenbus_switch_state(dev, XenbusStateClosing);
+
+	/*
+	 * We don't want to move forward before the frontend is diconnected
+	 * from the backend cleanly.
+	 */
+	timeout = wait_for_completion_timeout(&info->wait_backend_disconnected,
+					      timeout);
+	if (!timeout) {
+		err = -EBUSY;
+		xenbus_dev_error(dev, err, "Freezing timed out;"
+				 "the device may become inconsistent state");
+	}
+
+	return err;
+}
+
+static int blkfront_restore(struct xenbus_device *dev)
+{
+	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
+	int err = 0;
+
+	err = talk_to_blkback(dev, info);
+	blk_mq_unquiesce_queue(info->rq);
+	blk_mq_unfreeze_queue(info->rq);
+
+	if (err)
+		goto out;
+	blk_mq_update_nr_hw_queues(&info->tag_set, info->nr_rings);
+
+out:
+	return err;
+}
+
 static const struct block_device_operations xlvbd_block_fops =
 {
 	.owner = THIS_MODULE,
@@ -2647,6 +2749,9 @@ static struct xenbus_driver blkfront_driver = {
 	.resume = blkfront_resume,
 	.otherend_changed = blkback_changed,
 	.is_ready = blkfront_is_ready,
+	.freeze = blkfront_freeze,
+	.thaw = blkfront_restore,
+	.restore = blkfront_restore
 };
 
 static void purge_persistent_grants(struct blkfront_info *info)
-- 
2.15.3.AMZN

