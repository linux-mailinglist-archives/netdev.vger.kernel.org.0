Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B65F22B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 06:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfGDEcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 00:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfGDEcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 00:32:06 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE19F3082132;
        Thu,  4 Jul 2019 04:32:00 +0000 (UTC)
Received: from [10.72.12.202] (ovpn-12-202.pek2.redhat.com [10.72.12.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B705F968C7;
        Thu,  4 Jul 2019 04:31:50 +0000 (UTC)
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com
References: <20190703091339.1847-1-tiwei.bie@intel.com>
 <7b8279b2-aa7e-7adc-eeff-20dfaf4400d0@redhat.com>
 <20190703115245.GA22374@___>
 <64833f91-02cd-7143-f12e-56ab93b2418d@redhat.com> <20190703130817.GA1978@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b01b8e28-8d96-31dd-56f4-ca7793498c55@redhat.com>
Date:   Thu, 4 Jul 2019 12:31:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703130817.GA1978@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 04 Jul 2019 04:32:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/3 下午9:08, Tiwei Bie wrote:
> On Wed, Jul 03, 2019 at 08:16:23PM +0800, Jason Wang wrote:
>> On 2019/7/3 下午7:52, Tiwei Bie wrote:
>>> On Wed, Jul 03, 2019 at 06:09:51PM +0800, Jason Wang wrote:
>>>> On 2019/7/3 下午5:13, Tiwei Bie wrote:
>>>>> Details about this can be found here:
>>>>>
>>>>> https://lwn.net/Articles/750770/
>>>>>
>>>>> What's new in this version
>>>>> ==========================
>>>>>
>>>>> A new VFIO device type is introduced - vfio-vhost. This addressed
>>>>> some comments from here:https://patchwork.ozlabs.org/cover/984763/
>>>>>
>>>>> Below is the updated device interface:
>>>>>
>>>>> Currently, there are two regions of this device: 1) CONFIG_REGION
>>>>> (VFIO_VHOST_CONFIG_REGION_INDEX), which can be used to setup the
>>>>> device; 2) NOTIFY_REGION (VFIO_VHOST_NOTIFY_REGION_INDEX), which
>>>>> can be used to notify the device.
>>>>>
>>>>> 1. CONFIG_REGION
>>>>>
>>>>> The region described by CONFIG_REGION is the main control interface.
>>>>> Messages will be written to or read from this region.
>>>>>
>>>>> The message type is determined by the `request` field in message
>>>>> header. The message size is encoded in the message header too.
>>>>> The message format looks like this:
>>>>>
>>>>> struct vhost_vfio_op {
>>>>> 	__u64 request;
>>>>> 	__u32 flags;
>>>>> 	/* Flag values: */
>>>>>     #define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
>>>>> 	__u32 size;
>>>>> 	union {
>>>>> 		__u64 u64;
>>>>> 		struct vhost_vring_state state;
>>>>> 		struct vhost_vring_addr addr;
>>>>> 	} payload;
>>>>> };
>>>>>
>>>>> The existing vhost-kernel ioctl cmds are reused as the message
>>>>> requests in above structure.
>>>> Still a comments like V1. What's the advantage of inventing a new protocol?
>>> I'm trying to make it work in VFIO's way..
>>>
>>>> I believe either of the following should be better:
>>>>
>>>> - using vhost ioctl,  we can start from SET_VRING_KICK/SET_VRING_CALL and
>>>> extend it with e.g notify region. The advantages is that all exist userspace
>>>> program could be reused without modification (or minimal modification). And
>>>> vhost API hides lots of details that is not necessary to be understood by
>>>> application (e.g in the case of container).
>>> Do you mean reusing vhost's ioctl on VFIO device fd directly,
>>> or introducing another mdev driver (i.e. vhost_mdev instead of
>>> using the existing vfio_mdev) for mdev device?
>> Can we simply add them into ioctl of mdev_parent_ops?
> Right, either way, these ioctls have to be and just need to be
> added in the ioctl of the mdev_parent_ops. But another thing we
> also need to consider is that which file descriptor the userspace
> will do the ioctl() on. So I'm wondering do you mean let the
> userspace do the ioctl() on the VFIO device fd of the mdev
> device?
>

Yes. Is there any other way btw?

Thanks

