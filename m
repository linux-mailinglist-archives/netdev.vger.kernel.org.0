Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD50FDE64
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfKOMxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:53:10 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:40695 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfKOMxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:53:09 -0500
Received: by mail-ua1-f68.google.com with SMTP id i13so2957753uaq.7;
        Fri, 15 Nov 2019 04:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZMT8IrgK+lbCmgSGK3+j2RAMG/ZH85GtxQLUmaW4PZo=;
        b=ecl7dWoAuNjjda2FPvRzt8oLYXbORo8x9e1lFncy324/cQzOq77ApuJBWry+3qfzo6
         SvuiQTO8yTA5mfvAjEmMidBn5+T6lIfy3zORjc73FKHeRGhSAgdR5MeJG1LI1p3XP7LQ
         dd3TqLelK8Y60AdbIHDCfC8pT1+cTcZCbxQVP3ZFMH7+wJm3Y9X/PQgTBHrVLfBPw61u
         NwBA5j+fHT4qfht/rV1AvZQInd0ssoHgWruceM0d4qvcjnEE0w3cZQdSsP+OnMlUh1oQ
         rl913ZXpo1/iTv1awdSv58dR3L7Z6OG1AOEOhFXs3Po/APviuzn7uKIHTrjLMp0J3at1
         XhZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZMT8IrgK+lbCmgSGK3+j2RAMG/ZH85GtxQLUmaW4PZo=;
        b=JnyqGEUagbIue3ZqWdSPXtAYVTfoS2eyEFoVTSUfyWgRQdOi29Z2s5gYRDlcEbyEG0
         ivrYV9lq/UxUjgynx08jrpJpPf0ODHohw3owMrJFEid+ypamONq2uwVuRrdDCKGAVhvV
         OcDqTFGYErduFkPx8zawQo08Z4/fsBUfkvxFxaZwyTcHyEckXb7DVU1B09o6hmy+raJb
         4Xj/a6sz+sdGihAfLJ0gOUrNJ1+J/yEeCyN4qbO5utuOTfnssBqpR5WrOKV/+iRDVZaP
         adQ4o2KZRVeT7GUKOagH8ixiKA/hQnzhbCnEDcBCHKq7gMZKFjlq/E3hdqk/XrSyTVHk
         wlGA==
X-Gm-Message-State: APjAAAVvsi9hp5iK4ktxBW/8mi4IGSfAQs6aZExwLWpUvoLYb2DYGWU8
        6QMdUHANbGpLmUv4STNF43vNHM9ix5l5pbV0LgWflJMDrTo=
X-Google-Smtp-Source: APXvYqyJia/uLgHPT7ksQQDvf6OlzxSgrx6ssXp8gHABnSpaDpxuiODXCUmGAbtlb7f2IZhe0vSNUOWJqGeny6tnMNc=
X-Received: by 2002:ab0:738f:: with SMTP id l15mr3994772uap.57.1573822386378;
 Fri, 15 Nov 2019 04:53:06 -0800 (PST)
MIME-Version: 1.0
References: <20191115124846.38766-1-ethercflow@gmail.com>
In-Reply-To: <20191115124846.38766-1-ethercflow@gmail.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Fri, 15 Nov 2019 20:52:54 +0800
Message-ID: <CABtjQmao44Cy=_FdujwqzHcpX58_cgSgxQrWv2sYxKQjT=5K7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9] bpf: add new helper get_file_path for mapping
 a file descriptor to a pathname
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Alexei's latest comment:

>  This is definitely very useful helper that bpf tracing community has
>  been asking for long time, but I have few concerns with implementation:
> - fdget_raw is only used inside fs/, so it doesn't look right to skip the=
 layers.
> - accessing current->fs is not always correct, so the code should somehow
>   check that it's ok to do so, but I'm not sure if (in_irq()) would be en=
ough.
> - some implementations of d_dname do sleep.  For example: dmabuffs_dname.
>   Though it seems to me that it's a bug in that particular FS. But I'd li=
ke
>   to hear clear yes from VFS experts that fdget_raw() + d_path() is ok
>   from preempt_disabled section.

> The other alternative is to wait for sleepable and preemptible BPF progra=
ms to
> appear. Which is probably a month or so away. Then all these issues will
> disappear.

After consulting Yonghong, I made this patch to try to solve these issues:

> - fdget_raw is only used inside fs/, so it doesn't look right to skip the=
 layers.
As Yonghong's suggest, I use fget_raw instead as fget_raw has been
used outside fs/
(kernel/cgroup/cgroup.c, net/core/scm.c)

