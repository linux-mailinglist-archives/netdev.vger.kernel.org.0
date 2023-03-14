Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA256B881E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 03:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjCNCL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 22:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCNCL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 22:11:57 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB8B856A5;
        Mon, 13 Mar 2023 19:11:55 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y19so8068699pgk.5;
        Mon, 13 Mar 2023 19:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678759914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Kh93D/+te+j0IB0dAgsr8PGEgdCLFuhdg5/LQctP2E=;
        b=mzmcop6Eswi/dah8swmQ/Sf6zoUFx83VLxuiMkGIlE3ctBJRVb91+I7eh8OB3zH96H
         wekJceblT/j6kmDNWMCkGfNMTXJXT+Q2jzC8NZb4Mi/vYCeeae9J2qateruTRwuk6JGd
         WJ7J8MLydSkmZahnlKmNIjnU7M6ECnUKvSoALKL1BTacDb4h0MrQ/FnAIfEOqSLd+nUL
         RSH9QDcKdpF88ngtj86Exbbj+/v3XiDSm8hAEn887t+EvoZ4aYOgJZyOiUuopv+/H5+n
         1e+9epnZYTfojXqzZjEesblPBNGI7lk3+won7tfusHk9GHQkcHx2m0VRuM7U6McCYftc
         ty0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678759914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Kh93D/+te+j0IB0dAgsr8PGEgdCLFuhdg5/LQctP2E=;
        b=8LZUvmOXZW/2dioEa2pEDUUZd9FS5r4g7UIrFg+k9gj4f2QD3VKaGA81ziON8wtVy6
         UYNcGaRj+xAs2Q5doraWe6JDwpAS90fs9S/RfCjCV9ljOpd+KkW1oH3UnZUcpSoexzOh
         tDDM/PoOGQrZu8Ib3bGjLs1UJ4KtWtFLEsEoe0DlHYcF3sODZhPE1M5+6NPzyn7WlvRv
         pBpDkrYpZhCGD+tuCL7xtBvgDJXRsZjlcJ5iLspN7o5HnpKkF14gNCiA+2HGpyefEfiv
         5FV69waIhy5bBwb3RnKUTqSBeUQNhNT9OcgAosWYXrycTSb1zaYfAVsowv6FdbZu/qPf
         jj2g==
X-Gm-Message-State: AO0yUKWt87vUNjdjKaswMQC+CEM3DTcO4kz633pen8In5vgUB7QW6OO5
        fHvAV7nSGdA76l8AufeRM7G/5XWaWvKYhgF5AWgJlFcjIxknO8g3D3EprQ==
X-Google-Smtp-Source: AK7set96Kx9hVT10DY+Y2kshjDDGkEUewcJzEvR8BMO2mJTUPNbWBkz7at0WAAgqh9ptXT3Rh0TPZuEvbaxEyxov+6k=
X-Received: by 2002:a63:7d03:0:b0:503:4a2c:5f0 with SMTP id
 y3-20020a637d03000000b005034a2c05f0mr11936753pgc.9.1678759914543; Mon, 13 Mar
 2023 19:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230310105734.1574078-1-zyytlz.wz@163.com> <20230313170046.287bae8d@kernel.org>
In-Reply-To: <20230313170046.287bae8d@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Tue, 14 Mar 2023 10:11:42 +0800
Message-ID: <CAJedcCzaQZfyNzx0tE40k4sK=wmC3hdQ07cUNXwk8nukMYdw2Q@mail.gmail.com>
Subject: Re: [PATCH net] net: qcom/emac: Fix use after free bug in emac_remove
 due to race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, timur@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
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

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8814=E6=97=
=A5=E5=91=A8=E4=BA=8C 08:00=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, 10 Mar 2023 18:57:34 +0800 Zheng Wang wrote:
> > +     netif_carrier_off(netdev);
> > +     netif_tx_disable(netdev);
> > +     cancel_work_sync(&adpt->work_thread);
> >       unregister_netdev(netdev);
> >       netif_napi_del(&adpt->rx_q.napi);
>
> same problem as in the natsemi driver

Hi Jakub,

Thanks for your reply. Here we schedule the work when handling IRQ
request, So I think we should add free_irq after netif_napi_del and move
the cancel_work_sync after that like:

netif_carrier_off(netdev);
netif_tx_disable(netdev);

unregister_netdev(netdev);
netif_napi_del(&adpt->rx_q.napi);

free_irq(adpt->irq.irq, &adpt->irq);
cancel_work_sync(&adpt->work_thread);

Apprecaite for your advice about the fix.

Best regards,
Zheng
