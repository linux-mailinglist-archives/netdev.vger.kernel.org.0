Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A1312A3D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 06:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBHFtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 00:49:09 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9573 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhBHFtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 00:49:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6020d0a60000>; Sun, 07 Feb 2021 21:48:22 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 8 Feb 2021 05:48:20 +0000
Date:   Mon, 8 Feb 2021 07:48:16 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] mlx5_vdpa: defer clear_virtqueues to until DRIVER_OK
Message-ID: <20210208054816.GC137517@mtl-vdi-166.wap.labs.mlnx>
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-3-git-send-email-si-wei.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1612614564-4220-3-git-send-email-si-wei.liu@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612763302; bh=pzMBuwiRWPHolizp590FGjmhEg9704U0QfdQdV3HCkA=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=AuPjjMUW5UVtOQtPvtlWG2brZc/tBvp1k+pa3XbGySG9PiujkR+ArlJuUeWw9noXC
         JsBEaddaq2k87jcjA04wXjHTzv0qt775w/pcS8SOnUXq+zEJVSi8TMwEZlyKNa50td
         zyGWzhEOWgmZZ4hNLlmAH3FoggoFsOaYgCKEOUsqfK9K2fyGHKDCR2PyWApUISi8oO
         TuxvPQPDZ8CI6BgNjOwxuwNJjLnPN1zpK5tAPvr27i331yHkPhUYipgrUtEG8YXcDT
         zYkYVYz6MQ0una51GbY6BePMuPXhyEBC359iORrOWqzUOjqAKO628XLmdgO+1MWDdy
         541ykjhQ1c3Ow==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 06, 2021 at 04:29:24AM -0800, Si-Wei Liu wrote:
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


Not sure I understand the scenario. You are talking about reset of the
device followed by up/down events on the interface. How can you trigger
this?

> 
> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index aa6f8cd..444ab58 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1785,7 +1785,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>  	if (!status) {
>  		mlx5_vdpa_info(mvdev, "performing device reset\n");
>  		teardown_driver(ndev);
> -		clear_virtqueues(ndev);
>  		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>  		ndev->mvdev.status = 0;
>  		++mvdev->generation;
> @@ -1794,6 +1793,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
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
