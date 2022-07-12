Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D984E572169
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiGLQwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiGLQwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:52:04 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D733BF552
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:52:03 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-31c89653790so87028717b3.13
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tn30IFyGiCRItnn98TAi7nrAznP6tvUqE4bGKXjxky8=;
        b=pWu/7p9N/kzIeJ0+aCrvnBD0F3Orrd2YycYxndW1KklV5everL6vQzr5mxfD2XTuQA
         XEI4Ngn5MAt4UsnF76vWyMBZnWQMozWEoI6k/QYR7SyEq4IoVzSf1YtUG/dvNfNo+3mw
         GoMbqMArfcZnLoEi1dpiMkCReWp+m96doiMuXuZEBV6cOYYxQQR5pXit0Mhr42HCUs8H
         ng/iV1Vsf+08JKB55rDtIrPhVMDwM0SWfT0Fta445NMhUukG7Jy8eoR5El/pRZWGo5pt
         0YCMX/pleRq5NP9i8g55dPzqwGKYTwTEupTQfVhMXP4ex7E5D8qyoX1JTy2aVOh5qefG
         kOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tn30IFyGiCRItnn98TAi7nrAznP6tvUqE4bGKXjxky8=;
        b=sDwg47dO6l+6OB9tnL1BKR9ZIjcVun1HuCag5SL/YwL/EQm4CC6Cl0ZNK1CcGy/e6h
         U3pp/RYkdwbrdg754km7jCV/RtilMpeqX6PqV3trnpPzpE3LXe6lB6+DJqgVed2gd73b
         oI2hnAMQfbY66xjQW+b/rYib2ILRekKdP5CQZsoBp73siDmwXmo2vAiPnRq7wn1TA/O7
         8VSzSK+n2AYbQBvH15+2o4dfHFcSt8PfkHogmsv0wBxO2wYM7gJf0aQrZo3mGypMzBB6
         U6LNEWEzv+en78EW3ewsN+4bhBdw5LsoyAM/SKDHlH5VBAVXBYl9NmbjkC9M8mZuwbGC
         A96A==
X-Gm-Message-State: AJIora+9Rgee5fOlQ1ctu9Lg3X/kAFJnqGoCN9hLt7XiUuH4tTAXbF2a
        7JEtsmdk6IJr1+zoIX/mv7id/U0jP5DtBnZ8kU1bBQ==
X-Google-Smtp-Source: AGRyM1ubvwFxkTwN/np5U3cOWkinZ9KJeLNBOgVI5QY0z5i7Y7Np93uaRIUF/1wAAxz6xPfymgJBuIstA//JX8yWdhc=
X-Received: by 2002:a81:160d:0:b0:31c:8997:b760 with SMTP id
 13-20020a81160d000000b0031c8997b760mr26320482yww.489.1657644722492; Tue, 12
 Jul 2022 09:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220712163243.36014-1-kuniyu@amazon.com>
In-Reply-To: <20220712163243.36014-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jul 2022 18:51:51 +0200
Message-ID: <CANn89i+k084b4RuoOOrFzYkd9uB0GUbW7VxcCCDSpqWWJaNXnQ@mail.gmail.com>
Subject: Re: [PATCH v1 net] tcp/udp: Make early_demux back namespacified.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 6:33 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> it possible to enable/disable early_demux on a per-netns basis.  Then, we
> introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> tcp and udp").  However, the .proc_handler() was wrong and actually
> disabled us from changing the behaviour in each netns.

...

> -int tcp_v4_early_demux(struct sk_buff *skb)
> +void tcp_v4_early_demux(struct sk_buff *skb)
>  {
>         const struct iphdr *iph;
>         const struct tcphdr *th;
>         struct sock *sk;
>
>         if (skb->pkt_type != PACKET_HOST)
> -               return 0;
> +               return;
>
>         if (!pskb_may_pull(skb, skb_transport_offset(skb) + sizeof(struct tcphdr)))
> -               return 0;
> +               return;
>
>         iph = ip_hdr(skb);
>         th = tcp_hdr(skb);
>
>         if (th->doff < sizeof(struct tcphdr) / 4)
> -               return 0;
> +               return;
>
>         sk = __inet_lookup_established(dev_net(skb->dev), &tcp_hashinfo,
>                                        iph->saddr, th->source,
> @@ -1740,7 +1740,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
>                                 skb_dst_set_noref(skb, dst);
>                 }
>         }
> -       return 0;
> +       return;
>  }
>

You have a tendency of making your patches larger than needed.

If you fix a bug, please do not add 'cleanups'.
