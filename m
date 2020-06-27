Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB8520C085
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 11:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgF0JvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 05:51:06 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:35045 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgF0JvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 05:51:06 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 88344ce5
        for <netdev@vger.kernel.org>;
        Sat, 27 Jun 2020 09:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=iodm5UKAwuxsN5o9+q5XZMyNmO0=; b=xcwnIm
        QP6vC4Zjqt9c6L2IxZdxZg9Z4hfT3ScxG7Qg0+Q/ZIMqZo9e0lj06v8YYUXJOAUQ
        rhIf56vLcLDVxsw6djkdfBSmFEiJHSPpRGUm0GBwuubI7ZIUYdmuhN4Onm0ev7Nk
        /t1Sz5Vzz3Bvf51F0A3h2MXnXB8Yd9v/mGXQ79L863kLGd0hOX9HogG0xOx4vuPs
        dRfOetCar8HmSqnYUjXjfVuP3GN/NwCc1gyjmf7aawrJtvSuPgr0dN+PuUII5CJv
        tdXHhzGh2/dfQ15CFlemBKgzG0OQBaqkWUEJPKXyYCX5X3syvbsxLpgRZftDArKx
        ArDmC0as6XgRtlYA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 57d8a46b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 27 Jun 2020 09:31:41 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id a11so2257999ilk.0
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 02:51:04 -0700 (PDT)
X-Gm-Message-State: AOAM531IYUGfI3J8itACFjPjccOLCINBSoe0kbOu5sFzP8Fyti1+tW1i
        woyv69vkZ8OfQuN3Aud3wBms8n6XpbFGclEsWPo=
X-Google-Smtp-Source: ABdhPJxueSk+svbzmYoYDONtUkByzd2M7ARKTZlhnhj93OhChiMIBsQoWe7mIbTgJ7fEaN5pq4KFnRitFiseHlmwY3Y=
X-Received: by 2002:a92:91c2:: with SMTP id e63mr6662683ill.64.1593251463502;
 Sat, 27 Jun 2020 02:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200623095945.1402468-1-Jason@zx2c4.com> <20200623095945.1402468-3-Jason@zx2c4.com>
 <CAHmME9qo6u1rmzgP0HEf2mVj+o4eWpjR+9j709NVhJuMAsb4uQ@mail.gmail.com> <CACT4Y+adKydDGcoz3xBb45g_J04kKtQpGRua3k_BvOF=mB4EdQ@mail.gmail.com>
In-Reply-To: <CACT4Y+adKydDGcoz3xBb45g_J04kKtQpGRua3k_BvOF=mB4EdQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 27 Jun 2020 03:50:52 -0600
X-Gmail-Original-Message-ID: <CAHmME9rrpr97mXLoEgk9YvZCfEUeodhCGbbWV1t2+giDBasiKQ@mail.gmail.com>
Message-ID: <CAHmME9rrpr97mXLoEgk9YvZCfEUeodhCGbbWV1t2+giDBasiKQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] wireguard: device: avoid circular netns references
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

On Sat, Jun 27, 2020 at 2:59 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> Hard to say. syzkaller frequently needs some time (days) to get
> reasonable coverage of new code.
> Is wg_netns_pre_exit executed synchronously in the context of a
> syscall? If not, then it won't be shown as covered. If yes, then what
> syscall is it?

Aw, shucks, you're right. I thought that this would be from the
syscall path for deleting a network namespace via netns_put, but
sticking a dump_stack() in there, it's clear that namespace cleanup
actually happens in a worker:

[    0.407072]  wg_netns_pre_exit+0xc/0x98
[    0.408496]  cleanup_net+0x1bd/0x2f0
[    0.409844]  process_one_work+0x17f/0x2d0
[    0.411327]  worker_thread+0x4b/0x3b0
[    0.412697]  ? rescuer_thread+0x360/0x360
[    0.414169]  kthread+0x116/0x140
[    0.415368]  ? __kthread_create_worker+0x110/0x110
[    0.417125]  ret_from_fork+0x1f/0x30

> This is related to namespaces, right? syzkaller has some descriptions
> for namespaces:
> https://github.com/google/syzkaller/blob/master/sys/linux/namespaces.txt
> But I don't know if it's enough nor I checked if they actually work.
> We have this laundry list:
> https://github.com/google/syzkaller/issues/533
> and some interns working on adding more descriptions. If you can
> identify something that's not covered but can be covered, please add
> to that list. I think we can even prioritize it then b/c most items on
> that list don't have anybody actively interested.

Something to add to that list would be:

- Create an interface of a given type (wg0->wireguard, for example)
- Move it to a namespace
- Delete a namespace
- Delete an interface

Some combination of those things might provoke issues. One would be
what the original post of this email thread was about. Another would
be that xfrmi OOPS from a few weeks ago, fixed with c95c5f58b35e
("xfrm interface: fix oops when deleting a x-netns interface"), which
has a reproducer in the commit message pretty similar to the one here.
There's an even older one in xfrmi, fixed with c5d1030f2300 ("xfrm
interface: fix list corruption for x-netns").

In short, adding and deleting namespaces and moving interfaces around
between them, amidst other syzkaller chaos, might turn up bugs,
because in the past humans have found those sorts of bugs doing the
same.

Jason
