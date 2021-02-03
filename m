Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B970C30E6D5
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhBCXLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233492AbhBCXJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:09:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACFB464DD4;
        Wed,  3 Feb 2021 23:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612393724;
        bh=zF0N0vZDcw3ZbALDaZ0Ew/YIjGDUVRBQUNcJcxF9VbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gbT0P39ctE7ncr9QsKlIxNpGeFaWA65KlBa1MfuxxkclfqqDVRu+z0H1mMyC3ua+z
         wmk4iwk51+leqnp7U8Sm49rhQ3izKPgskWvQILwjD9ZcFQSfJh9df0wMm9afd0cs/l
         l7xddjpE13iP6tH1UEI49ombtl69Lb7+cioy7185mFQY5lHMtyDjOPt1967KojCxgV
         Bc3gwC6YjdcNzFRc5BhVFw9Rxll6bYNM4B0v5iMiz5dldO2YNUniH5AzF658ZQpOkP
         CIoB7t+/C031umK6CBAovJ3H1ZptnrpXnuTEAJR9oga0/YlGCoce87TtfscshZ4/YR
         0AEokFpy/QRcw==
Date:   Wed, 3 Feb 2021 15:08:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     bjorn@mork.no, dcbw@redhat.com, netdev@vger.kernel.org,
        carl.yin@quectel.com
Subject: Re: [PATCH net-next v2 1/3] net: mhi: Add RX/TX fixup callbacks
Message-ID: <20210203150843.06506420@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612213542-17257-1-git-send-email-loic.poulain@linaro.org>
References: <1612213542-17257-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please put the maintainers or the list thru which you expect the patch
to be applied in the To: field of your emails.

On Mon,  1 Feb 2021 22:05:40 +0100 Loic Poulain wrote:
> +	if (proto && proto->tx_fixup) {
> +		skb = proto->tx_fixup(mhi_netdev, skb);
> +		if (unlikely(!skb))
> +			goto exit_drop;
> +	}

> @@ -170,7 +193,11 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>  		}
>  
>  		skb_put(skb, mhi_res->bytes_xferd);
> -		netif_rx(skb);
> +
> +		if (proto && proto->rx_fixup)
> +			proto->rx_fixup(mhi_netdev, skb);
> +		else
> +			netif_rx(skb);
>  	}

There us a slight asymmetry between tx_fixup and rx_fixup.
tx_fixup just massages the frame and then mhi_net still takes
care of transmission. On Rx side rx_fixup actually does the
netif_rx(skb). Maybe s/rx_fixup/rx/ ?
