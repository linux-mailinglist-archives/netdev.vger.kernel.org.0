Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0FE48BEC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFQS2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:28:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbfFQS2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 14:28:47 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F2EE307D90E;
        Mon, 17 Jun 2019 18:28:39 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C54E41001E86;
        Mon, 17 Jun 2019 18:28:34 +0000 (UTC)
Date:   Mon, 17 Jun 2019 20:28:30 +0200
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
Message-ID: <20190617202830.3dd92d46@redhat.com>
In-Reply-To: <43a9b0c7-27b4-733c-d3f2-60ad894e8aeb@gmail.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
        <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
        <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
        <20190615051342.7e32c2bb@redhat.com>
        <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
        <20190615052705.66f3fe62@redhat.com>
        <20190616220417.573be9a6@redhat.com>
        <d3527e70-15aa-abf8-4451-91e5bae4f1ab@gmail.com>
        <20190617161333.29cab4d7@redhat.com>
        <43a9b0c7-27b4-733c-d3f2-60ad894e8aeb@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 17 Jun 2019 18:28:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 11:06:51 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/17/19 8:13 AM, Stefano Brivio wrote:
> >>
> >> With strict checking (5.0 and forward):
> >> - RTM_F_CLONED NOT set means dump only FIB entries
> >> - RTM_F_CLONED set means dump only exceptions  
> > 
> > Okay. Should we really ignore the RFC and NLM_F_MATCH though? If we add
> > field(s) to the filter, it comes almost for free, something like:
> > 
> > 	if (nlh->nlmsg_flags & NLM_F_MATCH)
> > 		filter->dump_exceptions = rtm->rtm_flags & RTM_F_CLONED;
> > 
> > instead of:
> > 
> > 	filter->dump_exceptions = rtm->rtm_flags & RTM_F_CLONED;  
> 
> This is where you keep losing me. iproute2 has always set NLM_F_MATCH on
> dump requests, so that flag can not be used as a discriminator here.

iproute2 yes, but some other users (I'm not aware of any so I have no
examples) might *very* vaguely follow the RFC and expect consistent
results. That was my only point here. Most likely just a theoretical
one.

> >   
> >> Without strict checking (old iproute2 on any kernel):
> >> - dump all, userspace has to sort
> >>
> >> Kernel side this can be handled with new field, dump_exceptions, in the
> >> filter that defaults to true and then is reset in the strict path if the
> >> flag is not set.  
> > 
> > I guess we need to add two fields, we'll need a 'dump_routes' too.
> > 
> > Otherwise, the dump functions can't distinguish between the three cases
> > ('no strict checking', 'strict checking and RTM_F_CLONED', 'strict
> > checking and no RTM_F_CLONED'). How would you do this with a single
> > additional field?
> >   
> 
> sure, separate fields are needed for the pre-strict mode use case.

Well, they are needed, in general. They both start as true, non-strict
mode doesn't clear them, strict mode clears one. That's how I would do
it.

> So, I take it we are converging on this:
> 
> 1. non-strict mode, dump both (FIB entries and exceptions). Userspace
> has to filter. This is the legacy behavior you are trying to restore.
> 
> 2. strict mode:
>    a. dump only FIB entries if RTM_F_CLONED is not set
>    b. dump only exception entries if RTM_F_CLONED is set
> 
> Agreed?

Agreed in general, maybe let me know what you think about the
NLM_F_MATCH point above though.

-- 
Stefano
