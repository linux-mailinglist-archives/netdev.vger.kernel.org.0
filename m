Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1846411D4
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 01:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiLCAMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 19:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiLCAMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 19:12:22 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B3BE5A9C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 16:12:21 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id d3so7111344ljl.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 16:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T17hu1/b1oJIOpp/s2IdsgvZJxOnCQsWrWJsGJFvqH0=;
        b=UKsnYoaJHmjewV9j9UwqD2mss44ru//Kfy1CBjAlCRxSxWdcim4HAW40LrmkKr+/fQ
         BKWXxnUxBAm6/Kcp58g69sXb1alIqwFjTJTrCsI+FvGMeN9BjYmSBIkrvKvW34NT9zuc
         bVeAO6p5W67WqETYt1V47mJ75gD8dcst7HogA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T17hu1/b1oJIOpp/s2IdsgvZJxOnCQsWrWJsGJFvqH0=;
        b=eMfRpy+1ZsaO1PDeeAwAR/Ve5TmeWbAW1BxLevBlmAK2GvCw5qlleFpKyXGsdgvnRI
         EDBk4pVQN/DQuG0w9PDX+EYOjNeYtqGI56WtBZGiOiK296+lGlksrQJeC8d35qEaEZCB
         ClgOhFm/ZGuK+eD6RYnduv6Qmtz7OecukIHuIQfSY2hV3vGBCkjOiRgNCACPAJbq+A4B
         ch17uE3sg5HGW6HyEymDk4IIBUo8PsaLRsZ/h5/ZAcbzcJi8gmzI3qPCN6cQezreJ8ch
         1Y/d6eiT7pzwGrT6KqND22JTRuep2RsPQT2oGWLebEsO6AaEj5ZHKRErNlIJusBFRcWM
         f4WA==
X-Gm-Message-State: ANoB5pnb6B6uEHPRETiea2bRVgmrJzfBQB54OfWCaz3xBxYfisXnlY7B
        Hb9VerHqG9dkLAPENYoj7Ll/sREMMiiYVbuVI2C/pg==
X-Google-Smtp-Source: AA0mqf74zQGRkJi4s/Iawo9QaLfN7eB13DzSKxalYectkSHGS+ZKABjtI+c5zub44iSVO/Z9ya7sWOnJbAHFaeewOf4=
X-Received: by 2002:a2e:3309:0:b0:279:d1ef:69f7 with SMTP id
 d9-20020a2e3309000000b00279d1ef69f7mr3381423ljc.167.1670026340151; Fri, 02
 Dec 2022 16:12:20 -0800 (PST)
MIME-Version: 1.0
References: <20221202052847.2623997-1-edumazet@google.com> <Y4qPJ89SBWACbbTr@google.com>
 <20221203000325.GL4001@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20221203000325.GL4001@paulmck-ThinkPad-P17-Gen-1>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Sat, 3 Dec 2022 00:12:08 +0000
Message-ID: <CAEXW_YQLYnufG2wx9R1xkQYwkugeN=VFf9Dgkfu8WGeYVFLcgw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
To:     paulmck@kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 3, 2022 at 12:03 AM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Fri, Dec 02, 2022 at 11:49:59PM +0000, Joel Fernandes wrote:
> > On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
> > > kfree_rcu(1-arg) should be avoided as much as possible,
> > > since this is only possible from sleepable contexts,
> > > and incurr extra rcu barriers.
> > >
> > > I wish the 1-arg variant of kfree_rcu() would
> > > get a distinct name, like kfree_rcu_slow()
> > > to avoid it being abused.
> >
> > Hi Eric,
> > Nice to see your patch.
> >
> > Paul, all, regarding Eric's concern, would the following work to warn of
> > users? Credit to Paul/others for discussing the idea on another thread. One
> > thing to note here is, this debugging will only be in effect on preemptible
> > kernels, but should still help catch issues hopefully.
>
> Mightn't there be some places where someone needs to invoke
> single-argument kfree_rcu() in a preemptible context, for example,
> due to the RCU-protected structure being very small and very numerous?

This could be possible but I am not able to find examples of such
cases, at the moment. Another approach could be to introduce a
dedicated API for such cases, where the warning will not fire. And
keep the warning otherwise.

Example: kfree_rcu_headless()
With a big comment saying, use only if you are calling from a
preemptible context and cannot absolutely embed an rcu_head. :-)

Thoughts?

Cheers,

 - Joel
