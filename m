Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0791462E6EB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbiKQV3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiKQV3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:29:32 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72187101C0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:29:31 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id g127so3448699ybg.8
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hb99SZGqiD7q1zzB403dE9eGF6JozK2TLUstBhxk3OE=;
        b=NO1RijVCnuqJG3D4QUm8+dgWVagxY8YKToG8PUXVpx4aLVjE+l3FMAQLCVMvxFj7Lb
         2K7gO1DTUH/wG0Eu+ljOCz28A7uKX++dso+wNrxNOol3YuD1VedhaNszDPqrichVoEFA
         w8ab1TqAbDKaUBC/FFmP/qgK51NkNqi420DlHTAun0xOSgjhgMHHNRh5vS9V39HATcUz
         QFsTAQwyGCUElPAQpCBotvgGybcWh1/ruCn3lSV7qIjS7OfYaQ0DhcGvMZDVNvLhZTTX
         0pNoD/QJohcBnaKZqvi2b0e/VdpVf52148+JcFPfmAXzLKmHrCatvoT4HFk4q54IXDiL
         rF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hb99SZGqiD7q1zzB403dE9eGF6JozK2TLUstBhxk3OE=;
        b=BolUYwVyFhXbiKUuZl/ducCfL15bhVgUPQuEUl7fo9fT7YfkNcKSbhwDBjIJrDRBDi
         +dJCNYVeymKQqySD29MwIygZ+/SURjYNfAxPpZwzM0icNXs9A7wX4fyrrdTW8BhbPOjL
         i4QXnHDgTMtuDO0QRFixBFAbbsNrKliLDOXpg/5vXNftv/8qaW/D37lZ8qtXXPM9EaSO
         fkRk256iejqhtzMikRDU6husHhdqWMaU6SoZu+A7Pj5q9bteVOE9hp2aeYMgF9l4Y+1k
         G19bCFxei8dBFeD/fa7mah5e+c4/MeR1aIZ2s8Ybo/S3R/bPL7CrYdWTIBrS++2okVQo
         On7w==
X-Gm-Message-State: ANoB5pmKkP31cRB1RH2td0aH5mdDakV3yJTSzdmBpAkzW+6Pg44Yckjl
        slm6RS9/Bc6vFZmsYgIgKRj2jAgiDk5EIHgGXE5upw==
X-Google-Smtp-Source: AA0mqf4HG3J5S8rqGeAWZgZmOj35lHSEf7gRoA5YTeSVJzK4K0XZMLd6W5hSIagjTDQ5EBOT2YExaEssI5V8Dv/o2aI=
X-Received: by 2002:a25:6641:0:b0:6ca:b03:7111 with SMTP id
 z1-20020a256641000000b006ca0b037111mr3838876ybm.598.1668720570383; Thu, 17
 Nov 2022 13:29:30 -0800 (PST)
MIME-Version: 1.0
References: <20221117192949.GD4001@paulmck-ThinkPad-P17-Gen-1> <CC3744B1-20A7-4628-873A-2551938009D4@joelfernandes.org>
In-Reply-To: <CC3744B1-20A7-4628-873A-2551938009D4@joelfernandes.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 13:29:19 -0800
Message-ID: <CANn89i+T8OUgW9TEvMU277GGH3yLEzBM2Dt8szPDyzx4dYD11w@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
To:     Joel Fernandes <joel@joelfernandes.org>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 1:16 PM Joel Fernandes <joel@joelfernandes.org> wro=
te:
>
>
>
> > On Nov 17, 2022, at 2:29 PM, Paul E. McKenney <paulmck@kernel.org> wrot=
e:
> >
> > =EF=BB=BFOn Thu, Nov 17, 2022 at 05:40:40PM +0000, Joel Fernandes wrote=
:
> >>> On Thu, Nov 17, 2022 at 5:38 PM Joel Fernandes <joel@joelfernandes.or=
g> wrote:
> >>>
> >>> On Thu, Nov 17, 2022 at 5:17 PM Eric Dumazet <edumazet@google.com> wr=
ote:
> >>>>
> >>>> On Thu, Nov 17, 2022 at 7:58 AM Joel Fernandes <joel@joelfernandes.o=
rg> wrote:
> >>>>>
> >>>>> Hello Eric,
> >>>>>
> >>>>> On Wed, Nov 16, 2022 at 07:44:41PM -0800, Eric Dumazet wrote:
> >>>>>> On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> >>>>>> <joel@joelfernandes.org> wrote:
> >>>>>>>
> >>>>>>> In a networking test on ChromeOS, we find that using the new CONF=
IG_RCU_LAZY
> >>>>>>> causes a networking test to fail in the teardown phase.
> >>>>>>>
> >>>>>>> The failure happens during: ip netns del <name>
> >>>>>>
> >>>>>> And ? What happens then next ?
> >>>>>
> >>>>> The test is doing the 'ip netns del <name>' and then polling for th=
e
> >>>>> disappearance of a network interface name for upto 5 seconds. I bel=
ieve it is
> >>>>> using netlink to get a table of interfaces. That polling is timing =
out.
> >>>>>
> >>>>> Here is some more details from the test's owner (copy pasting from =
another
> >>>>> bug report):
> >>>>> In the cleanup, we remove the netns, and thus will cause the veth p=
air being
> >>>>> removed automatically, so we use a poll to check that if the veth i=
n the root
> >>>>> netns still exists to know whether the cleanup is done.
> >>>>>
> >>>>> Here is a public link to the code that is failing (its in golang):
> >>>>> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main=
:src/platform/tast-tests/src/chromiumos/tast/local/network/virtualnet/env/e=
nv.go;drc=3D6c2841d6cc3eadd23e07912ec331943ee33d7de8;l=3D161
> >>>>>
> >>>>> Here is a public link to the line of code in the actual test leadin=
g up to the above
> >>>>> path (this is the test that is run:
> >>>>> network.RoutingFallthrough.ipv4_only_primary) :
> >>>>> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main=
:src/platform/tast-tests/src/chromiumos/tast/local/bundles/cros/network/rou=
ting_fallthrough.go;drc=3D8fbf2c53960bc8917a6a01fda5405cad7c17201e;l=3D52
> >>>>>
> >>>>>>> Using ftrace, I found the callbacks it was queuing which this ser=
ies fixes. Use
> >>>>>>> call_rcu_flush() to revert to the old behavior. With that, the te=
st passes.
> >>>>>>
> >>>>>> What is this test about ? What barrier was used to make it not fla=
ky ?
> >>>>>
> >>>>> I provided the links above, let me know if you have any questions.
> >>>>>
> >>>>>> Was it depending on some undocumented RCU behavior ?
> >>>>>
> >>>>> This is a new RCU feature posted here for significant power-savings=
 on
