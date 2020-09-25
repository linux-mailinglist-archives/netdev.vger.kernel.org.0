Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8547D279035
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgIYSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYSXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:23:51 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E6AC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:23:50 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c5so3234640ilk.11
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=om4hwkkxY33Mnt6ZUcdQDw0K8aNnONhgEqgzopLy+bA=;
        b=CfUV5x0YkKA3oHzSmvasfNvWDorbiKoAtGfkL2T1TSQ1S+kVfMvhC1q9OwNgiZDSvc
         0FHpLejaTLmOCzB21Bz8GiMGHAe75C5DPM1kxiv96V/gP5Maxv9I1K6T3uI7sRG+Hw0h
         hc9qm4+7JGP+32BIv81WKR+Pp+twd8MuXaxJe11Ys7HHbA2KFmaFw6EvRYx+lMOh64u5
         6orBnjmR7AG/io70sxforn2daL1LdQUUSGCHibC4vBB5Cv8PHnqoyr6TE6BD76AVzXIK
         qFpiW7CzGN//++El3x/d04Qb0cdPY2azAma1nMwbVyuaao6/ekL2EUmyF0KpHViCCYV4
         leuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=om4hwkkxY33Mnt6ZUcdQDw0K8aNnONhgEqgzopLy+bA=;
        b=EXQKNbwBIwnbbTqwWztdqF1HpFH4b3cVpAc1kjDy+1Z9kKS+monLGtfWTNT52ZhTXM
         nqfs6r33EgcvwP2pfUiAkWE4XFB1GzNkmjTXLhLXWl7DDb5QY86bWXjWyFH6NTHnwxfX
         dZdY4kanqOq3vjBThe06nRS35WjKQTbVaqsKOVa6VlXuscgIrHTh7/rQLurYSfTLeMZQ
         xJcAxBJIn8rqq7BseJz7vShVl0k6AXBAOTMrgBhwQaa/a68MAxwNXNijfgVk8oarfgxL
         eQInfZZmMV43S2Fx97yDI0/7dYWR/MrfCGf7zbxmvovXpM+pkn2gbzK4OYfLURdNLh0C
         bMfA==
X-Gm-Message-State: AOAM532GFL33KPxh8iMjUVvsLaOGj53TMFs7cFNrTkomzJ1Z8yejt4Zr
        GsDVc14wovUYdYL2Ku1N9qW8e3pR9l7H7H4Tl/Sb4w==
X-Google-Smtp-Source: ABdhPJzQZR9nhsI5iPyX0RWy4ZuZELge6cQ24pK8cCNQpP0Ol2tF0Mk6XKaCA7jnXWg5htG5bPAKLe1/X4bisEYjqvE=
X-Received: by 2002:a92:d48b:: with SMTP id p11mr1290378ilg.69.1601058229903;
 Fri, 25 Sep 2020 11:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
 <CAEA6p_BBaSQJjTPicgjoDh17BxS9aFMb-o6ddqW3wDvPAMyrGQ@mail.gmail.com> <20200925111627.047f5ed2@hermes.lan>
In-Reply-To: <20200925111627.047f5ed2@hermes.lan>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 25 Sep 2020 20:23:37 +0200
Message-ID: <CANn89iKAaKnZb3+RdMkK+Lx+5BBs=0Lnzwhe_jkzP4A8qHFZTg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Wei Wang <weiwan@google.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 8:16 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 25 Sep 2020 10:15:25 -0700
> Wei Wang <weiwan@google.com> wrote:
>
> > > > In terms of performance, I ran tcp_rr tests with 1000 flows with
> > > > various request/response sizes, with RFS/RPS disabled, and compared
> > > > performance between softirq vs kthread. Host has 56 hyper threads and
> > > > 100Gbps nic.
>
> It would be good to similar tests on othere hardware. Not everyone has
> server class hardware. There are people running web servers on untuned
> servers over 10 years old; this may cause a regression there.
>
> Not to mention the slower CPU's in embedded systems. How would this
> impact OpenWrt or Android?

Most probably you won't notice a significant difference.

Switching to a kthread is quite cheap, since you have no MMU games to play with.

>
> Another potential problem is that if you run real time (SCH_FIFO)
> threads they have higher priority than kthread. So for that use
> case, moving networking to kthread would break them.

Sure, playing with FIFO threads is dangerous.

Note that our plan is still to have softirqs by default.

If an admin chose to use kthreads, it is its choice, not ours.

This is also why I very much prefer the kthread approach to the work
queue, since the work queue could not be fine tuned.
