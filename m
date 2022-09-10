Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AF65B43E5
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 05:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIJDtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 23:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiIJDtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 23:49:41 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1DF618B04;
        Fri,  9 Sep 2022 20:49:37 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 28A3nOLp007225;
        Sat, 10 Sep 2022 05:49:24 +0200
Date:   Sat, 10 Sep 2022 05:49:24 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Chris Clayton <chris2553@googlemail.com>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: removing conntrack helper toggle to enable auto-assignment [was
 Re: b118509076b3 (probably) breaks my firewall]
Message-ID: <20220910034924.GA7148@1wt.eu>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc>
 <YxsTMMFoaNSM9gLN@salvia>
 <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
 <YxvwKlE+nyfUjHx8@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxvwKlE+nyfUjHx8@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo!

On Sat, Sep 10, 2022 at 04:02:18AM +0200, Pablo Neira Ayuso wrote:
> This is always an issue: deprecating stuff is problematic. After
> finally removing this toggle, there are chances that more users come
> to complain at the flag day to say they did not have enough time to
> update their setup to enable conntrack helpers by policy as the
> document recommends.

netfilter is particular in that it often runs on completely headless
systems, and many users do not even watch logs so there are limited
ways to communicate to them.

> This is the history behind this toggle:
> 
> - In 2012, the documentation above is released and a toggle is added
>   to disable the existing behaviour.
> 
> - In 2016, this toggle is set off by default, _that was already
>   breaking existing setups_ as a way to attract users' attention on
>   this topic. Yes, that was a tough way to attract attention on this
>   topic.
> 
>   Moreover, this warning message was also available via dmesg:
> 
>         nf_conntrack: default automatic helper assignment
>                       has been turned off for security reasons and CT-based
>                       firewall rule not found. Use the iptables CT target
>                       to attach helpers instead.

FWIW when you're just a user, that message isn't particularly clear
about what the user must do. An example of rule for each helper found
could have been useful (typically a match on dport 21 for ftp).

The other problem is to try to force users to notice this message when
they simply upgrade a kernel on their headless firewall. Among the
things users detect on headless systems are:
  - long pause before first starting the service (e.g. 30s). That could
    be sufficient for the user to log into the firewall and try to figure
    what is happening.
  - refusal to load a configuration so that it doesn't work *at all*.
    It might not be easy with firewall rules since any config is valid.

Configs that seem to work when doing a few tests are the hardest ones
to troubleshoot because exhaustive tests are needed and any users are
not interested in running them and often don't know at all how to do
that..

>   There was a simple way to restore the previous behaviour
>   by simply:
> 
>         echo 1 > /proc/sys/net/netfilter/nf_conntrack_helper
> 
>   Still, maybe not many people look at this warning message.

Definitely, and it's not clear that this is a temporary switch nor
that it does have negative impacts. Most users just copy-paste random
advices found in forums and blogs. I like to name switches in a way that
make people think twice such as "nf_conntrack_enable_insecure_helpers". 
Of course it's easy to say after the problem happens, I'm just saying
this to try to improve the situation in the future.

> - In 2022, the toggle is removed. There is still a way to restore your
>   setup, which is to enable conntrack helpers via policy. Yes, it
>   requires a bit more effort, but there is documentation available on
>   how to do this.
> 
>   Why at -rc stage? Someone reported a security issue related to
>   one of the conntrack helpers, and the reporter claims many users
>   still rely on the insecure configuration. This attracted again
>   our attention on this toggle, and we decided it was a good idea to
>   finally remove it, the sooner the better.

I agree. In addition, breakage is always possible when upgrading a
kernel and users have to check. Of course we never like it when it
happens but we've seen plenty of other changes in the past, including
some features that used to be configured as module arguments and that
ended up in /sys (e.g. bonding), or new inter-module dependencies that
cause breakage because the final image is missing them, etc.

> > > We have been announcing this going deprecated for 10 years...
> > 
> > That may be the case, it should be broken before -rc1 is released. Breaking it at -rc4+ is, I think, a regression!
> > Adding Thorsten Leemuis to cc list
> 
> Disagreed, reverting and waiting for one more release cycle will just
> postpone the fact that users must adapt their policies, and that they
> rely on a configuration which is not secure.

And in addition by then there will be even more such users. Deprecation
is not rocket science, if it doesn't work in 10 years there's something
wrong, either an important feature is being removed that users heavily
depend on, or a message is not seen or not understood. And in both cases,
postponing without changing anything doesn't help the problem go away
but makes it worse.

Just my two cents,
Willy
