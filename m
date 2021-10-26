Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2102543BB51
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhJZUCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231703AbhJZUCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 16:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D275060200;
        Tue, 26 Oct 2021 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635278377;
        bh=9yvP/Mku05mjwGEffiQM/MQYBBjQLlgIiuut1zNScQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tiwfrVTvvl3aAfbBbDgyVCiEkCR98YxUAyE5NH+74g/WvI8TOIY9FOUObBVlo53ky
         8LMgyWwHgYvAjrg7OdcrbCVHXfTxAyYYGzkDNvCMxlYU0dVCplcXtv5/WUqrLDSvY7
         uGJZhPivrX8x+i3gQQ+78k5c/W7ol/KjRZvXKn3qF9muBBDTfOKKIzT71PU2wV6+qX
         XDNgiWuT9KfxoIj08lSWxl7xhAzJo8YNaWgEa+DKnOGTHv5Qt/29Ah7/UHJpqW1riV
         lSOXENkpgbzm99m4f5nwOzs3SLyekJ38jHSinXwnw6hzmCu7uoVx3UtEMaRG/2h9tS
         DaaXaLkSyrd4Q==
Date:   Tue, 26 Oct 2021 12:59:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH net-next] net: ax88796c: fix -Wpointer-bool-conversion
 warning
Message-ID: <20211026125935.17caa7b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026195711.16152-1-arnd@kernel.org>
References: <20211026195711.16152-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 21:56:39 +0200 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> ax_local->phydev->advertising is an array, not a pointer, so
> clang points out that checking for NULL is unnecessary:
> 
> drivers/net/ethernet/asix/ax88796c_main.c:851:24: error: address of array 'ax_local->phydev->advertising' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
>         if (ax_local->phydev->advertising &&
>             ~~~~~~~~~~~~~~~~~~^~~~~~~~~~~ ~~
> 
> Fixes: a97c69ba4f30 ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/asix/ax88796c_main.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
> index cfc597f72e3d..846a04922561 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -848,11 +848,10 @@ ax88796c_open(struct net_device *ndev)
>  	/* Setup flow-control configuration */
>  	phy_support_asym_pause(ax_local->phydev);
>  
> -	if (ax_local->phydev->advertising &&
> -	    (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> -			       ax_local->phydev->advertising) ||
> -	     linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> -			       ax_local->phydev->advertising)))
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +			      ax_local->phydev->advertising) ||
> +	    linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +			      ax_local->phydev->advertising))
>  		fc |= AX_FC_ANEG;
>  
>  	fc |= linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,

Same as 971f5c4079ed46a131ad3ac6e684ed056a7777da in net-next, thanks.
