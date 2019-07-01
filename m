Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743695BC33
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfGAM5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:57:54 -0400
Received: from mx.0dd.nl ([5.2.79.48]:53944 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGAM5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 08:57:54 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 89C175FBBA;
        Mon,  1 Jul 2019 14:57:52 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="S+L8MgYG";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 419711CEAF08;
        Mon,  1 Jul 2019 14:57:52 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 419711CEAF08
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561985872;
        bh=SvuIg99z70EzCu3ysoMBUjr+NraXTm8gQI0tZ5NYnaY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=S+L8MgYGmrCUYG2LNVNFLQsVpm9L+PkhSAFTMJjjfaDvQnPECwjLBMUdxltspPM6N
         QQhy0dgDUPnG7iv7tivRqoEF0Giw/hgqluu0+srb0kbSYXkc5hjjSE1INZ80+HvX0M
         MFaeKZcUVr6xxH6Pz9n8a+YGbIFL4bjthxY5NZ4y/RFYouWrOYWzbW0DopoWiIvj5h
         Jmy0CM7ChKjgcOj0TFIq/9HO5AUHxDdgzT+fP6MaTMO9R65JsY+Oj7N2unjmow3qu9
         5cTLRFyMgpXNujY7QcsKMnCcTdg3XuuOKrB60SpgxRQAl22jmmxHSO65nJiYGBJKwa
         Piho7ehqeKEVA==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 01 Jul 2019 12:57:52 +0000
Date:   Mon, 01 Jul 2019 12:57:52 +0000
Message-ID: <20190701125752.Horde.M4sGI0OXZNgSa9VpOKj-m3s@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: mediatek: Allow non TRGMII mode with
 MT7621 DDR2 devices
In-Reply-To: <20190629122451.19578-1-opensource@vdorst.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting René van Dorst <opensource@vdorst.com>:

I see that I also forgot to tag this patch for net-next.

Greats,

René

> No reason to error out on a MT7621 device with DDR2 memory when non
> TRGMII mode is selected.
> Only MT7621 DDR2 clock setup is not supported for TRGMII mode.
> But non TRGMII mode doesn't need any special clock setup.
>
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c  
> b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 066712f2e985..b20b3a5a1ebb 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -139,9 +139,12 @@ static int mt7621_gmac0_rgmii_adjust(struct  
> mtk_eth *eth,
>  {
>  	u32 val;
>
> -	/* Check DDR memory type. Currently DDR2 is not supported. */
> +	/* Check DDR memory type.
> +	 * Currently TRGMII mode with DDR2 memory is not supported.
> +	 */
>  	regmap_read(eth->ethsys, ETHSYS_SYSCFG, &val);
> -	if (val & SYSCFG_DRAM_TYPE_DDR2) {
> +	if (interface == PHY_INTERFACE_MODE_TRGMII &&
> +	    val & SYSCFG_DRAM_TYPE_DDR2) {
>  		dev_err(eth->dev,
>  			"TRGMII mode with DDR2 memory is not supported!\n");
>  		return -EOPNOTSUPP;
> --
> 2.20.1



