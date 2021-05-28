Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80594394839
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhE1VTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhE1VTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 17:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C98EE6100B;
        Fri, 28 May 2021 21:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622236691;
        bh=7W+RlOQGHryBngK+npbIbXIQUHoSOpa/HVifWRueKZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ky58ttpTiYx3SAY914fnqtHmiRD72X6Ofr/kr+z+qV+WtbHOhDgI8a8ZjNRfLEuih
         41A7wrl4MrYBWWj/qDB67hG6Q6Pn26r6ROd6/Kx3OeNkag8niZaP78GxWrXQwu+Lqr
         /ABURDI4Ndmg08MSX7UTU3mBm/moh3nlMcwC6KkUBizsAPqRJOTjBPtBtsEvjkRUkO
         F1Uir3Jb1L/DKYItPvecy11PLHSLC3z+ub2iaBhUq4rtyoUOyyUWFxM2A1P+hLt33z
         1luLfx+sg1PuPcr2E7byZBIGJI/HGXd1oYdEk31CdZCkionFU848JTDniz0iFU8UUh
         kqqA2zKSd7IVg==
Date:   Fri, 28 May 2021 14:18:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>, <davem@davemloft.net>
Subject: Re: [PATCH -next 2/2] net: dsa: qca8k: add missing check return
 value in qca8k_phylink_mac_config()
Message-ID: <20210528141810.4ec1cb86@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528082240.3863991-3-yangyingliang@huawei.com>
References: <20210528082240.3863991-1-yangyingliang@huawei.com>
        <20210528082240.3863991-3-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 16:22:40 +0800 Yang Yingliang wrote:
> Now we can check qca8k_read() return value correctly, so if
> it fails, we need return directly.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/dsa/qca8k.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a8c274227348..6fe963ba23e8 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1200,6 +1200,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  
>  		/* Enable/disable SerDes auto-negotiation as necessary */
>  		ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
> +		if (ret)
> +			return;
>  		if (phylink_autoneg_inband(mode))
>  			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
>  		else
> @@ -1208,6 +1210,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  
>  		/* Configure the SGMII parameters */
>  		ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
> +		if (ret)
> +			return;
>  
>  		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
>  			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;

You should ignore the return value in the previous patch and add the
ret variable here, to avoid the transient build warning.
