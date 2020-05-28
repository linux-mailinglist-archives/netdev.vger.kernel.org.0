Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C281E61CE
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390208AbgE1NKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:10:07 -0400
Received: from mail.xenproject.org ([104.130.215.37]:42924 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390012AbgE1NKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:10:05 -0400
X-Greylist: delayed 2332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2020 09:10:04 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID
        :Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=yT0YCeVmS31oUgr3kcKp2rb0acVnrFO8fotP62VttFc=; b=AYKcpbquSFiA+Fd7AjYabIdcNc
        4c2MIIx960LxN3oKeum4woXDrPd63sTz6u9RAt3c7TQ/aIhITEKF4IXMi/5azqQSLBSyOIsbayblx
        Rr4HoSXPO1rM1AF1bil9f9PjFl8RKeIwRbeNJz/k/np4qPa4pVnpN0eeWuRSLh7XOXmI=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <roger@xen.org>)
        id 1jeHfy-000317-0c; Thu, 28 May 2020 12:30:22 +0000
Received: from [93.176.191.173] (helo=localhost)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <roger@xen.org>)
        id 1jeHfx-0002M2-9k; Thu, 28 May 2020 12:30:21 +0000
Date:   Thu, 28 May 2020 14:30:12 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger@xen.org>
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.com, axboe@kernel.dk,
        davem@davemloft.net, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, peterz@infradead.org, eduval@amazon.com,
        sblbir@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        benh@kernel.crashing.org
Subject: Re: [PATCH 06/12] xen-blkfront: add callbacks for PM suspend and
 hibernation
Message-ID: <20200528122956.GF1195@Air-de-Roger>
References: <cover.1589926004.git.anchalag@amazon.com>
 <ad580b4d5b76c18fe2fe409704f25622e01af361.1589926004.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad580b4d5b76c18fe2fe409704f25622e01af361.1589926004.git.anchalag@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 11:27:50PM +0000, Anchal Agarwal wrote:
> From: Munehisa Kamata <kamatam@amazon.com>
> 
> S4 power transition states are much different than xen
> suspend/resume. Former is visible to the guest and frontend drivers should
> be aware of the state transitions and should be able to take appropriate
> actions when needed. In transition to S4 we need to make sure that at least
> all the in-flight blkif requests get completed, since they probably contain
> bits of the guest's memory image and that's not going to get saved any
> other way. Hence, re-issuing of in-flight requests as in case of xen resume
> will not work here. This is in contrast to xen-suspend where we need to
> freeze with as little processing as possible to avoid dirtying RAM late in
> the migration cycle and we know that in-flight data can wait.
> 
> Add freeze, thaw and restore callbacks for PM suspend and hibernation
> support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
> events, need to implement these xenbus_driver callbacks. The freeze handler
> stops block-layer queue and disconnect the frontend from the backend while
> freeing ring_info and associated resources. Before disconnecting from the
> backend, we need to prevent any new IO from being queued and wait for existing
> IO to complete. Freeze/unfreeze of the queues will guarantee that there are no
> requests in use on the shared ring. However, for sanity we should check
> state of the ring before disconnecting to make sure that there are no
> outstanding requests to be processed on the ring. The restore handler
> re-allocates ring_info, unquiesces and unfreezes the queue and re-connect to
> the backend, so that rest of the kernel can continue to use the block device
> transparently.
> 
> Note:For older backends,if a backend doesn't have commit'12ea729645ace'
> xen/blkback: unmap all persistent grants when frontend gets disconnected,
> the frontend may see massive amount of grant table warning when freeing
> resources.
> [   36.852659] deferring g.e. 0xf9 (pfn 0xffffffffffffffff)
> [   36.855089] xen:grant_table: WARNING:e.g. 0x112 still in use!
> 
> In this case, persistent grants would need to be disabled.
> 
> [Anchal Changelog: Removed timeout/request during blkfront freeze.
> Reworked the whole patch to work with blk-mq and incorporate upstream's
> comments]

Please tag versions using vX and it would be helpful if you could list
the specific changes that you performed between versions. There where
3 RFC versions IIRC, and there's no log of the changes between them.

> 
> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> ---
>  drivers/block/xen-blkfront.c | 122 +++++++++++++++++++++++++++++++++--
>  1 file changed, 115 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 3b889ea950c2..464863ed7093 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -48,6 +48,8 @@
>  #include <linux/list.h>
>  #include <linux/workqueue.h>
>  #include <linux/sched/mm.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -80,6 +82,8 @@ enum blkif_state {
>  	BLKIF_STATE_DISCONNECTED,
>  	BLKIF_STATE_CONNECTED,
>  	BLKIF_STATE_SUSPENDED,
> +	BLKIF_STATE_FREEZING,
> +	BLKIF_STATE_FROZEN

