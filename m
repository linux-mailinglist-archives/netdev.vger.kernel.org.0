Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CBBE56BF
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfJYW5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:57:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:55888 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfJYW5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 18:57:14 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO8W7-00018H-45; Sat, 26 Oct 2019 00:57:11 +0200
Date:   Sat, 26 Oct 2019 00:57:10 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf@vger.kernel.org, yhs@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3] bpf: add new helper fd2path for mapping a
 file descriptor to a pathname
Message-ID: <20191025225710.GG14547@pc-63.home>
References: <20191024143856.30562-1-ethercflow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024143856.30562-1-ethercflow@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 10:38:56AM -0400, Wenbo Zhang wrote:
[...]
> index 2c2c29b49845..d73314a7e674 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1082,6 +1082,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
>  extern const struct bpf_func_proto bpf_strtol_proto;
>  extern const struct bpf_func_proto bpf_strtoul_proto;
>  extern const struct bpf_func_proto bpf_tcp_sock_proto;
> +extern const struct bpf_func_proto bpf_fd2path_proto;

Don't think we need to expose it here. More below.

>  /* Shared helpers among cBPF and eBPF. */
>  void bpf_user_rnd_init_once(void);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4af8b0819a32..fdb37740951f 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2773,6 +2773,15 @@ union bpf_attr {
>   *
>   * 		This helper is similar to **bpf_perf_event_output**\ () but
>   * 		restricted to raw_tracepoint bpf programs.
> + *
> + * int bpf_fd2path(char *path, u32 size, int fd)
> + *	Description
> + *		Get **file** atrribute from the current task by *fd*, then call
> + *		**d_path** to get it's absolute path and copy it as string into
> + *		*path* of *size*. The **path** also support pseudo filesystems
> + *		(whether or not it can be mounted). The *size* must be strictly
> + *		positive. On success, the helper makes sure that the *path* is
> + *		NUL-terminated. On failure, it is filled with zeroes.
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.

The 'Return' bits are now removed from prior helper description?

>   */
> @@ -2888,7 +2897,8 @@ union bpf_attr {
>  	FN(sk_storage_delete),		\
>  	FN(send_signal),		\
>  	FN(tcp_gen_syncookie),		\
> -	FN(skb_output),
> +	FN(skb_output),			\
> +	FN(fd2path),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 673f5d40a93e..6b44ed804280 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2079,6 +2079,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
>  const struct bpf_func_proto bpf_get_current_comm_proto __weak;
>  const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
>  const struct bpf_func_proto bpf_get_local_storage_proto __weak;
> +const struct bpf_func_proto bpf_fd2path_proto __weak;

Ditto, not needed ...

>  const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
>  {
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5e28718928ca..8e6b4189a456 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -487,3 +487,39 @@ const struct bpf_func_proto bpf_strtoul_proto = {
>  	.arg4_type	= ARG_PTR_TO_LONG,
>  };
>  #endif
> +
> +BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
> +{
> +	struct fd f;
> +	char *p;
> +	int ret = -EINVAL;
> +
> +	f = fdget_raw(fd);

What's the rationale for using the fdget_raw variant?

> +	if (!f.file)
> +		goto error;
> +
> +	p = d_path(&f.file->f_path, dst, size);
> +	if (IS_ERR_OR_NULL(p)) {
> +		ret = PTR_ERR(p);
> +		goto error;
> +	}
> +
> +	ret = strlen(p);
> +	memmove(dst, p, ret);
> +	dst[ret] = '\0';
> +	goto end;
> +
> +error:
> +	memset(dst, '0', size);
> +end:
> +	return ret;

Where is fdput(f) in here?

> +}
> +
> +const struct bpf_func_proto bpf_fd2path_proto = {
> +	.func       = bpf_fd2path,
> +	.gpl_only   = true,
> +	.ret_type   = RET_INTEGER,
> +	.arg1_type  = ARG_PTR_TO_UNINIT_MEM,
> +	.arg2_type  = ARG_CONST_SIZE,
> +	.arg3_type  = ARG_ANYTHING,
> +};

... as you can simply add the helper into kernel/trace/bpf_trace.c right
away if it's only used form there anyway and make bpf_fd2path_proto static.

> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index c3240898cc44..26f65abdb249 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  #endif
>  	case BPF_FUNC_send_signal:
>  		return &bpf_send_signal_proto;
> +	case BPF_FUNC_fd2path:
> +		return &bpf_fd2path_proto;
>  	default:
>  		return NULL;
>  	}
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4af8b0819a32..fdb37740951f 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -2773,6 +2773,15 @@ union bpf_attr {
>   *
>   * 		This helper is similar to **bpf_perf_event_output**\ () but
>   * 		restricted to raw_tracepoint bpf programs.
> + *
> + * int bpf_fd2path(char *path, u32 size, int fd)
> + *	Description
> + *		Get **file** atrribute from the current task by *fd*, then call
> + *		**d_path** to get it's absolute path and copy it as string into
> + *		*path* of *size*. The **path** also support pseudo filesystems
> + *		(whether or not it can be mounted). The *size* must be strictly
> + *		positive. On success, the helper makes sure that the *path* is
> + *		NUL-terminated. On failure, it is filled with zeroes.
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
>   */
> @@ -2888,7 +2897,8 @@ union bpf_attr {
>  	FN(sk_storage_delete),		\
>  	FN(send_signal),		\
>  	FN(tcp_gen_syncookie),		\
> -	FN(skb_output),
> +	FN(skb_output),			\
> +	FN(fd2path),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 933f39381039..32883cca7ea7 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile

Would be good to split out selftests into a dedicated patch.

Thanks,
Daniel
