Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887962458EE
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgHPSF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgHPSFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 14:05:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5506FC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:05:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id c10so6979059pjn.1
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/RHppuSfA76nLkYq60UJvQdm5YmbI0J3RX8Vux/ja5M=;
        b=FEiph5QJaJ6TQk2yTKz3NwVKVGsmYhPlzMqn8abtCXFqZFs5TBJX7eA+hsbOiXglDm
         Rw/wlRJYoMxa7EwJZrwoTEKYjLsEcdEkgp/3uE6TT1TE/KcDRmCui3dVU2+2Jjz5yppm
         9ChUX5Agb7/gQjFuO204LtIHbsR0xu50VgByegCjx//99aRyG1/AWVm4QR32iJR5ZXSm
         05L2CcEQKU3u9ECX+7nuTuh+QLUM8xUC7PE9ylwjqY6b/50iBXiJEWjHwCkumVRRYnqp
         X9EJT/94ZoFjcMWqvScH3R1ztClPJ3Gn+A2kzVT98XILWGpRc1qcXh2sPiXzXTSFJgN0
         4cpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/RHppuSfA76nLkYq60UJvQdm5YmbI0J3RX8Vux/ja5M=;
        b=PXkrmGqVwBIXpaXXNEd5xShRQBY7w+o6Sam1issJUUnSyj83AYOQW09xDYW9/6b9EK
         7Yw5FWjrunw0Mz2zyKY99AcvrM3DQcens7/t+puh1hVS56l/+1OveTKzaBNYkiG0ilwu
         ctyTFMg7brw/J+bllTaws3wlFJD+ExCH6dbvhq4Qsokf2cl3LrenXmtTaxcBEKpGQVFi
         EzeGxXKIHLpUOLhZDPmAp/tjNP+vGAnW04l2A2yN55ad7amndOZlzM4cBiEVAz6QhlM4
         IR3lYx6BN6rGphQBqOQXo0kqqVpYI/BFhoVnNZVOopWmw4CMj8T3zH6sDiey4ZPk0dR+
         7Www==
X-Gm-Message-State: AOAM532GNeNuFoIbBs3Xg2EGRZayg/UETpAYH3aAKupDubDxNaIN6cRj
        XOFfuIaALHt8pWXa6+9jFyY=
X-Google-Smtp-Source: ABdhPJxXMTAU9VAyqcz2DLiClP4v5hBi3l4rZ5rv3yD8G3CAygmgb+dIftU3eJlkkWezO/d5/a5RcA==
X-Received: by 2002:a17:902:9888:: with SMTP id s8mr8475943plp.111.1597601151922;
        Sun, 16 Aug 2020 11:05:51 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t25sm15871675pfe.76.2020.08.16.11.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 11:05:51 -0700 (PDT)
Subject: Re: [PATCH 2/3] net: lantiq: use netif_tx_napi_add() for TX NAPI
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com
References: <20200815183314.404-1-hauke@hauke-m.de>
 <20200815183314.404-2-hauke@hauke-m.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fc1c2dfd-5a7c-b9cb-8dff-4c4c5fd737fa@gmail.com>
Date:   Sun, 16 Aug 2020 11:05:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815183314.404-2-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/20 11:33 AM, Hauke Mehrtens wrote:
> netif_tx_napi_add() should be used for NAPI in the TX direction instead
> of the netif_napi_add() function.
> 
> Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/ethernet/lantiq_xrx200.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index 1feb9fc710e0..f34e4dc8c661 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -502,7 +502,7 @@ static int xrx200_probe(struct platform_device *pdev)
>  
>  	/* setup NAPI */
>  	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx, 32);
> -	netif_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping, 32);
> +	netif_tx_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping, 32);
>  
>  	platform_set_drvdata(pdev, priv);
>  
> 


This is not a must, simply a matter of (small) optimization in
the very rare case of busy polling users.

The Fixes: tag here is not necessary.
