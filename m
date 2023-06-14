Return-Path: <netdev+bounces-10855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E778B7308CF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:53:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E0121C20C9C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFCE11CBB;
	Wed, 14 Jun 2023 19:53:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50AF11CAD
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1596C433C9;
	Wed, 14 Jun 2023 19:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686772386;
	bh=gyq+c814bbzkOBJezTg1pBWbrnl02FG9KGt6qi2fNzw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=X01sa44NvfCG0AwAz9IdGtFQzaUMki98jIzLBjIp1GDNrjH3mfoaNT9xmmekaIBcz
	 fma0mPkFrHQbekgIpAmG/URzPThk/RMXdVIaJXS2MVoKd9Da4YlhZmlRb0OjQYnawZ
	 4VIah7XFAcspy5y3HXz9Pv77QeQkdINofN7pEIiRRiESlhdKSdt9O2xdosODXlPGlN
	 zLi1NCHYNgDdnzep/WLBWcHJzCAxAINaAPkbjb1kl9vIF5U3lrUfmC5yUN8F4a2+rN
	 btbayFQfXecU8k6hwroNI4BaZCQt1QifmBWY1DA/Q5r9hKsBdCFKe7M/zpfwnqE4nt
	 hBNOZLml+l/dg==
Date: Wed, 14 Jun 2023 12:53:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, sburla@marvell.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeon_ep: Add missing check for ioremap
Message-ID: <20230614125304.294dd2ef@kernel.org>
In-Reply-To: <20230614032347.32940-1-jiasheng@iscas.ac.cn>
References: <20230614032347.32940-1-jiasheng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 11:23:47 +0800 Jiasheng Jiang wrote:
> @@ -981,6 +981,9 @@ int octep_device_setup(struct octep_device *oct)
>  		oct->mmio[i].hw_addr =
>  			ioremap(pci_resource_start(oct->pdev, i * 2),
>  				pci_resource_len(oct->pdev, i * 2));
> +		if (!oct->mmio[i].hw_addr)
> +			goto unsupported_dev;
> +
>  		oct->mmio[i].mapped = 1;
>  	}
>  
> @@ -1015,8 +1018,8 @@ int octep_device_setup(struct octep_device *oct)
>  	return 0;
>  
>  unsupported_dev:
> -	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
> -		iounmap(oct->mmio[i].hw_addr);
> +	for (j = 0; j < i; j++)
> +		iounmap(oct->mmio[j].hw_addr);

Assuming @i is not changed by the rest of the function is a bit fragile.

Better way of handling this situation is:

unsupported_dev:
	i = OCTEP_MMIO_REGIONS;
unmap_prev:
	while (i--)
		iounmap(oct->mmio[i].hw_addr);

and jump to unmap_prev
-- 
pw-bot: cr

