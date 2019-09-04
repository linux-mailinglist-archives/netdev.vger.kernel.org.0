Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D4AA79E0
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfIDEdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:33:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfIDEdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:33:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 00CA43082E20;
        Wed,  4 Sep 2019 04:33:10 +0000 (UTC)
Received: from [10.72.12.87] (ovpn-12-87.pek2.redhat.com [10.72.12.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95BC75C220;
        Wed,  4 Sep 2019 04:32:58 +0000 (UTC)
Subject: Re: [RFC v3] vhost: introduce mdev based hardware vhost backend
To:     Tiwei Bie <tiwei.bie@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     alex.williamson@redhat.com, maxime.coquelin@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20190828053712.26106-1-tiwei.bie@intel.com>
 <20190903043704-mutt-send-email-mst@kernel.org> <20190904024801.GA5671@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5972f30a-4f01-c953-0785-1c82b20cec58@redhat.com>
Date:   Wed, 4 Sep 2019 12:32:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904024801.GA5671@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 04 Sep 2019 04:33:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/4 上午10:48, Tiwei Bie wrote:
> On Tue, Sep 03, 2019 at 07:26:03AM -0400, Michael S. Tsirkin wrote:
>> On Wed, Aug 28, 2019 at 01:37:12PM +0800, Tiwei Bie wrote:
>>> Details about this can be found here:
>>>
>>> https://lwn.net/Articles/750770/
>>>
>>> What's new in this version
>>> ==========================
>>>
>>> There are three choices based on the discussion [1] in RFC v2:
>>>
>>>> #1. We expose a VFIO device, so we can reuse the VFIO container/group
>>>>      based DMA API and potentially reuse a lot of VFIO code in QEMU.
>>>>
>>>>      But in this case, we have two choices for the VFIO device interface
>>>>      (i.e. the interface on top of VFIO device fd):
>>>>
>>>>      A) we may invent a new vhost protocol (as demonstrated by the code
>>>>         in this RFC) on VFIO device fd to make it work in VFIO's way,
>>>>         i.e. regions and irqs.
>>>>
>>>>      B) Or as you proposed, instead of inventing a new vhost protocol,
>>>>         we can reuse most existing vhost ioctls on the VFIO device fd
>>>>         directly. There should be no conflicts between the VFIO ioctls
>>>>         (type is 0x3B) and VHOST ioctls (type is 0xAF) currently.
>>>>
>>>> #2. Instead of exposing a VFIO device, we may expose a VHOST device.
>>>>      And we will introduce a new mdev driver vhost-mdev to do this.
>>>>      It would be natural to reuse the existing kernel vhost interface
>>>>      (ioctls) on it as much as possible. But we will need to invent
>>>>      some APIs for DMA programming (reusing VHOST_SET_MEM_TABLE is a
>>>>      choice, but it's too heavy and doesn't support vIOMMU by itself).
>>> This version is more like a quick PoC to try Jason's proposal on
>>> reusing vhost ioctls. And the second way (#1/B) in above three
>>> choices was chosen in this version to demonstrate the idea quickly.
>>>
>>> Now the userspace API looks like this:
>>>
>>> - VFIO's container/group based IOMMU API is used to do the
>>>    DMA programming.
>>>
>>> - Vhost's existing ioctls are used to setup the device.
>>>
>>> And the device will report device_api as "vfio-vhost".
>>>
>>> Note that, there are dirty hacks in this version. If we decide to
>>> go this way, some refactoring in vhost.c/vhost.h may be needed.
>>>
>>> PS. The direct mapping of the notify registers isn't implemented
>>>      in this version.
>>>
>>> [1] https://lkml.org/lkml/2019/7/9/101
>>>
>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>> ....
>>
>>> +long vhost_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
>>> +		      unsigned long arg)
>>> +{
>>> +	void __user *argp = (void __user *)arg;
>>> +	struct vhost_mdev *vdpa;
>>> +	unsigned long minsz;
>>> +	int ret = 0;
>>> +
>>> +	if (!mdev)
>>> +		return -EINVAL;
>>> +
>>> +	vdpa = mdev_get_drvdata(mdev);
>>> +	if (!vdpa)
>>> +		return -ENODEV;
>>> +
>>> +	switch (cmd) {
>>> +	case VFIO_DEVICE_GET_INFO:
>>> +	{
>>> +		struct vfio_device_info info;
>>> +
>>> +		minsz = offsetofend(struct vfio_device_info, num_irqs);
>>> +
>>> +		if (copy_from_user(&info, (void __user *)arg, minsz)) {
>>> +			ret = -EFAULT;
>>> +			break;
>>> +		}
>>> +
>>> +		if (info.argsz < minsz) {
>>> +			ret = -EINVAL;
>>> +			break;
>>> +		}
>>> +
>>> +		info.flags = VFIO_DEVICE_FLAGS_VHOST;
>>> +		info.num_regions = 0;
>>> +		info.num_irqs = 0;
>>> +
>>> +		if (copy_to_user((void __user *)arg, &info, minsz)) {
>>> +			ret = -EFAULT;
>>> +			break;
>>> +		}
>>> +
>>> +		break;
>>> +	}
>>> +	case VFIO_DEVICE_GET_REGION_INFO:
>>> +	case VFIO_DEVICE_GET_IRQ_INFO:
>>> +	case VFIO_DEVICE_SET_IRQS:
>>> +	case VFIO_DEVICE_RESET:
>>> +		ret = -EINVAL;
>>> +		break;
>>> +
>>> +	case VHOST_MDEV_SET_STATE:
>>> +		ret = vhost_set_state(vdpa, argp);
>>> +		break;
>>> +	case VHOST_GET_FEATURES:
>>> +		ret = vhost_get_features(vdpa, argp);
>>> +		break;
>>> +	case VHOST_SET_FEATURES:
>>> +		ret = vhost_set_features(vdpa, argp);
>>> +		break;
>>> +	case VHOST_GET_VRING_BASE:
>>> +		ret = vhost_get_vring_base(vdpa, argp);
>>> +		break;
>>> +	default:
>>> +		ret = vhost_dev_ioctl(&vdpa->dev, cmd, argp);
>>> +		if (ret == -ENOIOCTLCMD)
>>> +			ret = vhost_vring_ioctl(&vdpa->dev, cmd, argp);
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL(vhost_mdev_ioctl);
>>
>> I don't have a problem with this approach. A small question:
>> would it make sense to have two fds: send vhost ioctls
>> on one and vfio ioctls on another?
>> We can then pass vfio fd to the vhost fd with a
>> SET_BACKEND ioctl.
>>
>> What do you think?
> I like this idea! I will give it a try.
> So we can introduce /dev/vhost-mdev to have the vhost fd,


You still need to think about how to connect it to current sysfs based 
mdev management interface, or you want to invent another API, or just 
use the /dev/vhost-net but pass vfio fd through ioctl to the file.

Thanks


>   and let
> userspace pass vfio fd to the vhost fd with a SET_BACKEND ioctl.
>
> Thanks a lot!
> Tiwei
>
>> -- 
>> MST
