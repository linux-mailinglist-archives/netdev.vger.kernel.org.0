Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E6662EAB3
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 02:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbiKRBFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 20:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbiKRBFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 20:05:46 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C843F047
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:05:45 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id l127so3822431oia.8
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoVVDHJ7JC6OIOtIhxXSR2WeCvXYp7Wgi4VTV2SicSE=;
        b=Zrg+Iy0eUU6RPkdO5ZUu1THHQkTILr2YYgYLNkKEGPv+E81vPRn22lxUzAWsaIhmjU
         jj7UU2gpgYaf/WeaweeoJLJ2Coj6amH+EWLe+TrWbQ+MHt9sZzfY0rC1QMo9FlYxi14V
         pMT8+PL1inoKr87Y3V3HzWh54JBiIUg7i9lro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qoVVDHJ7JC6OIOtIhxXSR2WeCvXYp7Wgi4VTV2SicSE=;
        b=btdxX2JgXNWvR+G4EwEcKspnfbqPGRNu78OaE8r0qBfwYAhcff+M945OqN8cqo2biE
         Jh8nkAyVbUqZoqh2ffsvrexF5owbRWoVYj8NdwV/27j1sJOIqgr63LybUHi/QKfFr4ED
         Gkm0ozbQIb2uV14PQh36jYezKqfMlmups78elnFD6qGtOVjua1pPdtY4oom+sluBRacu
         b8SOq6eIR73nXiWFb/pCjj082ULi0ibd+2X0AsxwTmtDejfe6nagFH2m0rZoxmjaOZ0S
         TIqXPbF/y+Xg8h4qvIb8p2XRmFxukpRgaPDsy0ObWcVdXcYeXMTpT7uIOH6ir5rvo5Ql
         pj2w==
X-Gm-Message-State: ANoB5pkA/dJ7Fpf2kONUVALeEYv/P1YU0vPelTXrSEOY3C45crDDHeqt
        zolYKpg4mj2KVqaLA3pm1Q3JzdJw/y9PE/5pHWbIVA==
X-Google-Smtp-Source: AA0mqf4VwOu5m61xDXA24VL+oIELade9BH7j9pngi8veRZkCJWpfluPJdMUlnd+Zgziaj9PiBUtlZKJLvIqAhdq2tXg=
X-Received: by 2002:a05:6808:1a09:b0:354:4a36:aa32 with SMTP id
 bk9-20020a0568081a0900b003544a36aa32mr5258680oib.15.1668733544386; Thu, 17
 Nov 2022 17:05:44 -0800 (PST)
MIME-Version: 1.0
References: <20221117192949.GD4001@paulmck-ThinkPad-P17-Gen-1>
 <CC3744B1-20A7-4628-873A-2551938009D4@joelfernandes.org> <CANn89i+T8OUgW9TEvMU277GGH3yLEzBM2Dt8szPDyzx4dYD11w@mail.gmail.com>
In-Reply-To: <CANn89i+T8OUgW9TEvMU277GGH3yLEzBM2Dt8szPDyzx4dYD11w@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 18 Nov 2022 01:05:33 +0000
Message-ID: <CAEXW_YRNUBxXb27rx+XPWDRsT5YDfJG56cZr9Q8k2uXAAbE0mQ@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
To:     Eric Dumazet <edumazet@google.com>
Cc:     paulmck@kernel.org, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 9:29 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Nov 17, 2022 at 1:16 PM Joel Fernandes <joel@joelfernandes.org> w=
rote:
> >
> >
> >
> > > On Nov 17, 2022, at 2:29 PM, Paul E. McKenney <paulmck@kernel.org> wr=
ote:
> > >
> > > =EF=BB=BFOn Thu, Nov 17, 2022 at 05:40:40PM +0000, Joel Fernandes wro=
te:
> > >>> On Thu, Nov 17, 2022 at 5:38 PM Joel Fernandes <joel@joelfernandes.=
org> wrote:
> > >>>
> > >>> On Thu, Nov 17, 2022 at 5:17 PM Eric Dumazet <edumazet@google.com> =
wrote:
> > >>>>
> > >>>> On Thu, Nov 17, 2022 at 7:58 AM Joel Fernandes <joel@joelfernandes=
.org> wrote:
> > >>>>>
> > >>>>> Hello Eric,
> > >>>>>
> > >>>>> On Wed, Nov 16, 2022 at 07:44:41PM -0800, Eric Dumazet wrote:
> > >>>>>> On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> > >>>>>> <joel@joelfernandes.org> wrote:
> > >>>>>>>
> > >>>>>>> In a networking test on ChromeOS, we find that using the new CO=
NFIG_RCU_LAZY
> > >>>>>>> causes a networking test to fail in the teardown phase.
> > >>>>>>>
> > >>>>>>> The failure happens during: ip netns del <name>
> > >>>>>>
> > >>>>>> And ? What happens then next ?
> > >>>>>
> > >>>>> The test is doing the 'ip netns del <name>' and then polling for =
the
> > >>>>> disappearance of a network interface name for upto 5 seconds. I b=
elieve it is
> > >>>>> using netlink to get a table of interfaces. That polling is timin=
g out.
> > >>>>>
> > >>>>> Here is some more details from the test's owner (copy pasting fro=
m another
> > >>>>> bug report):
> > >>>>> In the cleanup, we remove the netns, and thus will cause the veth=
 pair being
> > >>>>> removed automatically, so we use a poll to check that if the veth=
 in the root
