Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2449B837
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377675AbiAYQH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349336AbiAYQHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:07:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617F3C06173B;
        Tue, 25 Jan 2022 08:07:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3B606143D;
        Tue, 25 Jan 2022 16:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DEAC340E0;
        Tue, 25 Jan 2022 16:07:00 +0000 (UTC)
Date:   Tue, 25 Jan 2022 11:06:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/9] ftrace: Add ftrace_set_filter_ips function
Message-ID: <20220125110659.2cc8df29@gandalf.local.home>
In-Reply-To: <164311270629.1933078.4596694198103138848.stgit@devnote2>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
        <164311270629.1933078.4596694198103138848.stgit@devnote2>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 21:11:46 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> From: Jiri Olsa <jolsa@redhat.com>
> 
> Adding ftrace_set_filter_ips function to be able to set filter on
> multiple ip addresses at once.
> 
> With the kprobe multi attach interface we have cases where we need to
> initialize ftrace_ops object with thousands of functions, so having
> single function diving into ftrace_hash_move_and_update_ops with
> ftrace_lock is faster.
> 
> The functions ips are passed as unsigned long array with count.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/ftrace.h |    3 +++
>  kernel/trace/ftrace.c  |   53 ++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 47 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9999e29187de..60847cbce0da 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -512,6 +512,8 @@ struct dyn_ftrace {
>  
>  int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>  			 int remove, int reset);
> +int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
> +			  unsigned int cnt, int remove, int reset);
>  int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
>  		       int len, int reset);
>  int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
> @@ -802,6 +804,7 @@ static inline unsigned long ftrace_location(unsigned long ip)
>  #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
>  #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
>  #define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
> +#define ftrace_set_filter_ips(ops, ips, cnt, remove, reset) ({ -ENODEV; })
>  #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
>  #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
>  #define ftrace_free_filter(ops) do { } while (0)
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index be5f6b32a012..39350aa38649 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4958,7 +4958,7 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
>  }
>  
>  static int
> -ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
> +__ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
>  {
>  	struct ftrace_func_entry *entry;
>  
> @@ -4976,9 +4976,25 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
>  	return add_hash_entry(hash, ip);
>  }
>  
> +static int
> +ftrace_match_addr(struct ftrace_hash *hash, unsigned long *ips,
> +		  unsigned int cnt, int remove)
> +{
> +	unsigned int i;
> +	int err;
> +
> +	for (i = 0; i < cnt; i++) {
> +		err = __ftrace_match_addr(hash, ips[i], remove);
> +		if (err)
> +			return err;

On error should we revert what was done?

			goto err;
> +	}
> +	return 0;

err:
	for (i--; i >= 0; i--)
		__ftrace_match_addr(hash, ips[i], !remove);
	return err;

Although it may not matter as it looks like it is only used on a temporary
hash. But either it should be commented that is the case, or we do the above
just to be more robust.

> +}
> +
>  static int
>  ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> -		unsigned long ip, int remove, int reset, int enable)
> +		unsigned long *ips, unsigned int cnt,
> +		int remove, int reset, int enable)
>  {
>  	struct ftrace_hash **orig_hash;
>  	struct ftrace_hash *hash;
> @@ -5008,8 +5024,8 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
>  		ret = -EINVAL;
>  		goto out_regex_unlock;
>  	}
> -	if (ip) {
> -		ret = ftrace_match_addr(hash, ip, remove);
> +	if (ips) {
> +		ret = ftrace_match_addr(hash, ips, cnt, remove);
>  		if (ret < 0)
>  			goto out_regex_unlock;
>  	}
> @@ -5026,10 +5042,10 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
>  }
>  
>  static int
> -ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
> -		int reset, int enable)
> +ftrace_set_addr(struct ftrace_ops *ops, unsigned long *ips, unsigned int cnt,
> +		int remove, int reset, int enable)
>  {
> -	return ftrace_set_hash(ops, NULL, 0, ip, remove, reset, enable);
> +	return ftrace_set_hash(ops, NULL, 0, ips, cnt, remove, reset, enable);
>  }
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> @@ -5634,10 +5650,29 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>  			 int remove, int reset)
>  {
>  	ftrace_ops_init(ops);
> -	return ftrace_set_addr(ops, ip, remove, reset, 1);
> +	return ftrace_set_addr(ops, &ip, 1, remove, reset, 1);
>  }
>  EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
>  
> +/**
> + * ftrace_set_filter_ips - set a functions to filter on in ftrace by addresses

		- set functions to filter on ...

-- Steve

> + * @ops - the ops to set the filter with
> + * @ips - the array of addresses to add to or remove from the filter.
> + * @cnt - the number of addresses in @ips
> + * @remove - non zero to remove ips from the filter
> + * @reset - non zero to reset all filters before applying this filter.
> + *
> + * Filters denote which functions should be enabled when tracing is enabled
> + * If @ips array or any ip specified within is NULL , it fails to update filter.
> + */
> +int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
> +			  unsigned int cnt, int remove, int reset)
> +{
> +	ftrace_ops_init(ops);
> +	return ftrace_set_addr(ops, ips, cnt, remove, reset, 1);
> +}
> +EXPORT_SYMBOL_GPL(ftrace_set_filter_ips);
> +
>  /**
>   * ftrace_ops_set_global_filter - setup ops to use global filters
>   * @ops - the ops which will use the global filters
> @@ -5659,7 +5694,7 @@ static int
>  ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
>  		 int reset, int enable)
>  {
> -	return ftrace_set_hash(ops, buf, len, 0, 0, reset, enable);
> +	return ftrace_set_hash(ops, buf, len, NULL, 0, 0, reset, enable);
>  }
>  
>  /**

