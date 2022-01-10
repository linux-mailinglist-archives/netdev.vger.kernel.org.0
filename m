Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96934898F8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiAJM6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:58:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238598AbiAJM5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 07:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641819418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AVvp/Hc7qPRUEz7YJl4ozj14nYLlyYVQtjr0ms9L8NQ=;
        b=GoMtm1QG1S+jJ9oFHDvnKJAq2fFQyfWRt8qn1vcRIBrHgitYR+6uihJ2Igvzf/hYVAe6zd
        8o6o2DtUQYPur+D9zg2VH6Bbmbf5A5C8Wyc+3gW26v4zQe5WD9mSxhVlb4exp9XV/5qUfI
        9yVJkqcIAWwBnyhT7ar8LaG0jdy7RGU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-VaCQGt2APhmz4OfjlFBo3g-1; Mon, 10 Jan 2022 07:56:57 -0500
X-MC-Unique: VaCQGt2APhmz4OfjlFBo3g-1
Received: by mail-wm1-f70.google.com with SMTP id m17-20020a05600c3b1100b0034922b9c177so506768wms.6
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 04:56:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AVvp/Hc7qPRUEz7YJl4ozj14nYLlyYVQtjr0ms9L8NQ=;
        b=ihmHZpLGhfFh/VHtQ7J602Gba/0xjl9Cg4ahBEYas+oSkEVvEE9incS/7hJ9FQdKkB
         G6aQx0YYRgAyYJAthzreCktDh4KgWUz6dzySKjibl3Vpna+kAs0VGTxRZ3hWb2ga/CH7
         WLElXhyINic/bCy/AGKM7EB466AoDsGg2IL/ceg20JZBSMRhUZah2W3EF0UKbnlFSEhK
         A+JgLAaq78vFnfmv3xI35BjyGOoLyF0lVB6kSBbyeu/c5yu+37FagbEuzFMhS1t693N7
         rOweCcp7FNDhAjoa7V0ghrIWMzGfEfjoxrEtgAII15R8ReJNBJnlJFiodOvHGxDWoSln
         ib5w==
X-Gm-Message-State: AOAM530iNjqOUiuE56yGh6WwvTVRjO1zCWuoi0YZqPUXNjhL0RHA6sOG
        /BfvnJPerCmiu32pYvHqhqI6ppygFT+oHGyZpb7zFotc6cOFJmwUgvvZ0p0XwLHxtdTpiUhS6e5
        6+QByq/5/fmm66NXW
X-Received: by 2002:a5d:6811:: with SMTP id w17mr1492938wru.443.1641819415868;
        Mon, 10 Jan 2022 04:56:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdbhYXvkJBaz3bkMPO/rSfqHXfqP57/N68w5WuSlZAf8/gWErxx+H35vqh9TdefF+KiFBoKA==
X-Received: by 2002:a5d:6811:: with SMTP id w17mr1492925wru.443.1641819415636;
        Mon, 10 Jan 2022 04:56:55 -0800 (PST)
Received: from redhat.com ([2.55.13.160])
        by smtp.gmail.com with ESMTPSA id g6sm6862655wri.67.2022.01.10.04.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 04:56:55 -0800 (PST)
