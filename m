Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E466B6DB4
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCMDA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCMDA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:00:26 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4232310B;
        Sun, 12 Mar 2023 20:00:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id ce7so6758004pfb.9;
        Sun, 12 Mar 2023 20:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678676422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKTaGpRJpGfg5wlKMy1+U+YC2Eq1IaNZm1QPKjQwsJs=;
        b=LIzozpIhyWcMIC2ePFLKPny/tTXoYvfRq8emp8NfTEn5dkk5aP0rG0rvXec1j0L4ln
         SiSjbb6buAVpPPh1BDxpFZxNmTNPQMDLXIGoBisPUcpMUEYcIjr8iogsKs0upKQKD8hB
         jsr3H/i6Jnx6ce0hTHeEA19qHpokwU9lTwzu93s7ESR5sSrQVqG1VTxj89zMsbsaczuV
         RfEdDem5Pi2MgBAVfr1L5wom5KqE9PdVzh+Xq6wnVQDAC7UpCMwI+SBqE7CtSKk9xF79
         a9Gs+NMgyX8RrxuLXIRWza8lnM8rotHvS9urxAao63/D9uo/3wqOGak3NTKHiEypu1Zd
         m1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678676422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xKTaGpRJpGfg5wlKMy1+U+YC2Eq1IaNZm1QPKjQwsJs=;
        b=bnIc3TZ73V7HQsQHsIy2EIUJoilzlbxboqCiVWAyJrdpgB24bUrtqm1xMqxAdTflPD
         LRhY4HsvZavndztdFdOhIOw0fOrc4mj3ojFcYGaRzEBiGJYnVyafqhO0RJK2bJs2eDNs
         rS+soIE0YAXXOCgxSRmosaa9YkSM1J+qXdFP2DeEsf6KHG+mn9Mx5F7VVM8JHpmkSvqu
         tfF9Jiv+h3oMhm65JEeQr9AWVTXEMLnolQB6yXglpWT6mhK37oX0jT0+XwGOBkX3MqDD
         3i6WbrlGk8Z/kKQXTpfQqUCHiUW9adVPpBROO2FA6Mht3hjW4F6s7OOY+Cj0YYVKPegu
         wIZQ==
X-Gm-Message-State: AO0yUKXXiXzMQb+RHoXAzKLlGm+3dg2z6WxZO23Kmm2j/Ecbigjb4WeY
        ARY34Ny7yp2De4o9tnKCtsGmW5jiXkmcXNWn8Wc=
X-Google-Smtp-Source: AK7set/U1SLubaV+HzTzjkOQnSnP9exny+cXpXFov6tzNvDNFVALXhYBX879HE0+yf4kgoNaPZhqp4lSfJmGxsuVE8w=
X-Received: by 2002:a63:7f1a:0:b0:4d9:8f44:e1d7 with SMTP id
 a26-20020a637f1a000000b004d98f44e1d7mr11426153pgd.4.1678676421701; Sun, 12
 Mar 2023 20:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230311180630.4011201-1-zyytlz.wz@163.com> <1a313548-1181-c376-a570-b8efd1d30810@omp.ru>
In-Reply-To: <1a313548-1181-c376-a570-b8efd1d30810@omp.ru>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Mar 2023 11:00:08 +0800
Message-ID: <CAJedcCw2DJWU=C0h_B093AofQw1nnDAQ8AaqVbhb=ea_mMNXWw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ravb: Fix possible UAF bug in ravb_remove
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Zheng Wang <zyytlz.wz@163.com>, davem@davemloft.net,
        linyunsheng@huawei.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
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

Sergey Shtylyov <s.shtylyov@omp.ru> =E4=BA=8E2023=E5=B9=B43=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=80 04:26=E5=86=99=E9=81=93=EF=BC=9A
>
> On 3/11/23 9:06 PM, Zheng Wang wrote:
>
> > In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
> > If timeout occurs, it will start the work. And if we call
> > ravb_remove without finishing the work, there may be a
> > use-after-free bug on ndev.
> >
> > Fix it by finishing the job before cleanup in ravb_remove.
> >
> > Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>
>    Well, I haven't reviewed v3 yet...

Please forgive my rudeness, I forgot that..

> > ---
> > v3:
> > - fix typo in commit message
> > v2:
> > - stop dev_watchdog so that handle no more timeout work suggested by Yu=
nsheng Lin,
> > add an empty line to make code clear suggested by Sergey Shtylyov
> > ---
> >  drivers/net/ethernet/renesas/ravb_main.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/eth=
ernet/renesas/ravb_main.c
> > index 0f54849a3823..eb63ea788e19 100644
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -2892,6 +2892,10 @@ static int ravb_remove(struct platform_device *p=
dev)
> >       struct ravb_private *priv =3D netdev_priv(ndev);
> >       const struct ravb_hw_info *info =3D priv->info;
> >
> > +     netif_carrier_off(ndev);
> > +     netif_tx_disable(ndev);
> > +     cancel_work_sync(&priv->work);
> > +
>
>    Thinking about it again (and looking on some drivers): can ravb_remove=
() be
> called without ravb_close() having been called on the bound devices?
>    So I suspect this code should be added to ravb_close()...
>

Yes, as this bug is found by static analysis, I've also seen a lot of
other drivers, many of them put the cancel-work-related code into
*_close as we must close all open file handle before remove a driver.
So I think you'are right. I'll try to add the code to ravb_close.

Best regards,
Zheng
