Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5857548170
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 10:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiFMISy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 04:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiFMISx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 04:18:53 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAF21A06D
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:18:52 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-fe15832ce5so7470226fac.8
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OC2DU6JdEPvoz6eXUQ44J7ul5VX2ic5VQdRWOpkdajs=;
        b=exoZO2UHbPIo4rwEe5Blni4d5wjbSy6laQrZbmamFNhrWdTc8JwUrhvmmfVYhY9kwh
         jfVn6Dt4fHMfFgtU/THVFurget2BbwNcE7+rOhct7HfSmA/hc9hqPLw6kUc+vBtmmWvm
         491EonOgPphOmMDrG/bVqWQjzJm33Nfxw54Yx7dOIyBNvO7V+PsHL2ddGI9peyp4cd/d
         pBe9y21NczE44RK21RNZ+0viIdJIIblq/kRb/Z5biKHAimDQKx/2C77YQKsCJrnZd1au
         ZA/jgnOCGlfCw8oq3CF9K79jPLVs8iRrP/8l2Bh4FjE7FjQBFqQXMF+SO4zP0DlpdblF
         sucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OC2DU6JdEPvoz6eXUQ44J7ul5VX2ic5VQdRWOpkdajs=;
        b=jGggirT9TWZwq+eb0Vr7avmyrJboE0elnVtF6mzHh3JuyAtLQ+0dFV1JrgfUR5P2XX
         fDTpS5yjgfvWt0b0n/pQk/r5WWAyY6rxh/Z0XTeo+M6/TxX9MuS2YbfI7PwRNhgl9wcK
         SskkMNZagMT9EGTf0WJoPJtqvzoL6GlEGWJ6mh/syUDUSCqa2Z7Y1Y/11AapBE138IjN
         BL3SVv6tUoaix6rTZm9ZHVep4ynl3oIpbTz60ZnCjryiLM0otztIQPzTmQzSBwlqLl8p
         Bccy2ll/pLU8ts8zOaUIacQxlkeHbr3PkKpIAuysIKHW5eC5u2j0UOlMEX5JGr6F6pnl
         d5zA==
X-Gm-Message-State: AOAM533lAQm8VN25S0RQOSeEzW7qV5hObTtC8FHlm4XtcVV8J57GJOn/
        kinM2fl4pIEhHl6dznqihddNEgJqvaqRkD1Mzau8LxeYRF+lgsdM
X-Google-Smtp-Source: ABdhPJzPhcam0SCm2wZHJcFKSGJzRGYoKfqkkgd6ASd6D6NlGPYSuEMqHvxTf35mI8z1URjlaXeYrxNrN6HAhc98LuU=
X-Received: by 2002:a05:6870:3116:b0:fe:1586:5922 with SMTP id
 v22-20020a056870311600b000fe15865922mr6735200oaa.285.1655108331600; Mon, 13
 Jun 2022 01:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220613034202.3777248-1-andy.chiu@sifive.com> <20220613034202.3777248-3-andy.chiu@sifive.com>
In-Reply-To: <20220613034202.3777248-3-andy.chiu@sifive.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 13 Jun 2022 16:18:40 +0800
Message-ID: <CABgGipX=ssZg_AmsGuxrqUiJ4MW+fAuKs-zHhXuFmcgBs82nvA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: axienet: Use iowrite64 to write all 64b
 descriptor pointers
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, Max Hsu <max.hsu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Greentime Hu <greentime.hu@sifive.com>

On Mon, Jun 13, 2022 at 11:45 AM Andy Chiu <andy.chiu@sifive.com> wrote:
>
> According to commit f735c40ed93c ("net: axienet: Autodetect 64-bit DMA
> capability") and AXI-DMA spec (pg021), on 64-bit capable dma, only
> writing MSB part of tail descriptor pointer causes DMA engine to start
> fetching descriptors. However, we found that it is true only if dma is in
> idle state. In other words, dma would use a tailp even if it only has LSB
> updated, when the dma is running.
>
> The non-atomicity of this behavior could be problematic if enough
> delay were introduced in between the 2 writes. For example, if an
> interrupt comes right after the LSB write and the cpu spends long
> enough time in the handler for the dma to get back into idle state by
> completing descriptors, then the seconcd write to MSB would treat dma
> to start fetching descriptors again. Since the descriptor next to the
> one pointed by current tail pointer is not filled by the kernel yet,
> fetching a null descriptor here causes a dma internal error and halt
> the dma engine down.
>
> We suggest that the dma engine should start process a 64-bit MMIO write
> to the descriptor pointer only if ONE 32-bit part of it is written on all
> states. Or we should restrict the use of 64-bit addressable dma on 32-bit
> platforms, since those devices have no instruction to guarantee the write
> to LSB and MSB part of tail pointer occurs atomically to the dma.
>
> initial condition:
> curp =  x-3;
> tailp = x-2;
> LSB = x;
> MSB = 0;
>
> cpu:                       |dma:
>  iowrite32(LSB, tailp)     |  completes #(x-3) desc, curp = x-3
>  ...                       |  tailp updated
>  => irq                    |  completes #(x-2) desc, curp = x-2
>     ...                    |  completes #(x-1) desc, curp = x-1
>     ...                    |  ...
>     ...                    |  completes #x desc, curp = tailp = x
>  <= irqreturn              |  reaches tailp == curp = x, idle
>  iowrite32(MSB, tailp + 4) |  ...
>                            |  tailp updated, starts fetching...
>                            |  fetches #(x + 1) desc, sees cntrl = 0
>                            |  post Tx error, halt
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reported-by: Max Hsu <max.hsu@sifive.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h | 21 +++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index 6c95676ba172..97ddc0273b8a 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -564,13 +564,28 @@ static inline void axienet_dma_out32(struct axienet_local *lp,
>  }
>
>  #ifdef CONFIG_64BIT
> +/**
> + * axienet_dma_out64 - Memory mapped Axi DMA register write.
> + * @lp:                Pointer to axienet local structure
> + * @reg:       Address offset from the base address of the Axi DMA core
> + * @value:     Value to be written into the Axi DMA register
> + *
> + * This function writes the desired value into the corresponding Axi DMA
> + * register.
> + */
> +static inline void axienet_dma_out64(struct axienet_local *lp,
> +                                    off_t reg, u64 value)
> +{
> +       iowrite64(value, lp->dma_regs + reg);
> +}
> +
>  static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
>                                  dma_addr_t addr)
>  {
> -       axienet_dma_out32(lp, reg, lower_32_bits(addr));
> -
>         if (lp->features & XAE_FEATURE_DMA_64BIT)
> -               axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
> +               axienet_dma_out64(lp, reg, addr);
> +       else
> +               axienet_dma_out32(lp, reg, lower_32_bits(addr));
>  }
>
>  #else /* CONFIG_64BIT */
> --
> 2.36.0
>
