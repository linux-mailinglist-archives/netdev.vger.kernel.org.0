Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A746E04
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFODXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:23:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfFODXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 23:23:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7CFA8553D;
        Sat, 15 Jun 2019 03:23:38 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F52B5C239;
        Sat, 15 Jun 2019 03:23:36 +0000 (UTC)
Date:   Sat, 15 Jun 2019 05:23:32 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v4 2/8] ipv4: Honour NLM_F_MATCH, make semantics of
 NETLINK_GET_STRICT_CHK consistent
Message-ID: <20190615052332.16628b2c@redhat.com>
In-Reply-To: <9abeefb6-81a7-dc0a-30f4-f15ccf4edc86@gmail.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
        <58865c4c143d0da40cd417b5b87b49d292d8129d.1560561432.git.sbrivio@redhat.com>
        <9abeefb6-81a7-dc0a-30f4-f15ccf4edc86@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sat, 15 Jun 2019 03:23:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 21:13:38 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/14/19 7:32 PM, Stefano Brivio wrote:
> > Socket option NETLINK_GET_STRICT_CHK, quoting from commit 89d35528d17d
> > ("netlink: Add new socket option to enable strict checking on dumps"),
> > is used to "request strict checking of headers and attributes on dump
> > requests".
> > 
> > If some attributes are set (including flags), setting this option causes
> > dump functions to filter results according to these attributes, via the
> > filter_set flag. However, if strict checking is requested, this should
> > imply that we also filter results based on flags that are *not* set.  
> 
> I don't agree with that comment. If a request does not specify a bit or
> specify an attribute on the request, it is a wildcard in the sense of
> nothing to be considered when matching records to be returned.

This is what I had in v1. Then:

On Thu, 6 Jun 2019 16:47:00 -0600
David Ahern <dsahern@gmail.com> wrote:

> That's the use case I was targeting:
> 1. fib dumps - RTM_F_CLONED not set
> 2. exception dump - RTM_F_CLONED set

On Mon, 10 Jun 2019 15:38:06 -0600
David Ahern <dsahern@gmail.com> wrote:

> By that I mean without the CLONED flag, no exceptions are returned
> (default FIB dump). With the CLONED flag only exceptions are returned.

and this looks to me like a sensible way (if strict checking is
requested, or if NLM_F_MATCH is passed) to filter the results.

> > This is currently not the case, at least for IPv4 FIB dumps: if the
> > RTM_F_CLONED flag is not set, and strict checking is required, we should
> > not return routes with the RTM_F_CLONED flag set.  
> 
> IPv4 currently ignores the CLONED flag and just returns - regardless of
> whether strict checking is enabled. This is the original short cut added
> many years ago.

Sure, and I'm removing that, because there's no way to fetch cached
routes otherwise.

> > Set the filter_set flag whenever strict checking is requested, limiting
> > the scope to IPv4 FIB dumps for the moment being, as other users of the
> > flag might not present this inconsistency.
> > 
> > Note that this partially duplicates the semantics of NLM_F_MATCH as
> > described by RFC 3549, par. 3.1.1. Instead of setting a filter based on
> > the size of the netlink message, properly support NLM_F_MATCH, by
> > setting a filter via ip_filter_fib_dump_req() and setting the filter_set
> > flag.
> >   
> 
> your commit description is very confusing given the end goal. can you
> explain again?

1. we need a way to filter on cached routes

2. RTM_F_CLONED, by itself, doesn't specify a filter

3. how do we turn that into a filter? NLM_F_MATCH, says RFC 3549

4. but if strict checking is requested, you also turn some attributes
   and flags into filters -- so let's make that apply to RTM_F_CLONED
   too, I don't see any reason why that should be special

-- 
Stefano
