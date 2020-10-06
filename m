Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AECB284FAB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgJFQQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbgJFQQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 12:16:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47BC4206D4;
        Tue,  6 Oct 2020 16:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602001006;
        bh=TWMwUj4kJVGZ7TPJvXD4IlmevacWsb0LEBaJ+PZED+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ve3M+OmLeXbDf4xTuzzgP8YxzawCJjeQnWo5WsMLXD20AsegvGAZBoMjGLPfLgIxq
         ZRKlcvSQMzUZvU4C3mvC0eGvL6nu0XpQxUXbGDSyW1ziWpxr9YDT6O5o5YV9qGGS64
         0taO2Oh0EHVimca8ppb7YMrToL66qoqHv1qLFt78=
Date:   Tue, 6 Oct 2020 09:16:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH 2/2] netlink: export policy in extended ACK
Message-ID: <20201006091644.0425e0fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0f534e06a9b2248cc4a5ae941caf7772a864a68f.camel@sipsolutions.net>
References: <20201006123202.57898-1-johannes@sipsolutions.net>
        <20201006142714.3c8b8db03517.I6dae2c514a6abc924ee8b3e2befb0d51b086cf70@changeid>
        <0f534e06a9b2248cc4a5ae941caf7772a864a68f.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 06 Oct 2020 17:10:44 +0200 Johannes Berg wrote:
> Sorry, hat to run out earlier and forgot to comment here.
> 
> On Tue, 2020-10-06 at 14:32 +0200, Johannes Berg wrote:
> > 
> > +	/* the max policy content is currently ~44 bytes for range min/max */
> > +	if (err && nlk_has_extack && extack && extack->policy)
> > +		tlvlen += 64;  
> 
> So I'm not really happy with this. I counted 44 bytes content (so 48
> bytes for the nested attribute) for the biggest that we have now, but if
> we ever implement e.g. dumping out the reject string for NLA_REJECT
> (though not sure anyone even uses that?) then it'd be more variable.

I wonder if we should in fact dump the reject string, in this case it
feels like an omission not to have it... although as you say, grep for
reject_message reveals it's completely unused today.

> I couldn't really come up with any better idea, but I believe we do need
> to size the skb fairly well to return the original one ...
> 
> The only solution I _could_ think of was to allocate another skb, put
> the attribute into it, check the length, and then later append it to the
> message ... but that seemed kinda ugly.
> 
> Any preferences?

It'd feel pretty idiomatic for (rt)netlink to have

	netlink_policy_dump_attr_size()

which would calculate the size. That'd cost us probably ~100 LoC?

If that's too much we could at least add a define for this constant,
and WARN_ON_ONCE() in __netlink_policy_dump_write_attr() if the dump
ends up larger?