> - accessing current->fs is not always correct, so the code should somehow
>   check that it's ok to do so, but I'm not sure if (in_irq()) would be en=
ough.

In addition to checking irq, we also did the following checks

if (unlikely(in_interrupt() ||
                     current->flags & (PF_KTHREAD | PF_EXITING)))
                return -EPERM;

Similar to bpf_probe_write_user

> - some implementations of d_dname do sleep.  For example: dmabuffs_dname.
>   Though it seems to me that it's a bug in that particular FS. But I'd li=
ke
>   to hear clear yes from VFS experts that fdget_raw() + d_path() is ok
>   from preempt_disabled section.

For unmountable pseudo filesystem, it seems to have no meaning to get their=
 fake
paths as they don't have path, and to be no way to validate this
function pointer can
be always safe to call in the current context.

So I add judge before d_path

        if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname)
                return -EINVAL;

On the other hand, if some people's use case consider unmountable
pseudo files, I'll
remove this judge and wait for sleepable and preemptible BPF programs

Other than these,  I added a more detailed description for this
helper=EF=BC=8Cabout the return buffer's
content and error code.

 * int bpf_get_file_path(char *path, u32 size, int fd)
 *      Description
 *              Get **file** atrribute from the current task by *fd*, then =
call
 *              **d_path** to get it's absolute path and copy it as string =
into
 *              *path* of *size*. Notice the **path** don't support unmount=
able
 *              pseudo filesystems as they don't have path (eg: SOCKFS, PIP=
EFS).
 *              The *size* must be strictly positive. On success, the helpe=
r
 *              makes sure that the *path* is NUL-terminated, and the buffe=
r
 *              could be:
 *              - a regular full path (include mountable fs eg: /proc, /sys=
)
 *              - a regular full path with "(deleted)" at the end.
 *              On failure, it is filled with zeroes.
 *      Return
 *              On success, returns the length of the copied string INCLUDI=
NG
 *              the trailing NUL.
 *
 *              On failure, the returned value is one of the following:
 *
 *              **-EPERM** if no permission to get the path (eg: in irq ctx=
).
 *
 *              **-EBADF** if *fd* is invalid.
 *
 *              **-EINVAL** if *fd* corresponds to a unmountable pseudo fs
 *
 *              **-ENAMETOOLONG** if full path is longer than *size*

Thank you.

