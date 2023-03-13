Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DA86B6DB7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCMDCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCMDCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:02:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9672138EBC;
        Sun, 12 Mar 2023 20:02:41 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q14so834763pfu.7;
        Sun, 12 Mar 2023 20:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678676561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sP45EmaHky2C7HY2PTlFBXhO5V4BCl6r67HtKTO/Y8c=;
        b=SpxKSkg68PnvkeE7lu8MlFe6Goe0KbJSuDc+nx4qQ5MOFtFZvJHbJ2ylI9iGGzWyRf
         K9Ok8oh/Zmd+Nd7fzkAJOH0XHEcG8QWDhf30BRbivnJT14eBXqo7hLBCSvjd18wTq3df
         HUglygM2rVy1Se77oZtNxBzJuybRlPOBIaXxUfRnlBtRFaIfn/4ipD+8jFRqX6hAtCpi
         A/tC76yEc3GrUvSq+GaZVVOfUFV3mwGMp4HW6ZWd0rKz3JTA3v/2xe/7VPjqcY+K4glZ
         iWLtRefRO/LL1L8hnOHmqYzY8glHCFgV5f/fpO/e/D6rbiEuyWqAVqy3ouspN11CcKT1
         PTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678676561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sP45EmaHky2C7HY2PTlFBXhO5V4BCl6r67HtKTO/Y8c=;
        b=CoPrAAaCg927lAC+FjcfeQ9uXbWgANEEUyLvPPZzSDoxPacWDeOqQ9GmWDCjY79ZCD
         9zoRE+E4ux/B7AftqGAe0sIBESLpX7eOu+Cj7tb6UcIcEMyvtn8ABxWRk6WShofntdjP
         dX+PQ/g2zhRPBMuc6P3q6OImy+7IPjyxrMxtfo5Z31/RFBv7nD2XlrZ+kiuXj1xg4IFa
         8DNVZb6o1t+r9b3Kwu9vwOlX/4P4IYMA7ZGOGay1nOPeKtIcfQG0i3s/U46HLGb3T9Dn
         yzgFHMnQEVVAKTqA/1DfOTk5IRV6SqT5EuM+mq+NEgXOklvZ1Q2TAAHeGUYGfOJuuJZX
         OvJw==
X-Gm-Message-State: AO0yUKVFIiQ6qxbLpp8ACUoKNNhf4mPk5Z29tXOMddjEplCrfZcTxH+k
        qB57EROHuTofKTuDuknnPKp4K5EbEwbRknL4F4w=
X-Google-Smtp-Source: AK7set/WOvoEJDUn6WYNo57it6WU5ZYIzPQ7MgBmLSAaHEPFbEnJHgLNLA+oUzIfnH4+ul1Bhc+KS/7HVq4izUuD/Nc=
X-Received: by 2002:a63:8c1d:0:b0:503:2535:44c3 with SMTP id
 m29-20020a638c1d000000b00503253544c3mr11036458pgd.4.1678676561089; Sun, 12
 Mar 2023 20:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230311180630.4011201-1-zyytlz.wz@163.com> <57f6d87e-8bfb-40fc-7724-89676c2e75ef@huawei.com>
In-Reply-To: <57f6d87e-8bfb-40fc-7724-89676c2e75ef@huawei.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Mar 2023 11:02:28 +0800
Message-ID: <CAJedcCy8QOCv3SC-Li2JkaFEQydTDd1aiY77BHn7ht0Y8r1nUA@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ravb: Fix possible UAF bug in ravb_remove
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, s.shtylyov@omp.ru,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
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

Yunsheng Lin <linyunsheng@huawei.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=80 09:15=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2023/3/12 2:06, Zheng Wang wrote:
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
>
> LGTM.
> Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
>
> As noted by Sergey, ravb_remove() and ravb_close() may
> share the same handling, but may require some refactoring
> in order to do that. So for a fix, it seems the easiest
> way to just add the handling here.

Dear Yunsheng,

I think Sergey is right for I've seen other drivers' same handling
logic. Do you think we should try to move the cancel-work-related code
from ravb_remove to ravb_close funtion?
Appreciate for your precise advice.

Best regards,
Zheng

>
> > +
> >       /* Stop PTP Clock driver */
> >       if (info->ccc_gac)
> >               ravb_ptp_stop(ndev);
> >
