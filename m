Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111F4281D42
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJBU7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBU7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:59:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A173C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:59:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOS8r-00FSin-6h; Fri, 02 Oct 2020 22:59:01 +0200
Message-ID: <47b6644999ce2946a262d5eac0c82e33057e7321.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Date:   Fri, 02 Oct 2020 22:59:00 +0200
In-Reply-To: <20201002135059.1657d673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
         <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
         <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
         <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
         <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <cc9594d16270aeb55f9f429a234ec72468403b93.camel@sipsolutions.net>
         <20201002135059.1657d673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 13:50 -0700, Jakub Kicinski wrote:
> 
> My thinking was that until kernel actually start using separate dump
> policies user space can assume policy 0 is relevant. But yeah, merging
> your changes first would probably be best.

Works for me. I have it based on yours. Just updated my branch (top
commit is 4d5045adfe90), but I'll probably only actually email it out
once things are a bit more settled wrt. your changes.

> I, OTOH, am having second thoughts about not implementing separate
> policies for dump right away, since Michal said he'll need them soon :)

:)

> Any ideas on how to do that cleanly? At some point it will make sense
> to have dumps and doits in separate structures, as you said earlier,
> but can we have "small" and "full" ops for both? That seems like too
> much :/

Not sure I understand what you just wrote :)

I had originally assumed dumps would be "infrequent", and so having the
small ops without dumps would be worthwhile. You said it wasn't true for
other users, so small ops still have .doit and .dumpit entries. Which is
fine?

But in the small ops anyway you don't have a policy pointer - I guess
you could have two "fallbacks" (for do and dump) in the family rather
than just one?

Another option - though it requires some rejiggering in my new policy
dump code - would be to key the lookup based on do/dump as well. Then
you could have the *same* op listed twice like

struct genl_ops my_ops[] = {
	{
		.cmd = SOMETHING,
		.doit = do_something,
		.policy = something_do_policy,
	},
	{
		.cmd = SOMETHING,
		.dumpit = dump_something,
		.policy = something_dump_policy,
	},
};

That way you only pay where needed? But ultimately with large ops you
already pay for the start/dump/done pointers, and you'd have that even
for the extra entry with _doit_ because ...

Unless we put three different kinds of ops (small, full-do, full-dump),
but that gets a bit awkward too?

johannes

