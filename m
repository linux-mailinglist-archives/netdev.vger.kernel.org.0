Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5E3249CB
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 05:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhBYEht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 23:37:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232177AbhBYEhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 23:37:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614227778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3Qu0W62Nsz/9XbzUBh6tNh9Gpuzlo/5AB2th8SWEnU=;
        b=EUXG16CIPmZB4y/zMmZJhyyz3v4PnuBZlsfq8lmvazD0ezNZ0nOo3TNtMXtTv5/OZjDzxy
        6D8JHFISmsnxkb6PDpNrGXecnqSM4aAkc5/pbvvrBcijBtoPOfNF0wGhOGrBPdsvwykbHh
        VMiifSioXOJsFMUU9pId2LGot8iMwoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-0zFEIR4jPIqZeJooYB1o6g-1; Wed, 24 Feb 2021 23:36:16 -0500
X-MC-Unique: 0zFEIR4jPIqZeJooYB1o6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7208A10066F3;
        Thu, 25 Feb 2021 04:36:15 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-239.pek2.redhat.com [10.72.13.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 928045F9C9;
        Thu, 25 Feb 2021 04:36:08 +0000 (UTC)
Subject: Re: [virtio-dev] Re: [PATCH] vdpa/mlx5: set_features should allow
 reset to zero
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <ee31e93b-5fbb-1999-0e82-983d3e49ad1e@oracle.com>
 <20210223041740-mutt-send-email-mst@kernel.org>
 <788a0880-0a68-20b7-5bdf-f8150b08276a@redhat.com>
 <20210223110430.2f098bc0.cohuck@redhat.com>
 <bbb0a09e-17e1-a397-1b64-6ce9afe18e44@redhat.com>
 <20210223115833.732d809c.cohuck@redhat.com>
 <8355f9b3-4cda-cd2e-98df-fed020193008@redhat.com>
 <20210224121234.0127ae4b.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <be6713d3-ac98-bbbf-1dc1-a003ed06a156@redhat.com>
Date:   Thu, 25 Feb 2021 12:36:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224121234.0127ae4b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/24 7:12 下午, Cornelia Huck wrote:
> On Wed, 24 Feb 2021 17:29:07 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2021/2/23 6:58 下午, Cornelia Huck wrote:
>>> On Tue, 23 Feb 2021 18:31:07 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>   
>>>> On 2021/2/23 6:04 下午, Cornelia Huck wrote:
>>>>> On Tue, 23 Feb 2021 17:46:20 +0800
>>>>> Jason Wang <jasowang@redhat.com> wrote:
>>>>>      
>>>>>> On 2021/2/23 下午5:25, Michael S. Tsirkin wrote:
>>>>>>> On Mon, Feb 22, 2021 at 09:09:28AM -0800, Si-Wei Liu wrote:
>>>>>>>> On 2/21/2021 8:14 PM, Jason Wang wrote:
>>>>>>>>> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
>>>>>>>>>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>>>>>>>>>> for legacy") made an exception for legacy guests to reset
>>>>>>>>>> features to 0, when config space is accessed before features
>>>>>>>>>> are set. We should relieve the verify_min_features() check
>>>>>>>>>> and allow features reset to 0 for this case.
>>>>>>>>>>
>>>>>>>>>> It's worth noting that not just legacy guests could access
>>>>>>>>>> config space before features are set. For instance, when
>>>>>>>>>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>>>>>>>>>> will try to access and validate the MTU present in the config
>>>>>>>>>> space before virtio features are set.
>>>>>>>>> This looks like a spec violation:
>>>>>>>>>
>>>>>>>>> "
>>>>>>>>>
>>>>>>>>> The following driver-read-only field, mtu only exists if
>>>>>>>>> VIRTIO_NET_F_MTU is set. This field specifies the maximum MTU for the
>>>>>>>>> driver to use.
>>>>>>>>> "
>>>>>>>>>
>>>>>>>>> Do we really want to workaround this?
>>>>>>>> Isn't the commit 452639a64ad8 itself is a workaround for legacy guest?
>>>>>>>>
>>>>>>>> I think the point is, since there's legacy guest we'd have to support, this
>>>>>>>> host side workaround is unavoidable. Although I agree the violating driver
>>>>>>>> should be fixed (yes, it's in today's upstream kernel which exists for a
>>>>>>>> while now).
>>>>>>> Oh  you are right:
>>>>>>>
>>>>>>>
>>>>>>> static int virtnet_validate(struct virtio_device *vdev)
>>>>>>> {
>>>>>>>             if (!vdev->config->get) {
>>>>>>>                     dev_err(&vdev->dev, "%s failure: config access disabled\n",
>>>>>>>                             __func__);
>>>>>>>                     return -EINVAL;
>>>>>>>             }
>>>>>>>
>>>>>>>             if (!virtnet_validate_features(vdev))
>>>>>>>                     return -EINVAL;
>>>>>>>
>>>>>>>             if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
>>>>>>>                     int mtu = virtio_cread16(vdev,
>>>>>>>                                              offsetof(struct virtio_net_config,
>>>>>>>                                                       mtu));
>>>>>>>                     if (mtu < MIN_MTU)
>>>>>>>                             __virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
>>>>>> I wonder why not simply fail here?
>>>>> I think both failing or not accepting the feature can be argued to make
>>>>> sense: "the device presented us with a mtu size that does not make
>>>>> sense" would point to failing, "we cannot work with the mtu size that
>>>>> the device presented us" would point to not negotiating the feature.
>>>>>      
>>>>>>      
>>>>>>>             }
>>>>>>>
>>>>>>>             return 0;
>>>>>>> }
>>>>>>>
>>>>>>> And the spec says:
>>>>>>>
>>>>>>>
>>>>>>> The driver MUST follow this sequence to initialize a device:
>>>>>>> 1. Reset the device.
>>>>>>> 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
>>>>>>> 3. Set the DRIVER status bit: the guest OS knows how to drive the device.
>>>>>>> 4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
>>>>>>> device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
>>>>>>> fields to check that it can support the device before accepting it.
>>>>>>> 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
>>>>>>> 6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
>>>>>>> support our subset of features and the device is unusable.
>>>>>>> 7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-bus setup,
>>>>>>> reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
>>>>>>> 8. Set the DRIVER_OK status bit. At this point the device is “live”.
>>>>>>>
>>>>>>>
>>>>>>> Item 4 on the list explicitly allows reading config space before
>>>>>>> FEATURES_OK.
>>>>>>>
>>>>>>> I conclude that VIRTIO_NET_F_MTU is set means "set in device features".
>>>>>> So this probably need some clarification. "is set" is used many times in
>>>>>> the spec that has different implications.
>>>>> Before FEATURES_OK is set by the driver, I guess it means "the device
>>>>> has offered the feature";
>>>> For me this part is ok since it clarify that it's the driver that set
>>>> the bit.
>>>>
>>>>
>>>>   
>>>>> during normal usage, it means "the feature
>>>>> has been negotiated".
>>>> /?
>>>>
>>>> It looks to me the feature negotiation is done only after device set
>>>> FEATURES_OK, or FEATURES_OK could be read from device status?
>>> I'd consider feature negotiation done when the driver reads FEATURES_OK
>>> back from the status.
>>
>> I agree.
>>
>>
>>>   
>>>>   
>>>>>     (This is a bit fuzzy for legacy mode.)
>>> ...because legacy does not have FEATURES_OK.
>>>       
>>>> The problem is the MTU description for example:
>>>>
>>>> "The following driver-read-only field, mtu only exists if
>>>> VIRTIO_NET_F_MTU is set."
>>>>
>>>> It looks to me need to use "if VIRTIO_NET_F_MTU is set by device".
>>> "offered by the device"? I don't think it should 'disappear' from the
>>> config space if the driver won't use it. (Same for other config space
>>> fields that are tied to feature bits.)
>>
>> But what happens if e.g device doesn't offer VIRTIO_NET_F_MTU? It looks
>> to according to the spec there will be no mtu field.
> I think so, yes.
>
>> And a more interesting case is VIRTIO_NET_F_MQ is not offered but
>> VIRTIO_NET_F_MTU offered. To me, it means we don't have
>> max_virtqueue_pairs but it's not how the driver is wrote today.
> That would be a bug, but it seems to me that the virtio-net driver
> reads max_virtqueue_pairs conditionally and handles absence of the
> feature correctly?