Date:   Mon, 10 Jan 2022 07:56:49 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/13] Introduce VDUSE - vDPA Device in Userspace
Message-ID: <20220110075546-mutt-send-email-mst@kernel.org>
References: <20210830141737.181-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830141737.181-1-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> This series introduces a framework that makes it possible to implement
> software-emulated vDPA devices in userspace. And to make the device
> emulation more secure, the emulated vDPA device's control path is handled
> in the kernel and only the data path is implemented in the userspace.
> 
> Since the emuldated vDPA device's control path is handled in the kernel,
> a message mechnism is introduced to make userspace be aware of the data
> path related changes. Userspace can use read()/write() to receive/reply
> the control messages.
> 
> In the data path, the core is mapping dma buffer into VDUSE daemon's
> address space, which can be implemented in different ways depending on
> the vdpa bus to which the vDPA device is attached.
> 
> In virtio-vdpa case, we implements a MMU-based software IOTLB with
> bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
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
>             |                           |                            |                      |
>             |                           |                            |                      |
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
>                                                                                          ---+---
>                                                                                             |
>                                                                                    ---------+---------
>                                                                                    | Remote Storages |
>                                                                                    -------------------
> 
> We make use of it to implement a block device connecting to
> our distributed storage, which can be used both in containers and
> VMs. Thus, we can have an unified technology stack in this two cases.
> 
> To test it with null-blk:
> 
>   $ qemu-storage-daemon \
>       --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
>       --monitor chardev=charmonitor \
>       --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
>       --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
> 
> The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse

It's been half a year - any plans to upstream this?
I'm beginning to worry I made a mistake merging this
with the module being unused by major userspace ...

