Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1160A6CF483
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 22:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjC2U0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 16:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjC2U0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 16:26:54 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F4C40FE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 13:26:51 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e13so7400354ioc.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 13:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680121611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=359AViNSJCKquU5T0vPvFTncgroYRhZfZb/8qRGhbxo=;
        b=iWbWFFw5VO/1DPu7+6uNFeLX4FkGsp899lyVOinba9cFn/HDB3H86z9j/YiT5b5IFv
         2PJmq6GNB9/sK0zQsT9VEgHKFBeEDvH9NZnDirLBaYn8R9i9vHfZ3APxw88nhJyVZ07K
         dk6L1y2gH9JcghwyuL9YPg8sK9fNZeAyAryZRbEiFnrBechwWzH2CmC8TwFwuOFmt1cA
         EHICzpMPIGkPirXqqQTfYrVEtcCewoZjWKhGFM1zJ1R7rxR3WXSH9dH2rOySmzhIKMwd
         uJtY9GDyEN8OYBI7pH4gbgFm0F/09/dLEHm9un1QiHw2KdBE1gUJ7E+//n++QnXloXK4
         sreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680121611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=359AViNSJCKquU5T0vPvFTncgroYRhZfZb/8qRGhbxo=;
        b=shEpl8E43HCKxvG6pM8YrpQNdvVZ/VF2nHYerqoJP3VVJGaR+mgZxlXiwFLZ683+AA
         k4P8bj7tagXRafM91F1eAh7py/qi/toYOq38LaDdDjGwBHF7+cKLbYMlTS4I6PO+GeoA
         AgJqmDsdMjKxCQg3aZxqOP1kqUlVyBZS199ZbTGDB0vmUbQViw2Tx0WYLpySgWviYDvI
         ZqAuX1SivECEvrqbnd4yNvL6cdyPxTq9zCJA0OXWnuxLmlw3e4x6wxL4rwTvWqy24EQt
         EwqQuvVeXF/M9FEeQ2xWSJxOmuGyjc4ZSYfDjqijlJvM7zskEi8xcWkvJABML4oD8IAa
         QpzQ==
X-Gm-Message-State: AO0yUKV0ZfVvFicpTUUf8B+e96nqZKB/aUlLTIMmCEewdAVb+669C4gr
        meOFVpA7CpYLeIxp4ATgdWdLUKT0KW03CF3h1BKE7g==
X-Google-Smtp-Source: AK7set+qu9VQI4SotrXeyUM5hzUtsVRn9QXfkA1oXk1LPpUOkWRkWKbrxXXyTfeO6gvkkohgN5oh4hPDOBTUzT2DekI=
X-Received: by 2002:a5e:c810:0:b0:74c:bb62:6763 with SMTP id
 y16-20020a5ec810000000b0074cbb626763mr7765447iol.1.1680121611089; Wed, 29 Mar
 2023 13:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201348.79003-1-kuniyu@amazon.com>
In-Reply-To: <20230329201348.79003-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 29 Mar 2023 22:26:35 +0200
Message-ID: <CANn89i+V4_kZ1Lbf-4Y22tx1EWBFEdaW5RLm7ud9h8k6gk_mFg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] tcp: Refine SYN handling for PAWS.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Jason Xing <kerneljasonxing@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:14=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.c=
om> wrote:
>
> Our Network Load Balancer (NLB) [0] has multiple nodes with different
> IP addresses, and each node forwards TCP flows from clients to backend
> targets.  NLB has an option to preserve the client's source IP address
> and port when routing packets to backend targets. [1]
>
> When a client connects to two different NLB nodes, they may select the
> same backend target.  Then, if the client has used the same source IP
> and port, the two flows at the backend side will have the same 4-tuple.
>
> While testing around such cases, I saw these sequences on the backend
> target.
>
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2819965599, win 62=
727, options [mss 8365,sackOK,TS val 1029816180 ecr 0,nop,wscale 7], length=
 0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3040695044, ack 2=
819965600, win 62643, options [mss 8961,sackOK,TS val 1224784076 ecr 102981=
6180,nop,wscale 7], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 1, win 491, option=
s [nop,nop,TS val 1029816181 ecr 1224784076], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2681819307, win 62=
727, options [mss 8365,sackOK,TS val 572088282 ecr 0,nop,wscale 7], length =
0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 1, win 490, option=
s [nop,nop,TS val 1224794914 ecr 1029816181,nop,nop,sack 1 {4156821004:4156=
821005}], length 0
>
> It seems to be working correctly, but the last ACK was generated by
> tcp_send_dupack() and PAWSEstab was increased.  This is because the
> second connection has a smaller timestamp than the first one.
>
> In this case, we should send a dup ACK in tcp_send_challenge_ack()
> to increase the correct counter and rate-limit it properly.
>
> Let's check the SYN flag after the PAWS tests to avoid adding unnecessary
> overhead for most packets.
>
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/int=
roduction.html [0]
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/loa=
d-balancer-target-groups.html#client-ip-preservation [1]
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
