Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29D75821DE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiG0IQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiG0IQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:16:41 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8619C2126A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 01:16:40 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-31f661b3f89so5803707b3.11
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 01:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TosQt7+C6WVDgeW3pqLpixZ2CG0ue4hW6mKDztF+riI=;
        b=ewV8nzHI7JjrNhkdqJI6eEzQ0a8NHsR59OqkPqFN9gmcL2mm3GH97ruy12TfQAdeDn
         NKkCzJmG00tptTd030QoLBbUjGh2c2rNFMq/y8tdfx2t80V1o+4x97aF4BfSEvWZzqXG
         EoCeEJHjQp5oQI5oNuVf/hc+KxEUmKrifz8KkK+wkL0DpMfJKhCw/2kmJOP8fnEravqm
         OCjR6/379HopAwgQk2amBUOCeeH2ilJaPfWiEKGWjFX+KNGKkXzn1JjP0izGNR0Y46Sa
         CByJVZlILLHFgtQDR7960DES6HBEhbSEyzN3EWlqyY34YdWKJB9/rKbrv/W8O3xT1N2/
         Sm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TosQt7+C6WVDgeW3pqLpixZ2CG0ue4hW6mKDztF+riI=;
        b=V9vfIOw+pEjLGEs2+pUpQW7NcwNXP38E67FrS7PckRoryfGu757wKiKz5HdZn8zY+0
         QIJacwIUAq/QTPNrd0WjFC+Mt1rfJjid2QPY4EoSLPKozI1+gVUKpfZgGIw17TcyvCev
         YCNzbB6gectwFKgsEp6sY5rd1t5hDJ/FBi0FIPobfwVdb5Ym12Ca+V9AGTgmNguPcqiN
         OqXQLLfukNkvj6u9YKcZ/2Rnq4+2tdqwwstn0BKEkalDViDmibDC9DWSD+uAZQCGwag4
         tf1NwDX0NX0aAgpb0ntYfT4lniI6RisP5vMmLvn3PEtokmxdiD5hc4IHFMlZrsGvrlGj
         VfRg==
X-Gm-Message-State: AJIora+Il5x5fwVk9mU+jpM4yYpJKIgajFJmuiRbxC3AQmGCXwPi93fA
        1BKBnsCEuMLIDgV2CnMj24/H6wZoheRp6b05wyJ+Sg==
X-Google-Smtp-Source: AGRyM1sCWl/4tFuOowWpHAjF91MWtDb7jpJ506rygqhFd89O61l5gDMhrej5gzjHR2W0IsAXkP0QQftkxqgAwJ1pjMg=
X-Received: by 2002:a0d:f104:0:b0:31f:268a:43da with SMTP id
 a4-20020a0df104000000b0031f268a43damr9871228ywf.332.1658909799532; Wed, 27
 Jul 2022 01:16:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220727060856.2370358-1-kafai@fb.com> <20220727060902.2370689-1-kafai@fb.com>
In-Reply-To: <20220727060902.2370689-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jul 2022 10:16:28 +0200
Message-ID: <CANn89i+X-6Z=a-mYGEFTa=SWB2anDGsJYJoG_rAeo07HpBjw2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/14] net: Change sock_setsockopt from taking
 sock ptr to sk ptr
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 8:09 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> A latter patch refactors bpf_setsockopt(SOL_SOCKET) with the
> sock_setsockopt() to avoid code duplication and code
> drift between the two duplicates.
>
> The current sock_setsockopt() takes sock ptr as the argument.
> The very first thing of this function is to get back the sk ptr
> by 'sk = sock->sk'.
>
> bpf_setsockopt() could be called when the sk does not have
> a userspace owner.  Meaning sk->sk_socket is NULL.  For example,
> when a passive tcp connection has just been established.  Thus,
> it cannot use the sock_setsockopt(sk->sk_socket) or else it will
> pass a NULL sock ptr.
>
> All existing callers have both sock->sk and sk->sk_socket pointer.
> Thus, this patch changes the sock_setsockopt() to take a sk ptr
> instead of the sock ptr.  The bpf_setsockopt() only allows
> optnames that do not require a sock ptr.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

...

> diff --git a/include/net/sock.h b/include/net/sock.h
> index f7ad1a7705e9..9e2539dcc293 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1795,7 +1795,7 @@ void sock_pfree(struct sk_buff *skb);
>  #define sock_edemux sock_efree
>  #endif
>
> -int sock_setsockopt(struct socket *sock, int level, int op,
> +int sock_setsockopt(struct sock *sk, int level, int op,
>                     sockptr_t optval, unsigned int optlen);
>

SGTM, but I feel we should rename this to sk_setsockopt() ?
