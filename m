Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A7822C880
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgGXOyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:54:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:44572 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgGXOyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 10:54:00 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyz51-0003nF-So; Fri, 24 Jul 2020 16:53:47 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyz51-000Hv8-Mj; Fri, 24 Jul 2020 16:53:47 +0200
Subject: Re: [PATCH v3 bpf-next 3/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     torvalds@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20200724055854.59013-1-alexei.starovoitov@gmail.com>
 <20200724055854.59013-4-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <418b538a-1799-af47-be1e-22e88d0119af@iogearbox.net>
Date:   Fri, 24 Jul 2020 16:53:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200724055854.59013-4-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25882/Thu Jul 23 16:39:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 7:58 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add kernel module with user mode driver that populates bpffs with
> BPF iterators.
> 
> $ mount bpffs /my/bpffs/ -t bpf
> $ ls -la /my/bpffs/
> total 4
> drwxrwxrwt  2 root root    0 Jul  2 00:27 .
> drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
> -rw-------  1 root root    0 Jul  2 00:27 maps.debug
> -rw-------  1 root root    0 Jul  2 00:27 progs.debug
> 
> The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
> maps, load two BPF programs, attach them to BPF iterators, and finally send two
> bpf_link IDs back to the kernel.
> The kernel will pin two bpf_links into newly mounted bpffs instance under
> names "progs.debug" and "maps.debug". These two files become human readable.
> 
> $ cat /my/bpffs/progs.debug
>    id name            pages attached
>    11 dump_bpf_map        1 bpf_iter_bpf_map
>    12 dump_bpf_prog       1 bpf_iter_bpf_prog
>    27 test_pkt_access     1
>    32 test_main           1 test_pkt_access test_pkt_access
>    33 test_subprog1       1 test_pkt_access_subprog1 test_pkt_access
>    34 test_subprog2       1 test_pkt_access_subprog2 test_pkt_access
>    35 test_subprog3       1 test_pkt_access_subprog3 test_pkt_access
>    36 new_get_skb_len     1 get_skb_len test_pkt_access
>    37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
>    38 new_get_constan     1 get_constant test_pkt_access
> 
> The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
> all BPF programs currently loaded in the system. This information is unstable
> and will change from kernel to kernel as ".debug" suffix conveys.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>   init/Kconfig                                  |   2 +
>   kernel/bpf/Makefile                           |   1 +
>   kernel/bpf/inode.c                            | 132 +++++++++++++++++-
>   kernel/bpf/preload/Kconfig                    |  18 +++
>   kernel/bpf/preload/Makefile                   |  21 +++
>   kernel/bpf/preload/bpf_preload.h              |  16 +++
>   kernel/bpf/preload/bpf_preload_kern.c         |  83 +++++++++++
>   kernel/bpf/preload/bpf_preload_umd_blob.S     |   7 +
>   .../preload/iterators/bpf_preload_common.h    |  13 ++
>   kernel/bpf/preload/iterators/iterators.c      |  94 +++++++++++++
>   10 files changed, 384 insertions(+), 3 deletions(-)
>   create mode 100644 kernel/bpf/preload/Kconfig
>   create mode 100644 kernel/bpf/preload/Makefile
>   create mode 100644 kernel/bpf/preload/bpf_preload.h
>   create mode 100644 kernel/bpf/preload/bpf_preload_kern.c
>   create mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
>   create mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
>   create mode 100644 kernel/bpf/preload/iterators/iterators.c
[...]
>   
> +struct bpf_preload_ops bpf_preload_ops = { .info.driver_name = "bpf_preload" };
> +EXPORT_SYMBOL_GPL(bpf_preload_ops);
> +
> +#if !IS_BUILTIN(CONFIG_BPF_PRELOAD_UMD)
> +static struct module *bpf_preload_mod;
> +#endif
> +
> +static bool bpf_preload_mod_get(void)
> +{
> +	bool ret = true;
> +
> +#if IS_BUILTIN(CONFIG_BPF_PRELOAD_UMD)
> +	return ret;
> +#else
> +	/* if bpf_preload.ko wasn't loaded earlier then load it now */
> +	if (!bpf_preload_ops.do_preload) {
> +		request_module("bpf_preload");
> +		if (!bpf_preload_ops.do_preload) {
> +			pr_err("bpf_preload module is missing.\n"
> +			       "bpffs will not have iterators.\n");
> +			return false;
> +		}
> +	}
> +	/* and grab the reference, so it doesn't disappear while the kernel
> +	 * is interacting with kernel module and its UMD
> +	 */
> +	preempt_disable();
> +	bpf_preload_mod = __module_address((long)bpf_preload_ops.do_preload);
> +	if (!bpf_preload_mod || !try_module_get(bpf_preload_mod)) {

Set looks good overall, but this combination looks a bit odd. Meaning, we request the
module via request_module(), in its init fn, it will set bpf_preload_ops.do_preload
callback, and here we need to search kallsyms on __module_address(bpf_preload_ops.do_preload)
just to get the module struct in order to place a ref on it via try_module_get().

Why can't the bpf_preload module simply do:

static const struct bpf_preload_umd_ops umd_ops = {
         .preload        = do_preload,
         .finish         = do_finish,
         .owner          = THIS_MODULE,
};

And then in load_umd():

static int __init load_umd(void)
{
	int err;

	err = umd_load_blob(&bpf_preload_ops.info, &bpf_preload_umd_start,
			    &bpf_preload_umd_end - &bpf_preload_umd_start);
	if (!err)
		bpf_preload_umd_ops = &umd_ops;
	return err;
}

Then later in bpf_preload_mod_get() you just do ...

   try_module_get(bpf_preload_umd_ops->owner)

... and can avoid this whole detour with symbol address search which looks odd and
unneeded for this case.

Thanks,
Daniel

> +		bpf_preload_mod = NULL;
> +		pr_err("bpf_preload module get failed.\n");
> +		ret = false;
> +	}
> +	preempt_enable();
> +	return ret;
> +#endif
> +}
> +
> +static void bpf_preload_mod_put(void)
> +{
> +#if !IS_BUILTIN(CONFIG_BPF_PRELOAD_UMD)
> +	if (bpf_preload_mod) {
> +		/* now user can "rmmod bpf_preload" if necessary */
> +		module_put(bpf_preload_mod);
> +		bpf_preload_mod = NULL;
> +	}
> +#endif
> +}
> +
> +static int populate_bpffs(struct dentry *parent)
> +{
> +	struct bpf_preload_info objs[BPF_PRELOAD_LINKS] = {};
> +	struct bpf_link *links[BPF_PRELOAD_LINKS] = {};
> +	int err = 0, i;
> +
> +	/* grab the mutex to make sure the kernel interactions with bpf_preload
> +	 * UMD are serialized
> +	 */
> +	mutex_lock(&bpf_preload_ops.lock);
> +
> +	/* if bpf_preload.ko wasn't built into vmlinux then load it */
> +	if (!bpf_preload_mod_get())
> +		goto out;
> +
> +	if (!bpf_preload_ops.info.tgid) {
> +		/* do_preload will start UMD that will load BPF iterator programs */
> +		err = bpf_preload_ops.do_preload(objs);
> +		if (err)
> +			goto out_put;
> +		for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
> +			links[i] = bpf_link_by_id(objs[i].link_id);
> +			if (IS_ERR(links[i])) {
> +				err = PTR_ERR(links[i]);
> +				goto out_put;
> +			}
> +		}
> +		for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
> +			err = bpf_iter_link_pin_kernel(parent,
> +						       objs[i].link_name, links[i]);
> +			if (err)
> +				goto out_put;
> +			/* do not unlink successfully pinned links even
> +			 * if later link fails to pin
> +			 */
> +			links[i] = NULL;
> +		}
> +		/* do_finish() will tell UMD process to exit */
> +		err = bpf_preload_ops.do_finish();
> +		if (err)
> +			goto out_put;
> +	}
> +out_put:
> +	bpf_preload_mod_put();
> +out:
> +	mutex_unlock(&bpf_preload_ops.lock);
> +	for (i = 0; i < BPF_PRELOAD_LINKS && err; i++)
> +		if (!IS_ERR_OR_NULL(links[i]))
> +			bpf_link_put(links[i]);
[...]
