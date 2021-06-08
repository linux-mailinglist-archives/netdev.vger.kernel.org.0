Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5A239F9ED
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhFHPHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:07:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37612 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbhFHPH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:07:29 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lqdIM-00044T-OR; Tue, 08 Jun 2021 15:05:34 +0000
Subject: NAK: [PATCH][next] net: usb: asix: ax88772: Fix less than zero
 comparison of a u16
From:   Colin Ian King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210608145823.159467-1-colin.king@canonical.com>
Message-ID: <26127b07-6f9e-12bb-6d2e-edf6819c08f1@canonical.com>
Date:   Tue, 8 Jun 2021 16:05:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608145823.159467-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/06/2021 15:58, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u16 priv->phy_addr < 0 is always false because
> phy_addr is unsigned. Fix this by assigning the return from the call
> to function asix_read_phy_addr to int ret and using this for the
> less than zero error check comparison.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/usb/asix_devices.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 57dafb3262d9..211c5a87eb15 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -704,9 +704,10 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	struct asix_common_private *priv = dev->driver_priv;
>  	int ret;
>  
> -	priv->phy_addr = asix_read_phy_addr(dev, true);
> -	if (priv->phy_addr < 0)
> +	ret = asix_read_phy_addr(dev, true);
> +	if (ret < 0)
>  		return priv->phy_addr;
> +	priv->phy_addr = ret;
>  
>  	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
>  		 priv->mdio->id, priv->phy_addr);
> 

Wrong commit message. I'll send a new fix.

Colin
