Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD3E441D3A
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 16:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhKAPQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 11:16:45 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47730 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAPQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 11:16:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A1FDnLf115877;
        Mon, 1 Nov 2021 10:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635779629;
        bh=Jzq3onPPIUYhf/zt+yXHkXe7aZ10c64oDy1WMlXiQvE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=wfFg2/D64lt12cLRkpWNG9dGaN0O0McGbOXyyIweqql21Av2yplXs5JbVcEkVP866
         KDIsWdmW6+d3a5J1VMytw9BctYpDkgS+hL0UP6Z4mCBymMV1XbWljgvh76RQJZ+ppT
         xwZPdN4OKXCAa0dDKf3ty4IvEU+U+DCuPmEzdI50=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A1FDnQU023818
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 Nov 2021 10:13:49 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 1
 Nov 2021 10:13:49 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 1 Nov 2021 10:13:49 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A1FDjPM103962;
        Mon, 1 Nov 2021 10:13:46 -0500
Subject: Re: [PATCH] net: davinci_emac: Fix interrupt pacing disable
To:     Maxim Kiselev <bigunclemax@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Michael Walle <michael@walle.cc>, Sriram <srk@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211101092134.3357661-1-bigunclemax@gmail.com>
 <CALHCpMjqL2i8rJBR1vVnW1orrY1Y6rSdmKGnL6uNE6tSa6jNYQ@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <01b318d1-ad3a-bf00-3ebe-6b449af5928d@ti.com>
Date:   Mon, 1 Nov 2021 17:13:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CALHCpMjqL2i8rJBR1vVnW1orrY1Y6rSdmKGnL6uNE6tSa6jNYQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/11/2021 16:03, Maxim Kiselev wrote:
>  From ca26bf62366f249a2ed360b00c1883652848bfdc Mon Sep 17 00:00:00 2001
> From: Maxim Kiselev <bigunclemax@gmail.com>
> Date: Mon, 1 Nov 2021 16:37:12 +0300
> Subject: [PATCH v2] net: davinci_emac: Fix interrupt pacing disable
> 
> This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
> disable rx irq coalescing.
> 
> Previously we could enable rx irq coalescing via ethtool
> (For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
> it because this part rejects 0 value:
> 
>         if (!coal->rx_coalesce_usecs)
>                 return -EINVAL;
> 
> Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing
> functionality.")
> 
> Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
> ---
> Changes v1 -> v2 (after review of Grygorii Strashko):
> 
>   - Simplify !coal->rx_coalesce_usecs handler


Do not send v2 as reply to v1 - pls, re-send as it will not hit
https://patchwork.kernel.org/project/netdevbpf/list/ properly

Otherwise:
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

> 
> ---
>   drivers/net/ethernet/ti/davinci_emac.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/davinci_emac.c
> b/drivers/net/ethernet/ti/davinci_emac.c
> index e8291d8488391..d243ca5dfde00 100644
> --- a/drivers/net/ethernet/ti/davinci_emac.c
> +++ b/drivers/net/ethernet/ti/davinci_emac.c
> @@ -420,8 +420,20 @@ static int emac_set_coalesce(struct net_device *ndev,
>          u32 int_ctrl, num_interrupts = 0;
>          u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;
> 
> -       if (!coal->rx_coalesce_usecs)
> -               return -EINVAL;
> +       if (!coal->rx_coalesce_usecs) {
> +               priv->coal_intvl = 0;
> +
> +               switch (priv->version) {
> +               case EMAC_VERSION_2:
> +                       emac_ctrl_write(EMAC_DM646X_CMINTCTRL, 0);
> +                       break;
> +               default:
> +                       emac_ctrl_write(EMAC_CTRL_EWINTTCNT, 0);
> +                       break;
> +               }
> +
> +               return 0;
> +       }
> 
>          coal_intvl = coal->rx_coalesce_usecs;
> 

-- 
Best regards,
grygorii
