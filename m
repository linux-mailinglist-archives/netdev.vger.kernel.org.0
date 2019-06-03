Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B332907
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 08:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfFCG7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 02:59:13 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:39452 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfFCG7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 02:59:13 -0400
Received: by mail-it1-f194.google.com with SMTP id j204so19629029ite.4
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 23:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XWFIz7NCVrdK9m5dlh1tOBVk1VqWPZQpkAyT6C9+b4c=;
        b=JgvjmlKSO8ChcoDDUlEBzPC1cwn20fuDHG2ADbUlJtHKKLjUAhF6GrbiFVSbNQFbaf
         knTHSBPg1kE9/Of8AJvRfaJCwvhxRD9G9wD80wDkzgUQTzVORcuhfgbYyTV24bVmzTA9
         cPI92iHii4rT/P+bLqdAy72/7mvElkr1QIuRYPNSu+dSczB6G1FmZt1nliPEpVFgutSy
         eudMufFqpzqlhxKe+a3FfoI9+uITZvlyIQw2IfxAzrEXOYRdLf4D1dlVqpd8+HAIVj8z
         Pt/YrVfb/hE2EtHcJ2amA8IfSPTbu+2uZeFaUQOIfIqvakZVotNHx+X9+Esrke+L+Nd5
         TZmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XWFIz7NCVrdK9m5dlh1tOBVk1VqWPZQpkAyT6C9+b4c=;
        b=UG7Mh+f1AMzjt5IynCG76MYEUeEFD7hgS//OvbWiUdrwy46WIIjjqJpt07V52xNw/s
         Kb8wEzSQ6wO5CMEfLa0oKeD4CSimYrJJO16JguwR9uhViOIyMcFUTj2PRaJi49J9F96N
         s45UvaodqGBylVba5LJnvfxzNl0HnuJj3tZFjhucpwGElLhJ6klWUbCUjDgkCv7Mx+My
         iB95eozqxguWUbAeyaoRC3EPTCUEwt13hDSfobkBXOYxVnKrG5mDgosBRlgI6E7RHrqd
         AyD5c9PLUS6aE/eT3+fAv1kP7AkSTfmF6v7SHMPyZWBsWOf4iKj8a8gxVDNm646akogD
         kewA==
X-Gm-Message-State: APjAAAXQbu6sAcKqs/P17Ks6xeHycIX8XlIqMMAPx2slQeTIV26L6giK
        HyBXRhOGzMPOyXb9bybmRn1U3G4dz55qYwfVXezArA==
X-Google-Smtp-Source: APXvYqwqPQASMFCWoe21WchhYtOEk7CEvxoeXCxaQk0iE0UfTp6/xHZmJiVR7Ce5xDMdeKfJKN4J++WN1mQ7DE3OkPQ=
X-Received: by 2002:a24:9083:: with SMTP id x125mr9448011itd.76.1559545152651;
 Sun, 02 Jun 2019 23:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000aa7a27058a3ce9aa@google.com> <250fba08-9cd7-7c79-f00a-d116e76fb51b@gmail.com>
In-Reply-To: <250fba08-9cd7-7c79-f00a-d116e76fb51b@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 3 Jun 2019 08:59:01 +0200
Message-ID: <CACT4Y+aOY01_2whx4cjFGY7Pj29JwYKmgBcpS6cM2oz75y1bjg@mail.gmail.com>
Subject: Re: general protection fault in tcp_v6_connect
To:     David Ahern <dsahern@gmail.com>
Cc:     syzbot <syzbot+5ee26b4e30c45930bd3c@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 5:29 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/1/19 12:05 AM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    f4aa8012 cxgb4: Make t4_get_tp_e2c_map static
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1662cb12a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d137eb988ffd93c3
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=5ee26b4e30c45930bd3c
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+5ee26b4e30c45930bd3c@syzkaller.appspotmail.com
> >
> > kasan: CONFIG_KASAN_INLINE enabled
> > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 17324 Comm: syz-executor.5 Not tainted 5.2.0-rc1+ #2
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:__read_once_size include/linux/compiler.h:194 [inline]
> > RIP: 0010:rt6_get_cookie include/net/ip6_fib.h:264 [inline]
> > RIP: 0010:ip6_dst_store include/net/ip6_route.h:213 [inline]
> > RIP: 0010:tcp_v6_connect+0xfd0/0x20a0 net/ipv6/tcp_ipv6.c:298
> > Code: 89 e6 e8 83 a2 48 fb 45 84 e4 0f 84 90 09 00 00 e8 35 a1 48 fb 49
> > 8d 7e 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02
> > 00 0f 85 57 0e 00 00 4d 8b 66 70 e8 4d 88 35 fb 31 ff 89
> > RSP: 0018:ffff888066547800 EFLAGS: 00010207
> > RAX: dffffc0000000000 RBX: ffff888064e839f0 RCX: ffffc90010e49000
> > RDX: 000000000000002b RSI: ffffffff8628033b RDI: 000000000000015f
> > RBP: ffff888066547980 R08: ffff8880a9412080 R09: ffffed1015d26be0
>
> This one is not so obvious.
>
> The error has to be a bad dst from ip6_dst_lookup_flow called by
> tcp_v6_connect which then is attempted to be stored in the socket via
> ip6_dst_store. ip6_dst_store calls rt6_get_cookie with dst as the
> argument. RDI (first arg for x86) shows 0x15f which is not a valid and
> would cause a fault.
>
> None of the ip6_dst_* functions in net/ipv6/ip6_output.c have changed
> recently (5.2-next definitely but I believe this true for many releases
> prior). Further, all of the FIB lookup functions (called by
> ip6_dst_lookup_flow) always return a non-NULL dst.
>
> If my hunch about the other splat is correct (pcpu corruption) that
> could explain this one: FIB lookup is fine and finds an entry, the entry
> has a pcpu cache entry so it is returned. If the pcpu entry was stomped
> on then it would be invalid and the above would result.


This happened only once so far, so may be a previous silent memory corruption.

This also may be related to "KASAN: user-memory-access Read in
ip6_hold_safe (3)":
https://syzkaller.appspot.com/bug?extid=a5b6e01ec8116d046842
because that one seems to be a race in involved code.
So this one may be a rare incarnation of the other crash.
