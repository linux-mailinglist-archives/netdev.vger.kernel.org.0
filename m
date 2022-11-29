Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA8663BC80
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiK2JGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiK2JGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:06:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35BE1DF19
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669712753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hnlw2SSsDh2OvZ7SdOJ9wJAiaQAGCGAe8+2H+LnCC+U=;
        b=jWiRroPx/Gm+SknVvO4Y94Sma1xasI2Ztm+xW+yoZPnEDjPENBHDxYbKkj/s4KSinld762
        JQwKxh4tL/Gi7PHW1vFGiqgopqTN3Z4ARF6E9RHfOWfwEs1iju0zF84/p4pcUwtkr1EDui
        o8BjvpUDAT+EUIPcpW5wkMZuuNALA6g=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-452-_z2HAkZCM3GPeVwrw5ko8A-1; Tue, 29 Nov 2022 04:05:51 -0500
X-MC-Unique: _z2HAkZCM3GPeVwrw5ko8A-1
Received: by mail-qk1-f197.google.com with SMTP id az31-20020a05620a171f00b006fa2cc1b0bfso27476283qkb.23
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:05:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hnlw2SSsDh2OvZ7SdOJ9wJAiaQAGCGAe8+2H+LnCC+U=;
        b=p9jCphFTOGBkKDykLeGRElewedup7g1D9sMg1DCRnLLDM0aKCphicP4w4wFwalVq9g
         LxRgEbRno5QBV5SykcRJdMS5WTjV4/CDRQTRXTEXGoSdW+g/YPpN8T+oiFYsdYLNWSAm
         BtduG9+bA9NZMMj6ovaYsHlNEvHOs8/GJ2eJ6P4GurTICSm0DsS8nOFOT5ez9u0WjI/z
         w8earI64fsZpsthgnbeFUoXasj1ZEXEq+O2Yt0xNBC1AjkXq+IsiQip9rsGkQp6LYlxr
         6R2mSNkzCUSHc1bSOoSapftpF6eMMN8vWCsI4r28imPP6MxARO8OxC5fRakIOGoPMhVG
         v9CA==
X-Gm-Message-State: ANoB5pkN5Am6etx8HkvXiaU5EZH+8tmq2ZKcj6C05znrtZ52/DF56Xed
        nbgcnFq4+h2Qv2oJwjqW4Gq0dAac2/eNrz1iczblS3t+4OLYxQu5+RJH634qI1Ksj1YMZLkm88X
        RVeqoY9nm6fFPbUyK
X-Received: by 2002:a05:620a:d41:b0:6fb:38cd:adee with SMTP id o1-20020a05620a0d4100b006fb38cdadeemr50392529qkl.703.1669712750964;
        Tue, 29 Nov 2022 01:05:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UDfji3QhGTQDqSi0RIX6UicCKWr7DY3aARg2fKp5BbD0KAKyBHzmWgOviClARZAeUfF3YzA==
X-Received: by 2002:a05:620a:d41:b0:6fb:38cd:adee with SMTP id o1-20020a05620a0d4100b006fb38cdadeemr50392509qkl.703.1669712750661;
        Tue, 29 Nov 2022 01:05:50 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id k23-20020ac86057000000b00399b73d06f0sm8265665qtm.38.2022.11.29.01.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:05:50 -0800 (PST)
Message-ID: <e9767b9d708db2593805e8507d3ca43532dad59e.camel@redhat.com>
Subject: Re: [PATCH v3] epoll: use refcount to reduce ep_mutex contention
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        linux-fsdevel@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>, netdev@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Date:   Tue, 29 Nov 2022 10:05:46 +0100
In-Reply-To: <477f3642-608f-f710-9eed-6312a6e3f2d8@intel.com>
References: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
         <477f3642-608f-f710-9eed-6312a6e3f2d8@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-11-28 at 16:06 -0800, Jacob Keller wrote:
