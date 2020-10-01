Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0CA280363
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbgJAQBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732368AbgJAQBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:01:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAE0C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:01:02 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kO10t-00EgNW-Hc; Thu, 01 Oct 2020 18:00:59 +0200
Message-ID: <3de28a3b54737ffd5c7d9944acc0614745242a30.camel@sipsolutions.net>
Subject: Re: [RFC net-next 9/9] genetlink: allow dumping command-specific
 policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 18:00:58 +0200
In-Reply-To: <20201001084152.33cc5bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-10-kuba@kernel.org>
         <591d18f08b82a84c5dc19b110962dabc598c479d.camel@sipsolutions.net>
         <20201001084152.33cc5bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 08:41 -0700, Jakub Kicinski wrote:

> > Even if I don't have a good idea now on how to avoid the duplication, it
> > might be nicer to have a (flag) attribute here for "CTRL_ATTR_ALL_OPS"?
> 
> Hm. How would you see the dump structured? 

Yeah, that's the tricky part ... Hence why I said "I don't have a good
idea now" :)

> We need to annotate the root
> policies with the command. Right now I have:
> 
>  [ATTR_FAMILY_ID]
>  [ATTR_OP]
>  [ATTR_POLICY]
>    [policy idx]
>      [attr idx]
>        [bla]
>        [bla]
>        [bla]
> 
> But if we're dumping _all_ the policy to op mapping is actually 1:n,
> so we'd need to restructure the dump a lil' bit and have OP only
> reported on root of the policy and make it a nested array.

So today you see something like

[ATTR_FAMILY_ID]
[ATTR_POLICY]
  [policy idx, 0 = main policy]
    [bla]
    ...
  ...


I guess the most compact representation, that also preserves the most
data about sharing, would be to do something like

[ATTR_FAMILY_ID]
[ATTR_POLICY]
  [policy idx, 0 = main policy]
    [bla]
    ...
  ...
[ATTR_OP_POLICY]
  [op] = [policy idx]
  ...

This preserves all the information because it tells you which policies
actually are identical (shared), each per-op policy can have nested
policies referring to common ones, like in the ethtool case, etc.


OTOH, it's a lot trickier to implement - I haven't really come up with a
good way of doing it "generically" with the net/netlink/policy.c code.
I'm sure it can be solved, but I haven't really given it enough thought.
Perhaps by passing a "policy iterator" to netlink_policy_dump_start(),
instead of just a single policy (i.e. a function & a data ptr or so),
and then it can walk all the policies using that, assign the idxes etc.,
and dump them out in netlink_policy_dump_write()?

But then we'd still have to get the policy idx for a given policy, and
not clean up all the state when netlink_policy_dump_loop() returns
false, because you still need it for ATTR_OP_POLICY to find the idx from
the pointer?

I guess it's doable. Just seems a bit more complex. OTOH, it may be that
such complexity also completely makes sense for non-generic netlink
families anyway, I haven't looked at them much at all.

johannes

