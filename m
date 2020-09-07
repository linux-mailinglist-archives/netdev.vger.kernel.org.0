Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53AD25F9BF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 13:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgIGLpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 07:45:19 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16940 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728948AbgIGLoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 07:44:09 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f561c7b0001>; Mon, 07 Sep 2020 04:41:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 07 Sep 2020 04:44:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 07 Sep 2020 04:44:00 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 11:43:57 +0000
Date:   Mon, 7 Sep 2020 14:43:51 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Message-ID: <20200907114351.GC121033@mtl-vdi-166.wap.labs.mlnx>
References: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
 <20200907073319-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200907073319-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599478907; bh=rPuSpQ+AI3waLwWQgYXQb/+jowBU3/p6fNwDC282AtI=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=ZpwZhzPUClNq+HpTlMqZEJw4z2gHdbem7InAMzz4hGyHXNuj91gBUvbnqKG9BItth
         krAefaUm1Sk7ZoKbegbV3I+zCJ3LBV4BtkZhSIy/qo4GhJZF3m5vhZHtsav7hvpdDp
         lbXpNqm7asLBGOGF6Z3SEyWMQReVATeOBR4dpYvL6etl0UJGGmlMew2sOi/pqEiQQh
         yI8y/t3P5rmbU4KP8Voa1fuauhhm2zLBla81rJTPbefOsbPb5DwIFioonOh+T5okHQ
         zaol5QsvyR3Y5IpdqKaylPBj90JEB4gkc6VGvIyKYIX4CRDx8JAVyw9Afv4eQ9wDwl
         TmLV7Ji5zVSBw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 07:34:00AM -0400, Michael S. Tsirkin wrote:
> On Mon, Sep 07, 2020 at 10:51:36AM +0300, Eli Cohen wrote:
> > If the memory map changes before the driver status is
> > VIRTIO_CONFIG_S_DRIVER_OK, don't attempt to create resources because it
> > may fail. For example, if the VQ is not ready there is no point in
> > creating resources.
> > 
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> 
> 
> Could you add a bit more data about the problem to the log?
> To be more exact, what exactly happens right now?
>

Sure I can.

set_map() is used by mlx5 vdpa to create a memory region based on the
address map passed by the iotlb argument. If I get successive calls, I
will destroy the current memory region and build another one based on
the new address mapping. I also need to setup the hardware resources
since they depend on the memory region.

If these calls happen before DRIVER_OK, It means it that driver VQs may
also not been setup and I may not create them yet. In this case I want
to avoid setting up the other resources and defer this till I get DRIVER
OK.

Let me know if that answers your question so I can post another patch.

> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 9df69d5efe8c..c89cd48a0aab 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net *ndev, struct vhost_iotlb *
> >  	if (err)
> >  		goto err_mr;
> >  
> > +	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
> > +		return 0;
> > +
> >  	restore_channels_info(ndev);
> >  	err = setup_driver(ndev);
> >  	if (err)
> > -- 
> > 2.26.0
> 
