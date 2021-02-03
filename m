Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4290C30D37D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 07:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhBCGtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 01:49:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7289 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhBCGs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 01:48:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601a47330002>; Tue, 02 Feb 2021 22:48:19 -0800
Received: from DRHQMAIL105.nvidia.com (10.27.9.14) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 06:48:19 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 3 Feb 2021 06:48:16 +0000
Date:   Wed, 3 Feb 2021 08:48:12 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <siwliu.kernel@gmail.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH] vdpa/mlx5: Restore the hardware used index after change
 map
Message-ID: <20210203064812.GA33072@mtl-vdi-166.wap.labs.mlnx>
References: <20210202142901.7131-1-elic@nvidia.com>
 <CAPWQSg3Z1aCZc7kX2x_4NLtAzkrZ+eO5ABBF0bAQfaLc=++Y2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPWQSg3Z1aCZc7kX2x_4NLtAzkrZ+eO5ABBF0bAQfaLc=++Y2Q@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL105.nvidia.com (10.27.9.14)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612334899; bh=bdWJXd3YSJWxG7Da0O4JneyR2Xqw2RHQwLqQqrk8WPY=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=pKhCUP08z1d/GjfKEtGyTR4xrOOO4sSqOTNQfZp+EK7WeZo1b5aGced6rYv43uMRH
         6yapjy0thTQ6oAjcgkMqpprndUmZEvkRa5cGOfczGq5+L5o3/LY+JxmCvNi6Ogu5cQ
         1Cicgn92mv2w/6DA/tA4Rq+7jp7GAplPSOovgAV27qLR5PJZ+yu/BfjlkhlkMlH1Dm
         GJyNyp14Fq3eF6Zb80ClE9/W3e/K0ncYJ7sZY3iyZdZYJx/errBCQXGg64EHGvHehE
         kaw0LlqTipeaZsWZQdo1ESYzb6sO9rGjmf4v5dys4HSuUA60QxJC0hy4hqkQwqb8fd
         U91fUnfEWiQWQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 09:14:02AM -0800, Si-Wei Liu wrote:
> On Tue, Feb 2, 2021 at 6:34 AM Eli Cohen <elic@nvidia.com> wrote:
> >
> > When a change of memory map occurs, the hardware resources are destroyed
> > and then re-created again with the new memory map. In such case, we need
> > to restore the hardware available and used indices. The driver failed to
> > restore the used index which is added here.
> >
> > Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> > This patch is being sent again a single patch the fixes hot memory
> > addtion to a qemy process.
> >
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 88dde3455bfd..839f57c64a6f 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
> >         u64 device_addr;
> >         u64 driver_addr;
> >         u16 avail_index;
> > +       u16 used_index;
> >         bool ready;
> >         struct vdpa_callback cb;
> >         bool restore;
> > @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
> >         u32 virtq_id;
> >         struct mlx5_vdpa_net *ndev;
> >         u16 avail_idx;
> > +       u16 used_idx;
> >         int fw_state;
> >
> >         /* keep last in the struct */
> > @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
> >
> >         obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
> >         MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
> > +       MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
> 
> The saved indexes will apply to the new virtqueue object whenever it
> is created. In virtio spec, these indexes will reset back to zero when
> the virtio device is reset. But I don't see how it's done today. IOW,
> I don't see where avail_idx and used_idx get cleared from the mvq for
> device reset via set_status().
> 

Right, but this is not strictly related to this patch. I will post
another patch to fix this.

BTW, can you describe a secnario that would cause a reset (through
calling set_status()) that happens after the VQ has been used?

> -Siwei
> 
> 
> >         MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
> >                  get_features_12_3(ndev->mvdev.actual_features));
> >         vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
> > @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> >  struct mlx5_virtq_attr {
> >         u8 state;
> >         u16 available_index;
> > +       u16 used_index;
> >  };
> >
> >  static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
> > @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
> >         memset(attr, 0, sizeof(*attr));
> >         attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
> >         attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
> > +       attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
> >         kfree(out);
> >         return 0;
> >
> > @@ -1610,6 +1615,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
> >                 return err;
> >
> >         ri->avail_index = attr.available_index;
> > +       ri->used_index = attr.used_index;
> >         ri->ready = mvq->ready;
> >         ri->num_ent = mvq->num_ent;
> >         ri->desc_addr = mvq->desc_addr;
> > @@ -1654,6 +1660,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
> >                         continue;
> >
> >                 mvq->avail_idx = ri->avail_index;
> > +               mvq->used_idx = ri->used_index;
> >                 mvq->ready = ri->ready;
> >                 mvq->num_ent = ri->num_ent;
> >                 mvq->desc_addr = ri->desc_addr;
> > --
> > 2.29.2
> >
