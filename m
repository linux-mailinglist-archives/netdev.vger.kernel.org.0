Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4782A3F9A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKCJFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:05:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgKCJFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604394311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NCLuRFwSBz7lCHK9Xxh7qpGQtAw7uNBdQ5Y4F/GcLRE=;
        b=RqvnYB1vnPBgGX33R86+A843771J69ctc4J/uC+GyHozwC8hVczo3PRRwmvYQLgQLBgoeZ
        JwoZNKHTT+/+PnaA0RmGsiX2THxFPxcaIPl3sHACgNTggnsBlbiTZzi/TZlek0twxVR7IS
        cCznyPGkKEoGuzeJGVl+CKiPEEctqHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-QnBW_FxePh-2eshNLH4Rrw-1; Tue, 03 Nov 2020 04:05:09 -0500
X-MC-Unique: QnBW_FxePh-2eshNLH4Rrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23D0C106B816;
        Tue,  3 Nov 2020 09:05:08 +0000 (UTC)
Received: from [10.72.13.208] (ovpn-13-208.pek2.redhat.com [10.72.13.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F47D21E97;
        Tue,  3 Nov 2020 09:04:32 +0000 (UTC)
Subject: Re: [PATCH] vhost/vsock: add IOTLB API support
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mst@redhat.com, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
References: <20201029174351.134173-1-sgarzare@redhat.com>
 <751cc074-ae68-72c8-71de-a42458058761@redhat.com>
 <20201030105422.ju2aj2bmwsckdufh@steredhat>
 <278f4732-e561-2b4f-03ee-b26455760b01@redhat.com>
 <20201102171104.eiovmkj23fle5ioj@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8648a2e3-1052-3b5b-11ce-87628ac8dd33@redhat.com>
Date:   Tue, 3 Nov 2020 17:04:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201102171104.eiovmkj23fle5ioj@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/3 上午1:11, Stefano Garzarella wrote:
> On Fri, Oct 30, 2020 at 07:44:43PM +0800, Jason Wang wrote:
>>
>> On 2020/10/30 下午6:54, Stefano Garzarella wrote:
>>> On Fri, Oct 30, 2020 at 06:02:18PM +0800, Jason Wang wrote:
>>>>
>>>> On 2020/10/30 上午1:43, Stefano Garzarella wrote:
>>>>> This patch enables the IOTLB API support for vhost-vsock devices,
>>>>> allowing the userspace to emulate an IOMMU for the guest.
>>>>>
>>>>> These changes were made following vhost-net, in details this patch:
>>>>> - exposes VIRTIO_F_ACCESS_PLATFORM feature and inits the iotlb
>>>>>   device if the feature is acked
>>>>> - implements VHOST_GET_BACKEND_FEATURES and
>>>>>   VHOST_SET_BACKEND_FEATURES ioctls
>>>>> - calls vq_meta_prefetch() before vq processing to prefetch vq
>>>>>   metadata address in IOTLB
>>>>> - provides .read_iter, .write_iter, and .poll callbacks for the
>>>>>   chardev; they are used by the userspace to exchange IOTLB messages
>>>>>
>>>>> This patch was tested with QEMU and a patch applied [1] to fix a
>>>>> simple issue:
>>>>>     $ qemu -M q35,accel=kvm,kernel-irqchip=split \
>>>>>            -drive file=fedora.qcow2,format=qcow2,if=virtio \
>>>>>            -device intel-iommu,intremap=on \
>>>>>            -device vhost-vsock-pci,guest-cid=3,iommu_platform=on
>>>>
>>>>
>>>> Patch looks good, but a question:
>>>>
>>>> It looks to me you don't enable ATS which means vhost won't get any 
>>>> invalidation request or did I miss anything?
>>>>
>>>
>>> You're right, I didn't see invalidation requests, only miss and 
>>> updates.
>>> Now I have tried to enable 'ats' and 'device-iotlb' but I still 
>>> don't see any invalidation.
>>>
>>> How can I test it? (Sorry but I don't have much experience yet with 
>>> vIOMMU)
>>
>>
>> I guess it's because the batched unmap. Maybe you can try to use 
>> "intel_iommu=strict" in guest kernel command line to see if it works.
>>
>> Btw, make sure the qemu contains the patch [1]. Otherwise ATS won't 
>> be enabled for recent Linux Kernel in the guest.
>
> The problem was my kernel, it was built with a tiny configuration.
> Using fedora stock kernel I can see the 'invalidate' requests, but I 
> also had the following issues.
>
> Do they make you ring any bells?
>
> $ ./qemu -m 4G -smp 4 -M q35,accel=kvm,kernel-irqchip=split \
>     -drive file=fedora.qcow2,format=qcow2,if=virtio \
>     -device intel-iommu,intremap=on,device-iotlb=on \
>     -device vhost-vsock-pci,guest-cid=6,iommu_platform=on,ats=on,id=v1
>
>     qemu-system-x86_64: vtd_iova_to_slpte: detected IOVA overflow     
> (iova=0x1d40000030c0)


It's a hint that IOVA exceeds the AW. It might be worth to check whether 
the missed IOVA reported from IOTLB is legal.

Thanks


> qemu-system-x86_64: vtd_iommu_translate: detected translation failure 
> (dev=00:03:00, iova=0x1d40000030c0)
>     qemu-system-x86_64: New fault is not recorded due to compression 
> of     faults
>
> Guest kernel messages:
>     [   44.940872] DMAR: DRHD: handling fault status reg 2
>     [   44.941989] DMAR: [DMA Read] Request device [00:03.0] PASID     
> ffffffff fault addr ffff88W
>     [   49.785884] DMAR: DRHD: handling fault status reg 2
>     [   49.788874] DMAR: [DMA Read] Request device [00:03.0] PASID     
> ffffffff fault addr ffff88W
>
>
> QEMU: b149dea55c Merge remote-tracking branch 
> 'remotes/cschoenebeck/tags/pull-9p-20201102' into staging
>
> Linux guest: 5.8.16-200.fc32.x86_64
>
>
> Thanks,
> Stefano
>

