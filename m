Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A42C407D2C
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhILMPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhILMPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 08:15:41 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9297AC061574;
        Sun, 12 Sep 2021 05:14:26 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4H6pSb1XdvzQk2Y;
        Sun, 12 Sep 2021 14:14:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1631448860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGo8RfjlaGE86RKp2Ugs8LU5kd9WCcFlCQqfgA32Exs=;
        b=zSsFaBQlFXVY6UYv6l7EZyjUN00u/dGl4AqKupz185pEKnCg/O5qJOQxmB+yS7ZWyMC0dY
        wX9Fzy+BmFPhL6OjM6+T2D5UEzjn/ciFbmDltdm3iY1jfShSPnqXoMUtMiXWOZie4g3n8U
        WZTDrB7aDloiJfGFV65cB7C1KSPLgeODirJlhBVuVstu9/hJOaF8xzH/RVJ8jrBbqn60Z9
        MTX+olgdgOVh/4B+lgtUH1Sz30eeTov7ZIVrEA9XrB4YFLUQz6LLj6AsUhXvmz6HhhQvrq
        oDbNUEpkySLB6fAynO0+cRwnqODxAJ4r0cBZ4guHeQyUMA8ygYJ0K4U3tEA9/g==
Subject: Re: [net,v2] net: dsa: lantiq_gswip: Add 200ms assert delay
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <20210912115807.3903-1-olek2@wp.pl>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <c0989c27-e799-cc73-e471-e7bd87934e81@hauke-m.de>
Date:   Sun, 12 Sep 2021 14:14:16 +0200
MIME-Version: 1.0
In-Reply-To: <20210912115807.3903-1-olek2@wp.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3995626C
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/21 1:58 PM, Aleksander Jan Bajkowski wrote:
> The delay is especially needed by the xRX300 and xRX330 SoCs. Without
> this patch, some phys are sometimes not properly detected.
> 
> The patch was tested on BT Home Hub 5A and D-Link DWR-966.
> 
> Fixes: a09d042b0862 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/dsa/lantiq_gswip.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 64d6dfa83122..267324889dd6 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1885,6 +1885,12 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
>   
>   	reset_control_assert(gphy_fw->reset);
>   
> +	/* The vendor BSP uses a 200ms delay after asserting the reset line.
> +	 * Without this some users are observing that the PHY is not coming up
> +	 * on the MDIO bus.
> +	 */
> +	msleep(200);
> +
>   	ret = request_firmware(&fw, gphy_fw->fw_name, dev);
>   	if (ret) {
>   		dev_err(dev, "failed to load firmware: %s, error: %i\n",
> 

