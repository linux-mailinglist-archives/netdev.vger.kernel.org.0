Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1D544235B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhKAW0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:26:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:33548 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhKAW0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:26:32 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhfif-000Fqp-CP; Mon, 01 Nov 2021 23:23:57 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhfif-00074F-6g; Mon, 01 Nov 2021 23:23:57 +0100
Subject: Re: [PATCH bpf-next 1/2] bpf: introduce helper bpf_find_vma
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kernel-team@fb.com,
        kpsingh@kernel.org
References: <20211027220043.1937648-1-songliubraving@fb.com>
 <20211027220043.1937648-2-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <368db409-c932-030b-a5bc-89efa56de289@iogearbox.net>
Date:   Mon, 1 Nov 2021 23:23:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211027220043.1937648-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26340/Mon Nov  1 09:21:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/21 12:00 AM, Song Liu wrote:
[...]
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index b48750bfba5aa..ad30f2e885356 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -8,6 +8,7 @@
>   #include <linux/fdtable.h>
>   #include <linux/filter.h>
>   #include <linux/btf_ids.h>
> +#include <linux/irq_work.h>
>   
>   struct bpf_iter_seq_task_common {
>   	struct pid_namespace *ns;
> @@ -21,6 +22,25 @@ struct bpf_iter_seq_task_info {
>   	u32 tid;
>   };
>   
> +/* irq_work to run mmap_read_unlock() */
> +struct task_iter_irq_work {
> +	struct irq_work irq_work;
> +	struct mm_struct *mm;
> +};
> +
> +static DEFINE_PER_CPU(struct task_iter_irq_work, mmap_unlock_work);
> +
> +static void do_mmap_read_unlock(struct irq_work *entry)
> +{
> +	struct task_iter_irq_work *work;
> +
> +	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
> +		return;
> +
> +	work = container_of(entry, struct task_iter_irq_work, irq_work);
> +	mmap_read_unlock_non_owner(work->mm);
> +}
> +
>   static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>   					     u32 *tid,
>   					     bool skip_if_dup_files)
> @@ -586,9 +606,89 @@ static struct bpf_iter_reg task_vma_reg_info = {
>   	.seq_info		= &task_vma_seq_info,
>   };
>   
> +BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
> +	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
> +{
> +	struct task_iter_irq_work *work = NULL;
> +	struct mm_struct *mm = task->mm;

Won't this NULL deref if called with task argument as NULL?

> +	struct vm_area_struct *vma;
> +	bool irq_work_busy = false;
> +	int ret = -ENOENT;
> +
> +	if (flags)
> +		return -EINVAL;
> +
> +	if (!mm)
> +		return -ENOENT;
> +
> +	/*
> +	 * Similar to stackmap with build_id support, we cannot simply do
> +	 * mmap_read_unlock when the irq is disabled. Instead, we need do
> +	 * the unlock in the irq_work.
> +	 */
> +	if (irqs_disabled()) {
> +		if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
> +			work = this_cpu_ptr(&mmap_unlock_work);
> +			if (irq_work_is_busy(&work->irq_work)) {
> +				/* cannot queue more mmap_unlock, abort. */
> +				irq_work_busy = true;
> +			}
> +		} else {
> +			/*
> +			 * PREEMPT_RT does not allow to trylock mmap sem in
> +			 * interrupt disabled context, abort.
> +			 */
> +			irq_work_busy = true;
> +		}
> +	}
> +
> +	if (irq_work_busy || !mmap_read_trylock(mm))
> +		return -EBUSY;
> +
> +	vma = find_vma(mm, start);
> +
> +	if (vma && vma->vm_start <= start && vma->vm_end > start) {
> +		callback_fn((u64)(long)task, (u64)(long)vma,
> +			    (u64)(long)callback_ctx, 0, 0);
> +		ret = 0;
> +	}
> +	if (!work) {
> +		mmap_read_unlock(current->mm);
> +	} else {
> +		work->mm = current->mm;
> +
> +		/* The lock will be released once we're out of interrupt
> +		 * context. Tell lockdep that we've released it now so
> +		 * it doesn't complain that we forgot to release it.
> +		 */
> +		rwsem_release(&current->mm->mmap_lock.dep_map, _RET_IP_);
> +		irq_work_queue(&work->irq_work);
> +	}

Given this is pretty much the same logic around the vma retrieval, could this be
refactored/consolidated with stack map build id retrieval into a common function?

> +	return ret;
> +}
> +
> +BTF_ID_LIST_SINGLE(btf_find_vma_ids, struct, task_struct)
> +
> +const struct bpf_func_proto bpf_find_vma_proto = {
> +	.func		= bpf_find_vma,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> +	.arg1_btf_id	= &btf_find_vma_ids[0],
> +	.arg2_type	= ARG_ANYTHING,
> +	.arg3_type	= ARG_PTR_TO_FUNC,
> +	.arg4_type	= ARG_PTR_TO_STACK_OR_NULL,
> +	.arg5_type	= ARG_ANYTHING,
> +};
[...]
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index c108200378834..056c00da1b5d6 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -4915,6 +4915,24 @@ union bpf_attr {
>    *		Dynamically cast a *sk* pointer to a *unix_sock* pointer.
>    *	Return
>    *		*sk* if casting is valid, or **NULL** otherwise.
> + * long bpf_find_vma(struct task_struct *task, u64 addr, void *callback_fn, void *callback_ctx, u64 flags)

nit: Wrongly copied uapi header over to tooling?

> + *	Description
> + *		Find vma of *task* that contains *addr*, call *callback_fn*
> + *		function with *task*, *vma*, and *callback_ctx*.
> + *		The *callback_fn* should be a static function and
> + *		the *callback_ctx* should be a pointer to the stack.
> + *		The *flags* is used to control certain aspects of the helper.
> + *		Currently, the *flags* must be 0.
> + *
> + *		The expected callback signature is
> + *
> + *		long (\*callback_fn)(struct task_struct \*task, struct vm_area_struct \*vma, void \*ctx);
> + *
> + *	Return
> + *		0 on success.
> + *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
> + *		**-EBUSY** if failed to try lock mmap_lock.
> + *		**-EINVAL** for invalid **flags**.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -5096,6 +5114,7 @@ union bpf_attr {
>   	FN(get_branch_snapshot),	\
>   	FN(trace_vprintk),		\
>   	FN(skc_to_unix_sock),		\
> +	FN(find_vma),			\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> 

