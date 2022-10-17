Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80F7601390
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJQQgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJQQgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:36:23 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7306642F5
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 09:36:22 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id i65so9565565ioa.0
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 09:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=skCCUzbnEznyI0pon1ebXS2COuj2VDhmeaFFtxQOPXI=;
        b=ZYHDsQcYL7xWpdQhqzfFBXfOzdomO8KSfDaBVIfpYIi2sSyc8tXZ0AhKfliodNfpMM
         Y/S08xuMia9RkHYpzlatEIwTF06/ujS5Inwmowh6i1UGjIpAxPV6DCXMpfROaGL4tUIe
         PTAIwGRff1fJ0hbTM33Sez40B8GJRR/TWoWr/kTgDGItcsOPyGIccvt2UjMhxxFxp1Pb
         3UuUbsf5WNDxJJ/fApa6HstTUKLgu9wfgYVxav6NMUcu5juUjDH6sXBQ1ddsIseW1S91
         eezV6TDLQMKBQ7f9rVbN3B1OLLhxjOwg8MYvWU8XC+28ApuWMBv9vSBe09j60BqkhJcf
         wUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=skCCUzbnEznyI0pon1ebXS2COuj2VDhmeaFFtxQOPXI=;
        b=zwUl3EU8pkF8+HNoMuvQLGR27VYzypVHv7lpqSjhZ4C/K67DDn93/BXVO/B/sdCOlg
         ph3PkeE86JNUUGxT1CY8pWvJqyPTWSnmbYVXBUxAwOxn4fDXYMkKxncM5NQKk1E0gEYY
         OAjCdVb0SRzDD3/PRtFdE/UOiIOMFt/Bi8V35Jh2xIWQm/XhK1sE8Xvik/Qrx4IzsyGO
         S1YHITwILRm4/94x0tgXUjquGD5e9OJoY5Ch8V7x8CgeZJ5XI92RFVTNvqZAEfQTw3z4
         dr4sjjGMFgFFRKGmZVWvEWGOCqQ1ikNq5/7R93xodbLssBTnstH0NKoDeqFRKx7sZ0I7
         4UtQ==
X-Gm-Message-State: ACrzQf1FMab1WthdDBK03+xw/gB2Xgq7+nPIfEaMDSjgqrM+GkiUOihx
        rikJ6tkZVlTvnhtfQsxtnQCqC0ULA6f81jv4bIEjaA==
X-Google-Smtp-Source: AMsMyM4D+jbc0eDlqdIYudXSfQY0/PCjxxTyhI1z3cybmkACiSaedb6InC39UHUREXLt5nQIDmGXX0NPpEm2n+XXyFs=
X-Received: by 2002:a05:6602:2e84:b0:6bc:e289:8469 with SMTP id
 m4-20020a0566022e8400b006bce2898469mr4769673iow.202.1666024582029; Mon, 17
 Oct 2022 09:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221015092448.117563-1-shaozhengchao@huawei.com>
In-Reply-To: <20221015092448.117563-1-shaozhengchao@huawei.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 17 Oct 2022 09:36:10 -0700
Message-ID: <CAKH8qBugSdWHP7mtNxrnLLR+56u_0OCx3xQOkJSV-+RUvDAeNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix issue that packet only contains l2 is dropped
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, oss@lmb.io, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 2:16 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> As [0] see, bpf_prog_test_run_skb() should allow user space to forward
> 14-bytes packet via BPF_PROG_RUN instead of dropping packet directly.
> So fix it.
>
> 0: https://github.com/cilium/ebpf/commit/a38fb6b5a46ab3b5639ea4d421232a10013596c0
>
> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/bpf/test_run.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..aa1b49f19ca3 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -979,9 +979,6 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
>  {
>         struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
>
> -       if (!skb->len)
> -               return -EINVAL;
> -
>         if (!__skb)
>                 return 0;
>
> @@ -1102,6 +1099,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>         if (IS_ERR(data))
>                 return PTR_ERR(data);
>
> +       if (size == ETH_HLEN)
> +               is_l2 = true;
> +

Don't think this will work? That is_l2 is there to expose proper l2/l3
skb for specific hooks; we can't suddenly start exposing l2 headers to
the hooks that don't expect it.
Does it make sense to start with a small reproducer that triggers the
issue first? We can have a couple of cases for
len=0/ETH_HLEN-1/ETH_HLEN+1 and trigger them from the bpf program that
redirects to different devices (to trigger dev_is_mac_header_xmit).





>         ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
>         if (IS_ERR(ctx)) {
>                 kfree(data);
> --
> 2.17.1
>
