Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E0171710
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 13:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfGWL3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 07:29:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42065 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbfGWL3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 07:29:40 -0400
Received: by mail-qt1-f195.google.com with SMTP id h18so41496291qtm.9;
        Tue, 23 Jul 2019 04:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KXa/pdiz35ep+mLCr28bqiNqSRHbUGvdnUMCdkRJY1Y=;
        b=cUyin+8NmP6Kz7ItookwxAVzJLEtQIAgc2TAZ6DfyUGnHm9QQKwwrEFQTHwgAM9MNl
         buGfYjyB8QYShPYlJBW4Xn9h2EL/3y0o6PpKiBFPc8LuutzTaOTBq9vwe9CB4ZGUkR3O
         TLEZJvVFKVRMqSyLC+bzQw5eNUb390atQ/6Bg+ldwGE8Oww9YV/8oAoebbgQFeFifh9X
         UyvHMYnRy8jmYoljcp2b2oJaeZCDF6gVpRxAE8r5JnoX1fnRuatMecYoAOlPO6wabHH0
         siT5vEvgho9+EhtYUprlf9NA860JhSL0sIfwBdttDWsXfHkAs4R+Wov6n/vfORBKbbe1
         3NLg==
X-Gm-Message-State: APjAAAWjAl6kzYMiSu//FhjSAj4vyLiMRPZ3CaphbgQWIL0g+XCLkJPV
        XcDBR4Q/IX6vrZBFM9o9vSCwj8qpPMTDzaMzyeg=
X-Google-Smtp-Source: APXvYqx1EU51FbX6+2XlA6KUG+F0dUz/vT1YeDqdoz4SzLZTi5S2qTafHd5AE2c3/8DfMvsxeTXs4OM5qOYjY9x4kYQ=
X-Received: by 2002:a0c:ba2c:: with SMTP id w44mr53689627qvf.62.1563881379713;
 Tue, 23 Jul 2019 04:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190708125554.3863901-1-arnd@arndb.de> <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
 <535ebf16-c523-0799-3ffe-6cfbeee3ac57@mellanox.com>
In-Reply-To: <535ebf16-c523-0799-3ffe-6cfbeee3ac57@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 23 Jul 2019 13:29:23 +0200
Message-ID: <CAK8P3a2z=h02_1ybRzL1DpW26-Qn-v22=Fdf_Z_C02fYg9OFgQ@mail.gmail.com>
Subject: Re: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate mlx5e_channel_param
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 1:21 PM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> On 2019-07-08 18:16, Maxim Mikityanskiy wrote:
> > On 2019-07-08 15:55, Arnd Bergmann wrote:
> >> -    mlx5e_build_xsk_cparam(priv, params, xsk, &cparam);
> >> +    cparam = kzalloc(sizeof(*cparam), GFP_KERNEL);
> >
> > Similar code in mlx5e_open_channels (en_main.c) uses kvzalloc. Although
> > the struct is currently smaller than a page anyway, and there should be
> > no difference in behavior now, I suggest using the same alloc function
> > to keep code uniform.
> >
> >>      /* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
> >>       * triggered and NAPI to be called on the correct CPU.
> >>       */
> >> -    err = mlx5e_open_icosq(c, params, &cparam.icosq, &c->xskicosq);
> >> +    err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
> >>      if (unlikely(err))
> >>              goto err_close_icocq;
> >>
> >
> > Here is kfree missing. It's a memory leak in the good path.
>
> Arnd, I'm going to take over your patch and respin it, addressing my own
> comments, because it's been quite a while, and we want to have this fix.
>
> Thanks for spotting it.

Thanks for taking care of it now. I was planning to do a respin, but
the reply got lost in the depth of my inbox so I forgot about it.

      Arnd
