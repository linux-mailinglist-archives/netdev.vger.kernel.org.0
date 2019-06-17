Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAAD484FC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfFQONz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:13:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFQONz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 10:13:55 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF8CA307D934;
        Mon, 17 Jun 2019 14:13:41 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87E087E5C8;
        Mon, 17 Jun 2019 14:13:37 +0000 (UTC)
Date:   Mon, 17 Jun 2019 16:13:33 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v4 1/8] ipv4/fib_frontend: Rename
 ip_valid_fib_dump_req, provide non-strict version
Message-ID: <20190617161333.29cab4d7@redhat.com>
In-Reply-To: <d3527e70-15aa-abf8-4451-91e5bae4f1ab@gmail.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
        <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
        <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
        <20190615051342.7e32c2bb@redhat.com>
        <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
        <20190615052705.66f3fe62@redhat.com>
        <20190616220417.573be9a6@redhat.com>
        <d3527e70-15aa-abf8-4451-91e5bae4f1ab@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 17 Jun 2019 14:13:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 07:38:54 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/16/19 2:04 PM, Stefano Brivio wrote:
> > We could do this:
> > 
> > - strict checking enabled (iproute2 >= 5.0.0):
> >   - in inet{,6}_dump_fib(): if NLM_F_MATCH is set, set
> >     filter->filter_set in any case
> > 
> >   - in fn_trie_dump_leaf() and rt6_dump_route(): use filter->filter_set
> >     to decide if we want to filter depending on RTM_F_CLONED being
> >     set/unset. If other filters (rt_type, dev, protocol) are not set,
> >     they are still wildcards (existing implementation)
> > 
> > - no strict checking (iproute2 < 5.0.0):
> >   - we can't filter consistently, so apply no filters at all: dump all
> >     the routes (filter->filter_set not set), cached and uncached. That
> >     means more netlink messages, but no spam as iproute2 filters them
> >     anyway, and list/flush cache commands work again.
> > 
> > I would drop 1/8, turn 2/8 and 6/8 into a straightforward:
> > 
> >  	if (cb->strict_check) {
> >  		err = ip_valid_fib_dump_req(net, nlh, &filter, cb);
> >  		if (err < 0)
> >  			return err;
> > +		if (nlh->nlmsg_flags & NLM_F_MATCH)
> > +			filter.filter_set = 1;
> >  	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
> >  		struct rtmsg *rtm = nlmsg_data(nlh);
> > 
> > and other patches remain the same.
> > 
> > What do you think?
> >   
> 
> With strict checking (5.0 and forward):
> - RTM_F_CLONED NOT set means dump only FIB entries
> - RTM_F_CLONED set means dump only exceptions

Okay. Should we really ignore the RFC and NLM_F_MATCH though? If we add
field(s) to the filter, it comes almost for free, something like:

	if (nlh->nlmsg_flags & NLM_F_MATCH)
		filter->dump_exceptions = rtm->rtm_flags & RTM_F_CLONED;

instead of:

	filter->dump_exceptions = rtm->rtm_flags & RTM_F_CLONED;

> Without strict checking (old iproute2 on any kernel):
> - dump all, userspace has to sort
> 
> Kernel side this can be handled with new field, dump_exceptions, in the
> filter that defaults to true and then is reset in the strict path if the
> flag is not set.

I guess we need to add two fields, we'll need a 'dump_routes' too.

Otherwise, the dump functions can't distinguish between the three cases
('no strict checking', 'strict checking and RTM_F_CLONED', 'strict
checking and no RTM_F_CLONED'). How would you do this with a single
additional field?

-- 
Stefano
