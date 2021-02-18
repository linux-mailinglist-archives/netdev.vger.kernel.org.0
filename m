Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC3031F05C
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhBRTqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:46:44 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:60974 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232083AbhBRTZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613676274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5egwyHcz3LKmFM3GfGugcfQko18t/R/0TBSPSzrjTW4=;
        b=TLsojzCFKBDbw9jb17qtrbiLE+JqDlrljbigOf3c7x8c328yJTbmrsFnWrvPOVrThceJXi
        sKWCulfh76aYaDzFbp5GdYL0Fo7HHRFnQ8Bpgf4LHJPKLEXgGZMMhcEjjd6XDciLJQvR+u
        drs6CkreeKt7M5cV3BcD15GR7yzMyvw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 544811a5 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 18 Feb 2021 19:24:34 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id n195so3221423ybg.9
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 11:24:34 -0800 (PST)
X-Gm-Message-State: AOAM533Vz6BfDyN4CeCAWNZNXnbYcv2jddu25TTeesZ+VWbx/2eeXLxq
        m0aoKbFPXEdhrK7gfSJq3WvzU69eD4jXe0CzwVo=
X-Google-Smtp-Source: ABdhPJz9Cxo3REZQwacDEkPzdbzh1QeBpkJtQRnIpW2e4hPE9m3Fue1fudMPr2AJEo2GwyxuRnXGe230TddGSjUNFqA=
X-Received: by 2002:a25:8712:: with SMTP id a18mr8724018ybl.306.1613676274153;
 Thu, 18 Feb 2021 11:24:34 -0800 (PST)
MIME-Version: 1.0
References: <20210218123053.2239986-1-Jason@zx2c4.com> <20210218110820.18f29ee5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210218110820.18f29ee5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 18 Feb 2021 20:24:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9pW8_BcuuB2OAfVn1Au=cn1=nxo7M5ZpqphACO4JVk6vw@mail.gmail.com>
Message-ID: <CAHmME9pW8_BcuuB2OAfVn1Au=cn1=nxo7M5ZpqphACO4JVk6vw@mail.gmail.com>
Subject: Re: [PATCH net] net: icmp: zero-out cb in icmp{,v6}_ndo_send before sending
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>, SinYu <liuxyon@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 8:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 18 Feb 2021 13:30:53 +0100 Jason A. Donenfeld wrote:
> > The icmp{,v6}_send functions make all sorts of use of skb->cb, assuming
> > the skb to have come directly from the inet layer. But when the packet
> > comes from the ndo layer, especially when forwarded, there's no telling
> > what might be in skb->cb at that point. So, icmp{,v6}_ndo_send must zero
> > out its skb->cb before passing the packet off to icmp{,v6}_send.
> > Otherwise the icmp sending code risks reading bogus memory contents,
> > which can result in nasty stack overflows such as this one reported by a
> > user:
> >
> >     panic+0x108/0x2ea
> >     __stack_chk_fail+0x14/0x20
> >     __icmp_send+0x5bd/0x5c0
> >     icmp_ndo_send+0x148/0x160
> >
> > This is easy to simulate by doing a `memset(skb->cb, 0x41,
> > sizeof(skb->cb));` before calling icmp{,v6}_ndo_send, and it's only by
> > good fortune and the rarity of icmp sending from that context that we've
> > avoided reports like this until now. For example, in KASAN:
> >
> >     BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0xa0e/0x12b0
> >     Write of size 38 at addr ffff888006f1f80e by task ping/89
> >     CPU: 2 PID: 89 Comm: ping Not tainted 5.10.0-rc7-debug+ #5
> >     Call Trace:
> >      dump_stack+0x9a/0xcc
> >      print_address_description.constprop.0+0x1a/0x160
> >      __kasan_report.cold+0x20/0x38
> >      kasan_report+0x32/0x40
> >      check_memory_region+0x145/0x1a0
> >      memcpy+0x39/0x60
> >      __ip_options_echo+0xa0e/0x12b0
> >      __icmp_send+0x744/0x1700
> >
> > Actually, out of the 4 drivers that do this, only gtp zeroed the cb for
> > the v4 case, while the rest did not. So this commit actually removes the
> > gtp-specific zeroing, while putting the code where it belongs in the
> > shared infrastructure of icmp{,v6}_ndo_send.
> >
> > Fixes: a2b78e9b2cac ("sunvnet: generate ICMP PTMUD messages for smaller port MTUs")
>
> nit: please make sure you CC the authors of the commits you're blaming.

Will do. Though in this case, it's behavior that's a few places, so I
put the git commit of the earliest case, to aid with backporting.

(This email is a reply to v1, but please check out v2.)

Jason
