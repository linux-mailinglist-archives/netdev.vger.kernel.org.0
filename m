Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6327C6D2B32
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 00:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjCaWRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 18:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjCaWRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 18:17:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2802C177
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 15:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87D97B83271
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 22:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB01C433EF;
        Fri, 31 Mar 2023 22:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680301034;
        bh=PO81GQ+cHDoeljK/vys7vnWNFMQhEaqiBpo55cdMq/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B410ycR4opPZkGelqE8Zzg7JUUXwDs16cRyc25rx0OPFXpjd9hWXxuYf4ekJekvKr
         y7XRtxVwz3zSIZ/M0rlNLLmaJTASJAMt1+HimtZfK9WfPfGgHBXL8gONq7xKspNVFy
         CrA5qOwuzMmqH2/NTN/XjmPD02SQGu7yJTFFX7ti8LZQ+MSBZ8MD7l82Outz3ld1bO
         Ymhqub/wSr5rfzlpuGpVf4ba7S3vh9jMUOq8ksxNxpRE5p3D3vCoGg7t+bavIcEZbi
         VtKn0+gZqUOBaQtUY+5yAPAoJC8m3ItXvybgG4PbfFagubiOzvXqzk14RsV6xHtQEh
         XbabiNZeKNURQ==
Date:   Fri, 31 Mar 2023 15:17:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     davem@davemloft.net, brouer@redhat.com, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230331151712.2ccd8317@kernel.org>
In-Reply-To: <20230331120643.09ce0e59@kernel.org>
References: <20230331043906.3015706-1-kuba@kernel.org>
        <c646d51c-4e91-bd86-9a5b-97b5a1ce33d0@redhat.com>
        <20230331120643.09ce0e59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 12:06:43 -0700 Jakub Kicinski wrote:
> > Make sense, but do read the comment above struct pp_alloc_cache.
> > The sizing of pp_alloc_cache is important for this trick/heuristic to
> > work, meaning the pp_alloc_cache have enough room.
> > It is definitely on purpose that pp_alloc_cache have 128 elements and is
> > only refill'ed with 64 elements, which leaves room for this kind of
> > trick.  But if Eric's deferred skb freeing have more than 64 pages to
> > free, then we will likely fallback to ptr_ring recycling.
> > 
> > Code wise, I suggest that you/we change page_pool_put_page_bulk() to
> > have a variant that 'allow_direct' (looking at code below, you might
> > already do this as this patch over-steer 'allow_direct').  Using the
> > bulk API, would then bulk into ptr_ring in the cases we cannot use
> > direct cache.  
> 
> Interesting point, let me re-run some tests with the statistics enabled.
> For a simple stream test I think it may just be too steady to trigger
> over/underflow. Each skb will carry at most 18 pages, and driver should
> only produce 64 packets / consume 64 pages. Each NAPI cycle will start
> by flushing the deferred free. So unless there is a hiccup either at the
> app or NAPI side - the flows of pages in each direction should be steady
> enough to do well with just 128 cache entries. Let me get the data and
> report back.

I patched the driver a bit to use page pool for HW-GRO.
Below are recycle stats with HW-GRO and with SW GRO + XDP_PASS (packet per page).

		HW-GRO				page=page
		before		after		before		after
recycle:
cached:			0	138669686		0	150197505
cache_full:		0	   223391		0	    74582
ring:		138551933         9997191	149299454		0
ring_full: 		0             488	     3154	   127590
released_refcnt:	0		0		0		0

alloc:
fast:		136491361	148615710	146969587	150322859
slow:		     1772	     1799	      144	      105
slow_high_order:	0		0		0		0
empty:		     1772	     1799	      144	      105
refill:		  2165245	   156302	  2332880	     2128
waive:			0		0		0		0

Which seems to confirm that for this trivial test the cache sizing is
good enough, and I won't see any benefit from batching (as cache is only
full respectively 0.16% and 0.05% of the time).
