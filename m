Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E894E215A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbiCUH0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiCUH0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:26:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D0855BC7
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 00:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC9D6B80F2B
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 07:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279A6C340F4
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 07:24:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="S3uVJJbD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647847487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hjy2cXg/pR6wbxhMZdE53B/Vc38fQptNwL09bkg78qo=;
        b=S3uVJJbDryWtlzUDiGAQDHNe8oA/NmTp1UcZiMPLwAMwWrfVGPMnOHPNB1FmzE5oNb9Yyq
        0yAIvt5dgaOJYvPDgroUFr15Mb05P0f17nuEVsTiRx4se//no2y2QeoxB/yywDiJW9c10S
        RCtuFzcSUFeLeohU37ygphsPB9I2CEI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3f5b2711 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 21 Mar 2022 07:24:47 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id l2so26413264ybe.8
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 00:24:46 -0700 (PDT)
X-Gm-Message-State: AOAM5339dZiLPHicSLnC7e0s5oTZ6eDnciU2uaFkoi8eHm5U/tEd/5Mq
        R8iqoob++4vxezUvtLiWVcRm0PYUOdFMWvIh8Z0=
X-Google-Smtp-Source: ABdhPJycLuXbyQLaEH4lExZjUHS1cCBgTz3uBRjUkZk6G0gz1V292sYRdwLi+yxeJKFAXpPowxYqgw5OX3YJXm71mIU=
X-Received: by 2002:a25:b854:0:b0:633:8a00:707a with SMTP id
 b20-20020a25b854000000b006338a00707amr21342066ybm.637.1647847486007; Mon, 21
 Mar 2022 00:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220319004738.1068685-1-Jason@zx2c4.com> <YjXGALddYuJeRlDk@linutronix.de>
In-Reply-To: <YjXGALddYuJeRlDk@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 21 Mar 2022 01:24:35 -0600
X-Gmail-Original-Message-ID: <CAHmME9rjNCM_2xOEUea1_T4aYJY+xqFL=hrEVBO_FK9eVT4cew@mail.gmail.com>
Message-ID: <CAHmME9rjNCM_2xOEUea1_T4aYJY+xqFL=hrEVBO_FK9eVT4cew@mail.gmail.com>
Subject: Re: [PATCH] net: remove lockdep asserts from ____napi_schedule()
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastian,

On Sat, Mar 19, 2022 at 6:01 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2022-03-18 18:47:38 [-0600], Jason A. Donenfeld wrote:
> > This reverts commit fbd9a2ceba5c ("net: Add lockdep asserts to
> > ____napi_schedule()."). While good in theory, in practice it causes
> > issues with various drivers, and so it can be revisited earlier in the
> > cycle where those drivers can be adjusted if needed.
>
> Do you plan to address to address the wireguard warning?

It seemed to me like you had a lot of interesting ideas regarding
packet batching and performance and whatnot around when bh is enabled
or not. I'm waiting for a patch from you on this, as I mentioned in my
previous email. There is definitely a lot of interesting potential
performance work here. I am curious to play around with it too, of
course, but it sounded to me like you had very specific ideas. I'm not
really sure how to determine how many packets to batch, except for
through empirical observation or some kind of crazy dql thing. Or
maybe there's some optimal quantity due to the way napi works in the
first place. Anyway, there's some research to do here.

>
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4277,9 +4277,6 @@ static inline void ____napi_schedule(struct softnet_data *sd,
> >  {
> >       struct task_struct *thread;
> >
> > -     lockdep_assert_softirq_will_run();
> > -     lockdep_assert_irqs_disabled();
>
> Could you please keep that lockdep_assert_irqs_disabled()? That is
> needed regardless of the upper one.

Feel free to send in a more specific revert if you think it's
justifiable. I just sent in the thing that reverted the patch that
caused the regression - the dumb brute approach.

Jason
