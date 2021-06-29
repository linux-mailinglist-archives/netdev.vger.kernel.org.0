Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBCC3B76E9
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhF2RLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhF2RLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 13:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 236F361CA2;
        Tue, 29 Jun 2021 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624986533;
        bh=+dC51rWNo1wDeYPoalM+gQQN7q0mu0SuHEZ2RWtnHzQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ry8PL6pWVxargf19eA97YHT5jTEszXOlOtOKrDK7Ekb7k2Krgiow14jZs1v3Rl4rn
         Ri55Nzn7c7ucumSSi6ZLqgaLTTOP7ZvTJrkZxt+CyQcxG+kFnLuoS+sg3m9qbraeA8
         9qeS6s928pyUDUReY5WziZ1QhvjZbojOLRSVyl+0FjIniRfRsoQ3KWMFgh4Vab5Dyg
         f49tJlS/HqGYTwnWJPeEWVsgYfOQ0cjs/N9vNGO8c4/UzZVuC/cI5Ac1DUa9fCT6XR
         8S5K5+XqI4IrPWxp4w95ReKoiFflr/nJ0UVH5zh8+XG4/O6na92z7H0y0/gv2QJ26U
         SyZAuVpaR7Svg==
Date:   Tue, 29 Jun 2021 10:08:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to
 skb_shared_info
Message-ID: <20210629100852.56d995a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YNsVyBw5i4hAHRN8@lore-desk>
References: <cover.1623674025.git.lorenzo@kernel.org>
        <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
        <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
        <YNsVyBw5i4hAHRN8@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Jun 2021 14:44:56 +0200 Lorenzo Bianconi wrote:
> > On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:  
> > >
> > > data_len field will be used for paged frame len for xdp_buff/xdp_frame.
> > > This is a preliminary patch to properly support xdp-multibuff
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  include/linux/skbuff.h | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index dbf820a50a39..332ec56c200d 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -522,7 +522,10 @@ struct skb_shared_info {
> > >         struct sk_buff  *frag_list;
> > >         struct skb_shared_hwtstamps hwtstamps;
> > >         unsigned int    gso_type;
> > > -       u32             tskey;
> > > +       union {
> > > +               u32     tskey;
> > > +               u32     data_len;
> > > +       };
> > >  
> > 
> > Rather than use the tskey field why not repurpose the gso_size field?
> > I would think in the XDP paths that the gso fields would be unused
> > since LRO and HW_GRO would be incompatible with XDP anyway.
> 
> ack, I agree. I will fix it in v10.

Why is XDP mb incompatible with LRO? I thought that was one of the use
cases (mentioned by Willem IIRC).
