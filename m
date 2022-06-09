Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DEA545704
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 00:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiFIWQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 18:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiFIWQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 18:16:07 -0400
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27CF1790B4
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 15:16:05 -0700 (PDT)
Received: by mail-oi1-f172.google.com with SMTP id k11so33491985oia.12
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 15:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I4j9Jwk3zdoer6eb+a4GYVvHMeahVKufEp5Nu9iO43w=;
        b=U4Qlr8gtKANzjwu8UyLuXSkbfGV+GDomm88tTWCv1rJUE9SPZv9AmBd0emysZ4VlOu
         t7ekbzmnw5lySfB25yZgVjL3uqGWyXKPA6qVaH/tY/lpsGpzn1gRd76ahwxykzfY/y1a
         e28mR5ssl7PEJYdCWClRPZjYxILi4POcLJp/zdOfurj4pB5iOsGUXWFRyKN4UZ+OxGOs
         0uqyAIU2wZNZUcbpuT/DD4OXt/29pwBVJGw0yZFNngr7/xASDPFDaunWinvpk7rO2tiQ
         SFCf2OOn9eY02bHlnloo6wChj8xNxxttXabq/QZkwqp2350LJJ1raNGCaLQQoZlT1qbm
         3P0g==
X-Gm-Message-State: AOAM531no76hhX2CCwPvTK3LsU0u5uM6DbuhZj7BH6QcRFmZOshQNLdR
        gbPe882sWJNLa5eHr9aCK0T/d9YQhc4K1111Tqs=
X-Google-Smtp-Source: ABdhPJz5d0hY5/eRmau24GaabIBYM73pImQnc+UEXAQSmfaNu+/y3oH6FHcnlOUb7pYKGJRJ+f5Bng1/HtTamvnMSb8=
X-Received: by 2002:a05:6808:2388:b0:32b:14cf:ad6c with SMTP id
 bp8-20020a056808238800b0032b14cfad6cmr3089193oib.100.1654812965158; Thu, 09
 Jun 2022 15:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
In-Reply-To: <20220609011844.404011-1-jmaxwell37@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 9 Jun 2022 15:15:53 -0700
Message-ID: <CAOftzPjh51QvdYYdsUFBRniHpAu=pTg5wX8T8LyhkiCze4eRVQ@mail.gmail.com>
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, atenart@kernel.org,
        cutaylor-pub@yahoo.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 6:21 PM Jon Maxwell <jmaxwell37@gmail.com> wrote:
>
> A customer reported a request_socket leak in a Calico cloud environment. We
> found that a BPF program was doing a socket lookup with takes a refcnt on
> the socket and that it was finding the request_socket but returning the parent
> LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> 1st, resulting in request_sock slab object leak. This patch retains the
> existing behaviour of returning full socks to the caller but it also decrements
> the child request_socket if one is present before doing so to prevent the leak.
>
> Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> thanks to Antoine Tenart for the reproducer and patch input.
>
> Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> Co-developed-by: Antoine Tenart <atenart@kernel.org>
> Signed-off-by:: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>  net/core/filter.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2e32cee2c469..e3c04ae7381f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  {
>         struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
>                                            ifindex, proto, netns_id, flags);
> +       struct sock *sk1 = sk;
>
>         if (sk) {
>                 sk = sk_to_full_sk(sk);
> -               if (!sk_fullsock(sk)) {
> -                       sock_gen_put(sk);
> +               /* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> +                * sock refcnt is decremented to prevent a request_sock leak.
> +                */
> +               if (!sk_fullsock(sk1))
> +                       sock_gen_put(sk1);
> +               if (!sk_fullsock(sk))
>                         return NULL;
> -               }
>         }
>
>         return sk;

Thinking through the constraints of this function:
1. If the return value is NULL, then all references taken during the
processing must be released.
2. If the return value is non-NULL, then the socket must either have
gained one reference OR it must have the SOCK_RCU_FREE flag set.
3. It also shouldn't return TIME_WAIT / request sockets (!sk_fullsock(sk)).

__bpf_skc_lookup() will give us the properties of (1)/(2) in a socket
that may or may not be `sk_is_refcounted()` at the start of the
function, so then we just need to consider the logic being changed
here.

Digging further, are these statements accurate?
* sk_to_full_sk() can either return the argument or a different listen socket.
* Iff sk1 and sk are the same, then we only need to consider (3),
hence the fullsock check, then depending on what type of socket it is,
we satisfy either (1) (current sock_gen_put() call + NULL) or (2)
(just return).
* Iff sk1 and sk are different, then we should release the reference
on sk1 and then do something with sk following the constraints above.
* Iff sk1 and sk are different, then sk must be a LISTEN socket.
* LISTEN sockets always have SOCK_RCU_FREE.
* Therefore, if sk1 and sk are different, we must release the
reference on sk1 and we do not need to take a reference on sk, and we
can just return sk.

Following the above, the implementation looks concise and follows the
logic for each case. I can't help but think that it would be easier to
read with an sk_is_refcounted() call in there though since the concern
is how the references for sk vs sk1 are tracked in this function.

Thanks,
Joe
