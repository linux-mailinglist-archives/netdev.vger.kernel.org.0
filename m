Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505216E0BCE
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjDMKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjDMKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:50:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C6093CC;
        Thu, 13 Apr 2023 03:50:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-247061537b3so252630a91.2;
        Thu, 13 Apr 2023 03:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681382999; x=1683974999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X02MYUaFwimMjhI3apxNwR61yvrcflc3YgqiYkmDYMY=;
        b=gzpuMv4XWbeGqag2o9I3b8XwZR6q6uiht+M0KURE8YyilULHk1u+7sPgQQWgfzC0d7
         I+KoyYNgVek6fmwvNZnuxucfEdIXJhtisMt+HRMgDjRQowJR5/0QLKFNiZE0Y8sZTdq7
         0QJbB9Pxzd6JE1ZK9OZAcbFrpXGgKnEF09zw215Yo2CpJOFkAYZ3zePORq433Stcwh1Z
         QCpIIATRQB7+DKPfXv2UPQQ1UB60CuBlYeLlvMvqTHrx3WOeUEH2sxdX1S6HxPtfzM/y
         rxdIrX77sFQRZGLydLyshNSDprudMPH0L/5yk5ZtZBBj0gzKjHUWG/x5xBLYlDDbY8Is
         7pxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681382999; x=1683974999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X02MYUaFwimMjhI3apxNwR61yvrcflc3YgqiYkmDYMY=;
        b=Yg47MoqvD9KoPc55sZKYEkbET80fd92YYYQPFaUGat+Zvf91ZjiIp+DexJg7K8fDAA
         N2uk+0YPltOszE3R1GtXvc4t7FHqrNNPAsicfZDw4d372tSsigg9hFr89S2Dqz3zsxh5
         LqgG2EMvulOZmoZ0fpfSYxGXzgsTCUR62/dgy8qMAT+77WaaFU1aSP+b4SPGnB2MjRSN
         a4esgiiWN1JsDtU8s14GbBWjiiLWOsdZkF7N0Ug84UBN1Ls3FSvQ89UVOW+s6YrnZznK
         f7X8XlL5IdhRg2LJXtZL8MXbhkhjJslWgQVsD0Zzojdz9zw2hubvKREFHgS/ETTooN1X
         t0jg==
X-Gm-Message-State: AAQBX9d2y/la9o3QhqpSSK9gTZaMlI93KmN6+X9FSiQNOq1reayfY8tG
        hsjK9w2Jiesx1GPbmEkwLCajKuLG/HokGAuQO9Q=
X-Google-Smtp-Source: AKy350Z14yxxe1R43wdcaGoC8BP5OM0ECwBkwAwfPLFYP5UDniJmvFjgXl2Ur6dtRiqqVp47SFJx+t5fQx3YhluHAPw=
X-Received: by 2002:a05:6a00:1409:b0:625:a545:3292 with SMTP id
 l9-20020a056a00140900b00625a5453292mr1082354pfu.0.1681382999741; Thu, 13 Apr
 2023 03:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230413071401.210599-1-zyytlz.wz@163.com> <20230413100128.bcnqvdpu6hgilws4@soft-dev3-1>
In-Reply-To: <20230413100128.bcnqvdpu6hgilws4@soft-dev3-1>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 13 Apr 2023 18:49:48 +0800
Message-ID: <CAJedcCyLXuqMEWt6f+_HFEzAdgEcq5oQc-hRtt0k=rd_vrz6ew@mail.gmail.com>
Subject: Re: [PATCH net v2] net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
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

Horatiu Vultur <horatiu.vultur@microchip.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=
=8813=E6=97=A5=E5=91=A8=E5=9B=9B 18:01=E5=86=99=E9=81=93=EF=BC=9A
>
> The 04/13/2023 15:14, Zheng Wang wrote:
>
> Hi Zheng,
>
> >
> > In ns83820_init_one, dev->tq_refill was bound with queue_refill.
> >
> > If irq happens, it will call ns83820_irq->ns83820_do_isr.
> > Then it invokes tasklet_schedule(&dev->rx_tasklet) to start
> > rx_action function. And rx_action will call ns83820_rx_kick
> > and finally start queue_refill function.
> >
> > If we remove the driver without finishing the work, there
> > may be a race condition between ndev, which may cause UAF
> > bug.
> >
> > CPU0                  CPU1
> >
> >                      |queue_refill
> > ns83820_remove_one   |
> > free_netdev                      |
> > put_device                       |
> > free ndev                        |
> >                      |rx_refill
> >                      |//use ndev
>
> Will you not have the same issue if you remove the driver after you
> schedule rx_tasklet? Because rx_action will use also ndev.
>

Hello Horatiu,

Thanks for your reply. In ns83820_remove_one, there is an invoking:

free_irq(dev->pci_dev->irq, ndev);

This will prevent the driver from handling more irq, But it couldn't preven=
t
the rx_tasklet from being scheduled. So I think we should add the
following code:

tasklet_kill(&dev->rx_tasklet);

after free_irq invoking. Is there anything wrong about my analysis?

Thanks again for pointing the mistake out.

Best regards,
Zheng


> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> > v2:
> > - cancel the work after unregister_netdev to make sure there
> > is no more request suggested by Jakub Kicinski
> > ---
> >  drivers/net/ethernet/natsemi/ns83820.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ether=
net/natsemi/ns83820.c
> > index 998586872599..2e84b9fcd8e9 100644
> > --- a/drivers/net/ethernet/natsemi/ns83820.c
> > +++ b/drivers/net/ethernet/natsemi/ns83820.c
> > @@ -2208,8 +2208,13 @@ static void ns83820_remove_one(struct pci_dev *p=
ci_dev)
> >
> >         ns83820_disable_interrupts(dev); /* paranoia */
> >
> > +       netif_carrier_off(ndev);
> > +       netif_tx_disable(ndev);
> > +
> >         unregister_netdev(ndev);
> >         free_irq(dev->pci_dev->irq, ndev);
> > +       cancel_work_sync(&dev->tq_refill);
> > +
> >         iounmap(dev->base);
> >         dma_free_coherent(&dev->pci_dev->dev, 4 * DESC_SIZE * NR_TX_DES=
C,
> >                           dev->tx_descs, dev->tx_phy_descs);
> > --
> > 2.25.1
> >
>
> --
> /Horatiu
