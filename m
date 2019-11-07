Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49553F34E1
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389723AbfKGQno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:44 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:44122 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbfKGQnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:42 -0500
Received: by mail-io1-f66.google.com with SMTP id j20so2740166ioo.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f0Y2etkGbHsNadyc2PSjZyRg4HjHUUzuvONULqffee0=;
        b=LLyc4I3UUEWwUHUO28d0ISklBe6gPN4FDYqRW8KvIV5kmM4cY1DgvEQwVqWnedlDDj
         bn3/rRGlmtHBNIWfo83qHlKAkjoVkV98EB8JseIK7yEIxfn69+CVEohGdP7BAVmL1atH
         MnMzScAR8DjPvylluJrFpz8DbRR0WFEL+2pHU37Y5is5OxpXsAX5+FFHGsYDPZNpgS8J
         MO8ThIcpwHfrpMw+v1uVX15HU5B6XJnym36ZD5Fp2E96Cynj6Rnd4GLR9oxmQ5saaj2v
         DsamRTQYRUpe+0sNYwlWoJaC71ohNYS+3/0SxVuLogjMnsAQ0lx0wgCx8VHvmvxXVdNg
         waZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f0Y2etkGbHsNadyc2PSjZyRg4HjHUUzuvONULqffee0=;
        b=Ns4STd5n5tpaCm5cxqgJr+Qese64Vv3DscOtspvMmP/HzW7WlkGnlP4teywpFufS12
         i30EdZm9m1wEimfJeKF48kkl9r5ub+lZRFTIRcPReWf6eOx/qVZMwUsnJw+qF6fruU9q
         PBtDT3ig1Se6TrlHz5zXQFkf0tuw/kB7ctEROSKaSTWFlxsVhgsCLxWUQV+uWqzd7wAh
         fojJQ7hYVA1kaBbKZh/eE7Z/Bsle1CvB64/46RlCOzvZlBm4AgUqgfuv6n34Zx7ungSD
         0VEpmLvoU5p8XTkfCtwNV6l2K03QF7PoFsL0OdCeGHV6Lr5/coG4mi0RYOCJOF3xP641
         34lw==
X-Gm-Message-State: APjAAAVJY/g1vaW32FcSHHC+BJ56Bf4lMvpMNgtxXf45yZ73k+HP2dtU
        1G4FnUgrjkRnQbbgvDZJRElsFWW2h6NjTAcJTAW2/Q==
X-Google-Smtp-Source: APXvYqyj02P0/YFePoUN0khWdwERL8dpcBug3b9lp8RyflLx//yz4J6o1jASqIVyDz/PVMQ4co4OGrJ8COaQw3SSrSo=
X-Received: by 2002:a5e:8e02:: with SMTP id a2mr4561824ion.269.1573145021756;
 Thu, 07 Nov 2019 08:43:41 -0800 (PST)
MIME-Version: 1.0
References: <20191107024509.87121-1-edumazet@google.com> <094aedc7-3303-7f27-25eb-a32523faa5b7@gmail.com>
In-Reply-To: <094aedc7-3303-7f27-25eb-a32523faa5b7@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Nov 2019 08:43:30 -0800
Message-ID: <CANn89i+U05o3T8dMCyKM15QmYp43w3Uc5dHKvZ-z2WHB5zYNLQ@mail.gmail.com>
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
