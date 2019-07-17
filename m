Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4171A6C2B4
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfGQVkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:40:52 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43703 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfGQVkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:40:52 -0400
Received: by mail-ot1-f67.google.com with SMTP id j11so2470735otp.10;
        Wed, 17 Jul 2019 14:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JwCY5EkX6qsSCI1zqTSmNzIVniTYPiFia3C3pkf6gXE=;
        b=Oui+ecCfFLBBgtSmUJViQyKvDee4rnPVVVxZZq6vZZTBhBkUYkeheQyB5cyJ2EPCYn
         qSj1BDqGkQaEN9QLj7v//zqlXqRlqKlyRZIVqhe/APlDIkuhJtPzRJEmVag7WFBte2bY
         Lqv5BzzRxApG1McZHAYYOgj7VjMpBz2BN8wcOcaDVnbmsmjmyn4C91Jb+RFckM3bNB0v
         Wpewsgu/++kYdMmv9vwfitUWM3BAcRxs6vvylfdizkFAPxh83jLiFf5NxZUmmFV0eLev
         KhB1fUacbnJms/HzNNNhMFW2IC4qdnw+LqyMvknUyWl583p1OPvx6XslBLCjOMJscVQg
         Biaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JwCY5EkX6qsSCI1zqTSmNzIVniTYPiFia3C3pkf6gXE=;
        b=ht/nt4cMLs93eg2a0t9yCVL0jGgaSWtUbmuJ5Lqx7btzLLQ1oW6r3r/dKwtN6JPhiq
         7NdAW3IQ41hJO1rJy4kdvEwH8BmZ6NsBU1SoMolPcoQcYpKXlM4I415lSvK4Y6o9PkNA
         lZEk8Ig6mOOL1DrmdJrsDbs1tYQrvSaD6T9MnmocdlIK4vhtPnWdmQaoSA6WyLxEpkM/
         DISp1XMZg2mvCOFb1YcH3fdeGu73LBeiS3EgMMVrRla7lTDRljpDcnIO9jRNfgwWBpbf
         BzF0wh+wzuArAEeVU23a2pMGyUMc0aYA9P0djaf/1JJ0SS61e25Kyes9SaTvtT+RqFK5
         dqeg==
X-Gm-Message-State: APjAAAUEyPIb+/6PVwmB4ZjR4e3sRtGcsXkgG0Y9M3BdFkcEordOrR/R
        a8tBNlVZKB/4EPpdQjj5RVhAr2ZYNz1aJAI7nx8=
X-Google-Smtp-Source: APXvYqysf8UWPm8GTDujuPn5wVlp6jl/AWJqP+AE7CvVunAzweacnZCJdfiO11rsJ1qDVpL0VrJQKsSWa8Yqs3pHsZ4=
X-Received: by 2002:a9d:6c46:: with SMTP id g6mr29693212otq.104.1563399650821;
 Wed, 17 Jul 2019 14:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190717201925.fur57qfs2x3ha6aq@debian> <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 17 Jul 2019 22:40:14 +0100
Message-ID: <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
Subject: Re: regression with napi/softirq ?
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jul 17, 2019 at 9:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, 17 Jul 2019, Sudip Mukherjee wrote:
> > I am using v4.14.55 on an Intel Atom based board and I am seeing network
> > packet drops frequently on wireshark logs. After lots of debugging it
> > seems that when this happens softirq is taking huge time to start after
> > it has been raised. This is a small snippet from ftrace:
> >
> >            <...>-2110  [001] dNH1   466.634916: irq_handler_entry: irq=126 name=eth0-TxRx-0
> >            <...>-2110  [001] dNH1   466.634917: softirq_raise: vec=3 [action=NET_RX]
> >            <...>-2110  [001] dNH1   466.634918: irq_handler_exit: irq=126 ret=handled
> >      ksoftirqd/1-15    [001] ..s.   466.635826: softirq_entry: vec=3 [action=NET_RX]
> >      ksoftirqd/1-15    [001] ..s.   466.635852: softirq_exit: vec=3 [action=NET_RX]
> >      ksoftirqd/1-15    [001] d.H.   466.635856: irq_handler_entry: irq=126 name=eth0-TxRx-0
> >      ksoftirqd/1-15    [001] d.H.   466.635857: softirq_raise: vec=3 [action=NET_RX]
> >      ksoftirqd/1-15    [001] d.H.   466.635858: irq_handler_exit: irq=126 ret=handled
> >      ksoftirqd/1-15    [001] ..s.   466.635860: softirq_entry: vec=3 [action=NET_RX]
> >      ksoftirqd/1-15    [001] ..s.   466.635863: softirq_exit: vec=3 [action=NET_RX]
> >
> > So, softirq was raised at 466.634917 but it started at 466.635826 almost
> > 909 usec after it was raised.
>
> This is a situation where the network softirq decided to delegate softirq
> processing to ksoftirqd. That happens when too much work is available while
> processing softirqs on return from interrupt.
>
> That means that softirq processing happens under scheduler control. So if
> there are other runnable tasks on the same CPU ksoftirqd can be delayed
> until their time slice expired. As a consequence ksoftirqd might not be
> able to catch up with the incoming packet flood and the NIC starts to drop.

Yes, and I see in the ftrace that there are many other userspace processes
getting scheduled in that time.

>
> You can hack ksoftirq_running() to return always false to avoid this, but
> that might cause application starvation and a huge packet buffer backlog
> when the amount of incoming packets makes the CPU do nothing else than
> softirq processing.

I tried that now, it is better but still not as good as v3.8
Now I am getting 375.9usec as the maximum time between raising the softirq
and it starting to execute and packet drops still there.

And just a thought, do you think there should be a CONFIG_ option for
this feature
of ksoftirqd_running() so that it can be disabled if needed by users like us?

Can you please think of anything else that might have changed which I still need
to change to make the time comparable to v3.8..


-- 
Regards
Sudip
