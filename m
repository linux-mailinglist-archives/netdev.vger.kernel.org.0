Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648ED31CCD5
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 16:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBPPWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 10:22:35 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5905 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhBPPWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 10:22:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602be3110000>; Tue, 16 Feb 2021 07:21:53 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Feb 2021 15:21:51 +0000
Date:   Tue, 16 Feb 2021 17:21:48 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] vdpa/mlx5: defer clear_virtqueues to until
 DRIVER_OK
Message-ID: <20210216152148.GA99540@mtl-vdi-166.wap.labs.mlnx>
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
 <1612993680-29454-4-git-send-email-si-wei.liu@oracle.com>
 <20210211073314.GB100783@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210211073314.GB100783@mtl-vdi-166.wap.labs.mlnx>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613488913; bh=oljyvW9QX6a5ATx1aSFBKfVM2GqJ4ZFr/3Fr2sk5rHw=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=O73rwWccv6ouPtIofhZsE42cFZL9RoBYP4RIVxu9Gm3SEEPbBhajBhqBd1maE5xxs
         3b80SDMrXHTn5HYWlByE7arBih42IEZQt9lW1508/PhIPTrM5zqDqmSsCZxESuAzud
         EZsnhI6A3JymxYBCCh7eSwEKwOTRHcUWXe1VdRSqYcTHDVz+sYfFrtYAJ2H9AevYK3
         0YcidfiJeKyEwKYQzbpoiYXRNZVxY9SMHGO8kyYh9Er6NMJg1l1f3qv9sYFvbR0TLr
         NWkMgCggiKF9rm8nDQhgjTf4VVexAwL6etJANWcuN9CoFe5nW3U4kRrdupidx6nZ8a
         wCqi0BlEDg/ew==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 09:33:14AM +0200, Eli Cohen wrote:
> On Wed, Feb 10, 2021 at 01:48:00PM -0800, Si-Wei Liu wrote:
> > While virtq is stopped,  get_vq_state() is supposed to
> > be  called to  get  sync'ed  with  the latest internal
> > avail_index from device. The saved avail_index is used
> > to restate  the virtq  once device is started.  Commit
> > b35ccebe3ef7 introduced the clear_virtqueues() routine
> > to  reset  the saved  avail_index,  however, the index
> > gets cleared a bit earlier before get_vq_state() tries
> > to read it. This would cause consistency problems when
> > virtq is restarted, e.g. through a series of link down
> > and link up events. We  could  defer  the  clearing of
> > avail_index  to  until  the  device  is to be started,
> > i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
> > set_status().
> > 
> > Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
> > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> 
> Acked-by: Eli Cohen <elic@nvidia.com>
> 

I take it back. I think we don't need to clear the indexes at all. In
case we need to restore indexes we'll get the right values through
set_vq_state(). If we suspend the virtqueue due to VM being suspended,
qemu will query first and will provide the the queried value. In case of
VM reboot, it will provide 0 in set_vq_state().

I am sending a patch that addresses both reboot and suspend.

> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 7c1f789..ce6aae8 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1777,7 +1777,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> >  	if (!status) {
> >  		mlx5_vdpa_info(mvdev, "performing device reset\n");
> >  		teardown_driver(ndev);
> > -		clear_virtqueues(ndev);
> >  		mlx5_vdpa_destroy_mr(&ndev->mvdev);
> >  		ndev->mvdev.status = 0;
> >  		++mvdev->generation;
> > @@ -1786,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> >  
> >  	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
> >  		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
> > +			clear_virtqueues(ndev);
> >  			err = setup_driver(ndev);
> >  			if (err) {
> >  				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
> > -- 
> > 1.8.3.1
> > 
