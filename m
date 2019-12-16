Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB98121C72
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfLPWJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:09:50 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41865 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfLPWJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 17:09:49 -0500
Received: by mail-qk1-f195.google.com with SMTP id u5so5880604qkf.8
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 14:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WoFu+iw/55dn3p0jLH3GcsdFKLdi2t+cDVe8vvyci7A=;
        b=S70Jlw5s8aHsDb+HD2Yo+RCU3JGy2nLRgVo1V6QhQzIR7b7rHC537Q+aqXywF7iXGR
         vliJXdIpvpC4U1N4+a58V98D/pDrGUHQ4yUSnUyubffqGKuz+Ti4+3Qa6gBb43mAyrJy
         zfPWmOiPCWPWpbiTFcpCXvK/DKrC0EFmoVikI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WoFu+iw/55dn3p0jLH3GcsdFKLdi2t+cDVe8vvyci7A=;
        b=TlqEBOsqo+XhEVk+UeXujPkb4/pHBqiukFrCCQRjLDnoTaZy1z5lezVE13QCPQODVQ
         hc7DjIWEhqQXtJlZUSKuQPHtWbcmQZ+QJ0T8lFcgkptfxXmb1FHwcjIsc0B6isNcnwgv
         o1ywZP64ncryH5dIS+7YKufhF1/Dp0a4Eg6VrAVart4/Fo+crbmnoQk3+46tNCcFU1cs
         3i4BuQDJQxyJPUPsu7p2PObvi1mi6h55EZoRVaOn0hCVZawuEqqXEBYroBrLY6SY5TIv
         o17SNf1pfdwsxfTdP8rwuC14UrIqwAcoGJL/ahgqfBfU8H7oktyuVi8Xomh6R9P6J3tr
         eSMg==
X-Gm-Message-State: APjAAAW4oMyvkKcCswEvBMLKMi1VeeZI7L9vFj58slxgUeF9Mk6GPzEk
        O/oA3mDV1XtUEd6bry+8AT0mzFVTliBS15srOklAYQ==
X-Google-Smtp-Source: APXvYqxZLlAX3hTnSdUpfiqgz3qD7M0Sa3PkORjuRvlAUs1wlPXB91vOPAJqIB7V47rG/reFPaSzmAzXinWlP2yaHHM=
X-Received: by 2002:a05:620a:b0f:: with SMTP id t15mr1710176qkg.135.1576534188249;
 Mon, 16 Dec 2019 14:09:48 -0800 (PST)
MIME-Version: 1.0
References: <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
 <cover.1576381511.git.ethercflow@gmail.com> <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
