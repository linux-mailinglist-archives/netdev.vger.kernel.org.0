Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7EEB7A26
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388195AbfISNIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732271AbfISNIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 09:08:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2765189810C;
        Thu, 19 Sep 2019 13:08:35 +0000 (UTC)
Received: from [10.72.12.81] (ovpn-12-81.pek2.redhat.com [10.72.12.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABF825D9CC;
        Thu, 19 Sep 2019 13:08:22 +0000 (UTC)
Subject: Re: [RFC v4 0/3] vhost: introduce mdev based hardware backend
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20190917010204.30376-1-tiwei.bie@intel.com>
 <993841ed-942e-c90b-8016-8e7dc76bf13a@redhat.com>
 <20190917105801.GA24855@___>
 <fa6957f3-19ad-f351-8c43-65bc8342b82e@redhat.com>
 <20190918102923-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d2efe7e4-cf13-437d-e2dc-e2779fac7d2f@redhat.com>
Date:   Thu, 19 Sep 2019 21:08:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918102923-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 19 Sep 2019 13:08:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/18 下午10:32, Michael S. Tsirkin wrote:
>>>> So I have some questions:
>>>>
>>>> 1) Compared to method 2, what's the advantage of creating a new vhost char
>>>> device? I guess it's for keep the API compatibility?
>>> One benefit is that we can avoid doing vhost ioctls on
>>> VFIO device fd.
>> Yes, but any benefit from doing this?
> It does seem a bit more modular, but it's certainly not a big deal.


Ok, if we go this way, it could be as simple as provide some callback to 
vhost, then vhost can just forward the ioctl through parent_ops.


>
>>>> 2) For method 2, is there any easy way for user/admin to distinguish e.g
>>>> ordinary vfio-mdev for vhost from ordinary vfio-mdev?
>>> I think device-api could be a choice.
>> Ok.
>>
>>
>>>> I saw you introduce
>>>> ops matching helper but it's not friendly to management.
>>> The ops matching helper is just to check whether a given
>>> vfio-device is based on a mdev device.
>>>
>>>> 3) A drawback of 1) and 2) is that it must follow vfio_device_ops that
>>>> assumes the parameter comes from userspace, it prevents support kernel
>>>> virtio drivers.
>>>>
>>>> 4) So comes the idea of method 3, since it register a new vhost-mdev driver,
>>>> we can use device specific ops instead of VFIO ones, then we can have a
>>>> common API between vDPA parent and vhost-mdev/virtio-mdev drivers.
>>> As the above draft shows, this requires introducing a new
>>> VFIO device driver. I think Alex's opinion matters here.


Just to clarify, a new type of mdev driver but provides dummy 
vfio_device_ops for VFIO to make container DMA ioctl work.

Thanks


>> Yes, it is.
>>
>> Thanks
>>
>>
