Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A9E3D41CA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 22:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhGWUQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhGWUQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 16:16:25 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5E0C061575;
        Fri, 23 Jul 2021 13:56:57 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a26so4055898lfr.11;
        Fri, 23 Jul 2021 13:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bXb16HUzNAOSlHZ/+zgh6wisO6Ka1nY0CUiqxXt2BMI=;
        b=PvOUNdePQ4acQ2Anw1fJ7UhyZzwodF3BQp2ULwO136rhrfLRvfBZAg2Ljdx5KDiDvw
         JlSBx0Hyo6x+H9e5ZFgnIzvyt9u2Xizs2YBsC+pp+i0DsQp//RWbqNxz+xjDNL9dGHt8
         JoT5PtNI1uAMkJZnryDmgmj5B+8fwkLB9ONiphnmWo/Ez53vjxJIJI3URnjA6L/PQmNU
         vyhRvcdE3Pt7nnaQbWrLRcZ9qdXvtYRI8gGaxv70cUnCZzaN6pN6przzTXB9ygtOPvVg
         xgSo/030SaBvypGBfDjxpSG7b+0BdCBTNyZ1AVJWe0TH9QwKhCpbVt+D/vz90QzUZK0s
         vH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bXb16HUzNAOSlHZ/+zgh6wisO6Ka1nY0CUiqxXt2BMI=;
        b=Qr803vagmxLNxVKeyND5m5IVQiJelRxaK4WjAfKV4vKCM+/G7etgQXc9C3INWYJHOt
         g4IOipZoLmzxeb4L2E2hc/GHYtP1VqdcmvqUx8vmEvfFLP/iGI8oNyf4BfRsXhYNrrnG
         9u/MseG/iSALs5kN3nD3Zb7gTtJCDAkWjE+HygB9gS4MJaXMjUztuBB1/HmASuB7iPng
         fJ3doKdg+CXzh1hA75l/VM0ecFT4n8iS68LJ7e8v+dgTxAjm7khCEsOcnfXRV75qXAqc
         aWovJ6+4FS2ZbuYLbly/HRqASQu3NuitJwifxAlzqCK5Fx1AJgdn0O4dnei4wKy63Rwg
         Yr/A==
X-Gm-Message-State: AOAM532tn6fzmxSQbV5+MwBrjNusKgqY8/0VIhTnOrS8cqUXRRvuKtkx
        xqt37xOna2V2gxwJffA6COs=
X-Google-Smtp-Source: ABdhPJwVUPz3xX79j8kxybNKnhf9xhZi+6W4NlHnYRCL9jkIfqyuzJs2v9tEcWQ9BmD2s+OP1Pirhg==
X-Received: by 2002:a19:ad4d:: with SMTP id s13mr4186705lfd.432.1627073814143;
        Fri, 23 Jul 2021 13:56:54 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.87.172])
        by smtp.gmail.com with ESMTPSA id bi36sm2320943lfb.159.2021.07.23.13.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 13:56:53 -0700 (PDT)
Subject: Re: [PATCH net-next 06/18] ravb: Factorise ptp feature
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-7-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <bff55135-c801-0a9e-e194-460469688afe@gmail.com>
Date:   Fri, 23 Jul 2021 23:56:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-7-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HEllo!

On 7/22/21 5:13 PM, Biju Das wrote:

> Gptp is active in CONFIG mode for R-Car Gen3, where as it is not

   It's gPTP, the manuals say. :-)

> active in CONFIG mode for R-Car Gen2. Add feature bits to handle
> both cases.

   I have no idea why this single diff requires 2 fetaure bits....

> RZ/G2L does not support ptp feature.

   Ah, that explains it. :-)
   It doesn't explain why we should bother with the 2nd bit in the same patch tho...