> > @@ -217,6 +218,12 @@ struct eventpoll {
> >   	u64 gen;
> >   	struct hlist_head refs;
> >   
> > +	/*
> > +	 * usage count, protected by mtx, used together with epitem->dying to
> > +	 * orchestrate the disposal of this struct
> > +	 */
> > +	unsigned int refcount;
> > +
> 
> Why not use a kref (or at least struct refcount?) those provide some 
> guarantees like guaranteeing atomic operations and saturation when the 
> refcount value would overflow.

Thank you for the feedback!

I thought about that options and ultimately opted otherwise because we
can avoid the additional atomic operations required by kref/refcount_t.
The reference count is always touched under the ep->mtx mutex.
Reasonably this does not introduce performance regressions even in the
stranger corner case.

The above was explicitly noted in the previous revisions commit
message, but I removed it by mistake while updating the message for v3.

I can switch to kref if there is agreement WRT such performance trade-
off. Another option would be adding a couple of additional checks for
wrap-arounds in ep_put() and ep_get() - so that we get similar safety
guarantees but no additional atomic operations.

> >   #ifdef CONFIG_NET_RX_BUSY_POLL
> >   	/* used to track busy poll napi_id */
> >   	unsigned int napi_id;
> > @@ -240,9 +247,7 @@ struct ep_pqueue {
> >   /* Maximum number of epoll watched descriptors, per user */
> >   static long max_user_watches __read_mostly;
> >   
> > -/*
> > - * This mutex is used to serialize ep_free() and eventpoll_release_file().
> > - */
> > +/* Used for cycles detection */
> >   static DEFINE_MUTEX(epmutex);
> >   
> >   static u64 loop_check_gen = 0;
> > @@ -555,8 +560,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
> >   
> >   /*
> >    * This function unregisters poll callbacks from the associated file
> > - * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
> > - * ep_free).
> > + * descriptor.  Must be called with "mtx" held.
> >    */
> >   static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
> >   {
> > @@ -679,11 +683,38 @@ static void epi_rcu_free(struct rcu_head *head)
> >   	kmem_cache_free(epi_cache, epi);
> >   }
> >   
> > +static void ep_get(struct eventpoll *ep)
> > +{
> > +	ep->refcount++;
> > +}
> This would become something like "kref_get(&ep->kref)" or maybe even 
> something like "kref_get_unless_zero" or some other form depending on 
> exactly how you acquire a pointer to an eventpoll structure.

No need for kref_get_unless_zero here, in all ep_get() call-sites we
know that at least onother reference is alive and can't go away
concurrently.

> > +
> > +/*
> > + * Returns true if the event poll can be disposed
> > + */
> > +static bool ep_put(struct eventpoll *ep)
> > +{
> > +	if (--ep->refcount)
> > +		return false;
> > +
> > +	WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
> > +	return true;
> > +}
> 
> This could become kref_put(&ep->kref, ep_dispose).

I think it would be necessary releasing the ep->mtx mutex before
invoking ep_dispose()...

> > +
> > +static void ep_dispose(struct eventpoll *ep)
> > +{
> > +	mutex_destroy(&ep->mtx);
> > +	free_uid(ep->user);
> > +	wakeup_source_unregister(ep->ws);
> > +	kfree(ep);
> > +}
> This would takea  kref pointer, use container_of to get to the eventpoll 
> structure, and then perform necessary cleanup once all references drop.
> 
> The exact specific steps here and whether it would still be safe to call 
> mutex_destroy is a bit unclear since you typically would only call 
> mutex_destroy when its absolutely sure that no one has locked the mutex.

... due to the above. The current patch code ensures that ep_dispose()
is called only after the ep->mtx mutex is released.


> See Documentation/core-api/kref.rst for a better overview of the API and 
> how to use it safely. I suspect that with just kref you could also 
> safely avoid the "dying" flag as well, but I am not 100% sure.

I *think* we will still need the 'dying' flag, otherwise ep_free()
can't tell if the traversed epitems entries still held a reference to
struct eventpoll - eventpoll_release_file() and ep_free() could
potentially try to release the same reference twice and kref could
detect that race only for the last reference.

Thanks!

Paolo

