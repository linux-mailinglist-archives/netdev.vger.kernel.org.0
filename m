Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E1322AB4
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhBWMoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:44:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16915 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhBWMoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:44:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6034f86a0000>; Tue, 23 Feb 2021 04:43:22 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 23 Feb 2021 12:43:20 +0000
Date:   Tue, 23 Feb 2021 14:43:17 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <jasowang@redhat.com>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <si-wei.liu@oracle.com>
Subject: Re: [PATCH] vdpa/mlx5: Extract correct pointer from driver data
Message-ID: <20210223124316.GA171074@mtl-vdi-166.wap.labs.mlnx>
References: <20210216055022.25248-1-elic@nvidia.com>
 <20210223073225-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223073225-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614084202; bh=Q69gPRrn3VGJ6qwrUnoht5ndKfARe2imxD6F3vClhDE=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=eYviLeYMssEBINi50XEdgGwgrrU+Thcaw7JpRM7PM2wjN37BIEFYjItljn2t5EYm7
         U0mb37Xa3VHWn6Fgx1XUnV5X2jYk9u817w85wUwpOKwbphDuv3iPaZMkdEKxS34vnq
         2Qa/2AUmmWev0aEJaqv2lLx29UOzYgfWYA0x0t8FakO412bknYJzNdIxMX2BdXInv1
         SiT4C4/GnHZ9q2tm/OX4cHILz/kMXgYH7bm5x4k5mCT4k5mgDD/DPBetmJsKTq6Hqz
         O4NPbXGRklZYuTK56bE0HfIM1TmG0lH5b3Jk7Ph0rTciCjPslRIXqm2s+cSgLmieZm
         PuVsl5oC0CqJw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 07:32:49AM -0500, Michael S. Tsirkin wrote:
> On Tue, Feb 16, 2021 at 07:50:21AM +0200, Eli Cohen wrote:
> > struct mlx5_vdpa_net pointer was stored in drvdata. Extract it as well
> > in mlx5v_remove().
> > 
> > Fixes: 74c9729dd892 ("vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> 
> Sorry which tree this is for? Couldn't apply.
> 

Drop it. The patch that adds support for management bus implicitly
addresses the issue.

> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 6b0a42183622..4103d3b64a2a 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -2036,9 +2036,9 @@ static int mlx5v_probe(struct auxiliary_device *adev,
> >  
> >  static void mlx5v_remove(struct auxiliary_device *adev)
> >  {
> > -	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
> > +	struct mlx5_vdpa_net *ndev = dev_get_drvdata(&adev->dev);
> >  
> > -	vdpa_unregister_device(&mvdev->vdev);
> > +	vdpa_unregister_device(&ndev->mvdev.vdev);
> >  }
> >  
> >  static const struct auxiliary_device_id mlx5v_id_table[] = {
> > -- 
> > 2.29.2
> 
