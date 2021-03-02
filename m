Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F8832A375
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378871AbhCBJEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377911AbhCBIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 03:45:10 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F33EC0617AB
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 00:42:38 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id lr13so33641853ejb.8
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 00:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agB1pi024Vr3XPHFnK8A8uxx+WSFW4Ss4wEt+UUGomA=;
        b=J2KxhfvYp/C4dNeiEuJ9uuzNtGkOnSWtZXhIKfyFPrvIRJ6Uz0nzrFUHlf/AJVfTX/
         pLADSL75J4ZVY+zeYfSOGPpkv9fP0XuJELCjv+CBzNjYyvbNqlvNEdO8o54dfEDtVYBf
         B8f+aY0ITlqdbI9sz70TTv+y26cx4W3D683xiB7w6RgFMzqfamj5eb16BuAy55JtBSXb
         dHUXhCpLl5GWmGLxuqBy+sAutKvDqQuvAKeG1lj97jpL5H7RzgzsMY62RMWRXHXy0Zc9
         6g2R/ewhXtTLFZtKya22iW6Hyt61B1lPKlWAWzZPyyeUvdmeh2YHExJZm3eape88OnIr
         0+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agB1pi024Vr3XPHFnK8A8uxx+WSFW4Ss4wEt+UUGomA=;
        b=tgJkcg1po/Rcm+xtRDjnfBrVGlQWtRoJTzX4prc2aQanQzQIAKcVfxrvBtntx2tqjF
         CnK4Cyz+zyuvpMctccRp8Jd+i9KgX3bRCXBnJi9Kzjg3jqHQtj1zi8iVg2I5DcVXigfv
         OyQXgKdpeszztr6eRhN3gkAdd3stMK+ujjtwItRhZk9zEpEKwxfqjAu2jS6aZy4AjH66
         KQSJb+otb3XUhm344XurxmxocLSwC31RVkuKndi6vBXo5+QEGZGIS3kwJDUkc4wLbHKa
         T+ewFF3WWNkZNLgw6Q9NQydD7Zf7agwp3kZ8wvhQGmU6h6rXlLxeig5cIb8Y0S4EVe/c
         ONQQ==
X-Gm-Message-State: AOAM530ydDUALdhS61GER1noiNTXbor9m1mbCQYsGAHZzTXXP4IGkWrO
        5NK4qjB45JgMiamayq+zh736qt+QeDLBqOjLmzHvfg==
X-Google-Smtp-Source: ABdhPJxrNudJeeR8IfVRpsk7slwS7VNf7SxzFv8Xp+r4FDzk4q5SXG33aC9jWsXdNCJ5zn9Z9QMi1b64BHGjO2kV73Q=
X-Received: by 2002:a17:906:3105:: with SMTP id 5mr20113035ejx.168.1614674557016;
 Tue, 02 Mar 2021 00:42:37 -0800 (PST)
MIME-Version: 1.0
References: <20210302033323.25830-1-biao.huang@mediatek.com>
In-Reply-To: <20210302033323.25830-1-biao.huang@mediatek.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Tue, 2 Mar 2021 09:42:26 +0100
Message-ID: <CAMpxmJV_MmOrP1eKdcBsD2sjzC7p52vxBz+HE+yHDdr9RTujqQ@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: mtk-star-emac: fix wrong unmap in RX handling
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 4:33 AM Biao Huang <biao.huang@mediatek.com> wrote:
>
> mtk_star_dma_unmap_rx() should unmap the dma_addr of old skb rather than
> that of new skb.
> Assign new_dma_addr to desc_data.dma_addr after all handling of old skb
> ends to avoid unexpected receive side error.
>
> Fixes: f96e9641e92b ("net: ethernet: mtk-star-emac: fix error path in RX handling")
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> index a8641a407c06..96d2891f1675 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -1225,8 +1225,6 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
>                 goto push_new_skb;
>         }
>
> -       desc_data.dma_addr = new_dma_addr;
> -
>         /* We can't fail anymore at this point: it's safe to unmap the skb. */
>         mtk_star_dma_unmap_rx(priv, &desc_data);
>
> @@ -1236,6 +1234,9 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
>         desc_data.skb->dev = ndev;
>         netif_receive_skb(desc_data.skb);
>
> +       /* update dma_addr for new skb */
> +       desc_data.dma_addr = new_dma_addr;
> +
>  push_new_skb:
>         desc_data.len = skb_tailroom(new_skb);
>         desc_data.skb = new_skb;
> --
> 2.18.0
>

Thanks for spotting that. Maybe also update the commit so that it
says: "it's safe to unmap the old skb"? Would make the thing clearer
IMO.

In any case:

Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Bartosz
