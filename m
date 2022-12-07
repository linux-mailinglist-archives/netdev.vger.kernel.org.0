Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31976457EF
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLGKen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiLGKel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:34:41 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299AE2C676
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:34:41 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id i186so9963779ybc.9
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 02:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h/yjgGh1+EPjVnMPsFEncTvMsMVBfHWHOEs7px4hu0w=;
        b=asg+uuBFf71kT9UV1EZDJ2cAJKD3+qUITe7bQrY8Ijdepywu7jcPWuE759qH7ABYlU
         9dlPh6p5ENql71k2Qh8hQVK00cMMSRwcO/H0ojP+5a2+Pko0QxdWeCeHyX61xeYAMQ2o
         Otl5+7KZHrkcfyUignumtXA+RFniG/HZhZlpVgjgp0XSJIkWnScZ7wt+vCvD5kdZdzJg
         sW/dyVsvBbf31mvp4+yuvoPdOl/Dj2k9+fSthG/bP8P2BiPrHCADRlmdoartnrqW/FMg
         HamqXI7TqWQqz8c2ft4Q7d3oDVVvWsQtqEe24mKz11BUmi2ixWyTVgNRAV7rGPHMoZ5v
         WZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h/yjgGh1+EPjVnMPsFEncTvMsMVBfHWHOEs7px4hu0w=;
        b=04lL84ybhLdp/Bv/iVvOJV/oJydhODjE3dxUx0ZHYlpIQu2mgDFnvLEka4+X1+vTsI
         FFDLDGSaTZuDEjbx2XIu7JmEu+SbBB8w544i9WwnC3aDUunAkk4iZCjXjOcmdm7LEWHt
         8jMzyxKeP23dOQGTD9JEUjnq7hbWDpLG2Yia+6XqNH5a/PEs8BL66bMts9OVyyAPIvBS
         bW0VD8A7ZweiJRk5zy/eeC9iU4yb3/DVKMHldwgbPSPVZEjHuElutvUCtAOBk//b9vkr
         BlusBqnbv6tgyFr0Ow45jH47pbYwPE8SU37biD+tR9GwOhhRydzwx1vn/KJfda/XkFre
         Bj8Q==
X-Gm-Message-State: ANoB5pk/WYrKnRmv8WCjA0quU4EEb24PgAQtXaI0BUXbCP3FHEndPHIb
        z5Dq8pYwuLJmDH8CytASf2V2g3Gap2OY5yw+ZY66UQ==
X-Google-Smtp-Source: AA0mqf5yTbW9hX/F6kNytdbtCDfGrp9qXlCHpvmwgjgeQY2CYstA7+aWK/5Y+8DzQSnO/ag06OJ1xh4laoLF+hxtixg=
X-Received: by 2002:a25:d4f:0:b0:703:8a9c:fd with SMTP id 76-20020a250d4f000000b007038a9c00fdmr5890859ybn.231.1670409280130;
 Wed, 07 Dec 2022 02:34:40 -0800 (PST)
MIME-Version: 1.0
References: <20221207073215.3545460-1-yangyingliang@huawei.com> <20221207073215.3545460-3-yangyingliang@huawei.com>
In-Reply-To: <20221207073215.3545460-3-yangyingliang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Dec 2022 11:34:29 +0100
Message-ID: <CANn89i+dFBt_iMfEua0zvdin684HrCUR7t2a1qedk-n-mk2V2Q@mail.gmail.com>
Subject: Re: [PATCH net 2/4] net: ethernet: dnet: don't call dev_kfree_skb()
 under spin_lock_irqsave()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 8:35 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. So replace dev_kfree_skb() with
> dev_consume_skb_irq() under spin_lock_irqsave().
>
> Fixes: 4796417417a6 ("dnet: Dave DNET ethernet controller driver (updated)")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/dnet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
> index 08184f20f510..1da10c79fb97 100644
> --- a/drivers/net/ethernet/dnet.c
> +++ b/drivers/net/ethernet/dnet.c
> @@ -551,7 +551,7 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
>         skb_tx_timestamp(skb);
>
>         /* free the buffer */
> -       dev_kfree_skb(skb);
> +       dev_consume_skb_irq(skb);
>
>         spin_unlock_irqrestore(&bp->lock, flags);

What about moving the dev_kfree_skb() after spin_unlock_irqrestore() ?


>
> --
> 2.25.1
>
