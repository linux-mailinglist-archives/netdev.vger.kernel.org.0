Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066255E7DA7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiIWOyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIWOyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:54:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B6B12B4BF;
        Fri, 23 Sep 2022 07:54:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1obk49-0005kN-E1; Fri, 23 Sep 2022 16:54:09 +0200
Date:   Fri, 23 Sep 2022 16:54:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <20220923145409.GF22541@breakpoint.cc>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <Yy3GL12BOgp3wLjI@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yy3GL12BOgp3wLjI@pc636>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uladzislau Rezki <urezki@gmail.com> wrote:
> On Fri, Sep 23, 2022 at 03:35:12PM +0200, Florian Westphal wrote:
> > Michal Hocko <mhocko@suse.com> wrote:
> > > On Fri 23-09-22 12:38:58, Florian Westphal wrote:
> > > > Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
> > > >  kernel BUG at mm/vmalloc.c:2437!
> > > >  invalid opcode: 0000 [#1] SMP
> > > >  CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
> > > >  [..]
> > > >  RIP: 0010:__get_vm_area_node+0x120/0x130
> > > >   __vmalloc_node_range+0x96/0x1e0
> > > >   kvmalloc_node+0x92/0xb0
> > > >   bucket_table_alloc.isra.0+0x47/0x140
> > > >   rhashtable_try_insert+0x3a4/0x440
> > > >   rhashtable_insert_slow+0x1b/0x30
> > > >  [..]
> > > > 
> > > > bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
> > > > falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> > > > 
> > > > Revert the problematic change and stay with slab allocator.
> > > 
> > > Why don't you simply fix the caller?
> > 
> > Uh, not following?
> > 
> > kvzalloc(GFP_ATOMIC) was perfectly fine, is this illegal again?
> >
> <snip>
> static struct vm_struct *__get_vm_area_node(unsigned long size,
> 		unsigned long align, unsigned long shift, unsigned long flags,
> 		unsigned long start, unsigned long end, int node,
> 		gfp_t gfp_mask, const void *caller)
> {
> 	struct vmap_area *va;
> 	struct vm_struct *area;
> 	unsigned long requested_size = size;
> 
> 	BUG_ON(in_interrupt());
> ...
> <snip>
> 
> vmalloc is not supposed to be called from the IRQ context.

It uses kvzalloc, not vmalloc api.

Before 2018, rhashtable did use kzalloc OR kvzalloc, depending on gfp_t.

Quote from 93f976b5190df327939 changelog:
  As of ce91f6ee5b3b ("mm: kvmalloc does not fallback to vmalloc for
  incompatible gfp flags") we can simplify the caller
  and trust kvzalloc() to just do the right thing.

I fear that if this isn't allowed it will result in hard-to-spot bugs
because things will work fine until a fallback to vmalloc happens.

rhashtable may not be the only user of kvmalloc api that rely on
ability to call it from (soft)irq.
