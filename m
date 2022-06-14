Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807F054A365
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 03:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbiFNBF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 21:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbiFNBF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 21:05:57 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB5630548;
        Mon, 13 Jun 2022 18:05:56 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id d6so5545529ilm.4;
        Mon, 13 Jun 2022 18:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i79EkBhkPIyeEclK83vYe/WWgIUjIHUtUL15eE6Q/6M=;
        b=Ocwtq7ECt7BU1qiAaarMmKL2+8gfQj7WEXeFDOVcsSoRZakYjdP5JJPSO2IoRCkR7p
         9kLnFOMkG5HBgk/FST+gOuyGDns4vesbNoNHL95Jy9YAzrTzoJQvFWGbxFslPVUau0N1
         sm13fsJBzdNUvuSKol9GXD0oc+J7kcWHlLOZRrx1H7VSYuCuZnpj9pASTYAMKwBibLbf
         8MPLPwZjRIxfmoW3JL28kmlex77kulqYkLQ5qCkjV0rGs9zTTYt7ujZOAII8ahQJmgpB
         G+vtg7/z1X/+6MG9ib5ehMCCk/VjqDBrnexKSyuBOgU9CT12jMMTXTNXl3+//YvGVXqc
         4EyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i79EkBhkPIyeEclK83vYe/WWgIUjIHUtUL15eE6Q/6M=;
        b=OjP2m7G/AvZU6PLhZqjlSxxJjwdj3ofu7t3BoY08B4sjFSpLjUnXBp0/sWTHSDqCRR
         kFHeFdB7nv0cmcTojxSZtAn3sZvLP0az5dGvU0f3uwsIs+46elXDsvmtCcWEIEq0tJ7O
         1xgt2nqZxGRi0v/09y2RB9VmcAG6bdLZQoE2AShbCpZNUX09vDVH3IU3Agfn2mM2PXaz
         D7pFbWxQdvebAZcSSrqQgWp+jraBruHaaLVwk48390xT5uZVNeRYBUpU0dh/vRx5M+yy
         Y5Is4Kypg82Abfqc5IRoKfgOaNdLCI6UWtHf4DoCHtOYtqN3ncSs3uPCIw07+cEBpNRQ
         PrdQ==
X-Gm-Message-State: AJIora/WusF32v9XkRy19xxHaCkZ0k0Ska8DZ4Qyz5/ckQ8UDO7yfwcu
        AhK6nmUKdpw4Bv14FA3DyiekHXpfBhVYcMjN/iU=
X-Google-Smtp-Source: AGRyM1twWiZmwa8sr1CnjOZrbx3iuXD2yIOKfKOcORYnsEH3zXfyBuiTPjoWzGiZlUmbk3jMqcNgFGs5w7dfMu/QZhk=
X-Received: by 2002:a05:6e02:1d18:b0:2d3:bd9f:1a5f with SMTP id
 i24-20020a056e021d1800b002d3bd9f1a5fmr1526840ila.35.1655168755893; Mon, 13
 Jun 2022 18:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220609011844.404011-1-jmaxwell37@gmail.com> <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
 <20220610001743.z5nxapagwknlfjqi@kafai-mbp> <76972cdc-6a3c-2052-f353-06ebd2d61eca@iogearbox.net>
 <20220610175826.zbi6nwt23wky3ho2@kafai-mbp>
