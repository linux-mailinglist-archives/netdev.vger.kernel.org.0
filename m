Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B9283FDA
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgJETsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:48:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:34606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgJETsE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:48:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A46CAAC79;
        Mon,  5 Oct 2020 19:48:01 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D25936035C; Mon,  5 Oct 2020 21:47:59 +0200 (CEST)
Date:   Mon, 5 Oct 2020 21:47:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
Message-ID: <20201005194759.fsszdioltmdy3u3c@lion.mk-sys.cz>
References: <20201005155753.2333882-1-kuba@kernel.org>
 <20201005155753.2333882-6-kuba@kernel.org>
 <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
 <20201005122242.48ed17cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <18fc3d1719ce09d5aa145a164bf407fe7a7bbb81.camel@sipsolutions.net>
 <20201005123414.2a211b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005123414.2a211b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 12:34:14PM -0700, Jakub Kicinski wrote:
> On Mon, 05 Oct 2020 21:25:57 +0200 Johannes Berg wrote:
> > On Mon, 2020-10-05 at 12:22 -0700, Jakub Kicinski wrote:
> > 
> > > > > +	if (value & ~(u64)pt->mask) {
> > > > > +		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
> > > > > +		return -EINVAL;    
> > > > 
> > > > You had an export of the valid bits there in ethtool, using the cookie.
> > > > Just pointing out you lost it now. I'm not sure I like using the cookie,
> > > > that seems a bit strange, but we could easily define a different attr?
> > > > 
> > > > OTOH, one can always query the policy export too (which hopefully got
> > > > wired up) so it wouldn't really matter much.  
> > > 
> > > My thinking is that there are no known uses of the cookie, it'd only
> > > have practical use to test for new flags - and we're adding first new
> > > flag in 5.10.  
> > 
> > Hm, wait, not sure I understand?
> > 
> > You _had_ this in ethtool, but you removed it now. And you're not
> > keeping it here, afaict.
> > 
> > I can't disagree on the "no known uses of the cookie" part, but it feels
> > odd to me anyway - since that is just another netlink message (*), you
> > could as well add a "NLMSGERR_ATTR_VALID_FLAGS" instead of sticking the
> > data into the cookie?
> > 
> > But then are you saying the new flags are only in 5.10 so the policy
> > export will be sufficient, since that's also wired up now?
> 
> Right, I was commenting on the need to keep the cookie for backward
> compat.
> 
> My preference is to do a policy dump to check the capabilities of the
> kernel rather than shoot messages at it and then try to work backward
> based on the info returned in extack.

The reason I used the extack was that that way, the "standard" case of
kernel and ethtool in sync (or even old ethtool with new kernel) would
still use one request and only new ethtool against old kernel would end
up doing two. Also, the extra request would be relatively short and so
would be the reply to it.

On the other hand, using the policy dump would allow checking not only
support for new flags but also support for new request attributes so in
the long term, it could actually make things simpler.

Michal
