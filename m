Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A628D71C
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgJMXnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:43:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50308 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgJMXnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 19:43:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DNY13D165663;
        Tue, 13 Oct 2020 23:43:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : mime-version : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b1qqGFIWpqYDHDX4RNbp8f/sJA5JEAYyA31Pa9AL6pw=;
 b=LFSwBh+UoSNVnW7BOAk6AdjWGLUb0g72L1QsekIvb1q83+4oHc+dCB1Ly578yl68F2jB
 AXsjqAncDI40j+IA4zsxpUaVs2Gb4qDjd/MOCkXIkonn7WTQ08ftk0GFj82zOkDTrCFC
 Q5ECKfbl4HJbAN7bDUpeLOMXuybToQuB2iI5noFtGuIEMuPcmUo00q423yjpeLfrZatG
 xfGQI/haCAvboD6fGDh5+N4ltx0phPH6za1UzGnfm5Ch6H5XyrDvc2FhzuWZsJ6VGGP1
 xyK42TCq1/gSzfiIBxwEBPh2EQRzVZRCEgA/2gvLOWF+U2+8ptT4F+DEeuzGbyl9fqzr 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vaeb6kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 23:43:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DNZD11090248;
        Tue, 13 Oct 2020 23:43:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 343puymax2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 23:43:04 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DNh2sj030296;
        Tue, 13 Oct 2020 23:43:02 GMT
