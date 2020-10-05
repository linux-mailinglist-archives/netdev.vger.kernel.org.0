Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFBD283FBA
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgJETeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgJETeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:34:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C07207BC;
        Mon,  5 Oct 2020 19:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601926456;
        bh=PIcrJ8BRqJ7kfa02kByXcbv93LA1IOLjb9z0kGdixDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ygqnSyN8EA+yPFou1kpWDqfiS8u5r8YgfVbuH/TBBHlZ7HV8arA3kG17952n7FbXv
         TLtoMsrn4cf2wUbZWRg3vPvmJZpA3K8T/ibV3caagfd55RCtfa7Yf1ww7QcDHaz2Vn
         WCzQzLA0styU7FIr8WyJWTVXvMEmnigLZd6Sbaas=
Date:   Mon, 5 Oct 2020 12:34:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz,
        dsahern@gmail.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
Message-ID: <20201005123414.2a211b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <18fc3d1719ce09d5aa145a164bf407fe7a7bbb81.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-6-kuba@kernel.org>
        <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
        <20201005122242.48ed17cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <18fc3d1719ce09d5aa145a164bf407fe7a7bbb81.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 21:25:57 +0200 Johannes Berg wrote:
> On Mon, 2020-10-05 at 12:22 -0700, Jakub Kicinski wrote:
> 
> > > > +	if (value & ~(u64)pt->mask) {
> > > > +		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
> > > > +		return -EINVAL;    
> > > 
> > > You had an export of the valid bits there in ethtool, using the cookie.
> > > Just pointing out you lost it now. I'm not sure I like using the cookie,
> > > that seems a bit strange, but we could easily define a different attr?
> > > 
> > > OTOH, one can always query the policy export too (which hopefully got
> > > wired up) so it wouldn't really matter much.  
> > 
> > My thinking is that there are no known uses of the cookie, it'd only
> > have practical use to test for new flags - and we're adding first new
> > flag in 5.10.  
> 
> Hm, wait, not sure I understand?
> 
> You _had_ this in ethtool, but you removed it now. And you're not
> keeping it here, afaict.
> 
> I can't disagree on the "no known uses of the cookie" part, but it feels
> odd to me anyway - since that is just another netlink message (*), you
> could as well add a "NLMSGERR_ATTR_VALID_FLAGS" instead of sticking the
> data into the cookie?
> 
> But then are you saying the new flags are only in 5.10 so the policy
> export will be sufficient, since that's also wired up now?

Right, I was commenting on the need to keep the cookie for backward
compat.

My preference is to do a policy dump to check the capabilities of the
kernel rather than shoot messages at it and then try to work backward
based on the info returned in extack.

> johannes
> 
> (*) in a way - the ack message has the "legacy" fixed part before the
> attrs, of course
> 

