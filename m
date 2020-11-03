Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4962A4F93
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgKCTC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCTC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:02:27 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630A8C0613D1;
        Tue,  3 Nov 2020 11:02:27 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id i186so15756494ybc.11;
        Tue, 03 Nov 2020 11:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m42DbzkD+osL19RsaBrrX0AeYKBjdMnQ7qK9QKFi0xc=;
        b=MZ0qdrGLuVZl6c3YU+OZFjTebbtUCMyWwygbBk1Wf8BTnnReYPonqgzYJqprANSsS/
         +Piop87w7bC3TUdUWoXpWfuZ4djB33x03jCov8lqAZrvdHFjQSeWBhJiICToMoHuCX0y
         kUcytUriU17tVNcUa8XxiLAaE1DH4kL/bEZ2DIxV3/0WGh9OS9JA7nw9HEqG5w34UmJc
         oT8styTjj5KaUwXn1C2sh0Hv5Pf41GAqR0HOUbmaivqB+dQf+OFgMCO8sGpn3AWjxp84
         jD7aws7M+CAhwBYWG+aWkJ8acizkhzUj5o5vNc+MiQ3fsrET4leQ7j5UDcPioyVmnSvR
         KmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m42DbzkD+osL19RsaBrrX0AeYKBjdMnQ7qK9QKFi0xc=;
        b=XVStDTlq6S2A1tJgAe4r/lKfc9FYlfCO9Mo7CPGsECvn4nEgV2rbSmMc0+D+SJXu3V
         3l1q7YGXhMoBuU5nzCzqOMxo3hKxO+QQTqaEaL3/nTyJdGEKVJ6UiV7u+Fe9spo6A4HP
         /KCI8zcHRvIuHauf57WIwcscDBU5eACH9yDzC/xf2RMK/hD5QckSZ13K85ucvA7n3pd+
         GasUBedBA4ZCr22ugW1h/fpWXGyhX+nTMKzahpa//wepBuAVa/CFiqOppEpjSSjutUUY
         csk7Af8FyHstNlwC7VwxPjAknbM30XYdHlNx+QvnwXX0/a09zhM/PgYaPSiwDBnubBBo
         nEXQ==
X-Gm-Message-State: AOAM531CRwntystvIFomSkY+opHXjtlcwcakdzsXigbLYxy6X/n07N5W
        nqMA7MBjaNZOOdz0qTnP5GGKNPDtIM3DtcAAtfU=
X-Google-Smtp-Source: ABdhPJxgsg0VLmlCCiMCMi3llZiAt5vhU10LApcxdKOrjxV34RkoZuzNpg0oqaMcO+tiDgCMjrM1z9paonG5FcKiv1c=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr31251504ybl.347.1604430146606;
 Tue, 03 Nov 2020 11:02:26 -0800 (PST)
MIME-Version: 1.0
References: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com> <1604396490-12129-2-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1604396490-12129-2-git-send-email-magnus.karlsson@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Nov 2020 11:02:15 -0800
Message-ID: <CAEf4BzYfYpMqtzDnmZ+LK5tkYbbH95F5aOAvjVVP2Vzp9eFrMw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] libbpf: fix null dereference in xsk_socket__delete
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 1:41 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a possible null pointer dereference in xsk_socket__delete that
> will occur if a null pointer is fed into the function.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/xsk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index e3c98c0..504b7a8 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -891,13 +891,14 @@ int xsk_umem__delete(struct xsk_umem *umem)
>  void xsk_socket__delete(struct xsk_socket *xsk)
>  {
>         size_t desc_sz = sizeof(struct xdp_desc);
> -       struct xsk_ctx *ctx = xsk->ctx;
>         struct xdp_mmap_offsets off;
> +       struct xsk_ctx *ctx;
>         int err;
>
>         if (!xsk)
>                 return;
>
> +       ctx = xsk->ctx;
>         if (ctx->prog_fd != -1) {
>                 xsk_delete_bpf_maps(xsk);
>                 close(ctx->prog_fd);
> --
> 2.7.4
>
