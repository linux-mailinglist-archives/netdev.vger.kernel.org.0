Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7054DA1B
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 08:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiFPGAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 02:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358838AbiFPGAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 02:00:40 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048291CB12
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:00:40 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31772f8495fso3206467b3.4
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZInT1u+pWZLnQddThGJUbbB0YhAsKMsGQ/rfD7WrGMY=;
        b=Jku9w/WocrOOa9eZoTIFWlKZJwuABEeKeNU8qQVpVyUMuYLBn8Nr5KfBa4u/8Izkh/
         /1phGBI7hjk+dQsFmpoKFGeVmhqk5annNg4d4th3bwrhAo+GnWCTZHjbwWJ39v3AdyIH
         CR6TKdDU6Zx6WZ0KSd5kWMqxl/RKMUxbWMA+EGgvGfZEqn+vi3oZtu62e8e4dhBDFpyJ
         lvPOYrlIjXG7m22COwbbLvE5DA9ebZ9NCkEA2I9EKkEiRX7ksjcBkYD77tQJPIdeMZ/B
         HWchTkqIX285Nh3kjy93s4mBcY/eS2S4N0ug+VUesWwRm7av+EhOm+u4Cjw0eOfc6f3b
         FSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZInT1u+pWZLnQddThGJUbbB0YhAsKMsGQ/rfD7WrGMY=;
        b=5d6q551B813dAM2tXQjohHne3sS7kJWhcSI/yNRypdcXjqfJ5pJ4d1Q2EwEAsbW0+3
         gY3AuptfMWO2PiFvCi2xLg2kRSZZbbdPoFqgpuH2uZ98ykW5AKrqG+1tFNrS7xgHwfPQ
         QOuQdmpENLjYlHPwrbOQkzbCJ87qPBIW8ni9yf8L1rB4XcIDNbxrHMqYsZ/Fn65IF8cR
         yiCEskzbWzz3jrfDV04dEG6jTexly7EnOqMEtZsqUHXaruWVIQJQLUzfMkO1ikJ48Ekq
         z2w0vITh/uR7qKFpJEkOwlDDAqB1xoDCQ7gM7x+KQmBaPGyTQ5nvpFaNb6YTRVWntWO4
         NOxg==
X-Gm-Message-State: AJIora+hJMq6b6XWJnZwBOgWGqV7wROyJhMir/7JVAl/zAgiJ+xs2E/J
        JPkv+Ab7qpnVCGhjaErN+/QSrTG21TqUEnNzFJ14ng==
X-Google-Smtp-Source: AGRyM1vKmG3v0clCzuZwz1hgo6ZUTpRu26miyCyfAGVe3IVCe7Mdte5cSU1Wh/HfWKPbX3vYVanDfQH+nkW3EfeLGak=
X-Received: by 2002:a81:1711:0:b0:317:4d4b:a487 with SMTP id
 17-20020a811711000000b003174d4ba487mr3678401ywx.55.1655359238924; Wed, 15 Jun
 2022 23:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com> <20220615.125642.858758583076702866.davem@davemloft.net>
In-Reply-To: <20220615.125642.858758583076702866.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Jun 2022 23:00:27 -0700
Message-ID: <CANn89iKie9pgj8mjXGrgpH0XL3Ehfad61kCJ8rGdOk4GoR=o+g@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] tcp: final (?) round of mem pressure fixes
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 4:56 AM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 14 Jun 2022 10:17:32 -0700
>
> > From: Eric Dumazet <edumazet@google.com>
> >
> > While working on prior patch series (e10b02ee5b6c "Merge branch
> > 'net-reduce-tcp_memory_allocated-inflation'"), I found that we
> > could still have frozen TCP flows under memory pressure.
> >
> > I thought we had solved this in 2015, but the fix was not complete.
> >
> > v2: deal with zerocopy tx paths.
>
> Does not apply cleanly to net, please respin.
>
> Thank you.

I was targeting net-next tree for this old bug, and planning to
prepare stable backports.

Tell me if you prefer to respin to net tree, probably later today
because I am traveling.

Thanks.
