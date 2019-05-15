Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DC21E6F7
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 04:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfEOCzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 22:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfEOCzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 22:55:44 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 97B25308123F;
        Wed, 15 May 2019 02:55:43 +0000 (UTC)
Received: from [10.72.12.103] (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C576608A6;
        Wed, 15 May 2019 02:55:36 +0000 (UTC)
Subject: Re: [PATCH net] vhost: don't use kmap() to log dirty pages
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
References: <1557725265-63525-1-git-send-email-jasowang@redhat.com>
 <20190514181150-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d4b64662-42b3-3ac3-0019-92935acb6bc7@redhat.com>
Date:   Wed, 15 May 2019 10:55:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514181150-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 15 May 2019 02:55:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/15 上午6:16, Michael S. Tsirkin wrote:
> On Mon, May 13, 2019 at 01:27:45AM -0400, Jason Wang wrote:
>> Vhost log dirty pages directly to a userspace bitmap through GUP and
>> kmap_atomic() since kernel doesn't have a set_bit_to_user()
>> helper. This will cause issues for the arch that has virtually tagged
>> caches. The way to fix is to keep using userspace virtual
>> address. Fortunately, futex has arch_futex_atomic_op_inuser() which
>> could be used for setting a bit to user.
>>
>> Note there're several cases that futex helper can fail e.g a page
>> fault or the arch that doesn't have the support. For those cases, a
>> simplified get_user()/put_user() pair protected by a global mutex is
>> provided as a fallback. The fallback may lead false positive that
>> userspace may see more dirty pages.
>>
>> Cc: Christoph Hellwig<hch@infradead.org>
>> Cc: James Bottomley<James.Bottomley@HansenPartnership.com>
>> Cc: Andrea Arcangeli<aarcange@redhat.com>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Ingo Molnar<mingo@redhat.com>
>> Cc: Peter Zijlstra<peterz@infradead.org>
>> Cc: Darren Hart<dvhart@infradead.org>
>> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
>> Changes from RFC V2:
>> - drop GUP and provide get_user()/put_user() fallbacks
>> - round down log_base
>> Changes from RFC V1:
>> - switch to use arch_futex_atomic_op_inuser()
>> ---
>>   drivers/vhost/vhost.c | 54 ++++++++++++++++++++++++++++-----------------------
>>   1 file changed, 30 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 351af88..7fa05ba 100644
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
>> @@ -43,6 +44,8 @@
>>   MODULE_PARM_DESC(max_iotlb_entries,
>>   	"Maximum number of iotlb entries. (default: 2048)");
>>   
>> +static DEFINE_MUTEX(vhost_log_lock);
>> +
>>   enum {
>>   	VHOST_MEMORY_F_LOG = 0x1,
>>   };
>> @@ -1692,28 +1695,31 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
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
>> -	unsigned long log = (unsigned long)addr;
>> -	struct page *page;
>> -	void *base;
>> -	int bit = nr + (log % PAGE_SIZE) * 8;
>> +	u32 old;
>>   	int r;
>>   
>> -	r = get_user_pages_fast(log, 1, 1, &page);
>> -	if (r < 0)
>> -		return r;
>> -	BUG_ON(r != 1);
>> -	base = kmap_atomic(page);
>> -	set_bit(bit, base);
>> -	kunmap_atomic(base);
>> -	set_page_dirty_lock(page);
>> -	put_page(page);
>> +	r = arch_futex_atomic_op_inuser(FUTEX_OP_OR, 1 << nr, &old, addr);
>> +	if (r) {
>> +		/* Fallback through get_user()/put_user(), this may
>> +		 * lead false positive that userspace may see more
>> +		 * dirty pages. A mutex is used to synchronize log
>> +		 * access between vhost threads.
>> +		 */
>> +		mutex_lock(&vhost_log_lock);
>> +		r = get_user(old, addr);
>> +		if (r)
>> +			goto err;
>> +		r = put_user(old | 1 << nr, addr);
>> +		if (r)
>> +			goto err;
>> +		mutex_unlock(&vhost_log_lock);
>> +	}
> Problem is, we always said it's atomic.
>
> This trick will work if userspace only clears bits
> in the log, but won't if it sets bits in the log.
> E.g. reusing the log structure for vhost-user
> will have exactly this effect.
>

Ok, I admit this is an issue.

Then I think maybe we can simply fallback to a u8 put_user() which is 
guaranteed to be atomic like:

put_user(0xF, addr);

Then we may at most have 7 more dirty pages to be seen by guest. 
Consider futex helper is implemented is most architectures and it's 
likely to succeed. It should be acceptable.

Does this make sense?

Thanks

