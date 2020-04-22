Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAF51B4505
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgDVMZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:25:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25983 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgDVMZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 08:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587558313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7GLv1hieY2g43mu5e5ZPwxyvQVnuP6zBSuRRINMS6FU=;
        b=IKBN1Szp14NrBc8CUnU9wJXwQ6QKAcGTuFk1yJQxPmCh09CGwiRT6H52+fK6JDdF4O2P9j
        L3Iqm7hI0XUrH4OFCi159gx8FO84OO41/jDtDWMz+6eaoMfy2yF5udyJCaIvgISU4E5Nzk
        KEsDpeVd5cEQuHio5LcdckZaiRn7aMs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270--ML2WBnjM7KQV9vVhUTT8g-1; Wed, 22 Apr 2020 08:25:11 -0400
X-MC-Unique: -ML2WBnjM7KQV9vVhUTT8g-1
Received: by mail-ej1-f72.google.com with SMTP id c9so982665ejr.16
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7GLv1hieY2g43mu5e5ZPwxyvQVnuP6zBSuRRINMS6FU=;
        b=SNcmotjW5KpPWVn4E0JhOMLr1p58rQR79Db0WaTpPEsUWRMAWZdDym9rgH89GWNSwu
         u4Tq38xH1/6+MMT7XUyfD5c4Blha8iTwktbYBtlP6KWTuc04Ma7+mUR4qwo7GR0U0xOa
         DvNpIP4pTa9rrhHwXz5unpmDhkP7RO8tVM8MItG2ZQsnSBtblCdroXsefZedUqrCjKvo
         p/NpD5ozWnrzo8QyXtNfn+v8cQhN52sd/MsPBN4dXSAyaKkDWQicBEuG2ghtBLvv2PjL
         z7gFpeg11CDLo/jMUw05p4e62Gfq89JoIe5w3v7R0vTefqALqrTZvXquxuPBJgQD3rSE
         d8wQ==
X-Gm-Message-State: AGi0PuYJlS8n1nuIrc1OeyN7DtXk9PtDo/m1kvx0+RlBa4X3w0Gbg2w+
        GW5AN0KsAcJUyozQU6UVxuxDrd5GgcG/UH/9t3JUOq3e74tkPX7F9hcnajcMS1rBvwAuiSvxH8L
        hXUuhfK9+9Ar0CQMldYAZ0hfb/S7HkuZ6
X-Received: by 2002:a50:bf4d:: with SMTP id g13mr22343573edk.381.1587558310365;
        Wed, 22 Apr 2020 05:25:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypJMZHyHhl/MKcaaiPQp56vuPo3AGjE4wipOhlWjouArq3pprboDIKm/iSaYP4ly8nSl+YoSfyxuZS+OnuLclyc=
X-Received: by 2002:a50:bf4d:: with SMTP id g13mr22343561edk.381.1587558310163;
 Wed, 22 Apr 2020 05:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200422102808.9197-1-jhs@emojatatu.com> <20200422102808.9197-2-jhs@emojatatu.com>
In-Reply-To: <20200422102808.9197-2-jhs@emojatatu.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Wed, 22 Apr 2020 14:24:59 +0200
Message-ID: <CAPpH65zpv6xD08KK-Gjwx4LxNsViu6Jy2DXgQ+inUodoE5Uhgw@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning is used
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, daniel@iogearbox.net,
        asmadeus@codewreck.org, Jamal Hadi Salim <hadi@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 12:28 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> From: Jamal Hadi Salim <hadi@mojatatu.com>
>
> Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")
>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  lib/bpf.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 10cf9bf4..656cad02 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -1509,15 +1509,15 @@ out:
>  static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>                                 const char *todo)
>  {
> -       char *tmp = NULL;
> +       char tmp[PATH_MAX] = {};
>         char *rem = NULL;
>         char *sub;
>         int ret;
>
> -       ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
> +       ret = snprintf(tmp, PATH_MAX, "%s/../", bpf_get_work_dir(ctx->type));

Shouldn't we check for the last argument length before? We should have
enough space for "/../" and the terminator, so we need the last
argument length to be less than PATH_MAX-5, right?


>         if (ret < 0) {
> -               fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
> -               goto out;
> +               fprintf(stderr, "snprintf failed: %s\n", strerror(errno));
> +               return ret;
>         }
>
>         ret = asprintf(&rem, "%s/", todo);
> @@ -1547,7 +1547,6 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>         ret = 0;
>  out:
>         free(rem);
> -       free(tmp);
>         return ret;
>  }
>
> --
> 2.20.1
>

