Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32FF494C8B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiATLLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:11:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiATLLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:11:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9D9861505;
        Thu, 20 Jan 2022 11:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7689BC340E0;
        Thu, 20 Jan 2022 11:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642677076;
        bh=GGzWXBrUg14FIR2o+wGqcRJ0noPIWzuk1kdN0teOW4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aO/Vpw4V5Cw1IYA5djIJTyXLMBi5I0mKh2bZr6skXcKtunhtVA1b+lLISMbqxfyFg
         IGD5AyvtqnFwomB0lPxkwGOujAmiBUtM2ak61KDV7wYhebG3cM2AAIiQr47n9dLOql
         dlYxQOPGELJiXGpk95dzl/Bo3LXf82XNNwTirhsDvMFJ1rnjupHsZFeoh1bfa9eLeh
         q7JWAle/lIl67DCHLzahFSx+WwYXibr9gnDxv2i4qMiUedZclAivL+UGbzuOLeSVHv
         EOS3n157BQdPyMlYSp36lWck9yQN7912o5/SYrG517pxviizDfl3HFbsfP8c4luhDl
         hR+kNU5Y2KLuQ==
Date:   Thu, 20 Jan 2022 13:11:11 +0200
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
Message-ID: <YelDT7AbnXO17PVf@unreal>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com>
 <Yee2tMJBd4kC8axv@unreal>
 <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
 <Yegmm4ksXfWiOMME@unreal>
 <PH0PR10MB55156B918F0D519B8A935C378C5A9@PH0PR10MB5515.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR10MB55156B918F0D519B8A935C378C5A9@PH0PR10MB5515.namprd10.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 08:00:54AM +0000, Praveen Kannoju wrote:
> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org] 
> Sent: 19 January 2022 08:26 PM
> To: Praveen Kannoju <praveen.kannoju@oracle.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>; Jason Gunthorpe <jgg@ziepe.ca>; David S . Miller <davem@davemloft.net>; kuba@kernel.org; netdev@vger.kernel.org; linux-rdma@vger.kernel.org; rds-devel@oss.oracle.com; linux-kernel@vger.kernel.org; Rama Nichanamatlu <rama.nichanamatlu@oracle.com>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
> Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the asynchronous workers to flush the mr pool
> 
> On Wed, Jan 19, 2022 at 11:46:16AM +0000, Praveen Kannoju wrote:
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon@kernel.org]
> > Sent: 19 January 2022 12:29 PM
> > To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Praveen Kannoju 
> > <praveen.kannoju@oracle.com>; David S . Miller <davem@davemloft.net>; 
> > kuba@kernel.org; netdev@vger.kernel.org; linux-rdma@vger.kernel.org; 
> > rds-devel@oss.oracle.com; linux-kernel@vger.kernel.org; Rama 
> > Nichanamatlu <rama.nichanamatlu@oracle.com>; Rajesh 
> > Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>
> > Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the 
> > asynchronous workers to flush the mr pool
> > 
> > On Tue, Jan 18, 2022 at 07:42:54PM +0000, Santosh Shilimkar wrote:
> > > On Jan 18, 2022, at 11:17 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > 
> > > > On Tue, Jan 18, 2022 at 04:48:43PM +0000, Santosh Shilimkar wrote:
> > > >> 
> > > >>> On Jan 18, 2022, at 6:47 AM, Praveen Kannoju <praveen.kannoju@oracle.com> wrote:
> > > >>> 
> > > >>> This patch aims to reduce the number of asynchronous workers 
> > > >>> being spawned to execute the function "rds_ib_flush_mr_pool" 
> > > >>> during the high I/O situations. Synchronous call path's to this function "rds_ib_flush_mr_pool"
> > > >>> will be executed without being disturbed. By reducing the number 
> > > >>> of processes contending to flush the mr pool, the total number 
> > > >>> of D state processes waiting to acquire the mutex lock will be 
> > > >>> greatly reduced, which otherwise were causing DB instance crash 
> > > >>> as the corresponding processes were not progressing while waiting to acquire the mutex lock.
> > > >>> 
> > > >>> Signed-off-by: Praveen Kumar Kannoju 
> > > >>> <praveen.kannoju@oracle.com> —
> > > >>> 
> > > >> […]
> > > >> 
> > > >>> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c index
> > > >>> 8f070ee..6b640b5 100644
> > > >>> +++ b/net/rds/ib_rdma.c
> > > >>> @@ -393,6 +393,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
> > > >>> 	 */
> > > >>> 	dirty_to_clean = llist_append_to_list(&pool->drop_list, &unmap_list);
> > > >>> 	dirty_to_clean += llist_append_to_list(&pool->free_list,
> > > >>> &unmap_list);
> > > >>> +	WRITE_ONCE(pool->flush_ongoing, true);
> > > >>> +	smp_wmb();
> > > >>> 	if (free_all) {
> > > >>> 		unsigned long flags;
> > > >>> 
> > > >>> @@ -430,6 +432,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
> > > >>> 	atomic_sub(nfreed, &pool->item_count);
> > > >>> 
> > > >>> out:
> > > >>> +	WRITE_ONCE(pool->flush_ongoing, false);
> > > >>> +	smp_wmb();
> > > >>> 	mutex_unlock(&pool->flush_lock);
> > > >>> 	if (waitqueue_active(&pool->flush_wait))
> > > >>> 		wake_up(&pool->flush_wait);
> > > >>> @@ -507,8 +511,17 @@ void rds_ib_free_mr(void *trans_private, 
> > > >>> int
> > > >>> invalidate)
> > > >>> 
> > > >>> 	/* If we've pinned too many pages, request a flush */
> > > >>> 	if (atomic_read(&pool->free_pinned) >= pool->max_free_pinned ||
> > > >>> -	    atomic_read(&pool->dirty_count) >= pool->max_items / 5)
> > > >>> -		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
> > > >>> +	    atomic_read(&pool->dirty_count) >= pool->max_items / 5) {
> > > >>> +		smp_rmb();
> > > >> You won’t need these explicit barriers since above atomic and 
> > > >> write once already issue them.
> > > > 
> > > > No, they don't. Use smp_store_release() and smp_load_acquire if 
> > > > you want to do something like this, but I still can't quite figure 
> > > > out if this usage of unlocked memory accesses makes any sense at all.
> > > > 
> > > Indeed, I see that now, thanks. Yeah, these multi variable checks 
> > > can indeed be racy but they are under lock at least for this code path.
> > > But there are few hot path places where single variable states are 
> > > evaluated atomically instead of heavy lock.
> > 
> > At least pool->dirty_count is not locked in rds_ib_free_mr() at all.
> > 
> > Thanks
> > 
> > > 
> > > Regards,
> > > Santosh
> > > 
> > 
> > Thank you Santosh, Leon and Jason for reviewing the Patch.
> > 
> > 1. Leon, the bool variable "flush_ongoing " introduced through the patch has to be accessed only after acquiring the mutex lock. Hence it is well protected.
> 
> I don't see any lock in rds_ib_free_mr() function where your perform "if (!READ_ONCE(pool->flush_ongoing)) { ...".
> 
> > 
> > 2. As the commit message already conveys the reason, the check being made in the function "rds_ib_free_mr" is only to avoid the redundant asynchronous workers from being spawned.
> > 
> > 3. The synchronous flush path's through the function "rds_free_mr" with either cookie=0 or "invalidate" flag being set, have to be honoured as per the semantics and hence these paths have to execute the function "rds_ib_flush_mr_pool" unconditionally.
> > 
> > 4. It complicates the patch to identify, where from the function "rds_ib_flush_mr_pool", has been called. And hence, this patch uses the state of the bool variable to stop the asynchronous workers.
> > 
> > 5. We knew that "queue_delayed_work" will ensures only one work is running, but avoiding these async workers during high load situations, made way for the allocation and synchronous callers which would otherwise be waiting long for the flush to happen. Great reduction in the number of calls to the function "rds_ib_flush_mr_pool" has been observed with this patch. 
> 
> So if you understand that there is only one work in progress, why do you say workerS?
> 
> Thanks
> 
> > 
> > 6. Jason, the only function "rds_ib_free_mr" which accesses the introduced bool variable "flush_ongoing" to spawn a flush worker does not crucially impact the availability of MR's, because the flush happens from allocation path as well when necessary.   Hence the Load-store ordering is not essentially needed here, because of which we chose smp_rmb() and smp_wmb() over smp_load_acquire() and smp_store_release().
> > 
> > Regards,
> > Praveen.
> 
> 
> Jason,
> 
> 	The relaxed ordering primitives smp_rmb() and smp_wmb() ensure to provide
> 	guaranteed atomic memory operations READ_ONCE and WRITE_ONCE, used in the
> 	functions "rds_ib_free_mr" and "rds_ib_flush_mr_pool" correspondingly.
> 
> 	Yes, the memory barrier primitives smp_load_acquire()and smp_store_release() 
> 	are even better. But, because of the simplicity of the use of memory barrier
> 	in the patch, smp_rmb() and smp_wmb() are chosen. 
> 
> 	Please let me know if you want me to switch to smp_load_acquire() and
> 	smp_store_release().
> 
> Leon,
> 
> 	Avoiding the asynchronous worker from being spawned during the high load situations,
> 	make way for both synchronous and allocation path to flush the mr pool and grab the
> 	mr without waiting.
> 
> 	Please let me know if you still have any queries with this respect or any modifications
> 	are needed.

I didn't get any answer on my questions.
So let's me repeat them.
1. Where can I see locks in rds_ib_free_mr() that protects concurrent
change of your new flush_ongoing field?
2. There is only one same work can be executed/scheduled, where do you
see multiple/parallel workers (plural) and how is it possible?

BTW, please fix your email client to reply inline.

> 
> Regards,
> Praveen.
