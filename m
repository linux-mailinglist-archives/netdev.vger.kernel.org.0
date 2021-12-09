Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B02446E0E0
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhLICd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:33:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47020 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhLICd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:33:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5EFACE24A0
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 02:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B5CC00446;
        Thu,  9 Dec 2021 02:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639016990;
        bh=ZYIL0348x5kQmaFciKewnc3I03qyTv6OH3VskqIYo9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DKX4+RO9ey2i9xRnWmF759pMrczaUtjrfnmZVI7xLf2LBu9nh0sJOIbSNHVRR6RXN
         e3creelXasLppEjXtNkyfF0CVfhslmXEurZ4BaGa5W9K3KykvzlIfo3/IAc4d390g5
         NHXZu5BzUVydDZXmhLanXltY1K4YbGL/yB/AmEzE8OSuRW4ry6Lvec3/QTD3Ed5NBb
         gwdSeYko3A4DHdn/qRUU4RuXg/HaSuyDKQtP3rYQCNeqiS2u87CNeznL2FVICzYT0q
         g7w1g5oSA1PTYIymihCdTOMTh0/XSCXXSwck5cF6ay5szHOgfDUvZoLVJ9KuwQZrSN
         o63xT/xqKEI3A==
Date:   Wed, 8 Dec 2021 18:29:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] ethernet: fman: add missing put_device() call in
 mac_probe()
Message-ID: <20211208182949.69733b8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1638881761-3262-1-git-send-email-wangqing@vivo.com>
References: <1638881761-3262-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 04:56:00 -0800 Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> of_find_device_by_node() takes a reference to the embedded struct device 
> which needs to be dropped when error return.
> 
> Add a jump target to fix the exception handling for this 
> function implementation.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

The entire mac_dev->port[] handling seems entirely pointless and leaky. 
Nothing ever reads the mac_dev->port array. We should remove it
completely.

> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
> index d9fc5c4..5180121
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -668,7 +668,7 @@ static int mac_probe(struct platform_device *_of_dev)
>  	if (err) {
>  		dev_err(dev, "failed to read cell-index for %pOF\n", dev_node);
>  		err = -EINVAL;
> -		goto _return_of_node_put;
> +		goto _return_of_put_device;
>  	}
>  	/* cell-index 0 => FMan id 1 */
>  	fman_id = (u8)(val + 1);
> @@ -677,7 +677,7 @@ static int mac_probe(struct platform_device *_of_dev)
>  	if (!priv->fman) {
>  		dev_err(dev, "fman_bind(%pOF) failed\n", dev_node);
>  		err = -ENODEV;
> -		goto _return_of_node_put;
> +		goto _return_of_put_device;
>  	}
>  
>  	of_node_put(dev_node);
> @@ -758,7 +758,7 @@ static int mac_probe(struct platform_device *_of_dev)
>  			dev_err(dev, "of_find_device_by_node(%pOF) failed\n",
>  				dev_node);
>  			err = -EINVAL;
> -			goto _return_of_node_put;
> +			goto _return_of_put_device;
>  		}
>  
>  		mac_dev->port[i] = fman_port_bind(&of_dev->dev);
> @@ -766,7 +766,7 @@ static int mac_probe(struct platform_device *_of_dev)
>  			dev_err(dev, "dev_get_drvdata(%pOF) failed\n",
>  				dev_node);
>  			err = -EINVAL;
> -			goto _return_of_node_put;
> +			goto _return_of_put_device;
>  		}
>  		of_node_put(dev_node);
>  	}
> @@ -863,6 +863,8 @@ static int mac_probe(struct platform_device *_of_dev)
>  
>  	goto _return;
>  
> +_return_of_put_device:
> +	put_device(&of_dev->dev);
>  _return_of_node_put:
>  	of_node_put(dev_node);
>  _return_of_get_parent:

