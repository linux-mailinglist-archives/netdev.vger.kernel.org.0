Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51D462E355
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbiKQRlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbiKQRkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:40:53 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64A22497E
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:40:51 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id q83so2627430oib.10
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W+agF9DCPi0CmTXNslJLojtkhYZZILaz8RI8h0MhFWk=;
        b=eLuE4ITld85hdDpkXNA8s3kN9JtRiylP5lPCD0e5LAQrtsIGZO00npXSNYO4e5UtkL
         P9qPVl42nTjtMzxCDmZiOue3Ju+5ijhWDSVHkMfb5ggGr69JuVRrpLtqYfEBVAF0PdwJ
         RrBRySPhMcp1Tb7Cqphd9GsF9w4VlBGd0zbJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W+agF9DCPi0CmTXNslJLojtkhYZZILaz8RI8h0MhFWk=;
        b=umkr6C5I2BDvybubeOYUxETCnfFq2iv9LYcIoL2v2AS6RU/+fkmUKcILNfgHdHUmQ9
         eMM0V/0eadzNYCAeE868CJllBPnq2hxvNLpRHJJxUklyy4Qtc+zDV0H5yUkqGFkcuPiA
         FLXBXzG46lkaT37dGmpNDdOpPlMFM/L6ilqqP/AmYYQvLssNxtoQZ7NoBidzPyae+2TS
         Er6cj3ePWuG8ivd8v39VU9WCmuaL85QeV2w8XoKd+j4pAVcKxz7+dcM5hAFNoXvIusVt
         OLufOsXV7gq0e8uqQfzvBEGtiQDa1sMCoeojFfdik4gsvGB4TrmuY2R8Q/5OHTpPZ3lD
         XPvA==
X-Gm-Message-State: ANoB5pkcKJubt9i4+x8T8EGuCYtI2rtg6LoYedOm12TUkzpzIHBzi/8h
        6Oi6c8b2hQ+tJbnMGFAQiX2RiZfyG8i9Tc8UV9+qqQ==
X-Google-Smtp-Source: AA0mqf56Ugj6QTxtqnKAfHYhEoXr8vzsUJNEcQe3ogo9Y9e9/e1to10bkNKi5flJkkBoVlQh6kZnM/enbwGWdQ0XMLg=
X-Received: by 2002:a05:6808:1a09:b0:354:4a36:aa32 with SMTP id
 bk9-20020a0568081a0900b003544a36aa32mr4522417oib.15.1668706850859; Thu, 17
 Nov 2022 09:40:50 -0800 (PST)
MIME-Version: 1.0
References: <20221117031551.1142289-1-joel@joelfernandes.org>
 <20221117031551.1142289-3-joel@joelfernandes.org> <CANn89i+gKVdveEtR9DX15Xr7E9Nn2my6SEEbXTMmxbqtezm2vg@mail.gmail.com>
 <Y3ZaH4C4omQs1OR4@google.com> <CANn89iJRhr8+osviYKVYhcHHk5TnQQD53x87-WG3iTo4YNa0qA@mail.gmail.com>
 <CAEXW_YRULY2KzMtkv+KjA_hSr1tSKhQLuCt-RrOkMLjjwAbwKg@mail.gmail.com>
In-Reply-To: <CAEXW_YRULY2KzMtkv+KjA_hSr1tSKhQLuCt-RrOkMLjjwAbwKg@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 17 Nov 2022 17:40:40 +0000
Message-ID: <CAEXW_YT7rFkJB1tWBJRKWUG6tLzMhfbd02RwnnByjnOm-=Aoqw@mail.gmail.com>
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
To:     Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com,
        jiejiang@google.com, Thomas Glexiner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 5:38 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Thu, Nov 17, 2022 at 5:17 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Nov 17, 2022 at 7:58 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > >
