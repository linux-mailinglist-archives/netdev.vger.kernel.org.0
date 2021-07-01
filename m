Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048783B97A3
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhGAUeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbhGAUeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:34:07 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E77C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 13:31:36 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d16so14074531lfn.3
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 13:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIqiTHzvPeiEeTMDYxBD0+2ajqNYadEaJR3wIFIk5BI=;
        b=as3k7HeJ7RWliEFqiLEQpPMum0otGZnYZUo51Xg+QYAp6caHf+/jTcAPvrHctTe651
         eIBM2DOmqj8gxn5Dci1nsUGBjzi7wTE1xXbmw5h78e5++1GmFvbp3J8lv63UwZAsf6Ev
         87Rz3v29NQ1My+XXslx3QCqbFXL7T+Ftiv9Vg3e190XYhRztREK/WrGBKkvq4KJyHgg3
         2dPci++JR3wliN+DOlyLhZUnMkFvq2P2+txpK6EozsT79V8QRaUI37GuWEW2fAPwnoFl
         x/ZdcMSUeY5A41pgmnT/rlgDe3oJS+sg73oNyBxRJIoUfdr6o9Vnux0vTFPYSy/nrGDX
         pLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIqiTHzvPeiEeTMDYxBD0+2ajqNYadEaJR3wIFIk5BI=;
        b=SVYDI/brK57whMcwP3M81JOZzk6RCh3vh0X+8TpniVgp4jZBSgQYKlRCp4n/D3uuoC
         rWCh9Tx70HK0lS0p/NGZJAnUoAu5gEEQcMlkPeMDLO8FUc8cJ/CeylP9twlNQu8fjvHV
         skJjw4kA5oAuedwt8dl1jeaemnH1d0YTpToJTvs4dxl5BrAiuhsqTFMulpIVHz2yhZrq
         FBnKhXk65ZE09HZOWJAlEVC68lU8K6Q9Bhom79lQi7YyauzCJ3TvUI3Yje3GZiFVOtuw
         /f020KphkK9ZP6fCrfnkxHkURJ4nQiv6D0vWs/IrdepZ9j60niJ23D0uInCzg5Ji7C6X
         QhtA==
X-Gm-Message-State: AOAM532o7Wn+F1oTfvoFJm9o5Dk6HeaNDIdxRz+tEO1NMwTE2+kwfX1/
        Mt9r/RMax79tsXqeWiQRUzdmjXPUTY8IB6j8yk/17w==
X-Google-Smtp-Source: ABdhPJzPRISLX9bFvv96SpCwfJRfNJxbsLpLaGY7HN/9msigZ2lAicrh9p1LsfjuohprWcJWUGExVDXP1/Pw5xJb3eQ=
X-Received: by 2002:ac2:5519:: with SMTP id j25mr1095541lfk.431.1625171494324;
 Thu, 01 Jul 2021 13:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <f5dbb1ed01d13d4eac2b719db42cb02bf8166ceb.1625170569.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <f5dbb1ed01d13d4eac2b719db42cb02bf8166ceb.1625170569.git.christophe.jaillet@wanadoo.fr>
From:   Catherine Sullivan <csully@google.com>
Date:   Thu, 1 Jul 2021 13:30:57 -0700
Message-ID: <CAH_-1qy5uTBMw0ExLVzdOi6GffisPVs1B5xappyu+gA4H6ZGcg@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] gve: Fix an error handling path in 'gve_probe()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        David Awogbemila <awogbemila@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Bailey Forrest <bcf@google.com>, Kuo Zhao <kuozhao@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 1:18 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> If the 'register_netdev() call fails, we must release the resources
> allocated by the previous 'gve_init_priv()' call, as already done in the
> remove function.
>
> Add a new label and the missing 'gve_teardown_priv_resources()' in the
> error handling path.
>
> Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Catherine Sullivan <csully@google.com>

> ---
> v2: Fix a typo in the label name
>     The previous serie had 3 patches. Now their are only 2
> ---
>  drivers/net/ethernet/google/gve/gve_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 867e87af3432..44262c9f9ec2 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -1565,7 +1565,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>
>         err = register_netdev(dev);
>         if (err)
> -               goto abort_with_wq;
> +               goto abort_with_gve_init;
>
>         dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
>         dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_format);
> @@ -1573,6 +1573,9 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         queue_work(priv->gve_wq, &priv->service_task);
>         return 0;
>
> +abort_with_gve_init:
> +       gve_teardown_priv_resources(priv);
> +
>  abort_with_wq:
>         destroy_workqueue(priv->gve_wq);
>
> --
> 2.30.2
>

Thanks for the fix!