Received: from [192.168.0.28] (/73.189.186.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 16:43:01 -0700
Message-ID: <5F863B83.6030204@oracle.com>
Date:   Tue, 13 Oct 2020 16:42:59 -0700
From:   si-wei liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        lingshan.zhu@intel.com
CC:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error
 path
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com> <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com> <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
In-Reply-To: <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=2 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=2 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130165
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/9/2020 7:27 PM, Jason Wang wrote:
>
> On 2020/10/3 下午1:02, Si-Wei Liu wrote:
>> Pinned pages are not properly accounted particularly when
>> mapping error occurs on IOTLB update. Clean up dangling
>> pinned pages for the error path. As the inflight pinned
>> pages, specifically for memory region that strides across
>> multiple chunks, would need more than one free page for
>> book keeping and accounting. For simplicity, pin pages
>> for all memory in the IOVA range in one go rather than
>> have multiple pin_user_pages calls to make up the entire
>> region. This way it's easier to track and account the
>> pages already mapped, particularly for clean-up in the
>> error path.
>>
>> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>> ---
>> Changes in v3:
>> - Factor out vhost_vdpa_map() change to a separate patch
>>
>> Changes in v2:
>> - Fix incorrect target SHA1 referenced
>>
>>   drivers/vhost/vdpa.c | 119 
>> ++++++++++++++++++++++++++++++---------------------
>>   1 file changed, 71 insertions(+), 48 deletions(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 0f27919..dad41dae 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -595,21 +595,19 @@ static int 
>> vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>       struct vhost_dev *dev = &v->vdev;
>>       struct vhost_iotlb *iotlb = dev->iotlb;
>>       struct page **page_list;
>> -    unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>> +    struct vm_area_struct **vmas;
>>       unsigned int gup_flags = FOLL_LONGTERM;
>> -    unsigned long npages, cur_base, map_pfn, last_pfn = 0;
>> -    unsigned long locked, lock_limit, pinned, i;
>> +    unsigned long map_pfn, last_pfn = 0;
>> +    unsigned long npages, lock_limit;
>> +    unsigned long i, nmap = 0;
>>       u64 iova = msg->iova;
>> +    long pinned;
>>       int ret = 0;
>>         if (vhost_iotlb_itree_first(iotlb, msg->iova,
>>                       msg->iova + msg->size - 1))
>>           return -EEXIST;
>>   -    page_list = (struct page **) __get_free_page(GFP_KERNEL);
>> -    if (!page_list)
>> -        return -ENOMEM;
>> -
>>       if (msg->perm & VHOST_ACCESS_WO)
>>           gup_flags |= FOLL_WRITE;
>>   @@ -617,61 +615,86 @@ static int 
>> vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>       if (!npages)
>>           return -EINVAL;
>>   +    page_list = kvmalloc_array(npages, sizeof(struct page *), 
>> GFP_KERNEL);
>> +    vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
>> +                  GFP_KERNEL);
>
>
> This will result high order memory allocation which was what the code 
> tried to avoid originally.
>
> Using an unlimited size will cause a lot of side effects consider VM 
> or userspace may try to pin several TB of memory.
Hmmm, that's a good point. Indeed, if the guest memory demand is huge or 
the host system is running short of free pages, kvmalloc will be 
problematic and less efficient than the __get_free_page implementation.

>
>
>> +    if (!page_list || !vmas) {
>> +        ret = -ENOMEM;
>> +        goto free;
>> +    }
>
>
> Any reason that you want to use vmas?
Without providing custom vmas, it's subject to high order allocation 
failure. While page_list and vmas can now fallback to virtual memory 
allocation if need be.

>
>
>> +
>>       mmap_read_lock(dev->mm);
>>   -    locked = atomic64_add_return(npages, &dev->mm->pinned_vm);
>>       lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> -
>> -    if (locked > lock_limit) {
>> +    if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
>>           ret = -ENOMEM;
>> -        goto out;
>> +        goto unlock;
>>       }
>>   -    cur_base = msg->uaddr & PAGE_MASK;
>> -    iova &= PAGE_MASK;
>> +    pinned = pin_user_pages(msg->uaddr & PAGE_MASK, npages, gup_flags,
>> +                page_list, vmas);
>> +    if (npages != pinned) {
>> +        if (pinned < 0) {
>> +            ret = pinned;
>> +        } else {
>> +            unpin_user_pages(page_list, pinned);
>> +            ret = -ENOMEM;
>> +        }
>> +        goto unlock;
>> +    }
>>   -    while (npages) {
>> -        pinned = min_t(unsigned long, npages, list_size);
>> -        ret = pin_user_pages(cur_base, pinned,
>> -                     gup_flags, page_list, NULL);
>> -        if (ret != pinned)
>> -            goto out;
>> -
>> -        if (!last_pfn)
>> -            map_pfn = page_to_pfn(page_list[0]);
>> -
>> -        for (i = 0; i < ret; i++) {
>> -            unsigned long this_pfn = page_to_pfn(page_list[i]);
>> -            u64 csize;
>> -
>> -            if (last_pfn && (this_pfn != last_pfn + 1)) {
>> -                /* Pin a contiguous chunk of memory */
>> -                csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
>> -                if (vhost_vdpa_map(v, iova, csize,
>> -                           map_pfn << PAGE_SHIFT,
>> -                           msg->perm))
>> -                    goto out;
>> -                map_pfn = this_pfn;
>> -                iova += csize;
>> +    iova &= PAGE_MASK;
>> +    map_pfn = page_to_pfn(page_list[0]);
>> +
>> +    /* One more iteration to avoid extra vdpa_map() call out of 
>> loop. */
>> +    for (i = 0; i <= npages; i++) {
>> +        unsigned long this_pfn;
>> +        u64 csize;
>> +
>> +        /* The last chunk may have no valid PFN next to it */
>> +        this_pfn = i < npages ? page_to_pfn(page_list[i]) : -1UL;
>> +
>> +        if (last_pfn && (this_pfn == -1UL ||
>> +                 this_pfn != last_pfn + 1)) {
>> +            /* Pin a contiguous chunk of memory */
>> +            csize = last_pfn - map_pfn + 1;
>> +            ret = vhost_vdpa_map(v, iova, csize << PAGE_SHIFT,
>> +                         map_pfn << PAGE_SHIFT,
>> +                         msg->perm);
>> +            if (ret) {
>> +                /*
>> +                 * Unpin the rest chunks of memory on the
>> +                 * flight with no corresponding vdpa_map()
>> +                 * calls having been made yet. On the other
>> +                 * hand, vdpa_unmap() in the failure path
>> +                 * is in charge of accounting the number of
>> +                 * pinned pages for its own.
>> +                 * This asymmetrical pattern of accounting
>> +                 * is for efficiency to pin all pages at
>> +                 * once, while there is no other callsite
>> +                 * of vdpa_map() than here above.
>> +                 */
>> +                unpin_user_pages(&page_list[nmap],
>> +                         npages - nmap);
>> +                goto out;
>>               }
>> -
>> -            last_pfn = this_pfn;
>> +            atomic64_add(csize, &dev->mm->pinned_vm);
>> +            nmap += csize;
>> +            iova += csize << PAGE_SHIFT;
>> +            map_pfn = this_pfn;
>>           }
>> -
>> -        cur_base += ret << PAGE_SHIFT;
>> -        npages -= ret;
>> +        last_pfn = this_pfn;
>>       }
>
>
> So what I suggest is to fix the pinning leakage first and do the 
> possible optimization on top (which is still questionable to me).
OK. Unfortunately, this was picked and got merged in upstream. So I will 
post a follow up patch set to 1) revert the commit to the original 
__get_free_page() implementation, and 2) fix the accounting and leakage 
on top. Will it be fine?


-Siwei
>
> Thanks
>
>
>>   -    /* Pin the rest chunk */
>> -    ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << 
>> PAGE_SHIFT,
>> -                 map_pfn << PAGE_SHIFT, msg->perm);
>> +    WARN_ON(nmap != npages);
>>   out:
>> -    if (ret) {
>> +    if (ret)
>>           vhost_vdpa_unmap(v, msg->iova, msg->size);
>> -        atomic64_sub(npages, &dev->mm->pinned_vm);
>> -    }
>> +unlock:
>>       mmap_read_unlock(dev->mm);
>> -    free_page((unsigned long)page_list);
>> +free:
>> +    kvfree(vmas);
>> +    kvfree(page_list);
>>       return ret;
>>   }
>

