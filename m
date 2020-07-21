Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A214B2288EA
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgGUTKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgGUTKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:10:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD62C061794;
        Tue, 21 Jul 2020 12:10:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id 72so10669847ple.0;
        Tue, 21 Jul 2020 12:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4VasfkiSgNbg3DexTWANpLNDcXThnixKgOSNULSjEfA=;
        b=L9R5y5TOMDt5OSaIal5MpxYPE3IRn8eYeUblKvHeUBPtWb6EUIWGKE2VT+eAMkxjGc
         ynef9fttbPpB+yehrjn+pvfUNSJhbYhuV/bhM0ZQ8KWiCrBUg1Zw9Pwy/3aioG4+tld2
         oVcw3VtTD8UkhQ46qzxSQ5zYhnQ0PVgUqNOJRjU3yjaf9abOdqvi9FS1bee3nfc4dFxO
         iclQYqam/wcL4ZGgaIIUZ9T6c4AdhBd2gRTtztcgtbXrrQJ6+LE/ym3vAF/NagaeEy/T
         6qP/CAO3l5JqEBln2UMnk7SfUuPmBa5pHxVZfQLKm7nhMzePuUoM/aNf6RNcNwzWs6Xl
         opGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4VasfkiSgNbg3DexTWANpLNDcXThnixKgOSNULSjEfA=;
        b=a2xbtQiWMxdUKu/OZpB3DSl+B4KceSJ+s5gbu9VuDqtEHa5xyN48Uft+p39m5g5fw7
         cHtsIeIrU/hLaUzvdzU2zp7idBYuo7+0sEUIWofuNCd215EChtPUx4pb0CxWZciPaMi1
         SBxvFnXJe9wx0LL44CeEntSqzlH+vfSca8rRlaCcbn0/2YyzLIHlOW2I2c0cRDFnz4Nm
         Z4+kIERQfBsFSVxRGcSNZgV2cTKgEgfLb3JHx+bqf/UsSZzPhTjCpty1ztNUsAu2ABgQ
         fhn4JZ4W2Qg/xvuVJmKfjPLSqmasxS/pOg/IsPton0Cf80Kav3pVTzCdnnpHGHCPbJJQ
         joUQ==
X-Gm-Message-State: AOAM533i0O+i8mfLTSds4KbpAW/8SHzGQBYxL+ToQGYR/PY06Saqfd8k
        Osz5b0xWDtY3xWw0iJZDpNY=
X-Google-Smtp-Source: ABdhPJwsmp2qZSeuy2yPW5EEVFEiG516nTfieiUGxmaw74pJ1ZL26UW/kpW5rXGE7uJCS9W48CMFcw==
X-Received: by 2002:a17:90a:ec0a:: with SMTP id l10mr5615119pjy.152.1595358612670;
        Tue, 21 Jul 2020 12:10:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id k189sm21202915pfd.175.2020.07.21.12.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 12:10:11 -0700 (PDT)
Date:   Tue, 21 Jul 2020 12:10:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        brouer@redhat.com, peterz@infradead.org
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid]
 for perf events BPF
Message-ID: <20200721191009.5khr7blivtuv3qfj@ast-mbp.dhcp.thefacebook.com>
References: <20200716225933.196342-1-songliubraving@fb.com>
 <20200716225933.196342-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716225933.196342-2-songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 03:59:32PM -0700, Song Liu wrote:
> +
> +BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
> +	   struct bpf_map *, map, u64, flags)
> +{
> +	struct perf_event *event = ctx->event;
> +	struct perf_callchain_entry *trace;
> +	bool has_kernel, has_user;
> +	bool kernel, user;
> +
> +	/* perf_sample_data doesn't have callchain, use bpf_get_stackid */
> +	if (!(event->attr.sample_type & __PERF_SAMPLE_CALLCHAIN_EARLY))

what if event was not created with PERF_SAMPLE_CALLCHAIN ?
Calling the helper will still cause crashes, no?

> +		return bpf_get_stackid((unsigned long)(ctx->regs),
> +				       (unsigned long) map, flags, 0, 0);
> +
> +	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
> +			       BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
> +		return -EINVAL;
> +
> +	user = flags & BPF_F_USER_STACK;
> +	kernel = !user;
> +
> +	has_kernel = !event->attr.exclude_callchain_kernel;
> +	has_user = !event->attr.exclude_callchain_user;
> +
> +	if ((kernel && !has_kernel) || (user && !has_user))
> +		return -EINVAL;

this will break existing users in a way that will be very hard for them to debug.
If they happen to set exclude_callchain_* flags during perf_event_open
the helpers will be failing at run-time.
One can argue that when precise_ip=1 the bpf_get_stack is broken, but
this is a change in behavior.
It also seems to be broken when PERF_SAMPLE_CALLCHAIN was not set at event
creation time, but precise_ip=1 was.

> +
> +	trace = ctx->data->callchain;
> +	if (unlikely(!trace))
> +		return -EFAULT;
> +
> +	if (has_kernel && has_user) {

shouldn't it be || ?

> +		__u64 nr_kernel = count_kernel_ip(trace);
> +		int ret;
> +
> +		if (kernel) {
> +			__u64 nr = trace->nr;
> +
> +			trace->nr = nr_kernel;
> +			ret = __bpf_get_stackid(map, trace, flags);
> +
> +			/* restore nr */
> +			trace->nr = nr;
> +		} else { /* user */
> +			u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
> +
> +			skip += nr_kernel;
> +			if (skip > BPF_F_SKIP_FIELD_MASK)
> +				return -EFAULT;
> +
> +			flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
> +			ret = __bpf_get_stackid(map, trace, flags);
> +		}
> +		return ret;
> +	}
> +	return __bpf_get_stackid(map, trace, flags);
...
> +	if (has_kernel && has_user) {
> +		__u64 nr_kernel = count_kernel_ip(trace);
> +		int ret;
> +
> +		if (kernel) {
> +			__u64 nr = trace->nr;
> +
> +			trace->nr = nr_kernel;
> +			ret = __bpf_get_stack(ctx->regs, NULL, trace, buf,
> +					      size, flags);
> +
> +			/* restore nr */
> +			trace->nr = nr;
> +		} else { /* user */
> +			u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
> +
> +			skip += nr_kernel;
> +			if (skip > BPF_F_SKIP_FIELD_MASK)
> +				goto clear;
> +
> +			flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
> +			ret = __bpf_get_stack(ctx->regs, NULL, trace, buf,
> +					      size, flags);
> +		}

Looks like copy-paste. I think there should be a way to make it
into common helper.

I think the main isssue is wrong interaction with event attr flags.
I think the verifier should detect that bpf_get_stack/bpf_get_stackid
were used and prevent attaching to perf_event with attr.precise_ip=1
and PERF_SAMPLE_CALLCHAIN is not specified.
I was thinking whether attaching bpf to event can force setting of
PERF_SAMPLE_CALLCHAIN, but that would be a surprising behavior,
so not a good idea.
So the only thing left is to reject attach when bpf_get_stack is used
in two cases:
if attr.precise_ip=1 and PERF_SAMPLE_CALLCHAIN is not set.
  (since it will lead to crashes)
if attr.precise_ip=1 and PERF_SAMPLE_CALLCHAIN is set,
but exclude_callchain_[user|kernel]=1 is set too.
  (since it will lead to surprising behavior of bpf_get_stack)

Other ideas?
