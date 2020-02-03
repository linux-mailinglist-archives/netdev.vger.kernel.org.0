Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF50150A53
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgBCPy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:54:56 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38307 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgBCPy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:54:56 -0500
Received: by mail-yw1-f65.google.com with SMTP id 10so14097473ywv.5
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 07:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mSZpSSrX1gkn4q4BYYE/uc6pa2MZhYOZnx1rar1JeDU=;
        b=cNVYE3f5rZHULQiCtnVROGU8SPrQJtN5P3gwxhWiT06FesW8t8EPhhvoRdCdyRSWGD
         Pdm5AqvZeunWdsHx3WkHzH/yGWMo3CaukRjBhNGvY0s4oYi7yQXO9/jKDr/ejy+feAZj
         Q18KO8xrDCFpIWVDH0NWdFT0VisoIEKDtEIa62V2Z/6PAIssAAuLx9fG84Qcht4+FMaW
         sQ+3QJdZ38zsdrj3Y9kSNmHfdQpkDUXUDpDgTTRB7EyyPip6aAlC8VvFqbVOBoHIrneI
         4T+9ya619FEA7beV6a+gPVNNdnlitPAzMqSABGEsAvG7f6BxBosnSxi8oZbGlMWmlS50
         n6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSZpSSrX1gkn4q4BYYE/uc6pa2MZhYOZnx1rar1JeDU=;
        b=n2XqilTRUgEJzmvFcZCd44WDyPJAxlZlKVGcZMUwCmniCPj0JvxPlWYDVo1muFB5no
         RKUmelNsdU3dwG8kGmoYa1Q4Rjc2UmcXoYpdlmzxn3rWVWPwaKPxRk3BIMg2lkmK2yVv
         aV10FAIbPm62c3WkIoT3cHEuOn4IK6kgIUSUWlMSOE2gzjtvDMKM+k1tFP0hhfng4qnb
         r6TxVH0mr6DCX1f5kQjsiKqBZ9IL6zZnG2gE8eaTCvkrAb/xGpD30Gudhqd8axZuSmvC
         ZboJOzarPJMC2lH7LRKf/Z46wjIVEgQqGplL42MvE+CPr27/81L8MddPWdX2M59XkCD6
         GIjw==
X-Gm-Message-State: APjAAAUgYNF2PBbkbRBO94LitjeeU0ISzB8cbzXWCetne0kTiW0HwvR3
        0sMGfrT49a/OfSKA5e8N7tQPbBFb0tGKWEZKkIWxfg==
X-Google-Smtp-Source: APXvYqw+3unlJ461KJ9W2xUNJu4MNXa9KusyuC3+9ZFbWmbq/bJ4pMvRmLrikmQvqgpZZWmCsodpVf68GMu1iwZvj3A=
X-Received: by 2002:a25:d112:: with SMTP id i18mr18684063ybg.364.1580745294734;
 Mon, 03 Feb 2020 07:54:54 -0800 (PST)
MIME-Version: 1.0
References: <20200131122421.23286-1-sjpark@amazon.com> <20200131122421.23286-3-sjpark@amazon.com>
 <CADVnQyk9xevY0kA9Sm9S9MOBNvcuiY+7YGBtGuoue+r+eizyOA@mail.gmail.com>
 <dd146bac-4e8a-4119-2d2b-ce6bf2daf7ce@gmail.com> <CADVnQy=Z0YRPY_0bxBpsZvECgamigESNKx6_-meNW5-6_N4kww@mail.gmail.com>
 <7d36a817-5519-8496-17cf-00eda5ed4ec7@gmail.com> <5a8c1658de8f49b2994d19d371c13c79@AcuMS.aculab.com>
In-Reply-To: <5a8c1658de8f49b2994d19d371c13c79@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 3 Feb 2020 07:54:42 -0800
Message-ID: <CANn89iLNRKGhkqDbx+Q38sB=rV8q=u8-ZsbmpHzcnJSHXdu9Lg@mail.gmail.com>
Subject: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is received
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        "sjpark@amazon.com" <sjpark@amazon.com>,
        David Miller <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "sj38.park@gmail.com" <sj38.park@gmail.com>,
        "aams@amazon.com" <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 7:40 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 31 January 2020 22:54
> > On 1/31/20 2:11 PM, Neal Cardwell wrote:
> >
> > > I looked into fixing this, but my quick reading of the Linux
> > > tcp_rcv_state_process() code is that it should behave correctly and
> > > that a connection in FIN_WAIT_1 that receives a FIN/ACK should move to
> > > TIME_WAIT.
> > >
> > > SeongJae, do you happen to have a tcpdump trace of the problematic
> > > sequence where the "process A" ends up in FIN_WAIT_2 when it should be
> > > in TIME_WAIT?
> > >
> > > If I have time I will try to construct a packetdrill case to verify
> > > the behavior in this case.
> >
> > Unfortunately you wont be able to reproduce the issue with packetdrill,
> > since it involved packets being processed at the same time (race window)
>
> You might be able to force the timing race by adding a sleep
> in one of the code paths.
>
> No good for a regression test, but ok for code testing.

Please take a look at packetdrill, there is no possibility for it to
send more than one packet at a time.

Even if we modify packetdrill adding the possibility of feeding
packets to its tun device from multiple threads,
the race is tiny and you would have to run the packetdrill thousands
of times to eventually trigger the race once.

While the test SeongJae provided is using two threads and regular TCP
stack over loopback interface,
it triggers the race more reliably.
