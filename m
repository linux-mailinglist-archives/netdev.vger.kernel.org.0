Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0D712B0F1
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 05:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfL0ESE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 23:18:04 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39499 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfL0ESE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 23:18:04 -0500
Received: by mail-ot1-f66.google.com with SMTP id 77so34763787oty.6;
        Thu, 26 Dec 2019 20:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DfKg9SPkUvfybKMjL5YOx3Xk7Ze33G0ys6ahY8byY+s=;
        b=rU+dNtJgARXnqPDmeFamfL2PeBiWwNJdd1b1/9gD5lxlIpbk3wM1M8i2DGLSpdyAn5
         09hP+DZJH+kGodPhEGBuSTlLv8nrOITA69yGJ4u/7iAn8i4h00j53Fh2CF/tSVx6n/kv
         PbRvsXxDcuWi7+t2OHet8bnC8E43P45XWHBMjGDBsXEPtlxColbJbmIJ7pYgmdrTSwGg
         RAXLRy+b6d2Wnd2X45tYyGtLfho/PPSrdapJiCGwt/Q7eJfTCEbFIe+OL4DtHQxI/HzE
         Lbtmi3nEDX01sZidPSyAap9LdXkfn6nguD5804uz5q8UJoYbAAQ0vvczr9tqyUMSssjr
         b8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DfKg9SPkUvfybKMjL5YOx3Xk7Ze33G0ys6ahY8byY+s=;
        b=NrKK/X7IyhizCpsWXFgjvxPbGtIxdSOsnU6RCwznoDl5iUBghLHfpelnYoSMRk+Tap
         vEwW7rS/CO1qVdUm9gHc3QrPJps4tw4VlvOOVxmdJMaiamksHueAGCW0Tj7KWQbeMPON
         2xHk8orw1rE1ACqbA0BIFCXZ6VFpVgb0m+2boJsi5q2WkgG78E7NhLNZa4qQk+uErfIi
         +Tr5S/RfS6SqwSCjNrmCgJ0iMJb3XZiMH09nb8pN0Ci9mCqF7rwqImwL9aTtba6g/xdT
         dKR5cvwi7YMUk1gc2Z8zSIvPTetC+uA8A4j+kyIcE7V36RPwybc5/RSK088JmMgJx7kd
         FH0Q==
X-Gm-Message-State: APjAAAXULDk7XDgW+zwDLjSfHk7UrBkX04wPPPTJ3r/qBY3iB4W3txwm
        2IinTEq62Nf1pF/EkDNzRYvdJNvWocH9EPSzG1+vbd4S
X-Google-Smtp-Source: APXvYqzAOBWIHURe65cgyn+zIKkk1chLEZEJcKMdb9lioX2df362DLpSsRG620wwmEa5h58dQU+VlMASJZLGZe1hNl8=
X-Received: by 2002:a9d:53c4:: with SMTP id i4mr42873422oth.48.1577420283259;
 Thu, 26 Dec 2019 20:18:03 -0800 (PST)
MIME-Version: 1.0
References: <00000000000057fd27059aa1dfca@google.com> <20191227003310.16061-1-fw@strlen.de>
In-Reply-To: <20191227003310.16061-1-fw@strlen.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 26 Dec 2019 20:17:52 -0800
Message-ID: <CAM_iQpW5stB_BshUJr0O3uDyaxDcqN-13ZqRr7dcmcJcBp-Tfg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: arp_tables: init netns pointer in
 xt_tgchk_param struct
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 4:37 PM Florian Westphal <fw@strlen.de> wrote:
>
> We get crash when the targets checkentry function tries to make
> use of the network namespace pointer for arptables.
>
> When the net pointer got added back in 2010, only ip/ip6/ebtables were
> changed to initialize it, so arptables has this set to NULL.
>
> This isn't a problem for normal arptables because no existing
> arptables target has a checkentry function that makes use of par->net.
>
> However, direct users of the setsockopt interface can provide any
> target they want as long as its registered for ARP or UNPSEC protocols.
>
> syzkaller managed to send a semi-valid arptables rule for RATEEST target
> which is enough to trigger NULL deref:
>
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> RIP: xt_rateest_tg_checkentry+0x11d/0xb40 net/netfilter/xt_RATEEST.c:109
> [..]
>  xt_check_target+0x283/0x690 net/netfilter/x_tables.c:1019
>  check_target net/ipv4/netfilter/arp_tables.c:399 [inline]
>  find_check_entry net/ipv4/netfilter/arp_tables.c:422 [inline]
>  translate_table+0x1005/0x1d70 net/ipv4/netfilter/arp_tables.c:572
>  do_replace net/ipv4/netfilter/arp_tables.c:977 [inline]
>  do_arpt_set_ctl+0x310/0x640 net/ipv4/netfilter/arp_tables.c:1456
>
> Fixes: add67461240c1d ("netfilter: add struct net * to target parameters")
> Reported-by: syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com
> Signed-off-by: Florian Westphal <fw@strlen.de>

I was about to send out a same patch.

So:
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
