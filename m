Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502ED22A245
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgGVWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:16:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:43870 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGVWQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:16:23 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyN25-0007uB-Qk; Thu, 23 Jul 2020 00:16:13 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jyN25-000O10-Kn; Thu, 23 Jul 2020 00:16:13 +0200
Subject: Re: [PATCH v2 bpf-next 4/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     torvalds@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20200717044031.56412-1-alexei.starovoitov@gmail.com>
 <20200717044031.56412-5-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <35b9bedb-a278-beac-0648-04416761acfb@iogearbox.net>
Date:   Thu, 23 Jul 2020 00:16:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200717044031.56412-5-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25881/Wed Jul 22 16:35:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/20 6:40 AM, Alexei Starovoitov wrote:
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
[...]
>   static int bpf_obj_do_pin(const char __user *pathname, void *raw,
>   			  enum bpf_type type)
>   {
> @@ -638,6 +661,61 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
>   	return 0;
>   }
>   
> +struct bpf_preload_ops bpf_preload_ops = { .info.driver_name = "bpf_preload" };
> +EXPORT_SYMBOL_GPL(bpf_preload_ops);
> +
> +static int populate_bpffs(struct dentry *parent)
> +{
> +	struct bpf_preload_info objs[BPF_PRELOAD_LINKS] = {};
> +	struct bpf_link *links[BPF_PRELOAD_LINKS] = {};
> +	int err = 0, i;
> +
> +	mutex_lock(&bpf_preload_ops.lock);
> +	if (!bpf_preload_ops.do_preload) {
> +		mutex_unlock(&bpf_preload_ops.lock);
> +		request_module("bpf_preload");
> +		mutex_lock(&bpf_preload_ops.lock);
> +
> +		if (!bpf_preload_ops.do_preload) {
> +			pr_err("bpf_preload module is missing.\n"
> +			       "bpffs will not have iterators.\n");
> +			goto out;
> +		}
> +	}

Overall set looks good. One thing that appears to be possible from staring at
the code is that while we load the bpf_preload module here and below invoke the
modules' preload ops callbacks, there seems to be nothing that prevents the module
from being forcefully unloaded in parallel (e.g. no ref on the module held).

So it looks like the old bpfilter code was preventing exactly this through holding
bpfilter_ops.lock mutex during its {load,fini}_umh() modules init/exit functions.

Other than that, maybe it would be nice to have a test_progs selftests extension
which mounts multiple BPF fs instances, and asserts that if one of them has the
{progs,maps}.debug files that the other ones must have it as well, plus plain
reading of both (w/o parsing anything from there) just to make sure the dump
terminates .. at least to have some basic exercising of the code in there.

Thanks,
Daniel

> +	if (!bpf_preload_ops.info.tgid) {
> +		err = bpf_preload_ops.do_preload(objs);
> +		if (err)
> +			goto out;
> +		for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
> +			links[i] = bpf_link_by_id(objs[i].link_id);
> +			if (IS_ERR(links[i])) {
> +				err = PTR_ERR(links[i]);
> +				goto out;
> +			}
> +		}
> +		for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
> +			err = bpf_iter_link_pin_kernel(parent,
> +						       objs[i].link_name, links[i]);
> +			if (err)
> +				goto out;
> +			/* do not unlink successfully pinned links even
> +			 * if later link fails to pin
> +			 */
> +			links[i] = NULL;
> +		}
> +		err = bpf_preload_ops.do_finish();
> +		if (err)
> +			goto out;
> +	}
> +out:
> +	mutex_unlock(&bpf_preload_ops.lock);
> +	for (i = 0; i < BPF_PRELOAD_LINKS && err; i++)
> +		if (!IS_ERR_OR_NULL(links[i]))
> +			bpf_link_put(links[i]);
> +	return err;
> +}
> +
>   static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
>   {
>   	static const struct tree_descr bpf_rfiles[] = { { "" } };
> @@ -654,8 +732,8 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
>   	inode = sb->s_root->d_inode;
>   	inode->i_op = &bpf_dir_iops;
>   	inode->i_mode &= ~S_IALLUGO;
> +	populate_bpffs(sb->s_root);
>   	inode->i_mode |= S_ISVTX | opts->mode;
> -
>   	return 0;
>   }
>   
> @@ -705,6 +783,8 @@ static int __init bpf_init(void)
[...]
> diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
> new file mode 100644
> index 000000000000..cd10f291d6cd
> --- /dev/null
> +++ b/kernel/bpf/preload/bpf_preload_kern.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/pid.h>
> +#include <linux/fs.h>
> +#include <linux/sched/signal.h>
> +#include "bpf_preload.h"
> +
> +extern char bpf_preload_umd_start;
> +extern char bpf_preload_umd_end;
> +
> +static int do_preload(struct bpf_preload_info *obj)
> +{
> +	int magic = BPF_PRELOAD_START;
> +	struct pid *tgid;
> +	loff_t pos = 0;
> +	int i, err;
> +	ssize_t n;
> +
> +	err = fork_usermode_driver(&bpf_preload_ops.info);
> +	if (err)
> +		return err;
> +	tgid = bpf_preload_ops.info.tgid;
> +
> +	/* send the start magic to let UMD proceed with loading BPF progs */
> +	n = kernel_write(bpf_preload_ops.info.pipe_to_umh,
> +			 &magic, sizeof(magic), &pos);
> +	if (n != sizeof(magic))
> +		return -EPIPE;
> +
> +	/* receive bpf_link IDs and names from UMD */
> +	pos = 0;
> +	for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
> +		n = kernel_read(bpf_preload_ops.info.pipe_from_umh,
> +				&obj[i], sizeof(*obj), &pos);
> +		if (n != sizeof(*obj))
> +			return -EPIPE;
> +	}
> +	return 0;
> +}
> +
> +static int do_finish(void)
> +{
> +	int magic = BPF_PRELOAD_END;
> +	struct pid *tgid;
> +	loff_t pos = 0;
> +	ssize_t n;
> +
> +	/* send the last magic to UMD. It will do a normal exit. */
> +	n = kernel_write(bpf_preload_ops.info.pipe_to_umh,
> +			 &magic, sizeof(magic), &pos);
> +	if (n != sizeof(magic))
> +		return -EPIPE;
> +	tgid = bpf_preload_ops.info.tgid;
> +	wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
> +	bpf_preload_ops.info.tgid = NULL;
> +	return 0;
> +}
> +
> +static int __init load_umd(void)
> +{
> +	int err;
> +
> +	err = umd_load_blob(&bpf_preload_ops.info, &bpf_preload_umd_start,
> +			    &bpf_preload_umd_end - &bpf_preload_umd_start);
> +	if (err)
> +		return err;
> +	bpf_preload_ops.do_preload = do_preload;
> +	bpf_preload_ops.do_finish = do_finish;
> +	return err;
> +}
> +
> +static void __exit fini_umd(void)
> +{
> +	bpf_preload_ops.do_preload = NULL;
> +	bpf_preload_ops.do_finish = NULL;
> +	/* kill UMD in case it's still there due to earlier error */
> +	kill_pid(bpf_preload_ops.info.tgid, SIGKILL, 1);
> +	bpf_preload_ops.info.tgid = NULL;
> +	umd_unload_blob(&bpf_preload_ops.info);
> +}
[...]
