Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EF4554058
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 04:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356064AbiFVCBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 22:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344874AbiFVCBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 22:01:42 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E508F338A5
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 19:01:40 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3178acf2a92so114915427b3.6
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 19:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2UP0FfY48S/GQ+UTTTzqpR7H2gUdFzERdX+eb+JRsWE=;
        b=Id7OdebAnxpH6EP2kUjv0roVYkCnfdNIKultxP3EDmjMbgzaUJEbGV4IRJNuuu2bqP
         9ERqjUwZv1GAqRL+iDKc+CYeK5XhoB/cfBIrE4FXp5OdyGPvK2fZnZGFj4DpR/DSf89m
         8qFxBOFZlXPo9EalRBbBPTcKnREwe5zAc7wTsZdfkS53MA/5TaDmoEMWWEEHGK48pdlR
         oHTPXYLndGP4l4zFTJY0jaXuxLPVpLSMCDtYgPegCdqzZsHBN6WxF7rUoAj/tVQ130FK
         G2+33vUvdYv0vc42zlyzogVz2Ma+iLG8w39BMT6Dfwtj9J/vK9QY8KreXKkY5YjBmrOe
         bRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2UP0FfY48S/GQ+UTTTzqpR7H2gUdFzERdX+eb+JRsWE=;
        b=ogSgHEeLOOS3fRE58Wi5lXKiq+9YH66PbZonoecAMC1724BN/xgXstlgOkD382WuyE
         slFqtFoVWmAUSK5Tqv06HIUvnkBqlA1f6XgE2Zc7VS1GqZc7k1jmbBNTICLfY6n4Lt9q
         am4vEDEd8QN2mVLhouUTnFEjopRYwYuRtyLpg1135Az5teZ2go1880oGw7MYmqC5Njtn
         PC4lFJB0o6q40gMiSiE0JdIUoRqYVd3JcVgNCPQ8DIQSFaB/iz6s7RQtcSn8YB9y5F5Y
         Z7Kh4WwwlZ+r9pLbfJ8fr8rSOsSFCvPeZH3ON1jtC99GHaEparWAimap5fdgpUmrJAsl
         TRcA==
X-Gm-Message-State: AJIora8LlE/N/112cwg2czGCiArqjyDDAzDDOWt+X7vigyzh4um9lXIv
        66luEvyG/Ijr0jlllY7/c6yXdrX/Y51a94XKxD+sQg==
X-Google-Smtp-Source: AGRyM1tJlU2ZiZEEXptHHK1oCYQyn+oT0D2Rpa13TVTHJbkxIGpsKz+BzJl/WUiGBIBO/bmQyMxftserC7+ThEbgvUs=
X-Received: by 2002:a81:1809:0:b0:317:c014:f700 with SMTP id
 9-20020a811809000000b00317c014f700mr1332634ywy.255.1655863299919; Tue, 21 Jun
 2022 19:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220621202240.4182683-1-ssewook@gmail.com>
In-Reply-To: <20220621202240.4182683-1-ssewook@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jun 2022 04:01:28 +0200
Message-ID: <CANn89iLDyumggtUhsE-so6jN3LB=v9W8UAgOPebtESiyDONZ=w@mail.gmail.com>
Subject: Re: [PATCH] net-tcp: Find dst with sk's xfrm policy not ctl_sk
To:     Sewook Seo <ssewook@gmail.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
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

