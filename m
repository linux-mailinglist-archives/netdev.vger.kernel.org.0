Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823F9352091
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 22:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbhDAU0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 16:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234488AbhDAU0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 16:26:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4041610D1;
        Thu,  1 Apr 2021 20:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617308781;
        bh=+ADI3ZWqoI7tOnyvHGFLAJJYfYQrIAvsENPdPT3ibUM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fxhQ941Aq8w/9gL79MSLCqHYh3gupCPuO2f+oBsdQl+xmSpbXfZ4A05jkNRtAK4qw
         ByuhmCdcMAE9W89ZJubzR9ev35JNyqyFgEuh31U9BJDje9M4YGASayEQG2JlDj9GSz
         rtdXtJIafQb1Seqp9DTyPZ6y6CEPL34hQ+cJ0oC1eF1zViQWxjVTp4PbUOHggcEgxQ
         F6RgMMZVC+/BUsHU/sX2NRXRWIGYeZuemQb3Uhzx4/9yCye79Mew5Lf3r2PShWa52s
         18Kj6BPsL4uMt9TRDfld2t4XoIUUxxWle38JugSBM25oGcPYVqZjWMFIkYBULnB6rk
         ZNieSaSZYMy6g==
Received: by mail-lf1-f46.google.com with SMTP id w28so4674392lfn.2;
        Thu, 01 Apr 2021 13:26:20 -0700 (PDT)
X-Gm-Message-State: AOAM531NR9mvpy03DNRMpT6JOLJTXYLitjpK0Xt6JLr1i4+AKqarlWjt
        LFFtemD3c9Qy5bABzC1CmqJ17EjcmghZr6hcjZI=
X-Google-Smtp-Source: ABdhPJyMqaw9UhOoZtv1rXpK7K76xh6ObasOVb2EUurAdUxBt83Y3DG3a9lZvmDTB2PMIn1UrAAqB79NDsg2CmSLWxQ=
X-Received: by 2002:ac2:5614:: with SMTP id v20mr6767163lfd.372.1617308779149;
 Thu, 01 Apr 2021 13:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <e01b1a562c523f64049fa45da6c031b0749ca412.1617267115.git.lorenzo@kernel.org>
 <CAPhsuW4QTOgC+fDYRZnVwWtt3NTS9D+56mpP04Kh3tHrkD7G1A@mail.gmail.com> <YGX5j7RDQIXlh69L@lore-desk>
In-Reply-To: <YGX5j7RDQIXlh69L@lore-desk>
From:   Song Liu <song@kernel.org>
Date:   Thu, 1 Apr 2021 13:26:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7ih9ULA=aq0G7Ka+15KfSWgyuLXD_BxTUcRhn8++UNoQ@mail.gmail.com>
Message-ID: <CAPhsuW7ih9ULA=aq0G7Ka+15KfSWgyuLXD_BxTUcRhn8++UNoQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] cpumap: bulk skb using netif_receive_skb_list
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 9:49 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Thu, Apr 1, 2021 at 1:57 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
>
> [...]
>
> > > -                       /* Inject into network stack */
> > > -                       ret = netif_receive_skb_core(skb);
> > > -                       if (ret == NET_RX_DROP)
> > > -                               drops++;
> >
> > I guess we stop tracking "drops" with this patch?
> >
> > Thanks,
> > Song
>
> Hi Song,
>
> we do not report the packets dropped by the stack but we still count the drops
> in the cpumap. If you think they are really important I guess we can change
> return value of netif_receive_skb_list returning the dropped packets or
> similar. What do you think?

I think we shouldn't silently change the behavior of the tracepoint below:

trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);

Returning dropped packets from netif_receive_skb_list() sounds good to me.

Thanks,
Song
