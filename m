Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE7C2B53DD
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgKPVeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:34:44 -0500
Received: from mail.efficios.com ([167.114.26.124]:60978 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgKPVen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 16:34:43 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 276C22D1426;
        Mon, 16 Nov 2020 16:34:42 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id f-Ce_6a2g1Tu; Mon, 16 Nov 2020 16:34:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AA8BB2D105C;
        Mon, 16 Nov 2020 16:34:41 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AA8BB2D105C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605562481;
        bh=EMWqZDrzoqtCJkVXP8nY7dQB0JH0OvHZOGk4DxHpjVM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=hSxrcYILoORHcHBaFoqN2cdA8LD7oKbqIuXhoatCyzyUzgdV69Xm1l3oU/ajsCS7w
         gTC88Teotu//DfDBOh5Q/2rG+ZMJ5+McWGT0AZWysjQqYhLfzhENYHxMLpGHnMT9Yz
         M8jPGagXnGIqFiTDMlBihZmgS4bzVlV6tXztuQuUPIjoYu4LXyhJnRqw5YncBY+kyz
         +HVNeVVtkNnXyb21sTD0mPTh6z5mNZdE2x1WH4uevhsk2AkT6MKSNBLmYXaDFZIyAv
         OWP/slVcdpBNbK0ZTZz4EIfe/EnYTijLnpKk+CFl/EvrdQiZVTlaBNNV4Cbo0umYWw
         S+b5kEmZXzSlA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bZ-GxLbRQbYG; Mon, 16 Nov 2020 16:34:41 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 90DFF2D105B;
        Mon, 16 Nov 2020 16:34:41 -0500 (EST)
Date:   Mon, 16 Nov 2020 16:34:41 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     paulmck <paulmck@kernel.org>, Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <1368007646.46749.1605562481450.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201116160218.3b705345@gandalf.local.home>
References: <00000000000004500b05b31e68ce@google.com> <20201115055256.65625-1-mmullins@mmlx.us> <20201116121929.1a7aeb16@gandalf.local.home> <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com> <20201116154437.254a8b97@gandalf.local.home> <20201116160218.3b705345@gandalf.local.home>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: don't fail kmalloc while releasing raw_tp
Thread-Index: rv+RzkkQl7L/OC9Xs4agP4GYhHq4hQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 16, 2020, at 4:02 PM, rostedt rostedt@goodmis.org wrote:

> On Mon, 16 Nov 2020 15:44:37 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> If you use a stub function, it shouldn't affect anything. And the worse
>> that would happen is that you have a slight overhead of calling the stub
>> until you can properly remove the callback.
> 
> Something like this:
> 
> (haven't compiled it yet, I'm about to though).
> 
> -- Steve
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 3f659f855074..8eab40f9d388 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -53,10 +53,16 @@ struct tp_probes {
> 	struct tracepoint_func probes[];
> };
> 
> -static inline void *allocate_probes(int count)
> +/* Called in removal of a func but failed to allocate a new tp_funcs */
> +static void tp_stub_func(void)

I'm still not sure whether it's OK to call a (void) function with arguments.

> +{
> +	return;
> +}
> +
> +static inline void *allocate_probes(int count, gfp_t extra_flags)
> {
> 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
> -				       GFP_KERNEL);
> +				       GFP_KERNEL | extra_flags);
> 	return p == NULL ? NULL : p->probes;
> }
> 
> @@ -150,7 +156,7 @@ func_add(struct tracepoint_func **funcs, struct
> tracepoint_func *tp_func,
> 		}
> 	}
> 	/* + 2 : one for new probe, one for NULL func */
> -	new = allocate_probes(nr_probes + 2);
> +	new = allocate_probes(nr_probes + 2, 0);
> 	if (new == NULL)
> 		return ERR_PTR(-ENOMEM);
> 	if (old) {
> @@ -188,8 +194,9 @@ static void *func_remove(struct tracepoint_func **funcs,
> 	/* (N -> M), (N > 1, M >= 0) probes */
> 	if (tp_func->func) {
> 		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> -			if (old[nr_probes].func == tp_func->func &&
> -			     old[nr_probes].data == tp_func->data)
> +			if ((old[nr_probes].func == tp_func->func &&
> +			     old[nr_probes].data == tp_func->data) ||
> +			    old[nr_probes].func == tp_stub_func)
> 				nr_del++;
> 		}
> 	}
> @@ -207,15 +214,20 @@ static void *func_remove(struct tracepoint_func **funcs,
> 		int j = 0;
> 		/* N -> M, (N > 1, M > 0) */
> 		/* + 1 for NULL */
> -		new = allocate_probes(nr_probes - nr_del + 1);
> -		if (new == NULL)
> -			return ERR_PTR(-ENOMEM);
> -		for (i = 0; old[i].func; i++)
> -			if (old[i].func != tp_func->func
> -					|| old[i].data != tp_func->data)
> -				new[j++] = old[i];
> -		new[nr_probes - nr_del].func = NULL;
> -		*funcs = new;
> +		new = allocate_probes(nr_probes - nr_del + 1, __GFP_NOFAIL);
> +		if (new) {
> +			for (i = 0; old[i].func; i++)
> +				if (old[i].func != tp_func->func
> +				    || old[i].data != tp_func->data)

as you point out in your reply, skip tp_stub_func here too.

> +					new[j++] = old[i];
> +			new[nr_probes - nr_del].func = NULL;
> +		} else {
> +			for (i = 0; old[i].func; i++)
> +				if (old[i].func == tp_func->func &&
> +				    old[i].data == tp_func->data)
> +					old[i].func = tp_stub_func;

I think you'll want a WRITE_ONCE(old[i].func, tp_stub_func) here, matched
with a READ_ONCE() in __DO_TRACE. This introduces a new situation where the
func pointer can be updated and loaded concurrently.

> +		}
> +		*funcs = old;

The line above seems wrong for the successful allocate_probe case. You will likely
want *funcs = new on successful allocation, and *funcs = old for the failure case.

Thanks,

Mathieu

> 	}
> 	debug_print_probes(*funcs);
> 	return old;
> @@ -300,6 +312,10 @@ static int tracepoint_remove_func(struct tracepoint *tp,
> 		return PTR_ERR(old);
> 	}
> 
> +	if (tp_funcs == old)
> +		/* Failed allocating new tp_funcs, replaced func with stub */
> +		return 0;
> +
> 	if (!tp_funcs) {
> 		/* Removed last function */
>  		if (tp->unregfunc && static_key_enabled(&tp->key))

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
