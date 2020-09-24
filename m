Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75DD277B6D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIXWDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:03:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:48674 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:03:18 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZKd-0003xI-Ij; Fri, 25 Sep 2020 00:03:15 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZKd-000MM3-CP; Fri, 25 Sep 2020 00:03:15 +0200
Subject: Re: [PATCH bpf-next 2/6] bpf, net: rework cookie generator as per-cpu
 one
To:     Eric Dumazet <eric.dumazet@gmail.com>, ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
 <e854149f-f3a6-a736-9d33-08b2f60eb3a2@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dc5dd027-256d-598a-2f89-a45bb30208f8@iogearbox.net>
Date:   Fri, 25 Sep 2020 00:03:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e854149f-f3a6-a736-9d33-08b2f60eb3a2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 8:58 PM, Eric Dumazet wrote:
> On 9/24/20 8:21 PM, Daniel Borkmann wrote:
[...]
>> diff --git a/include/linux/cookie.h b/include/linux/cookie.h
>> new file mode 100644
>> index 000000000000..2488203dc004
>> --- /dev/null
>> +++ b/include/linux/cookie.h
>> @@ -0,0 +1,41 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __LINUX_COOKIE_H
>> +#define __LINUX_COOKIE_H
>> +
>> +#include <linux/atomic.h>
>> +#include <linux/percpu.h>
>> +
>> +struct gen_cookie {
>> +	u64 __percpu	*local_last;
>> +	atomic64_t	 shared_last ____cacheline_aligned_in_smp;
>> +};
>> +
>> +#define COOKIE_LOCAL_BATCH	4096
>> +
>> +#define DEFINE_COOKIE(name)					\
>> +	static DEFINE_PER_CPU(u64, __##name);			\
>> +	static struct gen_cookie name = {			\
>> +		.local_last	= &__##name,			\
>> +		.shared_last	= ATOMIC64_INIT(0),		\
>> +	}
>> +
>> +static inline u64 gen_cookie_next(struct gen_cookie *gc)
>> +{
>> +	u64 *local_last = &get_cpu_var(*gc->local_last);
>> +	u64 val = *local_last;
>> +
>> +	if (__is_defined(CONFIG_SMP) &&
>> +	    unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
>> +		s64 next = atomic64_add_return(COOKIE_LOCAL_BATCH,
>> +					       &gc->shared_last);
>> +		val = next - COOKIE_LOCAL_BATCH;
>> +	}
>> +	val++;
>> +	if (unlikely(!val))
>> +		val++;
>> +	*local_last = val;
>> +	put_cpu_var(local_last);
>> +	return val;
> 
> This is not interrupt safe.
> 
> I think sock_gen_cookie() can be called from interrupt context.
> 
> get_next_ino() is only called from process context, that is what I used get_cpu_var()
> and put_cpu_var()

Hmm, agree, good point. Need to experiment a bit more .. initial thinking
potentially something like the below could do where we fall back to atomic
counter iff we encounter nesting (which should be an extremely rare case
normally).

BPF progs where this can be called from are non-preemptible, so we could
actually move the temp preempt_disable/enable() from get/put_cpu_var() into
a wrapper func for slow path non-BPF users as well.

static inline u64 gen_cookie_next(struct gen_cookie *gc)
{
         u64 val;

         if (likely(this_cpu_inc_return(*gc->level_nesting) == 1)) {
                 u64 *local_last = this_cpu_ptr(gc->local_last);

                 val = *local_last;
                 if (__is_defined(CONFIG_SMP) &&
                     unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
                         s64 next = atomic64_add_return(COOKIE_LOCAL_BATCH,
                                                        &gc->shared_last);
                         val = next - COOKIE_LOCAL_BATCH;
                 }
                 val++;
                 if (unlikely(!val))
                         val++;
                 *local_last = val;
         } else {
                 val = atomic64_add_return(COOKIE_LOCAL_BATCH,
                                           &gc->shared_last);
         }
         this_cpu_dec(*gc->level_nesting);
         return val;
}

Thanks,
Daniel
