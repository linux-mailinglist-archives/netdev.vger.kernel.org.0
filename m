Return-Path: <netdev+bounces-1354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D59146FD920
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 724802812A2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BDE12B80;
	Wed, 10 May 2023 08:23:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C212F37
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C81FC433EF;
	Wed, 10 May 2023 08:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683707018;
	bh=/gMniZJi49+b3F2CxP49asUyDF2qocWAllpb4xt4W88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b0zsNfI9p+LA76L/lfuEQcl/Z4Bl7vyuvAIAHtCL5/O48gu5Hv+tlKn1GZhIzV71x
	 OaQ2kGN1qr/eQB0taX1xmlss6VFcIseUXLJGQGn1m8LDukVUeI5drXLeodBfQV6CYy
	 lgIU79XxfCWt+XQul+U5tJI7b0LMlGf64ZvVZ7jZyb0+ekB2XYE4gpvYL6BQ30piFD
	 qnWwq1J4KI2oPLZYMfSW4e9S9HbSlaauSwlEngGJ6X5HUKC47VvaUQP9UJFaZ6Roum
	 w6NeAg6eC80Snwn0tdb5GuA1zW9M0GZX48Yav8SWrbuhHzonYzzrKmBZZEYxHv6cxU
	 41nEruMRIKgog==
Date: Wed, 10 May 2023 10:23:28 +0200
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
Subject: Re: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Message-ID: <ZFtUgCVaneGVKBsW@lpieralisi>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-7-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420024037.5921-7-decui@microsoft.com>

On Wed, Apr 19, 2023 at 07:40:37PM -0700, Dexuan Cui wrote:
> Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
> pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
> create_root_hv_pci_bus() and in hv_eject_device_work() to address the
> race between create_root_hv_pci_bus() and hv_eject_device_work(), but it
> turns that grabing the pci_rescan_remove_lock mutex is not enough:
> refer to the earlier fix "PCI: hv: Add a per-bus mutex state_lock".

This is meaningless for a commit log reader, there is nothing to
refer to.

> Now with hbus->state_lock and other fixes, the race is resolved, so

"other fixes" is meaningless too.

Explain the problem and how you fix it (this patch should be split
because the Subject does not represent what you are doing precisely,
see below).

> remove pci_{lock,unlock}_rescan_remove() in create_root_hv_pci_bus():
> this removes the serialization in hv_pci_probe() and hence allows
> async-probing (PROBE_PREFER_ASYNCHRONOUS) to work.
> 
> Add the async-probing flag to hv_pci_drv.

Adding the asynchronous probing should be a separate patch and
I don't think you should send it to stable kernels straight away
because a) it is not a fix b) it can trigger further regressions.

> pci_{lock,unlock}_rescan_remove() in hv_eject_device_work() and in
> hv_pci_remove() are still kept: according to the comment before
> drivers/pci/probe.c: static DEFINE_MUTEX(pci_rescan_remove_lock),
> "PCI device removal routines should always be executed under this mutex".

This patch should be split, first thing is to fix and document what
you are changing for pci_{lock,unlock}_rescan_remove() then add
asynchronous probing.

Lorenzo

> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
> 
> v2:
>   No change to the patch body.
>   Improved the commit message [Michael Kelley]
>   Added Cc:stable
> 
> v3:
>   Added Michael's and Long Li's Reviewed-by.
>   Fixed a typo in the commit message: grubing -> grabing [Thanks, Michael!]
> 
>  drivers/pci/controller/pci-hyperv.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index 3ae2f99dea8c2..2ea2b1b8a4c9a 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -2312,12 +2312,16 @@ static int create_root_hv_pci_bus(struct hv_pcibus_device *hbus)
>  	if (error)
>  		return error;
>  
> -	pci_lock_rescan_remove();
> +	/*
> +	 * pci_lock_rescan_remove() and pci_unlock_rescan_remove() are
> +	 * unnecessary here, because we hold the hbus->state_lock, meaning
> +	 * hv_eject_device_work() and pci_devices_present_work() can't race
> +	 * with create_root_hv_pci_bus().
> +	 */
>  	hv_pci_assign_numa_node(hbus);
>  	pci_bus_assign_resources(bridge->bus);
>  	hv_pci_assign_slots(hbus);
>  	pci_bus_add_devices(bridge->bus);
> -	pci_unlock_rescan_remove();
>  	hbus->state = hv_pcibus_installed;
>  	return 0;
>  }
> @@ -4003,6 +4007,9 @@ static struct hv_driver hv_pci_drv = {
>  	.remove		= hv_pci_remove,
>  	.suspend	= hv_pci_suspend,
>  	.resume		= hv_pci_resume,
> +	.driver = {
> +		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
> +	},
>  };
>  
>  static void __exit exit_hv_pci_drv(void)
> -- 
> 2.25.1
> 

