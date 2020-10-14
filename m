Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005F928DFED
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbgJNLlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 07:41:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388177AbgJNLle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 07:41:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602675692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3IxCdR5UIFXc9Mc6E/qqs0EKX5r/+I61Pl8lD+E/EQ=;
        b=eNE4T3N/8k+Mmxdnc2TpKUQgrvQR5ZrRV0fhPlBtgU74HwWjuW6vBGsIZBXCKXSW4QYFAq
        MjswfKkjtO24+HtvdRoXWacMR4nuBE1tMALrQSRezZV+1mugUtkQF2u03W01ECZDppJ9FN
        ig/YRyeluiPw32/0WUcUE73ALpA8DjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-CRMkafWXMgybo9GQOB-Dgg-1; Wed, 14 Oct 2020 07:41:27 -0400
X-MC-Unique: CRMkafWXMgybo9GQOB-Dgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F9A510866A9;
        Wed, 14 Oct 2020 11:41:26 +0000 (UTC)
Received: from [10.72.13.215] (ovpn-13-215.pek2.redhat.com [10.72.13.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF01A5D9CD;
        Wed, 14 Oct 2020 11:41:18 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error path
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        si-wei liu <si-wei.liu@oracle.com>
Cc:     lingshan.zhu@intel.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com>
 <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
 <5F863B83.6030204@oracle.com> <20201014025025-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <06322c3a-24b1-1fc7-6914-57a920271738@redhat.com>
Date:   Wed, 14 Oct 2020 19:41:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201014025025-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/14 下午2:52, Michael S. Tsirkin wrote:
> On Tue, Oct 13, 2020 at 04:42:59PM -0700, si-wei liu wrote:
>> On 10/9/2020 7:27 PM, Jason Wang wrote:
>>> On 2020/10/3 下午1:02, Si-Wei Liu wrote:
>>>> Pinned pages are not properly accounted particularly when
>>>> mapping error occurs on IOTLB update. Clean up dangling
>>>> pinned pages for the error path. As the inflight pinned
>>>> pages, specifically for memory region that strides across
>>>> multiple chunks, would need more than one free page for
>>>> book keeping and accounting. For simplicity, pin pages
>>>> for all memory in the IOVA range in one go rather than
>>>> have multiple pin_user_pages calls to make up the entire
>>>> region. This way it's easier to track and account the
>>>> pages already mapped, particularly for clean-up in the
>>>> error path.
>>>>
>>>> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>>>> Signed-off-by: Si-Wei Liu<si-wei.liu@oracle.com>
>>>> ---
>>>> Changes in v3:
>>>> - Factor out vhost_vdpa_map() change to a separate patch
>>>>
>>>> Changes in v2:
>>>> - Fix incorrect target SHA1 referenced
>>>>
>>>>    drivers/vhost/vdpa.c | 119
>>>> ++++++++++++++++++++++++++++++---------------------
>>>>    1 file changed, 71 insertions(+), 48 deletions(-)
>>>>
>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>> index 0f27919..dad41dae 100644
>>>> --- a/drivers/vhost/vdpa.c
>>>> +++ b/drivers/vhost/vdpa.c
>>>> @@ -595,21 +595,19 @@ static int
>>>> vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>>>        struct vhost_dev *dev = &v->vdev;
>>>>        struct vhost_iotlb *iotlb = dev->iotlb;
>>>>        struct page **page_list;
>>>> -    unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>>>> +    struct vm_area_struct **vmas;
>>>>        unsigned int gup_flags = FOLL_LONGTERM;
>>>> -    unsigned long npages, cur_base, map_pfn, last_pfn = 0;
>>>> -    unsigned long locked, lock_limit, pinned, i;
>>>> +    unsigned long map_pfn, last_pfn = 0;
>>>> +    unsigned long npages, lock_limit;
>>>> +    unsigned long i, nmap = 0;
>>>>        u64 iova = msg->iova;
>>>> +    long pinned;
>>>>        int ret = 0;
>>>>          if (vhost_iotlb_itree_first(iotlb, msg->iova,
>>>>                        msg->iova + msg->size - 1))
>>>>            return -EEXIST;
>>>>    -    page_list = (struct page **) __get_free_page(GFP_KERNEL);
>>>> -    if (!page_list)
>>>> -        return -ENOMEM;
>>>> -
>>>>        if (msg->perm & VHOST_ACCESS_WO)
>>>>            gup_flags |= FOLL_WRITE;
>>>>    @@ -617,61 +615,86 @@ static int
>>>> vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>>>        if (!npages)
>>>>            return -EINVAL;
>>>>    +    page_list = kvmalloc_array(npages, sizeof(struct page *),
>>>> GFP_KERNEL);
>>>> +    vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
>>>> +                  GFP_KERNEL);
>>> This will result high order memory allocation which was what the code
>>> tried to avoid originally.
>>>
>>> Using an unlimited size will cause a lot of side effects consider VM or
>>> userspace may try to pin several TB of memory.
>> Hmmm, that's a good point. Indeed, if the guest memory demand is huge or the
>> host system is running short of free pages, kvmalloc will be problematic and
>> less efficient than the __get_free_page implementation.
> OK so ... Jason, what's the plan?
>
> How about you send a patchset with
> 1. revert this change
> 2. fix error handling leak


Work for me, but it looks like siwei want to do this.

So it's better for to send the patchset.

Thanks


>
>