On Tue, Jun 21, 2022 at 10:23 PM Sewook Seo <ssewook@gmail.com> wrote:
>
> From: sewookseo <sewookseo@google.com>
>
> If we set XFRM security policy by calling setsockopt with option
> IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> struct. However tcp_v6_send_response doesn't look up dst_entry with the
> actual socket but looks up with tcp control socket. This may cause a
> problem that a RST packet is sent without ESP encryption & peer's TCP
> socket can't receive it.
> This patch will make the function look up dest_entry with actual socket,
> if the socket has XFRM policy(sock_policy), so that the TCP response
> packet via this function can be encrypted, & aligned on the encrypted
> TCP socket.
>
> Tested: We encountered this problem when a TCP socket which is encrypted
> in ESP transport mode encryption, receives challenge ACK at SYN_SENT
> state. After receiving challenge ACK, TCP needs to send RST to
> establish the socket at next SYN try. But the RST was not encrypted &
> peer TCP socket still remains on ESTABLISHED state.
> So we verified this with test step as below.
> [Test step]
> 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHED)=
.
> 2. Client tries a new connection on the same TCP ports(src & dst).
> 3. Server will return challenge ACK instead of SYN,ACK.
> 4. Client will send RST to server to clear the SOCKET.
> 5. Client will retransmit SYN to server on the same TCP ports.
> [Expected result]
> The TCP connection should be established.
>
> Effort: net-tcp
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Sehee Lee <seheele@google.com>
> Signed-off-by: sewookseo <sewookseo@google.com>
> ---
>  net/ipv4/ip_output.c | 7 ++++++-
>  net/ipv4/tcp_ipv4.c  | 8 ++++++++
>  net/ipv6/tcp_ipv6.c  | 7 ++++++-
>  3 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 00b4bf26fd93..26f388decee9 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, struct=
 sk_buff *skb,
>                            tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
>                            arg->uid);
>         security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
> -       rt =3D ip_route_output_key(net, &fl4);
> +#ifdef CONFIG_XFRM
> +       if (sk && sk->sk_policy[XFRM_POLICY_OUT])

sk can not be NULL here, no need to add a test against NULL.

> +               rt =3D ip_route_output_flow(net, &fl4, sk);
> +       else
> +#endif



> +               rt =3D ip_route_output_key(net, &fl4);
>         if (IS_ERR(rt))
>                 return;
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fda811a5251f..6a9afd2fdf70 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *sk,=
 struct sk_buff *skb)
>                 ctl_sk->sk_priority =3D (sk->sk_state =3D=3D TCP_TIME_WAI=
T) ?

See this sk->sk_state =3D=3D TCP_TIME_WAIT ?

>                                    inet_twsk(sk)->tw_priority : sk->sk_pr=
iority;
>                 transmit_time =3D tcp_transmit_time(sk);
> +#ifdef CONFIG_XFRM
> +               if (sk->sk_policy[XFRM_POLICY_OUT])
> +                       xfrm_sk_clone_policy(ctl_sk, sk);

At this point, sk can be a timewait socket.

A timewait socket can not be used in 2nd argument of xfrm_sk_clone_policy()=
,
because sk_policy is part of a full blown socket.

Make sure to test your patch with KASAN.

Thanks.

> +#endif
>         }
>         ip_send_unicast_reply(ctl_sk,
>                               skb, &TCP_SKB_CB(skb)->header.h4.opt,
> @@ -827,6 +831,10 @@ static void tcp_v4_send_reset(const struct sock *sk,=
 struct sk_buff *skb)
>                               transmit_time);
>
>         ctl_sk->sk_mark =3D 0;
> +#ifdef CONFIG_XFRM
> +       if (ctl_sk->sk_policy[XFRM_POLICY_OUT])
> +               xfrm_sk_free_policy(ctl_sk);
> +#endif

Simply call xfrm_sk_free_policy(ctl_sk);

No need for #ifdef CONFIG_XFRM, no need for if
(ctl_sk->sk_policy[XFRM_POLICY_OUT])

>         sock_net_set(ctl_sk, &init_net);
>         __TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
>         __TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index c72448ba6dc9..f731884cda90 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -952,7 +952,12 @@ static void tcp_v6_send_response(const struct sock *=
sk, struct sk_buff *skb, u32
>          * Underlying function will use this to retrieve the network
>          * namespace
>          */
> -       dst =3D ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL)=
;
> +#ifdef CONFIG_XFRM
> +       if (sk && sk->sk_policy[XFRM_POLICY_OUT])
> +               dst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* Get=
 dst with sk's XFRM policy */
> +       else
> +#endif
> +               dst =3D ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl=
6, NULL);
>         if (!IS_ERR(dst)) {
>                 skb_dst_set(buff, dst);
>                 ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
> --
> 2.37.0.rc0.104.g0611611a94-goog
>
