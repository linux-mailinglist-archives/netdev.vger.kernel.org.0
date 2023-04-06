Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8806D93AD
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbjDFKHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbjDFKHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:07:32 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2E47EDC
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 03:07:11 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i6so45589549ybu.8
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 03:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680775629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPaphp2tc5ZAbMuuvhwOMMZGr+8kgp4Gp0/jhl7VKAk=;
        b=N+ytqlapWiaqKzCXNf3wvkRNfa8FRfybOPKYoCE565ec5gGLn21OBVJxBTJwxm7IgP
         VKHGCc08+A5iYmUIFNzG/mGUhl7KnhSsn7j4tVw/0vJ9NUJXX4pJN328HW2hl8IBTyGj
         RdZhvaGuH0ubhVWBl7M63kp1pZWnoQ2P2SCHvwuU22rwIJWk5Sa8ZckTxhZ5R0AVDveo
         CpR0izpAkZrIlk+AMUjNxsjOCG7TBhpaHE2+FybQjeSsz7HCQSwdlXKMczC1xeyI2U/x
         6WtJMsS5kQZjn07rCqM0WK85njLtU4OSvKwG4DuwKmf1tdRMUhEwmCa8uoxN+4kAlRFz
         8P8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680775629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zPaphp2tc5ZAbMuuvhwOMMZGr+8kgp4Gp0/jhl7VKAk=;
        b=1yTyZSwexgxBuWXZ8sM/FC6ZkTaE5jD3RN1z2IVnlq70BEoPdl/xOifKTlxAQzbjPD
         0Mmvgyws8X68CKdKz8QCyDCMfyF1jtzD05NHXqonKhye+jtJWfUEqiBnQ/UONJzMCZ7c
         Wo9I+NuodKqsxFqW/ZEiFEeEiZKqHF4MdQ7wCIEQMydCbliFJqm0+JLIakpsMmm5AbFU
         OTgoj05T+ohh54ZjOxXgureSRqVzCTRq58Wa5xzQt35JUkYaaCdki7ezWmVeMfBOecLm
         RphwAkQt837kUT4usG6JEwk3EJp9Oeog2yziWThJr7Q+v0YP5zHTtcNCarZlgjjTHgUU
         TAfA==
X-Gm-Message-State: AAQBX9e80gpCqy+P5MmV4gqgNTBYMwnrKj0cjPwG1KZlJL4Ql5rEyAEI
        sxO4/rY9pstVgCe/TYRJoF9pKdT/P56AO7SRtf1WRv8eTGnvUHJn5E28uw==
X-Google-Smtp-Source: AKy350YikzV3T/i404fVAj6Dg/YmJ1h6JqKNInN7T9LTo/K+1cUIq8Cadymli/rfOe8LhKLr0q9UqSkAJO3eoohjgJg=
X-Received: by 2002:a25:d285:0:b0:b75:8ac3:d5d2 with SMTP id
 j127-20020a25d285000000b00b758ac3d5d2mr1725101ybg.4.1680775629278; Thu, 06
 Apr 2023 03:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230406031136.2814421-1-william.xuanziyang@huawei.com>
In-Reply-To: <20230406031136.2814421-1-william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Apr 2023 12:06:58 +0200
Message-ID: <CANn89iL5HUHTC19nCQLYhAExss_j2sHP4jjmZDJR4+4raaWg8w@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: Fix potential uninit variable access buf in __ip_make_skb()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, dlstevens@us.ibm.com
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

On Thu, Apr 6, 2023 at 5:11=E2=80=AFAM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Like commit ea30388baebc ("ipv6: Fix an uninit variable access bug in
> __ip6_make_skb()"). icmphdr does not in skb linear region under the
> scenario of SOCK_RAW socket. Access icmp_hdr(skb)->type directly will
> trigger the uninit variable access bug.
>
> Use a local variable icmp_type to carry the correct value in different
> scenarios.
>
> Fixes: 96793b482540 ("[IPV4]: Add ICMPMsgStats MIB (RFC 4293)")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/ipv4/ip_output.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 4e4e308c3230..57921b297a8e 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1570,9 +1570,15 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
>         cork->dst =3D NULL;
>         skb_dst_set(skb, &rt->dst);
>
> -       if (iph->protocol =3D=3D IPPROTO_ICMP)
> -               icmp_out_count(net, ((struct icmphdr *)
> -                       skb_transport_header(skb))->type);
> +       if (iph->protocol =3D=3D IPPROTO_ICMP) {
> +               u8 icmp_type;
> +
> +               if (sk->sk_socket->type =3D=3D SOCK_RAW && !inet_sk(sk)->=
hdrincl)

What is the reason for not using sk->sk_type ?

> +                       icmp_type =3D fl4->fl4_icmp_type;
> +               else
> +                       icmp_type =3D icmp_hdr(skb)->type;
> +               icmp_out_count(net, icmp_type);
> +       }


>
>         ip_cork_release(cork);
>  out:
> --
> 2.25.1
>
