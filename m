Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79847E562A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfJYVxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:53:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33952 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYVxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:53:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id e14so5550590qto.1;
        Fri, 25 Oct 2019 14:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knNmyzgenjCtHaLe2L9fLzRzUUoNvAmF7VPjiqMDdwo=;
        b=d8z4LnRIlYYrw2omzpxTMIT0LRNCehzf1c99bA9TCM1Z11Gz1P6Gum9DQLhqvegRH3
         5rxvFEK3gI2h84VdVOkhiNP0E9+hDR/phSe1MiADTt4qaJet+kMnFsIakmLQeDPyIM0p
         L7sB3NFzQqKpZ14eT54StGv54Oer/VeXvg8x1UmB3CJ7yFDo/4wumLisWTtIwtNv/4LV
         c+iGFmdhufy85BSQy748axdhGTaBFXiqJ4gRXMJTMZRYKQsYECEw0Uajio9FqhvVNH/Y
         XQJsviZDz8a7SPfxeVrTR6yOWer8fjsdcG5AMWS9tEvcGrBPA/3poSCIpxnDHKUB9zwX
         WUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knNmyzgenjCtHaLe2L9fLzRzUUoNvAmF7VPjiqMDdwo=;
        b=URxrhN8LJmtuNr7NftdkdRMaVUN9dTRiVf0ucBo3Jj2DEbFcfvkQr5KSQ2pX0IXoEL
         EbVZ31Ix9VYvuzcVREBAQmqIO8c84HKOv6QJhqv1DWgA92qkTZSp6p2lSGAv4kcJEW4s
         876DMnvVvtk0q0dhdHMt3czquKHxa5nV7JyOUW7FUmz628M3YvvDhEZ3wQOspJwwHp1+
         +pOx88diGmNxpQ4yF0aVdVQEYvBKXVhg94bRKXuhaP3qS9oenf3JcUMgigzAeJoarszG
         cNicD5Y/BkDlcDRUgiZS2XqEQEnQvEQuhiU6CZCNyge3uRbnEftA6P/Bn+SUBwMyUU43
         8XJQ==
X-Gm-Message-State: APjAAAUE+DgkNfnkC9CSsrLLCSusH9nTmwjSP5/VYW84NHMzWx8Jy3/d
        aFg44rHvnDiKkbN3FkCSSQDcLUvfFwq5vCEKQqMv/nww
X-Google-Smtp-Source: APXvYqx57aEGpEOOpy8pwCyf2KtxfRQ69VP99y8xEk6oBB4hWeD6HR+ZOO5qZL++VLHrDWvU1G1u7Ymrk4FJbmh0KCE=
X-Received: by 2002:ad4:4e4a:: with SMTP id eb10mr4344615qvb.228.1572040397992;
 Fri, 25 Oct 2019 14:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <8e63f4005c7139d88c5c78e2a19f539b2a1ff988.1572010897.git.daniel@iogearbox.net>
In-Reply-To: <8e63f4005c7139d88c5c78e2a19f539b2a1ff988.1572010897.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 14:53:07 -0700
Message-ID: <CAEf4BzbTKeBabyb3C3Yj5iT8TQC7A7SeUAe=PafaKnqeA4zoVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] uaccess: Add non-pagefault user-space write function
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Commit 3d7081822f7f ("uaccess: Add non-pagefault user-space read functions")
> missed to add probe write function, therefore factor out a probe_write_common()
> helper with most logic of probe_kernel_write() except setting KERNEL_DS, and
> add a new probe_user_write() helper so it can be used from BPF side.
>
> Again, on some archs, the user address space and kernel address space can
> co-exist and be overlapping, so in such case, setting KERNEL_DS would mean
> that the given address is treated as being in kernel address space.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM. See an EFAULT comment below, though.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/uaccess.h | 12 +++++++++++
>  mm/maccess.c            | 45 +++++++++++++++++++++++++++++++++++++----
>  2 files changed, 53 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index e47d0522a1f4..86dcf2894672 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -337,6 +337,18 @@ extern long __probe_user_read(void *dst, const void __user *src, size_t size);
>  extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
>  extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
>
> +/*
> + * probe_user_write(): safely attempt to write to a location in user space
> + * @dst: address to write to
> + * @src: pointer to the data that shall be written
> + * @size: size of the data chunk
> + *
> + * Safely write to address @dst from the buffer at @src.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
> +extern long notrace __probe_user_write(void __user *dst, const void *src, size_t size);
> +
>  extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
>  extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
>                                      long count);
> diff --git a/mm/maccess.c b/mm/maccess.c
> index d065736f6b87..2d3c3d01064c 100644
> --- a/mm/maccess.c

[...]

>
> +/**
> + * probe_user_write(): safely attempt to write to a user-space location
> + * @dst: address to write to
> + * @src: pointer to the data that shall be written
> + * @size: size of the data chunk
> + *
> + * Safely write to address @dst from the buffer at @src.  If a kernel fault
> + * happens, handle that and return -EFAULT.
> + */
> +
> +long __weak probe_user_write(void __user *dst, const void *src, size_t size)
> +    __attribute__((alias("__probe_user_write")));

curious, why is there this dance of probe_user_write alias to
__probe_user_write (and for other pairs of functions as well)?

> +
> +long __probe_user_write(void __user *dst, const void *src, size_t size)
> +{
> +       long ret = -EFAULT;

This initialization is not necessary, is it? Similarly in
__probe_user_read higher in this file.

> +       mm_segment_t old_fs = get_fs();
> +
> +       set_fs(USER_DS);
> +       if (access_ok(dst, size))
> +               ret = probe_write_common(dst, src, size);
> +       set_fs(old_fs);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(probe_user_write);
>
>  /**
>   * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
> --
> 2.21.0
>
