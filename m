Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DAF196DC
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 04:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfEJC7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 22:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbfEJC7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 22:59:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A06920260;
        Fri, 10 May 2019 02:59:09 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2B524F89;
        Fri, 10 May 2019 02:59:00 +0000 (UTC)
Subject: Re: [RFC PATCH V2] vhost: don't use kmap() to log dirty pages
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
References: <1557406680-4087-1-git-send-email-jasowang@redhat.com>
 <20190509090433-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d6d69a36-9a3a-2a21-924e-97fdcc6e6733@redhat.com>
Date:   Fri, 10 May 2019 10:59:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509090433-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 10 May 2019 02:59:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/9 下午9:18, Michael S. Tsirkin wrote:
> On Thu, May 09, 2019 at 08:58:00AM -0400, Jason Wang wrote:
>> Vhost log dirty pages directly to a userspace bitmap through GUP and
>> kmap_atomic() since kernel doesn't have a set_bit_to_user()
>> helper. This will cause issues for the arch that has virtually tagged
>> caches. The way to fix is to keep using userspace virtual
>> address. Fortunately, futex has arch_futex_atomic_op_inuser() which
>> could be used for setting a bit to user.
>>
>> Note:
>> - There're archs (few non popular ones) that don't implement futex
>>    helper, we can't log dirty pages. We can fix them e.g for non
>>    virtually tagged archs implement a kmap fallback on top or simply
>>    disable LOG_ALL features of vhost.
>> - The helper also requires userspace pointer is located at 4-byte
>>    boundary, need to check during dirty log setting
> Why check? Round it down.


Will do this.


>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Darren Hart <dvhart@infradead.org>
>> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>> Changes from V1:
>> - switch to use arch_futex_atomic_op_inuser()
>> ---
>>   drivers/vhost/vhost.c | 35 +++++++++++++++++------------------
>>   1 file changed, 17 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 351af88..4e5a004 100644
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
>> @@ -1652,6 +1653,10 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
>>   			r = -EFAULT;
>>   			break;
>>   		}
>> +		if (p & 0x3) {
>> +			r = -EINVAL;
>> +			break;
>> +		}
>>   		for (i = 0; i < d->nvqs; ++i) {
>>   			struct vhost_virtqueue *vq;
>>   			void __user *base = (void __user *)(unsigned long)p;
> That's an ABI change and might break some userspace. I don't think
> it's necessary: you are changing individual bits anyway.


Right.


>
>> @@ -1692,31 +1697,27 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
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
>> +	u32 old;
>>   	int r;
>>   
>>   	r = get_user_pages_fast(log, 1, 1, &page);
> OK so the trick is that page is pinned so you don't expect
> arch_futex_atomic_op_inuser below to fail.  get_user_pages_fast
> guarantees page is not going away but does it guarantee PTE won't be
> invaidated or write protected?


Good point, then I think we probably need to do manual fixup through 
fixup_user_fault() if arch_futex_atomic_op_in_user() fail.


>
>>   	if (r < 0)
>>   		return r;
>>   	BUG_ON(r != 1);
>> -	base = kmap_atomic(page);
>> -	set_bit(bit, base);
>> -	kunmap_atomic(base);
>> +
>> +	r = arch_futex_atomic_op_inuser(FUTEX_OP_ADD, 1 << nr, &old, addr);
>> +	/* TODO: fallback to kmap() when -ENOSYS? */
>> +
> Add a comment why this won't fail? Maybe warn on EFAULT?
>
> Also down the road a variant that does not need tricks like this is
> still nice to have.


Ok. Let me post a V3.

Thanks


>
>
>>   	set_page_dirty_lock(page);
>>   	put_page(page);
>> -	return 0;
>> +	return r;
>>   }
>>   
>> -static int log_write(void __user *log_base,
>> +static int log_write(u32 __user *log_base,
>>   		     u64 write_address, u64 write_length)
>>   {
>>   	u64 write_page = write_address / VHOST_PAGE_SIZE;
>> @@ -1726,12 +1727,10 @@ static int log_write(void __user *log_base,
>>   		return 0;
>>   	write_length += write_address % VHOST_PAGE_SIZE;
>>   	for (;;) {
>> -		u64 base = (u64)(unsigned long)log_base;
>> -		u64 log = base + write_page / 8;
>> -		int bit = write_page % 8;
>> -		if ((u64)(unsigned long)log != log)
>> -			return -EFAULT;
>> -		r = set_bit_to_user(bit, (void __user *)(unsigned long)log);
>> +		u32 __user *log = log_base + write_page / 32;
>> +		int bit = write_page % 32;
>> +
>> +		r = set_bit_to_user(bit, log);
>>   		if (r < 0)
>>   			return r;
>>   		if (write_length <= VHOST_PAGE_SIZE)
>> -- 
>> 1.8.3.1
