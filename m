Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA91C2E1909
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 07:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLWGkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 01:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726390AbgLWGkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 01:40:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608705535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7+7+o89aTavHz0eQnsiLimPO6GFLiWT2IxDjqFbKFik=;
        b=HFI+rzayrdacpeSspkTGrpeNKs4wV6O+AJBxWUC1F/ywaKsnlPGTvx2IzUgMMQd+dxc7a+
        VMIlo139Fc6o0BbG6U945KBtJcWMGukp654HPETCWrCY9r0kcd3seflXtBltc7yWDj8KfH
        42IRQQxFqWOVejXIWqaLPo1/VypEWOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-jyb7gkX5OXiv5Uo1kvek9A-1; Wed, 23 Dec 2020 01:38:51 -0500
X-MC-Unique: jyb7gkX5OXiv5Uo1kvek9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E3FB107ACF9;
        Wed, 23 Dec 2020 06:38:49 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D83575D9CC;
        Wed, 23 Dec 2020 06:38:36 +0000 (UTC)
Subject: Re: [RFC v2 00/13] Introduce VDUSE - vDPA Device in Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        akpm@linux-foundation.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c892652a-3f57-c337-8c67-084ba6d10834@redhat.com>
Date:   Wed, 23 Dec 2020 14:38:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/22 下午10:52, Xie Yongji wrote:
> This series introduces a framework, which can be used to implement
> vDPA Devices in a userspace program. The work consist of two parts:
> control path forwarding and data path offloading.
>
> In the control path, the VDUSE driver will make use of message
> mechnism to forward the config operation from vdpa bus driver
> to userspace. Userspace can use read()/write() to receive/reply
> those control messages.
>
> In the data path, the core is mapping dma buffer into VDUSE
> daemon's address space, which can be implemented in different ways
> depending on the vdpa bus to which the vDPA device is attached.
>
> In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
> bounce-buffering mechanism to achieve that.


Rethink about the bounce buffer stuffs. I wonder instead of using kernel 
pages with mmap(), how about just use userspace pages like what vhost did?

It means we need a worker to do bouncing but we don't need to care about 
annoying stuffs like page reclaiming?


> And in vhost-vdpa case, the dma
> buffer is reside in a userspace memory region which can be shared to the
> VDUSE userspace processs via transferring the shmfd.
>
> The details and our user case is shown below:
>
> ------------------------    -------------------------   ----------------------------------------------
> |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
> |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
> |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
> ------------+-----------     -----------+------------   -------------+----------------------+---------
>              |                           |                            |                      |
>              |                           |                            |                      |
> ------------+---------------------------+----------------------------+----------------------+---------
> |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
> |    -------+--------           --------+--------            -------+--------          -----+----    |
> |           |                           |                           |                       |        |
> | ----------+----------       ----------+-----------         -------+-------                |        |
> | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
> | ----------+----------       ----------+-----------         -------+-------                |        |
> |           |      virtio bus           |                           |                       |        |
> |   --------+----+-----------           |                           |                       |        |
> |                |                      |                           |                       |        |
> |      ----------+----------            |                           |                       |        |
> |      | virtio-blk device |            |                           |                       |        |
> |      ----------+----------            |                           |                       |        |
> |                |                      |                           |                       |        |
> |     -----------+-----------           |                           |                       |        |
> |     |  virtio-vdpa driver |           |                           |                       |        |
> |     -----------+-----------           |                           |                       |        |
> |                |                      |                           |    vdpa bus           |        |
> |     -----------+----------------------+---------------------------+------------           |        |
> |                                                                                        ---+---     |
> -----------------------------------------------------------------------------------------| NIC |------
>                                                                                           ---+---
>                                                                                              |
>                                                                                     ---------+---------
>                                                                                     | Remote Storages |
>                                                                                     -------------------
>
> We make use of it to implement a block device connecting to
> our distributed storage, which can be used both in containers and
> VMs. Thus, we can have an unified technology stack in this two cases.
>
> To test it with null-blk:
>
>    $ qemu-storage-daemon \
>        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
>        --monitor chardev=charmonitor \
>        --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
>        --export vduse-blk,id=test,node-name=disk0,writable=on,vduse-id=1,num-queues=16,queue-size=128
>
> The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
>
> Future work:
>    - Improve performance (e.g. zero copy implementation in datapath)
>    - Config interrupt support
>    - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)
>
> This is now based on below series:
> https://lore.kernel.org/netdev/20201112064005.349268-1-parav@nvidia.com/
>
> V1 to V2:
> - Add vhost-vdpa support


I may miss something but I don't see any code to support that. E.g 
neither set_map nor dma_map/unmap is implemented in the config ops.

Thanks


> - Add some documents
> - Based on the vdpa management tool
> - Introduce a workqueue for irq injection
> - Replace interval tree with array map to store the iova_map
>
> Xie Yongji (13):
>    mm: export zap_page_range() for driver use
>    eventfd: track eventfd_signal() recursion depth separately in different cases
>    eventfd: Increase the recursion depth of eventfd_signal()
>    vdpa: Remove the restriction that only supports virtio-net devices
>    vdpa: Pass the netlink attributes to ops.dev_add()
>    vduse: Introduce VDUSE - vDPA Device in Userspace
>    vduse: support get/set virtqueue state
>    vdpa: Introduce process_iotlb_msg() in vdpa_config_ops
>    vduse: Add support for processing vhost iotlb message
>    vduse: grab the module's references until there is no vduse device
>    vduse/iova_domain: Support reclaiming bounce pages
>    vduse: Add memory shrinker to reclaim bounce pages
>    vduse: Introduce a workqueue for irq injection
>
>   Documentation/driver-api/vduse.rst                 |   91 ++
>   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>   drivers/vdpa/Kconfig                               |    8 +
>   drivers/vdpa/Makefile                              |    1 +
>   drivers/vdpa/vdpa.c                                |    2 +-
>   drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    3 +-
>   drivers/vdpa/vdpa_user/Makefile                    |    5 +
>   drivers/vdpa/vdpa_user/eventfd.c                   |  229 ++++
>   drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
>   drivers/vdpa/vdpa_user/iova_domain.c               |  517 ++++++++
>   drivers/vdpa/vdpa_user/iova_domain.h               |  103 ++
>   drivers/vdpa/vdpa_user/vduse.h                     |   59 +
>   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1373 ++++++++++++++++++++
>   drivers/vhost/vdpa.c                               |   34 +-
>   fs/aio.c                                           |    3 +-
>   fs/eventfd.c                                       |   20 +-
>   include/linux/eventfd.h                            |    5 +-
>   include/linux/vdpa.h                               |   11 +-
>   include/uapi/linux/vdpa.h                          |    1 +
>   include/uapi/linux/vduse.h                         |  119 ++
>   mm/memory.c                                        |    1 +
>   21 files changed, 2598 insertions(+), 36 deletions(-)
>   create mode 100644 Documentation/driver-api/vduse.rst
>   create mode 100644 drivers/vdpa/vdpa_user/Makefile
>   create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
>   create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>   create mode 100644 drivers/vdpa/vdpa_user/vduse.h
>   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>   create mode 100644 include/uapi/linux/vduse.h
>

