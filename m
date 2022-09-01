Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45ABF5AA111
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiIAUyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 16:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiIAUyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 16:54:36 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A4698D1D
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 13:54:34 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id c9so489723ybf.5
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 13:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4jlXXthmnZbjTZtiVrsRSCOXepCwvjAKaezedZTf+1M=;
        b=dww8G34SkCKoX5t98auUmen/B2j+GBXp6v4tE5lPg8O17Ou+bYMY7NGL0+OFiLmfPX
         KB5TW3Hg05olsDbU2CzwQ+b0l2lXaobxlM0bqgJd9XPq2lkwiMhtg268U0LR1pgENUyg
         mw9NHDwFHa5UrvAydPu1H6hHymu7U37QFWsbhjRhtTy3sd/4bQQDVlT2RD4CEIgqicfq
         3vAOEfU4qC2vZ5VlgP4L4MGQSEnf35XUEk7uw7FC2H2NRZMCpev2bF2irrAkr91s2SgH
         cZP7vWAiNZggz+AuEqXG93mTZqAu8LM40i5ToAdS8XYVSMYFvx/sLwdWdFANCqCL8K9k
         UJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4jlXXthmnZbjTZtiVrsRSCOXepCwvjAKaezedZTf+1M=;
        b=sTabHRlc0/TGqGQc0T4elaF7e92gSDeglM4KccyJMLaj4AlvCKCtChKBqyaxeHSotg
         x3CcKfOEgr6PMdFxrdYw7BbwRutq6nPak1jBZMLyZL4xy1eG4GzuTTUcM+uCKeGr9cKw
         WI10lpKefhBObqhnjd9hC7LoA9aYSHsIpXb11k9K2CrOiFt/V+p1rfPVHMcc19SVyVty
         LDXU2VEMXr0sRyXSfgxA8oeXUdm4Vj8VrTos5/13jmW3gDqhM/TWuncIP+2vlLQJkLAa
         22Sj2t06a4bsesFVEyxARyOOsZjrmqoGfTjs4EOX3GnOxD1QLT9rs8P1TUlr4D7+XT3O
         zJNQ==
X-Gm-Message-State: ACgBeo1ilkKdR0HjAjNc+zmE0qtv83pMqyZV84kV+tsfSHpAIFoL0Tjb
        FLaqJG/zUcJGYRkCBlDvCmufWA+8wCbBE/vdl3/JoA==
X-Google-Smtp-Source: AA6agR6jgLiIHymOoujt2bkT4znI6OH8iUHG1AMhcO6J1HbWzop1c6DYcRaGmYydlzzhjkJk39ilU83dzTQekkbMduQ=
X-Received: by 2002:a25:84cd:0:b0:67a:699e:4e84 with SMTP id
 x13-20020a2584cd000000b0067a699e4e84mr20165239ybm.407.1662065673654; Thu, 01
 Sep 2022 13:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220901030610.1121299-1-keescook@chromium.org>
 <20220901030610.1121299-2-keescook@chromium.org> <20220831201825.378d748d@kernel.org>
 <202208312324.F2F8B28CA@keescook> <20220901124915.24ebc067@kernel.org>
In-Reply-To: <20220901124915.24ebc067@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Sep 2022 13:54:22 -0700
Message-ID: <CANn89iLPLu=cP0zu5r+hsXudSjMzieWke=nh0YwccH1QJUnzog@mail.gmail.com>
Subject: Re: [PATCH 1/2] netlink: Bounds-check nlmsg_len()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot <syzkaller@googlegroups.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 12:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 31 Aug 2022 23:27:08 -0700 Kees Cook wrote:
> > This would catch corrupted values...
> >
> > Is the concern the growth in image size? The check_sub_overflow() isn't
> > large at all -- it's just adding a single overflow bit test. The WARNs
> > are heavier, but they're all out-of-line.
>
> It turns the most obvious function into a noodle bar :(
>
> Looking at this function in particular is quite useful, because
> it clearly indicates that the nlmsg_len includes the header.
>
> How about we throw in a
>
>         WARN_ON_ONCE(nlh->nlmsg_len < NLMSG_HDRLEN ||
>                      nlh->nlmsg_len > INT_MAX);
>
> but leave the actual calculation human readable C?

This is inlined, and will add a lot of extra code. We are making the
kernel slower at each release.

What about letting fuzzers like syzbot find the potential issues ?

DEBUG_NET_WARN_ON_ONCE(...);
