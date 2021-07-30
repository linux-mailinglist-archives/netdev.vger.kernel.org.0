Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3763DBE75
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 20:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhG3Skr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 14:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG3Skq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 14:40:46 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37319C06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 11:40:40 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id m193so2857651ybf.9
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 11:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ZJf7NdmBf0ZXmV93u+O0u4Wzjjo5mi6y5VWYy13mIc=;
        b=AfaMobeN17tZDFrEvG8QBJJjGhQLZX4TVzBoXbuCyOOI2lO4w8z50iKpj0nfXeunce
         OZ/Q1HqMI8soheQcM5qMe9ynX3bfMHGAxgdXnj3IKLkIbXMvFSiC+fb9ZWYubBMvJ23r
         J+sMCenFhVIuXFAXUqtfNMmmzIzz06pDondYNzN+Fyx/GQpQ+5Zewl1u6z+VrF6jIDAx
         KXlSG493WoAkP/DmAFU+Z19NUQ4cW4uqs/l3aC/+mur60E/n/TlwRlghBe9PUGVstJSN
         foLWy/piPcYJMBdBfChAT+WOSJA9VrZpbQ3D57m165pob0vSk1IMe/e9umAT231pkIq8
         FsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ZJf7NdmBf0ZXmV93u+O0u4Wzjjo5mi6y5VWYy13mIc=;
        b=lOTwpnCeOSgV3ce4x7/Xkx/CFArJrgrpSdMxLB1PUvm1nqEzdqXYt9cnEuBCEgRhQF
         ZdiCb3C4MydPrA+txcvjS5ZM8bgD18EU4r1y2mbP10HO/lS67vvGVlf8NZRhu+uqBw/t
         1LepfHE2Z/hR1TkypqP/sqHzpV+vnlqHVU2fppl0aVKG14vZd6j3HVkOrqlkHUnoOBup
         ILeSb0dNBn8GW5RifeLeDYovuHaglmssK3ejzKOHk8dyTe1W10NonpljEt0GipCTSF9V
         LLrapr+1ZEBevr4TRWCoR7vvbDdw5O4Fzai8nL7G9ot3ExLO67OhhNrX8597p4UgnnOB
         wk+w==
X-Gm-Message-State: AOAM533LvcveXbMlMYG1giV6mu7i1Rb2GE03pS4FGkz+nfPXJ4EVJlvj
        +1tn3I9Rmd3kH4touCzIaGiOZcxxYS2fiJTmSMg=
X-Google-Smtp-Source: ABdhPJxgB7aRYEojy8rW3j6kM292EyaGUpyarOeK4kOnu3UjtizdyNUTwSlQhPONvSCTurV9xtb7rCUEk/aBND6f1n8=
X-Received: by 2002:a25:2901:: with SMTP id p1mr4971870ybp.459.1627670439333;
 Fri, 30 Jul 2021 11:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210729045516.7373-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20210729045516.7373-1-zhoufeng.zf@bytedance.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 11:40:28 -0700
Message-ID: <CAEf4BzY8_n9Yvd0Tpveca5-YRQYpqLgZHshHTWVUNOrAzUJfWw@mail.gmail.com>
Subject: Re: [PATCH] lib/bpf: Fix btf_load error lead to enable debug log
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        kuznet@ms2.inr.ac.ru, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        chenzhuowen.simon@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 9:55 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> Use tc with no verbose, when bpf_btf_attach fail,
> the conditions:
> "if (fd < 0 && (errno == ENOSPC || !ctx->log_size))"
> will make ctx->log_size != 0. And then, bpf_prog_attach,
> ctx->log_size != 0. so enable debug log.
> The verifier log sometimes is so chatty on larger programs.
> bpf_prog_attach is failed.
> "Log buffer too small to dump verifier log 16777215 bytes (9 tries)!"
>
> BTF load failure does not affect prog load. prog still work.
> So when BTF/PROG load fail, enlarge log_size and re-fail with
> having verbose.
>
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---

This seems to be targeted against iproute2? It would be good to
specify that as [PATCH iproute2] or something.


>  lib/bpf_legacy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
> index 8a03b9c2..d824388c 100644
> --- a/lib/bpf_legacy.c
> +++ b/lib/bpf_legacy.c
> @@ -1531,7 +1531,7 @@ retry:
>                  * into our buffer. Still, try to give a debuggable error
>                  * log for the user, so enlarge it and re-fail.
>                  */
> -               if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
> +               if (fd < 0 && errno == ENOSPC) {
>                         if (tries++ < 10 && !bpf_log_realloc(ctx))
>                                 goto retry;
>
> @@ -2069,7 +2069,7 @@ retry:
>         fd = bpf_btf_load(ctx->btf_data->d_buf, ctx->btf_data->d_size,
>                           ctx->log, ctx->log_size);
>         if (fd < 0 || ctx->verbose) {
> -               if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
> +               if (fd < 0 && errno == ENOSPC) {
>                         if (tries++ < 10 && !bpf_log_realloc(ctx))
>                                 goto retry;
>
> --
> 2.11.0
>
