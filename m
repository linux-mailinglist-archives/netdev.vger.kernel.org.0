Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B73E8F86
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbfJ2Ss5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:48:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33526 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfJ2Ss5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:48:57 -0400
Received: by mail-qt1-f195.google.com with SMTP id y39so16386848qty.0;
        Tue, 29 Oct 2019 11:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WEodmOMeEny9ygdqiMPdutx+FkJbqkmU1sclkwCwk4w=;
        b=o51OCrY8DoAgX6WmDLslV1iyS3OX5KJMH/t71tl1Qgvj4dvhC6NHAohbNR/gEopfIq
         Z73Sq30X0hk9pEQ8ZelarHPwyOE2Rj1fX8/EbMEVhUXOpoo8SUqtOn6qtUsqxnP+B6Hm
         Tlzblkk4QGHnKy2ZL0dYr/MqEMug/XKz9vyhhBUY992tsfhNZoN8yXNMqRDUaMn35SKu
         R8cLqR7Vp/VR/lStjEX0TJjZkHJHnyrrwTnkqNiecrQAGIzy9lTJXXT9kqk9aP7pehJp
         a5rS57mQh9QYXskIgg9u6m5HcBK+r5j++HxbToyevYYSRCTXwu/IRBPo9PfDsZJOSHIF
         EYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WEodmOMeEny9ygdqiMPdutx+FkJbqkmU1sclkwCwk4w=;
        b=GWQWGFFFskXvx94C3TuOYUc6YSRSFvFqcNZBVrLuXCEQ+gY4uIAAe3Bvq6CT4tObXT
         SajYSBlAQj8J0sk06pBDagHIJJHakOFPA1LwInxqpFMcNnko3jm/E0iP14bLGcTxHxbU
         EFVSXmbSLehbwiFdLilSiot/QyfqnguHdya6keZFmnk/XgZRBSMIah5Kvovy1CNCoOdu
         zqTDlzgSQA32oOiVDLwB9Awog7leByHgFDePRSOqstWNyw2DHmKZP6yJOR9touotUvxp
         cMoyvhOqc1cRMbv41F/J3Sa6L9i0cMsXk2ILJZePZGAjNs4FgKsj4Vm2Hez8AAaKasp6
         rBxg==
X-Gm-Message-State: APjAAAUybZuuPqAlzXkOmFGFd9UMCgm+4/25LKpf80GOeDuVETXknw+G
        izPIv6Fwx0qIY7OuM28LBz/ASiG6HhmGCsKxX9I=
X-Google-Smtp-Source: APXvYqyKiUqMlNUZDWb62UhgBA1PgYyvvsfUiEFKLXRY4d4L7Vk35TTtwcXJP49nhuf0bt6nokQooKJcmto3kY0KFzQ=
X-Received: by 2002:ac8:4890:: with SMTP id i16mr531582qtq.141.1572374935169;
 Tue, 29 Oct 2019 11:48:55 -0700 (PDT)
MIME-Version: 1.0
References: <20191028141053.12267-1-ethercflow@gmail.com>
In-Reply-To: <20191028141053.12267-1-ethercflow@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Oct 2019 11:48:44 -0700
Message-ID: <CAEf4BzY5XfX1_Txomnz1G4PCq=E4JSPVD+_BQ7qwn8=WM_imVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: add new helper fd2path for mapping a
 file descriptor to a pathname
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 1:59 PM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> When people want to identify which file system files are being opened,
> read, and written to, they can use this helper with file descriptor as
> input to achieve this goal. Other pseudo filesystems are also supported.
>
> This requirement is mainly discussed here:
>
>   https://github.com/iovisor/bcc/issues/237
>
> v3->v4:
> - fix missing fdput()
> - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> - move fd2path's test code to another patch
>
> v2->v3:
> - remove unnecessary LOCKDOWN_BPF_READ
> - refactor error handling section for enhanced readability
> - provide a test case in tools/testing/selftests/bpf
>
> v1->v2:
> - fix backward compatibility
> - add this helper description
> - fix signed-off name
>
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> ---
>  include/uapi/linux/bpf.h       | 14 +++++++++++-
>  kernel/trace/bpf_trace.c       | 40 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 14 +++++++++++-
>  3 files changed, 66 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4af8b0819a32..124632b2a697 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2775,6 +2775,17 @@ union bpf_attr {
>   *             restricted to raw_tracepoint bpf programs.
>   *     Return
>   *             0 on success, or a negative error in case of failure.
> + *
> + * int bpf_fd2path(char *path, u32 size, int fd)

from what I can see, we don't have any BPF helper with this naming
approach(2 -> to, 4 -> for, etc). How about something like
bpf_get_file_path?

> + *     Description
> + *             Get **file** atrribute from the current task by *fd*, then call
> + *             **d_path** to get it's absolute path and copy it as string into
> + *             *path* of *size*. The **path** also support pseudo filesystems
> + *             (whether or not it can be mounted). The *size* must be strictly
> + *             positive. On success, the helper makes sure that the *path* is
> + *             NUL-terminated. On failure, it is filled with zeroes.
> + *     Return
> + *             0 on success, or a negative error in case of failure.

Mention that we actually return a positive number on success, which is
a size of the string + 1 for NUL byte (the +1 is not true right now,
but I think should be).

>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2888,7 +2899,8 @@ union bpf_attr {
>         FN(sk_storage_delete),          \
>         FN(send_signal),                \
>         FN(tcp_gen_syncookie),          \
> -       FN(skb_output),
> +       FN(skb_output),                 \
> +       FN(fd2path),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 571c25d60710..dd7b070df3d6 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -683,6 +683,44 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
>         .arg1_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
> +{
> +       struct fd f;
> +       char *p;
> +       int ret = -EINVAL;
> +
> +       /* Use fdget_raw instead of fdget to support O_PATH */
> +       f = fdget_raw(fd);

I haven't followed previous discussions, so sorry if this was asked
before. Can either fdget_raw or d_path sleep? Also, d_path seems to be
relying on current, which in the interrupt context might not be what
you really want. Have you considered these problems?

> +       if (!f.file)
> +               goto error;
> +
> +       p = d_path(&f.file->f_path, dst, size);
> +       if (IS_ERR_OR_NULL(p)) {
> +               ret = PTR_ERR(p);

if p can really be NULL, you'd get ret == 0 here, which is probably
not what you want.
But reading d_path, it seems like it's either valid pointer or error,
so just use IS_ERR above?

> +               goto error;
> +       }
> +
> +       ret = strlen(p);
> +       memmove(dst, p, ret);
> +       dst[ret] = '\0';

I think returning number of useful bytes (including terminating NUL)
is good and follows bpf_probe_read_str() convention. So ret++ here?

> +       goto end;
> +
> +error:
> +       memset(dst, '0', size);
> +end:
> +       fdput(f);
> +       return ret;
> +}
> +

[...]
