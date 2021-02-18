Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F631E6EF
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhBRH1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 02:27:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17253 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhBRHTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 02:19:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602e14c60000>; Wed, 17 Feb 2021 23:18:30 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 18 Feb 2021 07:18:28 +0000
Date:   Thu, 18 Feb 2021 09:18:25 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Si-Wei Liu <si-wei.liu@oracle.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Fix suspend/resume index restoration
Message-ID: <20210218071825.GB174998@mtl-vdi-166.wap.labs.mlnx>
References: <20210216162001.83541-1-elic@nvidia.com>
 <4ecc1c7f-4f5a-68be-6734-e18dfeb91437@oracle.com>
 <20210217161858-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210217161858-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613632710; bh=dBVH6v6FNVioqy3fIcu1MpxBIXjR2p66Wi+Av9b44cY=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=oQ4px6Z+6ZHLmAf30OMNWX6sJRtVVyeBQCtKVwVJD1wMahKQZMJrVjNg1GuElyu69
         0H5Q+Xeaqq6bGHOp5SNGLGH9GlmuR77Frw5hnzPXEqALEBY1EBplAEJ+HXuV2EX0IM
         exIuH+uWkGhCOA0rzx0J+r0+zsBnAVlepAaDWnYeCeeuekSXNuSOfa0/XK5E5o4BI/
         rn2r+BdKdlf9qgsGbMCMmDhWHOiA3MvvQJFonzic0bcNYAHWDz1cio3E2QjQHGkrxz
         PUsNgqt2Aga01GSkd3ah7M9MHO1VFfjB8UHgJeZXF4+Ct/LJ/sk7bx8gsVwPxY84tL
         hRRpGJAibTC8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 04:20:14PM -0500, Michael S. Tsirkin wrote:
> On Wed, Feb 17, 2021 at 11:42:48AM -0800, Si-Wei Liu wrote:
> > 
> > 
> > On 2/16/2021 8:20 AM, Eli Cohen wrote:
> > > When we suspend the VM, the VDPA interface will be reset. When the VM is
> > > resumed again, clear_virtqueues() will clear the available and used
> > > indices resulting in hardware virqtqueue objects becoming out of sync.
> > > We can avoid this function alltogether since qemu will clear them if
> > > required, e.g. when the VM went through a reboot.
> > > 
> > > Moreover, since the hw available and used indices should always be
> > > identical on query and should be restored to the same value same value
> > > for virtqueues that complete in order, we set the single value provided
> > > by set_vq_state(). In get_vq_state() we return the value of hardware
> > > used index.
> > > 
> > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > Acked-by: Si-Wei Liu <si-wei.liu@oracle.com>
> 
> 
> Seems to also fix b35ccebe3ef76168aa2edaa35809c0232cb3578e, right?
> 

Right.

> 
> > > ---
> > >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 ++++-------------
> > >   1 file changed, 4 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index b8e9d525d66c..a51b0f86afe2 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> > >   		return;
> > >   	}
> > >   	mvq->avail_idx = attr.available_index;
> > > +	mvq->used_idx = attr.used_index;
> > >   }
> > >   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > @@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
> > >   		return -EINVAL;
> > >   	}
> > > +	mvq->used_idx = state->avail_index;
> > >   	mvq->avail_idx = state->avail_index;
> > >   	return 0;
> > >   }
> > > @@ -1443,7 +1445,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
> > >   	 * that cares about emulating the index after vq is stopped.
> > >   	 */
> > >   	if (!mvq->initialized) {
> > > -		state->avail_index = mvq->avail_idx;
> > > +		state->avail_index = mvq->used_idx;
> > >   		return 0;
> > >   	}
> > > @@ -1452,7 +1454,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
> > >   		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
> > >   		return err;
> > >   	}
> > > -	state->avail_index = attr.available_index;
> > > +	state->avail_index = attr.used_index;
> > >   	return 0;
> > >   }
> > > @@ -1532,16 +1534,6 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
> > >   	}
> > >   }
> > > -static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
> > > -{
> > > -	int i;
> > > -
> > > -	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
> > > -		ndev->vqs[i].avail_idx = 0;
> > > -		ndev->vqs[i].used_idx = 0;
> > > -	}
> > > -}
> > > -
> > >   /* TODO: cross-endian support */
> > >   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
> > >   {
> > > @@ -1777,7 +1769,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> > >   	if (!status) {
> > >   		mlx5_vdpa_info(mvdev, "performing device reset\n");
> > >   		teardown_driver(ndev);
> > > -		clear_virtqueues(ndev);
> > >   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
> > >   		ndev->mvdev.status = 0;
> > >   		++mvdev->generation;
> 
