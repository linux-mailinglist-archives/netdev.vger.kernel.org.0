Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4738A1434B7
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgAUAVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 19:21:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:42716 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgAUAVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:21:48 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1itgsx-0000kr-5K; Tue, 21 Jan 2020 00:55:11 +0100
Received: from [178.197.248.27] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1itgsw-00016c-NK; Tue, 21 Jan 2020 00:55:10 +0100
Subject: Re: [PATCH 5/6] bpf: Allow to resolve bpf trampoline and dispatcher
 in unwind
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
References: <20200118134945.493811-1-jolsa@kernel.org>
 <20200118134945.493811-6-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <133ecb39-c739-02b9-3c83-37ee24846037@iogearbox.net>
Date:   Tue, 21 Jan 2020 00:55:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200118134945.493811-6-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25701/Mon Jan 20 12:41:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/20 2:49 PM, Jiri Olsa wrote:
> When unwinding the stack we need to identify each address
> to successfully continue. Adding latch tree to keep trampolines
> for quick lookup during the unwind.
> 
> The patch uses first 48 bytes for latch tree node, leaving 4048
> bytes from the rest of the page for trampoline or dispatcher
> generated code.
> 
> It's still enough not to affect trampoline and dispatcher progs
> maximum counts.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   include/linux/bpf.h     | 12 ++++++-
>   kernel/bpf/core.c       |  2 ++
>   kernel/bpf/dispatcher.c |  4 +--
>   kernel/bpf/trampoline.c | 76 +++++++++++++++++++++++++++++++++++++----
>   4 files changed, 84 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 8e3b8f4ad183..41eb0cf663e8 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -519,7 +519,6 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
>   int bpf_trampoline_link_prog(struct bpf_prog *prog);
>   int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
>   void bpf_trampoline_put(struct bpf_trampoline *tr);
> -void *bpf_jit_alloc_exec_page(void);
>   #define BPF_DISPATCHER_INIT(name) {			\
>   	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
>   	.func = &name##func,				\
> @@ -551,6 +550,13 @@ void *bpf_jit_alloc_exec_page(void);
>   #define BPF_DISPATCHER_PTR(name) (&name)
>   void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
>   				struct bpf_prog *to);
> +struct bpf_image {
> +	struct latch_tree_node tnode;
> +	unsigned char data[];
> +};
> +#define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
> +bool is_bpf_image(void *addr);
> +void *bpf_image_alloc(void);
>   #else
>   static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>   {
> @@ -572,6 +578,10 @@ static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
>   static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
>   					      struct bpf_prog *from,
>   					      struct bpf_prog *to) {}
> +static inline bool is_bpf_image(void *addr)
> +{
> +	return false;
> +}
>   #endif
>   
>   struct bpf_func_info_aux {
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 29d47aae0dd1..b3299dc9adda 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -704,6 +704,8 @@ bool is_bpf_text_address(unsigned long addr)
>   
>   	rcu_read_lock();
>   	ret = bpf_prog_kallsyms_find(addr) != NULL;
> +	if (!ret)
> +		ret = is_bpf_image((void *) addr);
>   	rcu_read_unlock();

Btw, shouldn't this be a separate entity entirely to avoid unnecessary inclusion
in bpf_arch_text_poke() for the is_bpf_text_address() check there?

Did you drop the bpf_{trampoline,dispatcher}_<...> entry addition in kallsyms?

Thanks,
Daniel