In-Reply-To: <20220610175826.zbi6nwt23wky3ho2@kafai-mbp>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Tue, 14 Jun 2022 11:05:20 +1000
Message-ID: <CAGHK07CaXEyjxx5QO3f5FxVrXgavCZ9TyS-tDD6SEfvdKAFp7Q@mail.gmail.com>
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Antoine Tenart <atenart@kernel.org>, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, joe@cilium.io, i@lmb.io,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 3:58 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jun 10, 2022 at 09:08:41AM +0200, Daniel Borkmann wrote:
> > On 6/10/22 2:17 AM, Martin KaFai Lau wrote:
> > > On Thu, Jun 09, 2022 at 10:29:15PM +0200, Daniel Borkmann wrote:
> > > > On 6/9/22 3:18 AM, Jon Maxwell wrote:
> > > > > A customer reported a request_socket leak in a Calico cloud environment. We
> > > > > found that a BPF program was doing a socket lookup with takes a refcnt on
> > > > > the socket and that it was finding the request_socket but returning the parent
> > > > > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > > > > 1st, resulting in request_sock slab object leak. This patch retains the
> > > Great catch and debug indeed!
> > >
> > > > > existing behaviour of returning full socks to the caller but it also decrements
> > > > > the child request_socket if one is present before doing so to prevent the leak.
> > > > >
> > > > > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > > > > thanks to Antoine Tenart for the reproducer and patch input.
> > > > >
> > > > > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > > > > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> > > Instead of the above commits, I think this dated back to
> > > 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> > >
> > > > > Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> > > > > Co-developed-by: Antoine Tenart <atenart@kernel.org>
> > > > > Signed-off-by:: Antoine Tenart <atenart@kernel.org>
> > > > > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > > > > ---
> > > > >    net/core/filter.c | 20 ++++++++++++++------
> > > > >    1 file changed, 14 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > index 2e32cee2c469..e3c04ae7381f 100644
> > > > > --- a/net/core/filter.c
> > > > > +++ b/net/core/filter.c
> > > > > @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> > > > >    {
> > > > >         struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> > > > >                                            ifindex, proto, netns_id, flags);
> > > > > +       struct sock *sk1 = sk;
> > > > >         if (sk) {
> > > > >                 sk = sk_to_full_sk(sk);
> > > > > -               if (!sk_fullsock(sk)) {
> > > > > -                       sock_gen_put(sk);
> > > > > +               /* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> > > > > +                * sock refcnt is decremented to prevent a request_sock leak.
> > > > > +                */
> > > > > +               if (!sk_fullsock(sk1))
> > > > > +                       sock_gen_put(sk1);
> > > > > +               if (!sk_fullsock(sk))
> > > In this case, sk1 == sk (timewait).  It is a bit worrying to pass
> > > sk to sk_fullsock(sk) after the above sock_gen_put().
> > > I think Daniel's 'if (sk2 != sk) { sock_gen_put(sk); }' check is better.
> > >
> > > > [ +Martin/Joe/Lorenz ]
> > > >
> > > > I wonder, should we also add some asserts in here to ensure we don't get an unbalance for the
> > > > bpf_sk_release() case later on? Rough pseudocode could be something like below:
> > > >
> > > > static struct sock *
> > > > __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> > > >                  struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
> > > >                  u64 flags)
> > > > {
> > > >          struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> > > >                                             ifindex, proto, netns_id, flags);
> > > >          if (sk) {
> > > >                  struct sock *sk2 = sk_to_full_sk(sk);
> > > >
> > > >                  if (!sk_fullsock(sk2))
> > > >                          sk2 = NULL;
> > > >                  if (sk2 != sk) {
> > > >                          sock_gen_put(sk);
> > > >                          if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
> > > I don't think it matters if the helper-returned sk2 is refcounted or not (SOCK_RCU_FREE).
> > > The verifier has ensured the bpf_sk_lookup() and bpf_sk_release() are
> > > always balanced regardless of the type of sk2.
> > >
> > > bpf_sk_release() will do the right thing to check the sk2 is refcounted or not
> > > before calling sock_gen_put().
> > >
> > > The bug here is the helper forgot to call sock_gen_put(sk) while
> > > the verifier only tracks the sk2, so I think the 'if (unlikely...) { WARN_ONCE(...); }'
> > > can be saved.
> >
> > I was mainly thinking given in sk_lookup() we have the check around `sk && !refcounted &&
> > !sock_flag(sk, SOCK_RCU_FREE)` to check for unreferenced non-SOCK_RCU_FREE socket, and
> > given sk_to_full_sk() can return inet_reqsk(sk)->rsk_listener we don't have a similar
> > assertion there. Given we don't bump any ref on the latter, it must be SOCK_RCU_FREE then
> Ah. got it.  Thanks for the explanation.
>
> Yep, agree.  It is useful to have this check here to ensure
> no need to bump the sk2 refcnt.  A comment may be useful
> here also, /* Ensure there is no need to bump sk2 refcnt */
>

I'll add that comment.

I'll add the SOCK_RCU_FREE check. We are currently testing the new patch
based on Daniels recommendation. When that is complete I'll resubmit the next
version of the patch including that. It'll probably be a few days.

Regards

Jon

> Thanks!
>