> >>>>> battery-powered devices:
> >>>>> https://lore.kernel.org/rcu/20221017140726.GG5600@paulmck-ThinkPad-=
P17-Gen-1/T/#m7a54809b8903b41538850194d67eb34f203c752a
> >>>>>
> >>>>> There is also an LPC presentation about the same, I can dig the lin=
k if you
> >>>>> are interested.
> >>>>>
> >>>>>> Maybe adding a sysctl to force the flush would be better for funct=
ional tests ?
> >>>>>>
> >>>>>> I would rather change the test(s), than adding call_rcu_flush(),
> >>>>>> adding merge conflicts to future backports.
> >>>>>
> >>>>> I am not too sure about that, I think a user might expect the netwo=
rk
> >>>>> interface to disappear from the networking tables quickly enough wi=
thout
> >>>>> dealing with barriers or kernel iternals. However, I added the auth=
ors of the
> >>>>> test to this email in the hopes he can provide is point of views as=
 well.
> >>>>>
> >>>>> The general approach we are taking with this sort of thing is to us=
e
> >>>>> call_rcu_flush() which is basically the same as call_rcu() for syst=
ems with
> >>>>> CALL_RCU_LAZY=3Dn. You can see some examples of that in the patch s=
eries link
> >>>>> above. Just to note, CALL_RCU_LAZY depends on CONFIG_RCU_NOCB_CPU s=
o its only
> >>>>> Android and ChromeOS that are using it. I am adding Jie to share an=
y input,
> >>>>> he is from the networking team and knows this test well.
> >>>>>
> >>>>>
> >>>>
> >>>> I do not know what is this RCU_LAZY thing, but IMO this should be op=
t-in
> >>>
> >>> You should read the links I sent you. We did already try opt-in,
> >>> Thomas Gleixner made a point at LPC that we should not add new APIs
> >>> for this purpose and confuse kernel developers.
> >>>
> >>>> For instance, only kfree_rcu() should use it.
> >>>
> >>> No. Most of the call_rcu() usages are for freeing memory, so the
> >>> consensus is we should apply this as opt out and fix issues along the
> >>> way. We already did a lot of research/diligence on seeing which users
> >>> need conversion.
> >>>
> >>>> We can not review hundreds of call_rcu() call sites and decide if
> >>>> adding arbitrary delays cou hurt .
> >>>
> >>> That work has already been done as much as possible, please read the
> >>> links I sent.
> >>
> >> Also just to add, this test is a bit weird / corner case, as in anyone
> >> expecting a quick response from call_rcu() is broken by design.
> >> However, for these callbacks, it does not matter much which API they
> >> use as they are quite infrequent for power savings.
> >
> > The "broken by design" is a bit strong.  Some of those call_rcu()
> > invocations have been around for the better part of 20 years, after all=
.
> >
> > That aside, I do hope that we can arrive at something that will enhance
> > battery lifetime while avoiding unnecessary disruption.  But we are
> > unlikely to be able to completely avoid disruption.  As this email
> > thread illustrates.  ;-)
>
> Another approach, with these 3 patches could be to keep the call_rcu() bu=
t add an rcu_barrier() after them. I think people running ip del netns shou=
ld not have to wait for their RCU cb to take too long to run and remove use=
r visible state. But I would need suggestions from networking experts which=
 CBs of these 3, to do this for. Or for all of them.
>
> Alternatively, we can also patch just the test with a new knob that does =
rcu_barrier. But I dislike that as it does not fix it for all users. Probab=
ly the ip utilities will also need a patch then.
>

Normally we have an rcu_barrier() in netns dismantle path already at a
strategic location ( in cleanup_net() )

Maybe the issue here is that some particular layers need another one.
Or we need to release a blocking reference before the call_rcu().
Some call_rcu() usages might not be optimal in this respect.

We should not add an rcu_barrier() after a call_rcu(), we prefer
factoring these expensive operations.
