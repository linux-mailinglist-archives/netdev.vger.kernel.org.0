Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7E4AA66B
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379233AbiBEEVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBEEVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:21:01 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E93C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:20:56 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id v186so24501416ybg.1
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 20:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJ5WLOQg5yM+1EYrHn8pvSQHKyd9X/uA4aijttZ5IzQ=;
        b=N06+7qNu2QvypUDK3UDF7sazgGxe/WyMiT4FJ+Wmg0WYPiu3Y9zB0hsjlyIBIZl20H
         6X9258Yev0Ya9AfAczOpd55QsqcOJPoo0RuXOei6Ek5Gf86x7ide9J6S2FpqOyg5fp9x
         NejI2s9Tr8t3+YNnzqh4CxhZkG1wSEyDwd+hpBt0yqfFQUlo0Aq9uC/nY7LKC3eSfNzC
         9VTUt/YVQhZXx9lM9nY3j3w7U9kU3GWRUmNkXRvbOYLeYv++PhieBgc9HraIAS6P5wXc
         auqk/HKZPlsZ22OjTlh/AYdsTwOspNww+KRqST2EBNMyvFixGcY+i/LupFNRoR2zTxfS
         hPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJ5WLOQg5yM+1EYrHn8pvSQHKyd9X/uA4aijttZ5IzQ=;
        b=x68bnB+ElSFgnVuW7Jp1B0Mb0RymbrFbeYVu06l2Teh2XiBWXkEY5yL5euMck6oVrR
         KuT7rCcib8LTwQjTvBlDu0vmDoqYFNTFwHFnzoeF8lm5VbRqdHbK9fXOrH5ethIDWVAV
         RAlWVYdgHf4hHQy28O0HNNOeGLRa878xIEWUajwuX7m5EwWcvzql56uPk6yKAKe3q0bt
         zjVkLqJOElFV1DfBUmP6w1izO1UcD8D9Z79+7gWbxCi0CutgHhlHGSc9lzRckCbM5ohg
         KbqRXOwvIpb5UfdMrEmK986nG2Njhe1Ap1TcqjHik4Q4qNZOz5kj+gcWUhKIVp7xoY03
         Ln5w==
X-Gm-Message-State: AOAM532Gy9hzo1lk0LVC44lFVdPdxb9QIbg/p6i54JJ7bieQjZ54EmhO
        oYpUgZ1TXS4MNQ60XrkxhT+K5kKzbM1n8N38WHhOUg==
X-Google-Smtp-Source: ABdhPJxdkPxgDJF/qT8Bup85jpbLg45WiSt5M0EnDLaycI0pmrLmSsdMCYeSIsrVcVAhNDF7m5VKHKsOX0hjX+AqwuQ=
X-Received: by 2002:a81:1b4e:: with SMTP id b75mr2096637ywb.295.1644034854776;
 Fri, 04 Feb 2022 20:20:54 -0800 (PST)
MIME-Version: 1.0
References: <20220203225547.665114-1-eric.dumazet@gmail.com> <20220204200648.496c7963@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204200648.496c7963@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 20:20:43 -0800
Message-ID: <CANn89iLpPA4c6RLWZpONXP0rrjMn__T7_yN=qsBFE8L5VwyMyg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY)
 case
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
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

On Fri, Feb 4, 2022 at 8:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  3 Feb 2022 14:55:47 -0800 Eric Dumazet wrote:
> > +             if (!sk_wmem_schedule(sk, extra))
> > +                     return ENOMEM;
>
> Let me make this negative when applying, looks like an inconsequential
> typo with current callers.

Agreed, at first I was returning 0/1, and changed the 1 to ENOMEM at
the last moment.

Thanks !
