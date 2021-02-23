Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F5E3228BE
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhBWKTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:19:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230142AbhBWKT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 05:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614075482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZGrk/KRVSJf4lDW/M6cnASmoATrbPhldVhOPwuWamk=;
        b=VW8XJcmINZWmLzZF2L4A/0WuMMIobwz5QkjO6OVFit4djzV0Zj1xqBglHgixjZ/iZIE8AV
        hS5T2A9fgpxoiS9GhhAIQP+CpCSFHkWU5mDZyp8t6nEBO146bqPkfIbtXuuIfy+8IqhTSF
        JLTAtursbaCN7eMPi9IJ3IHA3JrkqcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-BOWJBQAyOaygi4vJp1gqeA-1; Tue, 23 Feb 2021 05:17:58 -0500
X-MC-Unique: BOWJBQAyOaygi4vJp1gqeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C16BCC621;
        Tue, 23 Feb 2021 10:17:57 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-193.pek2.redhat.com [10.72.12.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 736D162A23;
        Tue, 23 Feb 2021 10:17:51 +0000 (UTC)
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <ee31e93b-5fbb-1999-0e82-983d3e49ad1e@oracle.com>
 <20210223041740-mutt-send-email-mst@kernel.org>
 <788a0880-0a68-20b7-5bdf-f8150b08276a@redhat.com>
 <20210223045600-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c188353e-9aca-a94c-e8f5-4bad5942481c@redhat.com>
Date:   Tue, 23 Feb 2021 18:17:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223045600-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 6:01 下午, Michael S. Tsirkin wrote:
> On Tue, Feb 23, 2021 at 05:46:20PM +0800, Jason Wang wrote:
>> On 2021/2/23 下午5:25, Michael S. Tsirkin wrote:
>>> On Mon, Feb 22, 2021 at 09:09:28AM -0800, Si-Wei Liu wrote:
>>>> On 2/21/2021 8:14 PM, Jason Wang wrote:
>>>>> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
>>>>>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>>>>>> for legacy") made an exception for legacy guests to reset
>>>>>> features to 0, when config space is accessed before features
>>>>>> are set. We should relieve the verify_min_features() check
>>>>>> and allow features reset to 0 for this case.
>>>>>>
>>>>>> It's worth noting that not just legacy guests could access
>>>>>> config space before features are set. For instance, when
>>>>>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>>>>>> will try to access and validate the MTU present in the config
>>>>>> space before virtio features are set.
>>>>> This looks like a spec violation:
>>>>>
>>>>> "
>>>>>
>>>>> The following driver-read-only field, mtu only exists if
>>>>> VIRTIO_NET_F_MTU is set. This field specifies the maximum MTU for the
>>>>> driver to use.
>>>>> "
>>>>>
>>>>> Do we really want to workaround this?
>>>> Isn't the commit 452639a64ad8 itself is a workaround for legacy guest?
>>>>
>>>> I think the point is, since there's legacy guest we'd have to support, this
>>>> host side workaround is unavoidable. Although I agree the violating driver
>>>> should be fixed (yes, it's in today's upstream kernel which exists for a
>>>> while now).
>>> Oh  you are right:
>>>
>>>
>>> static int virtnet_validate(struct virtio_device *vdev)
>>> {
>>>           if (!vdev->config->get) {
>>>                   dev_err(&vdev->dev, "%s failure: config access disabled\n",
>>>                           __func__);
>>>                   return -EINVAL;
>>>           }
>>>
>>>           if (!virtnet_validate_features(vdev))
>>>                   return -EINVAL;
>>>
>>>           if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
>>>                   int mtu = virtio_cread16(vdev,
>>>                                            offsetof(struct virtio_net_config,
>>>                                                     mtu));
>>>                   if (mtu < MIN_MTU)
>>>                           __virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
>>
>> I wonder why not simply fail here?
> Back in 2016 it went like this:
>
> 	On Thu, Jun 02, 2016 at 05:10:59PM -0400, Aaron Conole wrote:
> 	> +     if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
> 	> +             dev->mtu = virtio_cread16(vdev,
> 	> +                                       offsetof(struct virtio_net_config,
> 	> +                                                mtu));
> 	> +     }
> 	> +
> 	>       if (vi->any_header_sg)
> 	>               dev->needed_headroom = vi->hdr_len;
> 	>
>
> 	One comment though: I think we should validate the mtu.
> 	If it's invalid, clear VIRTIO_NET_F_MTU and ignore.
>
>
> Too late at this point :)
>
> I guess it's a way to tell device "I can not live with this MTU",
> device can fail FEATURES_OK if it wants to. MIN_MTU
> is an internal linux thing and at the time I felt it's better to
> try to make progress.


What if e.g the device advertise a large MTU. E.g 64K here? In that 
case, the driver can not live either. Clearing MTU won't help here.

Thanks


>
>
>>>           }
>>>
>>>           return 0;
>>> }
>>>
>>> And the spec says:
>>>
>>>
>>> The driver MUST follow this sequence to initialize a device:
>>> 1. Reset the device.
>>> 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
>>> 3. Set the DRIVER status bit: the guest OS knows how to drive the device.
>>> 4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
>>> device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
>>> fields to check that it can support the device before accepting it.
>>> 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
>>> 6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
>>> support our subset of features and the device is unusable.
>>> 7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-bus setup,
>>> reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
>>> 8. Set the DRIVER_OK status bit. At this point the device is “live”.
>>>
>>>
>>> Item 4 on the list explicitly allows reading config space before
>>> FEATURES_OK.
>>>
>>> I conclude that VIRTIO_NET_F_MTU is set means "set in device features".
>>
>> So this probably need some clarification. "is set" is used many times in the
>> spec that has different implications.
>>
>> Thanks
>>
>>
>>> Generally it is worth going over feature dependent config fields
>>> and checking whether they should be present when device feature is set
>>> or when feature bit has been negotiated, and making this clear.
>>>

