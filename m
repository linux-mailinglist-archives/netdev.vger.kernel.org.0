Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697DE21134F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgGATLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgGATLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 15:11:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD3F20720;
        Wed,  1 Jul 2020 19:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593630692;
        bh=X9dPdF+r6EcEwraYNG+BnVk0XBlLBKkHE6QCDWwdNGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rWRrWPUuWgIfXMa2t1esFbO4pFlKOL2nu1vNVkFB4ZxTVyCZA29cKrRvAd0vv45xG
         48EtgV+Go1wkfDUrMT8k7yf743mD4VCm+r8K26s5kXrSb4bSZ4gPqgngvYboZa3+NP
         Di0SEo4ui1vCyFI3Osbbeq07hDt7CuC3a2bU60Co=
Date:   Wed, 1 Jul 2020 12:11:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 12/15] sfc_ef100: add EF100 to NIC-revision
 enumeration
Message-ID: <20200701121131.56e456c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f03e0e84-4c8f-8e1e-a0c4-d8454daf9813@solarflare.com>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
        <f03e0e84-4c8f-8e1e-a0c4-d8454daf9813@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 15:55:10 +0100 Edward Cree wrote:
> Also, condition on revision in ethtool drvinfo: if rev is EF100, then
>  we must be the sfc_ef100 driver.  (We can't rely on KBUILD_MODNAME
>  any more, because ethtool_common.o gets linked into both drivers.)
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/ethtool_common.c | 5 ++++-
>  drivers/net/ethernet/sfc/nic_common.h     | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
> index 37a4409e759e..926deb22ee67 100644
> --- a/drivers/net/ethernet/sfc/ethtool_common.c
> +++ b/drivers/net/ethernet/sfc/ethtool_common.c
> @@ -104,7 +104,10 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
>  {
>  	struct efx_nic *efx = netdev_priv(net_dev);
>  
> -	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> +	if (efx->type->revision == EFX_REV_EF100)
> +		strlcpy(info->driver, "sfc_ef100", sizeof(info->driver));
> +	else
> +		strlcpy(info->driver, "sfc", sizeof(info->driver));

ethtool info -> driver does not seem like an appropriate place to
report hardware version.

>  	strlcpy(info->version, EFX_DRIVER_VERSION, sizeof(info->version));
>  	efx_mcdi_print_fwver(efx, info->fw_version,
>  			     sizeof(info->fw_version));
> diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
> index 813f288ab3fe..e04b6817cde3 100644
> --- a/drivers/net/ethernet/sfc/nic_common.h
> +++ b/drivers/net/ethernet/sfc/nic_common.h
> @@ -21,6 +21,7 @@ enum {
>  	 */
>  	EFX_REV_SIENA_A0 = 3,
>  	EFX_REV_HUNT_A0 = 4,
> +	EFX_REV_EF100 = 5,
>  };
>  
>  static inline int efx_nic_rev(struct efx_nic *efx)
> 

