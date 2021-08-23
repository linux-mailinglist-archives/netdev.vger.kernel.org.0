Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1139A3F4731
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 11:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhHWJPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 05:15:19 -0400
Received: from mail-vs1-f50.google.com ([209.85.217.50]:33449 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhHWJPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 05:15:13 -0400
Received: by mail-vs1-f50.google.com with SMTP id v26so10683526vsa.0;
        Mon, 23 Aug 2021 02:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XzJFujuWV9NuV2pa9LOX6rWxNm/ii/522I59qgbcb5o=;
        b=jIwFxn7iPEk8bhDLk3dSwp1+27oc358R99VA/tFANIBobgBvKdbmZQfMxFPEssNunu
         DT1ADyaEKx0ARIYNpR6J1T+yQqWj5JVmeCY7DPD/73SM5DqZKmczCqSk3hjiSnQ2f729
         mzK75doPOzxYShyHnfby5KYrxoyiPNZ5E2KcqBVZLRvCT6l6OmiJng0r91f0gWHyrB7d
         1w2Mgf8g3tUPvc7iy3OAutG2t/4UpYnLaJqR62wsJlWLCyoULapx6S0I7ZgUWwviOydB
         IDjBW8ikrwJV6siwHwl14vwhzvDxN0tB2hbQKMRI2P9VcogPC4lZPS2SbR1pb046P4O7
         ViJg==
X-Gm-Message-State: AOAM530VFCZK+jJDOJUTbMp/CdwUbWdLRVES3FFRCa0rnaWN+kOIjMrk
        Vu3AHaFEmlSoR16UWKIURnFesVi0IIXUlmj7VnE=
X-Google-Smtp-Source: ABdhPJxqKw+eO7pYO2bfRzWkEX3Dhnn/1Z/e59Lv3TZm52eVeI5bHqcBUkzfNAsEcQdXTnWlxpfy+XYhExtl/2YmwZQ=
X-Received: by 2002:a67:ce90:: with SMTP id c16mr1504043vse.7.1629710070937;
 Mon, 23 Aug 2021 02:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com> <20210818190800.20191-4-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210818190800.20191-4-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 23 Aug 2021 11:14:19 +0200
Message-ID: <CAMuHMdUEeZjfJgpXpO6qcAyuGp64wxyxiuLjUosVcRfG8=2s6w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/9] ravb: Add aligned_tx to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Wed, Aug 18, 2021 at 9:08 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> R-Car Gen2 needs a 4byte aligned address for the transmission buffer,
> whereas R-Car Gen3 doesn't have any such restriction.
>
> Add aligned_tx to struct ravb_hw_info to select the driver to choose
> between aligned and unaligned tx buffers.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Thanks for your patch, which is now commit 68ca3c923213b908 ("ravb:
Add aligned_tx to struct ravb_hw_info") in net-next.

> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -990,6 +990,7 @@ enum ravb_chip_id {
>
>  struct ravb_hw_info {
>         enum ravb_chip_id chip_id;
> +       unsigned aligned_tx: 1;
>  };
>
>  struct ravb_private {
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index b6554e5e13af..dbccf2cd89b2 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1930,6 +1930,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
>
>  static const struct ravb_hw_info ravb_gen2_hw_info = {
>         .chip_id = RCAR_GEN2,
> +       .aligned_tx = 1,
>  };
>
>  static const struct of_device_id ravb_match_table[] = {
> @@ -2140,7 +2141,7 @@ static int ravb_probe(struct platform_device *pdev)
>         ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
>         ndev->min_mtu = ETH_MIN_MTU;
>
> -       priv->num_tx_desc = info->chip_id == RCAR_GEN2 ?
> +       priv->num_tx_desc = info->aligned_tx ?
>                 NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;

At first look, this change does not seem to match the patch description.
Upon a deeper look, it is correct, as num_tx_desc is also used to
control alignment.

But now NUM_TX_DESC_GEN[23] no longer match their use.
Perhaps they should be renamed, or replaced by hardcoded values,
with a comment?

    /*
     * FIXME: Explain the relationship between alignment and number of buffers
     */
    priv->num_tx_desc = info->aligned_tx ? 2 : 1;

>
>         /* Set function */

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
