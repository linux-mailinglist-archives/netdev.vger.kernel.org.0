Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994F744AFB4
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbhKIOrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhKIOrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 09:47:18 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FD1C061767
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 06:44:32 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 13so18823874ljj.11
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 06:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=380uvh5+sUqb8TraF7vmPFyBkLi6WjO5zrWJDuYOuW8=;
        b=hx92lP6a6ki8mts7VTpqY8I/zBlOUm6b89CcYV+vGebMWqbTW7oG/3nzH+Z2sevs+M
         hi/bH6j00gm2iIfY2gT6dj51crE7Md+HZZzW/yJQ89NUPvQyyZe6PZMEJrV2a9ckVSTl
         SxdU4qgUitmcs2ioGzF8pwPt1c5L4Nrnk8sz+97/YbZxaazGf5xX7Q6VOJnJpXKLi2/i
         umQRnvt34xvkchkuavC1qrgIf36NGAi46ZPoRjR0ylOZIc/M5S32woBiS36tcaHnk+t4
         qY2QG6S5a8w2xtlcp1AcGdYy+WmcR97EFQOYH65XMBNm08PFCYAjUszr25JQzjtgMmPz
         wfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=380uvh5+sUqb8TraF7vmPFyBkLi6WjO5zrWJDuYOuW8=;
        b=z6t2HpdP+FZXRIIKQ6csaO1ZhqZRHxfz97iIGMJmcjV2TEQqI6d9bNDbP6FCFBI9/C
         n/vjy1AiG10+MCEOkoXgmcDXOrQ+f3zFZGdF6UyCfQX6lr3wCVHuGpWIekOBjE5zaEXB
         In2ReiTu8D2nhbf+RXKTZq3WklL06FU6E+4KHrSHjx/eqTruso6LByLCB/SHLznUhQDg
         RTaoGbJN+pPxWiZn6vdILsgBs/9gelmXtIGqGqCPUGJSDiLSxHCOC/l+68/oFQ9WU+jb
         +iWVqbFOkWt/DoYe3wdLPY5ojZT0N2Mp+MceehoQFY8u6EISiku7eGFeo3UlEYN+bFGh
         WwyA==
X-Gm-Message-State: AOAM533XI62MBeqrenVPGe4ZOGAfDeBTT5V4XU5sRR3otNsSN1M1kEke
        4ZPPd2jN5wVLYh699dMuwuLD3bhtIULQcB5DKzKN/Q==
X-Google-Smtp-Source: ABdhPJwa5+ZdRbBDkHA1aLBKxJ03FggnzVQhStS9KMhKJ1ZXqodBkZbmYEH21Hl0dNGUdqQH46VK7gKlqzglelSw/b0=
X-Received: by 2002:a2e:b88b:: with SMTP id r11mr7984204ljp.474.1636469070153;
 Tue, 09 Nov 2021 06:44:30 -0800 (PST)
MIME-Version: 1.0
References: <20211109103101.92382-1-louis.amas@eho.link>
In-Reply-To: <20211109103101.92382-1-louis.amas@eho.link>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 9 Nov 2021 15:44:18 +0100
Message-ID: <CAPv3WKeHN3c_C4Y+QrAR9=BnQ_+tdhyKKAk=-o_DpyQ_6KyzAQ@mail.gmail.com>
Subject: Re: [PATCH] net: mvpp2: fix XDP rx queues registering
To:     Louis Amas <louis.amas@eho.link>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


wt., 9 lis 2021 o 11:31 Louis Amas <louis.amas@eho.link> napisa=C5=82(a):
>
> The registration of XDP queue information is incorrect because the RX que=
ue id we use is invalid.
> When port->id =3D=3D 0 it appears to works as expected yet it's no longer=
 the case when port->id !=3D 0.
>
> This is due to the fact that the value we use (rxq->id) is not the per-po=
rt queue index which
> XDP expects -- it's a global index which should not be used in this case.=
 Instead we shall use
