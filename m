Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DEB36E331
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 04:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbhD2CTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 22:19:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhD2CTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 22:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619662737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDHW1GjShJjBXMVMkRd2LW6Z0k5jQYIAFZdHKIa1zSo=;
        b=W1bknPeMYgfcWzf0kCijYO7Qn5DbAaXDBaTWlpNmyuAqVw48GzymBTaRKDiIdn4JBmwIaO
        dCCU3gBADT4UUnZvrnnThl3tHHlLrBKB4gGG47eGub6MTXZc/X9yMWLJz9QQAFW8veZLJ4
        y6bONjpminuSdZBFOEkrFPUA7pUj5rM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-gi_7TphcNau8938lt_LzvQ-1; Wed, 28 Apr 2021 22:18:52 -0400
X-MC-Unique: gi_7TphcNau8938lt_LzvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCEC6107ACF3;
        Thu, 29 Apr 2021 02:18:50 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-162.pek2.redhat.com [10.72.13.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65FA7226FD;
        Thu, 29 Apr 2021 02:18:45 +0000 (UTC)
Subject: Re: [PATCH] virtio-net: enable SRIOV
To:     "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz@intel.com>,
        Arkadiusz Kudan <arkadiusz.kudan@codilime.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jayagopi, Geetha" <geetha.jayagopi@intel.com>
References: <20210426102135.227802-1-arkadiusz.kudan@codilime.com>
 <625a6618-bb59-8ccc-bf1c-e29ac556b590@redhat.com>
 <MWHPR1101MB209476B1939ADB73C57E71AC9E409@MWHPR1101MB2094.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5616038a-6a96-9a25-c2e2-7fa216b76126@redhat.com>
Date:   Thu, 29 Apr 2021 10:18:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <MWHPR1101MB209476B1939ADB73C57E71AC9E409@MWHPR1101MB2094.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/28 下午9:32, Walukiewicz, Miroslaw 写道:
> HI Jason,
>
> You are right here. We did not catch your change in driver and the SRIOV flag is set correctly as you stated.
>
> We want to orchestrate the HW implementation of VFs and PFs for virtio-net using libvirt.
>
> The issue that we want to resolve is that there is no .ndo_get_vf_config Callback implemented in virtio-net driver as other NIC's drivers have, called by libvirt.
> See https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/igb/igb_main.c#L2996, for example
> This callback really should create a minimal configuration inside of driver, but we cannot avoid it.


The reason for not implementing that callback is because the attributes 
are not implemented in the virtio spec.

We're working on adding management plane to virtio spec[1].


>
> Another issue is lack of sysfs fro virtual functions /sys/class/net/ens801f0/device/virtfnX (where X is VF number and ens801fo is its PF netdev),


What hardware did you use?

I'm using ifcvf (the hardware not the vdpa driver) and it works like a 
charm:

# pwd
/sys/bus/pci/drivers/virtio-pci/0000:07:00.0
# echo 4 > sriov_numvfs
# ls | grep virtfn
virtfn0
virtfn1
virtfn2
virtfn3

Thanks

[1] 
https://lists.oasis-open.org/archives/virtio-comment/202101/msg00047.html


>
> Could you advise us, how we can solve our issue and drive us to proper solution?
>
> Regards,
>
> Mirek
> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: wtorek, 27 kwietnia 2021 04:44
> To: Arkadiusz Kudan <arkadiusz.kudan@codilime.com>; virtualization@lists.linux-foundation.org
> Cc: mst@redhat.com; netdev@vger.kernel.org; Walukiewicz, Miroslaw <Miroslaw.Walukiewicz@intel.com>
> Subject: Re: [PATCH] virtio-net: enable SRIOV
>
>
> 在 2021/4/26 下午6:21, Arkadiusz Kudan 写道:
>> With increasing interest for virtio, NIC have appeared that provide
>> SRIOV with PF appearing in the host as a virtio network device and
>> probably more similiar NICs will emerge.
>> igb_uio of DPDK or pci-pf-stub can be used to provide SRIOV, however
>> there are hypervisors/VMMs that require VFs, which are to be PCI
>> passthrued to a VM, to have its PF with network representation in the
>> kernel. For virtio-net based PFs, virtio-net could do that by
>> providing both SRIOV interface and netdev representation.
>>
>> Enable SRIOV via VIRTIO_F_SR_IOV feature bit if the device supports
>> it.
>>
>> Signed-off-by: Arkadiusz Kudan <arkadiusz.kudan@codilime.com>
>> Signed-off-by: Miroslaw Walukiewicz <Miroslaw.Walukiewicz@intel.com>
>> ---
>>    drivers/net/virtio_net.c | 1 +
>>    1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c index
>> 0824e6999e49..a03aa7e99689 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -3249,6 +3249,7 @@ static struct virtio_device_id id_table[] = {
>>    
>>    static unsigned int features[] = {
>>    	VIRTNET_FEATURES,
>> +	VIRTIO_F_SR_IOV,
>>    };
>
> So I'm suprised that it needs to be enabled per device. We had:
>
> static void vp_transport_features(struct virtio_device *vdev, u64 features) {
>           struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>           struct pci_dev *pci_dev = vp_dev->pci_dev;
>
>           if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>                           pci_find_ext_capability(pci_dev,
> PCI_EXT_CAP_ID_SRIOV))
>                   __virtio_set_bit(vdev, VIRTIO_F_SR_IOV); }
>
> And I had used this driver for SRIOV virtio-pci hardware for more than one year.
>
> Thanks
>
>
>>    
>>    static unsigned int features_legacy[] = {

