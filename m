Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23716B8820
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCNCM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 22:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCNCMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 22:12:25 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4C386147;
        Mon, 13 Mar 2023 19:12:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s17so8068658pgv.4;
        Mon, 13 Mar 2023 19:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678759942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+PG/bPeXML8HPhbviR8D9BdLsDmoGyXkknbItojLBQ=;
        b=TDFZ2UptmH52rBY1fIz8zWB676QAshsIDlOkKWDx7938eT6L/nmyQNs7ElW8X/gImb
         kpxvSc1HLeBihglxseQMS0vmi1IDSz1qgHY7FMkQruMVZq0mi3ZYrPmyawM2n8hNYwn1
         kUbOgH9QkrDZVvjwn4HvAX639Rtq1wpcS8/fgzdU59v1VE08QDGjJXGuzdj3wa9aZION
         BOftsM9A8jcwNRqO+tcOdxqFGPW2fTRam/MevCDFik+M+mw9Br5Ri+gHj3tbVyWQVu7L
         cNBcnukSRHoL/sLjpIsxQmjLO227LNQRGSCChNntKNK5Fg7wNDu8KN1P1WDlXFziI3SC
         pgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678759942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+PG/bPeXML8HPhbviR8D9BdLsDmoGyXkknbItojLBQ=;
        b=fFxCy084wXA7NLPGOw7wGFIIweCGaKe6KjXx5yYkGLAdSV80MfXQIeR90/j0wk4ub9
         21/ia5A2pHSazePfKxoIipQI4R2rPmerebF1ySM7T11+KLnMhtz/BurHBAz2TBHvOqGM
         r23SNO10oLvmkjudjThEKeAMw/vR94zT2lBTiuPihMiGnXdNL3xwb3mTCBYpU4O5rZLi
         B8djmlqy64e/9jtl2GwjF2hbrydGT2Os9QLW64jz81NWMv2J6JtsWCmpcUqqkhnCh8ur
         7CzXZBhqgzj3trsZh13+Zm8vZhHEyBI0EneyHYmFWdXrZUShtjJ9pkojL9vkfD6pPX7c
         Gfkw==
X-Gm-Message-State: AO0yUKUIGPGUS0bGnoqn/hhlJwnZK5yQQ2hIqICSOjGmDHFYO+oNEDri
        VhaGxrUmg1UEvrxajHOOa2SDNMpUogFhfoIoWAs=
X-Google-Smtp-Source: AK7set/eGBuBHWImtsoYrhMg5r2XVkLeNYX8EG4FJE3ETeby2X7uo98bZqPcSHnsU5uDjjAUGaSyJTX4pk4zPxNQpT0=
X-Received: by 2002:a63:7d03:0:b0:503:4a2c:5f0 with SMTP id
 y3-20020a637d03000000b005034a2c05f0mr11937106pgc.9.1678759942189; Mon, 13 Mar
 2023 19:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230311170836.3919005-1-zyytlz.wz@163.com> <20230313171500.35400df5@kernel.org>
In-Reply-To: <20230313171500.35400df5@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Tue, 14 Mar 2023 10:12:10 +0800
Message-ID: <CAJedcCwhAL0ZdCqVK=i4Ss_iZnWS+PNzq2juBmuqmKR0rbJ9QQ@mail.gmail.com>
Subject: Re: [PATCH v2] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        simon.horman@corigine.com, edumazet@google.com, pabeni@redhat.com,
        petrm@nvidia.com, thomas.lendacky@amd.com,
        wsa+renesas@sang-engineering.com, leon@kernel.org,
        shayagr@amazon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
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
=A5=E5=91=A8=E4=BA=8C 08:15=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, 12 Mar 2023 01:08:36 +0800 Zheng Wang wrote:
> > In xirc2ps_probe, the local->tx_timeout_task was bounded
> > with xirc2ps_tx_timeout_task. When timeout occurs,
> > it will call xirc_tx_timeout->schedule_work to start the
> > work.
> >
> > When we call xirc2ps_detach to remove the driver, there
> > may be a sequence as follows:
> >
> > Stop responding to timeout tasks and complete scheduled
> > tasks before cleanup in xirc2ps_detach, which will fix
> > the problem.
> >
> > CPU0                  CPU1
> >
> >                     |xirc2ps_tx_timeout_task
> > xirc2ps_detach      |
> >   free_netdev       |
> >     kfree(dev);     |
> >                     |
> >                     | do_reset
> >                     |   //use dev
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> > v2:
> > - fix indentation error suggested by Simon Horman,
> > and stop the timeout tasks  suggested by Yunsheng Lin
> > ---
> >  drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/eth=
ernet/xircom/xirc2ps_cs.c
> > index 894e92ef415b..c77ca11d9497 100644
> > --- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
> > +++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> > @@ -503,6 +503,11 @@ static void
> >  xirc2ps_detach(struct pcmcia_device *link)
> >  {
> >      struct net_device *dev =3D link->priv;
> > +             struct local_info *local =3D netdev_priv(dev);
> > +
> > +             netif_carrier_off(dev);
> > +             netif_tx_disable(dev);
> > +             cancel_work_sync(&local->tx_timeout_task);
> >
> >      dev_dbg(&link->dev, "detach\n");
> >
>
> Please fix the formatting and make sure you CC the maintainers when you
> post v3.

Hi Jakub,

Get it!

Best regards,
Zheng
