Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A3E3037C3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 09:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbhAZIVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:21:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389823AbhAZIVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611649184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dMTvjaMSAfTTa27ylw0ds1j6FG5ed6ihblNq6KfLvCg=;
        b=bZBLDyENzXuzZRxelnFdJP7t9f+PFLBVPeZszFxEYzfZWzCy399RRxemPBaJS/UAAF80Xn
        jsBE7jmetKw48+hvZydtaDmi2pECeMv4OJov1CBkpWLBNJqxVYG/h3dM4jHP/4HRe/yFB9
        gPtavWxN4NOPoMJqJT569g4IrMDlM5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-THLH8a-qP6-IH6UDIF3e1g-1; Tue, 26 Jan 2021 03:19:39 -0500
X-MC-Unique: THLH8a-qP6-IH6UDIF3e1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67674195D563;
        Tue, 26 Jan 2021 08:19:37 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F9E560C47;
        Tue, 26 Jan 2021 08:19:26 +0000 (UTC)
Subject: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1f419a24-cd53-bd73-5b8a-8ab5d976a490@redhat.com>
Date:   Tue, 26 Jan 2021 16:19:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119050756.600-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午1:07, Xie Yongji wrote:
> This VDUSE driver enables implementing vDPA devices in userspace.
> Both control path and data path of vDPA devices will be able to
> be handled in userspace.
>
> In the control path, the VDUSE driver will make use of message
> mechnism to forward the config operation from vdpa bus driver
> to userspace. Userspace can use read()/write() to receive/reply
> those control messages.
>
> In the data path, VDUSE_IOTLB_GET_FD ioctl will be used to get
> the file descriptors referring to vDPA device's iova regions. Then
> userspace can use mmap() to access those iova regions. Besides,
> the eventfd mechanism is used to trigger interrupt callbacks and
> receive virtqueue kicks in userspace.
>
> Signed-off-by: Xie Yongji<xieyongji@bytedance.com>
> ---
>   Documentation/driver-api/vduse.rst                 |   85 ++
>   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>   drivers/vdpa/Kconfig                               |    7 +
>   drivers/vdpa/Makefile                              |    1 +
>   drivers/vdpa/vdpa_user/Makefile                    |    5 +
>   drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
>   drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
>   drivers/vdpa/vdpa_user/iova_domain.c               |  426 +++++++
>   drivers/vdpa/vdpa_user/iova_domain.h               |   68 ++
>   drivers/vdpa/vdpa_user/vduse.h                     |   62 +
>   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1217 ++++++++++++++++++++
>   include/uapi/linux/vdpa.h                          |    1 +
>   include/uapi/linux/vduse.h                         |  125 ++
>   13 files changed, 2267 insertions(+)
>   create mode 100644 Documentation/driver-api/vduse.rst
>   create mode 100644 drivers/vdpa/vdpa_user/Makefile
>   create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
>   create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>   create mode 100644 drivers/vdpa/vdpa_user/vduse.h
>   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>   create mode 100644 include/uapi/linux/vduse.h


Btw, if you could split this into three parts:

1) iova domain
2) vduse device
3) doc

It would be more easier for the reviewers.

Thanks

