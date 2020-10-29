Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B1529E5E0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgJ2IK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:10:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728364AbgJ2IIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603958915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wgqGqZ0wLRZyTiOM1OAwQ0bdpUaIgkZ0lF5Q0v5yLw=;
        b=QtK7/6PzAS/DlODDLPE23cpc+sdEN1Bq3hLboeuC0RTRtsAV7DncxuZEc9hm+4/6W9S36G
        qZPrc7qRZKuKLg+y4rHTQnQ/8BMs2apzMvKTo5HJr1z98c96SW0oIvjCGZZfT1oUx+tz99
        Vb1lVfVY/CiurZN8j40fxPG34JiNh1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-Ofar--SsMjSfuShHFSIQOA-1; Thu, 29 Oct 2020 04:08:33 -0400
X-MC-Unique: Ofar--SsMjSfuShHFSIQOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EAF8879528;
        Thu, 29 Oct 2020 08:08:32 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53F7710013DB;
        Thu, 29 Oct 2020 08:08:27 +0000 (UTC)
Subject: Re: [PATCH] vhost: Use mutex to protect vq_irq setup
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>, lingshan.zhu@intel.com
References: <20201028142004.GA100353@mtl-vdi-166.wap.labs.mlnx>
 <60e24a0e-0d72-51b3-216a-b3cf62fb1a58@redhat.com>
 <20201029073717.GA132479@mtl-vdi-166.wap.labs.mlnx>
 <7b92d057-75cc-8bee-6354-2fbefcd1850a@redhat.com>
 <20201029075035.GC132479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <34c4c6c0-ca95-6940-1b3f-c8c6a9cee833@redhat.com>
Date:   Thu, 29 Oct 2020 16:08:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029075035.GC132479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/29 下午3:50, Eli Cohen wrote:
> On Thu, Oct 29, 2020 at 03:39:24PM +0800, Jason Wang wrote:
>> On 2020/10/29 下午3:37, Eli Cohen wrote:
>>> On Thu, Oct 29, 2020 at 03:03:24PM +0800, Jason Wang wrote:
>>>> On 2020/10/28 下午10:20, Eli Cohen wrote:
>>>>> Both irq_bypass_register_producer() and irq_bypass_unregister_producer()
>>>>> require process context to run. Change the call context lock from
>>>>> spinlock to mutex to protect the setup process to avoid deadlocks.
>>>>>
>>>>> Fixes: 265a0ad8731d ("vhost: introduce vhost_vring_call")
>>>>> Signed-off-by: Eli Cohen<elic@nvidia.com>
>>>> Hi Eli:
>>>>
>>>> During review we spot that the spinlock is not necessary. And it was already
>>>> protected by vq mutex. So it was removed in this commit:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=86e182fe12ee5869022614457037097c70fe2ed1
>>>>
>>>> Thanks
>>>>
>>> I see, thanks.
>>>
>>> BTW, while testing irq bypassing, I noticed that qemu started crashing
>>> and I fail to boot the VM? Is that a known issue. I checked using
>>> updated master branch of qemu updated yesterday.
>> Not known yet.
>>
>>
>>> Any ideas how to check this further?
>> I would be helpful if you can paste the calltrace here.
>>
> I am not too familiar with qemu. Assuming I am using virsh start to boot
> the VM, how can I get the call trace?


You probably need to configure qemu with --enable-debug. Then after VM 
is launching, you can use gdb to attach to the qemu process, then gdb 
may report a calltrace if qemu crashes.

Thanks


