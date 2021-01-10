Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C3E2F04CD
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 03:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAJCS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 21:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbhAJCS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 21:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BACE22CA0;
        Sun, 10 Jan 2021 02:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610245065;
        bh=wdvqF4R6SrNS4g9bhmZpyk/YYNx95NX6Q8Mw5dY0uM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JZMkBnOirvR/25hpFcYEbNxaCdpf95jhuqqFHIASZSgS54ov3dSlEcA8t4R+gVZFc
         NYvL/g1ApoVI6ueKNr94zHlWzGxpLAWVJ79z4oOUZTj4o1vrwuL5QTei3eDZKygeBQ
         xTn3qg0Lr/DRHEy23QIyFu7UaZwodj1XauiJklFoSw7peXJ0AjKqNVd3BrWFmLcpMT
         NWkq6sniF/FpeehScTPuzgznIV6DcmGbwOHZ4My/pXggWr5+7bA5BIsxXbJ6suV4Kv
         T6sveAGJ/UkLjywwhIH9Ews0UnlxX4GjN+U18wVVv6wcmpJgnpkcjfcqhJ/KxJxoGQ
         /+0rDT0JcjZJA==
Date:   Sat, 9 Jan 2021 18:17:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: deprecate support for
 RTL_GIGA_MAC_VER_27
Message-ID: <20210109181744.6b53c946@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fb6ff074-a9c3-94ce-0636-52276d8604f2@gmail.com>
References: <fb6ff074-a9c3-94ce-0636-52276d8604f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 13:24:16 +0100 Heiner Kallweit wrote:
> RTL8168dp is ancient anyway, and I haven't seen any trace of its early
> version 27 yet. This chip versions needs quite some special handling,
> therefore it would facilitate driver maintenance if support for it
> could be dropped. For now just disable detection of this chip version.
> If nobody complains we can remove support for it in the near future.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index e72d8f3ae..f94965615 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -1962,7 +1962,11 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
>  		{ 0x7c8, 0x280,	RTL_GIGA_MAC_VER_26 },
>  
>  		/* 8168DP family. */
> -		{ 0x7cf, 0x288,	RTL_GIGA_MAC_VER_27 },
> +		/* It seems this early RTL8168dp version never made it to
> +		 * the wild. Let's see whether somebody complains, if not
> +		 * we'll remove support for this chip version completely.
> +		 * { 0x7cf, 0x288,      RTL_GIGA_MAC_VER_27 },
> +		 */
>  		{ 0x7cf, 0x28a,	RTL_GIGA_MAC_VER_28 },
>  		{ 0x7cf, 0x28b,	RTL_GIGA_MAC_VER_31 },
>  

No objection to deprecating the support (although quick grep does not
reveal the special handling you speak of), but would it make sense to
also print some message to save the potential user out there debug time?
Something like:

	dev_err(dev, "support for device has been removed please contact <email>");

?
