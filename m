Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FF22E0257
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgLUWKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLUWKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 17:10:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E28BE22A85;
        Mon, 21 Dec 2020 22:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608588601;
        bh=uDT47mqlwZJogTvzDKTcNjDb5AtGGqiU+C0elNRtlUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BEoPU/HmBBjQweFz6iJ5YNRI+fF9rXp8BVBPrL0gvz8h8Qp/q7n0hw358NiGxm94H
         mMdgMphnGCXZWZS8q2gfonobPE/pKTT30kH4dzjs/h8+b1e8Kw+UU0HSHEseDB3JWN
         nFGErKGVeBHOhKCNwVlo2h0SZ9t0rjmmvvmW2mpNuy6GXxlPexI4myc3F/2q3tOoI3
         91je3V4hNVMIv1uHidqVt2Fzf17bJId4c0nPlpcij+0U9XnZxUu54rpd4odOxnEycU
         h43qYLu5R54xsdBi+0YYBYVLGuAQh23CHEMPgNP3ZUBfUiucktqCD5tsWKMrE+u3PA
         4amqDED6SP1zw==
Date:   Mon, 21 Dec 2020 14:09:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hongwei Zhang <hongweiz@ami.com>
Cc:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: Re: [Aspeed,ncsi-rx, v2 1/1] net: ftgmac100: Fix AST2600 EVB NCSI
 RX issue
Message-ID: <20201221140959.793449e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201221194026.30715-2-hongweiz@ami.com>
References: <20201215192323.24359-1-hongweiz@ami.com>
        <20201221194026.30715-2-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Dec 2020 14:40:26 -0500 Hongwei Zhang wrote:
> When FTGMAC100 driver is used on other NCSI Ethernet controllers, few

When you say NCSI Ethernet controller here you mean the main system
NIC, right? The MAC on the NCSI side is FTGMAC100, correct?

In that case I'm not sure how user is supposed to control this setting
at build time. The system NIC is often pluggable on the PCIe bus, and
can be changed at will.

> controllers have compatible issue, removing FTGMAC100_RXDES0_RX_ERR bit
> from RXDES0_ANY_ERROR can fix the issue.
> 
> Fixes: 7ee2d5b4d4340353 ("ARM: dts: nuvoton: Add Fii Kudo system")

Please fix the commit hash, this hash does not exist upstream:

Commit: 8711d4ef64fa ("net: ftgmac100: Fix AST2600 EVB NCSI RX issue")
	Fixes tag: Fixes: 7ee2d5b4d4340353 ("ARM: dts: nuvoton: Add Fii Kudo system")
	Has these problem(s):
		- Target SHA1 does not exist

> Signed-off-by: Hongwei Zhang <hongweiz@ami.com>
> ---
>  drivers/net/ethernet/faraday/Kconfig     | 9 +++++++++
>  drivers/net/ethernet/faraday/ftgmac100.h | 8 ++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/drivers/net/ethernet/faraday/Kconfig b/drivers/net/ethernet/faraday/Kconfig
> index c2677ec0564d..ccd0c30be0db 100644
> --- a/drivers/net/ethernet/faraday/Kconfig
> +++ b/drivers/net/ethernet/faraday/Kconfig
> @@ -38,4 +38,13 @@ config FTGMAC100
>  	  from Faraday. It is used on Faraday A369, Andes AG102 and some
>  	  other ARM/NDS32 SoC's.
>  
> +config FTGMAC100_RXDES0_RX_ERR_CHK
> +	bool "Include FTGMAC100_RXDES0_RX_ERR in RXDES0_ANY_ERROR"
> +	default y
> +	depends on FTGMAC100
> +	help
> +	  Say N here if the NCSI controller on your platform has compatible
> +	  issue with FTGMAC100, thus always trigger RXDES0_RX_ERR. Exclude
> +	  this bit can fix the issue.
> +
>  endif # NET_VENDOR_FARADAY
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.h b/drivers/net/ethernet/faraday/ftgmac100.h
> index 63b3e02fab16..59e1bd52d261 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.h
> +++ b/drivers/net/ethernet/faraday/ftgmac100.h
> @@ -251,12 +251,20 @@ struct ftgmac100_rxdes {
>  #define FTGMAC100_RXDES0_RXPKT_RDY	(1 << 31)
>  
>  /* Errors we care about for dropping packets */
> +#ifdef CONFIG_FTGMAC100_RXDES0_RX_ERR_CHK
>  #define RXDES0_ANY_ERROR		( \
>  	FTGMAC100_RXDES0_RX_ERR		| \
>  	FTGMAC100_RXDES0_CRC_ERR	| \
>  	FTGMAC100_RXDES0_FTL		| \
>  	FTGMAC100_RXDES0_RUNT		| \
>  	FTGMAC100_RXDES0_RX_ODD_NB)
> +#else
> +#define RXDES0_ANY_ERROR		( \
> +	FTGMAC100_RXDES0_CRC_ERR	| \
> +	FTGMAC100_RXDES0_FTL		| \
> +	FTGMAC100_RXDES0_RUNT		| \
> +	FTGMAC100_RXDES0_RX_ODD_NB)
> +#endif
>  
>  #define FTGMAC100_RXDES1_VLANTAG_CI	0xffff
>  #define FTGMAC100_RXDES1_PROT_MASK	(0x3 << 20)

