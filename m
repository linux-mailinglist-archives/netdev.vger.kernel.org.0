Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04205665C7
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 11:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiGEJEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 05:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiGEJE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 05:04:29 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C5EC63
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 02:04:28 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id b85so7445447yba.8
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 02:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ao08zDzl4/pAwhBJDcIdMsyjb6hDUpgKFrjrEobU1mc=;
        b=pD7GVgR1ZnW1KtETxtQP3YTJ+M+wYgKXoxYGZJTAlv0T7xW/ymi656avxhZLR8ekcP
         +Ixqe/sesSfRsceP9bYGFsnpk6SDI5IIhPiPCJuyLlGLBGWpqzk7sfyGk7UNwzeaBMpC
         Dh/wvcw3z/onaoRZ2m1Ic+SbSNWZfL/l6kOTRoq9pP/8nzsNvM+gRap+m6+g4WfXcg1S
         ZTG+1D/msZYUf4IbXt/PreFO+nrVtc9cMz1tNbtpD/8is2tXmrByXYsNaCBuIW9BXuxC
         OVYLDka6OMnx8W8uFSC3huVyB+05EX0Dw0vBgprsV030wM0XGr5twkfrugOAxVujVgiA
         qm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ao08zDzl4/pAwhBJDcIdMsyjb6hDUpgKFrjrEobU1mc=;
        b=N4qdH8e2Hzdmvc6YtkvbmtThoJMS4XDNvxTfXCN0zfRYGuESt1+uGOugdVSPlJK6L8
         8upcg+MxmyjKFYYOS3FQBIDIitR/70WVkOlKLzk+lRUe44pRpMkbkLiCHG8syzrxY9z7
         KiTt8TCn7BGxZ82jZU+e1QAEh3XrAXCPLsA5YxyzHiP//BQaFBqb70TzbuwRpo3u8OBs
         7fvJnzReEMHqak4Fd2yaanco76hfMJzSJeNXrXhf4k0MqBZauZ09pUhnZl23m/0svlYS
         I2H8z7ywvc/iC1E8iHW5Jy3p8gj1WnliTfER7szHRwpJ4MlnnBCZqmO+lemr7eeLQZRe
         u18A==
X-Gm-Message-State: AJIora8D2VWK1eVUohDtqilaHoAQZbNUD6O+U7ZEYi9sTO8QU2Ous5+p
        G0rjC+jOkbXWfXsEsvMCPTJRVb/viRO92jMjtgjwFQ==
X-Google-Smtp-Source: AGRyM1tk4y/jDr/CtD2IIas2J9x/SQFT7ezGxA+h5zBalIfTpyiQLKV7zxHvnzrWOntz+PTr9mRMHjf0q1UUSvR1llA=
X-Received: by 2002:a25:d741:0:b0:66e:5fc1:3001 with SMTP id
 o62-20020a25d741000000b0066e5fc13001mr6463310ybg.231.1657011867239; Tue, 05
 Jul 2022 02:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220621202240.4182683-1-ssewook@gmail.com> <20220701154413.868096-1-ssewook@gmail.com>
In-Reply-To: <20220701154413.868096-1-ssewook@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 5 Jul 2022 11:04:16 +0200
Message-ID: <CANn89iKLuTgp7QpWB7F7gp5_nNvdOXY_Zp9xmLJMpz2kpEaHDw@mail.gmail.com>
Subject: Re: [PATCH v2] net-tcp: Find dst with sk's xfrm policy not ctl_sk
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

On Fri, Jul 1, 2022 at 5:45 PM Sewook Seo <ssewook@gmail.com> wrote:
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
> Signed-off-by: Sewook Seo <sewookseo@google.com>
> ---
> Changelog since v1:
> - Remove unnecessary null check of sk at ip_output.c
>   Narrow down patch scope: sending RST at SYN_SENT state
>   Remove unnecessay condition to call xfrm_sk_free_policy()
>   Verified at KASAN build
>
>  net/ipv4/ip_output.c | 7 ++++++-
>  net/ipv4/tcp_ipv4.c  | 5 +++++
>  net/ipv6/tcp_ipv6.c  | 7 ++++++-
>  3 files changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 00b4bf26fd93..1da430c8fee2 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, struct=
 sk_buff *skb,
>                            tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
>                            arg->uid);
>         security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
> -       rt =3D ip_route_output_key(net, &fl4);

Please avoid these #ifdef ?

You probably can write something like

     if (IS_ENABLED(CONFIG_XFRM) && sk->sk_policy[XFRM_POLICY_OUT])
         rt =3D ip_route_output_flow(net, &fl4, sk);
    else
          rt =3D ip_route_output_key(net, &fl4);

> +#ifdef CONFIG_XFRM
> +       if (sk->sk_policy[XFRM_POLICY_OUT])
> +               rt =3D ip_route_output_flow(net, &fl4, sk);
> +       else
> +#endif
> +               rt =3D ip_route_output_key(net, &fl4);
>         if (IS_ERR(rt))
>                 return;
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fda811a5251f..459669f9e13f 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *sk,=
 struct sk_buff *skb)
>                 ctl_sk->sk_priority =3D (sk->sk_state =3D=3D TCP_TIME_WAI=
T) ?
>                                    inet_twsk(sk)->tw_priority : sk->sk_pr=
iority;
>                 transmit_time =3D tcp_transmit_time(sk);
> +#ifdef CONFIG_XFRM
> +               if (sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state =3D=3D=
 TCP_SYN_SENT)
> +                       xfrm_sk_clone_policy(ctl_sk, sk);
> +#endif
>         }
>         ip_send_unicast_reply(ctl_sk,
>                               skb, &TCP_SKB_CB(skb)->header.h4.opt,
> @@ -827,6 +831,7 @@ static void tcp_v4_send_reset(const struct sock *sk, =
struct sk_buff *skb)
>                               transmit_time);
>
>         ctl_sk->sk_mark =3D 0;
> +       xfrm_sk_free_policy(ctl_sk);
>         sock_net_set(ctl_sk, &init_net);
>         __TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
>         __TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index c72448ba6dc9..453452f87a7c 100644
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
> +       if (sk && sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state =3D=3D T=
CP_SYN_SENT && rst)


Why not using sk_fullsock(sk)  instead of 'sk->sk_state =3D=3D TCP_SYN_SENT=
' ?

sk_fullsock() is really telling us if we can use sk as a full socket,
and this is all we need to know when reviewing this code.

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
> 2.37.0.rc0.161.g10f37bed90-goog
>
