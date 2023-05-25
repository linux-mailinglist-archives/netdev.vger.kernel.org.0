Return-Path: <netdev+bounces-5291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D06C27109AA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:16:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77EC21C20E9F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00FBE561;
	Thu, 25 May 2023 10:16:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2BAD2EF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F94C433EF;
	Thu, 25 May 2023 10:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685009763;
	bh=7bXHnIYWtYF8xI7DWrHnG3fKIHxxxog4xxhaz5xiH1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QALVqdn7P/EEvs1ccrAeWVErDIOt1p3IKbax3xk3ikHcjvnMA3VMa2rOwPIW2tdaH
	 Zh2Ii9xY3JaT+YmZGkM5DKs6WG2dBRri4XTd7C6CVmyHrKHJ6E+C0m8h5qiifmnSQV
	 SdGmhqkU9lPYxQGXKFa7OpN3e0ySccLt2YSOGO8SnnsguhHjWD5NxjyBlq4PYmD6Fl
	 pztMKQGT4oN27tybKp8xiculeV2/LQWSxX7Rh4Vf1J2WVOLv5521Vib55zTsZ5AyLY
	 XpBOgVkJ88lXDCXRreNFeoQYNZLcbVZiuy0g1LOT5dpPS3b58+NsM9nXoayF4o9QW6
	 yGiiBPPZ7ZP7Q==
Date: Thu, 25 May 2023 12:15:54 +0200
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
Subject: Re: [PATCH v3 2/6] PCI: hv: Fix a race condition in hv_irq_unmask()
 that can cause panic
Message-ID: <ZG81WpJBBegbLSbT@lpieralisi>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-3-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420024037.5921-3-decui@microsoft.com>

On Wed, Apr 19, 2023 at 07:40:33PM -0700, Dexuan Cui wrote:
> When the host tries to remove a PCI device, the host first sends a
> PCI_EJECT message to the guest, and the guest is supposed to gracefully
> remove the PCI device and send a PCI_EJECTION_COMPLETE message to the host;
> the host then sends a VMBus message CHANNELMSG_RESCIND_CHANNELOFFER to
> the guest (when the guest receives this message, the device is already
> unassigned from the guest) and the guest can do some final cleanup work;
> if the guest fails to respond to the PCI_EJECT message within one minute,
> the host sends the VMBus message CHANNELMSG_RESCIND_CHANNELOFFER and
> removes the PCI device forcibly.
> 
> In the case of fast device addition/removal, it's possible that the PCI
> device driver is still configuring MSI-X interrupts when the guest receives
> the PCI_EJECT message; the channel callback calls hv_pci_eject_device(),
> which sets hpdev->state to hv_pcichild_ejecting, and schedules a work
> hv_eject_device_work(); if the PCI device driver is calling
> pci_alloc_irq_vectors() -> ... -> hv_compose_msi_msg(), we can break the
> while loop in hv_compose_msi_msg() due to the updated hpdev->state, and
> leave data->chip_data with its default value of NULL; later, when the PCI
> device driver calls request_irq() -> ... -> hv_irq_unmask(), the guest
> crashes in hv_arch_irq_unmask() due to data->chip_data being NULL.
> 
> Fix the issue by not testing hpdev->state in the while loop: when the
> guest receives PCI_EJECT, the device is still assigned to the guest, and
> the guest has one minute to finish the device removal gracefully. We don't
> really need to (and we should not) test hpdev->state in the loop.
> 
> Fixes: de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in hv_compose_msi_msg()")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
> 
> v2:
>   Removed the "debug code".
>   No change to the patch body.
>   Added Cc:stable
> 
> v3:
>   Added Michael's Reviewed-by.
> 
>  drivers/pci/controller/pci-hyperv.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index b82c7cde19e66..1b11cf7391933 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -643,6 +643,11 @@ static void hv_arch_irq_unmask(struct irq_data *data)
>  	pbus = pdev->bus;
>  	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
>  	int_desc = data->chip_data;
> +	if (!int_desc) {
> +		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
> +			 __func__, data->irq);
> +		return;
> +	}

That's a check that should be there regardless ?

>  	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
>  
> @@ -1911,12 +1916,6 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  		hv_pci_onchannelcallback(hbus);
>  		spin_unlock_irqrestore(&channel->sched_lock, flags);
>  
> -		if (hpdev->state == hv_pcichild_ejecting) {
> -			dev_err_once(&hbus->hdev->device,
> -				     "the device is being ejected\n");
> -			goto enable_tasklet;
> -		}
> -
>  		udelay(100);
>  	}

I don't understand why this code is in hv_compose_msi_msg() in the first
place (and why only in that function ?) to me this looks like you are
adding plasters in the code that can turn out to be problematic while
ejecting a device, this does not seem robust at all - that's my opinion.

Feel free to merge this code, I can't ACK it, sorry.

Lorenzo

