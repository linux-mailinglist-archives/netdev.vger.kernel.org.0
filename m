Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE436B7DA1
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjCMQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjCMQdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67F87B4A8;
        Mon, 13 Mar 2023 09:32:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 309D961361;
        Mon, 13 Mar 2023 16:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F364C433EF;
        Mon, 13 Mar 2023 16:31:48 +0000 (UTC)
Date:   Mon, 13 Mar 2023 12:31:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mike Rapoport <mike.rapoport@gmail.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
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
        Mike Rapoport <rppt@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with
 kmem_cache_alloc()
Message-ID: <20230313123147.6d28c47e@gandalf.local.home>
In-Reply-To: <ZA2gofYkXRcJ8cLA@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
        <ZA2gofYkXRcJ8cLA@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Mar 2023 11:51:29 +0200
Mike Rapoport <mike.rapoport@gmail.com> wrote:

> git grep -in slob still gives a couple of matches. I've dropped the
> irrelevant ones it it left me with these:
> 
> CREDITS:14:D: SLOB slab allocator
> kernel/trace/ring_buffer.c:358: * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
> mm/Kconfig:251:    SLOB allocator and is not recommended for systems with more than
> mm/Makefile:25:KCOV_INSTRUMENT_slob.o := n
>  
> Except the comment in kernel/trace/ring_buffer.c all are trivial.
> 
> As for the comment in ring_buffer.c, it looks completely irrelevant at this
> point.
> 
> @Steve?

You want me to remember something I wrote almost 15 years ago? I think I
understand that comment as much as you do. Yeah, that was when I was still
learning to write comments for my older self to understand, and I failed
miserably!

But git history comes to the rescue. The commit that added that comment was:

ed56829cb3195 ("ring_buffer: reset buffer page when freeing")

This was at a time when it was suggested to me to use the struct page
directly in the ring buffer and where we could do fun "tricks" for
"performance". (I was never really for this, but I wasn't going to argue).

And the code in question then had:

/*
 * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
 * this issue out.
 */
static inline void free_buffer_page(struct buffer_page *bpage)
{
        reset_page_mapcount(&bpage->page);
        bpage->page.mapping = NULL;
        __free_page(&bpage->page);
}


But looking at commit: e4c2ce82ca27 ("ring_buffer: allocate buffer page
pointer")

It was finally decided that method was not safe, and we should not be using
struct page but just allocate an actual page (much safer!).

I never got rid of the comment, which was more about that
"reset_page_mapcount()", and should have been deleted back then.

Just remove that comment. And you could even add:

Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")

-- Steve
