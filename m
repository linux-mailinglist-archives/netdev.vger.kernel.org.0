Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC21F5B43B3
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 04:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIJCC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 22:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIJCC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 22:02:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B176B93;
        Fri,  9 Sep 2022 19:02:27 -0700 (PDT)
Date:   Sat, 10 Sep 2022 04:02:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: removing conntrack helper toggle to enable auto-assignment [was Re:
 b118509076b3 (probably) breaks my firewall]
Message-ID: <YxvwKlE+nyfUjHx8@salvia>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc>
 <YxsTMMFoaNSM9gLN@salvia>
 <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 07:21:47PM +0100, Chris Clayton wrote:
> On 09/09/2022 11:19, Pablo Neira Ayuso wrote:
> > On Thu, Sep 08, 2022 at 11:48:59PM +0200, Florian Westphal wrote:
> >> Chris Clayton <chris2553@googlemail.com> wrote:
> >>
> >> [ CC Pablo ]
> >>
> >>> On 08/09/2022 20:19, Florian Westphal wrote:
> >>>> Chris Clayton <chris2553@googlemail.com> wrote:
> >>>>> Just a heads up and a question...
> >>>>>
> >>>>> I've pulled the latest and greatest from Linus' tree and built and installed the kernel. git describe gives
> >>>>> v6.0-rc4-126-g26b1224903b3.
> >>>>>
> >>>>> I find that my firewall is broken because /proc/sys/net/netfilter/nf_conntrack_helper no longer exists. It existed on an
> >>>>> -rc4 kernel. Are changes like this supposed to be introduced at this stage of the -rc cycle?
> >>>>
> >>>> The problem is that the default-autoassign (nf_conntrack_helper=1) has
> >>>> side effects that most people are not aware of.
> >>>>
> >>>> The bug that propmpted this toggle from getting axed was that the irc (dcc) helper allowed
> >>>> a remote client to create a port forwarding to the local client.
> >>>
> >>>
> >>> Ok, but I still think it's not the sort of change that should be introduced at this stage of the -rc cycle.
> >>> The other problem is that the documentation (Documentation/networking/nf_conntrack-sysctl.rst) hasn't been updated. So I
> >>> know my firewall is broken but there's nothing I can find that tells me how to fix it.
> >>
> >> Pablo, I don't think revert+move the 'next' will avoid this kinds of
> >> problems, but at least the nf_conntrack-sysctl.rst should be amended to
> >> reflect that this was removed.
> > 
> > I'll post a patch to amend the documentation.
> > 
> >> I'd keep it though because people that see an error wrt. this might be
> >> looking at nf_conntrack-sysctl.rst.
> >>
> >> Maybe just a link to
> >> https://home.regit.org/netfilter-en/secure-use-of-helpers/?
>
> but
> I'm afraid that document isn't much use to a "Joe User" like me. It's written by people who know a lot about the subject
> matter to be read by other people who know a lot about the subject matter.

This is always an issue: deprecating stuff is problematic. After
finally removing this toggle, there are chances that more users come
to complain at the flag day to say they did not have enough time to
update their setup to enable conntrack helpers by policy as the
document recommends.

This is the history behind this toggle:

- In 2012, the documentation above is released and a toggle is added
  to disable the existing behaviour.

- In 2016, this toggle is set off by default, _that was already
  breaking existing setups_ as a way to attract users' attention on
  this topic. Yes, that was a tough way to attract attention on this
  topic.

  Moreover, this warning message was also available via dmesg:

        nf_conntrack: default automatic helper assignment
                      has been turned off for security reasons and CT-based
                      firewall rule not found. Use the iptables CT target
                      to attach helpers instead.

  There was a simple way to restore the previous behaviour
  by simply:

        echo 1 > /proc/sys/net/netfilter/nf_conntrack_helper

  Still, maybe not many people look at this warning message.

- In 2022, the toggle is removed. There is still a way to restore your
  setup, which is to enable conntrack helpers via policy. Yes, it
  requires a bit more effort, but there is documentation available on
  how to do this.

  Why at -rc stage? Someone reported a security issue related to
  one of the conntrack helpers, and the reporter claims many users
  still rely on the insecure configuration. This attracted again
  our attention on this toggle, and we decided it was a good idea to
  finally remove it, the sooner the better.

> >> What do you think?
> > 
> > I'll update netfilter.org to host a copy of the github sources.
> > 
> > We have been announcing this going deprecated for 10 years...
> 
> That may be the case, it should be broken before -rc1 is released. Breaking it at -rc4+ is, I think, a regression!
> Adding Thorsten Leemuis to cc list

Disagreed, reverting and waiting for one more release cycle will just
postpone the fact that users must adapt their policies, and that they
rely on a configuration which is not secure.
