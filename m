Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CABB2A6F9D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgKDVZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731495AbgKDVZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 16:25:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 120192087C;
        Wed,  4 Nov 2020 21:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604525127;
        bh=VXjVjPf6AWvvmAfTIWWkJSJwojVzbmNen0kG7NYrvVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NuXtV+gaETRxiU8wEwsOcz1U4na7XD/4GmLfp2NqEsUqPk6r3VoAPe3ywZoAInup5
         EplIXSlam0HAIe4cXODT/F1k5hclfcJyc8mYDgmQDaOBmMYS3KFjsIwdlMlDzt2tU3
         jUmBAPeSU+oIPWGBkh7PAeIr9N7G7wO1sBX7eyPU=
Date:   Wed, 4 Nov 2020 13:25:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
Message-ID: <20201104132521.2f7c3690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104102141.3489-1-tariqt@nvidia.com>
References: <20201104102141.3489-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 12:21:41 +0200 Tariq Toukan wrote:
> With NETIF_F_HW_TLS_TX packets are encrypted in HW. This cannot be
> logically done when HW_CSUM offload is off.

Right. Do you expect drivers to nack clearing NETIF_F_HW_TLS_TX when
there are active connections, then?  I don't think NFP does.  We either
gotta return -EBUSY when there are offloaded connections, or at least
clearly document the expected behavior.

> Fixes: 2342a8512a1e ("net: Add TLS TX offload features")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Boris Pismenny <borisp@nvidia.com>

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 82dc6b48e45f..5f72ea17d3f7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9588,6 +9588,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
>  		}
>  	}
>  
> +	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_HW_CSUM)) {
> +		netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
> +		features &= ~NETIF_F_HW_TLS_TX;
> +	}
