Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35E027EECC
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgI3QS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbgI3QS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:18:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 228D720708;
        Wed, 30 Sep 2020 16:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601482708;
        bh=XRlEVG0GVYAhj7Mh4Jwp+f5h7E/VMiCnbj/teUhDoWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y26P4HXEft5E/9zydc4cpCj28nAoekkfkprCsJ/YsSAtRCcv040FgJatMVWS9vHd1
         t8zyA8h2TglDKeL2dD8hS6G4724XLAs6ndBkRmpuawzAjFPYe4h2YiICNopBnQFnwg
         t5E3pgH7MVGXs+A4oIwDclPSsiZk+aRe8pGpdPSE=
Date:   Wed, 30 Sep 2020 09:18:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930091825.27d14d1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 18:06:28 +0200 Johannes Berg wrote:
> Hi Jakub,
> 
> > I'd like to be able to dump ethtool nl policies, but right now policy
> > dumping is only supported for "global" family policies.  
> 
> Did ethtool add per-command policies?

Yup.

> > Is there any reason not to put the policy in struct genl_ops, 
> > or just nobody got to it, yet?
> > 
> > I get the feeling that this must have been discussed before...  
> 
> Sort of, yeah.
> 
> We actually *had* per-command policies, and I removed it in commit
> 3b0f31f2b8c9 ("genetlink: make policy common to family"), mostly because
> the maxattr is actually in the family not the op, so having a policy in
> each op was never really a good idea and well-supported.
> 
> Additionally, having the pointer in each op (and if you want to do it
> right you also need maxattr in each op) significantly increases the
> binary size there, as well as boilerplate code to type it out, though
> the latter could be avoided by "falling back" to the family policy.

Yup, it's like 2 or 3 "ops->family ? : rt->family" and we're good on
fallback AFAICT.

> So at the time, that reduced nl80211 size by 824 bytes, which I guess
> means we had 103 ops at the time. Doing it right with maxattr would cost
> twice as much as just the policy pointer, and we probably have a few
> more ops now, so we're looking at a cost of ~1.6k for it.

Hm. If we really care it wouldn't be too crazy to have "lightweight"
ops and normal ops. At a cost of an extra pointer in the family.
Core genl can deal with that. And we could save another 16B per op if
we drop .start and .done which nl80211 barely uses.

> Personally, I'm not really convinced that there really is a need for it,
> but then I haven't really looked that much at ethtool. In most cases,
> you want some "common" attributes for the family, even if it's only the
> interface index or such, because also on the userspace side that's
> awkward if you have to really build *everything* including such
> identifying information per command. The one or two families that
> actually had different policies per command (at the time I removed it)
> actually solved this by "aliasing" the same attribute number between the
> different policies, but again that feels rather awkward ...

ethtool has common and per command parts. Global policies don't jell
well with strict checking in my mind.

> That's the historic info I guess - I'll take a look at ethtool later and
> see what it's doing there.
> 
> johannes
> 

