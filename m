Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124D83D167F
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbhGUR6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhGUR6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 13:58:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57E6561222;
        Wed, 21 Jul 2021 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626892736;
        bh=c58AgXYLjV8nxV+yGDWGaiNc8lcnebnlE03OtQCUX8g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TXMnY/wOnELdxVY2UtnXI7v3JQ4uQNXB+95A3X/Ux1IpvCYoC+cOYlFW3kuVf4zxL
         jOnCVH8WpF06Fw22zy1ijEG0BH6X7zrY1VXHBJDTJ7PPPU70RjlsIIN6wPnePqsEkT
         dw6Y4/uW3a9A9aevLRFAyIeet0td3xhNCPBYjKcfSWaJ8QRfkLC6HPjcKTjQA6mBF6
         H8CTepg+QFouXY97lVzm2urACHyzbkMwuLctp5Iboyce4Tp7gZ/u//Yl+I+Wey8a19
         wudZz6BEjYQMJ5XkLfGgiACqpRodC7evSlKPclcqbBhh0YfBI1sDp4WNuq42HlzUQP
         Bi0ZA6loAxRxg==
Received: by mail-wm1-f52.google.com with SMTP id r16-20020a05600c2c50b029014c1adff1edso76550wmg.4;
        Wed, 21 Jul 2021 11:38:56 -0700 (PDT)
X-Gm-Message-State: AOAM533/H+Vl1K79Oflk7ZsVpxnbkE3oWMzIqvZ6u9j2kSeGqe/+uGtF
        yeGc8qkh8NCTcuHe/qBAZ470/Y3QZJ0TGeE2SV4=
X-Google-Smtp-Source: ABdhPJyhSRgfLaBTPJMwtpFNlY9q/GPNEb6Tfyk+uF/aS8k580kiJJMP0SB0r+iW16M91ZGiiwEn6z8lhMS6dEb2QmA=
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr5472491wmb.142.1626892734959;
 Wed, 21 Jul 2021 11:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210721151100.2042139-1-arnd@kernel.org> <CANH7hM7nLq9LthNi=D9qHsiS_eyhU8-CGjnXhsKYX9dqTaOmNw@mail.gmail.com>
In-Reply-To: <CANH7hM7nLq9LthNi=D9qHsiS_eyhU8-CGjnXhsKYX9dqTaOmNw@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 21 Jul 2021 20:38:38 +0200
X-Gmail-Original-Message-ID: <CAK8P3a27ii4fPvB8QA149g6ofWHazPGb9EZL_7M4z5ymkepVnw@mail.gmail.com>
Message-ID: <CAK8P3a27ii4fPvB8QA149g6ofWHazPGb9EZL_7M4z5ymkepVnw@mail.gmail.com>
Subject: Re: [PATCH] gve: DQO: avoid unused variable warnings
To:     Bailey Forrest <bcf@google.com>
Cc:     Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_unmap_len_set(pending_packet->bufs[pending_packet->num_bufs], len, len);
On Wed, Jul 21, 2021 at 5:36 PM Bailey Forrest <bcf@google.com> wrote:
> On Wed, Jul 21, 2021 at 8:11 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> >
> > +static void gve_unmap_packet(struct device *dev,
> > +                            struct gve_tx_pending_packet_dqo *pending_packet)
> > +{
> > +       dma_addr_t addr;
> > +       size_t len;
> > +       int i;
> > +
> > +       /* SKB linear portion is guaranteed to be mapped */
> > +       addr = dma_unmap_addr(&pending_packet->bufs[0], dma);
> > +       len = dma_unmap_len(&pending_packet->bufs[0], len);
> > +       dma_unmap_single(dev, addr, len, DMA_TO_DEVICE);
>
> "SKB linear portion is guaranteed to be mapped" is only true if
> gve_tx_add_skb_no_copy_dqo completed successfully.
>
> This optimization is important for the success path because otherwise
> there would be a per-packet branch misprediction, which I found to
> have a large performance impact.
>
> A solution which should address this would be something like:
>
> +static void gve_unmap_packet(struct device *dev,
> +     struct gve_tx_pending_packet_dqo *pending_packet
> +     bool always_unmap_first)
> +{
> + dma_addr_t addr;
> + size_t len;
> + int i;
> +
> + if (always_unmap_first || pending_packet->num_bufs > 0) {
> +  addr = dma_unmap_addr(&pending_packet->bufs[0], dma);
> +  len = dma_unmap_len(&pending_packet->bufs[0], len);
> +  dma_unmap_single(dev, addr, len, DMA_TO_DEVICE);
> + }
> +
> + for (i = 1; i < pending_packet->num_bufs; i++) {
> +  addr = dma_unmap_addr(&pending_packet->bufs[i], dma);
> +  len = dma_unmap_len(&pending_packet->bufs[i], len);
> +  dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
> + }
> + pending_packet->num_bufs = 0;
> +}
>
> (Sorry my email client keeps turning tabs into spaces...)
>
> By doing this, we can rely on the compiler to optimize away the extra
> branch in cases we know the first buffer will be mapped.

I didn't really change it here, I just moved the function up and changed
the dma_unmap_addr/dma_unmap_len calls to avoid the warning.

> > +static inline void gve_tx_dma_buf_set(struct gve_tx_dma_buf *buf,
> > +                                     dma_addr_t addr, size_t len)
> > +{
> > +       dma_unmap_len_set(buf, len, len);
> > +       dma_unmap_addr_set(buf, dma, addr);
> > +}
>
> checkpatch.pl will complain about `inline` in a C file.
>
> However, I would prefer to just not introduce this helper because it
> introduces indirection for the reader and the risk of passing the
> arguments in the wrong order. Don't have a strong opinion here
> though.

Sure, feel free to just treat my patch as a bug report and send a different
fix if you prefer to not have an inline function. This is usually the easiest
way to get around the macro ignoring its arguments since the compiler
does not warn for unused function arguments.

Open-codiung the call as

dma_unmap_len_set(pending_packet->bufs[pending_packet->num_bufs], len, len);
dma_unmap_len_addr(pending_packet->bufs[pending_packet->num_bufs], addr, dma);

works as well, I just found the inline function more readable.

     Arnd
