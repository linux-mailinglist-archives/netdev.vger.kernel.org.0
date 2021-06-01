Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07103396CC1
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhFAFY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhFAFY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:24:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6C9560FEF;
        Tue,  1 Jun 2021 05:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622524967;
        bh=txqQxvFGjKwyaUBubgFI9hHf/wKKpUlCVZDn/K9hQgE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KQ1hoofxcMEiyFa4vlWDKz4h+820ePXF5onuHahNO3W+1dGKv6l7WkGxeiWGD4ybQ
         yXqeftPF4biyCD4VKfOUYCAh/y2ez1Zl45BnCuBuBqdaYgNMnGp8NgbdU3Loy9JQ7Q
         UmjxG8gbAuxUeZWFSKBejsYLXfs0E17m5u4lKAPkRrShryK3aib52F2DUqcNYq9VHK
         hHUR6InaC7EVB8dAKhorw5O7LgNwQCMjZKyfIQMkfYGt6H/QtSkTMUVocHBXdeJz3N
         H8A+zZUo0CER7Gr4wgg/wB4micsJRohLb4cDVZJfk2s4tdSCJomdpzjFH+dlIpzziC
         Towmbe1KBC9eg==
Date:   Mon, 31 May 2021 22:22:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     pgwipeout@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: initialize ge and fe variables
Message-ID: <20210531222246.47508d84@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210530192943.2556076-1-trix@redhat.com>
References: <20210530192943.2556076-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 May 2021 12:29:43 -0700 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Static analysis reports this issue
> /motorcomm.c:83:2: warning: variable 'ge' is used uninitialized
>   whenever switch default is taken [-Wsometimes-uninitialized]
>         default: /* leave everything alone in other modes */
>         ^~~~~~~
> drivers/net/phy/motorcomm.c:87:85: note: uninitialized use
>   occurs here
>         ret = __phy_modify(phydev, YT8511_PAGE,
> 	  (YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN), ge);
>                                                      ^~
> 
> __phy_modify() calls __mdiobus_modify_changed(.., mask, set)
> 
> 	new = (ret & ~mask) | set;
> 	if (new == ret)
> 		return 0;
> 
> 	ret = __mdiobus_write(bus, addr, regnum, new);
> 
> Since 'ge/set' is or-ed in, it is safe to initialize it to 0
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/phy/motorcomm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> index 796b68f4b499..53b2906c54ef 100644
> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -50,7 +50,7 @@ static int yt8511_write_page(struct phy_device *phydev, int page)
>  
>  static int yt8511_config_init(struct phy_device *phydev)
>  {
> -	unsigned int ge, fe;
> +	unsigned int ge = 0, fe = 0;
>  	int ret, oldpage;
>  
>  	/* set clock mode to 125mhz */

I believe this was fixed by just-applied commit 0cc8bddb5b06 ("net: phy:
abort loading yt8511 driver in unsupported modes").
