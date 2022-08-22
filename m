Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4059C2A0
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbiHVPYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbiHVPYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:24:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2B31115;
        Mon, 22 Aug 2022 08:20:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5067C2030D;
        Mon, 22 Aug 2022 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661181602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u+unRvwl5RKeXktuSK+JeocNb4ORKTqv8ZYCMY8yQM8=;
        b=Z5JRAObP6PGpMdquxeMFMidbeOHtWJLVEE9H5TfjY4M/WMd9ZT0jW0WV9Yp7wIT2uHYujK
        vrtWNCDHB5cxvadCzxPjVH948tgFEUdcfX8l61/jqmxdXQSDRyrYuCK77OhGk7sq3xkBGI
        VPjgQZhJpqdOtppnpDO8v0bcGYh8wQQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 23E3D1332D;
        Mon, 22 Aug 2022 15:20:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id T4jUBaKeA2O6FQAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 22 Aug 2022 15:20:02 +0000
Date:   Mon, 22 Aug 2022 17:20:01 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
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
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for
 low/min
Message-ID: <YwOeocdkF/lacpKn@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-2-shakeelb@google.com>
 <YwNSlZFPMgclrSCz@dhcp22.suse.cz>
 <YwNX+vq9svMynVgW@dhcp22.suse.cz>
 <CALvZod720nwfP68OM2QtyyWJpOV5aO8xF6iuN0U2hpX9Pzj8PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod720nwfP68OM2QtyyWJpOV5aO8xF6iuN0U2hpX9Pzj8PA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 22-08-22 07:55:58, Shakeel Butt wrote:
> On Mon, Aug 22, 2022 at 3:18 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 22-08-22 11:55:33, Michal Hocko wrote:
> > > On Mon 22-08-22 00:17:35, Shakeel Butt wrote:
> > [...]
> > > > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > > > index eb156ff5d603..47711aa28161 100644
> > > > --- a/mm/page_counter.c
> > > > +++ b/mm/page_counter.c
> > > > @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
> > > >                                   unsigned long usage)
> > > >  {
> > > >     unsigned long protected, old_protected;
> > > > -   unsigned long low, min;
> > > >     long delta;
> > > >
> > > >     if (!c->parent)
> > > >             return;
> > > >
> > > > -   min = READ_ONCE(c->min);
> > > > -   if (min || atomic_long_read(&c->min_usage)) {
> > > > -           protected = min(usage, min);
> > > > +   protected = min(usage, READ_ONCE(c->min));
> > > > +   old_protected = atomic_long_read(&c->min_usage);
> > > > +   if (protected != old_protected) {
> > >
> > > I have to cache that code back into brain. It is really subtle thing and
> > > it is not really obvious why this is still correct. I will think about
> > > that some more but the changelog could help with that a lot.
> >
> > OK, so the this patch will be most useful when the min > 0 && min <
> > usage because then the protection doesn't really change since the last
> > call. In other words when the usage grows above the protection and your
> > workload benefits from this change because that happens a lot as only a
> > part of the workload is protected. Correct?
> 
> Yes, that is correct. I hope the experiment setup is clear now.

Maybe it is just me that it took a bit to grasp but maybe we want to
save our future selfs from going through that mental process again. So
please just be explicit about that in the changelog. It is really the
part that workloads excessing the protection will benefit the most that
would help to understand this patch.

> > Unless I have missed anything this shouldn't break the correctness but I
> > still have to think about the proportional distribution of the
> > protection because that adds to the complexity here.
> 
> The patch is not changing any semantics. It is just removing an
> unnecessary atomic xchg() for a specific scenario (min > 0 && min <
> usage). I don't think there will be any change related to proportional
> distribution of the protection.

Yes, I suspect you are right. I just remembered previous fixes
like 503970e42325 ("mm: memcontrol: fix memory.low proportional
distribution") which just made me nervous that this is a tricky area.

I will have another look tomorrow with a fresh brain and send an ack.
-- 
Michal Hocko
SUSE Labs