> To make the userspace VDUSE processes such as qemu-storage-daemon able
> to be run by an unprivileged user. We limit the supported device type
> to virtio block device currently. The support for other device types
> can be added after the security issue of corresponding device driver
> is clarified or fixed in the future.
> 
> Future work:
>   - Improve performance
>   - Userspace library (find a way to reuse device emulation code in qemu/rust-vmm)
>   - Support more device types
> 
> V11 to V12:
> - Rebased to vhost.git
> - Add reset support for all vdpa drivers
> - Remove the dependency on other patches
> - Export eventfd_wake_count
> - Use workqueue for virtqueue kicking in some cases
> 
> V10 to V11:
> - Rebased to newest kernel tree
> - Add a device attribute for message timeout
> - Add check for the reserved field of some structures
> - Add a reset callback in vdpa_config_ops and handle it in VDUSE case
> - Remove the patches that handle virtio-vdpa reset failure
> - Document the structures in include/uapi/linux/vduse.h using kernel doc
> - Add the reserved field for struct vduse_vq_config
> 
> V9 to V10:
> - Forbid some userspace operations after a timeout
> - Rename VDUSE_DEV_INJECT_IRQ to VDUSE_DEV_INJECT_CONFIG_IRQ
> - Use fixed bounce buffer size
> - Fix more code indentation issues in include/linux/vdpa.h
> - Remove the section describing bounce-buffer mechanism in documentation
> - Fix some commit logs and documentation
> 
> V8 to V9:
> - Add VDUSE_SET_STATUS message to replace VDUSE_START/STOP_DATAPLANE messages
> - Support packed virtqueue state
> - Handle the reset failure in both virtio-vdpa and vhost-vdpa cases
> - Add more details in documentation
> - Remove VDUSE_REQ_FLAGS_NO_REPLY flag
> - Add VDUSE_VQ_SETUP ioctl to support per-vq configuration
> - Separate config interrupt injecting out of config update
> - Flush kworker for interrupt inject during resetting
> - Validate the config_size in .get_config()
> 
> V7 to V8:
> - Rebased to newest kernel tree
> - Rework VDUSE driver to handle the device's control path in kernel
> - Limit the supported device type to virtio block device
> - Export free_iova_fast()
> - Remove the virtio-blk and virtio-scsi patches (will send them alone)
> - Remove all module parameters
> - Use the same MAJOR for both control device and VDUSE devices
> - Avoid eventfd cleanup in vduse_dev_release()
> 
> V6 to V7:
> - Export alloc_iova_fast()
> - Add get_config_size() callback
> - Add some patches to avoid trusting virtio devices
> - Add limited device emulation
> - Add some documents
> - Use workqueue to inject config irq
> - Add parameter on vq irq injecting
> - Rename vduse_domain_get_mapping_page() to vduse_domain_get_coherent_page()
> - Add WARN_ON() to catch message failure
> - Add some padding/reserved fields to uAPI structure
> - Fix some bugs
> - Rebase to vhost.git
> 
> V5 to V6:
> - Export receive_fd() instead of __receive_fd()
> - Factor out the unmapping logic of pa and va separatedly
> - Remove the logic of bounce page allocation in page fault handler
> - Use PAGE_SIZE as IOVA allocation granule
> - Add EPOLLOUT support
> - Enable setting API version in userspace
> - Fix some bugs
> 
> V4 to V5:
> - Remove the patch for irq binding
> - Use a single IOTLB for all types of mapping
> - Factor out vhost_vdpa_pa_map()
> - Add some sample codes in document
> - Use receice_fd_user() to pass file descriptor
> - Fix some bugs
> 
> V3 to V4:
> - Rebase to vhost.git
> - Split some patches
> - Add some documents
> - Use ioctl to inject interrupt rather than eventfd
> - Enable config interrupt support
> - Support binding irq to the specified cpu
> - Add two module parameter to limit bounce/iova size
> - Create char device rather than anon inode per vduse
> - Reuse vhost IOTLB for iova domain
> - Rework the message mechnism in control path
> 
> V2 to V3:
> - Rework the MMU-based IOMMU driver
> - Use the iova domain as iova allocator instead of genpool
> - Support transferring vma->vm_file in vhost-vdpa
> - Add SVA support in vhost-vdpa
> - Remove the patches on bounce pages reclaim
> 
> V1 to V2:
> - Add vhost-vdpa support
> - Add some documents
> - Based on the vdpa management tool
> - Introduce a workqueue for irq injection
> - Replace interval tree with array map to store the iova_map
> 
> Xie Yongji (13):
>   iova: Export alloc_iova_fast() and free_iova_fast()
>   eventfd: Export eventfd_wake_count to modules
>   file: Export receive_fd() to modules
>   vdpa: Fix some coding style issues
>   vdpa: Add reset callback in vdpa_config_ops
>   vhost-vdpa: Handle the failure of vdpa_reset()
>   vhost-iotlb: Add an opaque pointer for vhost IOTLB
>   vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
>   vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
>   vdpa: Support transferring virtual addressing during DMA mapping
>   vduse: Implement an MMU-based software IOTLB
>   vduse: Introduce VDUSE - vDPA Device in Userspace
>   Documentation: Add documentation for VDUSE
> 
>  Documentation/userspace-api/index.rst              |    1 +
>  Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>  Documentation/userspace-api/vduse.rst              |  233 +++
>  drivers/iommu/iova.c                               |    2 +
>  drivers/vdpa/Kconfig                               |   10 +
>  drivers/vdpa/Makefile                              |    1 +
>  drivers/vdpa/ifcvf/ifcvf_main.c                    |   37 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   42 +-
>  drivers/vdpa/vdpa.c                                |    9 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   26 +-
>  drivers/vdpa/vdpa_user/Makefile                    |    5 +
>  drivers/vdpa/vdpa_user/iova_domain.c               |  545 +++++++
>  drivers/vdpa/vdpa_user/iova_domain.h               |   73 +
>  drivers/vdpa/vdpa_user/vduse_dev.c                 | 1641 ++++++++++++++++++++
>  drivers/vdpa/virtio_pci/vp_vdpa.c                  |   17 +-
>  drivers/vhost/iotlb.c                              |   20 +-
>  drivers/vhost/vdpa.c                               |  168 +-
>  fs/eventfd.c                                       |    1 +
>  fs/file.c                                          |    6 +
>  include/linux/file.h                               |    7 +-
>  include/linux/vdpa.h                               |   62 +-
>  include/linux/vhost_iotlb.h                        |    3 +
>  include/uapi/linux/vduse.h                         |  306 ++++
>  23 files changed, 3112 insertions(+), 104 deletions(-)
>  create mode 100644 Documentation/userspace-api/vduse.rst
>  create mode 100644 drivers/vdpa/vdpa_user/Makefile
>  create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>  create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>  create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>  create mode 100644 include/uapi/linux/vduse.h
> 
> -- 
> 2.11.0

