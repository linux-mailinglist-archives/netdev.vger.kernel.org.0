Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDADC6204DF
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 01:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiKHAql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 19:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiKHAqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 19:46:39 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC3C62E3;
        Mon,  7 Nov 2022 16:46:37 -0800 (PST)
Message-ID: <5a1413c6-6a42-de02-810f-232a83628424@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667868396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDYFiUcfEaDUGFLdmrC859M8X8kO4TlbKBdLHnZHsxA=;
        b=VtJKbevt5Lux7H2pXGuCOsgEDM+naOijDZLhqy5GoKgauiX0MvEXcx9dFTyHVozeHLeKQ6
        T6od4VwzvzpE4xF5CzWXZuVbK+vbfeYRrHq6IIPN4W2lVuYuZQX3YXJEnxn6XjQkLgZ3Y3
        rNQWJVYM5lftB7oyY3CddaglcJrXZIA=
Date:   Mon, 7 Nov 2022 16:46:27 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf v3] bpf: Fix memory leaks in __check_func_call
Content-Language: en-US
To:     Wang Yufen <wangyufen@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, yhs@fb.com, joe@wand.net.nz
References: <1667468524-4926-1-git-send-email-wangyufen@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <1667468524-4926-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/22 2:42 AM, Wang Yufen wrote:
> kmemleak reports this issue:
> 
> unreferenced object 0xffff88817139d000 (size 2048):
>    comm "test_progs", pid 33246, jiffies 4307381979 (age 45851.820s)
>    hex dump (first 32 bytes):
>      01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<0000000045f075f0>] kmalloc_trace+0x27/0xa0
>      [<0000000098b7c90a>] __check_func_call+0x316/0x1230
>      [<00000000b4c3c403>] check_helper_call+0x172e/0x4700
>      [<00000000aa3875b7>] do_check+0x21d8/0x45e0
>      [<000000001147357b>] do_check_common+0x767/0xaf0
>      [<00000000b5a595b4>] bpf_check+0x43e3/0x5bc0
>      [<0000000011e391b1>] bpf_prog_load+0xf26/0x1940
>      [<0000000007f765c0>] __sys_bpf+0xd2c/0x3650
>      [<00000000839815d6>] __x64_sys_bpf+0x75/0xc0
>      [<00000000946ee250>] do_syscall_64+0x3b/0x90
>      [<0000000000506b7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The root case here is: In function prepare_func_exit(), the callee is
> not released in the abnormal scenario after "state->curframe--;". To
> fix, move "state->curframe--;" to the very bottom of the function,
> right when we free callee and reset frame[] pointer to NULL, as Andrii
> suggested.
> 
> In addition, function __check_func_call() has a similar problem. In
> the abnormal scenario before "state->curframe++;", the callee is alse
> not released.
> 
> Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
> Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>   kernel/bpf/verifier.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7f0a9f6..eff7a5a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6736,11 +6736,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>   	/* Transfer references to the callee */
>   	err = copy_reference_state(callee, caller);
>   	if (err)
> -		return err;
> +		goto err_out;
>   
>   	err = set_callee_state_cb(env, caller, callee, *insn_idx);
>   	if (err)
> -		return err;
> +		goto err_out;
>   
>   	clear_caller_saved_regs(env, caller->regs);
>   
> @@ -6757,6 +6757,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>   		print_verifier_state(env, callee, true);
>   	}
>   	return 0;
> +
> +err_out:
> +	kfree(callee);

Is it sure that free_func_state() is not needed ?

> +	state->frame[state->curframe + 1] = NULL;
> +	return err;
>   }
>   
>   int map_set_for_each_callback_args(struct bpf_verifier_env *env,
> @@ -6970,8 +6975,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
>   		return -EINVAL;
>   	}
>   
> -	state->curframe--;
> -	caller = state->frame[state->curframe];
> +	caller = state->frame[state->curframe - 1];
>   	if (callee->in_callback_fn) {
>   		/* enforce R0 return value range [0, 1]. */
>   		struct tnum range = callee->callback_ret_range;
> @@ -7001,6 +7005,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
>   			return err;
>   	}
>   
> +	state->curframe--;

nit. state->curframe is always pointing to callee upto this point?  Instead of 
doing another +1 dance in the latter 'state->frame[state->curframe + 1] = 
NULL;', how about do it later like:

	/* clear everything in the callee */
         free_func_state(callee);
	state->frame[state->curframe--] = NULL;


It shouldn't affect the earlier print_verifier_state() which explicitly takes 
callee and caller as its arg, right?

>   	*insn_idx = callee->callsite + 1;
>   	if (env->log.level & BPF_LOG_LEVEL) {
>   		verbose(env, "returning from callee:\n");

