Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322F454574E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiFIWWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 18:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiFIWWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 18:22:31 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1526D942
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 15:22:26 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id i66so33521881oia.11
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 15:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mYG71zyz/SPXXyMsRW0M/+syUQ4xnWNQdng1XXVyMeg=;
        b=kUYk5aKK8Gcenrn6VsrYrfD7GOTSn0xPHMsH7v5/p1KzkgwSpRj9nJoH/DIDBhUrrL
         j+oGrjkg9457GhpZn/IRiDYnA6oQiMv91l4sak5sAppAxn3SzfNUG/OyJwrB0h3LXDqk
         BpplcVZLalEAYDoRZO0dyjxONiEfxa3yYFJ1aJjQfVW6fD1cXn8gaHsxZ7lXLrVFmyAi
         tu0nFnPYM9ilcHwzTPuDYdwaA8jsf+tZLUVnEXNIoQBLmLmgNVR59PDH4Lxdh+lVoLzS
         TpDS0M+wsrI73UDcGzN5Gs5eRzjBFxvsfK2XAjNRsdkL840TrxsArxmlBcZdUwdcURCH
         lk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mYG71zyz/SPXXyMsRW0M/+syUQ4xnWNQdng1XXVyMeg=;
        b=Ly8wkvYHCCZ0IPZV9EMHnzrtfS/8gpFum42vxA6wtRjWlEPQid2O+r2OzMh61InfFB
         rGKBmZawQtTmvsrmdUK0MwH7mge95iHBeVFZO6Un6bWvxUGiumy7SSAq+Nl53d7RaSWp
         +BLK/uonk6YteZl6JP+VCmEfM5SRVeVwLABt0RIrrL+RbGxCJk2imssArJgzBAGb0ejE
         ceJTApSGpAttyhgv+xSDd/CYoAm2C9pSilloW7bXmzb/xaC/vDzhq9PunwAZe+bJes2v
         I7HhosfTZAUHeuUKFoKR0UvjmuztvORuK+OHGl8t2XrSX+fQBRohBjxuAs2252vhQTHp
         cmXA==
X-Gm-Message-State: AOAM533FEJUwvmY/rGDBHQ+NL1VL2VPG/1m4l4Rt3SjiYSUFeCMSfPLW
        RIKUtRaDeW8FtldorE1qNO+vB5wFqSjldz9naU4=
X-Google-Smtp-Source: ABdhPJyPIQLMoja685CD7b+09xLGlRe1+VADh35XIPvCRRa8/pqbl6myeEswQUAJr/6p6cedxD/MvA==
X-Received: by 2002:a05:6808:14c5:b0:32e:f7b9:99a2 with SMTP id f5-20020a05680814c500b0032ef7b999a2mr1541235oiw.174.1654813345096;
        Thu, 09 Jun 2022 15:22:25 -0700 (PDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id bf1-20020a056808190100b0032af3cffac7sm14242848oib.2.2022.06.09.15.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 15:22:22 -0700 (PDT)
Received: by mail-ot1-f44.google.com with SMTP id g17-20020a9d6491000000b0060c0f0101ffso6118946otl.7;
        Thu, 09 Jun 2022 15:22:22 -0700 (PDT)
X-Received: by 2002:a05:6830:348e:b0:60b:f4b:c306 with SMTP id
 c14-20020a056830348e00b0060b0f4bc306mr17525569otu.297.1654813342247; Thu, 09
 Jun 2022 15:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220609011844.404011-1-jmaxwell37@gmail.com> <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
In-Reply-To: <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
From:   Joe Stringer <joe@cilium.io>
Date:   Thu, 9 Jun 2022 15:22:10 -0700
X-Gmail-Original-Message-ID: <CAOftzPgU6EaCgf9E407JrbTfWXBYZL=nECWjySVjw8EPtJb6Cg@mail.gmail.com>
Message-ID: <CAOftzPgU6EaCgf9E407JrbTfWXBYZL=nECWjySVjw8EPtJb6Cg@mail.gmail.com>
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jon Maxwell <jmaxwell37@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, kafai@fb.com, i@lmb.io,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 1:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/9/22 3:18 AM, Jon Maxwell wrote:
> > A customer reported a request_socket leak in a Calico cloud environment. We
> > found that a BPF program was doing a socket lookup with takes a refcnt on
> > the socket and that it was finding the request_socket but returning the parent
> > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > 1st, resulting in request_sock slab object leak. This patch retains the
> > existing behaviour of returning full socks to the caller but it also decrements
> > the child request_socket if one is present before doing so to prevent the leak.
> >
> > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > thanks to Antoine Tenart for the reproducer and patch input.
> >
> > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> > Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> > Co-developed-by: Antoine Tenart <atenart@kernel.org>
> > Signed-off-by:: Antoine Tenart <atenart@kernel.org>
> > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > ---
> >   net/core/filter.c | 20 ++++++++++++++------
> >   1 file changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 2e32cee2c469..e3c04ae7381f 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> >   {
> >       struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> >                                          ifindex, proto, netns_id, flags);
> > +     struct sock *sk1 = sk;
> >
> >       if (sk) {
> >               sk = sk_to_full_sk(sk);
> > -             if (!sk_fullsock(sk)) {
> > -                     sock_gen_put(sk);
> > +             /* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> > +              * sock refcnt is decremented to prevent a request_sock leak.
> > +              */
> > +             if (!sk_fullsock(sk1))
> > +                     sock_gen_put(sk1);
> > +             if (!sk_fullsock(sk))
> >                       return NULL;
>
> [ +Martin/Joe/Lorenz ]
>
> I wonder, should we also add some asserts in here to ensure we don't get an unbalance for the
> bpf_sk_release() case later on? Rough pseudocode could be something like below:
>
> static struct sock *
> __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>                  struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
>                  u64 flags)
> {
>          struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
>                                             ifindex, proto, netns_id, flags);
>          if (sk) {
>                  struct sock *sk2 = sk_to_full_sk(sk);
>
>                  if (!sk_fullsock(sk2))
>                          sk2 = NULL;
>                  if (sk2 != sk) {
>                          sock_gen_put(sk);
>                          if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
>                                  WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
>                                  sk2 = NULL;
>                          }
>                  }
>                  sk = sk2;
>          }
>          return sk;
> }

This seems a bit more readable to me from the perspective of
understanding the way that the socket references are tracked & freed.
