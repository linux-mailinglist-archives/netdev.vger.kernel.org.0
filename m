Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E24629420
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiKOJRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiKOJRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:17:11 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F522B15
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:16:50 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 7so16429951ybp.13
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bv5zkcSIm2mjk+OiqCCjHEOChFfQ9VeZrPEOnDGSgGE=;
        b=lmMMBsC5IxSfexlwJvUXhQJqUuj+M4nuYKL8yXbufGN3NXU8IK9tI9NfMW+vn+i1WN
         sQ5L1WgfeSRXFV8smyguiVtEGajOwRckIxDG81Lg9OSCv5sXkEbVugPaS/BZjMN+Hksi
         qYAPgKnhYfQnlXTH4C5O6zdyFMW9Bca3SLXUxaO7ODE9veg5se+eRywh04HmGctaT+k1
         skz5haWt+wbnDQQxzYiIAB4xAk7YcaAUOCphiifWM/bV9VsitYaHK+hBPJ+qKVIXd2ZT
         dqmrERAZ3DJV1MJha5WKpweJHK4L8cY/uAKBJ51MXQspVWYTKnsCy0j+YlMOvMmfnJLS
         /ehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bv5zkcSIm2mjk+OiqCCjHEOChFfQ9VeZrPEOnDGSgGE=;
        b=Jptwu9+MRcfEAmumX2XBmc7bPmVFm/lulnulnsTFDzvQ5upYYPGCxVCv7nKgi3is3W
         csXsEqSGnD80zqQWfew6Ppbt/4byqegytrAjSAqatYbcZuYqPsf9uBKqIzKGV/TQZyM6
         JyDOBpl/mQaBa3WRR6xTR0bDkcD3HozItHn7MsQBmxnOeOPAz3t8ltTQW++S+lBtVOJC
         n3VRdcJnnlxYN0aHiD/VFN/l4YZh3Ru1iUbgZNetgg1qj3dvtYPph4SlP7RGuGDvfPtv
         ZWGk3QVCtlNtm10sBa9F66OCCtBQh5tOMTgpjSDPDdIF623shXgeQffej0c5ycfyYJCT
         I4hg==
X-Gm-Message-State: ANoB5pkSABvdLsrwNrE/wxy145YB6Vr4eYjFCmf7KQmegc2WE0P9Jout
        RoRRKHW8pSKuwYrHS9wtbPYhcdaQdTRM2fgKODxbfg==
X-Google-Smtp-Source: AA0mqf4yFAG3DvIjiyVwZdPyA60CrV/tg1e1L38n8+xBX5o6zcRMP7nw06p8gl7hVCcWgXektQFvyObnUbMj9YIBCWU=
X-Received: by 2002:a25:d957:0:b0:6ca:e3de:f401 with SMTP id
 q84-20020a25d957000000b006cae3def401mr16070429ybg.236.1668503809409; Tue, 15
 Nov 2022 01:16:49 -0800 (PST)
MIME-Version: 1.0
References: <20221115090433.232165-1-tanghui20@huawei.com>
In-Reply-To: <20221115090433.232165-1-tanghui20@huawei.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 15 Nov 2022 10:16:36 +0100
Message-ID: <CAPv3WKc_iwojwpBqX+QK0_atp3vQiN4C8h_qqj=OPEQUJzMpeg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: mvpp2: fix possible invalid pointer dereference
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yusongping@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wt., 15 lis 2022 o 10:08 Hui Tang <tanghui20@huawei.com> napisa=C5=82(a):
>
> It will cause invalid pointer dereference to priv->cm3_base behind,
> if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().
>
> Fixes: a59d354208a7 ("net: mvpp2: enable global flow control")
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> ---
> v1 -> v2: patch title include target
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index d98f7e9a480e..c92bd1922421 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -7421,7 +7421,7 @@ static int mvpp2_probe(struct platform_device *pdev=
)
>                         dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
>
>                 /* Enable global Flow Control only if handler to SRAM not=
 NULL */
> -               if (priv->cm3_base)
> +               if (!IS_ERR_OR_NULL(priv->cm3_base))
>                         priv->global_tx_fc =3D true;
>         }
>
> --
> 2.17.1
>

Thank you for the patch.

Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Best regards,
Marcin