> Factorise ptp feature
> specific to R-Car.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 81 ++++++++++++++++--------
>  2 files changed, 56 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 0ed21262f26b..a474ed68db22 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -998,6 +998,7 @@ struct ravb_drv_data {
>  	size_t skb_sz;
>  	u8 num_tx_desc;
>  	enum ravb_chip_id chip_id;
> +	u32 features;

   You didn't like bitfelds (in sh_eth) so much? :-)

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 84ebd6fef711..e966b76df32c 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -40,6 +40,14 @@
>  		 NETIF_MSG_RX_ERR | \
>  		 NETIF_MSG_TX_ERR)
>  
> +#define RAVB_PTP_CONFIG_ACTIVE		BIT(0)
> +#define RAVB_PTP_CONFIG_INACTIVE	BIT(1)

   If both bits are 0, it means GbEth?

> +
> +#define RAVB_PTP	(RAVB_PTP_CONFIG_ACTIVE | RAVB_PTP_CONFIG_INACTIVE)

   Hm?

> +
> +#define RAVB_RCAR_GEN3_FEATURES	RAVB_PTP_CONFIG_ACTIVE
> +#define RAVB_RCAR_GEN2_FEATURES	RAVB_PTP_CONFIG_INACTIVE

   Not sure whtehr these are necessary...

[...]
>  	}
>  
>  	/* gPTP interrupt status summary */
> -	if (iss & ISS_CGIS) {
> +	if ((info->features & RAVB_PTP) && (iss & ISS_CGIS)) {

   This is not a transparent change -- the fearture check came fromn nownere...

>  		ravb_ptp_interrupt(ndev);
>  		result = IRQ_HANDLED;
>  	}
[...]
> @@ -1275,7 +1286,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
>  		(1 << HWTSTAMP_FILTER_NONE) |
>  		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
>  		(1 << HWTSTAMP_FILTER_ALL);
> -	info->phc_index = ptp_clock_index(priv->ptp.clock);
> +	if (data->features & RAVB_PTP)

   Again, not transparent...

> +		info->phc_index = ptp_clock_index(priv->ptp.clock);
>  
>  	return 0;
>  }
[...]
> @@ -1992,14 +2009,20 @@ static int ravb_set_gti(struct net_device *ndev)
>  static void ravb_set_config_mode(struct net_device *ndev)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
>  
> -	if (priv->chip_id == RCAR_GEN2) {
> +	switch (info->features & RAVB_PTP) {
> +	case RAVB_PTP_CONFIG_INACTIVE:
>  		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
>  		/* Set CSEL value */
>  		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
> -	} else {
> +		break;
> +	case RAVB_PTP_CONFIG_ACTIVE:
>  		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG |
>  			    CCC_GAC | CCC_CSEL_HPB);
> +		break;
> +	default:
> +		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);

   Not trasparent again...

[...]
> @@ -2182,13 +2205,15 @@ static int ravb_probe(struct platform_device *pdev)
>  	/* Set AVB config mode */
>  	ravb_set_config_mode(ndev);
>  
> -	/* Set GTI value */
> -	error = ravb_set_gti(ndev);
> -	if (error)
> -		goto out_disable_refclk;
> +	if (info->features & RAVB_PTP) {

   Not transparent enough yet again...

> +		/* Set GTI value */
> +		error = ravb_set_gti(ndev);
> +		if (error)
> +			goto out_disable_refclk;
>  
> -	/* Request GTI loading */
> -	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
> +		/* Request GTI loading */
> +		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
> +	}
>  
>  	if (priv->chip_id != RCAR_GEN2) {
>  		ravb_parse_delay_mode(np, ndev);
[...]
> @@ -2377,13 +2404,15 @@ static int __maybe_unused ravb_resume(struct device *dev)
>  	/* Set AVB config mode */
>  	ravb_set_config_mode(ndev);
>  
> -	/* Set GTI value */
> -	ret = ravb_set_gti(ndev);
> -	if (ret)
> -		return ret;
> +	if (info->features & RAVB_PTP) {

   Not transparent enough again...

> +		/* Set GTI value */
> +		ret = ravb_set_gti(ndev);
> +		if (ret)
> +			return ret;
>  
> -	/* Request GTI loading */
> -	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
> +		/* Request GTI loading */
> +		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
> +	}
>  
>  	if (priv->chip_id != RCAR_GEN2)
>  		ravb_set_delay_mode(ndev);
> 

MBR, Sergei
