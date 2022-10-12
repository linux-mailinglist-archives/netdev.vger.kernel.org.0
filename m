Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD655FC555
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJLMcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJLMcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:32:04 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9E8C694E
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 05:32:02 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-35ceeae764dso154390407b3.4
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 05:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n1eAXLVSdjDvTT36FDG6SszMPkNxBCxuhoYsTcbagCY=;
        b=NO1piUzZgrfqilXrIit3t/n5XrW8vDz1MFCgutluFp5rE633HaeBfiD8QzpiRyXdS2
         K7CnxDjTFilP5SDX/6AL59qHMzVLNZXc7e/gM2sDx0w8177zTzMzeFWKl2co7pi8cDuR
         ldO/OlbGiy07EK652BJMHMJDsSw3U8ngIr2szGEi3aGAito15SG7X1ZcuRmC4aTi10WM
         gTn3wgokrdWe/dYoL5ZWFLLeVjh3qjZbVt3cmtIwjK4l68yOBVskHGKWFBg98U4Jxdn2
         pkcZ4FSReSJWFghS1avo0s7897bsKnEujDAE+fflSa5nL13ByQ5ZQRPtwDbZHjVOjx+x
         5M6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n1eAXLVSdjDvTT36FDG6SszMPkNxBCxuhoYsTcbagCY=;
        b=xttEm/9R9LptHF3u99L85ezHefTE56Gi1Hjb+qlvAsUzYU9atLjL66al71soRK+A9Z
         QxFfVuAQwPg1cXUcowzotjOZX2UPrXglJqVrkanbnMpXDODUQ0i5p6zkdi72aL6bMOUg
         QVgWiP/gU3S7CeuHqgKS8b9brP0RaNYemNuyAC6qaFG5ZVAJoSc6/ZMcVLH9P2V8XUEp
         tYUcxrymTrROHy/R0kYXo+dPI8p+zfUETfASeW4z/PrMCL+stAViysiSSl1zZS9nZUmm
         9ey96PxjXhx0RK+n6BL9Z3u2NpC2iK1OsiNCrlB8nKLuOIX7OBiT7br/rZAf5M/Vx2Io
         jG4g==
X-Gm-Message-State: ACrzQf0FLCOfnOQM20LaXMjVrX22z6Fzrm4lOi8XUFt25ejHTLYZg39G
        ZZTxEiiqASre48ZZSg0El/xgnzwXMDZ0rLTpP62hddtcTbE=
X-Google-Smtp-Source: AMsMyM61a4PfT8UXFCPuohL6PlUBr68rZ9Nx/YMNPJ66JeWOdxA+sgMTiuQbUt2Dkn7JDTHbOIaMrqFKNtmurLHKESQ=
X-Received: by 2002:a81:12cb:0:b0:35c:b2a7:45f5 with SMTP id
 194-20020a8112cb000000b0035cb2a745f5mr25369182yws.332.1665577921598; Wed, 12
 Oct 2022 05:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221012103844.1095777-1-luwei32@huawei.com>
In-Reply-To: <20221012103844.1095777-1-luwei32@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Oct 2022 05:31:50 -0700
Message-ID: <CANn89iL3iWQkhbJ1-YgJ_DQErkhB6=rOD_JuJBiJaEb+36QrkA@mail.gmail.com>
Subject: Re: [PATCH -next] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, Oct 12, 2022 at 2:35 AM Lu Wei <luwei32@huawei.com> wrote:
>
> The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
> in tcp_add_backlog(), the variable limit is caculated by adding
> sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
> of u32 and be truncated. So change it to u64 to avoid a potential
> signed-integer-overflow, which leads to opposite result is returned
> in the following function.
>
> Signed-off-by: Lu Wei <luwei32@huawei.com>

You need to add a Fixes: tag, please.

> ---
>  include/net/sock.h  | 4 ++--
>  net/ipv4/tcp_ipv4.c | 6 ++++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 08038a385ef2..fc0fa29d8865 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1069,7 +1069,7 @@ static inline void __sk_add_backlog(struct sock *sk, struct sk_buff *skb)
>   * Do not take into account this skb truesize,
>   * to allow even a single big packet to come.
>   */
> -static inline bool sk_rcvqueues_full(const struct sock *sk, unsigned int limit)
> +static inline bool sk_rcvqueues_full(const struct sock *sk, u64 limit)
>  {
>         unsigned int qsize = sk->sk_backlog.len + atomic_read(&sk->sk_rmem_alloc);

qsize would then overflow :/

I would rather limit sk_rcvbuf and sk_sndbuf to 0x7fff0000, instead of
0x7ffffffe

If really someone is using 2GB for both send and receive queues,  I
doubt removing 64KB will be a problem.
