Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCA53185B8
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhBKHeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:34:31 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18482 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhBKHeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:34:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6024ddbf0000>; Wed, 10 Feb 2021 23:33:19 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Thu, 11 Feb 2021 07:33:17 +0000
Date:   Thu, 11 Feb 2021 09:33:14 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] vdpa/mlx5: defer clear_virtqueues to until
 DRIVER_OK
Message-ID: <20210211073314.GB100783@mtl-vdi-166.wap.labs.mlnx>
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
 <1612993680-29454-4-git-send-email-si-wei.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1612993680-29454-4-git-send-email-si-wei.liu@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613028799; bh=z+7b0JpDsftoI1h/7FD7ibwsJMwxhNgGdxyNnKVYs1Q=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=cjXXfxsVNlHxQ5FESuyuXLGg6E875SKaGfvVURvxIy1314hOsrCPR1gdvEGgZhvZe
         /kRv6TV1tJC+Chh2VeqmLCcYVRhB14+4JY1jbVjeaDBrw/M4mQXUqAVDOUiu9u2U3D
         uPYLVWmAHA8rov1B9zsytQHer9Ps7+rJTHSNEP0AVo8RczhD0nXdnRFDOKM9DHqP4W
         AKJCdFRSqvqgpXPwp726h8oJGA0dlMHbatynlVtg0RFGC5JUAAwgBdeMjRHx5tisol
         boTPkmn2WegcvLnrHp9yEcejqquVr+afZ9mo4EkGTrgQBabNhGNI6F9JTtlPIu9x9Q
         Hkelr8xSkInvA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 01:48:00PM -0800, Si-Wei Liu wrote:
> While virtq is stopped,  get_vq_state() is supposed to
> be  called to  get  sync'ed  with  the latest internal
> avail_index from device. The saved avail_index is used
> to restate  the virtq  once device is started.  Commit
> b35ccebe3ef7 introduced the clear_virtqueues() routine
> to  reset  the saved  avail_index,  however, the index
> gets cleared a bit earlier before get_vq_state() tries
> to read it. This would cause consistency problems when
> virtq is restarted, e.g. through a series of link down
> and link up events. We  could  defer  the  clearing of
> avail_index  to  until  the  device  is to be started,
> i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
> set_status().
> 
> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Acked-by: Eli Cohen <elic@nvidia.com>

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 7c1f789..ce6aae8 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1777,7 +1777,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>  	if (!status) {
>  		mlx5_vdpa_info(mvdev, "performing device reset\n");
>  		teardown_driver(ndev);
> -		clear_virtqueues(ndev);
>  		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>  		ndev->mvdev.status = 0;
>  		++mvdev->generation;
> @@ -1786,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>  
>  	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
>  		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
> +			clear_virtqueues(ndev);
>  			err = setup_driver(ndev);
>  			if (err) {
>  				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
> -- 
> 1.8.3.1
> 
