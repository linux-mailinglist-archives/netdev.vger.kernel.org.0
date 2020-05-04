Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992ED1C3C44
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 16:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgEDODy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 10:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbgEDODy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 10:03:54 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E83C061A0E;
        Mon,  4 May 2020 07:03:53 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s9so13991955eju.1;
        Mon, 04 May 2020 07:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tCHoUYZDTjX4vaPAyNBL+EYEDPRlfwHwHf5FTbB/Lh4=;
        b=KF937lRK0nNhSOVgWpMcj6ZuKQ7C+cWdzULHvmIN8/tI2pgvbinqmSxs9O7Uis2hZM
         Rp/YST7OxmY4ZCpDeEoX9rM4PETetPd4g1YjCX9U/iokjzZ/U558GihHLyAPaoiGBWFe
         7ASSJsYTBefWrcak4ajMy5czb8VLh4sdAb7Ztsv9hNEp1MkAllURAMdI95wxD4oGFJKD
         45o3L29FCXEj/Szid66lvzJHfI6AnKlPqfKYtAT6dEPz4HJAd60i8PceLYvjsDqsFRZt
         H1nmqCk+Wmsf86jhvtew6IYS+UIOVjqszXtyfSPo0EbnHFMNAQ8Qsqh1SiF7t+4aoIRS
         N3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tCHoUYZDTjX4vaPAyNBL+EYEDPRlfwHwHf5FTbB/Lh4=;
        b=Y9AwG4f4yYjlcoejH16dXusSI1hRLhQoV/q63uM29U21Q7OHSA9AqihND1MDV0mj3g
         HjNZyqH3rxGEftiPbsw/kIafSMkVU+dpWiyFD3ayEBDew5BOHxCnJhiz+2bq1uKjmF76
         ApMRTQE7aeU3YwWMcYYq95tg3BsPPQsxHdFwfRufBHkoeHvWZwjWt0dkap54eRrmHJos
         ZiraRYltEhh797i8foF6gnsldq5hcpvxHMGG1VWAeayoCEIr7+DUDzme1tXy19kwQxQO
         VlXRSTojI9NrhYeJxbbSfn2f1rSrEScmXlFBCCMo1wZuX+SJyxv4ZgQr7NyGKZlYO+ls
         y2Vg==
X-Gm-Message-State: AGi0PuZqvQnyY8D1aiFZE25NudtadTh0BM6N+CekJbAthHwJclTaaf5r
        Yziy7sDyNSQ2Ceq7bblfamzWOjJM5N6POCLd/ZM=
X-Google-Smtp-Source: APiQypIxSPbdrguBfX/9eTGu45BHQKk5RV0OzOZc8hHJ0xjKVKjmF3jhfhUGalHijSC/PcHW6qT1n80wXVoucotZBa8=
X-Received: by 2002:a17:906:78c:: with SMTP id l12mr14074138ejc.189.1588601032384;
 Mon, 04 May 2020 07:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200504120127.4482-1-zhengdejin5@gmail.com>
In-Reply-To: <20200504120127.4482-1-zhengdejin5@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 17:03:41 +0300
Message-ID: <CA+h21hpaCna1r=qR8QtLWGi+ttGfNxMhcXvm2JHHgV3ZgmXxGQ@mail.gmail.com>
Subject: Re: [PATCH net v1] net: enetc: fix an issue about leak system resources
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 May 2020 at 15:04, Dejin Zheng <zhengdejin5@gmail.com> wrote:
>
> the related system resources were not released when enetc_hw_alloc()
> return error in the enetc_pci_mdio_probe(), add iounmap() for error
> handling label "err_hw_alloc" to fix it.
>
> Fixes: 6517798dd3432a ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> index ebc635f8a4cc..15f37c5b8dc1 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
> @@ -74,8 +74,8 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
>         pci_disable_device(pdev);
>  err_pci_enable:
>  err_mdiobus_alloc:
> -       iounmap(port_regs);
>  err_hw_alloc:
> +       iounmap(port_regs);
>  err_ioremap:
>         return err;
>  }
> --
> 2.25.0
>

Thanks!
-Vladimir
