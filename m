Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB530B84B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhBBHEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:04:34 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13554 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhBBHEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 02:04:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018f9450001>; Mon, 01 Feb 2021 23:03:33 -0800
Received: from localhost (172.20.145.6) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 07:02:57 +0000
Date:   Tue, 2 Feb 2021 09:02:46 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v5 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210202070246.GC1945456@unreal>
References: <20210126085730.1165673-1-leon@kernel.org>
 <20210126085730.1165673-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210126085730.1165673-2-leon@kernel.org>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL105.nvidia.com (172.20.187.12)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612249413; bh=pcdL63axnrv3GD7icYQTjaMNlVO17X6R4uuh8YZy1R4=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=VZh07m+jtRQUiB7GKf3LZFAAEXyOnaDe34qthj5P6wMHl7zu4uFd1A8u3Fqe8SDB6
         F7h5eqF0EWF1iqJ+YtFWHckG6BxtF4FStkVEVC986BErYV2sGjysQ7724DOsrjSmj8
         ZFrowCpNH4gVZ42hFZUp6BNLKHLio50ds5RDaqNBKbTRw1MFlgpWzCp4tigOo44B4/
         xFPl8QSSiSu4JTXsvN2me3tbRHbi/Txj7gPq7q+3CheSW1DTsE3ccFNzNizjexNDPM
         86CnGNzr6O1ZZpuAe4/Txi+BxsomWbSzsdSG7O5or42uvobu4OtQdzC8J38Ii3hxd0
         jkQwQ24vHf/AA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:57:27AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Extend PCI sysfs interface with a new callback that allows configure
> the number of MSI-X vectors for specific SR-IO VF. This is needed
> to optimize the performance of newly bound devices by allocating
> the number of vectors based on the administrator knowledge of targeted VM.
>
> This function is applicable for SR-IOV VF because such devices allocate
> their MSI-X table before they will run on the VMs and HW can't guess the
> right number of vectors, so the HW allocates them statically and equally.
>
> 1) The newly added /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
> file will be seen for the VFs and it is writable as long as a driver is not
> bounded to the VF.
>
> The values accepted are:
>  * > 0 - this will be number reported by the VF's MSI-X capability
>  * < 0 - not valid
>  * = 0 - will reset to the device default value
>
> 2) In order to make management easy, provide new read-only sysfs file that
> returns a total number of possible to configure MSI-X vectors.
>
> cat /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
>   = 0 - feature is not supported
>   > 0 - total number of MSI-X vectors to consume by the VFs
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |  32 +++++
>  drivers/pci/iov.c                       | 180 ++++++++++++++++++++++++
>  drivers/pci/msi.c                       |  47 +++++++
>  drivers/pci/pci.h                       |   4 +
>  include/linux/pci.h                     |  10 ++
>  5 files changed, 273 insertions(+)

Bjorn,

Can I please get your Acked-by on this so it will go through
mlx5-next -> netdev submission flow?

Thanks
