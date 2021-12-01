Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC4464E89
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 14:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349501AbhLANMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 08:12:17 -0500
Received: from marcansoft.com ([212.63.210.85]:33352 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349491AbhLANMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 08:12:17 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 48A9C419B4;
        Wed,  1 Dec 2021 13:08:52 +0000 (UTC)
Subject: Re: [PATCHv3] ethernet: aquantia: Try MAC address from device tree
To:     Tianhao Chai <cth451@gmail.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
References: <20211201025706.GA2181732@cth-desktop-dorm.mad.wi.cth451.me>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <4f496718-a6fb-95af-24e3-8061a0c381c4@marcan.st>
Date:   Wed, 1 Dec 2021 22:08:49 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211201025706.GA2181732@cth-desktop-dorm.mad.wi.cth451.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2021 11.57, Tianhao Chai wrote:
> Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
> card, but instead need to obtain MAC addresses from the device tree. In
> this case the hardware will report an invalid MAC.
> 
> Currently atlantic driver does not query the DT for MAC address and will
> randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
> This patch causes the driver to perfer a valid MAC address from OF (if
> present) over HW self-reported MAC and only fall back to a random MAC
> address when neither of them is valid.
> 
> Signed-off-by: Tianhao Chai <cth451@gmail.com>
> ---
>   .../net/ethernet/aquantia/atlantic/aq_nic.c   | 24 +++++++++++--------
>   1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> index 1acf544afeb4..2a1ab154f681 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> @@ -316,18 +316,22 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
>   	aq_macsec_init(self);
>   #endif
>   
> -	mutex_lock(&self->fwreq_mutex);
> -	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
> -	mutex_unlock(&self->fwreq_mutex);
> -	if (err)
> -		goto err_exit;
> +	if (platform_get_ethdev_address(&self->pdev->dev, self->ndev) != 0) {
> +		// If DT has none or an invalid one, ask device for MAC address
> +		mutex_lock(&self->fwreq_mutex);
> +		err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
> +		mutex_unlock(&self->fwreq_mutex);
>   
> -	eth_hw_addr_set(self->ndev, addr);
> +		if (err)
> +			goto err_exit;
>   
> -	if (!is_valid_ether_addr(self->ndev->dev_addr) ||
> -	    !aq_nic_is_valid_ether_addr(self->ndev->dev_addr)) {
> -		netdev_warn(self->ndev, "MAC is invalid, will use random.");
> -		eth_hw_addr_random(self->ndev);
> +		if (is_valid_ether_addr(addr) &&
> +		    aq_nic_is_valid_ether_addr(addr)) {
> +			eth_hw_addr_set(self->ndev, addr);
> +		} else {
> +			netdev_warn(self->ndev, "MAC is invalid, will use random.");
> +			eth_hw_addr_random(self->ndev);
> +		}
>   	}
>   
>   #if defined(AQ_CFG_MAC_ADDR_PERMANENT)
> 

Reviewed-by: Hector Martin <marcan@marcan.st>

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
