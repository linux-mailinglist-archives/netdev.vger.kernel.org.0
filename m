Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B54283F6B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgJETQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgJETQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 15:16:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 513472064C;
        Mon,  5 Oct 2020 19:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601925384;
        bh=BLn2cW2nsahflA+ExECfDL+roE4/LywoB2/BQFpQCU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E/ZB++3/5z/bI5RyrgitidWxZLrwKcIuZVaGpfO+dpGJqe5rePrkfSNedgc8CHGRm
         vmxZiAsszh8QezSJ+5QTF+/q7lGMv4tNEuL7hzaMH4bzFBJC7Df/Jly2io/wRlPyGF
         s5M6f+yr9EudTk2ZHePxcT5j9mgfQAcDCt00yTVo=
Date:   Mon, 5 Oct 2020 12:16:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
Message-ID: <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
References: <20201005155753.2333882-1-kuba@kernel.org>
        <20201005155753.2333882-2-kuba@kernel.org>
        <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Oct 2020 20:56:29 +0200 Johannes Berg wrote:
> On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> > @@ -783,6 +799,9 @@ static const struct genl_ops ethtool_genl_ops[] = {
> >  		.start	= ethnl_default_start,
> >  		.dumpit	= ethnl_default_dumpit,
> >  		.done	= ethnl_default_done,
> > +		.policy = ethnl_rings_get_policy,
> > +		.maxattr = ARRAY_SIZE(ethnl_rings_get_policy) - 1,
> > +
> >  	},  
> 
> If you find some other reason to respin, perhaps remove that blank line
> :)
> 
> Unrelated to that, it bothers me a bit that you put here the maxattr as
> the ARRAY_SIZE(), which is of course fine, but then still have
> 
> > @@ -127,7 +127,7 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
> >  	.max_attr		= ETHTOOL_A_PRIVFLAGS_MAX,  
> 
> max_attr here, using the original define

Ah, another good catch, this is obviously no longer needed. I will
remove those members in v2.

> yes, mostly the policies use
> the define to size them, but they didn't really *need* to, and one might
> make an argument that on the policy arrays the size might as well be
> removed (and it be sized automatically based on the contents) since all
> the unspecified attrs are rejected anyway.
> 
> But with the difference it seems to me that it'd be possible to get this
> mixed up?

Right, I prefer not to have the unnecessary NLA_REJECTS, so my thinking
was - use the format I like for the new code, but leave the existing
rejects for a separate series / discussion.

If we remove the rejects we still need something like

extern struct nla_policy policy[lastattr + 1];

For array_size to work, but I think that's fine. And we'd get a
compiler errors if the sizes don't match up.

> I do see that you still need this to size the attrs for parsing them
> even after patch 2 where this:
> 
> >  	.req_info_size		= sizeof(struct privflags_req_info),
> >  	.reply_data_size	= sizeof(struct privflags_reply_data),
> > -	.request_policy		= privflags_get_policy,
> > +	.request_policy		= ethnl_privflags_get_policy,  
> 
> gets removed completely.
> 
> 
> Perhaps we can look up the genl_ops pointer, or add the ops pointer to
> struct genl_info (could point to the temporary full struct that gets
> populated, size of genl_info itself doesn't matter much since it's on
> the stack and temporary), and then use ops->maxattr instead of
> request_ops->max_attr in ethnl_default_parse()?

Hm, maybe my split of patches 1 and 2 hurts more than it helps.
Let me merge the two in v2.
