Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6276B1C39
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjCIHZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCIHZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:25:48 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24E45C13A;
        Wed,  8 Mar 2023 23:25:47 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id y19so505407pgk.5;
        Wed, 08 Mar 2023 23:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678346747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPQMej7KLmYsLHqJdkvoOENmhsOZSLZwLrCj7NjeNPQ=;
        b=Gm3KltXYMqXM9PpoXaSbH0syDlzDq9Va5QE0Jt8nZyq53bviDuO2Imgk+NQkGsi/aF
         W768jlFmRoxiDK2daAo0Oee1jdgV/vso+GbqI4yEdN7BxpC61mdhE+UQO+H7a2nek66f
         09jIz2eMzsLMTn3DEUAk9iF5AbxnBUc3MhpfuXt3tiGOG5HYjw2LY2PkMGUEm3iFTOvn
         3zq+udoAVWeGRuPNKDwVe3JfL6BAa8X2yWZETiqKxYcgjWyJcUYTukYqnxCpzVhzd2TZ
         uqWGZbjD2BLtOlc10OoowZPg8RW0wY6Tu8G0HwGaUIUC0NlM3TOKZGAjcP0AY4jRjh0v
         +z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678346747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPQMej7KLmYsLHqJdkvoOENmhsOZSLZwLrCj7NjeNPQ=;
        b=e+PB/9XyFgqXe7m/GdEJgPYvvOY3qg31WqFGla/dWM4BPh2p93IGNFY1iIuyG7ktFa
         HAb9QMJYYGqU5j+6laI2BeHbYMrQ0NuITD+C+L0Mke7vL4G8Oq4ScDp8vYtxVa1oHLSL
         qaBS9VE9iuumWkxsVustFbBDSvgliVbSGtJvySyCfJBEb9YHhJXAif+/muQfpnAc6ogS
         BZM8uHcm9n7E/gQVgH1QadgpYJJIkKuTcD1wXpse1vVniJHLbMzoYTgePIW9gKJxK0Wh
         FgF0ivYBcDuY4NiYdj1dCZJLBf6qV1Nza91Y+0ft75jWJBqKvvHQX6SyghlaRShHviRF
         CshA==
X-Gm-Message-State: AO0yUKUhCMycm5RCGuxkKGy44ABfO6HZddquIjEVuTjmggKwHSuzmSd5
        hMoT2DYO7Hs1SsQMwuJlY8OkT+fpIHkejaszIdE=
X-Google-Smtp-Source: AK7set+i8KrnF9mVLoLp7v2nGxm54qHjaPZn01vom8u8xIv/ykq5uYOfW331kcdc6khbmA4ahyw+Sb5RyLfaeCnwkKg=
X-Received: by 2002:a62:d41a:0:b0:5a8:e197:736f with SMTP id
 a26-20020a62d41a000000b005a8e197736fmr8811750pfh.0.1678346747330; Wed, 08 Mar
 2023 23:25:47 -0800 (PST)
MIME-Version: 1.0
References: <20230309035641.3439953-1-zyytlz.wz@163.com> <ec579c96-9955-f317-b37a-4f3fcd0c206e@huawei.com>
In-Reply-To: <ec579c96-9955-f317-b37a-4f3fcd0c206e@huawei.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 9 Mar 2023 15:25:33 +0800
Message-ID: <CAJedcCw=XmZzP+wBQRmVrtM-ns9Gs0uvxGowTn-QfQ4QJ0Upyw@mail.gmail.com>
Subject: Re: [PATCH] net: calxeda: fix race condition in xgmac_remove due to
 unfinshed work
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        1395428693sheep@gmail.com, alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yunsheng Lin <linyunsheng@huawei.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=889=E6=
=97=A5=E5=91=A8=E5=9B=9B 14:24=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2023/3/9 11:56, Zheng Wang wrote:
> > In xgmac_probe, the priv->tx_timeout_work is bound with
> > xgmac_tx_timeout_work. In xgmac_remove, if there is an
> > unfinished work, there might be a race condition that
> > priv->base was written byte after iounmap it.
> >
> > Fix it by finishing the work before cleanup.
>
> This should go to net branch, so title should be:
>
>  [PATCH net] net: calxeda: fix race condition in xgmac_remove due to unfi=
nshed work
>

Sorry for the confusion.

> From history commit, it seems more common to use "net: calxedaxgmac" inst=
ead of
> "net: calxeda", I am not sure which one is better.
>
> Also there should be a Fixes tag for net branch, maybe:
>
> Fixes: 8746f671ef04 ("net: calxedaxgmac: fix race between xgmac_tx_comple=
te and xgmac_tx_err")
>
>

Yes, I was eager to report the fix and ignored that. Thanks for
pointing that out.

> >
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> >  drivers/net/ethernet/calxeda/xgmac.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/etherne=
t/calxeda/xgmac.c
> > index f4f87dfa9687..94c3804001e3 100644
> > --- a/drivers/net/ethernet/calxeda/xgmac.c
> > +++ b/drivers/net/ethernet/calxeda/xgmac.c
> > @@ -1831,6 +1831,7 @@ static int xgmac_remove(struct platform_device *p=
dev)
> >       /* Free the IRQ lines */
> >       free_irq(ndev->irq, ndev);
> >       free_irq(priv->pmt_irq, ndev);
> > +     cancel_work_sync(&priv->tx_timeout_work);
>
> It seems the blow function need to stop the dev_watchdog() from
> calling dev->netdev_ops->ndo_tx_timeout before calling
> cancel_work_sync(&priv->tx_timeout_work), otherwise the
> dev_watchdog() may trigger the priv->tx_timeout_work to run again.
>
>         netif_carrier_off(ndev);
>         netif_tx_disable(ndev);
>
> >
> >       unregister_netdev(ndev);
> >       netif_napi_del(&priv->napi);
> >

Yes, I agree with that. Thanks for your advice. I learned a lot from it.

Best regards,
Zheng