In-Reply-To: <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
From:   Brendan Gregg <bgregg@netflix.com>
Date:   Mon, 16 Dec 2019 14:09:22 -0800
Message-ID: <CAJN39ohooPboU_ydys8rPbfwCEZabw3bLBGBnfz2EmJ6P8PGmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 8:01 PM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> When people want to identify which file system files are being opened,
> read, and written to, they can use this helper with file descriptor as
> input to achieve this goal. Other pseudo filesystems are also supported.
>
> This requirement is mainly discussed here:
>
>   https://github.com/iovisor/bcc/issues/237
>
> v11->v12: addressed Alexei's feedback
> - only allow tracepoints to make sure it won't dead lock
>
> v10->v11: addressed Al and Alexei's feedback
> - fix missing fput()
>
> v9->v10: addressed Andrii's feedback
> - send this patch together with the patch selftests as one patch series
>
> v8->v9:
> - format helper description
>
> v7->v8: addressed Alexei's feedback
> - use fget_raw instead of fdget_raw, as fdget_raw is only used inside fs/
> - ensure we're in user context which is safe fot the help to run
> - filter unmountable pseudo filesystem, because they don't have real path
> - supplement the description of this helper function
>
> v6->v7:
> - fix missing signed-off-by line
>
> v5->v6: addressed Andrii's feedback
> - avoid unnecessary goto end by having two explicit returns
>
> v4->v5: addressed Andrii and Daniel's feedback
> - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> helper's names
> - when fdget_raw fails, set ret to -EBADF instead of -EINVAL
> - remove fdput from fdget_raw's error path
> - use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
> into the buffer or an error code if the path was too long
> - modify the normal path's return value to return copied string length
> including NUL
> - update this helper description's Return bits.
>
> v3->v4: addressed Daniel's feedback
> - fix missing fdput()
> - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> - move fd2path's test code to another patch
> - add comment to explain why use fdget_raw instead of fdget
>
> v2->v3: addressed Yonghong's feedback
> - remove unnecessary LOCKDOWN_BPF_READ
> - refactor error handling section for enhanced readability
> - provide a test case in tools/testing/selftests/bpf
>
> v1->v2: addressed Daniel's feedback
> - fix backward compatibility
> - add this helper description
> - fix signed-off name
>
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> ---
>  include/uapi/linux/bpf.h       | 29 +++++++++++++-
>  kernel/trace/bpf_trace.c       | 70 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 29 +++++++++++++-
>  3 files changed, 126 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index dbbcf0b02970..71d9705df120 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2821,6 +2821,32 @@ union bpf_attr {
>   *     Return
>   *             On success, the strictly positive length of the string, including
>   *             the trailing NUL character. On error, a negative value.
> + *
> + * int bpf_get_file_path(char *path, u32 size, int fd)
> + *     Description
> + *             Get **file** atrribute from the current task by *fd*, then call
> + *             **d_path** to get it's absolute path and copy it as string into
> + *             *path* of *size*. Notice the **path** don't support unmountable
> + *             pseudo filesystems as they don't have path (eg: SOCKFS, PIPEFS).
> + *             The *size* must be strictly positive. On success, the helper
> + *             makes sure that the *path* is NUL-terminated, and the buffer
> + *             could be:
> + *             - a regular full path (include mountable fs eg: /proc, /sys)
> + *             - a regular full path with "(deleted)" at the end.
> + *             On failure, it is filled with zeroes.
> + *     Return
> + *             On success, returns the length of the copied string INCLUDING
> + *             the trailing NUL.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EPERM** if no permission to get the path (eg: in irq ctx).
> + *
> + *             **-EBADF** if *fd* is invalid.
> + *
> + *             **-EINVAL** if *fd* corresponds to a unmountable pseudo fs
> + *
> + *             **-ENAMETOOLONG** if full path is longer than *size*
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2938,7 +2964,8 @@ union bpf_attr {
>         FN(probe_read_user),            \
>         FN(probe_read_kernel),          \
>         FN(probe_read_user_str),        \
> -       FN(probe_read_kernel_str),
> +       FN(probe_read_kernel_str),      \
> +       FN(get_file_path),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index e5ef4ae9edb5..db9c0ec46a5d 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -762,6 +762,72 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
>         .arg1_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> +{
> +       struct file *f;
> +       char *p;
> +       int ret = -EBADF;
> +
> +       /* Ensure we're in user context which is safe for the helper to
> +        * run. This helper has no business in a kthread.
> +        */
> +       if (unlikely(in_interrupt() ||
> +                    current->flags & (PF_KTHREAD | PF_EXITING))) {
> +               ret = -EPERM;
> +               goto error;
> +       }
> +
> +       /* Use fget_raw instead of fget to support O_PATH, and it doesn't
> +        * have any sleepable code, so it's ok to be here.
> +        */
> +       f = fget_raw(fd);
> +       if (!f)
> +               goto error;
> +
> +       /* For unmountable pseudo filesystem, it seems to have no meaning
> +        * to get their fake paths as they don't have path, and to be no
> +        * way to validate this function pointer can be always safe to call
> +        * in the current context.
> +        */
> +       if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) {
> +               ret = -EINVAL;
> +               fput(f);
> +               goto error;
> +       }
> +
> +       /* After filter unmountable pseudo filesytem, d_path won't call
> +        * dentry->d_op->d_name(), the normally path doesn't have any
> +        * sleepable code, and despite it uses the current macro to get
> +        * fs_struct (current->fs), we've already ensured we're in user
> +        * context, so it's ok to be here.
> +        */
> +       p = d_path(&f->f_path, dst, size);
> +       if (IS_ERR(p)) {
> +               ret = PTR_ERR(p);
> +               fput(f);
> +               goto error;
> +       }
> +
> +       ret = strlen(p);
> +       memmove(dst, p, ret);
> +       dst[ret++] = '\0';
> +       fput(f);
> +       return ret;
> +
> +error:
> +       memset(dst, '0', size);
> +       return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_get_file_path_proto = {
> +       .func       = bpf_get_file_path,
> +       .gpl_only   = true,
> +       .ret_type   = RET_INTEGER,
> +       .arg1_type  = ARG_PTR_TO_UNINIT_MEM,
> +       .arg2_type  = ARG_CONST_SIZE,
> +       .arg3_type  = ARG_ANYTHING,
> +};
> +
>  static const struct bpf_func_proto *
>  tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> @@ -953,6 +1019,8 @@ tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_get_stackid_proto_tp;
>         case BPF_FUNC_get_stack:
>                 return &bpf_get_stack_proto_tp;
> +       case BPF_FUNC_get_file_path:
> +               return &bpf_get_file_path_proto;
>         default:
>                 return tracing_func_proto(func_id, prog);
>         }
> @@ -1146,6 +1214,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_get_stackid_proto_raw_tp;
>         case BPF_FUNC_get_stack:
>                 return &bpf_get_stack_proto_raw_tp;
> +       case BPF_FUNC_get_file_path:
> +               return &bpf_get_file_path_proto;
>         default:
>                 return tracing_func_proto(func_id, prog);
>         }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index dbbcf0b02970..71d9705df120 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -2821,6 +2821,32 @@ union bpf_attr {
>   *     Return
>   *             On success, the strictly positive length of the string, including
>   *             the trailing NUL character. On error, a negative value.
> + *
> + * int bpf_get_file_path(char *path, u32 size, int fd)
> + *     Description
> + *             Get **file** atrribute from the current task by *fd*, then call
> + *             **d_path** to get it's absolute path and copy it as string into
> + *             *path* of *size*. Notice the **path** don't support unmountable
> + *             pseudo filesystems as they don't have path (eg: SOCKFS, PIPEFS).
> + *             The *size* must be strictly positive. On success, the helper
> + *             makes sure that the *path* is NUL-terminated, and the buffer
> + *             could be:
> + *             - a regular full path (include mountable fs eg: /proc, /sys)
> + *             - a regular full path with "(deleted)" at the end.
> + *             On failure, it is filled with zeroes.
> + *     Return
> + *             On success, returns the length of the copied string INCLUDING
> + *             the trailing NUL.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EPERM** if no permission to get the path (eg: in irq ctx).
> + *
> + *             **-EBADF** if *fd* is invalid.
> + *
> + *             **-EINVAL** if *fd* corresponds to a unmountable pseudo fs
> + *
> + *             **-ENAMETOOLONG** if full path is longer than *size*
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2938,7 +2964,8 @@ union bpf_attr {
>         FN(probe_read_user),            \
>         FN(probe_read_kernel),          \
>         FN(probe_read_user_str),        \
> -       FN(probe_read_kernel_str),
> +       FN(probe_read_kernel_str),      \
> +       FN(get_file_path),


I just realized that among my tools that want the path, the input is either:

A) syscall tracepoints: int fd
B) kprobes: struct file *

This serves (A). If we ever add a different helper for (B), we might
think that this helper was misnamed. Should it be called get_fd_path
instead? That leaves get_file_path available for a later "struct file
*" -> pathname helper.

Brendan

-- 
Brendan Gregg, Senior Performance Architect, Netflix
