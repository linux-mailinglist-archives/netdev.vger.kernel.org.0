Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E326F068F
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 15:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243323AbjD0NYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 09:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243570AbjD0NYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 09:24:16 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E3346AB
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:24:09 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-329577952c5so433165ab.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682601848; x=1685193848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ztvc59BVtQVwSLUp1d5KqNO0RDhBpModEBe9X8WfsM8=;
        b=7tCTfV1FoufA/7TFAOHjLqTnsPiG7agmrT6vENctJMcz3LHQyuiT4n3n8SyyLl3jUX
         ZTlAPjydpvq8K2QiOiaOB04b9WX7l4uh5SfoHbfRyV1vIZ0mz6z4UCwdC3k9qruSi3lQ
         CKx9WY+s/sU8iDAUF78W6OYcF3uAjw4ZZW0+OzObZ4QedoxZtTiBiSClZ+Pe3jgNx9il
         2IQcMeR//bSMthGPjhoIcGXBkI1JZZNXYknEQTEGIlzJKfuukd1xlM1s5nr3fBRmIU8r
         KFTDexDdRGF88jSBlethcijNWo+Qs78cxM8uxtxUT8/tsGWzE5/4c0GP02oeK3qq6pOH
         6aRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682601848; x=1685193848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ztvc59BVtQVwSLUp1d5KqNO0RDhBpModEBe9X8WfsM8=;
        b=kxzpTg/N7pEXfRyFhPnkd7mI0BnpwVWLD+RwcazEDco9lFIRCwwVw9HjfYEJut8qN+
         8Wn+YjRSN8kqb3vdaFsGWoUDnordSLije4S79XImFqKNnT3jXHk9czDnxiQVTJ04ejSd
         7xWy7VKedAYQ/ihLB7/mE/2aULGbcNjpkUexKyjg+vaP8ln3qIu1fLYMlCLdZ/xo7rw1
         5ZBBSKs3jRefBu+kOQcwVGT512VjQi/DJz7c+XM7ZHq4awQHFo/P03NeIg0ts2QIn8IV
         22mK28PIv5GYeE0w2bwJA+FoL5IRfhN2iZbJPhcepzuSwDbimpzhtDQ7eBknb0xpV16d
         +JjQ==
X-Gm-Message-State: AC+VfDyyuBNt0RU+fUNV/4vZ35hRyvWvsKNv3ihhxtgxootSG9B6DoNF
        KuWMgDD11gBXWaaS85E7/lWAPvAtoK9EcsvfLp/XzuyHNZPvUCODpmM=
X-Google-Smtp-Source: ACHHUZ4gVnrmP4/7XqELs72391Z23nc13TBw2E2OhiJz/ClFMZdXQHyk/w9WbiY7GlMwVOoebuN97UlUH6cz+RbHwSI=
X-Received: by 2002:a05:6e02:1688:b0:326:55d0:efad with SMTP id
 f8-20020a056e02168800b0032655d0efadmr218173ila.12.1682601848202; Thu, 27 Apr
 2023 06:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230427092159.44998-1-atenart@kernel.org>
In-Reply-To: <20230427092159.44998-1-atenart@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Apr 2023 15:23:56 +0200
Message-ID: <CANn89i+5QO0a-unNjMRHWqCtp6-SsXs7ERTQXS5ybSFo+G2uUQ@mail.gmail.com>
Subject: Re: [PATCH net] net: ipv6: fix skb hash for some RST packets
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Apr 27, 2023 at 11:22=E2=80=AFAM Antoine Tenart <atenart@kernel.org=
> wrote:
>
> The skb hash comes from sk->sk_txhash when using TCP, except for some
> IPv6 RST packets. This is because in tcp_v6_send_reset when not in
> TIME_WAIT the hash is taken from sk->sk_hash, while it should come from
> sk->sk_txhash as those two hashes are not computed the same way.
>
> Packetdrill script to test the above,
>
>    0 socket(..., SOCK_STREAM, IPPROTO_TCP) =3D 3
>   +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) =3D 0
>   +0 connect(3, ..., ...) =3D -1 EINPROGRESS (Operation now in progress)
>
>   +0 > (flowlabel 0x1) S 0:0(0) <...>
>
>   // Wrong ack seq, trigger a rst.
>   +0 < S. 0:0(0) ack 0 win 4000
>
>   // Check the flowlabel matches prior one from SYN.
>   +0 > (flowlabel 0x1) R 0:0(0) <...>
>
> Fixes: 9258b8b1be2e ("ipv6: tcp: send consistent autoflowlabel in RST pac=
kets")
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---

Good catch, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
