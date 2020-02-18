Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E959D16363A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgBRWex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:34:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:47746 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBRWew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 17:34:52 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4BS4-0005lA-Hh; Tue, 18 Feb 2020 23:34:48 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4BS4-000OU6-1k; Tue, 18 Feb 2020 23:34:48 +0100
Subject: Re: [PATCH 06/18] bpf: Add bpf_ksym_tree tree
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20200216193005.144157-1-jolsa@kernel.org>
 <20200216193005.144157-7-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e869424c-eaf5-d8b1-dfde-86958f437538@iogearbox.net>
Date:   Tue, 18 Feb 2020 23:34:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200216193005.144157-7-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25727/Tue Feb 18 15:05:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/20 8:29 PM, Jiri Olsa wrote:
> The bpf_tree is used both for kallsyms iterations and searching
> for exception tables of bpf programs, which is needed only for
> bpf programs.
> 
> Adding bpf_ksym_tree that will hold symbols for all bpf_prog
> bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
> only for bpf_prog objects to keep it fast.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   include/linux/bpf.h |  1 +
>   kernel/bpf/core.c   | 60 ++++++++++++++++++++++++++++++++++++++++-----
>   2 files changed, 55 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f1174d24c185..5d6649cdc3df 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -468,6 +468,7 @@ struct bpf_ksym {
>   	unsigned long		 end;
>   	char			 name[KSYM_NAME_LEN];
>   	struct list_head	 lnode;
> +	struct latch_tree_node	 tnode;
>   };
>   
>   enum bpf_tramp_prog_type {
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 604093d2153a..9fb08b4d01f7 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -606,8 +606,46 @@ static const struct latch_tree_ops bpf_tree_ops = {
>   	.comp	= bpf_tree_comp,
>   };
>   
> +static unsigned long
> +bpf_get_ksym_start(struct latch_tree_node *n)
> +{
> +	const struct bpf_ksym *ksym;
> +
> +	ksym = container_of(n, struct bpf_ksym, tnode);
> +	return ksym->start;

Small nit, can be simplified to:

	return container_of(n, struct bpf_ksym, tnode)->start;

> +}
> +
> +static bool
> +bpf_ksym_tree_less(struct latch_tree_node *a,
> +		   struct latch_tree_node *b)
> +{
> +	return bpf_get_ksym_start(a) < bpf_get_ksym_start(b);
> +}
> +
> +static int
> +bpf_ksym_tree_comp(void *key, struct latch_tree_node *n)
> +{
> +	unsigned long val = (unsigned long)key;
> +	const struct bpf_ksym *ksym;
> +
> +	ksym = container_of(n, struct bpf_ksym, tnode);
> +
> +	if (val < ksym->start)
> +		return -1;
> +	if (val >= ksym->end)
> +		return  1;
> +
> +	return 0;
> +}
> +
> +static const struct latch_tree_ops bpf_ksym_tree_ops = {
> +	.less	= bpf_ksym_tree_less,
> +	.comp	= bpf_ksym_tree_comp,
> +};
> +
>   static DEFINE_SPINLOCK(bpf_lock);
>   static LIST_HEAD(bpf_kallsyms);
> +static struct latch_tree_root bpf_ksym_tree __cacheline_aligned;
>   static struct latch_tree_root bpf_tree __cacheline_aligned;

You mention in your commit description performance being the reason on why
we need two latch trees. Can't we maintain everything just in a single one?

What does "to keep it fast" mean here in absolute numbers that would affect
overall system performance? It feels a bit like premature optimization with
the above rationale as-is.

If it is about differentiating the different bpf_ksym symbols for some of the
kallsym handling functions (?), can't we simply add an enum bpf_ksym_type {
BPF_SYM_PROGRAM, BPF_SYM_TRAMPOLINE, BPF_SYM_DISPATCHER } instead, but still
maintain them all in a single latch tree?

Thanks,
Daniel