> rxq->logic_rxq which is the correct, per-port value.
>
> Signed-off-by: Louis Amas <louis.amas@eho.link>
> Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
> ---
>
> As we were trying to capture packets using XDP on our mv8040-powered
> MacchiatoBin, we experienced an issue related to rx queue numbering.
>
> Before I get to the problem itself, a bit of setup:
>
> * the Macchiato has several ports, all of them handled using the mvpp2
>   ethernet driver. We are able to reproduce our issue on any device whose
>   port->id !=3D 0 (we used eth2 for our tests). When port->id =3D=3D 0 (f=
or
>   example on eth0) everything works as expected ;
>
> * we use xdp-tutorial for our tests ; more specifically, we used the
>   advanced03-AF_XDP tutorial as it provides a simple testbed. We modified
>   the kernel to simplify it:
>
>         SEC("xdp_sock")
>         int xdp_sock_prog(struct xdp_md *ctx)
>         {
>                 int index =3D ctx->rx_queue_index;
>
>                 /* A set entry here means that the correspnding queue_id
>                  * has an active AF_XDP socket bound to it. */
>                 if (bpf_map_lookup_elem(&xsks_map, &index))
>                         return bpf_redirect_map(&xsks_map, index, 0);
>
>                 return XDP_PASS;
>         }
>
> * we tested kernel 5.10 (out target) and 5.15 (for reference) ; both kern=
els
>   exhibits the same symptoms ; I expect kernel 5.9 (the first linux kerne=
l
>   with XDP support in the mvpp2 driver) to exhibit the same problem.
>
> The normal invocation of this program would be:
>
>         ./af_xdp_user -d ETHDEV
>
> We should then capture packets on this interface. When ETHDEV is eth0
> (port->id =3D=3D 0) everything works as expcted ; when using ETHDEV =3D=
=3D eth2
> we fail to capture anything.
>
> We investigated the issue and found that XDP rx queues (setup as
> struct xdp_rxq_info by the mvpp2 driver) for this device were wrong. XDP
> expected them to be numbered in [0..3] but we found numbers in [32..35].
>
> The reason for this lies in mvpp2_main.c at lines 2962 and 2966 which are
> of the form (symbolic notation, close to actual code, function
> mvpp2_rxq_init()):
>
>         err =3D xdp_rxq_info_reg(&rxq->some_xdp_rxqinfo, port->dev, rxq->=
id, 0);
>
> The rxq->id value we pass to this function is incorrect - it's a virtual =
queue
> id which is computed as (symbolic notation, not actual code):
>
>         rxq->id =3D port->id * max_rxq_count + queue_id
>
> In our case, max_rxq_count =3D=3D 32 and port->id =3D=3D 1 for eth2, mean=
ing our
> rxq->id are in the range [32..35] (for 4 queues).
>
> We tried to force the rx queue id on the XDP side by using:
>
>         ./af_xdp_user -d eth2 -Q 32
>
> But that failed -- as expected, because we should not have more than 4
> rx queues.
>
> The computing of rxq->id is valid, but the use of rxq->id in this context=
 is
> not. What we really want here is the rx queue id for this port, and this =
value
> is stored in rxq->logic_rxq -- as hinted by the code in mvpp2_rxq_init().
> Replacing rxq->id by this value in the two xdp_rxq_info_reg() calls fixed=
 the
> issue and allowed us to use XDP on all the Macchiato ethernet ports.
>
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 587def69a6f7..f0ea377341c6 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -2959,11 +2959,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port=
,
>         mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
>
>         if (priv->percpu_pools) {
> -               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, =
rxq->id, 0);
> +               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, =
rxq->logic_rxq, 0);
>                 if (err < 0)
>                         goto err_free_dma;
>
> -               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, r=
xq->id, 0);
> +               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, r=
xq->logic_rxq, 0);
>                 if (err < 0)
>                         goto err_unregister_rxq_short;
>

Thank you for the patch and the detailed explanation. I think "Fixes:"
tag should be added to the commit message:
Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")

Other than that - LGTM, so you can add my:
Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Best regards,
Marcin
