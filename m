Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5559E2E7597
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 02:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgL3Bxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 20:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgL3Bxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 20:53:47 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683DCC061799;
        Tue, 29 Dec 2020 17:53:07 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id j1so8020961pld.3;
        Tue, 29 Dec 2020 17:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MATtNX8g2V0CtdnpcPx0ufzydTCH4FKcH5GFuI54yMg=;
        b=uWtPqavN3J8W5GGy5OeZVQtA3LWGAw4QFIEQFcnJ7q2lpqvU4O9Txyk5AZA3YH0weV
         kQq1ha97sc87UiZOSPitNOQrBN5n+/5ZQEp4YH2/feQ0LtWxVAhPprwrfVK6O30NgWY4
         jY2T4Kc+2b+8lI7ezKwpmxqxS1iZRMIUXWS2TzTUZzgx4spUl8S1m7csuvRIYYbF4irw
         S5FLLkdsxQHwcoU4YFooELqFRkoxx9zPt+yXNtgBMMA45Cv/hiS0YPX7wJqdBYXvScK1
         5e+zFdreed++Eccs7j9F+DXj8E/9494Q5R2UCF3boO5s5mzq7P2/iweeTzm4YXiD0j4+
         3g1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MATtNX8g2V0CtdnpcPx0ufzydTCH4FKcH5GFuI54yMg=;
        b=m2+qDU1oaQIVSPHTWNaBlIpCzSR4bZlI70BbgQQb6rv+uoLciJU5Z4tXd6jN4FFATe
         JxNB5tttt2e44zx/Kwjx+EnTE3luEu9DD4jwzXgycF3e7A+sLh8qHbPlg9UmI0ouJjmU
         5/GvIe22fHPC1WeCjycZnaje5IlCyXsdjpnIiC7ogk2pSZsg9gSkIDIiGSC5pkjkWfY1
         sucBGqIVki1YB/iSSX23+luc83NWiD2ABYMUZKZnkX2lXLM9Qj8htgImSDCIQOWaqCl4
         C+IZtgozq5KBjfSERwC63xr/8kCMwUivY0Ft5IFz1Xd+hP7gvt3/ilSAiVe6OMJ+z3zQ
         rvFQ==
X-Gm-Message-State: AOAM531UJh15I3qpYLEGzIHpavh/oB+rkw7D0PZNCoUAlhzyorHbY2Zm
        U/wfZjZdRQlJM+M9pVY//7kOAyxjO1o7m8In9+U=
X-Google-Smtp-Source: ABdhPJxOTWa5YFwusqXpxXvwX6034q8lA64p4sFm71sD+DmnKmifA3nfHowmlayUCuf6HxBX/kmFzomkNhRcpEsi324=
X-Received: by 2002:a17:902:6f01:b029:dc:3182:ce69 with SMTP id
 w1-20020a1709026f01b02900dc3182ce69mr27788205plk.10.1609293186906; Tue, 29
 Dec 2020 17:53:06 -0800 (PST)
MIME-Version: 1.0
References: <000000000000b14d8c05735dcdf8@google.com> <20201229173730.65f74253@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201229173730.65f74253@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 29 Dec 2020 17:52:56 -0800
Message-ID: <CAM_iQpUzEgWYzW4BAih9M0JnPjZs+hESpCv-gkEKWc4s1SMV2A@mail.gmail.com>
Subject: Re: inconsistent lock state in ila_xlat_nl_cmd_add_mapping
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+eaaf6c4a6a8cb1869d86@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tom Herbert <tom@herbertland.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 29, 2020 at 5:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 13 Aug 2018 21:40:03 -0700 syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    78cbac647e61 Merge branch 'ip-faster-in-order-IP-fragments'
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14df4828400000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9100338df26ab75
> > dashboard link: https://syzkaller.appspot.com/bug?extid=eaaf6c4a6a8cb1869d86
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=13069ad2400000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+eaaf6c4a6a8cb1869d86@syzkaller.appspotmail.com
>
> #syz invalid
>
> Hard to track down what fixed this, but the lockdep splat is mixing up
> locks from two different hashtables, so there was never a real issue
> here.

This one is probably fixed by:

commit ff93bca769925a2d8fd7f910cdf543d992e17f07
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue Aug 14 15:21:31 2018 -0700

    ila: make lockdep happy again

given the time of last reproducing...

Thanks.
