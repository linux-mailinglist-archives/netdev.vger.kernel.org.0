Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADFCB4604
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 05:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392230AbfIQDcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 23:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730000AbfIQDcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 23:32:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6592F10CC1E4;
        Tue, 17 Sep 2019 03:32:17 +0000 (UTC)
Received: from [10.72.12.121] (ovpn-12-121.pek2.redhat.com [10.72.12.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB54460126;
        Tue, 17 Sep 2019 03:32:05 +0000 (UTC)
Subject: Re: [RFC v4 0/3] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20190917010204.30376-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <993841ed-942e-c90b-8016-8e7dc76bf13a@redhat.com>
Date:   Tue, 17 Sep 2019 11:32:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917010204.30376-1-tiwei.bie@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Tue, 17 Sep 2019 03:32:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/17 上午9:02, Tiwei Bie wrote:
> This RFC is to demonstrate below ideas,
>
> a) Build vhost-mdev on top of the same abstraction defined in
>     the virtio-mdev series [1];
>
> b) Introduce /dev/vhost-mdev to do vhost ioctls and support
>     setting mdev device as backend;
>
> Now the userspace API looks like this:
>
> - Userspace generates a compatible mdev device;
>
> - Userspace opens this mdev device with VFIO API (including
>    doing IOMMU programming for this mdev device with VFIO's
>    container/group based interface);
>
> - Userspace opens /dev/vhost-mdev and gets vhost fd;
>
> - Userspace uses vhost ioctls to setup vhost (userspace should
>    do VHOST_MDEV_SET_BACKEND ioctl with VFIO group fd and device
>    fd first before doing other vhost ioctls);
>
> Only compile test has been done for this series for now.


Have a hard thought on the architecture:

1) Create a vhost char device and pass vfio mdev device fd to it as a 
backend and translate vhost-mdev ioctl to virtio mdev transport (e.g 
read/write). DMA was done through the VFIO DMA mapping on the container 
that is attached.

We have two more choices:

2) Use vfio-mdev but do not create vhost-mdev device, instead, just 
implement vhost ioctl on vfio_device_ops, and translate them into 
virtio-mdev transport or just pass ioctl to parent.

3) Don't use vfio-mdev, create a new vhost-mdev driver, during probe 
still try to add dev to vfio group and talk to parent with device 
specific ops

So I have some questions:

1) Compared to method 2, what's the advantage of creating a new vhost 
char device? I guess it's for keep the API compatibility?

2) For method 2, is there any easy way for user/admin to distinguish e.g 
ordinary vfio-mdev for vhost from ordinary vfio-mdev?  I saw you 
introduce ops matching helper but it's not friendly to management.

3) A drawback of 1) and 2) is that it must follow vfio_device_ops that 
assumes the parameter comes from userspace, it prevents support kernel 
virtio drivers.

4) So comes the idea of method 3, since it register a new vhost-mdev 
driver, we can use device specific ops instead of VFIO ones, then we can 
have a common API between vDPA parent and vhost-mdev/virtio-mdev drivers.

What's your thoughts?

Thanks


>
> RFCv3: https://patchwork.kernel.org/patch/11117785/
>
> [1] https://lkml.org/lkml/2019/9/10/135
>
> Tiwei Bie (3):
>    vfio: support getting vfio device from device fd
>    vfio: support checking vfio driver by device ops
>    vhost: introduce mdev based hardware backend
>
>   drivers/vfio/mdev/vfio_mdev.c    |   3 +-
>   drivers/vfio/vfio.c              |  32 +++
>   drivers/vhost/Kconfig            |   9 +
>   drivers/vhost/Makefile           |   3 +
>   drivers/vhost/mdev.c             | 462 +++++++++++++++++++++++++++++++
>   drivers/vhost/vhost.c            |  39 ++-
>   drivers/vhost/vhost.h            |   6 +
>   include/linux/vfio.h             |  11 +
>   include/uapi/linux/vhost.h       |  10 +
>   include/uapi/linux/vhost_types.h |   5 +
>   10 files changed, 573 insertions(+), 7 deletions(-)
>   create mode 100644 drivers/vhost/mdev.c
>
