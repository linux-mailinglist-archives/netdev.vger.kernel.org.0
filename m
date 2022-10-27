Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6088160F659
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiJ0Lj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiJ0Ljz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:39:55 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9881D674
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:39:54 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 185so1567104ybc.3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pWEvHLppfxWBW8+ISQe9vfLot+/ybDoyMJgUP6cuFrE=;
        b=QFGZm3rZ14dHWBfW+lw8P/mNPrfR5y5RthUIF/ENCUW2hh68Wr2DClFug2OMurAJtd
         5mJbtbErG2P42+bmO5HxPD3uHpN9138pZoQUGiiZf4las4E81JyKK5GZwbMQf51YAuG8
         mygIy8fEJTjZiCXqh0q1MCYLvRYOj8Oojbe3Wknjo5nH5zyCrbYarrW9STuzkZ4YA8QX
         c7Pk3JYmjiqed5CcimZt9ebZhCduc7urPX+ksaVFAkd5QlawMuaN2MLQknd2HOQe2Inl
         qTSSc1DhBR94anlu1XGklkGJ2tcAO2KoDOc06Z9XSAA54TU/UkEVD4XKqBbtICvCBHgx
         cO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pWEvHLppfxWBW8+ISQe9vfLot+/ybDoyMJgUP6cuFrE=;
        b=b2C1soX6jeN7r80i5qEuS5JpMxvGJgw+Fw8BRkhDjd4wD0S96Ou7nrKrFxYjBtBeia
         N7cYMi1tMwXJtTCwpI2v5pa/fwvp4QzhjCwliHsc5tMVjMY6sAhYd0MAoQjyxRdpEC2I
         yCTjVeqaXvLznYvbeXWEIghASO5AzCPUpRQ0klb0Job3Bfmp65obzfygq5cGmliMd6K9
         xN/GGwcIVnAKOzmgwgZg/qNPlN9C+8+xyWFMi+ikqZmgiAhRY5PxUfDZCT7S5WV+VQ1i
         RhjCsAcwZQbRy/s5azkKCMJ6cpf14VJ7RFwkjoDIZvnmA+nQOrPkTFP+3gKY9nl+714Y
         v+WA==
X-Gm-Message-State: ACrzQf0/SGJ99/Mo1Yof3G3txfK3IHMlBnsRoHNwQsew48WRn7ftr7VW
        UrT6+crtIGw+miaRpgt+No0N5+vLHewcCGz+K1Lt5Q==
X-Google-Smtp-Source: AMsMyM4XAzDPo0EgekhW6SAv2JktbvwUNrffi3GvIR1LS/T3F6+VqKzjiO2VMFrT+abtm1/+8vyVaWPklCsc+xLGC/M=
X-Received: by 2002:a25:32ca:0:b0:6ca:40e2:90c8 with SMTP id
 y193-20020a2532ca000000b006ca40e290c8mr34044036yby.55.1666870793192; Thu, 27
 Oct 2022 04:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221027102449.926410-1-william.xuanziyang@huawei.com>
In-Reply-To: <20221027102449.926410-1-william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Oct 2022 04:39:42 -0700
Message-ID: <CANn89iJkKJ3-b8vncrxgawWTtaLphYERhVma7+1qgdSEXn8tiQ@mail.gmail.com>
Subject: Re: [PATCH net] ipv6/gro: fix an out of bounds memory bug in ipv6_gro_receive()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
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

On Thu, Oct 27, 2022 at 3:25 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> IPv6 packets without NEXTHDR_NONE extension header can make continuous
> __skb_pull() until pskb_may_pull() failed in ipv6_gso_pull_exthdrs().
> That results in a big value of skb_gro_offset(), and after __skb_push()
> in ipv6_gro_receive(), skb->data will less than skb->head, an out of
> bounds memory bug occurs. That will trigger the problem as following:
>
> ==================================================================
> BUG: KASAN: use-after-free in eth_type_trans+0x100/0x260
> ...
> Call trace:
>  dump_backtrace+0xd8/0x130
>  show_stack+0x1c/0x50
>  dump_stack_lvl+0x64/0x7c
>  print_address_description.constprop.0+0xbc/0x2e8
>  print_report+0x100/0x1e4
>  kasan_report+0x80/0x120
>  __asan_load8+0x78/0xa0
>  eth_type_trans+0x100/0x260

Crash happens from eth_type_trans() , this should happen before
ipv6_gro_receive() ?

It seems your patch is unrelated.

Please provide a repro.


>  napi_gro_frags+0x164/0x550
>  tun_get_user+0xda4/0x1270
>  tun_chr_write_iter+0x74/0x130
>  do_iter_readv_writev+0x130/0x1ec
>  do_iter_write+0xbc/0x1e0
>  vfs_writev+0x13c/0x26c
>
> Add comparison between skb->data - skb_gro_offset() and skb->head
> and exception handler before __skb_push() to fix the bug.
>
> Fixes: 86911732d399 ("gro: Avoid copying headers of unmerged packets")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/ipv6/ip6_offload.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index 3ee345672849..6659ccf25387 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -237,6 +237,10 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
>                 proto = ipv6_gso_pull_exthdrs(skb, proto);
>                 skb_gro_pull(skb, -skb_transport_offset(skb));
>                 skb_reset_transport_header(skb);
> +               if (unlikely(skb_headroom(skb) < skb_gro_offset(skb))) {

This makes no sense to me.

If there is a bug, it should be fixed earlier.

> +                       kfree_skb(skb);
> +                       return ERR_PTR(-EINPROGRESS);
> +               }
>                 __skb_push(skb, skb_gro_offset(skb));
>
>                 ops = rcu_dereference(inet6_offloads[proto]);
> --
> 2.25.1
>
