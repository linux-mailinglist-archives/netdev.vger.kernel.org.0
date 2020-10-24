Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24607297A3F
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758827AbgJXBwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758785AbgJXBwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:52:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D754522280;
        Sat, 24 Oct 2020 01:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603504362;
        bh=JDNGC+MzUiSUxxaAunsJwvbECn/UpQnT0XYJAqbRsfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=trZQiy/L3FIVtYHQRgxWTYKg93zsg3SUWe5szm4SROiAXG3LYs1sHd19d6o6RzyLr
         LYGVUrjQmvq+px96U7gfPDCfDt44GqWUJ2e/xafW2rkOc1Mmdq/nnWzFM1JZiEB/z6
         8T4HxuI5zfJ8O3Iczn7u8ZCfYhip4xRvI+dTsVOw=
Date:   Fri, 23 Oct 2020 18:52:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net v2 1/7] cxgb4/ch_ktls: decrypted bit is not enough
Message-ID: <20201023185241.03830682@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023053134.26021-2-rohitm@chelsio.com>
References: <20201023053134.26021-1-rohitm@chelsio.com>
        <20201023053134.26021-2-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 11:01:28 +0530 Rohit Maheshwari wrote:
> +#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
> +		    cxgb4_is_ktls_skb(skb) ||
> +#endif
>  		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
>  			txq = txq % pi->nqsets;
>  
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
> index b169776ab484..65a8d4d4c6e5 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
> @@ -493,6 +493,13 @@ struct cxgb4_uld_info {
>  #endif
>  };
>  
> +#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
> +static inline bool cxgb4_is_ktls_skb(struct sk_buff *skb)
> +{
> +	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
> +}
> +#endif

There is no need for those ifdefs.
