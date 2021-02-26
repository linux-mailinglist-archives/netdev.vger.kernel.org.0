Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9732617B
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 11:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhBZKmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 05:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhBZKmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 05:42:15 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC18C061786
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:41:35 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id m9so8461810ybk.8
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nO0XK/w8yxvTjLqajs+l7Ht5P7GWyfVSxDdAhl6kfjY=;
        b=HWZGrFDlpAOU1L82MCzbB0qh77slPVpG7pUjVoSBDUkhMh1JBhVgtn1xvmJoP52dd4
         XMMlY5CByMxw2umni97IFMW36+HvuwyoebGCMp8KPRdk3y3fxMHBdcjYFIxdwSxvAf6m
         EG6EOXKToRaomUJUu8F31oBXyELhGipzxx/dwq4pB85OS3TsWOPh4GW3iQ5xFEtruIJE
         gLqpvTvAB8UE7yfIi7X8UptTN1YZ2kcE4ISsHx2ucoIxD7lTRyXvzzaAwJgopBJlK16x
         rfHOPC+HZQptaishZolQr+BQb9nlo9aKpizxMyZUHaPFCx4iG/07CtvGm8XIbK3FLZ4Z
         SoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nO0XK/w8yxvTjLqajs+l7Ht5P7GWyfVSxDdAhl6kfjY=;
        b=tRivWREQ+mYjmfT7SrYMzX5MbTla4OsuWIOr1Nmfs1qCK59cvdztPOp99+zI+cfCr7
         uUsBsxBVwuo5Gi/E3CP0xuzNvTK92x9XYQcfWeQ1e1Xt01dBJK6UHQ30fIm9rQ/fzAUM
         uoVEVlzUiSj03c0nKJiiHzRqSjxfRSQ/xhEKddUTeYaqpCLB90SG3F2ZUFBF0OKmPk7f
         u3kd82fASZaHxQMndq7GGccjGseeJybZI1/GPeEzFFdPywl5U4UwMhkd74pXAyUQ/gz7
         FKUwJsRI1eYd56bIDd/PfF9WM3kZf8e7NHrmi/VA4hpkHbA0D4GgSrRtgb+SYDloX+FH
         D05Q==
X-Gm-Message-State: AOAM531ErFOFVwjdzSiRv0b+9RM0P5kIj3n7pKuNdHxUN2CjaVtzr7+L
        ruzXvczdrGmzw+Wa7CoNq9WbVeu2/dtQwsJ2jQS2UA==
X-Google-Smtp-Source: ABdhPJxyrsb8OQEs6TD89xu60ZTm1zBmSgL36ucRLoHdllq8D7TgbpSfjmggZItZ7kkogyCIPN12wm8Mcu/cZZArK7c=
X-Received: by 2002:a5b:78f:: with SMTP id b15mr3600245ybq.234.1614336094153;
 Fri, 26 Feb 2021 02:41:34 -0800 (PST)
