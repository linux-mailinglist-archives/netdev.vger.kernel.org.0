Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6580A2078F0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404724AbgFXQUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404629AbgFXQUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:20:50 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C71C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:20:49 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id e6so439722vsm.3
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2J8wdA9rSZwk7I7Nvm7xFchDeFvnhiQIdFih6fJOYco=;
        b=a+zA65renqNqC3Zshj4T4Y0b1NJK7A1eJePBJRT9NsRb3sexIjMy+sJJniJCefHjZs
         y7jhCa7TzWhzUlOlmpQNLloJmNkfUZ1A9hmy8pE1FVwQCeNWKPDGPhySyx4GsCijXfFj
         eSY4dqlkmUm3Da7ex4AHXifCzqfxd1A6KhCnipEydXE8hoQ3/faYiagWI4K9PFQU6LAW
         2ogajJ+EBpbQGgwdBNHw1YEL4DA/6M2BxqQBvwNtsvWzNN0NgnbYxzUkQc+cNrcIsYsp
         gR1QIXJgBwZfzGA+kPxBWQ7rzSaicytIEMLJH758yl39ZrK3TGw1itaCCYDSM+t/6q5S
         qGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2J8wdA9rSZwk7I7Nvm7xFchDeFvnhiQIdFih6fJOYco=;
        b=YX1uwBHN8S5Acqbce3dpiYJXuFYP32qNmNYel+QB4tZIy3pdIP37fHEs1rNm85uV+s
         Pq0pWPgi5B8pHKscbC+0LPH7m7oAUpK621G7EbuwNTeBdmh07k7brgJtEjQG7UJFt2PD
         Xm3dgN28uaAIsLrnQ7VBtqVKZNagDb23fJr2pQMlNz8Sk5kC2zvnELETUnBUTiV0el0a
         hQjJ8Q4D1PW9XTiVN48GAtDWAh5+jTrfhuwR4pCQOJOi2ctaDN7iahwwkCdl3XRGCCDm
         hEBd9XjJO2GAZO7g3ICSxDBkeFmUt6DJ942vGaJtH+9yA4lBSPRzGWnM8j7xpm1g5YB9
         2H3Q==
X-Gm-Message-State: AOAM531sxBHCbA8mTpnUSDDWb3oSs6kDBEL9UOoIS6sRZegi5mUbiL0L
        edDT0jieFa1gPrGCMdlsX5iRuvDHDae/PTrF3hjH40/91kc=
X-Google-Smtp-Source: ABdhPJz4l2P+klInnOUHtaf4HOkxnbXm/jfB2PTECdqs7VX9/wWD7cN6Eu4vu2hcCHBK2jR7TVA7wll0mnbSyXPG9bo=
X-Received: by 2002:a67:ea98:: with SMTP id f24mr23242612vso.159.1593015648294;
 Wed, 24 Jun 2020 09:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200624095748.8246-1-denis.kirjanov@suse.com>
 <CADVnQym6aoueiB-auSxgp5tp0rjjte+MaxRPWd3t44F5VueKdA@mail.gmail.com> <CANn89iK_75H5jwGLaXUfRnLOgrFdP25xAYmyoD3SW6iFGEL96Q@mail.gmail.com>
In-Reply-To: <CANn89iK_75H5jwGLaXUfRnLOgrFdP25xAYmyoD3SW6iFGEL96Q@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 24 Jun 2020 12:20:30 -0400
Message-ID: <CADVnQyk28YkTtWbpOBuxKqDx7c6qtx0RDdca-c-N5_iCu6jFEA@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: don't ignore ECN CWR on pure ACK
To:     Eric Dumazet <edumazet@google.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        "Scheffenegger, Richard" <Richard.Scheffenegger@netapp.com>,
        Bob Briscoe <ietf@bobbriscoe.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 11:47 AM Eric Dumazet <edumazet@google.com> wrote:
> Do we really want to trigger an ACK if we received a packet with no payload ?
>
> I would think that the following is also needed :
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 12fda8f27b08bdf5c9f3bad422734f6b1965cef9..023dc90569c89d7d17d72f73641598a03a03b0a9
> 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -261,7 +261,8 @@ static void tcp_ecn_accept_cwr(struct sock *sk,
> const struct sk_buff *skb)
>                  * cwnd may be very low (even just 1 packet), so we should ACK
>                  * immediately.
>                  */
> -               inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
> +               if (TCP_SKB_CB(skb)->seq != TCP_SKB_CB(skb)->end_seq)
> +                       inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
>         }
>  }

Good point, Eric. Denis, would you mind respinning with Eric's addition?

thanks,
neal