Nit: adding a terminating ',' would prevent further additions from
having to modify this line.

>  };
>  
>  struct grant {
> @@ -219,6 +223,7 @@ struct blkfront_info
>  	struct list_head requests;
>  	struct bio_list bio_list;
>  	struct list_head info_list;
> +	struct completion wait_backend_disconnected;
>  };
>  
>  static unsigned int nr_minors;
> @@ -1005,6 +1010,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>  	info->sector_size = sector_size;
>  	info->physical_sector_size = physical_sector_size;
>  	blkif_set_queue_limits(info);
> +	init_completion(&info->wait_backend_disconnected);
>  
>  	return 0;
>  }
> @@ -1057,7 +1063,7 @@ static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
>  		case XEN_SCSI_DISK5_MAJOR:
>  		case XEN_SCSI_DISK6_MAJOR:
>  		case XEN_SCSI_DISK7_MAJOR:
> -			*offset = (*minor / PARTS_PER_DISK) + 
> +			*offset = (*minor / PARTS_PER_DISK) +
>  				((major - XEN_SCSI_DISK1_MAJOR + 1) * 16) +
>  				EMULATED_SD_DISK_NAME_OFFSET;
>  			*minor = *minor +
> @@ -1072,7 +1078,7 @@ static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
>  		case XEN_SCSI_DISK13_MAJOR:
>  		case XEN_SCSI_DISK14_MAJOR:
>  		case XEN_SCSI_DISK15_MAJOR:
> -			*offset = (*minor / PARTS_PER_DISK) + 
> +			*offset = (*minor / PARTS_PER_DISK) +

Unrelated changes, please split to a pre-patch.

>  				((major - XEN_SCSI_DISK8_MAJOR + 8) * 16) +
>  				EMULATED_SD_DISK_NAME_OFFSET;
>  			*minor = *minor +
> @@ -1353,6 +1359,8 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  	unsigned int i;
>  	struct blkfront_ring_info *rinfo;
>  
> +	if (info->connected == BLKIF_STATE_FREEZING)
> +		goto free_rings;
>  	/* Prevent new requests being issued until we fix things up. */
>  	info->connected = suspend ?
>  		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
> @@ -1360,6 +1368,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  	if (info->rq)
>  		blk_mq_stop_hw_queues(info->rq);
>  
> +free_rings:
>  	for_each_rinfo(info, rinfo, i)
>  		blkif_free_ring(rinfo);
>  
> @@ -1563,8 +1572,10 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>  	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
>  	struct blkfront_info *info = rinfo->dev_info;
>  
> -	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
> -		return IRQ_HANDLED;
> +	if (unlikely(info->connected != BLKIF_STATE_CONNECTED
> +		    && info->connected != BLKIF_STATE_FREEZING)){

Extra tab and missing space between '){'. Also my preference would be
for the && to go at the end of the previous line, like it's done
elsewhere in the file.

> +	    return IRQ_HANDLED;
> +	}
>  
>  	spin_lock_irqsave(&rinfo->ring_lock, flags);
>   again:
> @@ -2027,6 +2038,7 @@ static int blkif_recover(struct blkfront_info *info)
>  	unsigned int segs;
>  	struct blkfront_ring_info *rinfo;
>  
> +	bool frozen = info->connected == BLKIF_STATE_FROZEN;

Please put this together with the rest of the variable definitions,
and leave the empty line as a split between variable definitions and
code. I've already requested this on RFC v3 but you seem to have
dropped some of the requests I've made there.

