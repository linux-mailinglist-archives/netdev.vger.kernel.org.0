Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868C04F87A8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiDGTHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 15:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiDGTHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 15:07:04 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B410E33C;
        Thu,  7 Apr 2022 12:05:03 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e13so4928997ils.8;
        Thu, 07 Apr 2022 12:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+dlVy2KZaY8lVEV9hh94s1VdGn0V+ORlIk1tY4mgF8M=;
        b=YXgIRtwSAJL+rMrZdZF3nWvejXegp0BTZlsi8nmRL/Lhq0+pxiL2xcJg0C9MFAfrjZ
         0t8pvl6UrBxH1s14afcX0k0PNp4hwIWe3v8HdOM8OaEng8IWhOy8g66MvN4T80ZGuw9H
         CQS2QjzEKR+0+8CEgVA7jdCROqb7+3Xtw/SlHapVcbtwJQhZmcJ7uhoOEzrbr6zTsazX
         DrS6LlFNswULirUP9mkugPMyW9AdyISKaZDp9/MTl4c00GXr+2OyTZB6rNTEykRTloSV
         gTAp3kyY071EzYLnML+5KjVKdTkOMO9l+9wH2JaGMZ5uOKpYOv+tjnkgPHdovwI+LPDX
         LNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+dlVy2KZaY8lVEV9hh94s1VdGn0V+ORlIk1tY4mgF8M=;
        b=cPoCRfMrWCHByOBQH9g1W0OcolDvzqoxylEQ2h/Yyin9ZrH6oDE0gcOS6BuoNgvDuw
         0b+qY7sqE2fYRJk84s3s3HH0fviopUDDBQhCWuCJhp+9VfMC9oDzt7zpyPztN93ENRfA
         tMCavIK2Gh0k1bYWgjxqS7BtbMexSdGb+IHclYcgT9ebuLaDBJQTDeaKIdOqG1R1pn+b
         gvNBZ5dLfFyzzkE0jUYZVvRZlHTIbOeRVWARAxSsQ9b7C/10qhWx7uUn+CJO9Z5XYvc8
         5aCCM3om2K70mEolPCOs6F390J4DZQCUPxalgw2lFzC9yhXCFzqs7gNtfj9F9up7jP4B
         WLBg==
X-Gm-Message-State: AOAM531NcVRU2Ksc7BMEjYlkPV+MJlTZseQ1oKxL3fy68JsE3MNT31YC
        qPSOsBryqTZCtgGHwPrIbw5ww2wm0yAgz4026OE=
X-Google-Smtp-Source: ABdhPJzv3mhX3oefUnrlyLlgbT15YrUQel8OjPzyQFHgJ0TxZrZJ/j2j/YZGv0gWf4L00pIrogFzNMV7iRH7j+o5LRs=
X-Received: by 2002:a05:6e02:1562:b0:2ca:50f1:72f3 with SMTP id
 k2-20020a056e02156200b002ca50f172f3mr6911215ilu.71.1649358303000; Thu, 07 Apr
 2022 12:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <1649299098-2069-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1649299098-2069-1-git-send-email-baihaowen@meizu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 7 Apr 2022 12:04:52 -0700
Message-ID: <CAEf4BzbByQ8OUuACyLEHewPsFjfUpH8Yr1x2+Db5xtGgnPXhrQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: potential NULL dereference in usdt_manager_attach_usdt()
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 7:38 PM Haowen Bai <baihaowen@meizu.com> wrote:
>
> link could be null but still dereference bpf_link__destroy(&link->link)
> and it will lead to a null pointer access.
>
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  tools/lib/bpf/usdt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
> index 1bce2eab5e89..b02ebc4ba57c 100644
> --- a/tools/lib/bpf/usdt.c
> +++ b/tools/lib/bpf/usdt.c
> @@ -996,7 +996,7 @@ struct bpf_link *usdt_manager_attach_usdt(struct usdt_manager *man, const struct
>         link = calloc(1, sizeof(*link));
>         if (!link) {
>                 err = -ENOMEM;
> -               goto err_out;
> +               goto link_err;

this is not a complete fix because there are two more similar goto
err_out; above which you didn't fix. I think better fix is to just add
if (link) check before bpf_link__destroy(), which is what I did
locally when applying.


>         }
>
>         link->usdt_man = man;
> @@ -1072,7 +1072,7 @@ struct bpf_link *usdt_manager_attach_usdt(struct usdt_manager *man, const struct
>
>  err_out:
>         bpf_link__destroy(&link->link);
> -
> +link_err:
>         free(targets);
>         hashmap__free(specs_hash);
>         if (elf)
> --
> 2.7.4
>
