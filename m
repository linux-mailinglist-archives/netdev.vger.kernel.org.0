Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3F9116163
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 11:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfLHKd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 05:33:26 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43356 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfLHKd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 05:33:26 -0500
Received: by mail-oi1-f196.google.com with SMTP id x14so3796033oic.10;
        Sun, 08 Dec 2019 02:33:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m/XMm08gR2sjLP1gEIf1XClkapbPvq6gpn+AbMcpJ+I=;
        b=Um+/KhIzVFAq2vKsJqrvV6jYnzMvw1U5d6TWczosi7KTPjD3cLnwbO7cf6zqVsFyBj
         6aaSsK5Oi99Jx3z1+f7HixOFVUJfB5Wv03tm77I8kQGq2dvpE9zn4KT7W+Ofp0eU6MSA
         swMkpsM+ZF0imXs+bxZYNYCN3uUa3hDrc0GrV18HSGKDGZL4b4tt/x8/ZV7s1JHmfnP6
         8uNn9Ug2Mcurz2v2VX85DGLn4F57vC8f1V4YoBletw86pU3RN/PP4KXb1BPbvHuM5H8Y
         GkNTmTFql42a+PFQwftuJDReOTJGncNnerXtXOMANRXnZK4hOukCdNAn8qkgomHWvw+p
         cxhQ==
X-Gm-Message-State: APjAAAUDAADFuiUgJDVathLWDubGdgZbxFmiNwWUrn++sHFDXjGFaXzX
        p5tvu/4YuBS8FnyB1tzJd7dXVxk6J4gB3iP0LuadWQ==
X-Google-Smtp-Source: APXvYqzR+hkxfTMnBIXwpZthVNtnPoiXTgABDZEwTSOdgQLsq0VFrYM2rl+gRViiuFCnkPpvfsMTLkjNg3VOIvqJH6o=
X-Received: by 2002:aca:4e87:: with SMTP id c129mr19360701oib.153.1575801205174;
 Sun, 08 Dec 2019 02:33:25 -0800 (PST)
MIME-Version: 1.0
References: <20191121183404.6e183d06@canb.auug.org.au> <CAMuHMdX8QyGkpPXfwS0EJhC6hR+gpYfvdpGWqdb=bSwJGmF7Ew@mail.gmail.com>
 <20191207164111.fpnpoipaiadaxyde@salvia>
In-Reply-To: <20191207164111.fpnpoipaiadaxyde@salvia>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 8 Dec 2019 11:33:13 +0100
Message-ID: <CAMuHMdV4_rva3LqTNaGfciFeJZFDhfuOG2z55XwY_+2-0n5PTg@mail.gmail.com>
Subject: Re: nf_flow on big-endian (was: Re: linux-next: build warning after
 merge of the net-next tree)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
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

Hi Pablo,

On Sat, Dec 7, 2019 at 5:41 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 26, 2019 at 12:06:03PM +0100, Geert Uytterhoeven wrote:
> > On Thu, Nov 21, 2019 at 8:36 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > After merging the net-next tree, today's linux-next build (powerpc
> > > allyesconfig) produced this warning:
> > >
> > > net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
> > > net/netfilter/nf_flow_table_offload.c:80:21: warning: unsigned conversion from 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680' to '0' [-Woverflow]
> > >    80 |   mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
> > >       |                     ^~~~~~~~~~~~
> > >
> > > Introduced by commit
> > >
> > >   c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> >
> > This is now upstream, and must be completely broken on big-endian
> > platforms.
> >
> > The other user of the flags field looks buggy, too
> > (net/core/flow_dissector.c:__skb_flow_dissect_tcp()[*]):
> >
> >      key_tcp->flags = (*(__be16 *) &tcp_flag_word(th) & htons(0x0FFF));
> >
> > Disclaimer: I'm not familiar with the code or protocol, so below are just
> > my gut feelings.
> >
> >      struct flow_dissector_key_tcp {
> >             __be16 flags;
> >     };
> >
> > Does this have to be __be16, i.e. does it go over the wire?
> > If not, this should probably be __u16, and set using
> > "be32_to_cpu(flags) >> 16"?
> > If yes, "cpu_to_be16(be32_to_cpu(flags) >> 16)"?
> > (Ugh, needs convenience macros)
> >
> > [*] ac4bb5de27010e41 ("net: flow_dissector: add support for dissection
> > of tcp flags")
>
> I'm attaching a tentative patch, please let me know this is fixing up
> this issue there.

Thanks, this looks good to me, and fixes the build warning.
For this localized change (not for the global interaction), with the nits
below fixed:
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -189,10 +189,17 @@ struct flow_dissector_key_eth_addrs {
>
>  /**
>   * struct flow_dissector_key_tcp:
> - * @flags: flags
> + * @flags: TCP flags (16-bit, including the initial Data offset field bits)

@pad?

> + * @word: Data offset + reserved bits + TCP flags + window

flag_word

>   */
>  struct flow_dissector_key_tcp {
> -     __be16 flags;
> +     union {
> +             struct {
> +                     __be16 flags;
> +                     __be16 __pad;
> +             };
> +             __be32  flag_word;
> +     };
>  };
>
>  /**
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index ca871657a4c4..83af4633f306 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -756,7 +756,7 @@ __skb_flow_dissect_tcp(const struct sk_buff *skb,
>       key_tcp = skb_flow_dissector_target(flow_dissector,
>                                           FLOW_DISSECTOR_KEY_TCP,
>                                           target_container);
> -     key_tcp->flags = (*(__be16 *) &tcp_flag_word(th) & htons(0x0FFF));
> +     key_tcp->flag_word = tcp_flag_word(th);
>  }
>
>  static void
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index c94ebad78c5c..30205d57226d 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -87,8 +87,8 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>
>       switch (tuple->l4proto) {
>       case IPPROTO_TCP:
> -             key->tcp.flags = 0;
> -             mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
> +             key->tcp.flag_word = 0;
> +             mask->tcp.flag_word = TCP_FLAG_RST | TCP_FLAG_FIN;
>               match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
>               break;
>       case IPPROTO_UDP:


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
