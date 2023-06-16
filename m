Return-Path: <netdev+bounces-11287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9607326B0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC70C1C20F45
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4BCEA4;
	Fri, 16 Jun 2023 05:37:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012A97C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5427C433C0;
	Fri, 16 Jun 2023 05:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686893858;
	bh=iyblhOXf+gZeVRqwoZ1cYwv2FEYhn8/Qs7mY7WB/BNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kHO8LSkPvoF87hWEWNI0ZsoCXHuP2VisPRCgyzgOpVdxSTjo8eoIZxm4NP1UnX3/M
	 PdhQaoMrStEOm+jbTwKX9nKWNm8Q217Y7GtbuCTtMcEo5fFzGnKY9LnW2wcdOf5lTZ
	 zFHKSOmVxEy1tDnUkbo422CrHujlZLkAMzqFjxujEgjxJmdFMLSPhEtMwgNUnI584v
	 SUq15DxAz0UHjDAm1WVAqZR99Q8G8PKzZ7r6nlJ/Lh1oeUsbTY2M6GaMfIoWmaNlC7
	 XmjbI9n5QLF8EOyiNM4Fw3BQs6NMDlZqZXqbrvWhqLSP2fE6m4f9/f57uOoh99vHIK
	 cpf1gAR/PZEqA==
Date: Thu, 15 Jun 2023 22:37:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>, Nikolay Aleksandrov
 <razor@blackwall.org>, Vladimir Oltean <olteanv@gmail.com>
Cc: Ravi Gunasekaran <r-gunasekaran@ti.com>, <davem@davemloft.net>,
 <edumazet@google.com>, <pabeni@redhat.com>, <bigeasy@linutronix.de>,
 <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <rogerq@kernel.org>
Subject: Re: [PATCH v2 net-next] net: hsr: Disable promiscuous mode in
 offload mode
Message-ID: <20230615223736.0577fb11@kernel.org>
In-Reply-To: <20230614114710.31400-1-r-gunasekaran@ti.com>
References: <20230614114710.31400-1-r-gunasekaran@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 17:17:10 +0530 Ravi Gunasekaran wrote:
> When port-to-port forwarding for interfaces in HSR node is enabled,
> disable promiscuous mode since L2 frame forward happens at the
> offloaded hardware.
> 
> Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Bridge folks any thoughts on this? Is this the behavior bridge has 
and if not should we try to align the two?

> Changes from v1:
> ===============
> * Changed the data type of "fwd_offloaded" from "unsigned int" to "bool"
>   and moved it below "net_id" struct member as per Paolo's comment.
> * Collected Reviewed-by tag from v1 patch.
> 
> v1: https://lore.kernel.org/all/20230612093933.13267-1-r-gunasekaran@ti.com/
> 
>  net/hsr/hsr_device.c |  5 +++++
>  net/hsr/hsr_main.h   |  1 +
>  net/hsr/hsr_slave.c  | 15 +++++++++++----
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index 5a236aae2366..306f942c3b28 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -531,6 +531,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
>  	if (res)
>  		goto err_add_master;
>  
> +	/* HSR forwarding offload supported in lower device? */
> +	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
> +	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
> +		hsr->fwd_offloaded = true;
> +
>  	res = register_netdevice(hsr_dev);
>  	if (res)
>  		goto err_unregister;
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index 5584c80a5c79..6851e33df7d1 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -208,6 +208,7 @@ struct hsr_priv {
>  	u8 net_id;		/* for PRP, it occupies most significant 3 bits
>  				 * of lan_id
>  				 */
> +	bool fwd_offloaded;	/* Forwarding offloaded to HW */
>  	unsigned char		sup_multicast_addr[ETH_ALEN] __aligned(sizeof(u16));
>  				/* Align to u16 boundary to avoid unaligned access
>  				 * in ether_addr_equal
> diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
> index b70e6bbf6021..e5742f2a2d52 100644
> --- a/net/hsr/hsr_slave.c
> +++ b/net/hsr/hsr_slave.c
> @@ -131,9 +131,14 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
>  	struct hsr_port *master;
>  	int res;
>  
> -	res = dev_set_promiscuity(dev, 1);
> -	if (res)
> -		return res;
> +	/* Don't use promiscuous mode for offload since L2 frame forward
> +	 * happens at the offloaded hardware.
> +	 */
> +	if (!port->hsr->fwd_offloaded) {
> +		res = dev_set_promiscuity(dev, 1);
> +		if (res)
> +			return res;
> +	}
>  
>  	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
>  	hsr_dev = master->dev;
> @@ -152,7 +157,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
>  fail_rx_handler:
>  	netdev_upper_dev_unlink(dev, hsr_dev);
>  fail_upper_dev_link:
> -	dev_set_promiscuity(dev, -1);
> +	if (!port->hsr->fwd_offloaded)
> +		dev_set_promiscuity(dev, -1);
> +
>  	return res;
>  }
>  


