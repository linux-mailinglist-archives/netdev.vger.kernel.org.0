Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4699AF1225
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfKFJ3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:29:23 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37353 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbfKFJ3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:29:23 -0500
X-Originating-IP: 90.63.246.187
Received: from gandi.net (laubervilliers-658-1-215-187.w90-63.abo.wanadoo.fr [90.63.246.187])
        (Authenticated sender: thibaut.sautereau@clip-os.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 4BAE5E0008;
        Wed,  6 Nov 2019 09:29:19 +0000 (UTC)
Date:   Wed, 6 Nov 2019 10:29:19 +0100
From:   Thibaut Sautereau <thibaut.sautereau@clip-os.org>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, clipos@ssi.gouv.fr
Subject: Re: Double free of struct sk_buff reported by
 SLAB_CONSISTENCY_CHECKS with init_on_free
Message-ID: <20191106092919.GD1006@gandi.net>
References: <20191104170303.GA50361@gandi.net>
 <23c73a23-8fd9-c462-902b-eec2a0c04d36@suse.cz>
 <20191105143253.GB1006@gandi.net>
 <4fae11bc-9822-ea10-36e0-68a6fc3995bc@suse.cz>
 <af8174be-848e-5f00-d6eb-caa956e8fd71@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af8174be-848e-5f00-d6eb-caa956e8fd71@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 12:01:15PM -0500, Laura Abbott wrote:
> On 11/5/19 10:02 AM, Vlastimil Babka wrote:
> > On 11/5/19 3:32 PM, Thibaut Sautereau wrote:
> > > On Tue, Nov 05, 2019 at 10:00:39AM +0100, Vlastimil Babka wrote:
> > > > On 11/4/19 6:03 PM, Thibaut Sautereau wrote:
> > > > > The BUG only happens when using `slub_debug=F` on the command-line (to
> > > > > enable SLAB_CONSISTENCY_CHECKS), otherwise the double free is not
> > > > > reported and the system keeps running.
> > > > 
> > > > You could change slub_debug parameter to:
> > > > slub_debug=FU,skbuff_head_cache
> > > > 
> > > > That will also print out who previously allocated and freed the double
> > > > freed object. And limit all the tracking just to the affected cache.
> > > 
> > > Thanks, I did not know about that.
> > > 
> > > However, as kind of expected, I get a BUG due to a NULL pointer
> > > dereference in print_track():
> > 
> > Ah, I didn't read properly your initial mail, that there's a null
> > pointer deference during the consistency check.
> > 
> > ...
> > 
> > > > > 
> > > > > Bisection points to the following commit: 1b7e816fc80e ("mm: slub: Fix
> > > > > slab walking for init_on_free"), and indeed the BUG is not triggered
> > > > > when init_on_free is disabled.
> > > > 
> > > > That could be either buggy SLUB code, or the commit somehow exposed a
> > > > real bug in skbuff users.
> > > 
> > > Right. At first I thought about some incompatibility between
> > > init_on_free and SLAB_CONSISTENCY_CHECKS, but in that case why would it
> > > only happen with skbuff_head_cache?
> > 
> > That's curious, yeah.
> > 
> > > On the other hand, if it's a bug in
> > > skbuff users, why is the on_freelist() check in free_consistency_check()
> > > not detecting anything when init_on_free is disabled?
> > 
> > I vaguely suspect the code in the commit 1b7e816fc80e you bisected,
> > where in slab_free_freelist_hook() in the first iteration, we have void
> > *p = NULL; and set_freepointer(s, object, p); will thus write NULL into
> > the freelist. Is is the NULL we are crashing on? The code seems to
> > assume that the freelist is rewritten later in the function, but that
> > part is only active with some CONFIG_ option(s), none of which might be
> > enabled in your case?
> > But I don't really understand what exactly this function is supposed to
> > do. Laura, does my theory make sense?
> > 
> > Thanks,
> > Vlastimil
> > 
> 
> The note about getting re-written is referring to the fact that the trick
> with the bulk free is that we build the detached freelist and then when
> we do the cmpxchg it's getting (correctly) updated there.

Thank you Laura for this clarification.

> But looking at this again, I realize this function still has a more
> fundamental problem: walking the freelist like this means we actually
> end up reversing the list so head and tail are no longer pointing
> to the correct blocks. I was able to reproduce the issue by writing a
> simple kmem_cache_bulk_alloc/kmem_cache_bulk_free function. I'm
> guessing that the test of ping with an unusual size was enough to
> regularly trigger a non-trivial bulk alloc/free.
> 
> The fix I gave before fixed part of the problem but not all of it.
> At this point we're basically duplicating the work of the loop
> below so I think we can just combine it. Was there a reason this
> wasn't just combined in the first place?

Good catch about the freelist inversion, I was actually starting to
wonder whether it was really intended. Anyway, I tested your patch (see
one tiny inline comment below) and it seems to run fine for now, without
me being able to reproduce the bug anymore.

> diff --git a/mm/slub.c b/mm/slub.c
> index dac41cf0b94a..1510b86b2e7e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1431,13 +1431,17 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
>  	void *next = *head;
>  	void *old_tail = *tail ? *tail : *head;
>  	int rsize;
> +	next = *head;

`next` is already set a few lines above.

> -	if (slab_want_init_on_free(s)) {
> -		void *p = NULL;
> +	/* Head and tail of the reconstructed freelist */
> +	*head = NULL;
> +	*tail = NULL;
> -		do {
> -			object = next;
> -			next = get_freepointer(s, object);
> +	do {
> +		object = next;
> +		next = get_freepointer(s, object);
> +
> +		if (slab_want_init_on_free(s)) {
>  			/*
>  			 * Clear the object and the metadata, but don't touch
>  			 * the redzone.
> @@ -1447,29 +1451,8 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
>  							   : 0;
>  			memset((char *)object + s->inuse, 0,
>  			       s->size - s->inuse - rsize);
> -			set_freepointer(s, object, p);
> -			p = object;
> -		} while (object != old_tail);
> -	}
> -
> -/*
> - * Compiler cannot detect this function can be removed if slab_free_hook()
> - * evaluates to nothing.  Thus, catch all relevant config debug options here.
> - */
> -#if defined(CONFIG_LOCKDEP)	||		\
> -	defined(CONFIG_DEBUG_KMEMLEAK) ||	\
> -	defined(CONFIG_DEBUG_OBJECTS_FREE) ||	\
> -	defined(CONFIG_KASAN)
> -	next = *head;
> -
> -	/* Head and tail of the reconstructed freelist */
> -	*head = NULL;
> -	*tail = NULL;
> -
> -	do {
> -		object = next;
> -		next = get_freepointer(s, object);
> +		}
>  		/* If object's reuse doesn't have to be delayed */
>  		if (!slab_free_hook(s, object)) {
>  			/* Move object to the new freelist */
> @@ -1484,9 +1467,6 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
>  		*tail = NULL;
>  	return *head != NULL;
> -#else
> -	return true;
> -#endif
>  }
>  static void *setup_object(struct kmem_cache *s, struct page *page,
> 

-- 
Thibaut Sautereau
CLIP OS developer
