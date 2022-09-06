Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478675ADD2E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 04:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiIFCNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 22:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiIFCNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 22:13:08 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547F23ECC8;
        Mon,  5 Sep 2022 19:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662430387; x=1693966387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VmMSv3XVjXy1W5xIoqSZKXQGSkCAv2kavAnAZDQw2xE=;
  b=BRBpYRhDXQfG6mUeRcH7/VplLMQDtHiJmgW79lSkMJSqce6pHJpR6jWD
   EHyAmgWlnxlcSJtPe3036BU937uNBBGkoWZtzjst7LECgYZy5J2zH8wYO
   y0ZPSMokb02krcG01aFSudxcc2lq9z5QOtO6cggxzxNxId/0TGJv9JdNg
   8Kg+28RE/IV2aZujBm0anRU3LikgNR/G/TLo55k8KrS7EmT2uGhiE2WfI
   yW23WATXSbLnMS8N1DBIn7Z+1oGBzY+09JQ+fLCQUiB7n3lshbUo9opNr
   RBUPkNTyOAEAeMtp/BscdO1F9qVE3hFFet0mh3N4+FPNgtYlsm3cQzN+B
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="358197746"
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="358197746"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 19:12:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="675475407"
Received: from guotongw-mobl3.ccr.corp.intel.com (HELO [10.249.196.45]) ([10.249.196.45])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 19:12:46 -0700
Message-ID: <6be0490e-1f9c-3a7d-f5d3-8dd8e50b5fdc@intel.com>
Date:   Tue, 6 Sep 2022 10:12:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.1
Subject: Re: [RFC 1/4] vDPA/ifcvf: add get/set_vq_endian support for vDPA
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220901101601.61420-1-lingshan.zhu@intel.com>
 <20220901101601.61420-2-lingshan.zhu@intel.com>
 <04710aa1-5014-ff05-e961-a690490643bf@redhat.com>
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <04710aa1-5014-ff05-e961-a690490643bf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/2022 4:34 PM, Jason Wang wrote:
>
> 在 2022/9/1 18:15, Zhu Lingshan 写道:
>> This commit introuduces new config operatoions for vDPA:
>> vdpa_config_ops.get_vq_endian: set vq endian-ness
>> vdpa_config_ops.set_vq_endian: get vq endian-ness
>>
>> Because the endian-ness is a device wide attribute,
>> so seting a vq's endian-ness will result in changing
>> the device endian-ness, including all vqs and the config space.
>>
>> These two operations are implemented in ifcvf in this commit.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 15 +++++++++++++++
>>   include/linux/vdpa.h            | 13 +++++++++++++
>>   3 files changed, 29 insertions(+)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index f5563f665cc6..640238b95033 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -19,6 +19,7 @@
>>   #include <uapi/linux/virtio_blk.h>
>>   #include <uapi/linux/virtio_config.h>
>>   #include <uapi/linux/virtio_pci.h>
>> +#include <uapi/linux/vhost.h>
>>     #define N3000_DEVICE_ID        0x1041
>>   #define N3000_SUBSYS_DEVICE_ID    0x001A
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index f9c0044c6442..270637d0f3a5 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -684,6 +684,19 @@ static struct vdpa_notification_area 
>> ifcvf_get_vq_notification(struct vdpa_devic
>>       return area;
>>   }
>>   +static u8 ifcvf_vdpa_get_vq_endian(struct vdpa_device *vdpa_dev, 
>> u16 idx)
>> +{
>> +    return VHOST_VRING_LITTLE_ENDIAN;
>> +}
>> +
>> +static int ifcvf_vdpa_set_vq_endian(struct vdpa_device *vdpa_dev, 
>> u16 idx, u8 endian)
>> +{
>> +    if (endian != VHOST_VRING_LITTLE_ENDIAN)
>> +        return -EFAULT;
>
>
> I'm worrying that this basically make the proposed API not much useful.
>
> For example, what would userspace do if it meet this failure?
This means the device only support LE, so if the user space does not 
work with LE,
I think it should explicitly fails on the device.

And we see the device only support LE, so no need to set anything to the 
device
if LE is to set.

Thanks,
Zhu Lingshan
>
> Thanks
>
>
>> +
>> +    return 0;
>> +}
>> +
>>   /*
>>    * IFCVF currently doesn't have on-chip IOMMU, so not
>>    * implemented set_map()/dma_map()/dma_unmap()
>> @@ -715,6 +728,8 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>>       .set_config    = ifcvf_vdpa_set_config,
>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>       .get_vq_notification = ifcvf_get_vq_notification,
>> +    .get_vq_endian    = ifcvf_vdpa_get_vq_endian,
>> +    .set_vq_endian    = ifcvf_vdpa_set_vq_endian,
>>   };
>>     static struct virtio_device_id id_table_net[] = {
>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> index d282f464d2f1..5eb83453ba86 100644
>> --- a/include/linux/vdpa.h
>> +++ b/include/linux/vdpa.h
>> @@ -174,6 +174,17 @@ struct vdpa_map_file {
>>    *                @idx: virtqueue index
>>    *                Returns int: irq number of a virtqueue,
>>    *                negative number if no irq assigned.
>> + * @set_vq_endian:        set endian-ness for a virtqueue
>> + *                @vdev: vdpa device
>> + *                @idx: virtqueue index
>> + *                @endian: the endian-ness to set,
>> + *                can be VHOST_VRING_LITTLE_ENDIAN or 
>> VHOST_VRING_BIG_ENDIAN
>> + *                Returns integer: success (0) or error (< 0)
>> + * @get_vq_endian:        get the endian-ness of a virtqueue
>> + *                @vdev: vdpa device
>> + *                @idx: virtqueue index
>> + *                Returns u8, the endian-ness of the virtqueue,
>> + *                can be VHOST_VRING_LITTLE_ENDIAN or 
>> VHOST_VRING_BIG_ENDIAN
>>    * @get_vq_align:        Get the virtqueue align requirement
>>    *                for the device
>>    *                @vdev: vdpa device
>> @@ -306,6 +317,8 @@ struct vdpa_config_ops {
>>       (*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
>>       /* vq irq is not expected to be changed once DRIVER_OK is set */
>>       int (*get_vq_irq)(struct vdpa_device *vdev, u16 idx);
>> +    int (*set_vq_endian)(struct vdpa_device *vdev, u16 idx, u8 endian);
>> +    u8 (*get_vq_endian)(struct vdpa_device *vdev, u16 idx);
>>         /* Device ops */
>>       u32 (*get_vq_align)(struct vdpa_device *vdev);
>

