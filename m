Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363F9283FAB
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgJETbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgJETbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:31:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A85F3207BC;
        Mon,  5 Oct 2020 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601926283;
        bh=XM5yFm/K/LXfzmt5+ShbDE5wCl7aZ0HYK/7o9irwli0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t+4FxVZU/152pao7cQ69QJC3yHxv1AnJAps3K889I2H4w0WygfPQ8qWKwnzmi5oCF
         aLiqfebdYY4/Uu3XGZCq132aarQt4Io7lHN2lrsarUoAMi824iL3CrgFEqrW8r6l/0
         pDPfmjx8/87ZcovsbXqlNGIK4eX+vdoA9uNaIxiE=
Date:   Mon, 5 Oct 2020 12:31:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
Message-ID: <20201005123120.7e8caa84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-2-kuba@kernel.org>
        <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
        <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 21:21:36 +0200 Johannes Berg wrote:
> > > But with the difference it seems to me that it'd be possible to get this
> > > mixed up?  
> > 
> > Right, I prefer not to have the unnecessary NLA_REJECTS, so my thinking
> > was - use the format I like for the new code, but leave the existing
> > rejects for a separate series / discussion.
> > 
> > If we remove the rejects we still need something like
> > 
> > extern struct nla_policy policy[lastattr + 1];  
> 
> Not sure I understand? You're using strict validation (I think), so
> attrs that are out of range will be rejected same as NLA_REJECT (well,
> with a different message) in __nla_validate_parse():
> 
>         nla_for_each_attr(nla, head, len, rem) {
>                 u16 type = nla_type(nla);
> 
>                 if (type == 0 || type > maxtype) {
>                         if (validate & NL_VALIDATE_MAXTYPE) {
>                                 NL_SET_ERR_MSG_ATTR(extack, nla,
>                                                     "Unknown attribute type");
>                                 return -EINVAL;
>                         }
> 
> 
> In fact, if you're using strict validation even the default
> (0==NLA_UNSPEC) will be rejected, just like NLA_REJECT.
> 
> 
> Or am I confused somewhere?

Yea, I think we're both confused. Agreed with the above.

Are you suggesting:

const struct nla_policy policy[/* no size */] = {
	[HEADER]	= NLA_POLICY(...)
	[OTHER_ATTR]	= NLA_POLICY(...)
};

extern const struct nla_policy policy[/* no size */];

op = {
	.policy = policy,
	.max_attr = OTHER_ATTR,
}

?

What I'm saying is that my preference would be:

const struct nla_policy policy[OTHER_ATTR + 1] = {
	[HEADER]	= NLA_POLICY(...)
	[OTHER_ATTR]	= NLA_POLICY(...)
};

extern const struct nla_policy policy[OTHER_ATTR + 1];

op = {
	.policy = policy,
	.max_attr = ARRAY_SIZE(policy) - 1,
}

Since it's harder to forget to update the op (you don't have to update
op, and compiler will complain about the extern out of sync).
