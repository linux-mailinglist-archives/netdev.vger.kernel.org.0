Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A370924E1DF
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHUUJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgHUUJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 16:09:21 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90037C061573;
        Fri, 21 Aug 2020 13:09:21 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a34so1656265ybj.9;
        Fri, 21 Aug 2020 13:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OlqUo3Dge1orlY+cxzOKP+C7gVBbYdp4PpHHz814e9c=;
        b=WR4wVgmu2qTjwJc5qujv7bzHaNk0RvFcGAd54SXtSEm0V8FTOyTd+Xx6KhBAAp+gZK
         YlYMtv0KuCvDcouC81zSWj0IR4D5wBBTgisW74V/8d1YBSHvYtmyqp5s9oSbRyQymBe6
         vI2GmRQ5K7AOTco6z91rD2gXcjMqSiwo76+9NyHklfdoCKJucSCl43ThmThLdpH+6TFd
         JkJtJzYxe9RPxqTSG/xNFlPHi47GMpHel0FR4wgy4xqlcX88GUMODtIn8gPSA6sjNrEf
         9k8480QOYdjY6UTss7+BfDHZCjcYWBVNCdQW63Xvy3B4V1vz4LA5UcmitUrbeFD3NfCx
         jX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OlqUo3Dge1orlY+cxzOKP+C7gVBbYdp4PpHHz814e9c=;
        b=N349eTraZ5U5etKJMdcn4SYc91lB0u9OC2ufxlOsecjiYptMMzkfeJMQJwpIQjQQSZ
         /fDsg+5tTfw8zkbhVSWQFYeU6HNsugQghr0A9eGtkp4cNFUV3VMSRPkNDYqh8ZIjD1L9
         5Yc1Ono+p1frP/Ri4JNGjvRMmQd7YxtnfwZIZbogNXKExs58LMzT7S5V51bNrjKhC4eh
         32t/Qn5HzyXr4Y5zXXgDAQQoOldsq+hduZzt++fNAcr+lERmNU5oZMy9dYQ712m8cqYP
         TwgzQjOd6CQfl11LcxDyrpNOXK6jtTAJMHTKDWvzqPWhEcdLIRO36Mm7wPONnQfZBIkB
         ZXKA==
X-Gm-Message-State: AOAM530bPDTkILUH8YWlnjsxC/21m3WH+gXRgGQEcZwk9oiL0PPV3Uj/
        uUjZ/l+jU4gQkJcBZlv9E/hhRUSaVv1tB6ZiMAk=
X-Google-Smtp-Source: ABdhPJwrk1iCzTk6KzhCz09vBXaW/eTD6J/3EojIhuAb8Ds06Sge5HXnkkZ+pNjvyW/I6/8pX3Rzl9Is0s0r0dWfTdo=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr5609943ybk.230.1598040557470;
 Fri, 21 Aug 2020 13:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200821191054.714731-1-yhs@fb.com>
In-Reply-To: <20200821191054.714731-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 13:09:06 -0700
Message-ID: <CAEf4BzYkHraBsaaApbaBAUsQfjnYJtnBU7EcNybzxqaHmSNBCg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix a buffer out-of-bound access when filling
 raw_tp link_info
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 12:11 PM Yonghong Song <yhs@fb.com> wrote:
>
> Commit f2e10bff16a0 ("bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link")
> added link query for raw_tp. One of fields in link_info is to
> fill a user buffer with tp_name. The Scurrent checking only
> declares "ulen && !ubuf" as invalid. So "!ulen && ubuf" will be
> valid. Later on, we do "copy_to_user(ubuf, tp_name, ulen - 1)" which
> may overwrite user memory incorrectly.
>
> This patch fixed the problem by disallowing "!ulen && ubuf" case as well.
>
> Fixes: f2e10bff16a0 ("bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link")
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/syscall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 86299a292214..ac6c784c0576 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2634,7 +2634,7 @@ static int bpf_raw_tp_link_fill_link_info(const struct bpf_link *link,
>         u32 ulen = info->raw_tracepoint.tp_name_len;
>         size_t tp_len = strlen(tp_name);
>
> -       if (ulen && !ubuf)
> +       if (!ulen ^ !ubuf)
>                 return -EINVAL;

I think my original idea was to allow ulen == 0 && ubuf != NULL as a
still valid way to get real ulen, but it's clearly wrong with ulen-1
below. So instead of special-casing ulen==0 for the case I wanted to
support, it's easier to disallow ulen==0 && ubuf!=NULL.

So thanks for the fix!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
>         info->raw_tracepoint.tp_name_len = tp_len + 1;
> --
> 2.24.1
>
