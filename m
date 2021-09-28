Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1009041B1D3
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241181AbhI1ORE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241003AbhI1ORD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 10:17:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31062611CB
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632838524;
        bh=qNq0VvqQuRt5Li60uxhHCk6C3L40jBhgdnyLPJx19RA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dNPuZVX8i67GY1b1K0CAdOppyouYuXT0Q48GeDT30Zmd7p2ocJr5RF/fJouarcLaX
         eaxEZJGJAyzx+RVhCG+4b4Qnp7ui0snfA2ajulR5fDdYqbf1TGDRaUmLDe2MJbcV6S
         tdJL9Lfwjq4IGftQOGG98le2Vi6dfen0LAMawNRNeCsgRgAuM7cWmbxQcazh5g8eHX
         oz0NLPqYmnN9DgPSim120kU+EkP134Pmqo/jNahQDP0QzhR8v3XgNMEbumO1TLv5A2
         SqvSrS6RLqxiMBc2SX1hr6Fh5JTUVR/+3XGC8bMKYvXwLfPhtJ/ZEQUMBSNMD0w7+2
         9nuYjH74L/K4w==
Received: by mail-wr1-f49.google.com with SMTP id d6so58174849wrc.11
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:15:24 -0700 (PDT)
X-Gm-Message-State: AOAM531gW/QjZ1Pku22mCf1MzdFBsVcqXQ2I/EiD7E6D+gvAcpE7Fs7k
        GNlsfrDIXUUC/VXJHYVHA+dT24Y9Ub1bcZdMO9s=
X-Google-Smtp-Source: ABdhPJxXsOYMlADjmX7Gdtb1t5F38a8c96q02lTNAZUDa/e4CRFtL3sV6LtdCEpbYSHNNJjZmuUYGxagIf8BkzkH/MU=
X-Received: by 2002:adf:f481:: with SMTP id l1mr223770wro.411.1632838522728;
 Tue, 28 Sep 2021 07:15:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210723231957.1113800-1-bcf@google.com> <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
 <CANH7hM7_brYnVu_x7=+vY34SGQNbc7GUGQmAqpYwXGgVP0RH6Q@mail.gmail.com>
 <20210927162128.4686b57d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANH7hM4Y2gt9PW_1oZbMQfvT6Bih9U-Ckt7d-w4fKkLp2R-rKA@mail.gmail.com>
In-Reply-To: <CANH7hM4Y2gt9PW_1oZbMQfvT6Bih9U-Ckt7d-w4fKkLp2R-rKA@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 28 Sep 2021 16:15:06 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1P9ZGBCub2s62OjrUa1Hwk66zHHESEj06MPY8qwjK7Ag@mail.gmail.com>
Message-ID: <CAK8P3a1P9ZGBCub2s62OjrUa1Hwk66zHHESEj06MPY8qwjK7Ag@mail.gmail.com>
Subject: Re: [PATCH net] gve: DQO: Suppress unused var warnings
To:     Bailey Forrest <bcf@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 2:00 AM Bailey Forrest <bcf@google.com> wrote:
> On Mon, Sep 27, 2021 at 4:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 27 Sep 2021 13:21:30 -0700 Bailey Forrest wrote:
> >
> > Looks like fixing this on the wrong end, dma_unmap_len_set()
> > and friends should always evaluate their arguments.
>
> That makes sense.
>
> Arnd, if you want to fix this inside of the dma_* macros, the
> following diff resolves the errors reported for this driver:

> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index dca2b1355bb1..f51eee0f678e 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -590,10 +590,21 @@ static inline int dma_mmap_wc(struct device *dev,
>  #else
>  #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
>  #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
> -#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
> -#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
> -#define dma_unmap_len(PTR, LEN_NAME)             (0)
> -#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
> +
> +#define dma_unmap_addr(PTR, ADDR_NAME) ({ (void)PTR; 0; })
> +
> +#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL) do { \

Unfortunately, this breaks every other driver using these macros, as the
point of them is that the unmap-address is not actually defined
and not taking up space in data structure. Referencing it by name
is a compile-time bug.

I've come up with a new patch to gve that just removes the
"struct gve_tx_dma_buf" and open-codes the access everywhere,
sending that as v2 now. Feel free to take that and modify as needed
before sending on, or doing yet another patch.

        Arnd
