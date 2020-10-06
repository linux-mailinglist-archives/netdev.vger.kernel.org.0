Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3F28463F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgJFGm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:42:58 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11252 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:42:58 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c11860000>; Mon, 05 Oct 2020 23:41:10 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 06:42:55 +0000
Date:   Tue, 6 Oct 2020 09:42:51 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Si-Wei Liu <siwliu.kernel@gmail.com>, <jasowang@redhat.com>,
        <netdev@vger.kernel.org>, <joao.m.martins@oracle.com>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH] vdpa/mlx5: should keep avail_index despite device status
Message-ID: <20201006064251.GA245562@mtl-vdi-166.wap.labs.mlnx>
References: <1601583511-15138-1-git-send-email-si-wei.liu@oracle.com>
 <CAPWQSg1y8uvpiwxxp_ONGFs8GeuOY09q3AShfLCmhv77ePma-Q@mail.gmail.com>
 <20201006022133-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201006022133-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601966470; bh=ASs8JiGhlMNd52uGVVMaQ1Y7RyhmCiPPg7YfPHpQFa4=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=nkXgBjaLnjffyiY59h9MLp4hDRC627b5J3L4h1vN/qgrrVlYiAgRU/aH3laHlVpIF
         QDc7hvJE9TCfs50aW8eq+ej+ikWVqzMVFae0RUxUlkMFl8BHjt+QGWQc0D1utam2uF
         4PGzhAiESNkrzWhAczeUbb6mwtPGYRewq3F5xv4z6BZ5yNE8ELk+X3l136UYcoGAKC
         ecN4MldL7g63fCLWWKqVGQD/LB0YRSYBnrwyhlRbabBloWZI140Bupz9vmtDK1T4TD
         8vDfBcQHyl9owITyPs26ftW2/9MwCLOmLT3n47pmdklQ1yrr8y/VZZOGgrTxEoDyBs
         EcCvyHCbh7lmA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 02:22:15AM -0400, Michael S. Tsirkin wrote:

Acked-by: Eli Cohen <elic@nvidia.com>

> On Fri, Oct 02, 2020 at 01:17:00PM -0700, Si-Wei Liu wrote:
> > + Eli.
> > 
> > On Thu, Oct 1, 2020 at 2:02 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> > >
> > > A VM with mlx5 vDPA has below warnings while being reset:
> > >
> > > vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
> > > vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
> > >
> > > We should allow userspace emulating the virtio device be
> > > able to get to vq's avail_index, regardless of vDPA device
> > > status. Save the index that was last seen when virtq was
> > > stopped, so that userspace doesn't complain.
> > >
> > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> 
> Eli can you review this pls? I need to send a pull request to Linux by
> tomorrow - do we want to include this?
> 
> > > ---
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 20 ++++++++++++++------
> > >  1 file changed, 14 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index 70676a6..74264e59 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1133,15 +1133,17 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> > >         if (!mvq->initialized)
> > >                 return;
> > >
> > > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> > > -               return;
> > > -       }
> > >         if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
> > >                 return;
> > >
> > >         if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
> > >                 mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> > > +
> > > +       if (query_virtqueue(ndev, mvq, &attr)) {
> > > +               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> > > +               return;
> > > +       }
> > > +       mvq->avail_idx = attr.available_index;
> > >  }
> > >
> > >  static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > @@ -1411,8 +1413,14 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
> > >         struct mlx5_virtq_attr attr;
> > >         int err;
> > >
> > > -       if (!mvq->initialized)
> > > -               return -EAGAIN;
> > > +       /* If the virtq object was destroyed, use the value saved at
> > > +        * the last minute of suspend_vq. This caters for userspace
> > > +        * that cares about emulating the index after vq is stopped.
> > > +        */
> > > +       if (!mvq->initialized) {
> > > +               state->avail_index = mvq->avail_idx;
> > > +               return 0;
> > > +       }
> > >
> > >         err = query_virtqueue(ndev, mvq, &attr);
> > >         if (err) {
> > > --
> > > 1.8.3.1
> > >
> 
