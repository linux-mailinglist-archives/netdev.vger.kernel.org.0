Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1F028DA10
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 08:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgJNGwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 02:52:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbgJNGwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 02:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602658342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Umgsth+qAlJC/3C7CAcCT5UyrkL1Ulorv+l5T/RtKwQ=;
        b=J4VFr6uDKP6YeR7SZ4aHKfBouo7QquBgZkRB5dzvzoCKgpZHXxEqX2RoX97teGRZc3IwRR
        euP+t+s3f3BWZuz5GJHQo1LMQ9fTGU5fgEzq1Rx/02eZT+zyLWM39LDx1h/gKtkbPncirp
        nG4RxmdTj/rtzCAWKU0oEEuKnBokUe8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-K8graEyAMsufwxK_zILJ7g-1; Wed, 14 Oct 2020 02:52:18 -0400
X-MC-Unique: K8graEyAMsufwxK_zILJ7g-1
Received: by mail-wr1-f69.google.com with SMTP id v5so889842wrr.0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 23:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Umgsth+qAlJC/3C7CAcCT5UyrkL1Ulorv+l5T/RtKwQ=;
        b=TGhlpxxmy6o0t0E/CPehj96fNsLDnEdOxMGBFKoBd5JtkWKOJ8DAe5BH1r2JadGR6D
         ZNR2rIctzGOaxbaMfg1etB6VEmD3eR9gnkaVHesiXlOFgZ3uQNGyph+0L4PZ8HkQA7XM
         MPS97UZHFr4JDCJ8GzGC/Ep5v4L0ZFzgKZJvoOi0dHSelPfme5+qHYXOdXTd3yyiDIgm
         7Kn3hYaqrcteuxGBs4YFj/shPO+JZ0oBDy1z5LDmecEzPr0+aow4hpjDVK/rLhnyvVs6
         tV17raHus+6R5UOtY/8dxQiXd87C5Y2LyIDOhV+ZXXCDUQhuW5+eTbNz7WYacap7i3GR
         8xBg==
X-Gm-Message-State: AOAM532KQAd8HBijgZTw1PTM8+ILx4hVYWbiUGn8xdWiFTi2XizzWwoq
        wwa0Q/DessZEox3DTKOowXkomyI5UYFc8sYqPULoYtTXFdFMAWE8A7JVD+f9GKFSN4NYEkVYzUB
        wR4pJYiwShnx8Bylv
X-Received: by 2002:a5d:6642:: with SMTP id f2mr3797317wrw.374.1602658337680;
        Tue, 13 Oct 2020 23:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygjRUWH7k8NcK5WnN0N1PQoHHLLXDGOsXxyVZuN4eD8ensBeYjX+ISAk8XAMz9ma+J4s72ew==
X-Received: by 2002:a5d:6642:: with SMTP id f2mr3797288wrw.374.1602658337370;
        Tue, 13 Oct 2020 23:52:17 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id f63sm2237494wme.38.2020.10.13.23.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 23:52:16 -0700 (PDT)
Date:   Wed, 14 Oct 2020 02:52:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     si-wei liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, lingshan.zhu@intel.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error path
Message-ID: <20201014025025-mutt-send-email-mst@kernel.org>
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com>
 <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
 <5F863B83.6030204@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5F863B83.6030204@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 04:42:59PM -0700, si-wei liu wrote:
