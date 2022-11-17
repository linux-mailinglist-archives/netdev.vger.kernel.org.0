Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1987462E547
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 20:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiKQT34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 14:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbiKQT3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 14:29:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00C36E545;
        Thu, 17 Nov 2022 11:29:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D1116223A;
        Thu, 17 Nov 2022 19:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E0BC433D6;
        Thu, 17 Nov 2022 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668713390;
        bh=Lm2cK6bMT7tq+2nS6/7AlfFyPHgdLg/UIO51cboi93w=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=dj7BRCZyZCT3JmqB8RVy9xrPmPCejgVJWQcJUqPDL0xOJTpr5e27m1KGrb/Jvc4xp
         AM/uFeh8o4xmenloifPk/WT7DUw+2fVSq7nXuvM3PINFXOuJ9XINWR87kkZt2cLtSI
         GFF874LNhWPj+w2lpzeGztbuaNDlanDrzjq6mGa1atgH4RLXgHjShRIgRl3bAEZknl
         7gZcWMa7FZ/awB5N+rxOJcx1tYx1orXi+Uz/5h4YLZx9Q+P3AtALV1J+GHqNdeus7w
         60V2uoVbHRudWg8b3O20Sz66Wcz9tySi/U61I0r9KuHBU9unoimOyr7kAubitdgRQ+
         y3l/m+yqG6leA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8FDE35C05C5; Thu, 17 Nov 2022 11:29:49 -0800 (PST)
Date:   Thu, 17 Nov 2022 11:29:49 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, jiejiang@google.com,
        Thomas Glexiner <tglx@linutronix.de>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
Message-ID: <20221117192949.GD4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <20221117031551.1142289-3-joel@joelfernandes.org>
 <CANn89i+gKVdveEtR9DX15Xr7E9Nn2my6SEEbXTMmxbqtezm2vg@mail.gmail.com>
 <Y3ZaH4C4omQs1OR4@google.com>
 <CANn89iJRhr8+osviYKVYhcHHk5TnQQD53x87-WG3iTo4YNa0qA@mail.gmail.com>
 <CAEXW_YRULY2KzMtkv+KjA_hSr1tSKhQLuCt-RrOkMLjjwAbwKg@mail.gmail.com>
 <CAEXW_YT7rFkJB1tWBJRKWUG6tLzMhfbd02RwnnByjnOm-=Aoqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YT7rFkJB1tWBJRKWUG6tLzMhfbd02RwnnByjnOm-=Aoqw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 05:40:40PM +0000, Joel Fernandes wrote:
> On Thu, Nov 17, 2022 at 5:38 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > On Thu, Nov 17, 2022 at 5:17 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Thu, Nov 17, 2022 at 7:58 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > > >
> > > > Hello Eric,
> > > >
> > > > On Wed, Nov 16, 2022 at 07:44:41PM -0800, Eric Dumazet wrote:
> > > > > On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> > > > > <joel@joelfernandes.org> wrote:
> > > > > >
> > > > > > In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> > > > > > causes a networking test to fail in the teardown phase.
> > > > > >
> > > > > > The failure happens during: ip netns del <name>
> > > > >
> > > > > And ? What happens then next ?
> > > >
> > > > The test is doing the 'ip netns del <name>' and then polling for the
> > > > disappearance of a network interface name for upto 5 seconds. I believe it is
> > > > using netlink to get a table of interfaces. That polling is timing out.
> > > >
> > > > Here is some more details from the test's owner (copy pasting from another
> > > > bug report):
> > > > In the cleanup, we remove the netns, and thus will cause the veth pair being
> > > > removed automatically, so we use a poll to check that if the veth in the root
> > > > netns still exists to know whether the cleanup is done.
> > > >
> > > > Here is a public link to the code that is failing (its in golang):
> > > > https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/network/virtualnet/env/env.go;drc=6c2841d6cc3eadd23e07912ec331943ee33d7de8;l=161
> > > >
> > > > Here is a public link to the line of code in the actual test leading up to the above
> > > > path (this is the test that is run:
> > > > network.RoutingFallthrough.ipv4_only_primary) :
> > > > https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/bundles/cros/network/routing_fallthrough.go;drc=8fbf2c53960bc8917a6a01fda5405cad7c17201e;l=52
> > > >
> > > > > > Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> > > > > > call_rcu_flush() to revert to the old behavior. With that, the test passes.
> > > > >
> > > > > What is this test about ? What barrier was used to make it not flaky ?
> > > >
> > > > I provided the links above, let me know if you have any questions.
> > > >
> > > > > Was it depending on some undocumented RCU behavior ?
> > > >
> > > > This is a new RCU feature posted here for significant power-savings on
> > > > battery-powered devices:
> > > > https://lore.kernel.org/rcu/20221017140726.GG5600@paulmck-ThinkPad-P17-Gen-1/T/#m7a54809b8903b41538850194d67eb34f203c752a
> > > >
> > > > There is also an LPC presentation about the same, I can dig the link if you
> > > > are interested.
> > > >
> > > > > Maybe adding a sysctl to force the flush would be better for functional tests ?
> > > > >
> > > > > I would rather change the test(s), than adding call_rcu_flush(),
> > > > > adding merge conflicts to future backports.
> > > >
> > > > I am not too sure about that, I think a user might expect the network
> > > > interface to disappear from the networking tables quickly enough without
> > > > dealing with barriers or kernel iternals. However, I added the authors of the
> > > > test to this email in the hopes he can provide is point of views as well.
> > > >
> > > > The general approach we are taking with this sort of thing is to use
> > > > call_rcu_flush() which is basically the same as call_rcu() for systems with
> > > > CALL_RCU_LAZY=n. You can see some examples of that in the patch series link
> > > > above. Just to note, CALL_RCU_LAZY depends on CONFIG_RCU_NOCB_CPU so its only
> > > > Android and ChromeOS that are using it. I am adding Jie to share any input,
> > > > he is from the networking team and knows this test well.
> > > >
> > > >
> > >
> > > I do not know what is this RCU_LAZY thing, but IMO this should be opt-in
> >
> > You should read the links I sent you. We did already try opt-in,
> > Thomas Gleixner made a point at LPC that we should not add new APIs
> > for this purpose and confuse kernel developers.
> >
> > > For instance, only kfree_rcu() should use it.
> >
> > No. Most of the call_rcu() usages are for freeing memory, so the
> > consensus is we should apply this as opt out and fix issues along the
> > way. We already did a lot of research/diligence on seeing which users
> > need conversion.
> >
> > > We can not review hundreds of call_rcu() call sites and decide if
> > > adding arbitrary delays cou hurt .
> >
> > That work has already been done as much as possible, please read the
> > links I sent.
> 
> Also just to add, this test is a bit weird / corner case, as in anyone
> expecting a quick response from call_rcu() is broken by design.
> However, for these callbacks, it does not matter much which API they
> use as they are quite infrequent for power savings.

The "broken by design" is a bit strong.  Some of those call_rcu()
invocations have been around for the better part of 20 years, after all.

That aside, I do hope that we can arrive at something that will enhance
battery lifetime while avoiding unnecessary disruption.  But we are
unlikely to be able to completely avoid disruption.  As this email
thread illustrates.  ;-)

							Thanx, Paul
