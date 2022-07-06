Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1589567FAE
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiGFHUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiGFHT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:19:59 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8505412ADD
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:19:58 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 76so10279736ybd.0
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 00:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZV7aV670IW+2yCLT7LhgJ3EYsGV5I1t71hCWYrfKAiA=;
        b=euyvMPhIUoWQIbmRP0lmucU07OYXlCVQIbGQnnATHAzygGLOpgD9f4fgAt4cffMWhf
         +aAeuDpAfd0p29r/1CMMhYzrLOHHAPM4B/KtlwzbVwD/AeupzIworVAtffzShG9uONUp
         /+VN8CsjIeMXOHGRgWNXsMrFswnL2s+3hFTPe9Ad0eaKLvT+fGp1ZtYNiCSGA2eL3Cwt
         3T3TLmnqAAamFgMCs67O6uE6Ln2HbbchoIYnWg2MY8LScrF+NH0hR8UC5r1UfIQ6vXLQ
         CkfSo8GXtjUZkZLBIjtWkuKrERz9jAqm5qyVIyrKoV9OEGUHgllTma7F+ln28aAS72mt
         XioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZV7aV670IW+2yCLT7LhgJ3EYsGV5I1t71hCWYrfKAiA=;
        b=fhhatj5pMC1CITFuNsTzGZ3hLytJYkiyUHKX3aVhCawaE5yff8SGMsMtKQrW6EEGCr
         w2Op1XB3ND/xFrmuXoCTZvS0j21bfSgmAZZFHglxCCalxzsMgkxvzrBEQjK9yM8Mol5H
         Dns2iot5APPD7pnCf6M4lUeZCGtOqOQ+2RWnXqKTNwPlsjaL1fxcJwi5O8X4iry6WpfY
         RkAeAvERdg/UAmmrDKI8nF1GftqlmRCNRGlmt7soDrsvxU5wKNmPbxqu9ulFTRwfrzYQ
         fVUNV9qq4nEsaQyKCiieUl+3NPWUo6dhqfzNImnsfmZk/0hFiEhtZlnzicEAsFK+dcIK
         kudg==
X-Gm-Message-State: AJIora9AyvgqgaiGUmltjid95GtJPvjijNW5A9EBedpB4xW5MMSis2NM
        irEUDueQjYykfllsbPyxU1TP+QQflzsycsMMUGjYUA==
X-Google-Smtp-Source: AGRyM1u0MHIDCjgpoMcI1hQaS83bp2N5DJPPbOaUGxNNHGGVQmXWiJUuHSJIRVptpJcKp6ICohi3JVyi1PfgyugzEsY=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr43909965ybh.36.1657091997552; Wed, 06
 Jul 2022 00:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220621202240.4182683-1-ssewook@gmail.com> <20220706063243.2782818-1-ssewook@gmail.com>
In-Reply-To: <20220706063243.2782818-1-ssewook@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Jul 2022 09:19:46 +0200
Message-ID: <CANn89iJiod_=AGbKM=-5cGvDQjUzxLm88Zg6UU2T8Mvj6nAcOQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] net: Find dst with sk's xfrm policy not ctl_sk
To:     Sewook Seo <ssewook@gmail.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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

On Wed, Jul 6, 2022 at 8:34 AM Sewook Seo <ssewook@gmail.com> wrote:
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
> Effort: net

Please remove this Effort: tag, this is not appropriate for upstream patche=
s.

> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Sehee Lee <seheele@google.com>
> Signed-off-by: Sewook Seo <sewookseo@google.com>
> ---
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
> +#ifdef CONFIG_XFRM
> +       if (sk->sk_policy[XFRM_POLICY_OUT])
> +               rt =3D ip_route_output_flow(net, &fl4, sk);
> +       else
> +#endif
> +               rt =3D ip_route_output_key(net, &fl4);

I really do not like adding more #ifdef

What happens if we simply use :

      rt =3D ip_route_output_flow(net, &fl4, sk);




>         if (IS_ERR(rt))
>                 return;
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fda811a5251f..3c2ab436c692 100644
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
> +               if (sk->sk_policy[XFRM_POLICY_OUT] && sk_fullsock(sk))
> +                       xfrm_sk_clone_policy(ctl_sk, sk);
> +#endif

What happens if we simply use

                           xfrm_sk_clone_policy(ctl_sk, sk);

(and move the check about sk_full_sock() in  xfrm_sk_clone_policy() instead=
 ?

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9287712ad97727aa781787b09fa5f6b101b8146b..a6b3ff073d05f1be9908f96ae7d=
4aab2469daee1
100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1195,6 +1195,8 @@ int __xfrm_sk_clone_policy(struct sock *sk,
const struct sock *osk);

 static inline int xfrm_sk_clone_policy(struct sock *sk, const struct sock =
*osk)
 {
+       if (!sk_fullsock(osk))
+               return 0;
        sk->sk_policy[0] =3D NULL;
        sk->sk_policy[1] =3D NULL;
        if (unlikely(osk->sk_policy[0] || osk->sk_policy[1]))


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
> index c72448ba6dc9..8b8819c3d2c2 100644
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
> +       if (sk && sk->sk_policy[XFRM_POLICY_OUT] && sk_fullsock(sk))
> +               dst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* Get=
 dst with sk's XFRM policy */
> +       else
> +#endif
> +               dst =3D ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl=
6, NULL);

and then:

     dst =3D ip6_dst_lookup_flow(net, sk, &fl6, NULL);



>         if (!IS_ERR(dst)) {
>                 skb_dst_set(buff, dst);
>                 ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>
