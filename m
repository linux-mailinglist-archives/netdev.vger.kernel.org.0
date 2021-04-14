Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29D835FADA
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352514AbhDNSfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232246AbhDNSfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6079861107;
        Wed, 14 Apr 2021 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618425302;
        bh=C+kNVnSifWU5QxK/9U4nB/COob9vJHKoSmCJpUx56n4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xns6chgKI6aTeq6WBbW3+K5RsWClGN+y9FOyQr1mjpFX29S05jofQiDK4TE7b/Dsw
         gejm72XUHN4dQKVRFKg87kYgbi5xcJV5kWBbu5s3cyMILDEZ+c+CYBkyOJh+SXFrB5
         t6pwGGEvCfm+AR+pVqDO7R03Jh/LUFE7L6HEDpMEXiSuKHnrN5zb2j0R9wUpsSHO8n
         f4JXFWul69YhvAnTSsjQEWybSiY/aY65dOHbanxXo93D2wzx/YqnyFlw10s+G3QC5h
         Sp74knOyNlm81uLh0RraEuFFqMYlIId6nJZHPj2rpFxQ+EMZI3WRmaGVyvjURKpp5O
         rTNZNbTrgPxAw==
Date:   Wed, 14 Apr 2021 11:35:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/16] net/mlx5: E-Switch, let user to enable
 disable metadata
Message-ID: <20210414113501.20cea8ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210414180605.111070-2-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
        <20210414180605.111070-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 11:05:50 -0700 Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> Currently each packet inserted in eswitch is tagged with a internal
> metadata to indicate source vport. Metadata tagging is not always
> needed. Metadata insertion is needed for multi-port RoCE, failover
> between representors and stacked devices. In many other cases,
> metadata enablement is not needed.
> 
> Metadata insertion slows down the packet processing rate of the E-switch
> when it is in switchdev mode.
> 
> Below table show performance gain with metadata disabled for VXLAN
> offload rules in both SMFS and DMFS steering mode on ConnectX-5 device.
> 
> ----------------------------------------------
> | steering | metadata | pkt size | rx pps    |
> | mode     |          |          | (million) |
> ----------------------------------------------
> | smfs     | disabled | 128Bytes | 42        |
> ----------------------------------------------
> | smfs     | enabled  | 128Bytes | 36        |
> ----------------------------------------------
> | dmfs     | disabled | 128Bytes | 42        |
> ----------------------------------------------
> | dmfs     | enabled  | 128Bytes | 36        |
> ----------------------------------------------
> 
> Hence, allow user to disable metadata using driver specific devlink
> parameter. Metadata setting of the eswitch is applicable only for the
> switchdev mode.
> 
> Example to show and disable metadata before changing eswitch mode:
> $ devlink dev param show pci/0000:06:00.0 name esw_port_metadata
> pci/0000:06:00.0:
>   name esw_port_metadata type driver-specific
>     values:
>       cmode runtime value true
> 
> $ devlink dev param set pci/0000:06:00.0 \
> 	  name esw_port_metadata value false cmode runtime
> 
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