> > >>>>> netns still exists to know whether the cleanup is done.
> > >>>>>
> > >>>>> Here is a public link to the code that is failing (its in golang)=
:
> > >>>>> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/ma=
in:src/platform/tast-tests/src/chromiumos/tast/local/network/virtualnet/env=
/env.go;drc=3D6c2841d6cc3eadd23e07912ec331943ee33d7de8;l=3D161
> > >>>>>
> > >>>>> Here is a public link to the line of code in the actual test lead=
ing up to the above
> > >>>>> path (this is the test that is run:
> > >>>>> network.RoutingFallthrough.ipv4_only_primary) :
> > >>>>> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/ma=
in:src/platform/tast-tests/src/chromiumos/tast/local/bundles/cros/network/r=
outing_fallthrough.go;drc=3D8fbf2c53960bc8917a6a01fda5405cad7c17201e;l=3D52
> > >>>>>
> > >>>>>>> Using ftrace, I found the callbacks it was queuing which this s=
eries fixes. Use
> > >>>>>>> call_rcu_flush() to revert to the old behavior. With that, the =
test passes.
> > >>>>>>
> > >>>>>> What is this test about ? What barrier was used to make it not f=
laky ?
> > >>>>>
> > >>>>> I provided the links above, let me know if you have any questions=
.
> > >>>>>
> > >>>>>> Was it depending on some undocumented RCU behavior ?
> > >>>>>
> > >>>>> This is a new RCU feature posted here for significant power-savin=
gs on
> > >>>>> battery-powered devices:
> > >>>>> https://lore.kernel.org/rcu/20221017140726.GG5600@paulmck-ThinkPa=
d-P17-Gen-1/T/#m7a54809b8903b41538850194d67eb34f203c752a
> > >>>>>
> > >>>>> There is also an LPC presentation about the same, I can dig the l=
ink if you
> > >>>>> are interested.
> > >>>>>
> > >>>>>> Maybe adding a sysctl to force the flush would be better for fun=
ctional tests ?
> > >>>>>>
> > >>>>>> I would rather change the test(s), than adding call_rcu_flush(),
> > >>>>>> adding merge conflicts to future backports.
> > >>>>>
> > >>>>> I am not too sure about that, I think a user might expect the net=
work
> > >>>>> interface to disappear from the networking tables quickly enough =
without
> > >>>>> dealing with barriers or kernel iternals. However, I added the au=
thors of the
> > >>>>> test to this email in the hopes he can provide is point of views =
as well.
> > >>>>>
> > >>>>> The general approach we are taking with this sort of thing is to =
use
> > >>>>> call_rcu_flush() which is basically the same as call_rcu() for sy=
stems with
> > >>>>> CALL_RCU_LAZY=3Dn. You can see some examples of that in the patch=
 series link
> > >>>>> above. Just to note, CALL_RCU_LAZY depends on CONFIG_RCU_NOCB_CPU=
 so its only
> > >>>>> Android and ChromeOS that are using it. I am adding Jie to share =
any input,
> > >>>>> he is from the networking team and knows this test well.
> > >>>>>
> > >>>>>
> > >>>>
> > >>>> I do not know what is this RCU_LAZY thing, but IMO this should be =
opt-in
> > >>>
> > >>> You should read the links I sent you. We did already try opt-in,
> > >>> Thomas Gleixner made a point at LPC that we should not add new APIs
> > >>> for this purpose and confuse kernel developers.
> > >>>
> > >>>> For instance, only kfree_rcu() should use it.
> > >>>
> > >>> No. Most of the call_rcu() usages are for freeing memory, so the
> > >>> consensus is we should apply this as opt out and fix issues along t=
he
> > >>> way. We already did a lot of research/diligence on seeing which use=
rs
> > >>> need conversion.
> > >>>
> > >>>> We can not review hundreds of call_rcu() call sites and decide if
> > >>>> adding arbitrary delays cou hurt .
> > >>>
> > >>> That work has already been done as much as possible, please read th=
e
> > >>> links I sent.
> > >>
> > >> Also just to add, this test is a bit weird / corner case, as in anyo=
ne
> > >> expecting a quick response from call_rcu() is broken by design.
> > >> However, for these callbacks, it does not matter much which API they
> > >> use as they are quite infrequent for power savings.
> > >
> > > The "broken by design" is a bit strong.  Some of those call_rcu()
> > > invocations have been around for the better part of 20 years, after a=
ll.
> > >
> > > That aside, I do hope that we can arrive at something that will enhan=
ce
> > > battery lifetime while avoiding unnecessary disruption.  But we are
> > > unlikely to be able to completely avoid disruption.  As this email
> > > thread illustrates.  ;-)
> >
> > Another approach, with these 3 patches could be to keep the call_rcu() =
but add an rcu_barrier() after them. I think people running ip del netns sh=
ould not have to wait for their RCU cb to take too long to run and remove u=
ser visible state. But I would need suggestions from networking experts whi=
ch CBs of these 3, to do this for. Or for all of them.
> >
> > Alternatively, we can also patch just the test with a new knob that doe=
s rcu_barrier. But I dislike that as it does not fix it for all users. Prob=
ably the ip utilities will also need a patch then.
> >
>
> Normally we have an rcu_barrier() in netns dismantle path already at a
> strategic location ( in cleanup_net() )
>
> Maybe the issue here is that some particular layers need another one.
> Or we need to release a blocking reference before the call_rcu().
> Some call_rcu() usages might not be optimal in this respect.
>
> We should not add an rcu_barrier() after a call_rcu(), we prefer
> factoring these expensive operations.

Sounds good! The dst_destroy_rcu() function appears complex to break
down (similar to how you suggested in 2/3). The dst->ops->destroy()
can decrement refcounts and so forth. We could audit all such dst->ops
users, but I wonder if it is safer to use call_rcu_flush() for this
patch.

Thanks,

 - Joel
