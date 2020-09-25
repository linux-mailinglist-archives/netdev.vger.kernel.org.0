Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2040F2781F5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgIYHti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIYHti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 03:49:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09315C0613CE;
        Fri, 25 Sep 2020 00:49:38 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so2493515wrt.3;
        Fri, 25 Sep 2020 00:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qcup0n0Kbbar3GfFMOaxKCrWneqO730ge7ejBLQFsSw=;
        b=JynSupAsPIxyM0tHSq+I6BS9ERtnR1QGjR+6bKFi+uZNkl80guzf8BhYZMLEfqo/tE
         NzU3ngLifZ0aj7Y6je/bqPJWN0vvB/C7MNioXEONFGgpSUCEkZ9iej7QMQwjmTyaJA3H
         /7FhMcSOPhwbQBvr12PEGjkDLl6wv8K/O0oGKQEIX1GvqZtTd2ETXfQgCssS2RyzyAnM
         wPWCveLU+0pAp+y5jHCsS4pxH5kgXjse4jkEYHzBfIvFPxB4byE2uGG+iEo8Ytv13MsF
         JbMqqh26OslGAW1u0YnETFAPCMUQdGcHnJv+xeer/W4jJ+77HQO3Vel38+soXX1hiSAg
         X3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qcup0n0Kbbar3GfFMOaxKCrWneqO730ge7ejBLQFsSw=;
        b=NmKlTryWotGEvc0hhq/Q//EB2+TbOAGqBaqskE+dyRXzYQO9k8wIduuqKJrTqhj8ZS
         xWQGK+TslO0Las7VPvgldRXVBnnKPI27x2cf6CoeQvFhFN82yJK7KEPh0l5s9xVSgEiQ
         MOibznS0r7CD6rvVoAyFOXX/hWhW9tA8lQk6Md7pPLCg4AkkfP8n1LI0+JMmMAqlaI7X
         HveTa2XHubqya9h5KwzmC3scyF0EoQNTY45a/4BG2CPL9gj3JO/Tb1x5m9G4zefudnuc
         cd1j1Xj1T5fZ8Xkk+00v8qO24jBGSc+sM/L+cJ7Ky7Nw1fpVTRq3yMeswpsxoqHvx6YJ
         2XKw==
X-Gm-Message-State: AOAM5308dBdgGWMQbuAs+SRCtN+zm79ae3iZy86Zu1cvcwEKgN95NIfz
        JnrK5LSb9zVz0Gi+HrJUO7vdkA3ej9A=
X-Google-Smtp-Source: ABdhPJxwFm66hjCZtWCDMIe431jHpYL45Ee/LOTh9Y1AeX1i7uxIiN3Cedz65FyKh11i0dAGLOyDgw==
X-Received: by 2002:adf:a418:: with SMTP id d24mr3062067wra.80.1601020176552;
        Fri, 25 Sep 2020 00:49:36 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.202.225])
        by smtp.gmail.com with ESMTPSA id c14sm1858788wrm.64.2020.09.25.00.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 00:49:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next 2/6] bpf, net: rework cookie generator as per-cpu
 one
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
 <e854149f-f3a6-a736-9d33-08b2f60eb3a2@gmail.com>
 <dc5dd027-256d-598a-2f89-a45bb30208f8@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b1d5d93a-3846-ae35-7ea6-4bc31e98ef30@gmail.com>
