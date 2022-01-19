Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F7493531
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351853AbiASG7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 01:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242328AbiASG7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 01:59:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DC3C061574;
        Tue, 18 Jan 2022 22:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 796E7612C4;
        Wed, 19 Jan 2022 06:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6B2C004E1;
        Wed, 19 Jan 2022 06:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642575545;
        bh=Pt6R+AEyWFXdl8U2QBDrYxNGlP3nwbUyAONzX9MOrdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MTdMtvyeQgpsClX00DEelSBLn913bNw7uxDN+W+kBWvauruTkTdCsaourTerq8u6c
         wxsw+r9+VF+3kaODHvpTkjMIOSd+fFwlNx43Dwnqicr/X0cf0fSCdFPtmgVsOPMDKp
         qZshUoXeHdr5AWUCOa2w9KraBYymGFktTBA5/p4P5WioLMRHOgcrheY0G+fqzvkodE
         NfEaly2aSOZcmgS32qwnKA+jsjGiEa6lBRrs1jVZUN0ZCFP5XY6EV9AXeMFpWtaM1A
         8BH9UMpGp3tMRIUEUdHN5UEDb/RrYWmav3w1zCDQkTBB1f5eqFzRar0Lf/mfHYHEJt
         Y8NS8Ldl2m+YA==
Date:   Wed, 19 Jan 2022 08:59:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Praveen Kannoju <praveen.kannoju@oracle.com>,
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
Message-ID: <Yee2tMJBd4kC8axv@unreal>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 07:42:54PM +0000, Santosh Shilimkar wrote:
> On Jan 18, 2022, at 11:17 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > On Tue, Jan 18, 2022 at 04:48:43PM +0000, Santosh Shilimkar wrote:
> >> 
> >>> On Jan 18, 2022, at 6:47 AM, Praveen Kannoju <praveen.kannoju@oracle.com> wrote:
> >>> 
> >>> This patch aims to reduce the number of asynchronous workers being spawned
> >>> to execute the function "rds_ib_flush_mr_pool" during the high I/O
> >>> situations. Synchronous call path's to this function "rds_ib_flush_mr_pool"
> >>> will be executed without being disturbed. By reducing the number of
> >>> processes contending to flush the mr pool, the total number of D state
> >>> processes waiting to acquire the mutex lock will be greatly reduced, which
> >>> otherwise were causing DB instance crash as the corresponding processes
> >>> were not progressing while waiting to acquire the mutex lock.
> >>> 
> >>> Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
> >>> —
> >>> 
> >> […]
> >> 
> >>> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> >>> index 8f070ee..6b640b5 100644
> >>> +++ b/net/rds/ib_rdma.c
> >>> @@ -393,6 +393,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
> >>> 	 */
> >>> 	dirty_to_clean = llist_append_to_list(&pool->drop_list, &unmap_list);
> >>> 	dirty_to_clean += llist_append_to_list(&pool->free_list, &unmap_list);
> >>> +	WRITE_ONCE(pool->flush_ongoing, true);
> >>> +	smp_wmb();
> >>> 	if (free_all) {
> >>> 		unsigned long flags;
> >>> 
> >>> @@ -430,6 +432,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
> >>> 	atomic_sub(nfreed, &pool->item_count);
> >>> 
> >>> out:
> >>> +	WRITE_ONCE(pool->flush_ongoing, false);
> >>> +	smp_wmb();
> >>> 	mutex_unlock(&pool->flush_lock);
> >>> 	if (waitqueue_active(&pool->flush_wait))
> >>> 		wake_up(&pool->flush_wait);
> >>> @@ -507,8 +511,17 @@ void rds_ib_free_mr(void *trans_private, int invalidate)
> >>> 
> >>> 	/* If we've pinned too many pages, request a flush */
> >>> 	if (atomic_read(&pool->free_pinned) >= pool->max_free_pinned ||
> >>> -	    atomic_read(&pool->dirty_count) >= pool->max_items / 5)
> >>> -		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
> >>> +	    atomic_read(&pool->dirty_count) >= pool->max_items / 5) {
> >>> +		smp_rmb();
> >> You won’t need these explicit barriers since above atomic and write once already
> >> issue them.
> > 
> > No, they don't. Use smp_store_release() and smp_load_acquire if you
> > want to do something like this, but I still can't quite figure out if
> > this usage of unlocked memory accesses makes any sense at all.
> > 
> Indeed, I see that now, thanks. Yeah, these multi variable checks can indeed
> be racy but they are under lock at least for this code path. But there are few
> hot path places where single variable states are evaluated atomically instead of
> heavy lock. 

At least pool->dirty_count is not locked in rds_ib_free_mr() at all.

Thanks

> 
> Regards,
> Santosh
> 
