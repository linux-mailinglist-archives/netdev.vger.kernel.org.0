Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0410E601296
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiJQPPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiJQPP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:15:28 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8920F53;
        Mon, 17 Oct 2022 08:15:23 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id w3so7861218qtv.9;
        Mon, 17 Oct 2022 08:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sOV8A8y2OEDCqeDMSFkwrO9Qw07N2EwVNNkiwYHAOws=;
        b=Wf6qHQIgc/9+LqENrlT6LpwlJV036Yx5V3qlBkt1qrdVBHcP1MMVW2O6StajdlMZQW
         A50mwMSWOSx1NQYXC+NMV9eQkTd7tUdDRdqHy6V+q5XS5J+jZDfz4O0ydHAKYjn6WYsw
         YeJrFhvDTxs2HYFW+mewod8wLqXGqFDe/iBpfB7IGVZdziXlGDiqeSmD+2Vdjb7QHp27
         Vw/tchHhWbYaBPmMHMdeyThyA5qGeyiwALiYTH6TqM/aEDLLPNlMM2rs8fmWm6nGxsIB
         o5PpCZVH9QpQmr791tfIUxAWxamZbzHCD0S8JjshzPY+jIJRQAqWU3/vB0cGVV6yuILv
         bZWw==
X-Gm-Message-State: ACrzQf0F0utvt1yfj94rzT5DgHRn1SBF6hrMcXbolVQSz1SQNpYIgBZJ
        br+R68XeQtmy2GVvGeNeetCaA6w1ggJpGg==
X-Google-Smtp-Source: AMsMyM6VFSsgYtmMmQbxCxQRsjp0MsA7ZOL6fPsy3Sx1ThMw1QBVNaJHzuyP+DxXWlvmn41/2CZSTg==
X-Received: by 2002:a05:622a:14c7:b0:39c:ec5e:f05b with SMTP id u7-20020a05622a14c700b0039cec5ef05bmr2964960qtx.166.1666019722186;
        Mon, 17 Oct 2022 08:15:22 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id u3-20020a05620a454300b006a6ebde4799sm12746qkp.90.2022.10.17.08.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 08:15:21 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id f205so2487918yba.2;
        Mon, 17 Oct 2022 08:15:21 -0700 (PDT)
X-Received: by 2002:a25:4fc2:0:b0:6be:afb4:d392 with SMTP id
 d185-20020a254fc2000000b006beafb4d392mr8994270ybb.604.1666019721188; Mon, 17
 Oct 2022 08:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220902215737.981341-1-sean.anderson@seco.com> <20220902215737.981341-6-sean.anderson@seco.com>
In-Reply-To: <20220902215737.981341-6-sean.anderson@seco.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 17 Oct 2022 17:15:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWqTtjuOvDo9qxgDVpm+RBGm7BEgpdqVRH1n_dLGoYLTA@mail.gmail.com>
Message-ID: <CAMuHMdWqTtjuOvDo9qxgDVpm+RBGm7BEgpdqVRH1n_dLGoYLTA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 05/14] net: fman: Map the base address once
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Sat, Sep 3, 2022 at 12:00 AM Sean Anderson <sean.anderson@seco.com> wrote:
> We don't need to remap the base address from the resource twice (once in
> mac_probe() and again in set_fman_mac_params()). We still need the
> resource to get the end address, but we can use a single function call
> to get both at once.
>
> While we're at it, use platform_get_mem_or_io and devm_request_resource
> to map the resource. I think this is the more "correct" way to do things
> here, since we use the pdev resource, instead of creating a new one.
> It's still a bit tricky, since we need to ensure that the resource is a
> child of the fman region when it gets requested.
>
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> Acked-by: Camelia Groza <camelia.groza@nxp.com>

Thanks for your patch, which is now commit 262f2b782e255b79
("net: fman: Map the base address once") in v6.1-rc1.

> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
> @@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
>
>         if (mac_dev)
>                 return sprintf(buf, "%llx",
> -                               (unsigned long long)mac_dev->res->start);
> +                               (unsigned long long)mac_dev->vaddr);

On 32-bit:

    warning: cast from pointer to integer of different size
[-Wpointer-to-int-cast]

Obviously you should cast to "uintptr_t" or "unsigned long" instead,
and change the "%llx" to "%p" or "%lx"...

However, taking a closer look:
  1. The old code exposed a physical address to user space, the new
     code exposes the mapped virtual address.
     Is that change intentional?
  2. Virtual addresses are useless in user space.
     Moreover, addresses printed by "%p" are obfuscated, as this is
     considered a security issue. Likewise for working around this by
     casting to an integer.

What's the real purpose of dpaa_eth_show_addr()?
Perhaps it should be removed?

>         else
>                 return sprintf(buf, "none");
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