Date:   Fri, 25 Sep 2020 09:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <dc5dd027-256d-598a-2f89-a45bb30208f8@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/20 12:03 AM, Daniel Borkmann wrote:
> On 9/24/20 8:58 PM, Eric Dumazet wrote:
>> On 9/24/20 8:21 PM, Daniel Borkmann wrote:
> [...]
>>> diff --git a/include/linux/cookie.h b/include/linux/cookie.h
>>> new file mode 100644
>>> index 000000000000..2488203dc004
>>> --- /dev/null
>>> +++ b/include/linux/cookie.h
>>> @@ -0,0 +1,41 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +#ifndef __LINUX_COOKIE_H
>>> +#define __LINUX_COOKIE_H
>>> +
>>> +#include <linux/atomic.h>
>>> +#include <linux/percpu.h>
>>> +
>>> +struct gen_cookie {
>>> +    u64 __percpu    *local_last;
>>> +    atomic64_t     shared_last ____cacheline_aligned_in_smp;
>>> +};
>>> +
>>> +#define COOKIE_LOCAL_BATCH    4096
>>> +
>>> +#define DEFINE_COOKIE(name)                    \
>>> +    static DEFINE_PER_CPU(u64, __##name);            \
>>> +    static struct gen_cookie name = {            \
>>> +        .local_last    = &__##name,            \
>>> +        .shared_last    = ATOMIC64_INIT(0),        \
>>> +    }
>>> +
>>> +static inline u64 gen_cookie_next(struct gen_cookie *gc)
>>> +{
>>> +    u64 *local_last = &get_cpu_var(*gc->local_last);
>>> +    u64 val = *local_last;
>>> +
>>> +    if (__is_defined(CONFIG_SMP) &&
>>> +        unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
>>> +        s64 next = atomic64_add_return(COOKIE_LOCAL_BATCH,
>>> +                           &gc->shared_last);
>>> +        val = next - COOKIE_LOCAL_BATCH;
>>> +    }
>>> +    val++;
>>> +    if (unlikely(!val))
>>> +        val++;
>>> +    *local_last = val;
>>> +    put_cpu_var(local_last);
>>> +    return val;
>>
>> This is not interrupt safe.
>>
>> I think sock_gen_cookie() can be called from interrupt context.
>>
>> get_next_ino() is only called from process context, that is what I used get_cpu_var()
>> and put_cpu_var()
> 
> Hmm, agree, good point. Need to experiment a bit more .. initial thinking
> potentially something like the below could do where we fall back to atomic
> counter iff we encounter nesting (which should be an extremely rare case
> normally).
> 
> BPF progs where this can be called from are non-preemptible, so we could
> actually move the temp preempt_disable/enable() from get/put_cpu_var() into
> a wrapper func for slow path non-BPF users as well.
> 
> static inline u64 gen_cookie_next(struct gen_cookie *gc)
> {
>         u64 val;
> 

I presume you would use a single structure to hold level_nesting and local_last
in the same cache line.

struct pcpu_gen_cookie {
    int level_nesting;
    u64 local_last;
} __aligned(16);

    

>         if (likely(this_cpu_inc_return(*gc->level_nesting) == 1)) {
>                 u64 *local_last = this_cpu_ptr(gc->local_last);
> 
>                 val = *local_last;
>                 if (__is_defined(CONFIG_SMP) &&
>                     unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
>                         s64 next = atomic64_add_return(COOKIE_LOCAL_BATCH,
>                                                        &gc->shared_last);
>                         val = next - COOKIE_LOCAL_BATCH;
>                 }
>                 val++;



>                 if (unlikely(!val))
>                         val++;

Note that we really expect this wrapping will never happen, with 64bit value.
(We had to take care of the wrapping in get_next_ino() as it was dealing with 32bit values)

>                 *local_last = val;
>         } else {
>                 val = atomic64_add_return(COOKIE_LOCAL_BATCH,
>                                           &gc->shared_last);

Or val = atomic64_dec_return(&reverse_counter)

With reverse_counter initial value set to ATOMIC64_INIT(0) ? 

This will start sending 'big cookies like 0xFFFFFFFFxxxxxxxx' to make sure applications
are not breaking with them, after few months of uptime.

This would also not consume COOKIE_LOCAL_BATCH units per value,
but this seems minor based on the available space.


>         }
>         this_cpu_dec(*gc->level_nesting);
>         return val;
> }
> 
> Thanks,
> Daniel