> 
> On 10/9/2020 7:27 PM, Jason Wang wrote:
> > 
> > On 2020/10/3 下午1:02, Si-Wei Liu wrote:
> > > Pinned pages are not properly accounted particularly when
> > > mapping error occurs on IOTLB update. Clean up dangling
> > > pinned pages for the error path. As the inflight pinned
> > > pages, specifically for memory region that strides across
> > > multiple chunks, would need more than one free page for
> > > book keeping and accounting. For simplicity, pin pages
> > > for all memory in the IOVA range in one go rather than
> > > have multiple pin_user_pages calls to make up the entire
> > > region. This way it's easier to track and account the
> > > pages already mapped, particularly for clean-up in the
> > > error path.
> > > 
> > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > ---
> > > Changes in v3:
> > > - Factor out vhost_vdpa_map() change to a separate patch
> > > 
> > > Changes in v2:
> > > - Fix incorrect target SHA1 referenced
> > > 
> > >   drivers/vhost/vdpa.c | 119
> > > ++++++++++++++++++++++++++++++---------------------
> > >   1 file changed, 71 insertions(+), 48 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index 0f27919..dad41dae 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -595,21 +595,19 @@ static int
> > > vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> > >       struct vhost_dev *dev = &v->vdev;
> > >       struct vhost_iotlb *iotlb = dev->iotlb;
> > >       struct page **page_list;
> > > -    unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
> > > +    struct vm_area_struct **vmas;
> > >       unsigned int gup_flags = FOLL_LONGTERM;
> > > -    unsigned long npages, cur_base, map_pfn, last_pfn = 0;
> > > -    unsigned long locked, lock_limit, pinned, i;
> > > +    unsigned long map_pfn, last_pfn = 0;
> > > +    unsigned long npages, lock_limit;
> > > +    unsigned long i, nmap = 0;
> > >       u64 iova = msg->iova;
> > > +    long pinned;
> > >       int ret = 0;
> > >         if (vhost_iotlb_itree_first(iotlb, msg->iova,
> > >                       msg->iova + msg->size - 1))
> > >           return -EEXIST;
> > >   -    page_list = (struct page **) __get_free_page(GFP_KERNEL);
> > > -    if (!page_list)
> > > -        return -ENOMEM;
> > > -
> > >       if (msg->perm & VHOST_ACCESS_WO)
> > >           gup_flags |= FOLL_WRITE;
> > >   @@ -617,61 +615,86 @@ static int
> > > vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> > >       if (!npages)
> > >           return -EINVAL;
> > >   +    page_list = kvmalloc_array(npages, sizeof(struct page *),
> > > GFP_KERNEL);
> > > +    vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
> > > +                  GFP_KERNEL);
> > 
> > 
> > This will result high order memory allocation which was what the code
> > tried to avoid originally.
> > 
> > Using an unlimited size will cause a lot of side effects consider VM or
> > userspace may try to pin several TB of memory.
> Hmmm, that's a good point. Indeed, if the guest memory demand is huge or the
> host system is running short of free pages, kvmalloc will be problematic and
> less efficient than the __get_free_page implementation.

OK so ... Jason, what's the plan?

How about you send a patchset with
1. revert this change
2. fix error handling leak


