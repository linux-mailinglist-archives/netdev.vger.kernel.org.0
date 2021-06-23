Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5258F3B1EAC
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFWQbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:31:05 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46716 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhFWQbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:31:03 -0400
Received: by mail-io1-f70.google.com with SMTP id a24-20020a5d95580000b029044cbcdddd23so2289275ios.13
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 09:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=aP6mT2qrVDZrhD2GlNrwXfQc4RVciPnhRbx1x2YC7LY=;
        b=TTlhyL68YLQQBHOyJldhnI0TZl5LPUbrEH9pjQWaHsR6TDEg48r4y+5N4hRvxMgUmM
         T0gFS4JybAvEF5TlMmiISmNOoZqg8BWT4H8knz0fdOSZ2xtOlcnfn3e/UJ2MesPb7Idm
         ZWizKXcZV/zaQKJAHNOFu02z8Y+ZVd5m5IR7tT9mcOp0ypU/di4pb9TGrHlMZRw9ctIF
         jiH/+r7jG0Y9GqpUferVqpniXIIbbC8XAj4skbCHTjd/EUkx4Wf6+MLCor6ZkdeG8lRf
         +VWlVSBJjCeewfkVLfWDHRdITJHtzkfkchcqQ40Ci/j/og09lv1EkWI8MpIV3tt7Jgz9
         3BUg==
X-Gm-Message-State: AOAM530XJaxaC+BsTSaOw6ZBGdNj4qZRZNMwVV63sUq5HkAoUIsAMz6C
        +qV6tSEoHtqJ2DChFGFTyJRWkakFs5zdmoyZtP/U3wptDI1Y
X-Google-Smtp-Source: ABdhPJyLpcXJHB3MVxVIUy+85q0zE6Yj6eHUyrMEtmeC9c1NUmAjPrMWUpjD2gA0KaLltVYjkpscqbOZZc3Jcgy/3ztGMWNd7oE+
MIME-Version: 1.0
X-Received: by 2002:a92:d781:: with SMTP id d1mr196234iln.162.1624465724721;
 Wed, 23 Jun 2021 09:28:44 -0700 (PDT)
Date:   Wed, 23 Jun 2021 09:28:44 -0700
In-Reply-To: <20210623192837.13792eae@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000078d19c05c5716638@google.com>
Subject: Re: [syzbot] WARNING: zero-size vmalloc in corrupted
From:   syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 23 Jun 2021 19:19:28 +0300
> Pavel Skripkin <paskripkin@gmail.com> wrote:
>
>> On Wed, 23 Jun 2021 02:15:23 -0700
>> syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com> wrote:
>> 
>> > Hello,
>> > 
>> > syzbot found the following issue on:
>> > 
>> > HEAD commit:    13311e74 Linux 5.13-rc7
>> > git tree:       upstream
>> > console output:
>> > https://syzkaller.appspot.com/x/log.txt?x=15d01e58300000 kernel
>> > config:  https://syzkaller.appspot.com/x/.config?x=42ecca11b759d96c
>> > dashboard link:
>> > https://syzkaller.appspot.com/bug?extid=c2f6f09fe907a838effb syz
>> > repro:
>> > https://syzkaller.appspot.com/x/repro.syz?x=14bb89e8300000 C
>> > reproducer:
>> > https://syzkaller.appspot.com/x/repro.c?x=17cc51b8300000
>> > 
>> > The issue was bisected to:
>> > 
>> > commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
>> > Author: Florian Westphal <fw@strlen.de>
>> > Date:   Wed Apr 21 07:51:08 2021 +0000
>> > 
>> >     netfilter: arp_tables: pass table pointer via nf_hook_ops
>> > 
>> > bisection log:
>> > https://syzkaller.appspot.com/x/bisect.txt?x=13b88400300000 final
>> > oops:
>> > https://syzkaller.appspot.com/x/report.txt?x=10788400300000 console
>> > output: https://syzkaller.appspot.com/x/log.txt?x=17b88400300000
>> > 
>> 
>> This one is similar to previous zero-size vmalloc, I guess :)
>> 
>> #syz test
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> master
>> 
>> 
>
> Hah, I didn't notice that this one is already fixed by me. But the
> patch is in the media tree, it's not upstreamed yet:  
>
> https://git.linuxtv.org/media_tree.git/commit/?id=c680ed46e418e9c785d76cf44eb33bfd1e8cf3f6
>
> So, 
>
> #syz dup: WARNING: zero-size vmalloc in dvb_dmx_init

Can't dup bug to a bug in different reporting (upstream->internal).Please dup syzbot bugs only onto syzbot bugs for the same kernel/reporting.

>
> With regards,
> Pavel Skripkin
