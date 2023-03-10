Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3186B4D53
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCJQl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCJQlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:41:10 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F540119415;
        Fri, 10 Mar 2023 08:38:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id h8so6161412plf.10;
        Fri, 10 Mar 2023 08:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678466302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QVoDt8UjEaPrFLKqSBNQ8tDd7rlJV/H36JbOoKuTkzQ=;
        b=owzHLqT4lTivzNESaa0zBhjQKEZb39AwND+OwtyUfsHyI1ul4saBZhHUxVxjvHOvF2
         4KOavY5DPo/hLz/qEOSAbWkBCIQJsu7CpFBwr6jPmVBxf0SRMphVI7Lw0UFlJVS/6O3P
         tGZuO490D/GSG8PMgme+r7SA5ykVf5xIz7bArmdjVMkfDTCPUV8MaADwXhE7uvFasmh1
         1W75hWjlJkQqJk4NJWZNvG024xeS455UIyBOm89R8wlFxJH6BYRlnpCCOsHnz4A9mMZA
         LdqyeTIU+bGnE7imFXz70zTvfB0n9mu1XySDr1ncBtanv2JE/CNDuIEij6ex02EfyqXi
         GNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678466302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QVoDt8UjEaPrFLKqSBNQ8tDd7rlJV/H36JbOoKuTkzQ=;
        b=0Azb6BQ3Dh636KmYCokejjNXTU8yqCKkzZ0u+pjqAfdUSu8AlS8O8/579tEqOy64mN
         ct0oZZz9FvLnhC3Y7h0qwENlnJlztngsOp5QevLYN0andaNgu8khKSoIXSjJztETxEt7
         +6iN5L+bklj84/OpFOJUkI+3Eidv3hUE3mADzG3BcTnUcfdSjWoTsQO6VDxaPeqmZ30I
         pjRLhBoXSZiTA2d6CZUEGSjysAKyxIRumStlgGMH0Jk9XUYgCnXDWq9RxX7HeOb8OGhb
         q8fwaCLgUTNpBP+mQuUZrkQN2mr2ZqpC7CBqkfjA/vyImchZFB6XnNlF/h891J+agJ5G
         ipsg==
X-Gm-Message-State: AO0yUKVm31VOnGjyiJsn9YkeTMQ7+iETBuB8Bc31QREZBJNUv95SgtK9
        Ie3YBUp4egsr4hJjmei9H3OJr2l/7MdDOiYsjjg=
X-Google-Smtp-Source: AK7set9j940Iu26+zJhUp/L79gAyfXMI1228dqulhEw0DuzOaBgPcqJDS5bQ1t7lXpJEd8PrVCJeuzt0Um0TzVkJheA=
X-Received: by 2002:a17:902:684d:b0:19c:cf99:11f7 with SMTP id
 f13-20020a170902684d00b0019ccf9911f7mr10385024pln.0.1678466302633; Fri, 10
 Mar 2023 08:38:22 -0800 (PST)
MIME-Version: 1.0
References: <20230309100248.3831498-1-zyytlz.wz@163.com> <cca0b40b-d6f8-54c7-1e46-83cb62d0a2f1@huawei.com>
In-Reply-To: <cca0b40b-d6f8-54c7-1e46-83cb62d0a2f1@huawei.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Sat, 11 Mar 2023 00:38:10 +0800
Message-ID: <CAJedcCy2n9jHm+uS5RG1T7u8aK8RazrzrC-sQhxFQ_v_ZphjWA@mail.gmail.com>
Subject: Re: [PATCH net] net: ravb: Fix possible UAF bug in ravb_remove
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

Yunsheng Lin <linyunsheng@huawei.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8810=E6=
=97=A5=E5=91=A8=E4=BA=94 09:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On 2023/3/9 18:02, Zheng Wang wrote:
> > In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
> > If timeout occurs, it will start the work. And if we call
> > ravb_remove without finishing the work, ther may be a use
>
> ther -> there
>

Sorry about the typo, will correct it in the next version.

> > after free bug on ndev.
> >
> > Fix it by finishing the job before cleanup in ravb_remove.
> >
> > Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> >  drivers/net/ethernet/renesas/ravb_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
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
> As your previous patch, I still do not see anything stopping
> dev_watchdog() from calling dev->netdev_ops->ndo_tx_timeout
> after cancel_work_sync(), maybe I missed something obvious
> here?
>
Yes, that's a keyed suggestion. I was hurry to report the issue today
so wrote with many mistakes.
Thanks agagin for the advice. I will review other patch carefully.

Best regards,
Zheng

>

> >       /* Stop PTP Clock driver */
> >       if (info->ccc_gac)
> >               ravb_ptp_stop(ndev);
> >