> > 
> > 
> > > +    if (!page_list || !vmas) {
> > > +        ret = -ENOMEM;
> > > +        goto free;
> > > +    }
> > 
> > 
> > Any reason that you want to use vmas?
> Without providing custom vmas, it's subject to high order allocation
> failure. While page_list and vmas can now fallback to virtual memory
> allocation if need be.
> 
> > 
> > 
> > > +
> > >       mmap_read_lock(dev->mm);
> > >   -    locked = atomic64_add_return(npages, &dev->mm->pinned_vm);
> > >       lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > > -
> > > -    if (locked > lock_limit) {
> > > +    if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
> > >           ret = -ENOMEM;
> > > -        goto out;
> > > +        goto unlock;
> > >       }
> > >   -    cur_base = msg->uaddr & PAGE_MASK;
> > > -    iova &= PAGE_MASK;
> > > +    pinned = pin_user_pages(msg->uaddr & PAGE_MASK, npages, gup_flags,
> > > +                page_list, vmas);
> > > +    if (npages != pinned) {
> > > +        if (pinned < 0) {
> > > +            ret = pinned;
> > > +        } else {
> > > +            unpin_user_pages(page_list, pinned);
> > > +            ret = -ENOMEM;
> > > +        }
> > > +        goto unlock;
> > > +    }
> > >   -    while (npages) {
> > > -        pinned = min_t(unsigned long, npages, list_size);
> > > -        ret = pin_user_pages(cur_base, pinned,
> > > -                     gup_flags, page_list, NULL);
> > > -        if (ret != pinned)
> > > -            goto out;
> > > -
> > > -        if (!last_pfn)
> > > -            map_pfn = page_to_pfn(page_list[0]);
> > > -
> > > -        for (i = 0; i < ret; i++) {
> > > -            unsigned long this_pfn = page_to_pfn(page_list[i]);
> > > -            u64 csize;
> > > -
> > > -            if (last_pfn && (this_pfn != last_pfn + 1)) {
> > > -                /* Pin a contiguous chunk of memory */
> > > -                csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
> > > -                if (vhost_vdpa_map(v, iova, csize,
> > > -                           map_pfn << PAGE_SHIFT,
> > > -                           msg->perm))
> > > -                    goto out;
> > > -                map_pfn = this_pfn;
> > > -                iova += csize;
> > > +    iova &= PAGE_MASK;
> > > +    map_pfn = page_to_pfn(page_list[0]);
> > > +
> > > +    /* One more iteration to avoid extra vdpa_map() call out of
> > > loop. */
> > > +    for (i = 0; i <= npages; i++) {
> > > +        unsigned long this_pfn;
> > > +        u64 csize;
> > > +
> > > +        /* The last chunk may have no valid PFN next to it */
> > > +        this_pfn = i < npages ? page_to_pfn(page_list[i]) : -1UL;
> > > +
> > > +        if (last_pfn && (this_pfn == -1UL ||
> > > +                 this_pfn != last_pfn + 1)) {
> > > +            /* Pin a contiguous chunk of memory */
> > > +            csize = last_pfn - map_pfn + 1;
> > > +            ret = vhost_vdpa_map(v, iova, csize << PAGE_SHIFT,
> > > +                         map_pfn << PAGE_SHIFT,
> > > +                         msg->perm);
> > > +            if (ret) {
> > > +                /*
> > > +                 * Unpin the rest chunks of memory on the
> > > +                 * flight with no corresponding vdpa_map()
> > > +                 * calls having been made yet. On the other
> > > +                 * hand, vdpa_unmap() in the failure path
> > > +                 * is in charge of accounting the number of
> > > +                 * pinned pages for its own.
> > > +                 * This asymmetrical pattern of accounting
> > > +                 * is for efficiency to pin all pages at
> > > +                 * once, while there is no other callsite
> > > +                 * of vdpa_map() than here above.
> > > +                 */
> > > +                unpin_user_pages(&page_list[nmap],
> > > +                         npages - nmap);
> > > +                goto out;
> > >               }
> > > -
> > > -            last_pfn = this_pfn;
> > > +            atomic64_add(csize, &dev->mm->pinned_vm);
> > > +            nmap += csize;
> > > +            iova += csize << PAGE_SHIFT;
> > > +            map_pfn = this_pfn;
> > >           }
> > > -
> > > -        cur_base += ret << PAGE_SHIFT;
> > > -        npages -= ret;
> > > +        last_pfn = this_pfn;
> > >       }
> > 
> > 
> > So what I suggest is to fix the pinning leakage first and do the
> > possible optimization on top (which is still questionable to me).
> OK. Unfortunately, this was picked and got merged in upstream. So I will
> post a follow up patch set to 1) revert the commit to the original
> __get_free_page() implementation, and 2) fix the accounting and leakage on
> top. Will it be fine?
> 
> 
> -Siwei
> > 
> > Thanks
> > 
> > 
> > >   -    /* Pin the rest chunk */
> > > -    ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) <<
> > > PAGE_SHIFT,
> > > -                 map_pfn << PAGE_SHIFT, msg->perm);
> > > +    WARN_ON(nmap != npages);
> > >   out:
> > > -    if (ret) {
> > > +    if (ret)
> > >           vhost_vdpa_unmap(v, msg->iova, msg->size);
> > > -        atomic64_sub(npages, &dev->mm->pinned_vm);
> > > -    }
> > > +unlock:
> > >       mmap_read_unlock(dev->mm);
> > > -    free_page((unsigned long)page_list);
> > > +free:
> > > +    kvfree(vmas);
> > > +    kvfree(page_list);
> > >       return ret;
> > >   }
> > 

