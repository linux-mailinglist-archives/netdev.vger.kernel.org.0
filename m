Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317AC56AAE4
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiGGSeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbiGGSeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:34:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434706B272;
        Thu,  7 Jul 2022 11:31:33 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id d2so33961408ejy.1;
        Thu, 07 Jul 2022 11:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idtTibX39G3M3EcggPBGQ0OQ7aIB8ofMb/2wWYruZ7E=;
        b=ci2hmjGBNxckQ+31ahd3/Po/um5v7f46g8voKFuBJa3NHBdFaubyoxLCGISagKi/9E
         ndTSSVIGDCDF6mOLZjLoZcdmXn6CA2EvygBP2nP5m3xKXdBiRni2D+u8tRouE47d/yVG
         nleqoIk3rek1Qo4WFdbM001fla+f3gnl977/3UDRIT4BSI0sYkeXAwNjUjKL1wwVvYyk
         /KgfGe12xUQe/HIp7DUEnS9aOQmn6Yo48cVfQx5xMbyOfoi+qDtq5mqVrQkqJ7/z2/7q
         tQT5ufdO8syGB/cXRiefkCjgNdxJt5ZFtxm/tbCzBGLF7zNYOjAO4Yt2f3ksT9S2hN7V
         um0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idtTibX39G3M3EcggPBGQ0OQ7aIB8ofMb/2wWYruZ7E=;
        b=s3/N6EYpGoooI413aGEZihgAHasbH11tnvTNzjzujjPW1BqWX7Cd1J3R6dqt4YvevV
         ZftyuLbDUna8fx49Pgxiz49TWKbrfWqkVHf2SQhhQbG2MlJyLdesAJHBZhOWhuG12zoe
         TPtyTCJnXWMU9YuUtgd2+ePitesoyJgR8wK76DEsM4sMOF6dWRg9IPTIoMg6Prlkgj8U
         rpJngno8T501sp7GchDl41UTUrMDamC4COMU0YCcbWE40FOhRnGuJG0BJXiM7zin505l
         xwGbvzZhMIW6YNkKk11+8uD+efhiJ1OznSYbiClntcassMrfrqeZn9h9xBZOKPByHbAG
         3C8w==
X-Gm-Message-State: AJIora+SGVCJoxa6c1KuNBGhDnJuUAgVfhAk1Vc9ZgCwlbWmjvmGtoPg
        Gql+gyBxPQwHfWcYADDBvTOIzwQjjYWC/+2Ru44kSdcV
X-Google-Smtp-Source: AGRyM1uUlWbDOflFI/XQbphOpNFpMA8QeTxN8uLKBqanGDBTPwDjVE1s+g7g0p4NrwwvhM4bK6VnaW1Qt8rgKyXtmaw=
X-Received: by 2002:a17:906:5189:b0:722:dc81:222a with SMTP id
 y9-20020a170906518900b00722dc81222amr46173415ejk.502.1657218691531; Thu, 07
 Jul 2022 11:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220707123900.945305-1-edumazet@google.com> <165721801302.2116.12763817658962623961.git-patchwork-notify@kernel.org>
In-Reply-To: <165721801302.2116.12763817658962623961.git-patchwork-notify@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 7 Jul 2022 11:31:19 -0700
Message-ID: <CAADnVQLoMzN8icCenQh7OHNRHAHMhQhujQYwSXH3Kmw6sAGOGA@mail.gmail.com>
Subject: Re: [PATCH] bpf: make sure mac_header was set before using it
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>
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

On Thu, Jul 7, 2022 at 11:20 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to bpf/bpf.git (master)

Are we sure it's bpf tree material?
The fixes tag points to net-next tree.

> by Daniel Borkmann <daniel@iogearbox.net>:
>
> On Thu,  7 Jul 2022 12:39:00 +0000 you wrote:
> > Classic BPF has a way to load bytes starting from the mac header.
> >
> > Some skbs do not have a mac header, and skb_mac_header()
> > in this case is returning a pointer that 65535 bytes after
> > skb->head.
> >
> > Existing range check in bpf_internal_load_pointer_neg_helper()
> > was properly kicking and no illegal access was happening.
> >
> > [...]
>
> Here is the summary with links:
>   - bpf: make sure mac_header was set before using it
>     https://git.kernel.org/bpf/bpf/c/0326195f523a
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>
