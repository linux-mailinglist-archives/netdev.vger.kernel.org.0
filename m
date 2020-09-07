Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB42425F9AF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 13:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgIGL1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 07:27:02 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4636 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgIGLZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 07:25:56 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f56138a0000>; Mon, 07 Sep 2020 04:03:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 07 Sep 2020 04:03:52 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 07 Sep 2020 04:03:52 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 11:03:44 +0000
Date:   Mon, 7 Sep 2020 14:03:35 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Message-ID: <20200907110335.GA121033@mtl-vdi-166.wap.labs.mlnx>
References: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx>
 <507166908.16038290.1599476003292.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <507166908.16038290.1599476003292.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599476618; bh=LMINtOPqRpD4/qKaVjsYmBlP/+l8N4T31Ra1fzRuNvw=;
        h=X-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=U+LfzrCE1qXlV5Yn6jDnkds7trQBDDmYItyFQMxX1MoMqSuJmtNK53pNNcczWzbUo
         H+QV6phVU8H808RJk3hv3GDA/RW9Iq59OamE4WXWEaovO0uPfHmBdu6IU9TMxwyb45
         ibdZRbLgsyj6q13xMcce+aZcduR5jRQ+iAqDQ7cEAY7qqeV7tnRjTqJOcboebTnE9Y
         EPDkXpuND9DVgbithHbEZp4nDXzyWNDfMh+FZDQZGVBbMRCW50PuKexfYGltFkyO/X
         rJeWLUaFt1JWC5mEzoRrYX7bBekwT9Yf2vWXtPztSS7LGafFYfqxlPxBWafpf4EUeh
         9v6spsKZi4NXQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 06:53:23AM -0400, Jason Wang wrote:
> 
> 
> ----- Original Message -----
> > If the memory map changes before the driver status is
> > VIRTIO_CONFIG_S_DRIVER_OK, don't attempt to create resources because it
> > may fail. For example, if the VQ is not ready there is no point in
> > creating resources.
> > 
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
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
> I'm not sure I get this.
> 
> It looks to me if set_map() is called before DRIVER_OK, we won't build
> any mapping?
> 
What would prevent that? Is it some qemu logic you're relying upon?
With current qemu 5.1 with lack of batching support, I get plenty calls
to set_map which result in calls to mlx5_vdpa_change_map().
If that happens before VIRTIO_CONFIG_S_DRIVER_OK then Imay fail (in case
I was not called to set VQs ready).

> 
> >  	restore_channels_info(ndev);
> >  	err = setup_driver(ndev);
> >  	if (err)
> > --
> > 2.26.0
> > 
> > 
> 
