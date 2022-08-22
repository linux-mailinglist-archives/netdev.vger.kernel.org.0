Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F377559C637
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiHVS2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiHVS2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:28:02 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3038C48E84;
        Mon, 22 Aug 2022 11:27:52 -0700 (PDT)
Date:   Mon, 22 Aug 2022 11:27:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661192870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=859bRFvYP0PwP1RQEaN1BuNqPudeM49yRCMP2gzbo/M=;
        b=mCGQi+2b3AdYVcCk9kc+RYKSR5DNMp8IBmyH6G+E69Cq3b2l19KvwGFIuMAQgaZ1ip974E
        Gfuml2lG4ZQJmNqdc9vHZ1ompfYFjZdFzV0Xj/H73RUciXDYNcSERvs7e3WDbYpIjcVsB1
        T0npKZERgo9FQlUXzHgUKV2CBE3OL1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter
 fields
Message-ID: <YwPKojTHxV4PFoKn@P9FQF9L96D>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-3-shakeelb@google.com>
 <YwNZD4YlRkvQCWFi@dhcp22.suse.cz>
 <CALvZod5pw_7hnH44hdC3rDGQxQB2XATrViNNGosG3FnUoWo-4A@mail.gmail.com>
 <YwOde3qFvne7Umld@dhcp22.suse.cz>
 <CALvZod4whYX+0ZuCGgyKuG-Q_9d0g7N_x+=WXOeB_1TM=3Q7vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod4whYX+0ZuCGgyKuG-Q_9d0g7N_x+=WXOeB_1TM=3Q7vg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 09:04:59AM -0700, Shakeel Butt wrote:
> On Mon, Aug 22, 2022 at 8:15 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 22-08-22 08:06:14, Shakeel Butt wrote:
> > [...]
> > > > >  struct page_counter {
> > > > > +     /*
> > > > > +      * Make sure 'usage' does not share cacheline with any other field. The
> > > > > +      * memcg->memory.usage is a hot member of struct mem_cgroup.
> > > > > +      */
> > > > > +     PC_PADDING(_pad1_);
> > > >
> > > > Why don't you simply require alignment for the structure?
> > >
> > > I don't just want the alignment of the structure. I want different
> > > fields of this structure to not share the cache line. More
> > > specifically the 'high' and 'usage' fields. With this change the usage
> > > will be its own cache line, the read-most fields will be on separate
> > > cache line and the fields which sometimes get updated on charge path
> > > based on some condition will be a different cache line from the
> > > previous two.
> >
> > I do not follow. If you make an explicit requirement for the structure
> > alignement then the first field in the structure will be guarantied to
> > have that alignement and you achieve the rest to be in the other cache
> > line by adding padding behind that.
> 
> Oh, you were talking explicitly about _pad1_, yes, we can remove it
> and make the struct cache align. I will do it in the next version.

Yes, please, it caught my eyes too.
With this change:
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Also, can you, please, include the numbers on the additional memory overhead?
I think it still worth it, just think we need to include them for a record.

Thanks!
