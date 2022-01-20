Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275A3494DCF
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiATMVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiATMVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:21:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA4DC061574;
        Thu, 20 Jan 2022 04:21:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B24A8616B1;
        Thu, 20 Jan 2022 12:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCDAC340E0;
        Thu, 20 Jan 2022 12:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642681294;
        bh=Rrtb4Z78kZvagGkT+zZbKk4bqZcLdYZB4YKkMxPDgz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n89ufXgxqBQmlVGQINtc9zHNVXP319B7qHybh3Qx+c0L2HqM31avHfgl6wa04P+PS
         U2a/VDC5IDPuFQ4eiMY82H6dmoHs8ZfK1kB9z7g/dnjdF0aqtH2rwy7iweU7l4nfCd
         uKCCdHIcWBEv0gR0OI3G7/t0anRLm/mFYQkndcecH0oX/QSV0Suoe05HTp9nWHxadN
         8tE23CL6HQC4nzhCVsDFmucKj+Hij7vZthIZmYs3fmCqG8MKMk5+rVRjnlI1OXbcca
         k2+X9OelbzYNhRg4+6sbjOuxpm57c2Blg09udLGHi+J7sZeVubFehVShcW+SAm/zNx
         OgVkpV0c7w+bQ==
Date:   Thu, 20 Jan 2022 14:21:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Praveen Kannoju <praveen.kannoju@oracle.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Message-ID: <YelTyePJh0l3U9Gk@unreal>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com>
 <Yee2tMJBd4kC8axv@unreal>
 <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
 <Yegmm4ksXfWiOMME@unreal>
 <PH0PR10MB55156B918F0D519B8A935C378C5A9@PH0PR10MB5515.namprd10.prod.outlook.com>
 <YelDT7AbnXO17PVf@unreal>
 <PH0PR10MB55154C4363F16B6EE003F8958C5A9@PH0PR10MB5515.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR10MB55154C4363F16B6EE003F8958C5A9@PH0PR10MB5515.namprd10.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 11:57:02AM +0000, Praveen Kannoju wrote:
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon@kernel.org]
> > Sent: 20 January 2022 04:41 PM
> > To: Praveen Kannoju <praveen.kannoju@oracle.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Santosh Shilimkar
> > <santosh.shilimkar@oracle.com>; David S . Miller <davem@davemloft.net>;
> > kuba@kernel.org; netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> > rds-devel@oss.oracle.com; linux-kernel@vger.kernel.org; Rama
> > Nichanamatlu <rama.nichanamatlu@oracle.com>; Rajesh
> > Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
> > Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the
> > asynchronous workers to flush the mr pool
> > 
> > On Thu, Jan 20, 2022 at 08:00:54AM +0000, Praveen Kannoju wrote:
> > > -----Original Message-----
> > > From: Leon Romanovsky [mailto:leon@kernel.org]
> > > Sent: 19 January 2022 08:26 PM
> > > To: Praveen Kannoju <praveen.kannoju@oracle.com>
> > > Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>; Jason Gunthorpe
> > > <jgg@ziepe.ca>; David S . Miller <davem@davemloft.net>;
> > > kuba@kernel.org; netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > rds-devel@oss.oracle.com; linux-kernel@vger.kernel.org; Rama
> > > Nichanamatlu <rama.nichanamatlu@oracle.com>; Rajesh
> > > Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
> > > Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the
> > > asynchronous workers to flush the mr pool
> > >
> > > On Wed, Jan 19, 2022 at 11:46:16AM +0000, Praveen Kannoju wrote:
> > > > -----Original Message-----
> > > > From: Leon Romanovsky [mailto:leon@kernel.org]
> > > > Sent: 19 January 2022 12:29 PM
> > > > To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Praveen Kannoju
> > > > <praveen.kannoju@oracle.com>; David S . Miller
> > > > <davem@davemloft.net>; kuba@kernel.org; netdev@vger.kernel.org;
> > > > linux-rdma@vger.kernel.org; rds-devel@oss.oracle.com;
> > > > linux-kernel@vger.kernel.org; Rama Nichanamatlu
> > > > <rama.nichanamatlu@oracle.com>; Rajesh Sivaramasubramaniom
> > > > <rajesh.sivaramasubramaniom@oracle.com>
> > > > Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by
> > > > the asynchronous workers to flush the mr pool
> > > >
> > > > On Tue, Jan 18, 2022 at 07:42:54PM +0000, Santosh Shilimkar wrote:
> > > > > On Jan 18, 2022, at 11:17 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > > >
> > > > > > On Tue, Jan 18, 2022 at 04:48:43PM +0000, Santosh Shilimkar wrote:
> > > > > >>
> > > > > >>> On Jan 18, 2022, at 6:47 AM, Praveen Kannoju
> > <praveen.kannoju@oracle.com> wrote:
> > > > > >>>
> > > > > >>> This patch aims to reduce the number of asynchronous workers
> > > > > >>> being spawned to execute the function "rds_ib_flush_mr_pool"
> > > > > >>> during the high I/O situations. Synchronous call path's to this
> > function "rds_ib_flush_mr_pool"
> > > > > >>> will be executed without being disturbed. By reducing the
> > > > > >>> number of processes contending to flush the mr pool, the total
> > > > > >>> number of D state processes waiting to acquire the mutex lock
> > > > > >>> will be greatly reduced, which otherwise were causing DB
> > > > > >>> instance crash as the corresponding processes were not
> > progressing while waiting to acquire the mutex lock.
> > > > > >>>
> > > > > >>> Signed-off-by: Praveen Kumar Kannoju
> > > > > >>> <praveen.kannoju@oracle.com> —
> > > > > >>>
> > > > > >> […]
> > > > > >>
> > > > > >>> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c index
> > > > > >>> 8f070ee..6b640b5 100644
> > > > > >>> +++ b/net/rds/ib_rdma.c
> > > > > >>> @@ -393,6 +393,8 @@ int rds_ib_flush_mr_pool(struct
> > rds_ib_mr_pool *pool,
> > > > > >>> 	 */
> > > > > >>> 	dirty_to_clean = llist_append_to_list(&pool->drop_list,
> > &unmap_list);
> > > > > >>> 	dirty_to_clean += llist_append_to_list(&pool->free_list,
> > > > > >>> &unmap_list);
> > > > > >>> +	WRITE_ONCE(pool->flush_ongoing, true);
> > > > > >>> +	smp_wmb();
> > > > > >>> 	if (free_all) {
> > > > > >>> 		unsigned long flags;
> > > > > >>>
> > > > > >>> @@ -430,6 +432,8 @@ int rds_ib_flush_mr_pool(struct
> > rds_ib_mr_pool *pool,
> > > > > >>> 	atomic_sub(nfreed, &pool->item_count);
> > > > > >>>
> > > > > >>> out:
> > > > > >>> +	WRITE_ONCE(pool->flush_ongoing, false);
> > > > > >>> +	smp_wmb();
> > > > > >>> 	mutex_unlock(&pool->flush_lock);
> > > > > >>> 	if (waitqueue_active(&pool->flush_wait))
> > > > > >>> 		wake_up(&pool->flush_wait);
> > > > > >>> @@ -507,8 +511,17 @@ void rds_ib_free_mr(void *trans_private,
> > > > > >>> int
> > > > > >>> invalidate)
> > > > > >>>
> > > > > >>> 	/* If we've pinned too many pages, request a flush */
> > > > > >>> 	if (atomic_read(&pool->free_pinned) >= pool-
> > >max_free_pinned ||
> > > > > >>> -	    atomic_read(&pool->dirty_count) >= pool->max_items / 5)
> > > > > >>> -		queue_delayed_work(rds_ib_mr_wq, &pool-
> > >flush_worker, 10);
> > > > > >>> +	    atomic_read(&pool->dirty_count) >= pool->max_items / 5)
> > {
> > > > > >>> +		smp_rmb();
> > > > > >> You won’t need these explicit barriers since above atomic and
> > > > > >> write once already issue them.
> > > > > >
> > > > > > No, they don't. Use smp_store_release() and smp_load_acquire if
> > > > > > you want to do something like this, but I still can't quite
> > > > > > figure out if this usage of unlocked memory accesses makes any
> > sense at all.
> > > > > >
> > > > > Indeed, I see that now, thanks. Yeah, these multi variable checks
> > > > > can indeed be racy but they are under lock at least for this code path.
> > > > > But there are few hot path places where single variable states are
> > > > > evaluated atomically instead of heavy lock.
> > > >
> > > > At least pool->dirty_count is not locked in rds_ib_free_mr() at all.
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Regards,
> > > > > Santosh
> > > > >
> > > >
> > > > Thank you Santosh, Leon and Jason for reviewing the Patch.
> > > >
> > > > 1. Leon, the bool variable "flush_ongoing " introduced through the patch
> > has to be accessed only after acquiring the mutex lock. Hence it is well
> > protected.
> > >
> > > I don't see any lock in rds_ib_free_mr() function where your perform "if
> > (!READ_ONCE(pool->flush_ongoing)) { ...".
> > >
> > > >
> > > > 2. As the commit message already conveys the reason, the check being
> > made in the function "rds_ib_free_mr" is only to avoid the redundant
> > asynchronous workers from being spawned.
> > > >
> > > > 3. The synchronous flush path's through the function "rds_free_mr" with
> > either cookie=0 or "invalidate" flag being set, have to be honoured as per the
> > semantics and hence these paths have to execute the function
> > "rds_ib_flush_mr_pool" unconditionally.
> > > >
> > > > 4. It complicates the patch to identify, where from the function
> > "rds_ib_flush_mr_pool", has been called. And hence, this patch uses the
> > state of the bool variable to stop the asynchronous workers.
> > > >
> > > > 5. We knew that "queue_delayed_work" will ensures only one work is
> > running, but avoiding these async workers during high load situations, made
> > way for the allocation and synchronous callers which would otherwise be
> > waiting long for the flush to happen. Great reduction in the number of calls
> > to the function "rds_ib_flush_mr_pool" has been observed with this patch.
> > >
> > > So if you understand that there is only one work in progress, why do you
> > say workerS?
> > >
> > > Thanks
> > >
> > > >
> > > > 6. Jason, the only function "rds_ib_free_mr" which accesses the
> > introduced bool variable "flush_ongoing" to spawn a flush worker does not
> > crucially impact the availability of MR's, because the flush happens from
> > allocation path as well when necessary.   Hence the Load-store ordering is
> > not essentially needed here, because of which we chose smp_rmb() and
> > smp_wmb() over smp_load_acquire() and smp_store_release().
> > > >
> > > > Regards,
> > > > Praveen.
> > >
> > >
> > > Jason,
> > >
> > > 	The relaxed ordering primitives smp_rmb() and smp_wmb() ensure
> > to provide
> > > 	guaranteed atomic memory operations READ_ONCE and
> > WRITE_ONCE, used in the
> > > 	functions "rds_ib_free_mr" and "rds_ib_flush_mr_pool"
> > correspondingly.
> > >
> > > 	Yes, the memory barrier primitives smp_load_acquire()and
> > smp_store_release()
> > > 	are even better. But, because of the simplicity of the use of memory
> > barrier
> > > 	in the patch, smp_rmb() and smp_wmb() are chosen.
> > >
> > > 	Please let me know if you want me to switch to smp_load_acquire()
> > and
> > > 	smp_store_release().
> > >
> > > Leon,
> > >
> > > 	Avoiding the asynchronous worker from being spawned during the
> > high load situations,
> > > 	make way for both synchronous and allocation path to flush the mr
> > pool and grab the
> > > 	mr without waiting.
> > >
> > > 	Please let me know if you still have any queries with this respect or
> > any modifications
> > > 	are needed.
> > 
> Thank you for your reply, Leon.
> 
> > I didn't get any answer on my questions.
> > So let's me repeat them.
> > 1. Where can I see locks in rds_ib_free_mr() that protects concurrent change
> > of your new flush_ongoing field?
> 
> flush_ongoing variable is only modified in the function "rds_ib_flush_mr_pool" under mutex lock. It is only being read atomically in the function "rds_ib_free_mr()", with memory barrier in place.  Hence a lock is not essential in this function "rds_ib_free_mr()". Depending on the value being read, decision is taken weather to spawn the asynchronous worker or not. 

This is not how locking works.

 CPU1                                     CPU2      
  rds_ib_flush_mr_pool
  lock
                        context switch -> rds_ib_free_mr
			                  READ old value of flush_ongoing
			<- context switch
  WRITE new value to flush_ongoing
			              

> 
> > 2. There is only one same work can be executed/scheduled, where do you
> > see multiple/parallel workers (plural) and how is it possible?
> 
> In my earlier comment, I have re-iterated the same point. I would take back my word "workerS". By avoiding this asynchronous worker to participate in flushing, the synchronous flush jobs (cookie=0 and invalidate=1) as well as allocation path worker will be acquiring the mutex lock in the function "rds_ib_flush_mr_pool" quickly, thereby fetching the MR.

This is completely different scenario from what was presented before.
You are interested to prioritize synchronous operations over async.
In such case, why don't you simply cancel_delayed_work() in your sync
flows?

> 
> I hope I am clear. 
> 
> > BTW, please fix your email client to reply inline.
> Fixed it. Thank you. 
> > 
> > >
> > > Regards,
> > > Praveen.
> 
> 
> Regards,
> Praveen.
