Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4AA31AA61
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 08:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhBMHvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 02:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhBMHvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 02:51:52 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DE5C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 23:51:12 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id y128so1819220ybf.10
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 23:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62T3EbgH/uFzjVLTtwsf7zOusCXF1P64HhQpGXtu3YI=;
        b=m4vbZpIlSy1jQ/new0s5TnnSmqL/91sKXFOv4WMjB5HOXh/JxTtg3/tyD+MukhLVTq
         BvdC5QV/Q7m9YGAyeJMBovaDuxhrW7zjKHoplj/GeSbt87Vj8TRFG/p1VDkIXi74mlsK
         yP49mV7s6hdFO8dy7smr2AnhIK9pMt5CCVY4e9l9EndrsuLC/VCDzpQ6PBBb2ACDrGWD
         Q53aQ9FTVhpBHi0aAzla9iLW4ffv1Xzn/tDNVyp87eItqrYnwqT3IdzXvxNKNzGg7Ulm
         pJT5tIVJ18HGFJ7BJe1SWQmpDRxIP4Q1avRRa+qnWv7XyhQCszKQoiqifDW6AVy3J6mS
         h4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62T3EbgH/uFzjVLTtwsf7zOusCXF1P64HhQpGXtu3YI=;
        b=JR9sAq5gwNOH5+7n7AFKOPMuEM5DIpJJcIJriwEfHaEOzQrRJe2ca5R21ipwcrlUa+
         rXgO3jieMtpymGZ2pxLjG1fmh+cTNN/HM/TfHLS2+R6K9BlQAd3vOoQ8o+2pebK2HT3v
         zbKZl8cUrplJdmllWVhYpRPwm8cSEJPaumAZLa8SRolQ9E3FPp6d3CJ3I6r0ZAOaOxoN
         bmhv6RcAfqL6gD4OH3emagMhss7WSATrIMrHrKESB7njnRO0q75jVUa8nCBCUo/mnX0m
         vtRBgwKDtPMSfzTlIOQna0ozl//L04yfoxrVDz46UieM92DVWuOcCrgMRkbjTYqyPQsG
         3QQg==
X-Gm-Message-State: AOAM533e1Hufwl7vWsXS+ywt5hwx+T4+AjiAsT1K/JdLVkP7Nnpq2oUz
        /J9OCkiqr38VCCapSJZBNLjK1SKDZkicBV+EvGlIPA==
X-Google-Smtp-Source: ABdhPJw+6kZa7+kLOf2Si3+wrd8MeyEr7/aewoHnHiFJ6EVXOKXrEQAwnzl+hPfBdTEOzfuJ1Q3IKhzIQqM72it40OE=
X-Received: by 2002:a25:1d88:: with SMTP id d130mr9383617ybd.446.1613202670933;
 Fri, 12 Feb 2021 23:51:10 -0800 (PST)
MIME-Version: 1.0
References: <20210212232214.2869897-1-eric.dumazet@gmail.com>
 <20210212232214.2869897-3-eric.dumazet@gmail.com> <CAEA6p_A0g-7WMfyQbw55wdAKkFkEbW2A-XwTNziP9XyD3MjmCA@mail.gmail.com>
In-Reply-To: <CAEA6p_A0g-7WMfyQbw55wdAKkFkEbW2A-XwTNziP9XyD3MjmCA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 13 Feb 2021 08:50:59 +0100
Message-ID: <CANn89iJ-Y9avDrs3Jbx93J8zwMFfrY8Pq1LAL6tYWDvtcfdWKg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tcp: factorize logic into tcp_epollin_ready()
To:     Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 1:30 AM Wei Wang <weiwan@google.com> wrote:
>

> >  void tcp_data_ready(struct sock *sk)
> >  {
> > -       const struct tcp_sock *tp = tcp_sk(sk);
> > -       int avail = tp->rcv_nxt - tp->copied_seq;
> > -
> > -       if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
> > -           !sock_flag(sk, SOCK_DONE) &&
>
> Seems "!sock_flag(sk, SOCK_DONE)" is not checked in
> tcp_epollin_read(). Does it matter?
>


Yes, probably, good catch.

Not sure where tcp_poll() gets this, I have to double check.

Thanks !
