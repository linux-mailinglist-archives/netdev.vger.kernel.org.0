Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D07535EEC3
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhDNHu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:50:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348376AbhDNHu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:50:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618386605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G1+hEzV1eb9qbk1su8ULoEmf0TKJMERUcSajKB2v3vU=;
        b=bCG34M27NrCrDCIcSo67JbafZUvAWL42xR1CLPeOYRtMXxNykValAhqrAj6XR2f5YwV5so
        2xj/2X54WAKMAJ1AYlyGNXRWR/UFPP3xJjzUziRN8zN+YbGqEKovbLgp9v9YcM8ZUsKKky
        TXM/3MTMdM5RmFwB1MHJTkVGsD9K8bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-TEu0HjeTNoetCTuJjv3a9Q-1; Wed, 14 Apr 2021 03:50:02 -0400
X-MC-Unique: TEu0HjeTNoetCTuJjv3a9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A25161009600;
        Wed, 14 Apr 2021 07:49:59 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-33.pek2.redhat.com [10.72.13.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 738E110074F1;
        Wed, 14 Apr 2021 07:49:46 +0000 (UTC)
Subject: Re: [PATCH v6 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210414032909-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a7126e76-05c6-533c-9c2b-e8e3041ec5f8@redhat.com>
Date:   Wed, 14 Apr 2021 15:49:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414032909-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/14 ÏÂÎç3:34, Michael S. Tsirkin Ð´µÀ:
> On Wed, Mar 31, 2021 at 04:05:09PM +0800, Xie Yongji wrote:
>> This series introduces a framework, which can be used to implement
>> vDPA Devices in a userspace program. The work consist of two parts:
>> control path forwarding and data path offloading.
>>
>> In the control path, the VDUSE driver will make use of message
>> mechnism to forward the config operation from vdpa bus driver
>> to userspace. Userspace can use read()/write() to receive/reply
>> those control messages.
>>
>> In the data path, the core is mapping dma buffer into VDUSE
>> daemon's address space, which can be implemented in different ways
>> depending on the vdpa bus to which the vDPA device is attached.
>>
>> In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
>> bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
>> buffer is reside in a userspace memory region which can be shared to the
>> VDUSE userspace processs via transferring the shmfd.
>>
>> The details and our user case is shown below:
>>
>> ------------------------    -------------------------   ----------------------------------------------
>> |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
>> |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
>> |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
>> ------------+-----------     -----------+------------   -------------+----------------------+---------
>>              |                           |                            |                      |
>>              |                           |                            |                      |
>> ------------+---------------------------+----------------------------+----------------------+---------
>> |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
>> |    -------+--------           --------+--------            -------+--------          -----+----    |
>> |           |                           |                           |                       |        |
>> | ----------+----------       ----------+-----------         -------+-------                |        |
>> | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
>> | ----------+----------       ----------+-----------         -------+-------                |        |
>> |           |      virtio bus           |                           |                       |        |
>> |   --------+----+-----------           |                           |                       |        |
>> |                |                      |                           |                       |        |
>> |      ----------+----------            |                           |                       |        |
>> |      | virtio-blk device |            |                           |                       |        |
>> |      ----------+----------            |                           |                       |        |
>> |                |                      |                           |                       |        |
>> |     -----------+-----------           |                           |                       |        |
>> |     |  virtio-vdpa driver |           |                           |                       |        |
>> |     -----------+-----------           |                           |                       |        |
>> |                |                      |                           |    vdpa bus           |        |
>> |     -----------+----------------------+---------------------------+------------           |        |
>> |                                                                                        ---+---     |
>> -----------------------------------------------------------------------------------------| NIC |------
>>                                                                                           ---+---
>>                                                                                              |
>>                                                                                     ---------+---------
>>                                                                                     | Remote Storages |
>>                                                                                     -------------------
> This all looks quite similar to vhost-user-block except that one
> does not need any kernel support at all.
>
> So I am still scratching my head about its advantages over
> vhost-user-block.
>
>
>> We make use of it to implement a block device connecting to
>> our distributed storage, which can be used both in containers and
>> VMs. Thus, we can have an unified technology stack in this two cases.
> Maybe the container part is the answer. How does that stack look?


Yong Ji may add more and I think this has been demonstrated in the above 
figure: the userspace vDPA device can provide a kenrel virito-blk device 
via virtio_vdpa driver.

Thanks


>
>> To test it with null-blk:
>>
>>    $ qemu-storage-daemon \
>>        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
>>        --monitor chardev=charmonitor \
>>        --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
>>        --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
>>
>> The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
>>
>> Future work:
>>    - Improve performance
>>    - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)
>>
>> V5 to V6:
>> - Export receive_fd() instead of __receive_fd()
>> - Factor out the unmapping logic of pa and va separatedly
>> - Remove the logic of bounce page allocation in page fault handler
>> - Use PAGE_SIZE as IOVA allocation granule
>> - Add EPOLLOUT support
>> - Enable setting API version in userspace
>> - Fix some bugs
>>
>> V4 to V5:
>> - Remove the patch for irq binding
>> - Use a single IOTLB for all types of mapping
>> - Factor out vhost_vdpa_pa_map()
>> - Add some sample codes in document
>> - Use receice_fd_user() to pass file descriptor
>> - Fix some bugs
>>
>> V3 to V4:
>> - Rebase to vhost.git
>> - Split some patches
>> - Add some documents
>> - Use ioctl to inject interrupt rather than eventfd
>> - Enable config interrupt support
>> - Support binding irq to the specified cpu
>> - Add two module parameter to limit bounce/iova size
>> - Create char device rather than anon inode per vduse
>> - Reuse vhost IOTLB for iova domain
>> - Rework the message mechnism in control path
>>
>> V2 to V3:
>> - Rework the MMU-based IOMMU driver
>> - Use the iova domain as iova allocator instead of genpool
>> - Support transferring vma->vm_file in vhost-vdpa
>> - Add SVA support in vhost-vdpa
>> - Remove the patches on bounce pages reclaim
>>
>> V1 to V2:
>> - Add vhost-vdpa support
>> - Add some documents
>> - Based on the vdpa management tool
>> - Introduce a workqueue for irq injection
>> - Replace interval tree with array map to store the iova_map
>>
>> Xie Yongji (10):
>>    file: Export receive_fd() to modules
>>    eventfd: Increase the recursion depth of eventfd_signal()
>>    vhost-vdpa: protect concurrent access to vhost device iotlb
>>    vhost-iotlb: Add an opaque pointer for vhost IOTLB
>>    vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
>>    vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
>>    vdpa: Support transferring virtual addressing during DMA mapping
>>    vduse: Implement an MMU-based IOMMU driver
>>    vduse: Introduce VDUSE - vDPA Device in Userspace
>>    Documentation: Add documentation for VDUSE
>>
>>   Documentation/userspace-api/index.rst              |    1 +
>>   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>>   Documentation/userspace-api/vduse.rst              |  212 +++
>>   drivers/vdpa/Kconfig                               |   10 +
>>   drivers/vdpa/Makefile                              |    1 +
>>   drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
>>   drivers/vdpa/vdpa.c                                |    9 +-
>>   drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    8 +-
>>   drivers/vdpa/vdpa_user/Makefile                    |    5 +
>>   drivers/vdpa/vdpa_user/iova_domain.c               |  521 ++++++++
>>   drivers/vdpa/vdpa_user/iova_domain.h               |   70 +
>>   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1362 ++++++++++++++++++++
>>   drivers/vdpa/virtio_pci/vp_vdpa.c                  |    2 +-
>>   drivers/vhost/iotlb.c                              |   20 +-
>>   drivers/vhost/vdpa.c                               |  154 ++-
>>   fs/eventfd.c                                       |    2 +-
>>   fs/file.c                                          |    6 +
>>   include/linux/eventfd.h                            |    5 +-
>>   include/linux/file.h                               |    7 +-
>>   include/linux/vdpa.h                               |   21 +-
>>   include/linux/vhost_iotlb.h                        |    3 +
>>   include/uapi/linux/vduse.h                         |  175 +++
>>   23 files changed, 2548 insertions(+), 51 deletions(-)
>>   create mode 100644 Documentation/userspace-api/vduse.rst
>>   create mode 100644 drivers/vdpa/vdpa_user/Makefile
>>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>>   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>>   create mode 100644 include/uapi/linux/vduse.h
>>
>> -- 
>> 2.11.0

