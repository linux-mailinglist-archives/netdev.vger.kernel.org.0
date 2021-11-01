Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEE8442361
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhKAW3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:29:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:33970 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhKAW3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:29:12 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhflF-000G1T-Cw; Mon, 01 Nov 2021 23:26:37 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhflF-000LVr-77; Mon, 01 Nov 2021 23:26:37 +0100
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kernel-team@fb.com,
        kpsingh@kernel.org
References: <20211027220043.1937648-1-songliubraving@fb.com>
 <20211027220043.1937648-3-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <25320fdb-bf37-9fd2-869c-72657de8e9a8@iogearbox.net>
Date:   Mon, 1 Nov 2021 23:26:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211027220043.1937648-3-songliubraving@fb.com>
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
> +static __u64
> +check_vma(struct task_struct *task, struct vm_area_struct *vma,
> +	  struct callback_ctx *data)
> +{
> +	if (vma->vm_file)
> +		bpf_probe_read_kernel_str(d_iname, DNAME_INLINE_LEN - 1,
> +					  vma->vm_file->f_path.dentry->d_iname);
> +
> +	/* check for VM_EXEC */
> +	if (vma->vm_flags & VM_EXEC)
> +		found_vm_exec = 1;
> +

Could you also add test cases that verifier will reject write attempts to task/vma
for the callback?

> +	return 0;
> +}
> +
> +SEC("kprobe/__x64_sys_getpgid")
> +int handle_getpid(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	if (task->pid != target_pid)
> +		return 0;
> +
> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +	/* this should return -ENOENT */
> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +	return 0;
> +}
> +
> +SEC("perf_event")
> +int handle_pe(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	if (task->pid != target_pid)
> +		return 0;
> +
> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +	/* In NMI, this should return -EBUSY, as the previous call is using
> +	 * the irq_work.
> +	 */
> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +	return 0;
> +}
> 

