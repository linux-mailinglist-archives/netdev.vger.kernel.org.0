Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A40349B8F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 22:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhCYV1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 17:27:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:41752 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhCYV0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 17:26:38 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lPXUv-000AXJ-4k; Thu, 25 Mar 2021 22:26:33 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lPXUu-000173-Sh; Thu, 25 Mar 2021 22:26:32 +0100
Subject: Re: [PATCHv2] bpf: Take module reference for trampoline in module
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20210324174030.2053353-1-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7cc5c310-c764-99bb-ad59-5ac04402bd5d@iogearbox.net>
Date:   Thu, 25 Mar 2021 22:26:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210324174030.2053353-1-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26120/Thu Mar 25 12:15:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 6:40 PM, Jiri Olsa wrote:
> Currently module can be unloaded even if there's a trampoline
> register in it. It's easily reproduced by running in parallel:
> 
>    # while :; do ./test_progs -t module_attach; done
>    # while :; do rmmod bpf_testmod; sleep 0.5; done
> 
> Taking the module reference in case the trampoline's ip is
> within the module code. Releasing it when the trampoline's
> ip is unregistered.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> v2 changes:
>    - fixed ip_module_put to do preempt_disable/preempt_enable
> 
>   kernel/bpf/trampoline.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 1f3a4be4b175..39e4280f94e4 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -87,6 +87,26 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>   	return tr;
>   }
>   
> +static struct module *ip_module_get(unsigned long ip)
> +{
> +	struct module *mod;
> +	int err = 0;
> +
> +	preempt_disable();
> +	mod = __module_text_address(ip);
> +	if (mod && !try_module_get(mod))
> +		err = -ENOENT;
> +	preempt_enable();
> +	return err ? ERR_PTR(err) : mod;
> +}
> +
> +static void ip_module_put(unsigned long ip)
> +{
> +	preempt_disable();
> +	module_put(__module_text_address(ip));
> +	preempt_enable();

Could we cache the mod pointer in tr instead of doing another addr search
for dropping the ref?

> +}
> +
>   static int is_ftrace_location(void *ip)
>   {
>   	long addr;
> @@ -108,6 +128,9 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
>   		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
>   	else
>   		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
> +
> +	if (!ret)
> +		ip_module_put((unsigned long) ip);
>   	return ret;
>   }
>   
> @@ -126,6 +149,7 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
>   /* first time registering */
>   static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>   {
> +	struct module *mod;
>   	void *ip = tr->func.addr;
>   	int ret;
>   
> @@ -134,10 +158,17 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>   		return ret;
>   	tr->func.ftrace_managed = ret;
>   
> +	mod = ip_module_get((unsigned long) ip);
> +	if (IS_ERR(mod))
> +		return -ENOENT;
> +
>   	if (tr->func.ftrace_managed)
>   		ret = register_ftrace_direct((long)ip, (long)new_addr);
>   	else
>   		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
> +
> +	if (ret)
> +		module_put(mod);
>   	return ret;
>   }
>   
> 