>  	blkfront_gather_backend_features(info);
>  	/* Reset limits changed by blk_mq_update_nr_hw_queues(). */
>  	blkif_set_queue_limits(info);
> @@ -2048,6 +2060,9 @@ static int blkif_recover(struct blkfront_info *info)
>  		kick_pending_request_queues(rinfo);
>  	}
>  
> +	if (frozen)
> +		return 0;
> +
>  	list_for_each_entry_safe(req, n, &info->requests, queuelist) {
>  		/* Requeue pending requests (flush or discard) */
>  		list_del_init(&req->queuelist);
> @@ -2364,6 +2379,7 @@ static void blkfront_connect(struct blkfront_info *info)
>  
>  		return;
>  	case BLKIF_STATE_SUSPENDED:
> +	case BLKIF_STATE_FROZEN:
>  		/*
>  		 * If we are recovering from suspension, we need to wait
>  		 * for the backend to announce it's features before
> @@ -2481,12 +2497,36 @@ static void blkback_changed(struct xenbus_device *dev,
>  		break;
>  
>  	case XenbusStateClosed:
> -		if (dev->state == XenbusStateClosed)
> +		if (dev->state == XenbusStateClosed) {
> +			if (info->connected == BLKIF_STATE_FREEZING) {
> +				blkif_free(info, 0);
> +				info->connected = BLKIF_STATE_FROZEN;
> +				complete(&info->wait_backend_disconnected);
> +				break;

There's no need for the break here, you can rely on the break below.

> +			}
> +
>  			break;
> +		}
> +
> +		/*
> +		 * We may somehow receive backend's Closed again while thawing
> +		 * or restoring and it causes thawing or restoring to fail.
> +		 * Ignore such unexpected state regardless of the backend state.
> +		 */
> +		if (info->connected == BLKIF_STATE_FROZEN) {

I think you can join this with the previous dev->state == XenbusStateClosed?

Also, won't the device be in the Closed state already if it's in state
frozen?

> +			dev_dbg(&dev->dev,
> +					"ignore the backend's Closed state: %s",
> +					dev->nodename);
> +			break;
> +		}
>  		/* fall through */
>  	case XenbusStateClosing:
> -		if (info)
> -			blkfront_closing(info);
> +		if (info) {
> +			if (info->connected == BLKIF_STATE_FREEZING)
> +				xenbus_frontend_closed(dev);
> +			else
> +				blkfront_closing(info);
> +		}
>  		break;
>  	}
>  }
> @@ -2630,6 +2670,71 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
>  	mutex_unlock(&blkfront_mutex);
>  }
>  
> +static int blkfront_freeze(struct xenbus_device *dev)
> +{
> +	unsigned int i;
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> +	struct blkfront_ring_info *rinfo;
> +	/* This would be reasonable timeout as used in xenbus_dev_shutdown() */
> +	unsigned int timeout = 5 * HZ;
> +	unsigned long flags;
> +	int err = 0;
> +
> +	info->connected = BLKIF_STATE_FREEZING;
> +
> +	blk_mq_freeze_queue(info->rq);
> +	blk_mq_quiesce_queue(info->rq);
> +
> +	for_each_rinfo(info, rinfo, i) {
> +	    /* No more gnttab callback work. */
> +	    gnttab_cancel_free_callback(&rinfo->callback);
> +	    /* Flush gnttab callback work. Must be done with no locks held. */
> +	    flush_work(&rinfo->work);
> +	}
> +
> +	for_each_rinfo(info, rinfo, i) {
> +	    spin_lock_irqsave(&rinfo->ring_lock, flags);
> +	    if (RING_FULL(&rinfo->ring)
> +		    || RING_HAS_UNCONSUMED_RESPONSES(&rinfo->ring)) {

'||' should go at the end of the previous line.

> +		xenbus_dev_error(dev, err, "Hibernation Failed.
> +			The ring is still busy");
> +		info->connected = BLKIF_STATE_CONNECTED;
> +		spin_unlock_irqrestore(&rinfo->ring_lock, flags);

You need to unfreeze the queues here, or else the device will be in a
blocked state AFAICT.

> +		return -EBUSY;
> +	}
> +	    spin_unlock_irqrestore(&rinfo->ring_lock, flags);
> +	}

This block has indentation all messed up.

> +	/* Kick the backend to disconnect */
> +	xenbus_switch_state(dev, XenbusStateClosing);
> +
> +	/*
> +	 * We don't want to move forward before the frontend is diconnected
> +	 * from the backend cleanly.
> +	 */
> +	timeout = wait_for_completion_timeout(&info->wait_backend_disconnected,
> +					      timeout);
> +	if (!timeout) {
> +		err = -EBUSY;

Note err is only used here, and I think could just be dropped.

> +		xenbus_dev_error(dev, err, "Freezing timed out;"
> +				 "the device may become inconsistent state");

Leaving the device in this state is quite bad, as it's in a closed
state and with the queues frozen. You should make an attempt to
restore things to a working state.

> +	}
> +
> +	return err;
> +}
> +
> +static int blkfront_restore(struct xenbus_device *dev)
> +{
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> +	int err = 0;
> +
> +	err = talk_to_blkback(dev, info);
> +	blk_mq_unquiesce_queue(info->rq);
> +	blk_mq_unfreeze_queue(info->rq);
> +	if (!err)
> +	    blk_mq_update_nr_hw_queues(&info->tag_set, info->nr_rings);

Bad indentation. Also shouldn't you first update the queues and then
unfreeze them?

Thanks, Roger.
