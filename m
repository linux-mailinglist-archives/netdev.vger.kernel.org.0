Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753616FDCC
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 12:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfGVK3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 06:29:17 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37606 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfGVK3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 06:29:17 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so28154034qkl.4;
        Mon, 22 Jul 2019 03:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0NOGeJyfbedSFMqRuTXzJhGJqhWVTfys7Td6+TiU9cU=;
        b=K9uw9O5KERcJQL7dKmdtVhuZ5e+o96+Y/S4EABKI+CBZOfQIqgBp7xWcl0Lj/Oib/W
         GcmWRhPF+Q5Uomtr95zpT9Od9UfXi12fSG6l+AA1209kNZezzO1B1a0pGYCS7L2UovzD
         Sa+A7OZuDvzIUtpaNvTWwKHovS71pZPj6y/wEHH46rJFUOgRu8n8nbuGVltJTnFvXZ21
         KpQ/nPHxsVm10rW1/YqqcuF9nrfqc6EZ6IkyYO1Gk+wkrn+owzEgP7BzzAX9cqeeCkvt
         TUxjhyUJCFAanXYukj6jXuPfCsAhCUN9+6F5LoMniozVZ/G5yye0liv6G8PSULg4CEZI
         wBMQ==
X-Gm-Message-State: APjAAAX0t54w8cC5J7EMC/rHgrbjZdQbjAhN+HcwsR1w3Rl5UrwyGul0
        Puj6Xtk7LnOySnh29PnpKdcdCZH4evj/AyQbwz4=
X-Google-Smtp-Source: APXvYqzk3DuGvaGAEaTy+ImxITuZDO3qbOIA7saZZgJD0ZGnPw+qsE85yHCiUF55BTu2T15XmHYund5FGCRBFNzC2pc=
X-Received: by 2002:a37:4ac3:: with SMTP id x186mr44393855qka.138.1563791355964;
 Mon, 22 Jul 2019 03:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190628123819.2785504-1-arnd@arndb.de> <20190628123819.2785504-4-arnd@arndb.de>
 <CA+FuTSexLuu8e1XHaY0ObGi46CgZnBpELecBr+kMgCU29Fa_gw@mail.gmail.com>
In-Reply-To: <CA+FuTSexLuu8e1XHaY0ObGi46CgZnBpELecBr+kMgCU29Fa_gw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 22 Jul 2019 12:28:59 +0200
Message-ID: <CAK8P3a0xPDmNDbxRkN6ssobFLu1-JLvMG3MSai844hinj2Bs8A@mail.gmail.com>
Subject: Re: [PATCH 4/4] ipvs: reduce kernel stack usage
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Network Development <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 9:59 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> On Fri, Jun 28, 2019 at 8:40 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > With the new CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL option, the stack
> > usage in the ipvs debug output grows because each instance of
> > IP_VS_DBG_BUF() now has its own buffer of 160 bytes that add up
> > rather than reusing the stack slots:
> >
> > net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_sched_persist':
> > net/netfilter/ipvs/ip_vs_core.c:427:1: error: the frame size of 1052 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_new_conn_out':
> > net/netfilter/ipvs/ip_vs_core.c:1231:1: error: the frame size of 1048 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_out':
> > net/netfilter/ipvs/ip_vs_ftp.c:397:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_in':
> > net/netfilter/ipvs/ip_vs_ftp.c:555:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> >
> > Since printk() already has a way to print IPv4/IPv6 addresses using
> > the %pIS format string, use that instead,
>
> since these are sockaddr_in and sockaddr_in6, should that have the 'n'
> specifier to denote network byteorder?

I double-checked the implementation, and don't see that make any difference,
as 'n' is the default.

> >  include/net/ip_vs.h             | 71 +++++++++++++++++++--------------
> >  net/netfilter/ipvs/ip_vs_core.c | 44 ++++++++++----------
> >  net/netfilter/ipvs/ip_vs_ftp.c  | 20 +++++-----
> >  3 files changed, 72 insertions(+), 63 deletions(-)
> >
> > diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> > index 3759167f91f5..3dfbeef67be6 100644
> > --- a/include/net/ip_vs.h
> > +++ b/include/net/ip_vs.h
> > @@ -227,6 +227,16 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
> >                        sizeof(ip_vs_dbg_buf), addr,                     \
> >                        &ip_vs_dbg_idx)
> >
> > +#define IP_VS_DBG_SOCKADDR4(fam, addr, port)                           \
> > +       (struct sockaddr*)&(struct sockaddr_in)                         \
> > +       { .sin_family = (fam), .sin_addr = (addr)->in, .sin_port = (port) }
>
> might as well set .sin_family = AF_INET here and AF_INET6 below?

That would work just same, but I don't see any advantage. As the family
and port members are the same between sockaddr_in and sockaddr_in6,
the compiler can decide to set these regardless to the argument values
regardless of the condition.

       Arnd
