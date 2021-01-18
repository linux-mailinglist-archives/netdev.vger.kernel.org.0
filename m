Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C682FA719
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406858AbhARRKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406642AbhARREF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:04:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44766222BB;
        Mon, 18 Jan 2021 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610989404;
        bh=PUMHVLXGzKM/krtPA6wU46Eo7KWFNt/qTlacxel4Xqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CT1FKksMsv0NV+pGEK+8r4HoOEh3UI3nvsu+U34daYb8O8I86wZvRZDsxm9CQlPzR
         njNLCb5Jz4qMJo5wE1nZIwNaDM//j133YFEUBzY0v5Aj9DBt0UKKDzSTdIls/LzUEh
         RJByE/qiCWo68qjVlx/6VLu7Q2yfCWMSfG6wjaqQ=
Date:   Mon, 18 Jan 2021 18:03:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <YAW/Wtr0thScxvK/@kroah.com>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110150727.1965295-3-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:07:24PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Some SR-IOV capable devices provide an ability to configure specific
> number of MSI-X vectors on their VF prior driver is probed on that VF.
> 
> In order to make management easy, provide new read-only sysfs file that
> returns a total number of possible to configure MSI-X vectors.
> 
> cat /sys/bus/pci/devices/.../sriov_vf_total_msix
>   = 0 - feature is not supported
>   > 0 - total number of MSI-X vectors to consume by the VFs
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
>  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
>  drivers/pci/pci.h                       |  3 +++
>  include/linux/pci.h                     |  2 ++
>  4 files changed, 50 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 05e26e5da54e..64e9b700acc9 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -395,3 +395,17 @@ Description:
>  		The file is writable if the PF is bound to a driver that
>  		supports the ->sriov_set_msix_vec_count() callback and there
>  		is no driver bound to the VF.
> +
> +What:		/sys/bus/pci/devices/.../sriov_vf_total_msix
> +Date:		January 2021
> +Contact:	Leon Romanovsky <leonro@nvidia.com>
> +Description:
> +		This file is associated with the SR-IOV PFs.
> +		It returns a total number of possible to configure MSI-X
> +		vectors on the enabled VFs.
> +
> +		The values returned are:
> +		 * > 0 - this will be total number possible to consume by VFs,
> +		 * = 0 - feature is not supported
> +
> +		If no SR-IOV VFs are enabled, this value will return 0.
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 42c0df4158d1..0a6ddf3230fd 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
>  	return count;
>  }
> 
> +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);

Nit, please use sysfs_emit() for new sysfs files.

thanks,

greg k-h
