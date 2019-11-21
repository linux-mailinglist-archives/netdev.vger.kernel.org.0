Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00891049F6
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 06:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKUFXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 00:23:08 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56385 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725819AbfKUFXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 00:23:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574313786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhoJJeMZNrnDwldtVK+Mq0KcgLm9YBFAdIN9ju4qGzM=;
        b=MrngqOF2DXre7N46eMlbiu3lkTpOxtjyqazmVWiZNZ9hTCP6JJTa/34/7Kx3RAXZJx8zz4
        ZMwHb6HGcTmfnWz8W7Bq2be5RW87bVTNx42EleFZTnvKcpeiY3ZRkA24r3wEOmUAhO84GM
        jOAX9glFllNGGjDOnk76AcBlsGAMQaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-_Oj-2s8pNEK25LIz8fytXg-1; Thu, 21 Nov 2019 00:23:04 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FB90800054;
        Thu, 21 Nov 2019 05:23:02 +0000 (UTC)
Received: from [10.72.12.204] (ovpn-12-204.pek2.redhat.com [10.72.12.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98509106F966;
        Thu, 21 Nov 2019 05:22:52 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
References: <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca> <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca> <20191120150732.2fffa141@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fb73ceea-afc9-de6e-3a62-ac3bbc345fd2@redhat.com>
Date:   Thu, 21 Nov 2019 13:22:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120150732.2fffa141@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: _Oj-2s8pNEK25LIz8fytXg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/21 =E4=B8=8A=E5=8D=886:07, Alex Williamson wrote:
> On Wed, 20 Nov 2019 14:11:08 -0400
> Jason Gunthorpe<jgg@ziepe.ca>  wrote:
>
>> On Wed, Nov 20, 2019 at 10:28:56AM -0700, Alex Williamson wrote:
>>>>> Are you objecting the mdev_set_iommu_deivce() stuffs here?
>>>> I'm questioning if it fits the vfio PCI device security model, yes.
>>> The mdev IOMMU backing device model is for when an mdev device has
>>> IOMMU based isolation, either via the PCI requester ID or via requester
>>> ID + PASID.  For example, an SR-IOV VF may be used by a vendor to
>>> provide IOMMU based translation and isolation, but the VF may not be
>>> complete otherwise to provide a self contained device.  It might
>>> require explicit coordination and interaction with the PF driver, ie.
>>> mediation.
>> In this case the PF does not look to be involved, the ICF kernel
>> driver is only manipulating registers in the same VF that the vfio
>> owns the IOMMU for.
> The mdev_set_iommu_device() call is probably getting caught up in the
> confusion of mdev as it exists today being vfio specific.  What I
> described in my reply is vfio specific.  The vfio iommu backend is
> currently the only code that calls mdev_get_iommu_device(), JasonW
> doesn't use it in the virtio-mdev code, so this seems like a stray vfio
> specific interface that's setup by IFC but never used.
>

It will be used by userspace driver through vhost-mdev code for having a=20
correct IOMMU when doing DMA mappings.

Thanks

