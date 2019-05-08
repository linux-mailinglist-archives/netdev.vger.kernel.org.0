Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD65517016
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 06:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfEHE2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 00:28:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbfEHE2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 00:28:51 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 33DDB307D987;
        Wed,  8 May 2019 04:28:51 +0000 (UTC)
Received: from [10.72.12.176] (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 650282E041;
        Wed,  8 May 2019 04:28:44 +0000 (UTC)
Subject: Re: [PATCH RFC] vhost: don't use kmap() to log dirty pages
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>
References: <1557195809-12373-1-git-send-email-jasowang@redhat.com>
 <20190507220526-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <84a2237e-d8cf-922c-0d0b-90009e99e8ee@redhat.com>
Date:   Wed, 8 May 2019 12:28:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507220526-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 08 May 2019 04:28:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/8 下午12:12, Michael S. Tsirkin wrote:
> On Mon, May 06, 2019 at 10:23:29PM -0400, Jason Wang wrote:
>> Vhost log dirty pages directly to a userspace bitmap through GUP and
>> kmap_atomic() since kernel doesn't have a set_bit_to_user()
>> helper. This will cause issues for the arch that has virtually tagged
>> caches. The way to fix is to keep using userspace virtual address.
>>
>> Fortunately, futex has a cmpxchg to userspace memory helper
>> futex_atomic_cmpxchg_inatomic(). So switch to use it to exchange the
>> userspace bitmap with zero, set the bit and then write it back through
>> put_user().
>>
>> Note: there're archs (few non popular ones) that don't implement
>> futex helper, we can't log dirty pages. We can fix them on top or
>> simply disable LOG_ALL features of vhost.
> Or implement futex_atomic_cmpxchg using kmap if they don't have
> virtually tagged caches.


Yes, this might work.


>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/vhost.c | 27 +++++++++++++++------------
>>   1 file changed, 15 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 351af88..9c94c41 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -31,6 +31,7 @@
>>   #include <linux/sched/signal.h>
>>   #include <linux/interval_tree_generic.h>
>>   #include <linux/nospec.h>
>> +#include <asm/futex.h>
>>   
>>   #include "vhost.h"
>>   
>> @@ -1692,25 +1693,27 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
>>   }
>>   EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
>>   
>> -/* TODO: This is really inefficient.  We need something like get_user()
>> - * (instruction directly accesses the data, with an exception table entry
>> - * returning -EFAULT). See Documentation/x86/exception-tables.txt.
>> - */
>> -static int set_bit_to_user(int nr, void __user *addr)
>> +static int set_bit_to_user(int nr, u32 __user *addr)
>>   {
>>   	unsigned long log = (unsigned long)addr;
>>   	struct page *page;
>> -	void *base;
>> -	int bit = nr + (log % PAGE_SIZE) * 8;
>> +	u32 old_log;
>>   	int r;
>>   
>>   	r = get_user_pages_fast(log, 1, 1, &page);
>>   	if (r < 0)
>>   		return r;
>>   	BUG_ON(r != 1);
>> -	base = kmap_atomic(page);
>> -	set_bit(bit, base);
>> -	kunmap_atomic(base);
>> +
>> +	r = futex_atomic_cmpxchg_inatomic(&old_log, addr, 0, 0);
>> +	if (r < 0)
>> +		return r;
> So I think this is a great idea!
>
> However one issue here is that futex_atomic_cmpxchg_inatomic will fail if the
> page is swapped out. I suspect we need a variant that blocks the thread
> instead.


I guess not since the patch still try to pin the page before.

Thanks


>
>> +
>> +	old_log |= 1 << nr;
>> +	r = put_user(old_log, addr);
>> +	if (r < 0)
>> +		return r;
>> +
>>   	set_page_dirty_lock(page);
>>   	put_page(page);
>>   	return 0;
>> @@ -1727,8 +1730,8 @@ static int log_write(void __user *log_base,
>>   	write_length += write_address % VHOST_PAGE_SIZE;
>>   	for (;;) {
>>   		u64 base = (u64)(unsigned long)log_base;
>> -		u64 log = base + write_page / 8;
>> -		int bit = write_page % 8;
>> +		u64 log = base + write_page / 32;
>> +		int bit = write_page % 32;
>>   		if ((u64)(unsigned long)log != log)
>>   			return -EFAULT;
>>   		r = set_bit_to_user(bit, (void __user *)(unsigned long)log);
>> -- 
>> 1.8.3.1
