Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FD76278E1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiKNJTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiKNJTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:19:33 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9235EE0E0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:19:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id f5so26735738ejc.5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xtQdNUKoXwD5Pbbd0mTkyBbYoAHEDkzfXHoS609j2qc=;
        b=d8XYmMI5Bzqb5m8BXHEXDW6WBNNR6xC/E3rPPxZmLUCMTvSMfykh3RsEvybTw0YjIg
         FY2AYLJXZohbv6QjVrJRgtGmzGFhBHcNvCIOTZyC6HzVdNXQkX6tfAgQb+jGLG8HtW4L
         uQ9GljI6Fa2FcLUccFyZXFVCaLIGPL+Mvas9e5D9enMu3SB1v/3moUXdNNkuYag/o1jk
         PXznOarpiYE1t0y643x16KwyWunc9xaHn/xa4Ml2WWmpyKb0cBH5HCZvlsJ1TEnFw46q
         iy8tT4cAi9N5QO3C6WKotVJwQuvRV4jxpwRCCw74UJID29Y8f1eqCvh9qsN0KUbIup3e
         fvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xtQdNUKoXwD5Pbbd0mTkyBbYoAHEDkzfXHoS609j2qc=;
        b=KEiYRW9RTLNIOJxCB7LPF4uIoiY2ov1tUm42IAFL51ioyMUFclmE5BNcvO0FYA+3/d
         wjeMFc6Sczky8f0sjSy46/xurdNSkFDEaHHLit3fjuPwhn5Gux3VKou3GgxqGZUN+db3
         sXzRGOjbvLUV02yeCpwuZwJqf6l66Nvpwz6lcJ8E43Pg4qubarAYGhiVfGnXbDqB4aG6
         IHzMefGCosbR5du0TFDktbNb2QDNknZikQtFXfc1uqDLA+tQHtzp8NnmdAVh4RZVJuXa
         llOgcDgUL8SRrXnQ21N3BY3gvTcW2+Nn10dmeaaa31Z97olNPHGr/XE4Z7ICe5MSmVTx
         JGhA==
X-Gm-Message-State: ANoB5pnwVpz6KPTTvB+blL86d/hpRCFa1b/tOwo0fDnWM/uMaYrvBsmB
        smB7QPFdMbJs4SIKcvABuYUHgUZrlrZV3ST4PKg=
X-Google-Smtp-Source: AA0mqf4D6E2hUo80jFlhX9LH6ee9N/IaTcGVJmWYAyiZyxyI6U9BOo6k8htH9Ye7EKa6m2fVieK4Q0Qs5cpDbQ1rBEc=
X-Received: by 2002:a17:907:1749:b0:78d:4f05:6ba7 with SMTP id
 lf9-20020a170907174900b0078d4f056ba7mr9577554ejc.590.1668417568947; Mon, 14
 Nov 2022 01:19:28 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221111091440.51f9c09e@kernel.org>
In-Reply-To: <20221111091440.51f9c09e@kernel.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 14 Nov 2022 10:13:10 +0100
Message-ID: <CAGRyCJEtXx4scuFYbpjpe+-UB=XWQX26uhC+yPJPKCoYCWMM2g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Il giorno ven 11 nov 2022 alle ore 18:14 Jakub Kicinski
<kuba@kernel.org> ha scritto:
>
> On Wed,  9 Nov 2022 19:02:48 +0100 Daniele Palmas wrote:
> > +bool rmnet_map_tx_agg_skip(struct sk_buff *skb)
> > +{
> > +     bool is_icmp = 0;
> > +
> > +     if (skb->protocol == htons(ETH_P_IP)) {
> > +             struct iphdr *ip4h = ip_hdr(skb);
> > +
> > +             if (ip4h->protocol == IPPROTO_ICMP)
> > +                     is_icmp = true;
> > +     } else if (skb->protocol == htons(ETH_P_IPV6)) {
> > +             unsigned int icmp_offset = 0;
> > +
> > +             if (ipv6_find_hdr(skb, &icmp_offset, IPPROTO_ICMPV6, NULL, NULL) == IPPROTO_ICMPV6)
> > +                     is_icmp = true;
> > +     }
> > +
> > +     return is_icmp;
> > +}
>
> Why this? I don't see it mention in the commit message or any code
> comment.

This is something I've found in downstream code: with my test setup
and scenario it does not make any difference on the icmp packets
timing (both with or without throughput tests ongoing), but I don't
have access to all the systems for which rmnet is used.

So, I'm not sure if it solves a real issue in other situations.

I can move that out and me or someone else will add it again in case
there will be a real issue to be solved.

Thanks,
Daniele
