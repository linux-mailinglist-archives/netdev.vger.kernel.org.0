Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77072AE44C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbgKJXof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgKJXof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:44:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C790F207E8;
        Tue, 10 Nov 2020 23:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605051875;
        bh=o6wNEbY5NpvlgutDr4f6xOf9o2yFKWKhyUaNDZd43Po=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G08VYt1IAM8+TmQDaCalbJiRJHNkEJ244cezVDDAzskY1G6ixtahpFNwnVv6CnWiY
         K0X13eoUwrvZ34RLoP2VrAxBNRwE2kJEijM03b5e4+5W1p8e3HUQ1CkudXp+Q6yWJ5
         5EtL0Nm2xrr3e5Jd8JvkaJGfIKTY+FrD2xeqRqYU=
Date:   Tue, 10 Nov 2020 15:44:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net V2] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
Message-ID: <20201110154428.06094336@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201108144309.31699-1-tariqt@nvidia.com>
References: <20201108144309.31699-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Nov 2020 16:43:09 +0200 Tariq Toukan wrote:
> @@ -528,3 +528,7 @@ Drivers should ignore the changes to TLS the device feature flags.
>  These flags will be acted upon accordingly by the core ``ktls`` code.
>  TLS device feature flags only control adding of new TLS connection
>  offloads, old connections will remain active after flags are cleared.
> +
> +The TLS encryption cannot be offloaded to device if checksum calculation
> +is not, hence the TLS TX device feature flag is cleared when HW_CSUM is
> +disabled.

This makes it sound like the driver will fall back to software crypto
if L4 csum offload gets disabled, is this your intention?

Seems at odds with the paragraph above it.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9499a414d67e..26c9b059cade 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9584,6 +9584,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
>  		}
>  	}
>  
> +	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_HW_CSUM)) {
> +		netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
> +		features &= ~NETIF_F_HW_TLS_TX;
> +	}
> +
>  	return features;
>  }
>  

