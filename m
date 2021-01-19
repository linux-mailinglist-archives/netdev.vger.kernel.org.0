Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931282FBF6D
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732602AbhASSs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392227AbhASR4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 12:56:39 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0E1C061388;
        Tue, 19 Jan 2021 09:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=bem/4M8L62Jn47zv1wRCWw9J4rfbubNfeTQT1T3mqyg=; b=QvmCgohUW026YsJwX313hXd8Jr
        x7vvDHWSJjtQLA3V95OFuAyAYNMBfNbcNaSYAKsknQTQydAjdn9htC3xIaF8QXf/eofbkuUOPRnEe
        9gaJ698oMxw9WSiPyC9FaQKsnBQkMdkdFUEGtUGcdCCgUeuB+x7QAZHtFU4Mx2o5+R9dy4TGDVxkT
        owoSf4FZa6ieBgfyMW9q18FJRdhQ+3B74KHEFf7Xck3H+YIPUunSzUYHizgHW75sb+VGBYjjBLbV9
        aqrNQm6Ehz6PWM3dKR4J/ILgyzls/a2xwA/tSrS5Kz/efsuUuit8GnM+NvDDsSFNxUiaQrW3thId0
        QE0ymqEg==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l1vCd-00029A-NS; Tue, 19 Jan 2021 17:54:04 +0000
Subject: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, bob.liu@oracle.com, hch@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <cfdc418c-7559-c6b1-6d8d-8f3a91a24f2b@infradead.org>
Date:   Tue, 19 Jan 2021 09:53:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210119050756.600-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Documentation comments only:

On 1/18/21 9:07 PM, Xie Yongji wrote:
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  Documentation/driver-api/vduse.rst                 |   85 ++
> 
> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
> new file mode 100644
> index 000000000000..9418a7f6646b
> --- /dev/null
> +++ b/Documentation/driver-api/vduse.rst
> @@ -0,0 +1,85 @@
> +==================================
> +VDUSE - "vDPA Device in Userspace"
> +==================================
> +
> +vDPA (virtio data path acceleration) device is a device that uses a
> +datapath which complies with the virtio specifications with vendor
> +specific control path. vDPA devices can be both physically located on
> +the hardware or emulated by software. VDUSE is a framework that makes it
> +possible to implement software-emulated vDPA devices in userspace.
> +
> +How VDUSE works
> +------------
> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> +the VDUSE character device (/dev/vduse). Then a file descriptor pointing
> +to the new resources will be returned, which can be used to implement the
> +userspace vDPA device's control path and data path.
> +
> +To implement control path, the read/write operations to the file descriptor
> +will be used to receive/reply the control messages from/to VDUSE driver.
> +Those control messages are mostly based on the vdpa_config_ops which defines
> +a unified interface to control different types of vDPA device.
> +
> +The following types of messages are provided by the VDUSE framework now:
> +
> +- VDUSE_SET_VQ_ADDR: Set the addresses of the different aspects of virtqueue.
> +
> +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> +
> +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> +
> +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
> +
> +- VDUSE_SET_VQ_STATE: Set the state (last_avail_idx) for virtqueue
> +
> +- VDUSE_GET_VQ_STATE: Get the state (last_avail_idx) for virtqueue
> +
> +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
> +
> +- VDUSE_GET_FEATURES: Get virtio features supported by the device
> +
> +- VDUSE_SET_STATUS: Set the device status
> +
> +- VDUSE_GET_STATUS: Get the device status
> +
> +- VDUSE_SET_CONFIG: Write to device specific configuration space
> +
> +- VDUSE_GET_CONFIG: Read from device specific configuration space
> +
> +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping in device IOTLB
> +
> +Please see include/linux/vdpa.h for details.
> +
> +In the data path, vDPA device's iova regions will be mapped into userspace with
> +the help of VDUSE_IOTLB_GET_FD ioctl on the userspace vDPA device fd:
> +
> +- VDUSE_IOTLB_GET_FD: get the file descriptor to iova region. Userspace can
> +  access this iova region by passing the fd to mmap(2).
> +
> +Besides, the eventfd mechanism is used to trigger interrupt callbacks and
> +receive virtqueue kicks in userspace. The following ioctls on the userspace
> +vDPA device fd are provided to support that:
> +
> +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
> +  by VDUSE driver to notify userspace to consume the vring.
> +
> +- VDUSE_VQ_SETUP_IRQFD: set the irqfd for virtqueue, this eventfd is used
> +  by userspace to notify VDUSE driver to trigger interrupt callbacks.
> +
> +MMU-based IOMMU Driver
> +----------------------
> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip IOMMU

                                                   an MMU-based

> +driver to support mapping the kernel dma buffer into the userspace iova

                                        DMA

> +region dynamically.
> +
> +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
> +The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
> +so that the userspace process is able to use its virtual address to access
> +the dma buffer in kernel.

       DMA

> +
> +And to avoid security issue, a bounce-buffering mechanism is introduced to
> +prevent userspace accessing the original buffer directly which may contain other
> +kernel data. During the mapping, unmapping, the driver will copy the data from
> +the original buffer to the bounce buffer and back, depending on the direction of
> +the transfer. And the bounce-buffer addresses will be mapped into the user address
> +space instead of the original one.


thanks.
-- 
~Randy

