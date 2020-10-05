Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A87283FC6
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgJETkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgJETkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:40:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF745208C3;
        Mon,  5 Oct 2020 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601926831;
        bh=uE7YNb2E/y9n599n2UYn7kztWsrMIfew2lM1AEx6ZLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bll/8R+Eh8hXIJK4ibVtLpcq6bVp9QD5XzN/330MT7cVguV3duvijfESJSRMI+Bim
         Kfkbg/dBOkdZ4Tjts8QjWpVxHEKS7Psm7mAllxBDmpw2rob+V43/tPAwggMKsLED/q
         TE8/5EF3PMvLY6GofJT5bHFJOPV20cLlr8keO59U=
Date:   Mon, 5 Oct 2020 12:40:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
Message-ID: <20201005124029.5ebe684d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <93103e3d9496ea0e3e3b9e7f9850c9b12f2397b6.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-6-kuba@kernel.org>
        <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
        <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
        <93103e3d9496ea0e3e3b9e7f9850c9b12f2397b6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 21:31:13 +0200 Johannes Berg wrote:
> On Mon, 2020-10-05 at 21:28 +0200, Michal Kubecek wrote:
> 
> > > > +	if (value & ~(u64)pt->mask) {
> > > > +		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
> > > > +		return -EINVAL;  
> > > 
> > > You had an export of the valid bits there in ethtool, using the cookie.
> > > Just pointing out you lost it now. I'm not sure I like using the cookie,
> > > that seems a bit strange, but we could easily define a different attr?  
> > 
> > The idea behind the cookie was that if new userspace sends a request
> > with multiple flags which may not be supported by an old kernel, getting
> > only -EOPNOTSUPP (and badattr pointing to the flags) would not be very
> > helpful as multiple iteration would be necessary to find out which flags
> > are supported and which not.  
> 
> Message crossing, I guess.
> 
> I completely agree. I just don't like using the (somewhat vague)
> _cookie_ for that vs. adding a new explicit NLMSGERR_ATTR_SOMETHING :)
> 
> I would totally support doing that here in the general validation code,
> but (again) don't really think NLMSGERR_ATTR_COOKIE is an appropriate
> attribute for it.

Hm. Perhaps we can do a partial policy dump into the extack?

NL_POLICY_TYPE_ATTR_TYPE etc.?

Either way, I don't feel like this series needs it.

> > I'm not exactly happy with the prospect of having to do a full policy
> > dump before each such request, thought.

I tried to code it up and it gets rather ugly.

One has to selectively suppress error messages for stuff that's known
to be optional, and keep retrying.

The policy dump is much, much cleaner (and the policy for an op is
rather tiny - one nested policy of the header with 3? attrs in it).
