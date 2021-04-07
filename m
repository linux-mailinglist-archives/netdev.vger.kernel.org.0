Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05B43573D3
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355065AbhDGSCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbhDGSCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:02:22 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C487DC06175F;
        Wed,  7 Apr 2021 11:02:12 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id o10so1545153ybb.10;
        Wed, 07 Apr 2021 11:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpYCzJNOef6nzRWeGsY/LEXBbBDORX4MDbVyn/Z+mxA=;
        b=WnEEcxOzhTCnBorbstkvVjmjBanXBwj/KsFVDkz+UMUsUXsXxjUyGUeMiYRDMX6y0E
         TxN6KaWeUzCHRqWLgeQH5J5bkJIyohYXHl0pEo8nik/1mTjX4VTYdwWvdYmYEkYv/1aW
         s6FIDFivV+ob/1dDRzRmVGLTzZepI/dPNpnxn9Ve/DBnfl2lUaWn8AX0Q1cQytAOgYtl
         IQGg8vHvgRsKFVqTIlYEEXa4c75eQI92wKhsNvDXS4mVREm3SmrXIrlsXuUzl+pmpCB6
         iIkYL9dwnnoZwEaMms+E63CrXNz1nUCOI5HxvwjVur0vyXjzHsf70HuHj8UhkXHRJchl
         /S9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpYCzJNOef6nzRWeGsY/LEXBbBDORX4MDbVyn/Z+mxA=;
        b=dA4VWBF86OsZi1JtD+L/ENjZcCS4Ojc/i9ApgUexNZrOw3BtCRJOZpvLdVxOM39u7j
         Iidg54gqQ/bkD/WCusR2Y2GivHEBn1A7hykF43rFy6T46ih48EBEx5qE/YAbJwcYZZGi
         SC68PjRkXTv3AUNt2pePvjuuc72TnMyvFquJ3MDqANgBj4V3xg2ChLEaClXsPT926JK6
         ChivsW3d6VQjD7f+b9ZcZhpG8cHtLBOGLZZXpkUy5il1uwOtCe2l2trvFF0Az2OujTCF
         7/6TfE/iQNMabLo1PS2Lnweu4FA1ciKBkmDANzN8FbiS1uxgw677urvYpCrR8r4DZOL8
         GXwg==
X-Gm-Message-State: AOAM530pR+Yd1nPMdgUXxN8ppnN28gvBSB+VmChMlQufgsaNjMW4xNgf
        v2a8XzyAx3/MyKGQCuX0P6JyFQ0hxvLmjYoq0Ps=
X-Google-Smtp-Source: ABdhPJzRwzHE5d1xsj7Blti010Oz2Rl04CjvE55d3xX5lBzr4mq7TkRthbY9Bu4LNCIFTL6w//ljTP3AwCT8y4DRux4=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr5861561ybb.510.1617818532073;
 Wed, 07 Apr 2021 11:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210331061218.1647-1-ciara.loftus@intel.com> <20210331061218.1647-3-ciara.loftus@intel.com>
In-Reply-To: <20210331061218.1647-3-ciara.loftus@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 11:02:01 -0700
Message-ID: <CAEf4BzayWNm=kYqKz-6-P+fuRoy2UfPG8j8FuwXh5P6HDbsW9A@mail.gmail.com>
Subject: Re: [PATCH v4 bpf 2/3] libbpf: restore umem state after socket create failure
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 11:45 PM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> If the call to xsk_socket__create fails, the user may want to retry the
> socket creation using the same umem. Ensure that the umem is in the
> same state on exit if the call fails by:
> 1. ensuring the umem _save pointers are unmodified.
> 2. not unmapping the set of umem rings that were set up with the umem
> during xsk_umem__create, since those maps existed before the call to
> xsk_socket__create and should remain in tact even in the event of
> failure.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 443b0cfb45e8..5098d9e3b55a 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -743,26 +743,30 @@ static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
>         return NULL;
>  }
>
> -static void xsk_put_ctx(struct xsk_ctx *ctx)
> +static void xsk_put_ctx(struct xsk_ctx *ctx, bool unmap)
>  {
>         struct xsk_umem *umem = ctx->umem;
>         struct xdp_mmap_offsets off;
>         int err;
>
> -       if (--ctx->refcount == 0) {
> -               err = xsk_get_mmap_offsets(umem->fd, &off);
> -               if (!err) {
> -                       munmap(ctx->fill->ring - off.fr.desc,
> -                              off.fr.desc + umem->config.fill_size *
> -                              sizeof(__u64));
> -                       munmap(ctx->comp->ring - off.cr.desc,
> -                              off.cr.desc + umem->config.comp_size *
> -                              sizeof(__u64));
> -               }
> +       if (--ctx->refcount)
> +               return;
>
> -               list_del(&ctx->list);
> -               free(ctx);
> -       }
> +       if (!unmap)
> +               goto out_free;
> +
> +       err = xsk_get_mmap_offsets(umem->fd, &off);
> +       if (err)
> +               goto out_free;
> +
> +       munmap(ctx->fill->ring - off.fr.desc, off.fr.desc + umem->config.fill_size *
> +              sizeof(__u64));
> +       munmap(ctx->comp->ring - off.cr.desc, off.cr.desc + umem->config.comp_size *
> +              sizeof(__u64));
> +
> +out_free:
> +       list_del(&ctx->list);
> +       free(ctx);
>  }
>
>  static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
> @@ -797,8 +801,6 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>         memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
>         ctx->ifname[IFNAMSIZ - 1] = '\0';
>
> -       umem->fill_save = NULL;
> -       umem->comp_save = NULL;
>         ctx->fill = fill;
>         ctx->comp = comp;
>         list_add(&ctx->list, &umem->ctx_list);
> @@ -854,6 +856,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         struct xsk_socket *xsk;
>         struct xsk_ctx *ctx;
>         int err, ifindex;
> +       bool unmap = umem->fill_save != fill;
>

we are checking !umem only on the next line, so here it can be still
NULL. Please send a fix, thanks.

>         if (!umem || !xsk_ptr || !(rx || tx))
>                 return -EFAULT;
> @@ -994,6 +997,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         }
>
>         *xsk_ptr = xsk;
> +       umem->fill_save = NULL;
> +       umem->comp_save = NULL;
>         return 0;
>
>  out_mmap_tx:
> @@ -1005,7 +1010,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                 munmap(rx_map, off.rx.desc +
>                        xsk->config.rx_size * sizeof(struct xdp_desc));
>  out_put_ctx:
> -       xsk_put_ctx(ctx);
> +       xsk_put_ctx(ctx, unmap);
>  out_socket:
>         if (--umem->refcount)
>                 close(xsk->fd);
> @@ -1071,7 +1076,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>                 }
>         }
>
> -       xsk_put_ctx(ctx);
> +       xsk_put_ctx(ctx, true);
>
>         umem->refcount--;
>         /* Do not close an fd that also has an associated umem connected
> --
> 2.17.1
>
