Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF0132B37A
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352632AbhCCD6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:58:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1446424AbhCBKyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:54:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614682358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAqWjdxHKM9RMSGR9ESqFSYlgdQLhc7If8c/sW1Qwhg=;
        b=NSHJSvHvxrAsC/WznnA1GqVuMXiy07CYvlOMenVxelL2ohRfiqf6zII1oAwuDjWYLvG5Sy
        eXshG4T+yb6ssZh1bBz/BKE2pxf3Jc5sChJVVA/QUnkEsHT6CAa3N09MMBqAd3CBCrZ9d5
        1pYgtl+03qkeQhXcB+04Kbff8S7TqYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-9W1T2-QTM_WUBQGZBTxv_g-1; Tue, 02 Mar 2021 05:52:34 -0500
X-MC-Unique: 9W1T2-QTM_WUBQGZBTxv_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABED2107ACF9;
        Tue,  2 Mar 2021 10:52:33 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3F1260BFA;
        Tue,  2 Mar 2021 10:52:28 +0000 (UTC)
Subject: Re: [PATCH] vhost-vdpa: honor CAP_IPC_LOCK
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210302091418.7226-1-jasowang@redhat.com>
 <20210302044918-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4f3dcc1e-b95d-f17c-b371-52119d693d10@redhat.com>
Date:   Tue, 2 Mar 2021 18:52:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302044918-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/2 5:51 下午, Michael S. Tsirkin wrote:
> On Tue, Mar 02, 2021 at 04:14:18AM -0500, Jason Wang wrote:
>> When CAP_IPC_LOCK is set we should not check locked memory against
>> rlimit as what has been implemented in mlock().
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Indeed and it's not just mlock.
>
> Documentation/admin-guide/perf-security.rst:
>
> RLIMIT_MEMLOCK and perf_event_mlock_kb resource constraints are ignored
> for processes with the CAP_IPC_LOCK capability.
>
> and let's add a Fixes: tag?


Sure, V2 is posted.

Thanks


>
>> ---
>>   drivers/vhost/vdpa.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index ef688c8c0e0e..e93572e2e344 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -638,7 +638,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>   	mmap_read_lock(dev->mm);
>>   
>>   	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> -	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
>> +	if (!capable(CAP_IPC_LOCK) &&
>> +	    (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit)) {
>>   		ret = -ENOMEM;
>>   		goto unlock;
>>   	}
>> -- 
>> 2.18.1

