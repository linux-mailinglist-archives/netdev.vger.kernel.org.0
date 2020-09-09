Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1F32624CA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgIICG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:06:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726369AbgIICGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599617214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hetGJHzKmQX4NCLO2RauAhNQ86rD2R/wYZkTPA6dH3k=;
        b=HTD3tx2JKhzwD62Cc9ZIEUugPUt9WG1td8CHtUMlaLTN0GCUOWBRrUgxx8CtRxg+9obqPA
        iXV1+/0mssmdf5Fb9SeIC8HWsq1+ivZsxpKKMQgKgNBlWnMdv7BOEX0D5dREUz/UWa/z+Y
        xer6AZ4piZTdznnfaPU7uQor7UrSnPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-SA-GsSztMSGKQP9QCaubLg-1; Tue, 08 Sep 2020 22:06:53 -0400
X-MC-Unique: SA-GsSztMSGKQP9QCaubLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EBC2824FAB;
        Wed,  9 Sep 2020 02:06:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 064127E8CD;
        Wed,  9 Sep 2020 02:06:51 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFC2118095FF;
        Wed,  9 Sep 2020 02:06:51 +0000 (UTC)
Date:   Tue, 8 Sep 2020 22:06:50 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Message-ID: <1815785246.16284907.1599617210463.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200907110335.GA121033@mtl-vdi-166.wap.labs.mlnx>
References: <20200907075136.GA114876@mtl-vdi-166.wap.labs.mlnx> <507166908.16038290.1599476003292.JavaMail.zimbra@redhat.com> <20200907110335.GA121033@mtl-vdi-166.wap.labs.mlnx>
Subject: Re: [PATCH] vdpa/mlx5: Setup driver only if
 VIRTIO_CONFIG_S_DRIVER_OK
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.20, 10.4.195.30]
Thread-Topic: vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK
Thread-Index: NIGZWNwiAp0eeznMYcEYZRw78nk6JA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> On Mon, Sep 07, 2020 at 06:53:23AM -0400, Jason Wang wrote:
> > 
> > 
> > ----- Original Message -----
> > > If the memory map changes before the driver status is
> > > VIRTIO_CONFIG_S_DRIVER_OK, don't attempt to create resources because it
> > > may fail. For example, if the VQ is not ready there is no point in
> > > creating resources.
> > > 
> > > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5
> > > devices")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > ---
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index 9df69d5efe8c..c89cd48a0aab 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct
> > > mlx5_vdpa_net
> > > *ndev, struct vhost_iotlb *
> > >  	if (err)
> > >  		goto err_mr;
> > >  
> > > +	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
> > > +		return 0;
> > > +
> > 
> > I'm not sure I get this.
> > 
> > It looks to me if set_map() is called before DRIVER_OK, we won't build
> > any mapping?
> > 
> What would prevent that? Is it some qemu logic you're relying upon?

Ok, I think the map is still there, we just avoid to create some
resources.

> With current qemu 5.1 with lack of batching support, I get plenty calls
> to set_map which result in calls to mlx5_vdpa_change_map().
> If that happens before VIRTIO_CONFIG_S_DRIVER_OK then Imay fail (in case
> I was not called to set VQs ready).

Right, this could be solved by adding the batched IOTLB updating.

Thanks

> 
> > 
> > >  	restore_channels_info(ndev);
> > >  	err = setup_driver(ndev);
> > >  	if (err)
> > > --
> > > 2.26.0
> > > 
> > > 
> > 
> 
> 

