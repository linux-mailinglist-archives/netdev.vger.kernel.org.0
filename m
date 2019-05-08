Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CAD16F8D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 05:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfEHDn0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 May 2019 23:43:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfEHDnZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 23:43:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94D853087944;
        Wed,  8 May 2019 03:43:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82EFC60C4E;
        Wed,  8 May 2019 03:43:25 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 28F5E65D13;
        Wed,  8 May 2019 03:43:25 +0000 (UTC)
Date:   Tue, 7 May 2019 23:43:24 -0400 (EDT)
From:   Jason Wang <jasowang@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>
Message-ID: <1430527294.27174562.1557287004441.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190507154753.GA8809@infradead.org>
References: <20190507154753.GA8809@infradead.org>
Subject: Re: [PATCH RFC] vhost: don't use kmap() to log dirty pages
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.68.5.20, 10.4.195.23]
Thread-Topic: vhost: don't use kmap() to log dirty pages
Thread-Index: K7z0d3UL1bhTV/QW5Sb3gPqIWKhUvg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 08 May 2019 03:43:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/7 下午11:47, Christoph Hellwig wrote:
> On Mon, May 06, 2019 at 10:23:29PM -0400, Jason Wang wrote:
>> Note: there're archs (few non popular ones) that don't implement
>> futex helper, we can't log dirty pages. We can fix them on top or
>> simply disable LOG_ALL features of vhost.
>
> That means vhost now has to depend on HAVE_FUTEX_CMPXCHG to make
> sure we have a working implementation.

I found HAVE_FUTEX_CMPXCHG is not a must for arch that has the
implementation and futex does some kind of runtime detection like:

static void __init futex_detect_cmpxchg(void)
{
#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
	u32 curval;

	/*
	 * This will fail and we want it. Some arch implementations do
	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
	 * functionality. We want to know that before we call in any
	 * of the complex code paths. Also we want to prevent
	 * registration of robust lists in that case. NULL is
	 * guaranteed to fault and we get -EFAULT on functional
	 * implementation, the non-functional ones will return
	 * -ENOSYS.
	 */
	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
		futex_cmpxchg_enabled = 1;
#endif
}


>
>
>>  #include <linux/sched/signal.h>
>>  #include <linux/interval_tree_generic.h>
>>  #include <linux/nospec.h>
>> +#include <asm/futex.h>
>
> Also please include the futex maintainers to make sure they are fine
> with this first usage of <asm/futex.h> outside of kernel/futex.c.
>

Thanks for ccing them. Will do for next version.

If we decide to go this way, we probably need to move it to uaccess
for a more generic helper.

>
>> +static int set_bit_to_user(int nr, u32 __user *addr)
>>  {
>>  	unsigned long log = (unsigned long)addr;
>>  	struct page *page;
>> +	u32 old_log;
>>  	int r;
>>  
>>  	r = get_user_pages_fast(log, 1, 1, &page);
>>  	if (r < 0)
>>  		return r;
>>  	BUG_ON(r != 1);
>> +
>> +	r = futex_atomic_cmpxchg_inatomic(&old_log, addr, 0, 0);
>> +	if (r < 0)
>> +		return r;
>> +
>> +	old_log |= 1 << nr;
>> +	r = put_user(old_log, addr);
>> +	if (r < 0)
>> +		return r;
>
> And this just looks odd to me.  Why do we need the futex call to
> replace a 0 value with 0?  Why does it still duplicate the
> put_user?  This doesn't look like actually working code to me.

Yes, this is a bug. Should be something like:

static int set_bit_to_user(int nr, u32 __user *addr)
{
        unsigned long log = (unsigned long)addr;
        struct page *page;
        u32 old_log, new_log, l;
        int r;

        r = get_user_pages_fast(log, 1, 1, &page);
        if (r < 0)
                return r;
	BUG_ON(r != 1);

        do {
                r = get_user(old_log, addr);
                if (r < 0)
                        return r;
                new_log = old_log | (1 << nr);
		r = futex_atomic_cmpxchg_inatomic(&l, addr, old_log, new_log);
                if (r < 0)
                        return r;
        } while(l != new_log);

	set_page_dirty_lock(page);
        put_page(page);
        return 0;
}

>
> Also don't we need a pagefault_disable() around
> futex_atomic_cmpxchg_inatomic?

Since we don't want to deal with pagefault, so the page has been
pinned before futex_atomic_cmpxchg_inatomic().

Thanks
