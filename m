Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5CA3DE035
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhHBTmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBTmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 15:42:02 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFA5C06175F;
        Mon,  2 Aug 2021 12:41:52 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id m9so25301776ljp.7;
        Mon, 02 Aug 2021 12:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cvvD7OAixc/C6SiWBm4rRETT6DwlbRXzK7cf1P/caQ0=;
        b=GOCwh3Mf0aHCcRSSbbOuxQ6sFA0j4LthtY2KkQ1Xdbd5IT1nLRjxmV48h2p55nmfjs
         nXcEgBe1qcHI+Ua9sI025InoI2V7N8hyf8XKTwMKkeftDmjnM5jGcX6M78FEK3m2BEDt
         nYrPy6/JB3gwusZZ06t4sw0UXKUoZHFN1HgUm9YIO222N85vUMJX0sRAP96wcBFqz8v5
         xJSH0PCi3kGtbkerTL7nbNAMa8eBWjUKH0k27XRSj3a0fY+i9r0lbq55ueLqVd/jOq17
         I+VzS9mTA41sqPooUe6pttIURUBOOUeIj1iU6exywuODHbfg5Cps+WK8QmWeChXreLpM
         ugTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cvvD7OAixc/C6SiWBm4rRETT6DwlbRXzK7cf1P/caQ0=;
        b=AZMQIiTNFX4JhFXYcQL++7hai4bnjN/NEWfJjdRLJN8uEpNs6FAY10g3qS4RMwC22I
         PNas7sxw3s59UMQlD+DB1kY9FagcX3EtAOZjdV7tnXa1ik3qbtY9RQUzpNpxLUAO+hvh
         L8tjiJ/ZhqL4kguLDyPIFJx3VvIR0lAn6HOVhPrQLQoigCFXkm8rxRyz79dDWTnva9E7
         fu2PKayIQymVEpcQFgsnWeBSXKeFwKhtRXl95ovpOiUoJubbDf++P+v3bssFC9W8HcSf
         AbqiqYqkaPnjE0QEbos5HBWRvHsR/1iYLuih5AZZEb1Mbjo0xE8vAOvhVoGWVsqht6jD
         th1Q==
X-Gm-Message-State: AOAM531iJGXYD7SrGYHhEpchg1q6RGDJOdcT1ZLDDUROpo2P/7Xppmsu
        q+w6enCqGLMYHZf8mmrMkcc=
X-Google-Smtp-Source: ABdhPJyB36eIK94rLUaDAs5U+C0rfXN3sgl9S3hVwW2iRT8OBPqwwX9r4WHqulEntW3EPAjnkuKb4A==
X-Received: by 2002:a2e:9ecd:: with SMTP id h13mr12540926ljk.162.1627933311254;
        Mon, 02 Aug 2021 12:41:51 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.81.124])
        by smtp.gmail.com with ESMTPSA id bp31sm282592lfb.308.2021.08.02.12.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 12:41:50 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH net-next 12/18] ravb: Factorise {emac,dmac} init function
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
 <20210722141351.13668-13-biju.das.jz@bp.renesas.com>
Message-ID: <1bd80ea3-c216-a42a-c46c-0bb13173d793@gmail.com>
Date:   Mon, 2 Aug 2021 22:41:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-13-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/22/21 5:13 PM, Biju Das wrote:

> The R-Car AVB module has Magic packet detection, multiple irq's and
> timestamp enable features which is not present on RZ/G2L Gigabit
                                   ^ are

