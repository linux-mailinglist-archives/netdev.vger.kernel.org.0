Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5D953C4B4
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiFCF5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiFCF53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:57:29 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC4913CFA
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 22:57:28 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v4-20020a1cac04000000b00397001398c0so5786978wme.5
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 22:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trTQR6/qmHbTlyde/rCm8sSQSJS5wB9n1+cCV0e7RK0=;
        b=ZAEQlvgbKN0qmgFxrTlMgeUTBFJXXFKPGvElq+AAseoFgNf59kxTsxHeEbxmFDnMHf
         yqCgrHtHA67lNq4umZptjzUyVwVGgy4bf9VrDrNdLXNQ3zUE+/2buWyY254UiuESAryW
         ZER1hri8yIHaeqDwdfKZxWq2F/8nbyO/A+X9MpIT4A7JkizxtVv9QISQ9ba5RH9fp2Hk
         mQoWAhv2rWQOFueFLIjRj8RQyoqodVdB/rGuRkR570sXIwoOa7SX6LO3VOC9T10N5NVZ
         GZYUCjeWl5+yLn2TdQXE95+Wqz/Lz/AbtnWmgI7r6gdrWAm8HYZqdzkWF+hxaM9VH50v
         TtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trTQR6/qmHbTlyde/rCm8sSQSJS5wB9n1+cCV0e7RK0=;
        b=s+Vpo3t4udgnXOeRMcsEZ07cSZVxzHHIO/tUSGnM7GqHVg79Lj0utNoui6h5KwjmIB
         mYEBE+w2w/9U5D6qz/iuzEm7ooD06Y0M52LkGo/BMcQsvhjjsqC3adkJrS+zNq1+oYwv
         G9BJBgxLOvR1rVhvL6Zi4GhXDRn0mRogTPtrbCGgUZ/JYVSO3+ScYYeaYTVbeKZc5tUT
         Z5zVnJibIR/BgQTlIUjlza6MchJjKiYeeW5Ok8JV6U9tYW3WGYfeS8sZQTZqi1xtxJus
         rNVcwgsWc8WB+AIvx64oOjNaE/esPs5iGeK1kHWTg8tcs3Y9O7sgMP+yyELVvekZzf+g
         Jslw==
X-Gm-Message-State: AOAM530yW61m1zcovn33t4dAHmgoOcQEaJF5nx26yAXxS2MeC8+9raey
        4pXTSz+fGNAunVF0+31/917bRem6QZoVTNXMP83GldP3x64jKKs7
X-Google-Smtp-Source: ABdhPJwGoN6bmXgIXunf+Gu7h7634zKT6i0mHxKvT2pqhggzXPcroF5Muv7BO3o3uEbGWmJsG7M3rqIXWSfircn1Yqk=
X-Received: by 2002:a7b:c015:0:b0:397:3685:5148 with SMTP id
 c21-20020a7bc015000000b0039736855148mr6967957wmb.174.1654235846995; Thu, 02
 Jun 2022 22:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220603055156.2830463-1-irogers@google.com>
In-Reply-To: <20220603055156.2830463-1-irogers@google.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 2 Jun 2022 22:57:13 -0700
Message-ID: <CAP-5=fVhVLWg+c=WJyOD8FByg_4n6V0SLSLnaw7K0J=-oNnuaA@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Fix is_pow_of_2
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yuze Chi <chiyuze@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 10:52 PM Ian Rogers <irogers@google.com> wrote:
>
> From: Yuze Chi <chiyuze@google.com>
>
> Move the correct definition from linker.c into libbpf_internal.h.
>

Sorry I missed this:
Fixes: 0087a681fa8c ("libbpf: Automatically fix up
BPF_MAP_TYPE_RINGBUF size, if necessary")

Thanks,
Ian

> Reported-by: Yuze Chi <chiyuze@google.com>
> Signed-off-by: Yuze Chi <chiyuze@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/bpf/libbpf.c          | 5 -----
>  tools/lib/bpf/libbpf_internal.h | 5 +++++
>  tools/lib/bpf/linker.c          | 5 -----
>  3 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3f4f18684bd3..346f941bb995 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4954,11 +4954,6 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
>
>  static void bpf_map__destroy(struct bpf_map *map);
>
> -static bool is_pow_of_2(size_t x)
> -{
> -       return x && (x & (x - 1));
> -}
> -
>  static size_t adjust_ringbuf_sz(size_t sz)
>  {
>         __u32 page_sz = sysconf(_SC_PAGE_SIZE);
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 4abdbe2fea9d..ef5d975078e5 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -580,4 +580,9 @@ struct bpf_link * usdt_manager_attach_usdt(struct usdt_manager *man,
>                                            const char *usdt_provider, const char *usdt_name,
>                                            __u64 usdt_cookie);
>
> +static inline bool is_pow_of_2(size_t x)
> +{
> +       return x && (x & (x - 1)) == 0;
> +}
> +
>  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 9aa016fb55aa..85c0fddf55d1 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -697,11 +697,6 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
>         return err;
>  }
>
> -static bool is_pow_of_2(size_t x)
> -{
> -       return x && (x & (x - 1)) == 0;
> -}
> -
>  static int linker_sanity_check_elf(struct src_obj *obj)
>  {
>         struct src_sec *sec;
> --
> 2.36.1.255.ge46751e96f-goog
>
