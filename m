Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD6014F37F
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgAaU5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:57:43 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43284 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgAaU5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:57:43 -0500
Received: by mail-lf1-f66.google.com with SMTP id 9so5797812lfq.10
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 12:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yIy8jX/bIqNLPn135lJfh03fB0J5DTm/sQQubpuwpIc=;
        b=T9YJkCW9JbP3I/VrV8Kj+Sqgh32TFui6J89dvvzFWNF4uNBBlwLYLIiloGbloeGdEn
         +WhsCFna2qbBsj24mHwTYrLs7jNN597VW/cYfZ14T/ucXOrbAuhgBHDPx8ZibV3JpYUn
         SIOsaSvx7SY3ycO1LVDx3/u1kmOYO3RuQI1m4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yIy8jX/bIqNLPn135lJfh03fB0J5DTm/sQQubpuwpIc=;
        b=ePTtePClNFiyXngSBdfT5JNHVBrzJ8MWNNGQYgm1wjiPtxgWYdNJQGrse2pCRfgYN/
         fFlqrHYzAvlPtwGzc/t8tNgQe65G9NGD1r1/9QAL3YKC6Mg6/+wo1rCfj++DVL+YRzXl
         lAyNehLVahvNR2KnTRw8JdH5XCqWY2CBtuI5GxovQ/X5fKioogFtOF3iaq2ewrpneeTP
         FAUSOCFun63R402GS7Vg9w0/ZYWOdb8IvnNEJFx3aw3D6aJH++6NYmYysCNYvfn7Ivrl
         CGYi0u6Eil5YNUnqFTErVJqNf0xCV4VqYnYokWwe17J4p7gN6B5HLjmpebyJz+Ww2FPe
         7egg==
X-Gm-Message-State: APjAAAWhQpeFltkKeNkltxEp6al3GVrF2IVJWfiIYJ9A1j0g3vGGh6QW
        n++B0OBDj9An0jIU3pWi+k+PvEmGWOU=
X-Google-Smtp-Source: APXvYqz1KZWCDFzH5gz9eLFp/KFww6xRIlkAC0r+l4ClFXkQfB6z9uOjuxr1Cf67ARAENuXdudcbKQ==
X-Received: by 2002:ac2:5e9b:: with SMTP id b27mr6629397lfq.184.1580504260757;
        Fri, 31 Jan 2020 12:57:40 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id k1sm5195543lji.43.2020.01.31.12.57.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 12:57:39 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id w1so8516557ljh.5
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 12:57:39 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr7089308ljk.201.1580504259100;
 Fri, 31 Jan 2020 12:57:39 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dd68d0059c74a1db@google.com> <000000000000ed3a48059d17277e@google.com>
In-Reply-To: <000000000000ed3a48059d17277e@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 31 Jan 2020 12:57:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgNo-3FuNWSj+pRqJEG3phVnpcEi+NNq7f_VMWeTugFDA@mail.gmail.com>
Message-ID: <CAHk-=wgNo-3FuNWSj+pRqJEG3phVnpcEi+NNq7f_VMWeTugFDA@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_add
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Marco Elver <elver@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        jeremy@azazel.net, Kate Stewart <kstewart@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 8:01 PM syzbot
<syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:

Ok, the bisection is obviously bogus - it just points to where the
KASAN support was added to _notice_ the problem.

But is somebody looking at the actual KASAN report itself?

  https://syzkaller.appspot.com/bug?extid=f3e96783d74ee8ea9aa3

It does look like nfnetlink_rcv_msg() ends up looking at a bit:

 bitmap_ip_do_add net/netfilter/ipset/ip_set_bitmap_ip.c:83 [inline]
 bitmap_ip_add+0xef/0xe60 net/netfilter/ipset/ip_set_bitmap_gen.h:136
 bitmap_ip_uadt+0x73e/0xa10 net/netfilter/ipset/ip_set_bitmap_ip.c:186
 call_ad+0x1a0/0x5a0 net/netfilter/ipset/ip_set_core.c:1716
 ip_set_ad.isra.0+0x572/0xb20 net/netfilter/ipset/ip_set_core.c:1804
 ip_set_uadd+0x37/0x50 net/netfilter/ipset/ip_set_core.c:1829
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229

that is past the allocation:

 ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x6ec/0xc20 net/netfilter/ipset/ip_set_bitmap_ip.c:327
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229

Maybe this has already been fixed, but I'm just trying to follow-up on
the syzbot report..

           Linus
