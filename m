Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCFC1ED48B
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 18:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgFCQwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 12:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFCQwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 12:52:09 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206ADC08C5C0;
        Wed,  3 Jun 2020 09:52:08 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgWcX-002Z8R-Io; Wed, 03 Jun 2020 16:52:05 +0000
Date:   Wed, 3 Jun 2020 17:52:05 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603165205.GU23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <20200603011810-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603011810-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 01:29:00AM -0400, Michael S. Tsirkin wrote:
> On Wed, Jun 03, 2020 at 02:48:15AM +0100, Al Viro wrote:
> > On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
> > > So vhost needs to poke at userspace *a lot* in a quick succession.  It
> > > is thus benefitial to enable userspace access, do our thing, then
> > > disable. Except access_ok has already been pre-validated with all the
> > > relevant nospec checks, so we don't need that.  Add an API to allow
> > > userspace access after access_ok and barrier_nospec are done.
> > 
> > BTW, what are you going to do about vq->iotlb != NULL case?  Because
> > you sure as hell do *NOT* want e.g. translate_desc() under STAC.
> > Disable it around the calls of translate_desc()?
> > 
> > How widely do you hope to stretch the user_access areas, anyway?
> 
> So ATM I'm looking at adding support for the packed ring format.
> That does something like:
> 
> get_user(flags, desc->flags)
> smp_rmb()
> if (flags & VALID)
> copy_from_user(&adesc, desc, sizeof adesc);
> 
> this would be a good candidate I think.

Perhaps, once we get stac/clac out of raw_copy_from_user() (coming cycle,
probably).  BTW, how large is the structure and how is it aligned?

> > BTW, speaking of possible annotations: looks like there's a large
> > subset of call graph that can be reached only from vhost_worker()
> > or from several ioctls, with all uaccess limited to that subgraph
> > (thankfully).  Having that explicitly marked might be a good idea...
> 
> Sure. What's a good way to do that though? Any examples to follow?
> Or do you mean code comments?

Not sure...  FWIW, the part of call graph from "known to be only
used by vhost_worker" (->handle_kick/vhost_work_init callback/
vhost_poll_init callback) and "part of ->ioctl()" to actual uaccess
primitives is fairly large - the longest chain is
handle_tx_net ->
  handle_tx ->
    handle_tx_zerocopy ->
      get_tx_bufs ->
	vhost_net_tx_get_vq_desc ->
	  vhost_tx_batch ->
	    vhost_net_signal_used ->
	      vhost_add_used_and_signal_n ->
		vhost_signal ->
		  vhost_notify ->
		    vhost_get_avail_flags ->
		      vhost_get_avail ->
			vhost_get_user ->
			  __get_user()
i.e. 14 levels deep and the graph doesn't factorize well...

Something along the lines of "all callers of thus annotated function
must be annotated the same way themselves, any implicit conversion
of pointers to such functions to anything other than boolean yields
a warning, explicit cast is allowed only with __force", perhaps?
Then slap such annotations on vhost_{get,put,copy_to,copy_from}_user(),
on ->handle_kick(), a force-cast in the only caller of ->handle_kick()
and force-casts in the 3 callers in ->ioctl().

And propagate the annotations until the warnings stop, basically...

Shouldn't be terribly hard to teach sparse that kind of stuff and it
might be useful elsewhere.  It would act as a qualifier on function
pointers, with syntax ultimately expanding to __attribute__((something)).
I'll need to refresh my memories of the parser, but IIRC that shouldn't
require serious modifications.  Most of the work would be in
evaluate_call(), just before calling evaluate_symbol_call()...
I'll look into that; not right now, though.

BTW, __vhost_get_user() might be better off expanded in both callers -
that would get their structure similar to vhost_copy_{to,from}_user(),
especially if you expand __vhost_get_user_slow() as well.

Not sure I understand what's going with ->meta_iotlb[] - what are the
lifetime rules for struct vhost_iotlb_map and what prevents the pointers
from going stale?


