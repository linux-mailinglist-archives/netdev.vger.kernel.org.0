Return-Path: <netdev+bounces-5264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D14471074B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EF921C20C5D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB92D2E6;
	Thu, 25 May 2023 08:27:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78D66FA9
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF57C433EF;
	Thu, 25 May 2023 08:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685003264;
	bh=TXzkAJJtr+rb8+qhlaMHIqTqmmEXt7KMrw8HfElDAJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J35245Wq98yYPRUnLLCiT44fAp7tz9SYlr6TWHMK2i4IvPOJAmr2x/gsAVhHmh0BW
	 M5pefjyGo5aDKkPtKyHYK6omGZDyqWCWRhEI/G7GsEJE2IKx6+NuSI+uX3Bm1Calrc
	 tc5MpwpSqLCg4Gp69lLvO+fxKwk2QqI+lQ5OItzhqQYasd4Pm+U0mvMPOsNJAsQs+6
	 ybY/dfxk49hudYozaRGRRWD8OtxgaJme91Q+zWxenywCQNcu9qNo79Q7UHAeD9h5iF
	 4NJejm1VsfleZXpbjxCKYfiusxtEcKiTJj67zeKAp2l5b35mW4qAsxfZjWLuGbWXs/
	 unNc/oob7IUBA==
Date: Thu, 25 May 2023 10:27:35 +0200
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
Subject: Re: [PATCH v3 5/6] PCI: hv: Add a per-bus mutex state_lock
Message-ID: <ZG8b933WBtpssRz0@lpieralisi>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-6-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420024037.5921-6-decui@microsoft.com>

