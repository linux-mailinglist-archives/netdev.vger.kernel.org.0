Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C480D6DC0
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 05:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfJOD3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 23:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbfJOD3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 23:29:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C10D308624A;
        Tue, 15 Oct 2019 03:29:30 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76A635D6A9;
        Tue, 15 Oct 2019 03:29:09 +0000 (UTC)
Subject: Re: [PATCH V3 6/7] virtio: introduce a mdev based transport
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
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
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com
References: <20191011081557.28302-1-jasowang@redhat.com>
 <20191011081557.28302-7-jasowang@redhat.com>
 <20191014173942.GB5359@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cf8fa583-fb2c-67c3-15d1-64efa8d73121@redhat.com>
Date:   Tue, 15 Oct 2019 11:29:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191014173942.GB5359@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 15 Oct 2019 03:29:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/15 上午1:39, Stefan Hajnoczi wrote:
> On Fri, Oct 11, 2019 at 04:15:56PM +0800, Jason Wang wrote:
>> +struct virtio_mdev_device {
>> +	struct virtio_device vdev;
>> +	struct mdev_device *mdev;
>> +	unsigned long version;
>> +
>> +	struct virtqueue **vqs;
>> +	/* The lock to protect virtqueue list */
>> +	spinlock_t lock;
>> +	struct list_head virtqueues;
> Is this a list of struct virtio_mdev_vq_info?  Please document the
> actual type in a comment.


Ok.


>> +static int virtio_mdev_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>> +				struct virtqueue *vqs[],
>> +				vq_callback_t *callbacks[],
>> +				const char * const names[],
>> +				const bool *ctx,
>> +				struct irq_affinity *desc)
>> +{
>> +	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
>> +	struct mdev_device *mdev = vm_get_mdev(vdev);
>> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
>> +	struct virtio_mdev_callback cb;
>> +	int i, err, queue_idx = 0;
>> +
>> +	vm_dev->vqs = kmalloc_array(queue_idx, sizeof(*vm_dev->vqs),
>> +				    GFP_KERNEL);
> kmalloc_array(0, ...)?  I would have expected nvqs instead of queue_idx
> (0).
>
> What is this the purpose of vm_dev->vqs and does anything ever access it?


It's useless, will remove it.

Thanks