Yes, see the avove codes:

         if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
                 int mtu = virtio_cread16(vdev,
                                          offsetof(struct virtio_net_config,
                                                   mtu));
                 if (mtu < MIN_MTU)
                         __virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
         }

So it's probably too late to fix the driver.


>
>>
>>>      
>>>> Otherwise readers (at least for me), may think the MTU is only valid
>>>> if driver set the bit.
>>> I think it would still be 'valid' in the sense that it exists and has
>>> some value in there filled in by the device, but a driver reading it
>>> without negotiating the feature would be buggy. (Like in the kernel
>>> code above; the kernel not liking the value does not make the field
>>> invalid.)
>>
>> See Michael's reply, the spec allows read the config before setting
>> features.
> Yes, the period prior to finishing negotiation is obviously special.
>
>>
>>> Maybe a statement covering everything would be:
>>>
>>> "The following driver-read-only field mtu only exists if the device
>>> offers VIRTIO_NET_F_MTU and may be read by the driver during feature
>>> negotiation and after VIRTIO_NET_F_MTU has been successfully
>>> negotiated."
>>>   
>>>>   
>>>>> Should we add a wording clarification to the spec?
>>>> I think so.
>>> Some clarification would be needed for each field that depends on a
>>> feature; that would be quite verbose. Maybe we can get away with a
>>> clarifying statement?
>>>
>>> "Some config space fields may depend on a certain feature. In that
>>> case, the field exits if the device has offered the corresponding
>>> feature,
>>
>> So this implies for !VIRTIO_NET_F_MQ && VIRTIO_NET_F_MTU, the config
>> will look like:
>>
>> struct virtio_net_config {
>>           u8 mac[6];
>>           le16 status;
>>           le16 mtu;
>> };
>>
> I agree.


So consider it's probably too late to fix the driver which assumes some 
field are always persent, it looks to me need fix the spec do declare 
the fields are always existing instead.


>
>>>    and may be read by the driver during feature negotiation, and
>>> accessed by the driver after the feature has been successfully
>>> negotiated. A shorthand for this is a statement that a field only
>>> exists if a certain feature bit is set."
>>
>> I'm not sure using "shorthand" is good for the spec, at least we can
>> limit the its scope only to the configuration space part.
> Maybe "a shorthand expression"?


So the questions is should we use this for all over the spec or it will 
be only used in this speicifc part (device configuration).

Thanks