> > > Hello Eric,
> > >
> > > On Wed, Nov 16, 2022 at 07:44:41PM -0800, Eric Dumazet wrote:
> > > > On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> > > > <joel@joelfernandes.org> wrote:
> > > > >
> > > > > In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
> > > > > causes a networking test to fail in the teardown phase.
> > > > >
> > > > > The failure happens during: ip netns del <name>
> > > >
> > > > And ? What happens then next ?
> > >
> > > The test is doing the 'ip netns del <name>' and then polling for the
> > > disappearance of a network interface name for upto 5 seconds. I believe it is
> > > using netlink to get a table of interfaces. That polling is timing out.
> > >
> > > Here is some more details from the test's owner (copy pasting from another
> > > bug report):
> > > In the cleanup, we remove the netns, and thus will cause the veth pair being
> > > removed automatically, so we use a poll to check that if the veth in the root
> > > netns still exists to know whether the cleanup is done.
> > >
> > > Here is a public link to the code that is failing (its in golang):
> > > https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/network/virtualnet/env/env.go;drc=6c2841d6cc3eadd23e07912ec331943ee33d7de8;l=161
> > >
> > > Here is a public link to the line of code in the actual test leading up to the above
> > > path (this is the test that is run:
> > > network.RoutingFallthrough.ipv4_only_primary) :
> > > https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/tast-tests/src/chromiumos/tast/local/bundles/cros/network/routing_fallthrough.go;drc=8fbf2c53960bc8917a6a01fda5405cad7c17201e;l=52
> > >
> > > > > Using ftrace, I found the callbacks it was queuing which this series fixes. Use
> > > > > call_rcu_flush() to revert to the old behavior. With that, the test passes.
> > > >
> > > > What is this test about ? What barrier was used to make it not flaky ?
> > >
> > > I provided the links above, let me know if you have any questions.
> > >
> > > > Was it depending on some undocumented RCU behavior ?
> > >
> > > This is a new RCU feature posted here for significant power-savings on
> > > battery-powered devices:
> > > https://lore.kernel.org/rcu/20221017140726.GG5600@paulmck-ThinkPad-P17-Gen-1/T/#m7a54809b8903b41538850194d67eb34f203c752a
> > >
> > > There is also an LPC presentation about the same, I can dig the link if you
> > > are interested.
> > >
> > > > Maybe adding a sysctl to force the flush would be better for functional tests ?
> > > >
> > > > I would rather change the test(s), than adding call_rcu_flush(),
> > > > adding merge conflicts to future backports.
> > >
> > > I am not too sure about that, I think a user might expect the network
> > > interface to disappear from the networking tables quickly enough without
> > > dealing with barriers or kernel iternals. However, I added the authors of the
> > > test to this email in the hopes he can provide is point of views as well.
> > >
> > > The general approach we are taking with this sort of thing is to use
> > > call_rcu_flush() which is basically the same as call_rcu() for systems with
> > > CALL_RCU_LAZY=n. You can see some examples of that in the patch series link
> > > above. Just to note, CALL_RCU_LAZY depends on CONFIG_RCU_NOCB_CPU so its only
> > > Android and ChromeOS that are using it. I am adding Jie to share any input,
> > > he is from the networking team and knows this test well.
> > >
> > >
> >
> > I do not know what is this RCU_LAZY thing, but IMO this should be opt-in
>
> You should read the links I sent you. We did already try opt-in,
> Thomas Gleixner made a point at LPC that we should not add new APIs
> for this purpose and confuse kernel developers.
>
> > For instance, only kfree_rcu() should use it.
>
> No. Most of the call_rcu() usages are for freeing memory, so the
> consensus is we should apply this as opt out and fix issues along the
> way. We already did a lot of research/diligence on seeing which users
> need conversion.
>
> > We can not review hundreds of call_rcu() call sites and decide if
> > adding arbitrary delays cou hurt .
>
> That work has already been done as much as possible, please read the
> links I sent.

Also just to add, this test is a bit weird / corner case, as in anyone
expecting a quick response from call_rcu() is broken by design.
However, for these callbacks, it does not matter much which API they
use as they are quite infrequent for power savings.

Thanks.
