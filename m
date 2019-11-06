Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DF1F221F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKFWui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:50:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfKFWuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:50:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S+NDVwxnw7pUxx3P5o8f+I/8HtJJXwHD+rPflie4cnM=; b=pMQRdpKIQCx3SN9Vl5hh63a0q
        NN9hM0Rdx0FKjbRc5iGGjxbdKBzcS60ZVcKZX3pcxvoMr4KualdndEDr47JlzlgcGEmw70yQfewI1
        T7bj38nguBRwOjJHbfR5kz1aDqZ015cYLHqHBgeIMUOqld6zyuIA3N5V6zdW6x9UObSW4us0x+Qz4
        kUgZP3BVbKCZ2SoXTdv7WaUdAelz4i/YSG84yCv78On6N1pDStA1x/uK/u+lwrYTKCzIhLfi3J9bi
        +8mALHWxYMUbvB1tFVeq03G484MQcFQavQi2yCJuwxOzS9J58eV4AgmbpLY2iffnv5aR7Yu8gdBt7
        g9cvCQqnA==;
Received: from [2601:1c0:6280:3f0::4ba1]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSU8G-0006ML-Gr; Wed, 06 Nov 2019 22:50:32 +0000
Subject: Re: [PATCH V9 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191106070548.18980-1-jasowang@redhat.com>
 <20191106070548.18980-7-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <88efad07-70aa-3879-31e7-ace4d2ad63a1@infradead.org>
Date:   Wed, 6 Nov 2019 14:50:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191106070548.18980-7-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 11:05 PM, Jason Wang wrote:
> diff --git a/samples/Kconfig b/samples/Kconfig
> index c8dacb4dda80..13a2443e18e0 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -131,6 +131,16 @@ config SAMPLE_VFIO_MDEV_MDPY
>  	  mediated device.  It is a simple framebuffer and supports
>  	  the region display interface (VFIO_GFX_PLANE_TYPE_REGION).
>  
> +config SAMPLE_VIRTIO_MDEV_NET
> +	tristate "Build VIRTIO net example mediated device sample code -- loadable modules only"
> +	depends on VIRTIO_MDEV && VHOST_RING && m
> +	help
> +	  Build a networking sample device for use as a virtio
> +	  mediated device. The device coopreates with virtio-mdev bus

typo here:
	                              cooperates

> +	  driver to present an virtio ethernet driver for
> +	  kernel. It simply loopbacks all packets from its TX
> +	  virtqueue to its RX virtqueue.
> +
>  config SAMPLE_VFIO_MDEV_MDPY_FB
>  	tristate "Build VFIO mdpy example guest fbdev driver -- loadable module only"
>  	depends on FB && m

ciao.
-- 
~Randy

