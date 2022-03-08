Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE0E4D0FD1
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344380AbiCHGMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiCHGMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:12:44 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318EB3C4B8;
        Mon,  7 Mar 2022 22:11:48 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id c23so19858488ioi.4;
        Mon, 07 Mar 2022 22:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7BvwyhAFWa4G27i4/sy6U4v+QtsssPHIl8FCNF4JtE=;
        b=OPMEkDNTZHkbldBxxTGm523xM9rSSmdtF7xsHAhOC4W2/3OmaW/84WMcgXJPHTpcg5
         I56y3b6mg1NAxBkTCZE0nviSnBO3FNT120ZlhNlOL/F0xPI+BDAuuis1PPO18gxm8+tP
         GO8nqnhmrSNd+OOpf2hkDNJAOU0Zm15HUI0Eiv/102G4lc4TCWBF4prYHDPEWFd0T+5k
         6Tx6Iy73aLu/5xgCAFWFln1iHZp8mNKfx8yps82HZ/T3C3G/icFHjC+tpZ3J5zyK74yG
         szd1w9uFHq6ALG1W3P2uhzf9Qk2KwrYrXMijetR1H5eNHgFr0mQ+6EeIIrRUeAEtzDJi
         JlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7BvwyhAFWa4G27i4/sy6U4v+QtsssPHIl8FCNF4JtE=;
        b=jt/S7gWKRq9CS24Sq36GMWmyG4QS5F862E0IzsCqIYChAW4LwrTO2TK9v0dZ25WTsA
         ZW+mSgPKdFs/9UiaxuRXmp4BlBMRPBt0ZzzMRAL2YeGyHokaIB17qxbUPaf+jbfeXRuG
         LJu1jIH/RO4T91KLb3ukUROZWx1Xuccb+lMjNSMRFL0ty0Yv1fUb6G2iwKPwSW/sjRnG
         x5dAwk3ocrSrzxgaMXBDL1XgpJPch5lsTQj0XMzkiawOVzXhtZTnbApc8amsPxOwANI2
         ghXJmfktMVUSP5xcCRZUsanLTRAwwfSkNaCvIsxKbBruvCY3Zw5iLMFz4oo2aJAWhlc2
         jAyQ==
X-Gm-Message-State: AOAM531npoE5MTXc2nae62dnVjkeyRSoaXvd95h11h2iqQpb/9GUomqz
        wKYycXVIfUatnI9vrcsBvJhp/gsClA4Xfx3WROo=
X-Google-Smtp-Source: ABdhPJwUaC6RzBg1Az9oeiOgECfLmo2J1IUzm7SCV5qh+KzsgvrZjLWZZFoWME4v9+GJ/AgEf4bsNEMpjacfWYidiUY=
X-Received: by 2002:a02:aa85:0:b0:314:c152:4c89 with SMTP id
 u5-20020a02aa85000000b00314c1524c89mr13873666jai.93.1646719907591; Mon, 07
 Mar 2022 22:11:47 -0800 (PST)
MIME-Version: 1.0
References: <20220306121535.156276-1-falakreyaz@gmail.com>
In-Reply-To: <20220306121535.156276-1-falakreyaz@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 22:11:36 -0800
Message-ID: <CAEf4BzYmVo9rw1Ys0ZufQFA=f7sy+dP=d9L9rmGS5L91qV1K+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: fix broken bpf programs due to
 function inlining
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>
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

On Sun, Mar 6, 2022 at 4:15 AM Muhammad Falak R Wani
<falakreyaz@gmail.com> wrote:
>
> commit: "be6bfe36db17 block: inline hot paths of blk_account_io_*()"
> inlines the function `blk_account_io_done`. As a result we can't attach a
> kprobe to the function anymore. Use `__blk_account_io_done` instead.
>
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  samples/bpf/task_fd_query_kern.c | 2 +-
>  samples/bpf/tracex3_kern.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/samples/bpf/task_fd_query_kern.c b/samples/bpf/task_fd_query_kern.c
> index c821294e1774..186ac0a79c0a 100644
> --- a/samples/bpf/task_fd_query_kern.c
> +++ b/samples/bpf/task_fd_query_kern.c

samples/bpf/task_fd_query_user.c also needs adjusting, no? Have you
tried running those samples?


> @@ -10,7 +10,7 @@ int bpf_prog1(struct pt_regs *ctx)
>         return 0;
>  }
>
> -SEC("kretprobe/blk_account_io_done")
> +SEC("kretprobe/__blk_account_io_done")
>  int bpf_prog2(struct pt_regs *ctx)
>  {
>         return 0;
> diff --git a/samples/bpf/tracex3_kern.c b/samples/bpf/tracex3_kern.c
> index 710a4410b2fb..bde6591cb20c 100644
> --- a/samples/bpf/tracex3_kern.c
> +++ b/samples/bpf/tracex3_kern.c
> @@ -49,7 +49,7 @@ struct {
>         __uint(max_entries, SLOTS);
>  } lat_map SEC(".maps");
>
> -SEC("kprobe/blk_account_io_done")
> +SEC("kprobe/__blk_account_io_done")
>  int bpf_prog2(struct pt_regs *ctx)
>  {
>         long rq = PT_REGS_PARM1(ctx);
> --
> 2.35.1
>
