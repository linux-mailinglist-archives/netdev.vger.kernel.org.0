Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2F44DE4E8
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbiCSAm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241685AbiCSAmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:42:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2F3E65
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:41:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8016A6172C
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C62C340ED
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:41:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GhR80dX2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647650492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Iz/+lVd7B6MN/sKdXi5x/QmNGmp0dw8CWNiptRpLlw=;
        b=GhR80dX2kQ7tWwMik4lnhcpYjsmGJAa0Y5yq1K0CAc4cJWvxd3If/9QkSSh0SDXqc7lDHq
        1DXw7Qs5YrZbu4hQyPeJdB57llCVKmCiXaBToLitfE7C1YIsVQR9tBuTDhMgCQGIhlpnSs
        ENEALENltgL4PjupPMeSFtK07oGwNxQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0b379038 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 19 Mar 2022 00:41:31 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id v130so18576269ybe.13
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:41:31 -0700 (PDT)
X-Gm-Message-State: AOAM532eEfW4MTbZL5Xlp7qnuOmhDWtfWTFfVzq8r1wC/uXTxvseGdTj
        SPs7m5nGamCp9hM4Z7uPuERH/ro1w2FKhW5GdaY=
X-Google-Smtp-Source: ABdhPJwlMxtkXMyzKgI8ASFXGIHbmrrI0bot8AItLTOmVttRa4rfsRsh33QowAYGdnAU/sdIdoL+/Ipqr4ICAtMdSaw=
X-Received: by 2002:a25:b854:0:b0:633:8a00:707a with SMTP id
 b20-20020a25b854000000b006338a00707amr13055391ybm.637.1647650490615; Fri, 18
 Mar 2022 17:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <YitkzkjU5zng7jAM@linutronix.de> <YjPlAyly8FQhPJjT@zx2c4.com>
 <YjRlkBYBGEolfzd9@linutronix.de> <CAHmME9oHFzL6CYVh8nLGkNKOkMeWi2gmxs_f7S8PATWwc6uQsw@mail.gmail.com>
 <20220318115920.71470819@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220318115920.71470819@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 18 Mar 2022 18:41:18 -0600
X-Gmail-Original-Message-ID: <CAHmME9q4dKNtArpbsUbFv_Hg4BGEJ58GfRFMujQV5cZf36qFvw@mail.gmail.com>
Message-ID: <CAHmME9q4dKNtArpbsUbFv_Hg4BGEJ58GfRFMujQV5cZf36qFvw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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

Hey Jakub,

On Fri, Mar 18, 2022 at 12:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 18 Mar 2022 12:19:45 -0600 Jason A. Donenfeld wrote:
> > > In your case it is "okay" since that ptr_ring_consume_bh() will do BH
> > > disable/enable which forces the softirq to run. It is not obvious.
> >
> > In that case, isn't the lockdep assertion you added wrong and should
> > be reverted? If correct code is hitting it, something seems wrong...
>
> FWIW I'd lean towards revert as well, I can't think of a simple
> fix that won't require work arounds in callers.

I just got an email from syzbot about this too:
https://lore.kernel.org/wireguard/0000000000000eaff805da869d5b@google.com/

And no word from Sebastian, and now it's the weekend, so I suspect
you're probably right. I'll send in a revert.

Jason
