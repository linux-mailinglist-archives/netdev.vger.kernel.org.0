Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D1A22F674
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgG0RUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:20:21 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:22045 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgG0RUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:20:21 -0400
Received: (qmail 85210 invoked by uid 89); 27 Jul 2020 17:20:19 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 27 Jul 2020 17:20:19 -0000
Date:   Mon, 27 Jul 2020 10:20:14 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 13/21] net/tcp: Pad TCP options out to a fixed
 size for netgpu
Message-ID: <20200727172014.ynvc5vty5bbg7wsp@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-14-jonathan.lemon@gmail.com>
 <CANn89i+nXhXzxC3C+UY0xAMFeUxZSSD8R5MP2mmttjZa+5-Hxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+nXhXzxC3C+UY0xAMFeUxZSSD8R5MP2mmttjZa+5-Hxg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 08:19:24AM -0700, Eric Dumazet wrote:
> On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
> <jonathan.lemon@gmail.com> wrote:
> >
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > The "header splitting" feature used by netgpu doesn't actually parse
> > the incoming packet header.  Instead, it splits the packet at a fixed
> > offset.  In order for this to work, the sender needs to send packets
> > with a fixed header size.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> >  net/ipv4/tcp_output.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index d8f16f6a9b02..e8a74d0f7ad2 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -438,6 +438,7 @@ struct tcp_out_options {
> >         u8 ws;                  /* window scale, 0 to disable */
> >         u8 num_sack_blocks;     /* number of SACK blocks to include */
> >         u8 hash_size;           /* bytes in hash_location */
> > +       u8 pad_size;            /* additional nops for padding */
> >         __u8 *hash_location;    /* temporary pointer, overloaded */
> >         __u32 tsval, tsecr;     /* need to include OPTION_TS */
> >         struct tcp_fastopen_cookie *fastopen_cookie;    /* Fast open cookie */
> > @@ -562,6 +563,17 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
> >         smc_options_write(ptr, &options);
> >
> >         mptcp_options_write(ptr, opts);
> > +
> > +#if IS_ENABLED(CONFIG_NETGPU)
> > +       /* pad out options */
> > +       if (opts->pad_size) {
> > +               int len = opts->pad_size;
> > +               u8 *p = (u8 *)ptr;
> > +
> > +               while (len--)
> > +                       *p++ = TCPOPT_NOP;
> > +       }
> > +#endif
> >  }
> >
> >  static void smc_set_option(const struct tcp_sock *tp,
> > @@ -826,6 +838,14 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
> >                         opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
> >         }
> >
> > +#if IS_ENABLED(CONFIG_NETGPU)
> > +       /* force padding */
> > +       if (size < 20) {
> > +               opts->pad_size = 20 - size;
> > +               size += opts->pad_size;
> > +       }
> > +#endif
> > +
> 
> This is obviously wrong, as any kernel compiled with CONFIG_NETGPU
> will fail all packetdrill tests suite.
> 
> Also the fixed 20 value is not pretty.

Would changing this into a sysctl be a suitable solution?  It really is
a temporary solution to handle hardware that doesn't support splitting,
and adding a sysctl seems so permanent.....  
-- 
Jonathan

