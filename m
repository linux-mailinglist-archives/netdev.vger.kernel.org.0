Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB7133D88
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 09:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgAHIpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 03:45:39 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36181 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgAHIpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 03:45:38 -0500
Received: by mail-ed1-f67.google.com with SMTP id j17so1917648edp.3;
        Wed, 08 Jan 2020 00:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QnWskoTIz3+0WWc/wqZuLn45bZinITtoNoTf51obx3o=;
        b=CvcK7z1033Lo7+sq/yON9EJqldCmoe1MWZ9BM7y5vcmmrPDiNCm1Y8S3LyC6irY1wb
         MILrFeqJQbgqoenECkSVeLbLtoH9aBgf7aZIr6GYoFRvHcKR4mlP4/XCoUqGnkP4rI1R
         RYzXl/tyC/m+n6xXKuRNzA7i7agOWdTLJS+jUaEpUD9aU3LncW53JwTF8GVLHIb01BpD
         vQY5px4NXOOi7FddkpFzy/9uw1VMGrS0/hGGu25VKCo9LHHej82OGx6zDXH0Rb4z5Bvl
         f5T6CUvYazI5A+uDsSAiPlYSacgMysxfNH18PgJdlyqHub+6xDLpEUqQJRpzkydwWjsu
         G0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QnWskoTIz3+0WWc/wqZuLn45bZinITtoNoTf51obx3o=;
        b=U9sNClBxQqbE+hF5Q3rc4xz94LMnkJp591OMXHmlyD67GpikAWsWgqg7z1FfSHHa7x
         kzFxRTQSsHEUygUjFHnn2r6GR6+cTMsENTyVmcsmkLe+AFAGI/OZ3fNWGoD81ZOY49n/
         bZIYM/R7OrrkTkFe+BlLmmzY1ZreK2vyj9dXhirynjVzYta7othFE03tkSGI/1RW3jNO
         DLS+pdA5/zDgnl9wv/5xx0vJA6YEiCsYzzNOqzEFTAJWqN478MwxCGlkK0QdyUx60iF2
         hnYRwctxAcglAATFcTDa/IcOLCQwkwLPnxNYTl53zA3AfzJJ+b7rLiuYh8QTMtgbX2+Q
         8KNg==
X-Gm-Message-State: APjAAAWpx4BjGnqsRPf/fQJVjLABofwfKjr5XflR7ehFQhmXip5x2ecM
        lX6B10ZEY3UlEC5UmHDYIBfCsNIe9gjnu88RJh3ou/ni
X-Google-Smtp-Source: APXvYqzaPH4LL5IgQE5ZnyP/RQ+XF7fSarAbsPkQV2bzIqELGcYCeM3z8WdTxSsTmGAZJnLGdDngulZzVIgzNXrJLMs=
X-Received: by 2002:aa7:d34d:: with SMTP id m13mr4242930edr.140.1578473136752;
 Wed, 08 Jan 2020 00:45:36 -0800 (PST)
MIME-Version: 1.0
References: <20200108062151.GA2614@embeddedor>
In-Reply-To: <20200108062151.GA2614@embeddedor>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 8 Jan 2020 10:45:26 +0200
Message-ID: <CA+h21hrhWDF6-nWVqkbYc5xFvfR6R6bEiimdRB5rRwXmceZEYA@mail.gmail.com>
Subject: Re: [PATCH net-next] enetc: enetc_pci_mdio: Fix inconsistent IS_ERR
 and PTR_ERR
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

On Wed, 8 Jan 2020 at 08:41, Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
>
> Fix inconsistent IS_ERR and PTR_ERR in enetc_pci_mdio_probe().
>
> The proper pointer to be passed as argument is hw.
>
> This bug was detected with the help of Coccinelle.
>
> Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---

This was fixed yesterday:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=4addbcb387c9519b320a9411cad68f0c01e9ed4b

>  drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> index 87c0e969da40..ebc635f8a4cc 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> @@ -27,7 +27,7 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
>         }
>
>         hw = enetc_hw_alloc(dev, port_regs);
> -       if (IS_ERR(enetc_hw_alloc)) {
> +       if (IS_ERR(hw)) {
>                 err = PTR_ERR(hw);
>                 goto err_hw_alloc;
>         }
> --
> 2.23.0
>

Thanks,
-Vladimir