> Ethernet module. Factorise emac and dmac initialization function to
> support the later SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  2 +
>  drivers/net/ethernet/renesas/ravb_main.c | 58 ++++++++++++++++--------
>  2 files changed, 40 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index d82bfa6e57c1..4d5910dcda86 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -992,6 +992,8 @@ struct ravb_ops {
>  	void (*ring_free)(struct net_device *ndev, int q);
>  	void (*ring_format)(struct net_device *ndev, int q);
>  	bool (*alloc_rx_desc)(struct net_device *ndev, int q);
> +	void (*emac_init)(struct net_device *ndev);
> +	void (*dmac_init)(struct net_device *ndev);
>  };
>  
>  struct ravb_drv_data {
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 3d0f6598b936..e200114376e4 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -454,7 +454,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
>  }
>  
>  /* E-MAC init function */
> -static void ravb_emac_init(struct net_device *ndev)
> +static void ravb_emac_init_ex(struct net_device *ndev)
>  {
>  	/* Receive frame limit set register */
>  	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
> @@ -480,30 +480,19 @@ static void ravb_emac_init(struct net_device *ndev)
>  	ravb_write(ndev, ECSIPR_ICDIP | ECSIPR_MPDIP | ECSIPR_LCHNGIP, ECSIPR);
>  }
>  
> -/* Device init function for Ethernet AVB */

   Grr, this comment seems oudated...

> -static int ravb_dmac_init(struct net_device *ndev)
> +static void ravb_emac_init(struct net_device *ndev)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
>  	const struct ravb_drv_data *info = priv->info;
> -	int error;
>  
> -	/* Set CONFIG mode */
> -	error = ravb_config(ndev);
> -	if (error)
> -		return error;
> -
> -	error = ravb_ring_init(ndev, RAVB_BE);
> -	if (error)
> -		return error;
> -	error = ravb_ring_init(ndev, RAVB_NC);
> -	if (error) {
> -		ravb_ring_free(ndev, RAVB_BE);
> -		return error;
> -	}
> +	info->ravb_ops->emac_init(ndev);
> +}

   The whole ravb_emac_init() now consists only of a single method call?
Why do we need it at all?

>  
> -	/* Descriptor format */
> -	ravb_ring_format(ndev, RAVB_BE);
> -	ravb_ring_format(ndev, RAVB_NC);
> +/* Device init function for Ethernet AVB */

   s/Device/DMAC/. Or this comment shouldn't have been moved.

> +static void ravb_dmac_init_ex(struct net_device *ndev)

   Please no _ex suffixes -- reminds me of Windoze too much. :-)

> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
>  
>  	/* Set AVB RX */
>  	ravb_write(ndev,
> @@ -530,6 +519,33 @@ static int ravb_dmac_init(struct net_device *ndev)
>  	ravb_write(ndev, RIC2_QFE0 | RIC2_QFE1 | RIC2_RFFE, RIC2);
>  	/* Frame transmitted, timestamp FIFO updated */
>  	ravb_write(ndev, TIC_FTE0 | TIC_FTE1 | TIC_TFUE, TIC);
> +}
> +
> +static int ravb_dmac_init(struct net_device *ndev)
> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
> +	int error;
> +
> +	/* Set CONFIG mode */
> +	error = ravb_config(ndev);
> +	if (error)
> +		return error;
> +
> +	error = ravb_ring_init(ndev, RAVB_BE);
> +	if (error)
> +		return error;
> +	error = ravb_ring_init(ndev, RAVB_NC);
> +	if (error) {
> +		ravb_ring_free(ndev, RAVB_BE);
> +		return error;
> +	}
> +
> +	/* Descriptor format */
> +	ravb_ring_format(ndev, RAVB_BE);
> +	ravb_ring_format(ndev, RAVB_NC);
> +
> +	info->ravb_ops->dmac_init(ndev);
>  
>  	/* Setting the control will start the AVB-DMAC process. */
>  	ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_OPERATION);
> @@ -2018,6 +2034,8 @@ static const struct ravb_ops ravb_gen3_ops = {
>  	.ring_free = ravb_ring_free_rx,
>  	.ring_format = ravb_ring_format_rx,
>  	.alloc_rx_desc = ravb_alloc_rx_desc,
> +	.emac_init = ravb_emac_init_ex,
> +	.dmac_init = ravb_dmac_init_ex,

   Hmm, why not also gen2?!

>  };
[...]

MBR, Sergei
