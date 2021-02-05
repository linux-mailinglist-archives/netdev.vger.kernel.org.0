Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915263103D1
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhBEDmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:42:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230333AbhBEDmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 22:42:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612496446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zxz2nycUsF5YazuV69jbv6bYyk/cSLKkrq0BMnX+Xss=;
        b=Up7ppnBwEVLU+B1h0+h3OIWMc0a8oxbMJXH3g57m6T1ZJJMur4jT3ZHcwjwMOkfYvPi8/o
        PaETG7kbNAhxobUMI1aN3ACEh+uCE0Pno9mkhWD+qD8gTxnY2XtL35x1RLz5pV0L1t58jw
        3c5Hq57cpe5beIakqFRfG06Y5w9BnYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-yoJl2KvRPDWP6d1ltDfgvA-1; Thu, 04 Feb 2021 22:40:44 -0500
X-MC-Unique: yoJl2KvRPDWP6d1ltDfgvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ECF2801975;
        Fri,  5 Feb 2021 03:40:43 +0000 (UTC)
Received: from [10.72.12.112] (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C7F75D9D2;
        Fri,  5 Feb 2021 03:40:37 +0000 (UTC)
Subject: Re: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
To:     Adrian Moreno <amorenoz@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dsahern@gmail.com, stephen@networkplumber.org, mst@redhat.com
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
 <99106d07-1730-6ed8-c847-0400be0dcd57@redhat.com>
 <1d1ff638-d498-6675-ead5-6e09213af3a8@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0017c3d7-9b04-d26c-94e2-485e4da6a778@redhat.com>
Date:   Fri, 5 Feb 2021 11:40:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1d1ff638-d498-6675-ead5-6e09213af3a8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/4 下午7:15, Adrian Moreno wrote:
> Sorry I have not followed this work as close as I would have wanted.
> Some questions below.
>
> On 2/4/21 4:16 AM, Jason Wang wrote:
>> On 2021/2/2 下午6:35, Parav Pandit wrote:
>>> Linux vdpa interface allows vdpa device management functionality.
>>> This includes adding, removing, querying vdpa devices.
>>>
>>> vdpa interface also includes showing supported management devices
>>> which support such operations.
>>>
>>> This patchset includes kernel uapi headers and a vdpa tool.
>>>
>>> examples:
>>>
>>> $ vdpa mgmtdev show
>>> vdpasim:
>>>     supported_classes net
>>>
>>> $ vdpa mgmtdev show -jp
>>> {
>>>       "show": {
>>>           "vdpasim": {
>>>               "supported_classes": [ "net" ]
>>>           }
>>>       }
>>> }
>>>
> How can a user establish the relationship between a mgmtdev and it's parent
> device (pci vf, sf, etc)?


Parav should know more but I try to answer.

I think there should be BDF information in the mgmtdev show command if 
the parent is a PCI device, or we can simply show the parent here?


>
>>> Create a vdpa device of type networking named as "foo2" from
>>> the management device vdpasim_net:
>>>
>>> $ vdpa dev add mgmtdev vdpasim_net name foo2
>>>
> I guess this command will accept a 'type' parameter once more supported_classes
> are added?


This could be extended in the future.


>
> Also, will this tool also handle the vdpa driver binding or will the user handle
> that through the vdpa bus' sysfs interface?


I think not, it's the configuration below the vdpa bus. The sysfs should 
be the only interface for managing driver binding.

Thanks


>
>>> Show the newly created vdpa device by its name:
>>> $ vdpa dev show foo2
>>> foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 256
>>>
>>> $ vdpa dev show foo2 -jp
>>> {
>>>       "dev": {
>>>           "foo2": {
>>>               "type": "network",
>>>               "mgmtdev": "vdpasim_net",
>>>               "vendor_id": 0,
>>>               "max_vqs": 2,
>>>               "max_vq_size": 256
>>>           }
>>>       }
>>> }
>>>
>>> Delete the vdpa device after its use:
>>> $ vdpa dev del foo2
>>>
>>> Patch summary:
>>> Patch-1 adds kernel headers for vdpa subsystem
>>> Patch-2 adds library routines for indent handling
>>> Patch-3 adds library routines for generic socket communication
>>> PAtch-4 adds library routine for number to string mapping
>>> Patch-5 adds vdpa tool
>>>
>>> Kernel headers are from the vhost kernel tree [1] from branch linux-next.
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>>>
>>> ---
>>
>> Adding Adrian to see if this looks good for k8s integration.
>>
>> Thanks
>>
> Thanks

