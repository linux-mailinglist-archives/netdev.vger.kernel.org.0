Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE2289D1D
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgJJBfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728994AbgJJBak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:30:40 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E006206D9;
        Sat, 10 Oct 2020 01:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602293439;
        bh=sHFyDh52gnsvc+uI8yhUC5uDYbYkQCvra+rDiRMmAvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kwaFsg+FwkcbT1hA6vX2rbzC7SEHg0ckV7q6+TfKUuTYp7lijGzsxhx1D9MfT9qZg
         puzd9VwNUhNC7pSZTswv9TmxeVvsyOKe33XMZMPqVG5rfdvIuh+YhVfWI5Z4mrkh0S
         V8+sp7izCEY2Jms4cmTCzh86mPIYz7uaZ6k3dzLQ=
Date:   Fri, 9 Oct 2020 18:30:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     ira.weiny@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-aio@kvack.org,
        linux-efi@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org,
        ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com,
        devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org,
        x86@kernel.org, amd-gfx@lists.freedesktop.org,
        linux-afs@lists.infradead.org, cluster-devel@redhat.com,
        linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org,
        xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, ecryptfs@vger.kernel.org,
        linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org,
        linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        io-uring@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC PKS/PMEM 22/58] fs/f2fs: Utilize new kmap_thread()
Message-ID: <20201010013036.GD1122@sol.localdomain>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-23-ira.weiny@intel.com>
 <20201009213434.GA839@sol.localdomain>
 <20201010003954.GW20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010003954.GW20115@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 01:39:54AM +0100, Matthew Wilcox wrote:
> On Fri, Oct 09, 2020 at 02:34:34PM -0700, Eric Biggers wrote:
> > On Fri, Oct 09, 2020 at 12:49:57PM -0700, ira.weiny@intel.com wrote:
> > > The kmap() calls in this FS are localized to a single thread.  To avoid
> > > the over head of global PKRS updates use the new kmap_thread() call.
> > >
> > > @@ -2410,12 +2410,12 @@ static inline struct page *f2fs_pagecache_get_page(
> > >  
> > >  static inline void f2fs_copy_page(struct page *src, struct page *dst)
> > >  {
> > > -	char *src_kaddr = kmap(src);
> > > -	char *dst_kaddr = kmap(dst);
> > > +	char *src_kaddr = kmap_thread(src);
> > > +	char *dst_kaddr = kmap_thread(dst);
> > >  
> > >  	memcpy(dst_kaddr, src_kaddr, PAGE_SIZE);
> > > -	kunmap(dst);
> > > -	kunmap(src);
> > > +	kunmap_thread(dst);
> > > +	kunmap_thread(src);
> > >  }
> > 
> > Wouldn't it make more sense to switch cases like this to kmap_atomic()?
> > The pages are only mapped to do a memcpy(), then they're immediately unmapped.
> 
> Maybe you missed the earlier thread from Thomas trying to do something
> similar for rather different reasons ...
> 
> https://lore.kernel.org/lkml/20200919091751.011116649@linutronix.de/

I did miss it.  I'm not subscribed to any of the mailing lists it was sent to.

Anyway, it shouldn't matter.  Patchsets should be standalone, and not require
reading random prior threads on linux-kernel to understand.

And I still don't really understand.  After this patchset, there is still code
nearly identical to the above (doing a temporary mapping just for a memcpy) that
would still be using kmap_atomic().  Is the idea that later, such code will be
converted to use kmap_thread() instead?  If not, why use one over the other?

- Eric
