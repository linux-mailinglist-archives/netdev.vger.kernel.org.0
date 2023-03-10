Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9CD6B4D1C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCJQgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbjCJQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:35:36 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579784AFD1;
        Fri, 10 Mar 2023 08:33:14 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id q189so3368444pga.9;
        Fri, 10 Mar 2023 08:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678465993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHjXS14Qn++SsDvoDYoTNjUowoiY9kx0S+3ZTEOxEoE=;
        b=WVnJliibCm9uDAcG4S3LXCQ1UqCQHLBglJ8CUFGXV3OK4Mg9gURKC1wm8AqbTuqpt4
         x2A6akGX6omQE2Khd6+t9sjWsXNAHPdDzSvfheTEnbSB2onBS4tihbB1IWWca86hvK+4
         HVFQ5+iQa5xBe/TnYyrxbUT8t7Gm9nvsFs/Sz7+ta1O37/b5VWJTSQsp/hYeDvUd9oWS
         fXQfwwUKQa4z8ah5mnSQjlgYrfRod0d0gBOspxOL8L/42BQ1AJoF6UPIo1Z75UbtGnk9
         7pXx6T2t6SBaYDu62fW56IZA72EAJCEbO3vUqx8E9PV4L/MSoBborPpqINMcKFVFtwxo
         i/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678465993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHjXS14Qn++SsDvoDYoTNjUowoiY9kx0S+3ZTEOxEoE=;
        b=ifSVR+/q4KgCRf9Z2Mr2LTIl+KNbm1wEyuqZrv7EQf/AaK4P7Rr7WGFe/f7ng4meU9
         pkzwgz+dhOQe0/tBTti7tbeDciLpmuSbp4uurouIzAGJLhBwPRae2rXvtk2EvCAhYwj8
         wr/h2Z4AEhLujpBp6TQhsfUhGG3+a6A2UA58M2ERl/3RyXiQgNDk76LfQ2oTB6Pma/xP
         PQpeG1g4aAdhkKkXOTnh/59qLd1uFHYW4OUA2hwdz/bcMADwWeibpqwNhuHpdIBqRd4E
         qm0fIbO1cXGdq+r7Uk7v8SzwDkAhg468K44Nm8QIHe4pYGcA+3FOIANoy7jMlvTUiqro
         B69g==
X-Gm-Message-State: AO0yUKWgDgmnnFo2E/dHJJLzFKvLJ9tcs+plofTQBnHSnuGJrWgXMumG
        2xOQ3ex9o69+1ysx/43EhW0AvDBC4JkkVQVZ3+E=
X-Google-Smtp-Source: AK7set8KUCyyYdE1HG4AxpSGGPoHQqlcnaRFnzaz+he0dAOhdfMi8eF8TJ79Ti/B5I/j+duOFM2tnWoJ6pMBoPHJ+3A=
X-Received: by 2002:a63:b003:0:b0:503:91ff:8dd8 with SMTP id
 h3-20020a63b003000000b0050391ff8dd8mr9094781pgf.4.1678465993615; Fri, 10 Mar
 2023 08:33:13 -0800 (PST)
MIME-Version: 1.0
References: <20230309100248.3831498-1-zyytlz.wz@163.com> <9054b170-8ed2-445c-6150-82f98af5808b@omp.ru>
In-Reply-To: <9054b170-8ed2-445c-6150-82f98af5808b@omp.ru>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Sat, 11 Mar 2023 00:33:01 +0800
Message-ID: <CAJedcCyTn3eM7ptFbW+WPQNC4jaxe=JF5kkWxC3bpnwRA91g-Q@mail.gmail.com>
Subject: Re: [PATCH net] net: ravb: Fix possible UAF bug in ravb_remove
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
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

Sergey Shtylyov <s.shtylyov@omp.ru> =E4=BA=8E2023=E5=B9=B43=E6=9C=889=E6=97=
=A5=E5=91=A8=E5=9B=9B 23:47=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello!
>
> On 3/9/23 1:02 PM, Zheng Wang wrote:
>
> > In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
> > If timeout occurs, it will start the work. And if we call
> > ravb_remove without finishing the work, ther may be a use
> > after free bug on ndev.
>
>    Have you actually encountered it?

Sorry, I haven't encountered it. All of the analysis is based on
static analysis.

>
> > Fix it by finishing the job before cleanup in ravb_remove.
> >
> > Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
>
>    Hm... sorry about that. :-)
>
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
>
> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>
> [...]
> > diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/eth=
ernet/renesas/ravb_main.c
> > index 0f54849a3823..07a08e72f440 100644
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -2892,6 +2892,7 @@ static int ravb_remove(struct platform_device *pd=
ev)
> >       struct ravb_private *priv =3D netdev_priv(ndev);
> >       const struct ravb_hw_info *info =3D priv->info;
> >
> > +     cancel_work_sync(&priv->work);
>
>    I think we need an empty line here...

Yes, will add it in the next version of patch.

Best regards,
Zheng

>
> >       /* Stop PTP Clock driver */
> >       if (info->ccc_gac)
> >               ravb_ptp_stop(ndev);
>
