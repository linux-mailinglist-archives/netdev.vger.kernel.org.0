Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA6560F954
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiJ0Nj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbiJ0Njz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:39:55 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D2917AAA
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:39:53 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id m125so2018861ybb.6
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T7RxfUpE+B/HYJd5zuMNI1CVQxXADlNT94gOnJfbWU8=;
        b=Mj/q7HNYsLLDCbO1NTCyj3g6/R8aSY3UUT/VO+0/Kv48WUGGEsM9f7fNdc3ZN49w6k
         OduPhKZAxfdbbNIzfzJc+G/RceTUjpH/M+x3W2VgMyuSZDnpx4yI2+aYQrD3fD2DfBlR
         GY3ggAswiGb11ShtenAInjlIxA664H6r8g0YyIumF0vHp5072mlQe3F8r8ON4KVIeZv+
         W95DZDD1WCFP0OCqqbGJhxnsk3DPVotETTC1G5EhEU/0lel2iRvSHD0QhUrIaqnkxnTX
         8zMhfIbuqvW7+U+Y0Wc2C6eUiX+G43fTDhJIZO2oFhjEGrSeXFIjp+2Se4l2U6vx2/h0
         QbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T7RxfUpE+B/HYJd5zuMNI1CVQxXADlNT94gOnJfbWU8=;
        b=lLcK8Hn+ok/R3MF/oogPUnekjsvhgIXa2quRyTDYHtYJiHSgairoQ4niQO6DlwR/HD
         88OK6+D5VoaUEaLWhs5mNirjYFvUGe+7b0AZFYdiP1UG3tv2A6swQ/LhlLhwoSyaoxON
         7XF4I1GAeKYukKe5d9OJI3bimdVuvwU9wyRC4f922D5Yps1t4l/3iI6NA13vnH6Jy0/n
         tuwxnHX2agrd3hSEul14Qa5iRSWls8SANIuIAqGytVaDe4Fq67k7WDvxw5SOKPdFBY5d
         JFR2sHw3qPC9btA/z20UKfDHVUH+Zzo/K+AbjZmd6HR7qDZrhLQby7Eywx4+2huK38Ng
         RyXw==
X-Gm-Message-State: ACrzQf38IfEEjjnaOAFKP3sd5rfBJ3/jbB69mcCTvquLc4LUe9Z4YWH5
        fatpAZTGM948koGH821xj4ZRtUpd7nzBD1LbGgFsJQ==
X-Google-Smtp-Source: AMsMyM7FaeVUsOl4ZXpzdSIIGTvEVJeq7ijb6oQekn41n7jUMVcDFH424GiYBNtVIxFyKBB8e/h5UlmX6izq4gYKueY=
X-Received: by 2002:a25:6647:0:b0:6cb:8601:238a with SMTP id
 z7-20020a256647000000b006cb8601238amr11408366ybm.598.1666877992173; Thu, 27
 Oct 2022 06:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20221027102449.926410-1-william.xuanziyang@huawei.com>
 <CANn89iJkKJ3-b8vncrxgawWTtaLphYERhVma7+1qgdSEXn8tiQ@mail.gmail.com> <8523b754-992d-0d72-ecd1-4f076e57ebde@huawei.com>
In-Reply-To: <8523b754-992d-0d72-ecd1-4f076e57ebde@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Oct 2022 06:39:41 -0700
Message-ID: <CANn89i+FYGkR5_-C3wp7GdpW=JT8V5LELwMNcHg9Gt6=e877JA@mail.gmail.com>
Subject: Re: [PATCH net] ipv6/gro: fix an out of bounds memory bug in ipv6_gro_receive()
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
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

On Thu, Oct 27, 2022 at 6:01 AM Ziyang Xuan (William)
<william.xuanziyang@huawei.com> wrote:
>
> > On Thu, Oct 27, 2022 at 3:25 AM Ziyang Xuan
> > <william.xuanziyang@huawei.com> wrote:
> >>
> >> IPv6 packets without NEXTHDR_NONE extension header can make continuous
> >> __skb_pull() until pskb_may_pull() failed in ipv6_gso_pull_exthdrs().
> >> That results in a big value of skb_gro_offset(), and after __skb_push()
> >> in ipv6_gro_receive(), skb->data will less than skb->head, an out of
> >> bounds memory bug occurs. That will trigger the problem as following:
> >>
> >> ==================================================================
> >> BUG: KASAN: use-after-free in eth_type_trans+0x100/0x260
> >> ...
> >> Call trace:
> >>  dump_backtrace+0xd8/0x130
> >>  show_stack+0x1c/0x50
> >>  dump_stack_lvl+0x64/0x7c
> >>  print_address_description.constprop.0+0xbc/0x2e8
> >>  print_report+0x100/0x1e4
> >>  kasan_report+0x80/0x120
> >>  __asan_load8+0x78/0xa0
> >>  eth_type_trans+0x100/0x260
> >
> > Crash happens from eth_type_trans() , this should happen before
> > ipv6_gro_receive() ?
> >
> > It seems your patch is unrelated.
> >
> > Please provide a repro.
>
> C repro put in attachment.

This seems to be a bug in tun device.

Please take more time to root cause this issue, instead of adding work
arounds all over the place.

Thanks.

>
> >
> >
> >>  napi_gro_frags+0x164/0x550
> >>  tun_get_user+0xda4/0x1270
> >>  tun_chr_write_iter+0x74/0x130
> >>  do_iter_readv_writev+0x130/0x1ec
> >>  do_iter_write+0xbc/0x1e0
> >>  vfs_writev+0x13c/0x26c
> >>
> >> Add comparison between skb->data - skb_gro_offset() and skb->head
> >> and exception handler before __skb_push() to fix the bug.
> >>
> >> Fixes: 86911732d399 ("gro: Avoid copying headers of unmerged packets")
> >> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> >> ---
> >>  net/ipv6/ip6_offload.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> >> index 3ee345672849..6659ccf25387 100644
> >> --- a/net/ipv6/ip6_offload.c
> >> +++ b/net/ipv6/ip6_offload.c
> >> @@ -237,6 +237,10 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
> >>                 proto = ipv6_gso_pull_exthdrs(skb, proto);
> >>                 skb_gro_pull(skb, -skb_transport_offset(skb));
> >>                 skb_reset_transport_header(skb);
> >> +               if (unlikely(skb_headroom(skb) < skb_gro_offset(skb))) {
> >
> > This makes no sense to me.
> >
> > If there is a bug, it should be fixed earlier.
>
> Maybe it is good to validate IPv6 packet earlier in ipv6_gro_receive() or more earlier?
>
> >
> >> +                       kfree_skb(skb);
> >> +                       return ERR_PTR(-EINPROGRESS);
> >> +               }
> >>                 __skb_push(skb, skb_gro_offset(skb));
> >>
> >>                 ops = rcu_dereference(inet6_offloads[proto]);
> >> --
> >> 2.25.1
> >>
> > .
> >
