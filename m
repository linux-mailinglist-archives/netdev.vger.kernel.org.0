Return-Path: <netdev+bounces-6921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37E6E718AEF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDBFC1C20F4F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AA83C0A7;
	Wed, 31 May 2023 20:16:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254913C0A5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:16:38 +0000 (UTC)
X-Greylist: delayed 447 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 13:16:10 PDT
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A6E55
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:16:10 -0700 (PDT)
Date: Wed, 31 May 2023 13:08:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685563719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MCDmBeWg+zG7uEZMpqk0ORpLnRVhc8FzIBTG2j8E62Y=;
	b=mLGQEeiQyjMSMtzOhV/R9hxVuyqt+7Jq4R62aBOvcMDyTEXRciRLn0fycPTqzzMDiIPHQQ
	DwwPoxXgN2/jZDXymtt6TFFmDKzRTWxO9g0Qm7eqE9JqCrqQS/h2BcPSSlSjMqndDta1WI
	uMNTPOtc4wdx6qPzL+nBrGzyfNrn/L4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
	linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, edumazet@google.com,
	pabeni@redhat.com, Matthew Wilcox <willy@infradead.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
Message-ID: <ZHepMQybpBcKLgVg@P9FQF9L96D.corp.robot.car>
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
 <81597717-0fed-5fd0-37d0-857d976b9d40@suse.cz>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81597717-0fed-5fd0-37d0-857d976b9d40@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 02:03:05PM +0200, Vlastimil Babka wrote:
> On 1/17/23 14:40, Jesper Dangaard Brouer wrote:
> > Allow API users of kmem_cache_create to specify that they don't want
> > any slab merge or aliasing (with similar sized objects). Use this in
> > network stack and kfence_test.
> > 
> > The SKB (sk_buff) kmem_cache slab is critical for network performance.
> > Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
> > performance by amortising the alloc/free cost.
> > 
> > For the bulk API to perform efficiently the slub fragmentation need to
> > be low. Especially for the SLUB allocator, the efficiency of bulk free
> > API depend on objects belonging to the same slab (page).
> > 
> > When running different network performance microbenchmarks, I started
> > to notice that performance was reduced (slightly) when machines had
> > longer uptimes. I believe the cause was 'skbuff_head_cache' got
> > aliased/merged into the general slub for 256 bytes sized objects (with
> > my kernel config, without CONFIG_HARDENED_USERCOPY).
> > 
> > For SKB kmem_cache network stack have reasons for not merging, but it
> > varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
> > We want to explicitly set SLAB_NEVER_MERGE for this kmem_cache.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Since this idea was revived by David [1], and neither patch worked as is,
> but yours was more complete and first, I have fixed it up as below. The
> skbuff part itself will be best submitted separately afterwards so we don't
> get conflicts between trees etc. Comments?
> 
> ----8<----
> From 485d3f58f3e797306b803102573e7f1367af2ad2 Mon Sep 17 00:00:00 2001
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Tue, 17 Jan 2023 14:40:00 +0100
> Subject: [PATCH] mm/slab: introduce kmem_cache flag SLAB_NO_MERGE
> 
> Allow API users of kmem_cache_create to specify that they don't want
> any slab merge or aliasing (with similar sized objects). Use this in
> kfence_test.
> 
> The SKB (sk_buff) kmem_cache slab is critical for network performance.
> Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
> performance by amortising the alloc/free cost.
> 
> For the bulk API to perform efficiently the slub fragmentation need to
> be low. Especially for the SLUB allocator, the efficiency of bulk free
> API depend on objects belonging to the same slab (page).
> 
> When running different network performance microbenchmarks, I started
> to notice that performance was reduced (slightly) when machines had
> longer uptimes. I believe the cause was 'skbuff_head_cache' got
> aliased/merged into the general slub for 256 bytes sized objects (with
> my kernel config, without CONFIG_HARDENED_USERCOPY).
> 
> For SKB kmem_cache network stack have reasons for not merging, but it
> varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
> We want to explicitly set SLAB_NO_MERGE for this kmem_cache.

I believe it's also good for the visibility: having a separate entity in
/proc/slabinfo for skbuff_head_cache can be really useful.

> 
> Another use case for the flag has been described by David Sterba [1]:
> 
> > This can be used for more fine grained control over the caches or for
> > debugging builds where separate slabs can verify that no objects leak.
> 
> > The slab_nomerge boot option is too coarse and would need to be
> > enabled on all testing hosts. There are some other ways how to disable
> > merging, e.g. a slab constructor but this disables poisoning besides
> > that it adds additional overhead. Other flags are internal and may
> > have other semantics.
> 
> > A concrete example what motivates the flag. During 'btrfs balance'
> > slab top reported huge increase in caches like
> 
> >  1330095 1330095 100%    0.10K  34105       39    136420K Acpi-ParseExt
> >  1734684 1734684 100%    0.14K  61953       28    247812K pid_namespace
> >  8244036 6873075  83%    0.11K 229001       36    916004K khugepaged_mm_slot
> 
> > which was confusing and that it's because of slab merging was not the
> > first idea.  After rebooting with slab_nomerge all the caches were
> > from btrfs_ namespace as expected.
> 
> [1] https://lore.kernel.org/all/20230524101748.30714-1-dsterba@suse.com/
> 
> [ vbabka@suse.cz: rename to SLAB_NO_MERGE, change the flag value to the
>   one proposed by David so it does not collide with internal SLAB/SLUB
>   flags, write a comment for the flag, expand changelog, drop the skbuff
>   part to be handled spearately ]
> 
> Reported-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
both for this patch and the corresponding change on the networking side.

Thanks!

