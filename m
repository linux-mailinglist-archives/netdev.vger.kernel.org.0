Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683DF3052EB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhA0GCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:02:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237050AbhA0Dpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:45:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611719052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ceg/CM/MoKoqri8fPYCc8f9eniAuyYgpBsh+rwCNKZc=;
        b=hVWpqE7bC5Ov+9eISQRIAvjEQuFasyHaN5q8+Djb2pUfM5GkCyt6EKd5gaQuQwx7/WrMh0
        R8jesiT8gIWNKuVjDY59GVVELmVI6gkAmLVMmFR9hSIS3gqmIt2YIjBrKDct2qa7iWnXx0
        mhPPFaB0OOyynv1PrnYXGcp9qRVB32o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-MtsRqPPfNiiSx6jVr9gLVQ-1; Tue, 26 Jan 2021 22:44:10 -0500
X-MC-Unique: MtsRqPPfNiiSx6jVr9gLVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7CAB1800D42;
        Wed, 27 Jan 2021 03:44:07 +0000 (UTC)
Received: from [10.72.13.33] (ovpn-13-33.pek2.redhat.com [10.72.13.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B19011F06D;
        Wed, 27 Jan 2021 03:43:53 +0000 (UTC)
Subject: Re: [RFC v3 05/11] vdpa: shared virtual addressing support
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-6-xieyongji@bytedance.com>
 <3d58d50c-935a-a827-e261-59282f4c8577@redhat.com>
 <CACycT3vXCaSc9Er3yzRAzf8-eEFgpQYmEaDy3129xPdb4AFdmA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d1c836a5-af67-0548-9adf-b64e762e7448@redhat.com>
Date:   Wed, 27 Jan 2021 11:43:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vXCaSc9Er3yzRAzf8-eEFgpQYmEaDy3129xPdb4AFdmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/20 下午3:10, Yongji Xie wrote:
> On Wed, Jan 20, 2021 at 1:55 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/1/19 下午12:59, Xie Yongji wrote:
>>> This patches introduces SVA (Shared Virtual Addressing)
>>> support for vDPA device. During vDPA device allocation,
>>> vDPA device driver needs to indicate whether SVA is
>>> supported by the device. Then vhost-vdpa bus driver
>>> will not pin user page and transfer userspace virtual
>>> address instead of physical address during DMA mapping.
>>>
>>> Suggested-by: Jason Wang <jasowang@redhat.com>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>    drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
>>>    drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
>>>    drivers/vdpa/vdpa.c               |  5 ++++-
>>>    drivers/vdpa/vdpa_sim/vdpa_sim.c  |  3 ++-
>>>    drivers/vhost/vdpa.c              | 35 +++++++++++++++++++++++------------
>>>    include/linux/vdpa.h              | 10 +++++++---
>>>    6 files changed, 38 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index 23474af7da40..95c4601f82f5 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -439,7 +439,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>
>>>        adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
>>>                                    dev, &ifc_vdpa_ops,
>>> -                                 IFCVF_MAX_QUEUE_PAIRS * 2, NULL);
>>> +                                 IFCVF_MAX_QUEUE_PAIRS * 2, NULL, false);
>>>        if (adapter == NULL) {
>>>                IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>>>                return -ENOMEM;
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index 77595c81488d..05988d6907f2 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -1959,7 +1959,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>>>        max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
>>>
>>>        ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
>>> -                              2 * mlx5_vdpa_max_qps(max_vqs), NULL);
>>> +                              2 * mlx5_vdpa_max_qps(max_vqs), NULL, false);
>>>        if (IS_ERR(ndev))
>>>                return PTR_ERR(ndev);
>>>
>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>> index 32bd48baffab..50cab930b2e5 100644
>>> --- a/drivers/vdpa/vdpa.c
>>> +++ b/drivers/vdpa/vdpa.c
>>> @@ -72,6 +72,7 @@ static void vdpa_release_dev(struct device *d)
>>>     * @nvqs: number of virtqueues supported by this device
>>>     * @size: size of the parent structure that contains private data
>>>     * @name: name of the vdpa device; optional.
>>> + * @sva: indicate whether SVA (Shared Virtual Addressing) is supported
>>>     *
>>>     * Driver should use vdpa_alloc_device() wrapper macro instead of
>>>     * using this directly.
>>> @@ -81,7 +82,8 @@ static void vdpa_release_dev(struct device *d)
>>>     */
>>>    struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>>>                                        const struct vdpa_config_ops *config,
>>> -                                     int nvqs, size_t size, const char *name)
>>> +                                     int nvqs, size_t size, const char *name,
>>> +                                     bool sva)
>>>    {
>>>        struct vdpa_device *vdev;
>>>        int err = -EINVAL;
>>> @@ -108,6 +110,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>>>        vdev->config = config;
>>>        vdev->features_valid = false;
>>>        vdev->nvqs = nvqs;
>>> +     vdev->sva = sva;
>>>
>>>        if (name)
>>>                err = dev_set_name(&vdev->dev, "%s", name);
>>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>>> index 85776e4e6749..03c796873a6b 100644
>>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>>> @@ -367,7 +367,8 @@ static struct vdpasim *vdpasim_create(const char *name)
>>>        else
>>>                ops = &vdpasim_net_config_ops;
>>>
>>> -     vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, VDPASIM_VQ_NUM, name);
>>> +     vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
>>> +                             VDPASIM_VQ_NUM, name, false);
>>>        if (!vdpasim)
>>>                goto err_alloc;
>>>
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index 4a241d380c40..36b6950ba37f 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -486,21 +486,25 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>>    static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>>>    {
>>>        struct vhost_dev *dev = &v->vdev;
>>> +     struct vdpa_device *vdpa = v->vdpa;
>>>        struct vhost_iotlb *iotlb = dev->iotlb;
>>>        struct vhost_iotlb_map *map;
>>>        struct page *page;
>>>        unsigned long pfn, pinned;
>>>
>>>        while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
>>> -             pinned = map->size >> PAGE_SHIFT;
>>> -             for (pfn = map->addr >> PAGE_SHIFT;
>>> -                  pinned > 0; pfn++, pinned--) {
>>> -                     page = pfn_to_page(pfn);
>>> -                     if (map->perm & VHOST_ACCESS_WO)
>>> -                             set_page_dirty_lock(page);
>>> -                     unpin_user_page(page);
>>> +             if (!vdpa->sva) {
>>> +                     pinned = map->size >> PAGE_SHIFT;
>>> +                     for (pfn = map->addr >> PAGE_SHIFT;
>>> +                          pinned > 0; pfn++, pinned--) {
>>> +                             page = pfn_to_page(pfn);
>>> +                             if (map->perm & VHOST_ACCESS_WO)
>>> +                                     set_page_dirty_lock(page);
>>> +                             unpin_user_page(page);
>>> +                     }
>>> +                     atomic64_sub(map->size >> PAGE_SHIFT,
>>> +                                     &dev->mm->pinned_vm);
>>>                }
>>> -             atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
>>>                vhost_iotlb_map_free(iotlb, map);
>>>        }
>>>    }
>>> @@ -558,13 +562,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>>>                r = iommu_map(v->domain, iova, pa, size,
>>>                              perm_to_iommu_flags(perm));
>>>        }
>>> -
>>> -     if (r)
>>> +     if (r) {
>>>                vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
>>> -     else
>>> +             return r;
>>> +     }
>>> +
>>> +     if (!vdpa->sva)
>>>                atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
>>>
>>> -     return r;
>>> +     return 0;
>>>    }
>>>
>>>    static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>>> @@ -589,6 +595,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>>                                           struct vhost_iotlb_msg *msg)
>>>    {
>>>        struct vhost_dev *dev = &v->vdev;
>>> +     struct vdpa_device *vdpa = v->vdpa;
>>>        struct vhost_iotlb *iotlb = dev->iotlb;
>>>        struct page **page_list;
>>>        unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>>> @@ -607,6 +614,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>>                                    msg->iova + msg->size - 1))
>>>                return -EEXIST;
>>>
>>> +     if (vdpa->sva)
>>> +             return vhost_vdpa_map(v, msg->iova, msg->size,
>>> +                                   msg->uaddr, msg->perm);
>>> +
>>>        /* Limit the use of memory for bookkeeping */
>>>        page_list = (struct page **) __get_free_page(GFP_KERNEL);
>>>        if (!page_list)
>>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>> index cb5a3d847af3..f86869651614 100644
>>> --- a/include/linux/vdpa.h
>>> +++ b/include/linux/vdpa.h
>>> @@ -44,6 +44,7 @@ struct vdpa_parent_dev;
>>>     * @config: the configuration ops for this device.
>>>     * @index: device index
>>>     * @features_valid: were features initialized? for legacy guests
>>> + * @sva: indicate whether SVA (Shared Virtual Addressing) is supported
>>
>> Rethink about this. I think we probably need a better name other than
>> "sva" since kernel already use that for shared virtual address space.
>> But actually we don't the whole virtual address space.
>>
> This flag is used to tell vhost-vdpa bus driver to transfer virtual
> addresses instead of physical addresses. So how about "use_va“,
> ”need_va" or "va“?


I think "use_va" or "need_va" should be fine.

Thanks


>
>> And I guess this can not work for the device that use platform IOMMU, so
>> we should check and fail if sva && !(dma_map || set_map).
>>
> Agree.
>
> Thanks,
> Yongji
>

