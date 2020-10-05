Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A14283F85
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgJETWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729284AbgJETWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:22:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71715207BC;
        Mon,  5 Oct 2020 19:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601925765;
        bh=9fNw5z4SaKEy9typVhAuWOKYtEnvLz7G1UVCY/BvzAM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ases54hN1HBJIZsvnp1JAR25xZoJZYhW2XgelrJe7bMZK9ynKxEJoz58wBInTiWgp
         aiXykUCPDWrS/G0dGoL/pkMpwFx4meTqfyDTLfY67yIPd/gPybUt8xnj0ydvPVErL0
         PnE+Pj1PztYIyHrTvmPfSB9eqIeQ68mjYH2dt20U=
Date:   Mon, 5 Oct 2020 12:22:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz,
        dsahern@gmail.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
Message-ID: <20201005122242.48ed17cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-6-kuba@kernel.org>
        <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 21:05:23 +0200 Johannes Berg wrote:
> On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> > We don't have good validation policy for existing unsigned int attrs
> > which serve as flags (for new ones we could use NLA_BITFIELD32).
> > With increased use of policy dumping having the validation be
> > expressed as part of the policy is important. Add validation
> > policy in form of a mask of supported/valid bits.  
> 
> Nice, I'll surely use this as well somewhere :)
> 
> >  #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
> > +#define NLA_ENSURE_UINT_TYPE(tp)			\
> > +	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
> > +		      tp == NLA_U32 || tp == NLA_U64) + tp)
> >  #define NLA_ENSURE_UINT_OR_BINARY_TYPE(tp)		\  
> 
> nit: maybe express this (_OR_BINARY_TYPE) in terms of UINT_TYPE() ||
> tp==NLA_BINARY? Doesn't matter much though.

Will do!

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
> 
> OTOH, one can always query the policy export too (which hopefully got
> wired up) so it wouldn't really matter much.

My thinking is that there are no known uses of the cookie, it'd only
have practical use to test for new flags - and we're adding first new
flag in 5.10.

> Either way is fine with me on both of these points.
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!
