Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4B76B8793
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCNBZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCNBZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:25:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A51069CEC;
        Mon, 13 Mar 2023 18:24:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso66888pjf.0;
        Mon, 13 Mar 2023 18:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678757099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rQAj3RdmyLkPTq1oHtk9XKECnzrwmvjxGU7spr3bBY=;
        b=IsUs0wHdJkILJGOuNdK4H9pKSoTih6KfR3UItAylXx0Q6bl8tgb0NJGrQQ5rIDt9CS
         VvQly+sSQXUsPbOzMyUZ1WoLPfodkylq8BGvweIa3It6jKOU8vqhcmw4lMVddTr4CCxi
         DY/rtelAiJiEA9BQRJiNQpBoL/4pkRP7CRJthoz5LYG0D0GVKP14rYP2JBoVh/FYYPD7
         EhbN4XvzfVVvEPJR2tU75gFEXvHUNaxDb1IwKkLX7ap0dcGlTNSqOeksYZewF6w9LVkj
         kOL0gIxT0tFXK2BrOVWNmScGl8wrpDfIx8z9DihSCBZgJO7rfLHvWpBkEuShHfhTrKIH
         TRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678757099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9rQAj3RdmyLkPTq1oHtk9XKECnzrwmvjxGU7spr3bBY=;
        b=udGxMgUrM5MVY4WqhNd0DgVU0ABVBRFKlQo/XU86uDC/pouSpeCbh6Fo59/3PmPWqc
         1oQokKaTMnR4/zu6kW4E83MXfEa82fbPEI63Jk75Oyc+RRS8D+Ir349YIAwOR7JVazVv
         GfygRSFSRy+m6nkeZ7p+m0qR2MZQmc3UyKVUd23ao4bOzDKWmsScLHbYfpXg32JLgdcY
         vhVVelhEVvQG9td5TOL9Ae28d1XFnTiskJ4BGWUqXPHFhz83+siKrKwGtPi1V/Wo6Jl7
         vxXZtC9X5UQH2NpQt7mLLUchLouUjeVshwAM6JXnEuUZhNteEAIXdWjNltYELYyvGueE
         r+1w==
X-Gm-Message-State: AO0yUKUGfzeDbkxR4MsmpkBg3C3FGfzUsiDXh2+WUCU/0n29ezynbZ8t
        B4Ws751Yp43ty5d4d1j5XhACWLJjpAn69uqNi2U=
X-Google-Smtp-Source: AK7set8scFBkNmdlTDen93ONGYZBItUA1MFMdQtWl5NTgTqHlykVRUkzRW0cD7CsESKImmbhqRCkyAI7VYxNlvi3cHc=
X-Received: by 2002:a17:902:f986:b0:1a0:4321:920e with SMTP id
 ky6-20020a170902f98600b001a04321920emr2435495plb.12.1678757098846; Mon, 13
 Mar 2023 18:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230311180630.4011201-1-zyytlz.wz@163.com> <20230313153904.53647ad7@kernel.org>
In-Reply-To: <20230313153904.53647ad7@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Tue, 14 Mar 2023 09:24:46 +0800
Message-ID: <CAJedcCzPGSBrR9vPHaguPCdK-_6txyQNhiMDaqxKRMNC1Ky2yg@mail.gmail.com>
Subject: Re: [PATCH net v3] net: ravb: Fix possible UAF bug in ravb_remove
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, s.shtylyov@omp.ru,
        davem@davemloft.net, linyunsheng@huawei.com, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com, richardcochran@gmail.com,
        p.zabel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        phil.edworthy@renesas.com,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        geert+renesas@glider.be, yuehaibing@huawei.com,
        linux-renesas-soc@vger.kernel.org
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
=A5=E5=91=A8=E4=BA=8C 06:39=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, 12 Mar 2023 02:06:30 +0800 Zheng Wang wrote:
> > Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
>
> You must CC all people involved in a commit if you put it as Fixes.
Hi Jakub,

Get it.

> Are you using the get_maintainer.pl script?
> How do you call in exactly?

Yes, I used this script to find developers involved but It seems that
I unintentionally forgot to CC some people.

I apologize for my offense for everyone exclued in the list.

Thanks,
Zheng
