Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367606B4DAB
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCJQyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjCJQyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:54:20 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D26136FC2;
        Fri, 10 Mar 2023 08:51:21 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id h31so3406453pgl.6;
        Fri, 10 Mar 2023 08:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678467080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Icx2k/mVThmsQ5uBdHUhfNVC8rWT1gXwAUNd336Yoms=;
        b=HFZ/3VfEdhnnp5NbZxdwNrIEf1uscmWB3kD272c0Wws7K3GGbGW6UULgZQSeWeXLnv
         18T16OS1tlWqWbnvmkM5NX6OPhxSZgJNz5zDFkLRNJZyw2bLG4TR1RZLuoSvF9aCb3xM
         fUBU7YDR0mj15pHwkafnmClKuOrmFGLUl1gRvgcMe30fezs7d6NwuZRKT/aLt/sYkugJ
         ZOoBKwV79ati5ClDhekhypxCVUXxAHtvZYdywoMp+Zp3956o/onqxaNyb6DWazQPjE+b
         musYmZWgF5C5xQVrO627BQpE/upxHT7gQiDsaIv4a6ES0lbG0F7zEqjeKsE7Orqo9ASq
         o0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678467080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Icx2k/mVThmsQ5uBdHUhfNVC8rWT1gXwAUNd336Yoms=;
        b=Icnf2VsKUt90dRvFh90QzuIm5GqBSvFoqFx2GdjzwN9oU2iM6pF/E3yXqeVjmEh70m
         c1yVjiFk/e6vjof5lhSmH42itLT8FbPEtRVq5aCGyDRYxVNYG8rbRtlZ/btUBz3SaYzS
         FtzcjB5seiZVipnTg6XmOGwBLHzDZnXrkUnEFPsnaSlbKXkcSPhQPMbDTOG7T1M6kFNj
         HIMXZXbWyo+ZP15LBZZY44X0WV/REcS2QdU3PI+kH5FlFspT3Ool1Il2P2o7+jXx+djS
         wJWzne95xEONKQUTDDr5w18TP6eBtajsgDAzsh9oM+9ggoRUgQNTeqQX3gkuFBG3//xa
         MaQQ==
X-Gm-Message-State: AO0yUKWIqyQvR0ji/V+oo9esdmxhOjy9/kddaZqBAwsXIv1nkT82WjFN
        Mb6QP5qF93L4vJ3d9kqODM8XlUNkSxwuPHZYDN0=
X-Google-Smtp-Source: AK7set9e8Ja8YX9td92OBoOeoViIEMnC0HKSPnKaqtXH7aK+8bHxCYhesfTOz8Ovt27usQ5SIXMHrjhSXXT/2f/4N4M=
X-Received: by 2002:a05:6a00:1955:b0:592:5696:89ee with SMTP id
 s21-20020a056a00195500b00592569689eemr10890910pfk.3.1678467079848; Fri, 10
 Mar 2023 08:51:19 -0800 (PST)
MIME-Version: 1.0
References: <20230309165729.164440-1-zyytlz.wz@163.com> <ZAs3nOoT0GmsLfGN@corigine.com>
In-Reply-To: <ZAs3nOoT0GmsLfGN@corigine.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Sat, 11 Mar 2023 00:51:07 +0800
Message-ID: <CAJedcCwFE0xsQpUYNS98J7WJxMrD9At8o2Km3AZo8CuNOvqJuw@mail.gmail.com>
Subject: Re: [PATCH net] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
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

Simon Horman <simon.horman@corigine.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8810=
=E6=97=A5=E5=91=A8=E4=BA=94 21:59=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Mar 10, 2023 at 12:57:29AM +0800, Zheng Wang wrote:
> > In xirc2ps_probe, the local->tx_timeout_task was bounded
> > with xirc2ps_tx_timeout_task. When timeout occurs,
> > it will call xirc_tx_timeout->schedule_work to start the
> > work.
> >
> > When we call xirc2ps_detach to remove the driver, there
> > may be a sequence as follows:
> >
> > Fix it by finishing the work before cleanup in xirc2ps_detach
> >
> > CPU0                  CPU1
> >
> >                     |xirc2ps_tx_timeout_task
> > xirc2ps_detach      |
> >   free_netdev       |
> >     kfree(dev);     |
> >                     |
> >                     | do_reset
> >                     |   //use
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> >  drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/eth=
ernet/xircom/xirc2ps_cs.c
> > index 894e92ef415b..ea7b06f75691 100644
> > --- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
> > +++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> > @@ -503,7 +503,10 @@ static void
> >  xirc2ps_detach(struct pcmcia_device *link)
> >  {
> >      struct net_device *dev =3D link->priv;
> > -
> > +             struct local_info *local;
> > +
> > +             local =3D netdev_priv(dev);
> > +             cancel_work_sync(&local->tx_timeout_task)
> >      dev_dbg(&link->dev, "detach\n");
> >
> >      unregister_netdev(dev);
>
> This doesn't compile.
> Also, the indentation is incorrect.

Sorry for my mistake. I was hurried to report the issue and ignored
the compile test.

>
> I think what should have been posted is:

Yes, will correct it in the next version of patch.

Best regards,
Zheng

>
> diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ether=
net/xircom/xirc2ps_cs.c
> index 894e92ef415b..b607fea486ab 100644
> --- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
> +++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
> @@ -503,7 +503,10 @@ static void
>  xirc2ps_detach(struct pcmcia_device *link)
>  {
>      struct net_device *dev =3D link->priv;
> +    struct local_info *local;
>
> +    local =3D netdev_priv(dev);
> +    cancel_work_sync(&local->tx_timeout_task);
>      dev_dbg(&link->dev, "detach\n");
>
>      unregister_netdev(dev);
