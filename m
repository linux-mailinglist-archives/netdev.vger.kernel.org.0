Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEBB283FA2
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgJET3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:29:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:46436 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgJET3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:29:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EBABEACC8;
        Mon,  5 Oct 2020 19:28:58 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 73F2D6035C; Mon,  5 Oct 2020 21:28:57 +0200 (CEST)
Date:   Mon, 5 Oct 2020 21:28:57 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
Message-ID: <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
References: <20201005155753.2333882-1-kuba@kernel.org>
 <20201005155753.2333882-6-kuba@kernel.org>
 <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 09:05:23PM +0200, Johannes Berg wrote:
> On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> 
> > +static int nla_validate_mask(const struct nla_policy *pt,
> > +			     const struct nlattr *nla,
> > +			     struct netlink_ext_ack *extack)
> > +{
> > +	u64 value;
> > +
> > +	switch (pt->type) {
> > +	case NLA_U8:
> > +		value = nla_get_u8(nla);
> > +		break;
> > +	case NLA_U16:
> > +		value = nla_get_u16(nla);
> > +		break;
> > +	case NLA_U32:
> > +		value = nla_get_u32(nla);
> > +		break;
> > +	case NLA_U64:
> > +		value = nla_get_u64(nla);
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (value & ~(u64)pt->mask) {
> > +		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
> > +		return -EINVAL;
> 
> You had an export of the valid bits there in ethtool, using the cookie.
> Just pointing out you lost it now. I'm not sure I like using the cookie,
> that seems a bit strange, but we could easily define a different attr?

The idea behind the cookie was that if new userspace sends a request
with multiple flags which may not be supported by an old kernel, getting
only -EOPNOTSUPP (and badattr pointing to the flags) would not be very
helpful as multiple iteration would be necessary to find out which flags
are supported and which not.

> OTOH, one can always query the policy export too (which hopefully got
> wired up) so it wouldn't really matter much.

But yes, if userspace can get supported flags from policy dump, it can
check them in advance and either bail out (if one of essential flags is
unsupported) or send only supported flags.

I'm not exactly happy with the prospect of having to do a full policy
dump before each such request, thought.

Michal