MIME-Version: 1.0
References: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210225191552.19b36496@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89iJwfXFKnSAQpwaBnfrrE01PXyxLUieBxaB0RzyOajCzLQ@mail.gmail.com>
In-Reply-To: <CANn89iJwfXFKnSAQpwaBnfrrE01PXyxLUieBxaB0RzyOajCzLQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Feb 2021 11:41:22 +0100
Message-ID: <CANn89iL7XCLBxsUnV3c_5AD8eSJ=jXs6o_KJUjmZAGo6_6sqUg@mail.gmail.com>
Subject: Re: Spurious TCP retransmissions on ack vs kfree_skb reordering
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 11:05 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Feb 26, 2021 at 4:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 25 Feb 2021 15:25:15 -0800 Jakub Kicinski wrote:
> > > Hi!
> > >
> > > We see large (4-8x) increase of what looks like TCP RTOs after rising
> > > the Tx coalescing above Rx coalescing timeout.
> > >
> > > Quick tracing of the events seems to indicate that the data has already
> > > been acked when we enter tcp:tcp_retransmit_skb:
> >
> > Seems like I'm pretty lost here and the tcp:tcp_retransmit_skb events
> > are less spurious than I thought. Looking at some tcpdump traces we see:
> >
> > 0.045277 IP6 A > B: Flags [SEW], seq 2248382925:2248383296, win 61920, options [mss 1440,sackOK,TS val 658870494 ecr 0,nop,wscale 11], length 371
> >
> > 0.045348 IP6 B > A: Flags [S.E], seq 961169456, ack 2248382926, win 65535, options [mss 1440,sackOK,TS val 883864022 ecr 658870494,nop,wscale 9], length 0
>
> The SYNACK does not include the prior payload.
>
> > 0.045369 IP6 A > B: Flags [P.], seq 1:372, ack 1, win 31, options [nop,nop,TS val 658870494 ecr 883864022], length 371
>
> So this rtx is not spurious.
>
> However in your prior email you wrote :
>
> bytes_in:      0
> bytes_out:   742
> bytes_acked: 742
>
> Are you sure that at the time of the retransmit, bytes_acked was 742 ?
> I do not see how this could happen.

Yes, this packetdrill test confirms TCP INFO stuff seems correct .

//
// SYN-data are not fully acknowledged
//
`../../common/defaults.sh
 sysctl -wq net.ipv4.tcp_timestamps=0 `

// Cache warmup: send a Fast Open cookie request
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
   +0 sendto(3, ..., 0, MSG_FASTOPEN, ..., ...) = -1 EINPROGRESS
(Operation is now in progress)
   +0 > S 0:0(0) <mss 1460,nop,nop,sackOK,nop,wscale 8,FO,nop,nop>
 +.01 < S. 123:123(0) ack 1 win 5840 <mss
1460,nop,nop,sackOK,nop,wscale 6,FO 1234abcd,nop,nop>
   +0 %{ assert tcpi_delivered == 1, tcpi_delivered }%
   +0 > . 1:1(0) ack 1
 +.01 close(3) = 0
   +0 > F. 1:1(0) ack 1
 +.01 < F. 1:1(0) ack 2 win 92
   +0 > .  2:2(0) ack 2


//
// Test: the data in SYN-data are retransmitted when server acks only ISN
//
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 4
   +0 fcntl(4, F_SETFL, O_RDWR|O_NONBLOCK) = 0
   +0 sendto(4, ..., 700, MSG_FASTOPEN, ..., ...) = 700
   +0 > S 0:700(700) <mss 1460,nop,nop,sackOK,nop,wscale 8,FO 1234abcd,nop,nop>
 +.02 < S. 0:0(0) ack 1 win 5840 <mss 1040,nop,nop,sackOK,nop,wscale
6,FO 1234abcd,nop,nop>
// Retransmits data in SYN-data on the first ACK.
   +0 %{ assert tcpi_delivered == 1, tcpi_delivered }%
   +0 %{ assert tcpi_bytes_acked == 1, tcpi_bytes_acked }%
   +0 %{ assert tcpi_bytes_sent == 2*700, tcpi_bytes_sent }%
   +0 > P. 1:701(700) ack 1
   +0 < P. 1:1001(1000) ack 701 win 257
   +0 %{ assert tcpi_delivered == 2, tcpi_delivered }%
   +0 %{ assert tcpi_bytes_acked == 701, tcpi_bytes_acked }%
   +0 > . 701:701(0) ack 1001
   +0 read(4, ..., 1024) = 1000
   +0 %{ assert (tcpi_options & TCPI_OPT_SYN_DATA) == 0, tcpi_options }%
   +0 close(4) = 0
   +0 > F. 701:701(0) ack 1001
 +.02 < F. 1001:1001(0) ack 702 win 257
   +0 > . 702:702(0) ack 1002
