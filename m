Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D9D2803D9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbgJAQYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732342AbgJAQYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 12:24:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2017620848;
        Thu,  1 Oct 2020 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601569477;
        bh=RyMow5fyBGKKDSMrZgCCAa1EJD2TJz7FT82CA+LQ/bU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NEGMeLY4okSH7Me3F1Nd4rmNPav0Us4tUoQMOBwA5zoRSb5akLDB4CqEL5yQmvPYf
         XGPwATzLEGHuGZTYGCoJ7zS1O1chZPIzqV7DM0gph2lDoCVhaBnhZdIc8H237HEl/r
         Och1W8JJNf0S42QgAFyIm35iTD5VlGNJvaMrBV7A=
Date:   Thu, 1 Oct 2020 09:24:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Subject: Re: [RFC net-next 9/9] genetlink: allow dumping command-specific
 policy
Message-ID: <20201001092434.3f916d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3de28a3b54737ffd5c7d9944acc0614745242a30.camel@sipsolutions.net>
References: <20201001000518.685243-1-kuba@kernel.org>
        <20201001000518.685243-10-kuba@kernel.org>
        <591d18f08b82a84c5dc19b110962dabc598c479d.camel@sipsolutions.net>
        <20201001084152.33cc5bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3de28a3b54737ffd5c7d9944acc0614745242a30.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Oct 2020 18:00:58 +0200 Johannes Berg wrote:
> On Thu, 2020-10-01 at 08:41 -0700, Jakub Kicinski wrote:
> 
> > > Even if I don't have a good idea now on how to avoid the duplication, it
> > > might be nicer to have a (flag) attribute here for "CTRL_ATTR_ALL_OPS"?  
> > 
> > Hm. How would you see the dump structured?   
> 
> Yeah, that's the tricky part ... Hence why I said "I don't have a good
> idea now" :)

You say that, yet your idea below seems pretty good :P

> > We need to annotate the root
> > policies with the command. Right now I have:
> > 
> >  [ATTR_FAMILY_ID]
> >  [ATTR_OP]
> >  [ATTR_POLICY]
> >    [policy idx]
> >      [attr idx]
> >        [bla]
> >        [bla]
> >        [bla]
> > 
> > But if we're dumping _all_ the policy to op mapping is actually 1:n,
> > so we'd need to restructure the dump a lil' bit and have OP only
> > reported on root of the policy and make it a nested array.  
> 
> So today you see something like
> 
> [ATTR_FAMILY_ID]
> [ATTR_POLICY]
>   [policy idx, 0 = main policy]
>     [bla]
>     ...
>   ...
> 
> 
> I guess the most compact representation, that also preserves the most
> data about sharing, would be to do something like
> 
> [ATTR_FAMILY_ID]
> [ATTR_POLICY]
>   [policy idx, 0 = main policy]
>     [bla]
>     ...
>   ...
> [ATTR_OP_POLICY]
>   [op] = [policy idx]
>   ...
> 
> This preserves all the information because it tells you which policies
> actually are identical (shared), each per-op policy can have nested
> policies referring to common ones, like in the ethtool case, etc.

Only comment I have is - can we make sure to put the ATTR_OP_POLICY
first? That way user space can parse the stream an pick out the info
it needs rather than recording all the policies only to find out later
which one is which.

> OTOH, it's a lot trickier to implement - I haven't really come up with a
> good way of doing it "generically" with the net/netlink/policy.c code.
> I'm sure it can be solved, but I haven't really given it enough thought.
> Perhaps by passing a "policy iterator" to netlink_policy_dump_start(),
> instead of just a single policy (i.e. a function & a data ptr or so),
> and then it can walk all the policies using that, assign the idxes etc.,
> and dump them out in netlink_policy_dump_write()?
> 
> But then we'd still have to get the policy idx for a given policy, and
> not clean up all the state when netlink_policy_dump_loop() returns
> false, because you still need it for ATTR_OP_POLICY to find the idx from
> the pointer?
> 
> I guess it's doable. Just seems a bit more complex. OTOH, it may be that
> such complexity also completely makes sense for non-generic netlink
> families anyway, I haven't looked at them much at all.

IDK, doesn't seem crazy hard. We can create some iterator or expand the
API with "begin" "add" "end" calls. Then once dumper state is build we
can ask it which ids it assigned.

OTOH I don't think we have a use for this in ethtool, because user
space usually does just one op per execution. So I'm thinking to use
your structure for the dump, but leave the actual implementation of
"dump all" for "later".

How does that sound?
