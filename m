Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581AF3210B2
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 07:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBVGGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 01:06:22 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8461 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhBVGGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 01:06:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603349ac0000>; Sun, 21 Feb 2021 22:05:32 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 22 Feb 2021 06:05:30 +0000
Date:   Mon, 22 Feb 2021 08:05:26 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Si-Wei Liu <si-wei.liu@oracle.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210222060526.GA110862@mtl-vdi-166.wap.labs.mlnx>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <20210221144437.GA82010@mtl-vdi-166.wap.labs.mlnx>
 <20210221165047-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210221165047-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613973932; bh=wtiBJo2dRLfJIIqt6wpLMyAaUBsSb2VCf4Pvw6R8saw=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=nJKcuKSBsnWQK5RLQOSDOFfHKKTzeXp1SAW9Bqr/zVjaT7ZlQr+e1HhVj52J5dTLt
         cWMt2LhDFMBNNxHoPYqOj/amvmWoW8OUf9nudrC26zxLMC8TN7L5UOrjqywOVqwYRK
         MQmh1UU/mz2r0HM0MDb2j+DkpC/x3ns5YyOI/WxB2sBlQvmg9JBAWkPqzPN09H5XQH
         7hdq7CucxipnsWHyyWPDMZwBCVVyu/aWTJVcBgVLbsqyVR4Of4Yj+ZC4/tXiD6ZFnE
         kOjwDam1Zoad33MeQWzQtqTfwIO3SzEMOUyHPqy0TghSIlVKEg8nAlstBGIf7PL7O1
         HYmkg/3HM8yTQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 04:52:05PM -0500, Michael S. Tsirkin wrote:
> On Sun, Feb 21, 2021 at 04:44:37PM +0200, Eli Cohen wrote:
> > On Fri, Feb 19, 2021 at 06:54:58AM -0500, Si-Wei Liu wrote:
> > > Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> > > for legacy") made an exception for legacy guests to reset
> > > features to 0, when config space is accessed before features
> > > are set. We should relieve the verify_min_features() check
> > > and allow features reset to 0 for this case.
> > > 
> > > It's worth noting that not just legacy guests could access
> > > config space before features are set. For instance, when
> > > feature VIRTIO_NET_F_MTU is advertised some modern driver
> > > will try to access and validate the MTU present in the config
> > > space before virtio features are set. Rejecting reset to 0
> > > prematurely causes correct MTU and link status unable to load
> > > for the very first config space access, rendering issues like
> > > guest showing inaccurate MTU value, or failure to reject
> > > out-of-range MTU.
> > > 
> > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > ---
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
> > >  1 file changed, 1 insertion(+), 14 deletions(-)
> > > 
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index 7c1f789..540dd67 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
> > >  	return mvdev->mlx_features;
> > >  }
> > >  
> > > -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> > > -{
> > > -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> > > -		return -EOPNOTSUPP;
> > > -
> > > -	return 0;
> > > -}
> > > -
> > 
> > But what if VIRTIO_F_ACCESS_PLATFORM is not offerred? This does not
> > support such cases.
> 
> Did you mean "catch such cases" rather than "support"?
> 

Actually I meant this driver/device does not support such cases.

> 
> > Maybe we should call verify_min_features() from mlx5_vdpa_set_status()
> > just before attempting to call setup_driver().
> > 
> > >  static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
> > >  {
> > >  	int err;
> > > @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
> > >  {
> > >  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
> > >  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> > > -	int err;
> > >  
> > >  	print_features(mvdev, features, true);
> > >  
> > > -	err = verify_min_features(mvdev, features);
> > > -	if (err)
> > > -		return err;
> > > -
> > >  	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
> > >  	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
> > >  	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
> > > -	return err;
> > > +	return 0;
> > >  }
> > >  
> > >  static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)
> > > -- 
> > > 1.8.3.1
> > > 
> 
