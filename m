Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69925FAC6
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfGDPWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:22:37 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36702 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfGDPWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 11:22:37 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so5811664qkl.3
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 08:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jUoFkBbIJTq3PTywmuQzWidznwHNv5fFQzaYhQ/YXIg=;
        b=HR5jRWVAbEufG7yRjbLkYWvmRFpRB7j5Nn3dL6XdfG2Ma8WAJhxkFWDEqEVcuXrnRX
         WawqooQ597OjY+Br72D2zQR57fRsPTfxj9FiYbdnIMWFn15QXixqWuCo9t6AeqMZDyOR
         65QEPKhpFyGVAzGuLiLWEMiIMbsGWJHjYmc6tBnC2bSK1xq6Xv+qvQVEIITNyTpc7k0N
         SnIu+ccE7CWYqbQ3t6pLqbt20B3jlwe30HPK/Cxfeb4NH3cWijqpFVBp92R0DGuITt+A
         pRu3ZpTpiJSQwfQzhJQGWufMzlIV7/iGb8FdPYXuRG5RsBghVGn6Bql8zcH6UdpkxRBM
         Ecdg==
X-Gm-Message-State: APjAAAXsIwL7BtbUCCu+fSIb5BJyhk4t8Ozj0kSalN1+u8ypo8p+I0Sh
        OGyyL3TutnuvsBhzUdcfaCszLRyZfM0+kqjW6VI=
X-Google-Smtp-Source: APXvYqxihHV2Qp0yX8tNqIp+3+O+vw8eRS9rdqNrHkaFaiTutu+hPxY0whDm0ya/ns/xE4npNHngWly3pqeXID3kRxg=
X-Received: by 2002:a37:ad12:: with SMTP id f18mr35257781qkm.3.1562253756243;
 Thu, 04 Jul 2019 08:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <1562251569-16506-1-git-send-email-ilias.apalodimas@linaro.org>
In-Reply-To: <1562251569-16506-1-git-send-email-ilias.apalodimas@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 4 Jul 2019 17:22:19 +0200
Message-ID: <CAK8P3a3katJh+r-SveR0D_tcF2gvXxv_RAAF4cVeEsf==mi6Tg@mail.gmail.com>
Subject: Re: [net-next, PATCH, v2] net: netsec: Sync dma for device on buffer allocation
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 4:46 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 5544a722543f..ada7626bf3a2 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
>
> +       dma_start = page_pool_get_dma_addr(page);
>         /* We allocate the same buffer length for XDP and non-XDP cases.
>          * page_pool API will map the whole page, skip what's needed for
>          * network payloads and/or XDP
>          */
> -       *dma_handle = page_pool_get_dma_addr(page) + NETSEC_RXBUF_HEADROOM;
> +       *dma_handle = dma_start + NETSEC_RXBUF_HEADROOM;
>         /* Make sure the incoming payload fits in the page for XDP and non-XDP
>          * cases and reserve enough space for headroom + skb_shared_info
>          */
>         *desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> +       dma_dir = page_pool_get_dma_dir(dring->page_pool);
> +       dma_sync_single_for_device(priv->dev, dma_start, PAGE_SIZE, dma_dir);

Should this maybe become part of the page_pool_*() interfaces?
Basically in order to map a page from the pool, any driver would have
to go through these exact steps, so you could make it a combined function
call

dma_addr_t page_pool_sync_for_device(dring->page_pool, page);

Or even fold the page_pool_dev_alloc_pages() into it as well and
make that return both the virtual and dma addresses.

     Arnd
