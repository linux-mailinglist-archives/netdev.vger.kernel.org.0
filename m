Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A187A3AA4E7
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhFPUFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:05:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41314 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhFPUE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lY2yufkq18mI0lFf+6rh51y7yUvqmPa0/Sx+3+Q5R9o=; b=FhWLelQkqzJ6A3/rWA6rm8v/zY
        lBEkFB/VR6RxGTC6zXW6P/DKtLNKhOayoNVaQVPzTlnUIpDknb4JLR3CDIDDYv07wzasJbuNxPscW
        Jdp8tKbhUrVSWvhsAJVljTJZow2GXvNs9+s8rRCo5Z2oG25Gt0X2RgqQajXXAFnyScQ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltbkJ-009lxl-JW; Wed, 16 Jun 2021 22:02:43 +0200
Date:   Wed, 16 Jun 2021 22:02:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Lee Jones <lee.jones@linaro.org>, EJ Hsu <ejh@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
Message-ID: <YMpY49PLAyObVxC4@lunn.ch>
References: <20210616195303.1231429-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616195303.1231429-1-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 12:53:03PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.
> 
> The memcpy() is copying the entire structure, not just the first array.
> Adjust the source argument so the compiler can do appropriate bounds
> checking.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/usb/r8152.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 85039e17f4cd..5f08720bf1c9 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -8678,7 +8678,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
>  {
>  	switch (stringset) {
>  	case ETH_SS_STATS:
> -		memcpy(data, *rtl8152_gstrings, sizeof(rtl8152_gstrings));
> +		memcpy(data, rtl8152_gstrings, sizeof(rtl8152_gstrings));
>  		break;

Is this correct? The call is supposed to return all the statistic
strings, which would be the entire structure.

	  Andrew
