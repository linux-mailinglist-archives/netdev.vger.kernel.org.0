Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0330A6D2C0
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388031AbfGRR1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:27:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33135 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbfGRR1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:27:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id r6so23846864qtt.0;
        Thu, 18 Jul 2019 10:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDq0jlOaaqXB8MtjadL1ZALSmY3trdskBEz5Or/556U=;
        b=WHn2g0SEdhD+d/7M85HvLN7gxwEas23PTjaYDoBhGWGdlxuwotYTOreCJZHFHux7Jn
         4Tk13E3NKBK4QdxKw/mO0psEEfOoIgGJFz1jtUIOTdC3Lhp3lBpPgcgrR2UpH+jJLukr
         zy8UxAt/3t3c356p12kuBaSbz3U8025bJA8blqVG1gKmWlyif53g03Z5S3a6PTfyGb3i
         HubL4PG0i0H/tyOsKW4/RwySjSEF15uVaamm2G0L0+C/V+amG7nAhnqiQgxU9miYymOB
         fz7WdGBtxEzrWoLh/81Y90qx+p3dEg1wMh5YzKlB614KwbOO28Mo9Q8jeWbfotXuFlyG
         R88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDq0jlOaaqXB8MtjadL1ZALSmY3trdskBEz5Or/556U=;
        b=PbpJ08FNQl3KcwbA0uveL/w6CrkZprctk5Ku3usLEST5noBDY8lSA+Xzdq5x0cr3Qx
         3RrFgUr1pjYl/tGdt2BuCh2+71vZ38ETwN8dJPnxJkiwO/Ooe7y/hazyvUg5y9Kes3E2
         8JoYMyjRQkaToHVDYBN0dymAn+7yQqdbJ+9LgPy7Wj9cUzT1yyUEu4g9veMi217WM8pU
         NGJt0mrVxpmTe239Vxv7UCWK4OFwWCC7m4s657cylN4nEdS9ab5PFSyu88qbxmLK157e
         Na/nVfrsqUGCpRUsglojsahUtDtk4HHP+p0n7MxWCPlXZ4yR4gf2PwWjBbrUtpqohO7x
         RlKQ==
X-Gm-Message-State: APjAAAVfBXkmGQRkfeiukSfqM7gOqjAJl8UOI1R9cgbKeYBYna08phTx
        TkvzsC3MSEt4mkms64aPsG6UWqkA1H60NVzVo8E=
X-Google-Smtp-Source: APXvYqyg+dnFA4IHKr/EGA4IPVODmVmLSZlCb+7auZQTm545YHixAZb5uCn58q4n4uyOl4jnsJJahEWFY0NuNs5Xvnk=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr34568735qvv.38.1563470820141;
 Thu, 18 Jul 2019 10:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190718172513.2394157-1-andriin@fb.com>
In-Reply-To: <20190718172513.2394157-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jul 2019 10:26:48 -0700
Message-ID: <CAEf4BzYK0XAXPLaqTzy6S3wDgrrvAJHyEjk2OoZfbYTRJbkVVQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 10:25 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> hashmap.h depends on __WORDSIZE being defined. It is defined by
> glibc/musl in different headers. It's an explicit goal for musl to be
> "non-detectable" at compilation time, so instead include glibc header if
> glibc is explicitly detected and fall back to musl header otherwise.
>
> Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/hashmap.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index 03748a742146..46a8cb667994 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -10,7 +10,12 @@
>
>  #include <stdbool.h>
>  #include <stddef.h>
> +#ifdef __GLIBC__
> +#include <bits/wordsize.h>
> +#else
> +#include <bits/reg.h>
>  #include "libbpf_internal.h"
> +#endif

Disregard this version, #endif on the wrong line. Fixing in v2.

>
>  static inline size_t hash_bits(size_t h, int bits)
>  {
> --
> 2.17.1
>
