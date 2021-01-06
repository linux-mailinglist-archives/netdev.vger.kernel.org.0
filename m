Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E49B2EB9A7
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 06:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAFFvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 00:51:35 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9646 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFFve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 00:51:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff54fbe0000>; Tue, 05 Jan 2021 21:50:54 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 6 Jan
 2021 05:50:53 +0000
Date:   Wed, 6 Jan 2021 07:50:50 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210106055050.GT31158@unreal>
References: <20210103082440.34994-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210103082440.34994-1-leon@kernel.org>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609912254; bh=TQxUJmNNZ4DZ0KVJcQg/uVvfTat5TCPZxfDgC+i/lZE=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=MKldL8+iQQ2zj0glQVTLNJF+1dE/Da4jt9qtvvKCrwET6jWs9oWSbwbgzwdqVc6j2
         nEZ4juVJVAgH0Z22bdw+57J5kmNAP8ra249UWU5lgpUZHxech/w4DR2w3dN0uq/vbH
         56KGkFuKWoNC4sZPRbXqpA6tAqevleqxcqTtiTpkjI+7TGQSBOgt3fR+6OV2j8uEy9
         y8LK7jvf9evlXmw7slfgAhR/+/aM4T84X1Gmf4f7pdp+DFXTGvAZ8QKDZAPBcCpkLa
         BrHa9c4XWt3X2x3vJqLmQEKkjH7BQaAVjuEuWNuksi3WaOSh0KAgWZhjNgHhtHuuxl
         guUfOlXvXZqHw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 03, 2021 at 10:24:36AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Hi,
>
> The number of MSI-X vectors is PCI property visible through lspci, that
> field is read-only and configured by the device.
>
> The static assignment of an amount of MSI-X vectors doesn't allow utilize
> the newly created VF because it is not known to the device the future load
> and configuration where that VF will be used.
>
> The VFs are created on the hypervisor and forwarded to the VMs that have
> different properties (for example number of CPUs).
>
> To overcome the inefficiency in the spread of such MSI-X vectors, we
> allow the kernel to instruct the device with the needed number of such
> vectors, before VF is initialized and bounded to the driver.
>
> Before this series:
> [root@server ~]# lspci -vs 0000:08:00.2
> 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> ....
> 	Capabilities: [9c] MSI-X: Enable- Count=12 Masked-
>
> Configuration script:
> 1. Start fresh
> echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
> modprobe -q -r mlx5_ib mlx5_core
> 2. Ensure that driver doesn't run and it is safe to change MSI-X
> echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_drivers_autoprobe
> 3. Load driver for the PF
> modprobe mlx5_core
> 4. Configure one of the VFs with new number
> echo 2 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
> echo 21 > /sys/bus/pci/devices/0000\:08\:00.2/vf_msix_vec
>
> After this series:
> [root@server ~]# lspci -vs 0000:08:00.2
> 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> ....
> 	Capabilities: [9c] MSI-X: Enable- Count=21 Masked-
>
>
> Thanks
>
> Leon Romanovsky (4):
>   PCI: Configure number of MSI-X vectors for SR-IOV VFs
>   net/mlx5: Add dynamic MSI-X capabilities bits
>   net/mlx5: Dynamically assign MSI-X vectors count
>   net/mlx5: Allow to the users to configure number of MSI-X vectors

Hi Bjorn,

I would like to route the PCI patch through mlx5-next tree which will
be taken to the netdev and rdma trees.

This is needed to avoid any possible merge conflicts between three
subsystems PCI, netdev and RDMA.

Is it acceptable by you?

Thanks
