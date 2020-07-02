Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E036921253C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgGBNx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:53:29 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40252 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbgGBNx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:53:28 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4A22C20B718A
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 06:53:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4A22C20B718A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1593698008;
        bh=g8+WPH7c9k1YcXVeJ8WB/mMp8kvubdnMYMZcbTzT/W4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oUiQJw8K2hJoUBfH9HAtcXhgXqabUlbp5xvx8/YDGE3wO8ZncafnQ/dulHaOymg/1
         CjXJF8HCUNZLnAQY/8KzHs2lWKhdnfhvqjxuctIF2PBKcxlHfNLb7VQ+sIyXH0RktC
         A9FpTBtmtzW3+Ff7wuFd+vGlSfBcISsG84okiQD0=
Received: by mail-qk1-f182.google.com with SMTP id k18so25647240qke.4
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 06:53:28 -0700 (PDT)
X-Gm-Message-State: AOAM532Fsior5ezFMj2ucDf9tdGhvQ+6ANheIVUUnJTCCvC8JeFXBx8V
        G6DDsnTYbBc0vF9pI7yUFDpscvQomXEtNh0Liyg=
X-Google-Smtp-Source: ABdhPJw0c7OQEmxOFcdGkte1iVXja89szXB/mGR78u0nTZ7O1+un7Yr9/wZteiD8iJgfympC95HlNNDkuk8NllARUhY=
X-Received: by 2002:a37:8905:: with SMTP id l5mr29083987qkd.302.1593698007197;
 Thu, 02 Jul 2020 06:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200701153044.qlzcnh7ve56o2ata@SvensMacBookAir.sven.lan> <20200701.124759.594794808175916495.davem@davemloft.net>
In-Reply-To: <20200701.124759.594794808175916495.davem@davemloft.net>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 2 Jul 2020 15:52:51 +0200
X-Gmail-Original-Message-ID: <CAFnufp0HTx0gguqerkRq2NLjijVXsZFh41b9wVX5jMDmfkvX-g@mail.gmail.com>
Message-ID: <CAFnufp0HTx0gguqerkRq2NLjijVXsZFh41b9wVX5jMDmfkvX-g@mail.gmail.com>
Subject: Re: [PATCH 1/1] mvpp2: xdp ethtool stats
To:     David Miller <davem@davemloft.net>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Sven agreed to add the v2 of this patch to the series it depends on,
please drop this one.
I'm sending a v2 of the series soon.

Thanks,

On Wed, Jul 1, 2020 at 9:48 PM David Miller <davem@davemloft.net> wrote:
>
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> Date: Wed, 1 Jul 2020 17:30:44 +0200
>
> >  static void mvpp2_read_stats(struct mvpp2_port *port)
> >  {
> >       u64 *pstats;
> > +     const struct mvpp2_ethtool_counter *s;
> > +     struct mvpp2_pcpu_stats xdp_stats = {};
> >       int i, q;
>
> Reverse christmas tree ordering here, please.
> > @@ -3166,6 +3271,7 @@
> >              struct xdp_frame **frames, u32 flags)
> >  {
> >       struct mvpp2_port *port = netdev_priv(dev);
> > +     struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
> >       int i, nxmit_byte = 0, nxmit = num_frame;
> >       u32 ret;
> >       u16 txq_id;
>
> Likewise.
>
> > @@ -3258,11 +3374,10 @@
> >       enum dma_data_direction dma_dir;
> >       struct bpf_prog *xdp_prog;
> >       struct xdp_buff xdp;
> > +     struct mvpp2_pcpu_stats ps = {};
> >       int rx_received;
> >       int rx_done = 0;
> >       u32 xdp_ret = 0;
> > -     u32 rcvd_pkts = 0;
> > -     u32 rcvd_bytes = 0;
>
> Likewise.
>


-- 
per aspera ad upstream
