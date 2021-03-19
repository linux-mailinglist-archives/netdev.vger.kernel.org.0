Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D269934133C
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhCSCx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhCSCxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 22:53:47 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10403C06174A;
        Thu, 18 Mar 2021 19:53:47 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id c131so4730242ybf.7;
        Thu, 18 Mar 2021 19:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sOnC4Ddk3iPilsDjgEGlh3GrkI/ytLhXl41wJKRSlhM=;
        b=kKb8gtICy33NBgsopdIcC421ERTAy5UI8WI54u0hIijoCctVvQro5fr06AK4LgRYaP
         /FIEYQeabqYE4UU98N46xeoi33hHfxncURD8ZDMhkocOlV+SOGp3gkJ+QVNhu3Iqnxzw
         /JVHcIA7ccom8+Kd5pa9mzg4TyC2cpAggbPMTPR5KI8C1DP0N2o6F8F/wPXp2LuUOoVu
         qXRlAbeVcz9dnWOZ+79ZzF89nVCYK9VQD8xO5lpHtrzAsNqteoMzLZwq8ePkSHZEkRpv
         nTrx6or4n/A7DciaIdEFqvwFn+0xLbrUNjojf/QlDxNLB5bxVgvJkfaYtZ9f++Zp8T+M
         emAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOnC4Ddk3iPilsDjgEGlh3GrkI/ytLhXl41wJKRSlhM=;
        b=dKJGzojFFa1wv9x+6eH9irZNFtOVhNl8zyrhK2ttGIfwKmg1G3LM3EogW8QpRXGblm
         XBc9kh1cOkBAFNHZ4v9SCEF3M3Uz5zxsSxuYO0qQ3SoVRFDrZMxeGkoEr/u9osPlZBmg
         mHzaCAmOvlPnggYxBZjwG6vyCSdzWn5n2rxvCY/jkNsfEQrMA/p2GssEFXba+S/8veLv
         qDlV3rqgela4NjCRR/HEdQtecUBeCv1KOvASHrTAeyBYEWfI3GAHIMEVHm6KztxKSzyC
         8Dho8ROxSE2I5EaSnZ64XVtxxjY5cyS8y3GZbQJQt/MT9OwWg+xG4nLioeubc94CyWSD
         RsvQ==
X-Gm-Message-State: AOAM533C8rXoK0J2JaRm2JppVvE81CYdMdly1rxZao1U3TowNeu84CgL
        LH17mpaK9h8lYbZI+efmlnvgo7awVThHUhaoGyI=
X-Google-Smtp-Source: ABdhPJwJk3+lUr1K23Ar7aKvLmkJoeBFvEgrfzYLHL3j60bwbeXjefeAKqmRc+H+M3rFuF5yUUMsoPpwsgPJVZUfBko=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr3307260ybc.425.1616122426069;
 Thu, 18 Mar 2021 19:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011426.4178537-1-kafai@fb.com>
In-Reply-To: <20210316011426.4178537-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 19:53:35 -0700
Message-ID: <CAEf4BzbYDKf6ahjV1HfH-ZoaWeLQb7me83AnjhF9rZ=uOzhnSQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/15] libbpf: Refactor bpf_object__resolve_ksyms_btf_id
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch refactors most of the logic from
> bpf_object__resolve_ksyms_btf_id() into a new function
> bpf_object__resolve_ksym_var_btf_id().
> It is to get ready for a later patch adding
> bpf_object__resolve_ksym_func_btf_id() which resolves
> a kernel function to the running kernel btf_id.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 125 ++++++++++++++++++++++-------------------
>  1 file changed, 68 insertions(+), 57 deletions(-)
>

[...]

> +static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> +{
> +       struct extern_desc *ext;
> +       int i, err;
> +
> +       for (i = 0; i < obj->nr_extern; i++) {
> +               ext = &obj->externs[i];
> +               if (ext->type != EXT_KSYM || !ext->ksym.type_id)
> +                       continue;
> +
> +               err = bpf_object__resolve_ksym_var_btf_id(obj, ext);
>

we usually put error checking right on the next line without empty
lines, please remove this distracting empty line


> -               ext->is_set = true;
> -               ext->ksym.kernel_btf_obj_fd = btf_fd;
> -               ext->ksym.kernel_btf_id = id;
> -               pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
> -                        ext->name, id, btf_kind_str(targ_var), targ_var_name);
> +               if (err)
> +                       return err;
>         }
>         return 0;
>  }
> --
> 2.30.2
>
