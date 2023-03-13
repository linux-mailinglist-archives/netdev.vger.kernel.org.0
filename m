Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6C86B7FDC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCMSAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCMSAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BC474DF3;
        Mon, 13 Mar 2023 11:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C700A6145D;
        Mon, 13 Mar 2023 18:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D010C433EF;
        Mon, 13 Mar 2023 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678730430;
        bh=LVvECMF2JRIS2+UZiegISVGjENHSYWHFcEABfHx4Ofo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmDkdvwH9Uawgk9LYBpbermXvvDECX/6RNccD8K+ELxVWRyH6oXSbon/VOBsEHR6n
         F6u1NrAxAZeeBN3YP4JLjsGKbj+ur3URprpXcm0b5SVWjRDxLSIAjZGXNSvk7r/yLy
         tREwM6XwdrHF5HOb86GOdDSTjy1yF+jdTm6cUtvIVPA8BIGCkRTeIQPH4r4GTlluwl
         BCo/sMkcG64jtK1CL/eqRKmrALGrDrDlniP5oBxWgtkK1uT0A2JJYB9imUUoNzCMVq
         ANF8rg4vOuACDCWW+Pm4zLOxx+DELNwtqJS/w1QFwVOHDfqhOV6uUXYIW5MaOfhqwq
         XFUCyzR3sbtJQ==
Date:   Mon, 13 Mar 2023 20:00:10 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Mike Rapoport <mike.rapoport@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Message-ID: <ZA9kqkyjWli2F3/Q@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <ZA2gofYkXRcJ8cLA@kernel.org>
 <20230313123147.6d28c47e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313123147.6d28c47e@gandalf.local.home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 12:31:47PM -0400, Steven Rostedt wrote:
> On Sun, 12 Mar 2023 11:51:29 +0200
> Mike Rapoport <mike.rapoport@gmail.com> wrote:
> 
> > git grep -in slob still gives a couple of matches. I've dropped the
> > irrelevant ones it it left me with these:
> > 
> > CREDITS:14:D: SLOB slab allocator
> > kernel/trace/ring_buffer.c:358: * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
> > mm/Kconfig:251:    SLOB allocator and is not recommended for systems with more than
> > mm/Makefile:25:KCOV_INSTRUMENT_slob.o := n
> >  
> > Except the comment in kernel/trace/ring_buffer.c all are trivial.
> > 
> > As for the comment in ring_buffer.c, it looks completely irrelevant at this
> > point.
> > 
> > @Steve?
> 
> You want me to remember something I wrote almost 15 years ago?

I just wanted to make sure you don't have a problem with removing this
comment :)

> I think I understand that comment as much as you do. Yeah, that was when
> I was still learning to write comments for my older self to understand,
> and I failed miserably!
>
> But git history comes to the rescue. The commit that added that comment was:
> 
> ed56829cb3195 ("ring_buffer: reset buffer page when freeing")
> 
> This was at a time when it was suggested to me to use the struct page
> directly in the ring buffer and where we could do fun "tricks" for
> "performance". (I was never really for this, but I wasn't going to argue).
> 
> And the code in question then had:
> 
> /*
>  * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
>  * this issue out.
>  */
> static inline void free_buffer_page(struct buffer_page *bpage)
> {
>         reset_page_mapcount(&bpage->page);
>         bpage->page.mapping = NULL;
>         __free_page(&bpage->page);
> }
> 
> 
> But looking at commit: e4c2ce82ca27 ("ring_buffer: allocate buffer page
> pointer")
> 
> It was finally decided that method was not safe, and we should not be using
> struct page but just allocate an actual page (much safer!).
> 
> I never got rid of the comment, which was more about that
> "reset_page_mapcount()", and should have been deleted back then.

Yeah, I did the same analysis, just was too lazy to post it.
 
> Just remove that comment. And you could even add:
> 
> Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")
> 
> -- Steve

-- 
Sincerely yours,
Mike.
