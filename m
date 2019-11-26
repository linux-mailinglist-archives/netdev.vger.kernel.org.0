Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9295D109CC3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 12:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfKZLGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 06:06:16 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41697 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfKZLGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 06:06:16 -0500
Received: by mail-ot1-f66.google.com with SMTP id r27so944822otc.8;
        Tue, 26 Nov 2019 03:06:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sDv2IDGJv0mFar0t3+yMbplV7bT/52S6zXtfv3V8JGI=;
        b=rKTSQa/ZFmaONGOW2cPBQUgmf6sjOD5r1OzNGS96qRHsTsUuDNtT34Q9voflpE/3Py
         LZuy/huLNopriEyucAtN+gcwtasCC17bPBlu/r5XRsZ7cbXTXFcGiF4Ix0YNLeGRozBK
         Ikrz569DQQqpH6oQfH9ENPQgzaPjrY5iw5JxU8vGJee2huDmWYp8EzF979tApYk/5xnq
         XN29rKrkDNxSzdzj+Pw+RpI3OQs/wdLv9L9XbICmfd/neIg3i49814YSG0t28JyQUdCG
         wtNAuVQevB1G21Vu5h+V8x8bJnGSIVZKg91y7q2ozkGg+J5OzKLprUMOinAxo9jmli67
         5ATw==
X-Gm-Message-State: APjAAAWEDKz0XaHiTrrJY5iYoTmQA0+5EXAgbt5DPXiVNCtsTiOPCXit
        WhAG9jSkGzn2uGnm1kcXJ20aEX1MJZibmrBxpZQ=
X-Google-Smtp-Source: APXvYqzVwTZwufgkEpLOPkgZBChJ+oyz3T07Gt9Es1AGLSJgdDI2N6gJx2zkS7FsJn1inn0vK0U1K9OsI9cugtJsiTQ=
X-Received: by 2002:a05:6830:2363:: with SMTP id r3mr1979742oth.39.1574766374983;
 Tue, 26 Nov 2019 03:06:14 -0800 (PST)
MIME-Version: 1.0
References: <20191121183404.6e183d06@canb.auug.org.au>
In-Reply-To: <20191121183404.6e183d06@canb.auug.org.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 26 Nov 2019 12:06:03 +0100
Message-ID: <CAMuHMdX8QyGkpPXfwS0EJhC6hR+gpYfvdpGWqdb=bSwJGmF7Ew@mail.gmail.com>
Subject: nf_flow on big-endian (was: Re: linux-next: build warning after merge
 of the net-next tree)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 8:36 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the net-next tree, today's linux-next build (powerpc
> allyesconfig) produced this warning:
>
> net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
> net/netfilter/nf_flow_table_offload.c:80:21: warning: unsigned conversion from 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680' to '0' [-Woverflow]
>    80 |   mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
>       |                     ^~~~~~~~~~~~
>
> Introduced by commit
>
>   c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")

This is now upstream, and must be completely broken on big-endian
platforms.

The other user of the flags field looks buggy, too
(net/core/flow_dissector.c:__skb_flow_dissect_tcp()[*]):

     key_tcp->flags = (*(__be16 *) &tcp_flag_word(th) & htons(0x0FFF));

Disclaimer: I'm not familiar with the code or protocol, so below are just
my gut feelings.

     struct flow_dissector_key_tcp {
            __be16 flags;
    };

Does this have to be __be16, i.e. does it go over the wire?
If not, this should probably be __u16, and set using
"be32_to_cpu(flags) >> 16"?
If yes, "cpu_to_be16(be32_to_cpu(flags) >> 16)"?
(Ugh, needs convenience macros)

[*] ac4bb5de27010e41 ("net: flow_dissector: add support for dissection
of tcp flags")

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
