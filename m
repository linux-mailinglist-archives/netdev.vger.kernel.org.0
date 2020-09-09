Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D688A2626C7
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 07:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIIFav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 01:30:51 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12751 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgIIFav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 01:30:51 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5868040000>; Tue, 08 Sep 2020 22:28:36 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 22:30:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 22:30:51 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 05:30:49 +0000
Date:   Wed, 9 Sep 2020 08:30:45 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] vdpa/mlx5: Setup driver only if
 VIRTIO_CONFIG_S_DRIVER_OK
Message-ID: <20200909053045.GB200399@mtl-vdi-166.wap.labs.mlnx>
References: <20200908123346.GA169007@mtl-vdi-166.wap.labs.mlnx>
 <1004346338.16284947.1599617319808.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1004346338.16284947.1599617319808.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599629316; bh=G/PGfCBFD4/W2dJY7lxPUQlfzJXAB7CQbbLOCfzv6iM=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=rPIZ62Gc3o14FIVE21A9fgxrUEOXO6PREJvhlKB1UIi5ZRNVYNf+ZWiydJ/qKzil0
         8UUixhpVyJG0F3j7wyrbK7rq6LqRPEAalb1EjkVGVs56ru7ctpW2gM94NIF689bd9v
         kQNZOEE3VXhpPZJQcp6NABwP8PNv0IH5v8zVysrpCHb3gHUM9rKvmQqIWPG5pKhT6h
         cOjEVDnIwfS394L4rYvvOYOoAq5aydHdrWQskZOzUf3njE9lRZV0SBh+pstCfswWUv
         3xdz4DKjHDIGyoG8wiouGoR4n8ZBN0JMtfxkwdkL8NiUfNMK6aE3p143oBcasbBdgS
         8VCKTel9u+hbg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 10:08:39PM -0400, Jason Wang wrote:
> 
> 
> ----- Original Message -----
> > set_map() is used by mlx5 vdpa to create a memory region based on the
> > address map passed by the iotlb argument. If we get successive calls, we
> > will destroy the current memory region and build another one based on
> > the new address mapping. We also need to setup the hardware resources
> > since they depend on the memory region.
> > 
> > If these calls happen before DRIVER_OK, It means that driver VQs may
> > also not been setup and we may not create them yet. In this case we want
> > to avoid setting up the other resources and defer this till we get
> > DRIVER OK.
> > 
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> > V1->V2: Improve changelog description
> > 
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 9df69d5efe8c..c89cd48a0aab 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net
> > *ndev, struct vhost_iotlb *
> >  	if (err)
> >  		goto err_mr;
> >  
> > +	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
> > +		return 0;
> > +
> 
> Is there any reason that we still need to do vq suspending and saving before?
> 
Though suspend_vqs() and save_channels_info() will be called, they will
not actually do any work because the mvq->initialized is false.

Since we don't expect so many false map updates I think it makes sense
to avoid logic around the calls suspend_vqs() and save_channels_info().

> Thanks
> 
> >  	restore_channels_info(ndev);
> >  	err = setup_driver(ndev);
> >  	if (err)
> > --
> > 2.26.0
> > 
> > 
> 
