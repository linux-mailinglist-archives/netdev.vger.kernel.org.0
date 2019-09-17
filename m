Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EED8B453E
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 03:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391292AbfIQB34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 21:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbfIQB34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 21:29:56 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDC728980E8;
        Tue, 17 Sep 2019 01:29:55 +0000 (UTC)
Received: from [10.72.12.121] (ovpn-12-121.pek2.redhat.com [10.72.12.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F41F05C1D6;
        Tue, 17 Sep 2019 01:29:44 +0000 (UTC)
Subject: Re: [RFC v4 0/3] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20190917010204.30376-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <980958b0-b541-6e37-830e-f2b82358845b@redhat.com>
Date:   Tue, 17 Sep 2019 09:29:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917010204.30376-1-tiwei.bie@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 17 Sep 2019 01:29:55 +0000 (UTC)
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
>
> RFCv3: https://patchwork.kernel.org/patch/11117785/
>
> [1] https://lkml.org/lkml/2019/9/10/135


Thanks a lot for the patches.

Per Michael request, the API in [1] might need some tweak, I want to 
introduce some device specific parent_ops instead of vfio specific one. 
This RFC has been posted at https://lkml.org/lkml/2019/9/12/151.


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
