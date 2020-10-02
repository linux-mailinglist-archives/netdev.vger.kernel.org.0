Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97B7281CA5
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJBULS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJBULS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:11:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A6BC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:11:17 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOROd-00FRRD-Ga; Fri, 02 Oct 2020 22:11:15 +0200
Message-ID: <7312dbde2b0bada0700afa6af417d065e45fb053.camel@sipsolutions.net>
Subject: Re: [PATCH 3/5] netlink: rework policy dump to support multiple
 policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Fri, 02 Oct 2020 22:11:14 +0200
In-Reply-To: <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
         <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
         <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 08:39 -0700, Jakub Kicinski wrote:
> 
> > -	ctx->state = netlink_policy_dump_start(op.policy, op.maxattr);
> > -	if (IS_ERR(ctx->state))
> > -		return PTR_ERR(ctx->state);
> > -	return 0;
> > +	return netlink_policy_dump_add_policy(&ctx->state, op.policy,
> > +					      op.maxattr);
> 
> Looks like we flip-flopped between int and pointer return between
> patches 1 and this one?

Huh, yeah, that was kinda dumb. I started going down one path and then
...

I'll probably just squash the first patch or something. Will figure
something out, thanks.

> >  }
> > +int netlink_policy_dump_get_policy_idx(struct netlink_policy_dump_state *state,
> > +				       const struct nla_policy *policy,
> > +				       unsigned int maxtype)
> > +{
> > +	unsigned int i;
> > +
> > +	if (WARN_ON(!policy || !maxtype))
> > +                return 0;
> 
> Would this warning make sense in add() (if not already there)?
> If null/0 is never added it can't match and we'd just hit the
> warning below.

It's not there, because had originally thought it should be OK to just
blindly add a policy of a family even if it has none. But that makes no
sense.

However, it's not true that it can't match, because

> > +	for (i = 0; i < state->n_alloc; i++) {

we go to n_alloc here, and don't separately track n_used, but n_alloc
grows in tens (or so), not singles.

johannes


