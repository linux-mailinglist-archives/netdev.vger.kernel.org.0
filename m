Return-Path: <netdev+bounces-5258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B37E4710723
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43DF31C20E3F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834BDD2E6;
	Thu, 25 May 2023 08:16:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B304D2E5
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18EDC433EF;
	Thu, 25 May 2023 08:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685002574;
	bh=K2jAHhKKwgAET5fyc2ERiEaO3ErwK7xD3nttPnJaXfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YGJ1dimBfF/DWboT1zfSrn474WMxAVgWF28GxGUOFEjBEw+reuo6isz3sWjMK2G7R
	 qm8UAEInwNMyeYBhRCtjl+aeqZzfsfsGnfRyrFtr6srnsr/AdGSceiunkSB7sFmwUQ
	 ahNXN9Mx5UNo2rgPPeg3EjbMqvWmyopyDSkW+eGiEHhX2t3h2diyfpoiWEfxVw11MV
	 MNJdU01N9f+9DzsX7ZzxCmRrZPhaY7/l0zVVRLUXMxAiA0mG6we58jB/X+x0eYcSrY
	 dm/BF+QoQH/A9uiFPHIdlPv8NeN0VWijfkv6GDzRyfY3vzga5Lj2jcLLE4/O5DhNtR
	 Dt58Pxq0LUcVA==
Date: Thu, 25 May 2023 10:16:03 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: bhelgaas@google.com, davem@davemloft.net, edumazet@google.com,
	haiyangz@microsoft.com, jakeo@microsoft.com, kuba@kernel.org,
	kw@linux.com, kys@microsoft.com, leon@kernel.org,
	linux-pci@vger.kernel.org, mikelley@microsoft.com,
	pabeni@redhat.com, robh@kernel.org, saeedm@nvidia.com,
	wei.liu@kernel.org, longli@microsoft.com, boqun.feng@gmail.com,
	ssengar@microsoft.com, helgaas@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	josete@microsoft.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/6] PCI: hv: Remove the useless hv_pcichild_state
 from struct hv_pci_dev
Message-ID: <ZG8ZQ1U4kmGBVe4/@lpieralisi>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-4-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420024037.5921-4-decui@microsoft.com>

On Wed, Apr 19, 2023 at 07:40:34PM -0700, Dexuan Cui wrote:
> The hpdev->state is never really useful. The only use in
> hv_pci_eject_device() and hv_eject_device_work() is not really necessary.
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
> 
> v2:
>   No change to the patch body.
>   Added Cc:stable
> 
> v3:
>   Added Michael's Reviewed-by.
> 
>  drivers/pci/controller/pci-hyperv.c | 12 ------------
>  1 file changed, 12 deletions(-)

Is this patch _required_ for subsequent fixes ? It is not a fix itself
so I am asking.

Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index 1b11cf7391933..46df6d093d683 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -553,19 +553,10 @@ struct hv_dr_state {
>  	struct hv_pcidev_description func[];
>  };
>  
> -enum hv_pcichild_state {
> -	hv_pcichild_init = 0,
> -	hv_pcichild_requirements,
> -	hv_pcichild_resourced,
> -	hv_pcichild_ejecting,
> -	hv_pcichild_maximum
> -};
> -
>  struct hv_pci_dev {
>  	/* List protected by pci_rescan_remove_lock */
>  	struct list_head list_entry;
>  	refcount_t refs;
> -	enum hv_pcichild_state state;
>  	struct pci_slot *pci_slot;
>  	struct hv_pcidev_description desc;
>  	bool reported_missing;
> @@ -2750,8 +2741,6 @@ static void hv_eject_device_work(struct work_struct *work)
>  	hpdev = container_of(work, struct hv_pci_dev, wrk);
>  	hbus = hpdev->hbus;
>  
> -	WARN_ON(hpdev->state != hv_pcichild_ejecting);
> -
>  	/*
>  	 * Ejection can come before or after the PCI bus has been set up, so
>  	 * attempt to find it and tear down the bus state, if it exists.  This
> @@ -2808,7 +2797,6 @@ static void hv_pci_eject_device(struct hv_pci_dev *hpdev)
>  		return;
>  	}
>  
> -	hpdev->state = hv_pcichild_ejecting;
>  	get_pcichild(hpdev);
>  	INIT_WORK(&hpdev->wrk, hv_eject_device_work);
>  	queue_work(hbus->wq, &hpdev->wrk);
> -- 
> 2.25.1
> 