On Wed, Apr 19, 2023 at 07:40:36PM -0700, Dexuan Cui wrote:
> In the case of fast device addition/removal, it's possible that
> hv_eject_device_work() can start to run before create_root_hv_pci_bus()
> starts to run; as a result, the pci_get_domain_bus_and_slot() in
> hv_eject_device_work() can return a 'pdev' of NULL, and
> hv_eject_device_work() can remove the 'hpdev', and immediately send a
> message PCI_EJECTION_COMPLETE to the host, and the host immediately
> unassigns the PCI device from the guest; meanwhile,
> create_root_hv_pci_bus() and the PCI device driver can be probing the
> dead PCI device and reporting timeout errors.
> 
> Fix the issue by adding a per-bus mutex 'state_lock' and grabbing the
> mutex before powering on the PCI bus in hv_pci_enter_d0(): when
> hv_eject_device_work() starts to run, it's able to find the 'pdev' and call
> pci_stop_and_remove_bus_device(pdev): if the PCI device driver has
> loaded, the PCI device driver's probe() function is already called in
> create_root_hv_pci_bus() -> pci_bus_add_devices(), and now
> hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able
> to call the PCI device driver's remove() function and remove the device
> reliably; if the PCI device driver hasn't loaded yet, the function call
> hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able to
> remove the PCI device reliably and the PCI device driver's probe()
> function won't be called; if the PCI device driver's probe() is already
> running (e.g., systemd-udev is loading the PCI device driver), it must
> be holding the per-device lock, and after the probe() finishes and releases
> the lock, hv_eject_device_work() -> pci_stop_and_remove_bus_device() is
> able to proceed to remove the device reliably.
> 
> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
> 
> v2:
>   Removed the "debug code".
>   Fixed the "goto out" in hv_pci_resume() [Michael Kelley]
>   Added Cc:stable
> 
> v3:
>   Added Michael's Reviewed-by.
> 
>  drivers/pci/controller/pci-hyperv.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)

Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index 48feab095a144..3ae2f99dea8c2 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -489,7 +489,10 @@ struct hv_pcibus_device {
>  	struct fwnode_handle *fwnode;
>  	/* Protocol version negotiated with the host */
>  	enum pci_protocol_version_t protocol_version;
> +
> +	struct mutex state_lock;
>  	enum hv_pcibus_state state;
> +
>  	struct hv_device *hdev;
>  	resource_size_t low_mmio_space;
>  	resource_size_t high_mmio_space;
> @@ -2512,6 +2515,8 @@ static void pci_devices_present_work(struct work_struct *work)
>  	if (!dr)
>  		return;
>  
> +	mutex_lock(&hbus->state_lock);
> +
>  	/* First, mark all existing children as reported missing. */
>  	spin_lock_irqsave(&hbus->device_list_lock, flags);
>  	list_for_each_entry(hpdev, &hbus->children, list_entry) {
> @@ -2593,6 +2598,8 @@ static void pci_devices_present_work(struct work_struct *work)
>  		break;
>  	}
>  
> +	mutex_unlock(&hbus->state_lock);
> +
>  	kfree(dr);
>  }
>  
> @@ -2741,6 +2748,8 @@ static void hv_eject_device_work(struct work_struct *work)
>  	hpdev = container_of(work, struct hv_pci_dev, wrk);
>  	hbus = hpdev->hbus;
>  
> +	mutex_lock(&hbus->state_lock);
> +
>  	/*
>  	 * Ejection can come before or after the PCI bus has been set up, so
>  	 * attempt to find it and tear down the bus state, if it exists.  This
> @@ -2777,6 +2786,8 @@ static void hv_eject_device_work(struct work_struct *work)
>  	put_pcichild(hpdev);
>  	put_pcichild(hpdev);
>  	/* hpdev has been freed. Do not use it any more. */
> +
> +	mutex_unlock(&hbus->state_lock);
>  }
>  
>  /**
> @@ -3562,6 +3573,7 @@ static int hv_pci_probe(struct hv_device *hdev,
>  		return -ENOMEM;
>  
>  	hbus->bridge = bridge;
> +	mutex_init(&hbus->state_lock);
>  	hbus->state = hv_pcibus_init;
>  	hbus->wslot_res_allocated = -1;
>  
> @@ -3670,9 +3682,11 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	if (ret)
>  		goto free_irq_domain;
>  
> +	mutex_lock(&hbus->state_lock);
> +
>  	ret = hv_pci_enter_d0(hdev);
>  	if (ret)
> -		goto free_irq_domain;
> +		goto release_state_lock;
>  
>  	ret = hv_pci_allocate_bridge_windows(hbus);
>  	if (ret)
> @@ -3690,12 +3704,15 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	if (ret)
>  		goto free_windows;
>  
> +	mutex_unlock(&hbus->state_lock);
>  	return 0;
>  
>  free_windows:
>  	hv_pci_free_bridge_windows(hbus);
>  exit_d0:
>  	(void) hv_pci_bus_exit(hdev, true);
> +release_state_lock:
> +	mutex_unlock(&hbus->state_lock);
>  free_irq_domain:
>  	irq_domain_remove(hbus->irq_domain);
>  free_fwnode:
> @@ -3945,20 +3962,26 @@ static int hv_pci_resume(struct hv_device *hdev)
>  	if (ret)
>  		goto out;
>  
> +	mutex_lock(&hbus->state_lock);
> +
>  	ret = hv_pci_enter_d0(hdev);
>  	if (ret)
> -		goto out;
> +		goto release_state_lock;
>  
>  	ret = hv_send_resources_allocated(hdev);
>  	if (ret)
> -		goto out;
> +		goto release_state_lock;
>  
>  	prepopulate_bars(hbus);
>  
>  	hv_pci_restore_msi_state(hbus);
>  
>  	hbus->state = hv_pcibus_installed;
> +	mutex_unlock(&hbus->state_lock);
>  	return 0;
> +
> +release_state_lock:
> +	mutex_unlock(&hbus->state_lock);
>  out:
>  	vmbus_close(hdev->channel);
>  	return ret;
> -- 
> 2.25.1
> 

