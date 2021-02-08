Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF60312A22
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 06:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhBHFfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 00:35:50 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8714 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhBHFfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 00:35:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6020cd8b0000>; Sun, 07 Feb 2021 21:35:07 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 8 Feb 2021 05:35:04 +0000
Date:   Mon, 8 Feb 2021 07:35:00 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] mlx5_vdpa: fix feature negotiation across device
 reset
Message-ID: <20210208053500.GA137517@mtl-vdi-166.wap.labs.mlnx>
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-2-git-send-email-si-wei.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1612614564-4220-2-git-send-email-si-wei.liu@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612762507; bh=/bt91ojGTfU/NFiqHuMYnIol4RfQVN8e4gHDbfiF45I=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=j9ttjT1pDapYqiN+WH++D9JM/pB7ZXbSTizJE8f6pxtYrqtBLmMz7Bqy7JXPAzBcM
         oKY1Czqb3BphVpwHT2uVUsbf6w+qtFdKg7Cds4dLnkx42poAJxf6UL4SYfkwlTQE2x
         05iGGvmeZwqs7T/x8WpfFNCI3TV9uzkX9wBRB2KNmD7fex4EN0mg5EZO8d7rsA8Xh9
         4lxhsa2vhWP/hTCq3LsVOzkdH3gW7Pj6aE5oLemTKzWrJ4Cw/aoalHxHlpYAI21uwu
         1YsUHCMfb62ZLcYu/2Um76C8lccBZuDq/g41Aj89Rvh+/YSLMDcWq287ooApo0zved
         oLrikGbfqhbeQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 06, 2021 at 04:29:23AM -0800, Si-Wei Liu wrote:
> The mlx_features denotes the capability for which
> set of virtio features is supported by device. In
> principle, this field needs not be cleared during
> virtio device reset, as this capability is static
> and does not change across reset.
> 
> In fact, the current code may have the assumption
> that mlx_features can be reloaded from firmware
> via the .get_features ops after device is reset
> (via the .set_status ops), which is unfortunately
> not true. The userspace VMM might save a copy
> of backend capable features and won't call into
> kernel again to get it on reset. This causes all
> virtio features getting disabled on newly created
> virtqs after device reset, while guest would hold
> mismatched view of available features. For e.g.,
> the guest may still assume tx checksum offload
> is available after reset and feature negotiation,
> causing frames with bogus (incomplete) checksum
> transmitted on the wire.
> 
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index b8416c4..aa6f8cd 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1788,7 +1788,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>  		clear_virtqueues(ndev);
>  		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>  		ndev->mvdev.status = 0;
> -		ndev->mvdev.mlx_features = 0;
>  		++mvdev->generation;
>  		return;
>  	}

Since we assume that device capabilities don't change, I think I would
get the features through a call done in mlx5v_probe after the netdev
object is created and change mlx5_vdpa_get_features() to just return
ndev->mvdev.mlx_features.

Did you actually see this issue in action? If you did, can you share
with us how you trigerred this?

> -- 
> 1.8.3.1
> 