Wenbo Zhang <ethercflow@gmail.com> =E4=BA=8E2019=E5=B9=B411=E6=9C=8815=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=888:48=E5=86=99=E9=81=93=EF=BC=9A
>
> When people want to identify which file system files are being opened,
> read, and written to, they can use this helper with file descriptor as
> input to achieve this goal. Other pseudo filesystems are also supported.
>
> This requirement is mainly discussed here:
>
>   https://github.com/iovisor/bcc/issues/237
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
>  include/uapi/linux/bpf.h       | 29 +++++++++++++++-
>  kernel/trace/bpf_trace.c       | 63 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 28 ++++++++++++++-
>  3 files changed, 118 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index df6809a76404..71832cd3729c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2815,6 +2815,32 @@ union bpf_attr {
>   *     Return
>   *             On success, the strictly positive length of the string, i=
ncluding
>   *             the trailing NUL character. On error, a negative value.
> + *
> + * int bpf_get_file_path(char *path, u32 size, int fd)
> + *     Description
> + *             Get **file** atrribute from the current task by *fd*, the=
n call
> + *             **d_path** to get it's absolute path and copy it as strin=
g into
> + *             *path* of *size*. Notice the **path** don't support unmou=
ntable
> + *             pseudo filesystems as they don't have path (eg: SOCKFS, P=
IPEFS).
> + *             The *size* must be strictly positive. On success, the hel=
per
> + *             makes sure that the *path* is NUL-terminated, and the buf=
fer
> + *             could be:
> + *             - a regular full path (include mountable fs eg: /proc, /s=
ys)
> + *             - a regular full path with "(deleted)" at the end.
> + *             On failure, it is filled with zeroes.
> + *     Return
> + *             On success, returns the length of the copied string INCLU=
DING
> + *             the trailing NUL.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EPERM** if no permission to get the path (eg: in irq c=
tx).
> + *
> + *             **-EBADF** if *fd* is invalid.
> + *
> + *             **-EINVAL** if *fd* corresponds to a unmountable pseudo f=
s
> + *
> + *             **-ENAMETOOLONG** if full path is longer than *size*
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2932,7 +2958,8 @@ union bpf_attr {
>         FN(probe_read_user),            \
>         FN(probe_read_kernel),          \
>         FN(probe_read_user_str),        \
> -       FN(probe_read_kernel_str),
> +       FN(probe_read_kernel_str),      \
> +       FN(get_file_path),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index ffc91d4935ac..c77e55418f1e 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -762,6 +762,67 @@ static const struct bpf_func_proto bpf_send_signal_p=
roto =3D {
>         .arg1_type      =3D ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> +{
> +       struct file *f;
> +       char *p;
> +       int ret =3D -EBADF;
> +
> +       /* Ensure we're in user context which is safe for the helper to
> +        * run. This helper has no business in a kthread.
> +        */
> +       if (unlikely(in_interrupt() ||
> +                    current->flags & (PF_KTHREAD | PF_EXITING)))
> +               return -EPERM;
> +
> +       /* Use fget_raw instead of fget to support O_PATH, and it doesn't
> +        * have any sleepable code, so it's ok to be here.
> +        */
> +       f =3D fget_raw(fd);
> +       if (!f)
> +               goto error;
> +
> +       /* For unmountable pseudo filesystem, it seems to have no meaning
> +        * to get their fake paths as they don't have path, and to be no
> +        * way to validate this function pointer can be always safe to ca=
ll
> +        * in the current context.
> +        */
> +       if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname)
> +               return -EINVAL;
> +
> +       /* After filter unmountable pseudo filesytem, d_path won't call
> +        * dentry->d_op->d_name(), the normally path doesn't have any
> +        * sleepable code, and despite it uses the current macro to get
> +        * fs_struct (current->fs), we've already ensured we're in user
> +        * context, so it's ok to be here.
> +        */
> +       p =3D d_path(&f->f_path, dst, size);
> +       if (IS_ERR(p)) {
> +               ret =3D PTR_ERR(p);
> +               fput(f);
> +               goto error;
> +       }
> +
> +       ret =3D strlen(p);
> +       memmove(dst, p, ret);
> +       dst[ret++] =3D '\0';
> +       fput(f);
> +       return ret;
> +
> +error:
> +       memset(dst, '0', size);
> +       return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_get_file_path_proto =3D {
> +       .func       =3D bpf_get_file_path,
> +       .gpl_only   =3D true,
> +       .ret_type   =3D RET_INTEGER,
> +       .arg1_type  =3D ARG_PTR_TO_UNINIT_MEM,
> +       .arg2_type  =3D ARG_CONST_SIZE,
> +       .arg3_type  =3D ARG_ANYTHING,
> +};
> +
>  static const struct bpf_func_proto *
>  tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog=
)
>  {
> @@ -822,6 +883,8 @@ tracing_func_proto(enum bpf_func_id func_id, const st=
ruct bpf_prog *prog)
>  #endif
>         case BPF_FUNC_send_signal:
>                 return &bpf_send_signal_proto;
> +       case BPF_FUNC_get_file_path:
> +               return &bpf_get_file_path_proto;
>         default:
>                 return NULL;
>         }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index df6809a76404..afe98857fa04 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -2815,6 +2815,31 @@ union bpf_attr {
>   *     Return
>   *             On success, the strictly positive length of the string, i=
ncluding
>   *             the trailing NUL character. On error, a negative value.
> + * int bpf_get_file_path(char *path, u32 size, int fd)
> + *     Description
> + *             Get **file** atrribute from the current task by *fd*, the=
n call
> + *             **d_path** to get it's absolute path and copy it as strin=
g into
> + *             *path* of *size*. Notice the **path** don't support unmou=
ntable
> + *             pseudo filesystems as they don't have path (eg: SOCKFS, P=
IPEFS).
> + *             The *size* must be strictly positive. On success, the hel=
per
> + *             makes sure that the *path* is NUL-terminated, and the buf=
fer
> + *             could be:
> + *             - a regular full path (include mountable fs eg: /proc, /s=
ys)
> + *             - a regular full path with "(deleted)" at the end.
> + *             On failure, it is filled with zeroes.
> + *     Return
> + *             On success, returns the length of the copied string INCLU=
DING
> + *             the trailing NUL.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EPERM** if no permission to get the path (eg: in irq c=
tx).
> + *
> + *             **-EBADF** if *fd* is invalid.
> + *
> + *             **-EINVAL** if *fd* corresponds to a unmountable pseudo f=
s
> + *
> + *             **-ENAMETOOLONG** if full path is longer than *size*
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2932,7 +2957,8 @@ union bpf_attr {
>         FN(probe_read_user),            \
>         FN(probe_read_kernel),          \
>         FN(probe_read_user_str),        \
> -       FN(probe_read_kernel_str),
> +       FN(probe_read_kernel_str),      \
> +       FN(get_file_path),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
>   * function eBPF program intends to call
> --
> 2.17.1
>
