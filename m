Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D8AF34E8
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbfKGQpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:45:45 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37104 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729970AbfKGQpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:45:45 -0500
Received: by mail-il1-f194.google.com with SMTP id s5so2418297iln.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/5ZLgZnCcBuLv8aQS/7oB1B1AkTmYUwkrjkHhQWyyk=;
        b=gVEgN2LYJXzJPFK18DZdDkIFTErk1EYgsNnY0KYe3wXhJhlGHGvxsil7wIsTWRgw7q
         Jn3EOrtgUILD1jVkgRhlrp/AW/7791V5d0nShKg0LZy9V6PzkctV9dymlBASL/jstGD9
         TI0W6LBgDptYdbbrpVcugXweqsYLfcoldtuZQC2T0Tg/meizTfuLt3foMF1DCIkruz8A
         sS3L+r3lisdVo2nMDROnglnd+QtI4oxe/6C5SRUSvF2vYN+7aBqObzldhaZBUwd34ye+
         dqxY9Mg83CfUzqeo7qu0hoCcShggH9sQTRy9Q6HBYnGlImCEeYBtFni6bb4J7LJJI2Ki
         af3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/5ZLgZnCcBuLv8aQS/7oB1B1AkTmYUwkrjkHhQWyyk=;
        b=qgNsQb8g9/BSyr5mMmwhPpn0jAqRT3g6+Z5mPA/mhchlR9WfOC3rfdh4eblCJR4Ceh
         E76VZDMsDuVvU70xEqk/jykxETYdEkbU1j1Mi0poCPYaNUbr+OqFIse6nVxmCKAGaBrn
         659OfU/fIqry1UAHm9GoBxwwrAOPLjNXso8gchJVe46ku8Gx3oEkxzQd3EH48sQikXD7
         W4lMFeX07X+vsrtTKg4/nuMFl7kNLv7Krf3Lw+809kynm33nzBiHWNFXxOv1FE89s7tp
         bqXLROXDJcDFQBooWnuOPpDynsnfZizIj839H67kkuhmGa77TevtcqzJiZDLYDZWRnzw
         LoSg==
X-Gm-Message-State: APjAAAWPE3c61/vY/a9fjQzzx2xPvOKQ2z1MZA+A0XT325ZAljXW8ZbT
        2HOsBvUJav4UUhRbdC6Upqq8l2YcS3MYOxlMMjL6HaDoqzg=
X-Google-Smtp-Source: APXvYqzLWf08p/p/gsnC5YXkA8zlI2lScj4Weq2bZGCUiZ+v27rYv0DkyiRRHXNCOUnZpTSmB6UMkBTxRzpfGfJetIM=
X-Received: by 2002:a92:7e0d:: with SMTP id z13mr5950327ilc.168.1573145144137;
 Thu, 07 Nov 2019 08:45:44 -0800 (PST)
MIME-Version: 1.0
References: <20191107024509.87121-1-edumazet@google.com> <094aedc7-3303-7f27-25eb-a32523faa5b7@gmail.com>
In-Reply-To: <094aedc7-3303-7f27-25eb-a32523faa5b7@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Nov 2019 08:45:32 -0800
Message-ID: <CANn89iJbwZ9TqC_ry2O9QCzp3SJtUcXept_SkKY=DEMTP61zwg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fixes rt6_probe() and fib6_nh->last_probe init
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 8:37 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/6/19 7:45 PM, Eric Dumazet wrote:
> > While looking at a syzbot KCSAN report [1], I found multiple
> > issues in this code :
> >
> > 1) fib6_nh->last_probe has an initial value of 0.
> >
> >    While probably okay on 64bit kernels, this causes an issue
> >    on 32bit kernels since the time_after(jiffies, 0 + interval)
> >    might be false ~24 days after boot (for HZ=1000)
> >
> > 2) The data-race found by KCSAN
> >    I could use READ_ONCE() and WRITE_ONCE(), but we also can
> >    take the opportunity of not piling-up too many rt6_probe_deferred()
> >    works by using instead cmpxchg() so that only one cpu wins the race.
> >
>
> ...
>
> > Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
>
> That commit only moves the location of last_probe, from fib6_info into
> fib6_nh. Given that I would expect the same problem to exist with the
> previous code. Agree? Point being should this be backported to older
> stable releases since said commit is new to 5.2?

Yes, the commit adding last probe went in 4.19

Fixes: f547fac624be ("ipv6: rate-limit probes for neighbourless routes")

Thanks.
