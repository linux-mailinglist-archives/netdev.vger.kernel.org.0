Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708F45B4ACA
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 01:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiIJXLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 19:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIJXLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 19:11:22 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD1B32EF1;
        Sat, 10 Sep 2022 16:11:21 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dv25so12173200ejb.12;
        Sat, 10 Sep 2022 16:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=jeaK+huC0HYaYSoTKVP+Gx3xGfLUlzMNYAzI17T9gFo=;
        b=XcNKsQJjPIW/WYRF3YdK9KskaL6E6piJLRR94UKljQ2eVjj1+v/Go4QCOk2nkO9/LH
         NGcc0ySKEUabUKoRAAFHE457OxUnR6D/KEploaoELiWbZsUnb8PeojGDUMMengQxZboF
         xMUqMJrSGuD7+gbJXJGJt9c6lgmpsE6Yp4DpI6szHHJpJ4hLonPp8177viCG8PwGi6O0
         i179nBJvfjivb7VWwGSjsbO/8u1sud0a0mKh4/gvzgTuRWmwnoCpZaL7eXkH5jhik6Gs
         vJy9zSGrwr6u2A40YU7BSaMftR+cCZ/K6c+pculL+ZwjEVbdt9Gb0KX9qIJJ7Ui+nKV8
         RybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=jeaK+huC0HYaYSoTKVP+Gx3xGfLUlzMNYAzI17T9gFo=;
        b=VXdrl4+EyNcuU+GsD4pE/8onC8fDlci3WYQtyAQWMozrwF1nUO3f1STa5s4IotVwHv
         bifFJ14EMvqaMzDKz2OQa0XSVcjJTl7msaWr1I7eR1KZ9X97MmYWwSqSLB/+oYI/FVUk
         PDOpwUkCyNPDRvSpG213pm3WVxIb1DhAhi0fZOZUUXbdQKq3r36wrGv0cLqPOvHxRKUl
         nXir3jjDgWGwdeLQe8Xf3uV+YQh3V84Wmhk31PDQ/nrkDsHc23MtEjWSFHgzvKZfyyje
         zyY7A1wIeCtNM3tIE3ERGjPZLWrsTalnr/4knUUJen0rQqbEDwmRAObXp2rjY3YKZQpY
         QtPg==
X-Gm-Message-State: ACgBeo2wNSZH7SHeIqPkxkxiNRt8FwnMioP0hvZ6WwhHPrUiQPROrme4
        RPKCtKko3iSjfT6/sAn6KXi8yFrPlBwe6rKxxdRXrmoM
X-Google-Smtp-Source: AA6agR7iaCQQLiFavNq17LTwEmCH5qrE5xls7SZa53tRYFe6JZ8z/+aKQT/uJEt4R8eboVZwsyaj0QLKiyo5ONE+GnI=
X-Received: by 2002:a17:906:3a15:b0:73d:80bf:542c with SMTP id
 z21-20020a1709063a1500b0073d80bf542cmr14183968eje.633.1662851479612; Sat, 10
 Sep 2022 16:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005ed86405e846585a@google.com> <e2e4cc0e-9d36-4ca1-9bfa-ce23e6f8310b@I-love.SAKURA.ne.jp>
In-Reply-To: <e2e4cc0e-9d36-4ca1-9bfa-ce23e6f8310b@I-love.SAKURA.ne.jp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 10 Sep 2022 16:11:08 -0700
Message-ID: <CAADnVQ+xWjREsVhbitJcdKUvb-pif2R_C58tf8UMc1Tzqo+-QQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: add missing percpu_counter_destroy() in htab_map_alloc()
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        syzbot <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
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

On Sat, Sep 10, 2022 at 8:08 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> syzbot is reporting ODEBUG bug in htab_map_alloc() [1], for
> commit 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated
> hash map.") added percpu_counter_init() to htab_map_alloc() but forgot to
> add percpu_counter_destroy() to the error path.
>
> Link: https://syzkaller.appspot.com/bug?extid=5d1da78b375c3b5e6c2b [1]
> Reported-by: syzbot <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated hash map.")
> ---
>  kernel/bpf/hashtab.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 0fe3f136cbbe..86aec20c22d0 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -622,6 +622,8 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>  free_prealloc:
>         prealloc_destroy(htab);
>  free_map_locked:
> +       if (htab->use_percpu_counter)
> +               percpu_counter_destroy(&htab->pcount);

Thank you for the fix! Applied
