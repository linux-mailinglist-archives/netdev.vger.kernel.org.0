Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B835B5048EA
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 20:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiDQSbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 14:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiDQSbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 14:31:48 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABBE19C30
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 11:29:12 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id v77so22411846ybi.12
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 11:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3JYZWHOgAvsU7h9AaVhO8VrZb8WbfwhUYEiyfpkHdVw=;
        b=T3BGvAdUme4Z/IVohuy0y6rmjcc/k/lmdp6I9waGfNh7lElPro6JrLKAiRnobObm01
         V8Tne+WxkZD0kKzV6Rk44r86+S7NUxMs5ck+RSINqYxTnkW7cwJmpVdK5PSK3SF4MyKa
         F6GUwev+agOXiY1SChJD6YkH9lT1+iVr5a131boCP+O1H8Yonz2irZi3kI7i7/SWYkOU
         qRNrFwkbvfZ1WwX07Popm2O/6b6lPUgHlhKpGEkWK+bhIG/5bVAouunv3+M4MWc+bKHq
         hsZqD+jiiTWbIeLQCAIF/WZKRfsu27o6i+2xAI0eBIxGuJj5gH14R3CKo9YVsFgWM17D
         jALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3JYZWHOgAvsU7h9AaVhO8VrZb8WbfwhUYEiyfpkHdVw=;
        b=iDFdTMg/QsJXd6S9+ayNRjcMnwOJyFPGKdG4/PdzJeWTxi/keH8UiFET/ZtVE7C+qn
         /mdGA5bdPbVglFx5JVR9i4ldAyhkzd5tbXiNMIZLHd0cA1b/TPH9DqDq0SMONv79Ak8L
         Tx1R5qw86olDN2fmfC/4sYVWPjJGf15DIOWYJOzZyKhIrE9eHR0XvjV5H76UAdgokCt5
         5VY+LEStE3ozrhU/194WpepXlX4/UZicjkucqe4EBAU4lAX4aCztFCM0ZTnzGbX2CMsQ
         O46+pW5IuFkMGWahnia8+E+MSRyDgACxpYZPC3OqcS6k4ECgBWrtc4CsdUiO7hvhjv6q
         qAFg==
X-Gm-Message-State: AOAM530kSWkWEI6LBkxSGasue8ABF/PsjcBeVPIJknIA+ul/36rKE+Dq
        bc2R0WJKl8W3dqqhD4/grlzEgjt5zaugHw+OEAMlfA==
X-Google-Smtp-Source: ABdhPJxC0Vav1rmjeg7/DL/XxPMcf4CHqJ9nBURLS982HnyQMUmBbAjbqaXXSx7KDGQxHaCNzlZwaGsXCsPRaOL4y18=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr7161401ybs.427.1650220151013; Sun, 17
 Apr 2022 11:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220417171027.3888810-1-eric.dumazet@gmail.com> <87czhfy3e3.fsf@igel.home>
In-Reply-To: <87czhfy3e3.fsf@igel.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 17 Apr 2022 11:28:59 -0700
Message-ID: <CANn89iL5+4YkUSMLUZxy2ed9gDjpQxJzJUoSbgyeH7iNuc9ExQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: fix signed/unsigned comparison
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
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

On Sun, Apr 17, 2022 at 11:24 AM Andreas Schwab <schwab@linux-m68k.org> wrote:
>
> On Apr 17 2022, Eric Dumazet wrote:
>
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index cf2dc19bb8c766c1d33406053fd61c0873f15489..0d88984e071531fb727bdee178b0c01fd087fe5f 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5959,7 +5959,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
> >
> >  step5:
> >       reason = tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT);
> > -     if (reason < 0)
> > +     if ((int)reason < 0)
> >               goto discard;
> >
> >       tcp_rcv_rtt_measure_ts(sk, skb);
>
> Shouldn't reason be negated before passing it to tcp_drop_reason?

Good catch, thanks !
