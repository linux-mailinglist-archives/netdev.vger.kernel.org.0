Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E202880D3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgJIDtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729272AbgJIDty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602215392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9TF1EF4zJCZjRxFtIEJ5tn74n9O/x+z0nQ+pg77K66I=;
        b=bpf5gow+v84d6k2AkEI7y9gwIYR+qPTjlRgBb6h7CuKhffFcpyYd+X7nNO6fMVGlOm+WSb
        g0wqbz3UfpstCTLDgPYxkA8LO5j7HC9it0CzXHhob11ZgrRPbFgNFLGox8R+AmDjyXTxQs
        q91X4T1wGw53xW0YBtUeqQ9yWwrTZwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-o-030-bYOD2Yu33kdPw8sA-1; Thu, 08 Oct 2020 23:49:50 -0400
X-MC-Unique: o-030-bYOD2Yu33kdPw8sA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D9731015ECB;
        Fri,  9 Oct 2020 03:49:49 +0000 (UTC)
Received: from [10.72.13.133] (ovpn-13-133.pek2.redhat.com [10.72.13.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 719415C1BD;
        Fri,  9 Oct 2020 03:49:33 +0000 (UTC)
Subject: Re: [RFC PATCH 08/24] vdpa: introduce virtqueue groups
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Miller <rob.miller@broadcom.com>,
        lingshan.zhu@intel.com, Harpreet Singh Anand <hanand@xilinx.com>,
        mhabets@solarflare.com, eli@mellanox.com,
        Adrian Moreno Zapata <amorenoz@redhat.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-9-jasowang@redhat.com>
 <CAJaqyWdDX4JoPUHHXxkB=veiK9nETyqCPEJxcrHdjLmpE4PRCg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3afd0747-d058-61b6-7818-f3c6993ef728@redhat.com>
Date:   Fri, 9 Oct 2020 11:49:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWdDX4JoPUHHXxkB=veiK9nETyqCPEJxcrHdjLmpE4PRCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/28 下午11:44, Eugenio Perez Martin wrote:
> On Thu, Sep 24, 2020 at 5:23 AM Jason Wang<jasowang@redhat.com>  wrote:
>> This patch introduces virtqueue groups to vDPA device. The virtqueue
>> group is the minimal set of virtqueues that must share an address
>> space. And the adddress space identifier could only be attached to
>> a specific virtqueue group.
>>
>> A new mandated bus operation is introduced to get the virtqueue group
>> ID for a specific virtqueue.
>>
>> All the vDPA device drivers were converted to simply support a single
>> virtqueue group.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c   |  9 ++++++++-
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c |  8 +++++++-
>>   drivers/vdpa/vdpa.c               |  4 +++-
>>   drivers/vdpa/vdpa_sim/vdpa_sim.c  | 11 ++++++++++-
>>   include/linux/vdpa.h              | 12 +++++++++---
>>   5 files changed, 37 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 076d7ac5e723..e6a0be374e51 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -327,6 +327,11 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>>          return IFCVF_QUEUE_ALIGNMENT;
>>   }
>>
>> +static u32 ifcvf_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
>> +{
>> +       return 0;
>> +}
>> +
>>   static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>>                                    unsigned int offset,
>>                                    void *buf, unsigned int len)
>> @@ -387,6 +392,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>>          .get_device_id  = ifcvf_vdpa_get_device_id,
>>          .get_vendor_id  = ifcvf_vdpa_get_vendor_id,
>>          .get_vq_align   = ifcvf_vdpa_get_vq_align,
>> +       .get_vq_group   = ifcvf_vdpa_get_vq_group,
>>          .get_config     = ifcvf_vdpa_get_config,
>>          .set_config     = ifcvf_vdpa_set_config,
>>          .set_config_cb  = ifcvf_vdpa_set_config_cb,
>> @@ -434,7 +440,8 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>
>>          adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
>>                                      dev, &ifc_vdpa_ops,
>> -                                   IFCVF_MAX_QUEUE_PAIRS * 2);
>> +                                   IFCVF_MAX_QUEUE_PAIRS * 2, 1);
>> +
>>          if (adapter == NULL) {
>>                  IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>>                  return -ENOMEM;
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index 9df69d5efe8c..4e480f4f754e 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1428,6 +1428,11 @@ static u32 mlx5_vdpa_get_vq_align(struct vdpa_device *vdev)
>>          return PAGE_SIZE;
>>   }
>>
>> +static u32 mlx5_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
>> +{
>> +       return 0;
>> +}
>> +
>>   enum { MLX5_VIRTIO_NET_F_GUEST_CSUM = 1 << 9,
>>          MLX5_VIRTIO_NET_F_CSUM = 1 << 10,
>>          MLX5_VIRTIO_NET_F_HOST_TSO6 = 1 << 11,
>> @@ -1838,6 +1843,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
>>          .get_vq_notification = mlx5_get_vq_notification,
>>          .get_vq_irq = mlx5_get_vq_irq,
>>          .get_vq_align = mlx5_vdpa_get_vq_align,
>> +       .get_vq_group = mlx5_vdpa_get_vq_group,
>>          .get_features = mlx5_vdpa_get_features,
>>          .set_features = mlx5_vdpa_set_features,
>>          .set_config_cb = mlx5_vdpa_set_config_cb,
>> @@ -1925,7 +1931,7 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
>>          max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
>>
>>          ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
>> -                                2 * mlx5_vdpa_max_qps(max_vqs));
>> +                                2 * mlx5_vdpa_max_qps(max_vqs), 1);
>>          if (IS_ERR(ndev))
>>                  return ndev;
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index a69ffc991e13..46399746ec7c 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -62,6 +62,7 @@ static void vdpa_release_dev(struct device *d)
>>    * @parent: the parent device
>>    * @config: the bus operations that is supported by this device
>>    * @nvqs: number of virtqueues supported by this device
>> + * @ngroups: number of groups supported by this device
> Hi!
>
> Maybe the description of "ngroups" could be "number of*virtqueue*
> groups supported by this device"? I think that it could be needed in
> some contexts reading the code.


Exactly.

Will fix.

Thanks


>
> Thanks!
>

