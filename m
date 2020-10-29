Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E570329F888
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJ2Wmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2Wme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:42:34 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2042B20639;
        Thu, 29 Oct 2020 22:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604011353;
        bh=tQ0l5V4oTxTVGP0tODtTkscyEVWsw8t0lVmFsdY5laM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yd92HkfEq5MGLxNG/VDKKPlVEu58u8uIqw6WqIHmkDLSLsC6Skbygw18GUFIvvPBP
         //sBtfvSNzKX+62TVK8ib7UHfjtQVhgUiCiqQeDorMGCldhLeRYqfSOxGdTTnVw/+D
         kfUTIyLBt/koK0q/VwnHdzPgfW6e/F0cTpItuspA=
Date:   Thu, 29 Oct 2020 15:42:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH] net: dsa: mt7530: support setting MTU
Message-ID: <20201029154232.02e38471@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028181221.30419-1-dqfext@gmail.com>
References: <20201028181221.30419-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 02:12:21 +0800 DENG Qingfang wrote:
> MT7530/7531 has a global RX packet length register, which can be used
> to set MTU.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Please wrap your code at 80 chars.

> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index de7692b763d8..7764c66a47c9 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1021,6 +1021,40 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	int length;
> +
> +	/* When a new MTU is set, DSA always set the CPU port's MTU to the largest MTU
> +	 * of the slave ports. Because the switch only has a global RX length register,
> +	 * only allowing CPU port here is enough.
> +	 */
> +	if (!dsa_is_cpu_port(ds, port))
> +		return 0;
> +
> +	/* RX length also includes Ethernet header, MTK tag, and FCS length */
> +	length = new_mtu + ETH_HLEN + MTK_HDR_LEN + ETH_FCS_LEN;
> +	if (length <= 1522)
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1522);
> +	else if (length <= 1536)
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1536);
> +	else if (length <= 1552)
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1552);
> +	else
> +		mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_JUMBO_MASK | MAX_RX_PKT_LEN_MASK,
> +			MAX_RX_JUMBO(DIV_ROUND_UP(length, 1024)) | MAX_RX_PKT_LEN_JUMBO);

this line should start under priv, so it aligns to the opening
parenthesis.

Besides, don't you need to reset the JUMBO bit when going from jumbo to
non-jumbo? The mask should always include jumbo.

I assume you're duplicating the mt7530_rmw() for the benefit of the
constant validation, but it seems to be counterproductive here.

> +	return 0;
> +}

