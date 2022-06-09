Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD6A544DCC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbiFINf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343869AbiFINf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:35:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9B44B86D
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:35:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0315361D41
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 13:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6CFC34114;
        Thu,  9 Jun 2022 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654781725;
        bh=aKFwRxrLeZ1Jm9AKt4HneNtBVicSwksGlK16+1EEMec=;
        h=In-Reply-To:References:Cc:From:Subject:To:Date:From;
        b=O0QAhzvoc30BjiYYaIYaIeINkm5S6/lWwmktOtqSoF7vxA0fDkklak1YTJmg867DH
         IffrzCy/oaaTeWSm8IpdBtSqyjXPVnT2HB4kKYH5KXaXEkM3kvHRGk4Vl60pcsIaop
         tpwTDIj4G5vPWYfP54oHpOsr8fV2eiResaAgl/rbLrsbVdH9eIyb9x/Pj830ZwcQG3
         v//4Y6xAflCQxbpP3R3M7rpOpLukBM5NRkBozZ1r8fham1j8Wfp8ct+k0WShagi3Ba
         Q5K+Ftfr2sYoyljCN6COboKul5VpbWQj5jTtnVPMhb4c+GemeT61Td1aQyfzzRM9Qb
         EsguAgbE84xGQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220609011844.404011-1-jmaxwell37@gmail.com>
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cutaylor-pub@yahoo.com,
        Jon Maxwell <jmaxwell37@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Jon Maxwell <jmaxwell37@gmail.com>, netdev@vger.kernel.org
Message-ID: <165478172265.3884.13579040217428050738@kwain>
Date:   Thu, 09 Jun 2022 15:35:22 +0200
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

Quoting Jon Maxwell (2022-06-09 03:18:44)
> A customer reported a request_socket leak in a Calico cloud environment. =
We=20
> found that a BPF program was doing a socket lookup with takes a refcnt on=
=20
> the socket and that it was finding the request_socket but returning the p=
arent=20
> LISTEN socket via sk_to_full_sk() without decrementing the child request =
socket=20
> 1st, resulting in request_sock slab object leak. This patch retains the=20
> existing behaviour of returning full socks to the caller but it also decr=
ements
> the child request_socket if one is present before doing so to prevent the=
 leak.
>=20
> Thanks to Curtis Taylor for all the help in diagnosing and testing this. =
And=20
> thanks to Antoine Tenart for the reproducer and patch input.
>=20
> Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_=
sk_lookup()")
> Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")

"bpf:" should be inside the parenthesis in the two above lines.

Isn't the issue from before edbf8c01de5a for bpf_sk_lookup? Looking at a
5.1 kernel[1], __bpf_sk_lookup was called and also did the full socket
translation[2]. bpf_sk_release would not be called on the original
socket when that happens.

[1] https://elixir.bootlin.com/linux/v5.1/source/net/core/filter.c#L5204
[2] https://elixir.bootlin.com/linux/v5.1/source/net/core/filter.c#L5198

> Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> Co-developed-by: Antoine Tenart <atenart@kernel.org>
> Signed-off-by:: Antoine Tenart <atenart@kernel.org>

Please remove the extra ':'.

Thanks!
Antoine

> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>  net/core/filter.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2e32cee2c469..e3c04ae7381f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_s=
ock_tuple *tuple, u32 len,
>  {
>         struct sock *sk =3D __bpf_skc_lookup(skb, tuple, len, caller_net,
>                                            ifindex, proto, netns_id, flag=
s);
> +       struct sock *sk1 =3D sk;
> =20
>         if (sk) {
>                 sk =3D sk_to_full_sk(sk);
> -               if (!sk_fullsock(sk)) {
> -                       sock_gen_put(sk);
> +               /* sk_to_full_sk() may return (sk)->rsk_listener, so make=
 sure the original sk1
> +                * sock refcnt is decremented to prevent a request_sock l=
eak.
> +                */
> +               if (!sk_fullsock(sk1))
> +                       sock_gen_put(sk1);
> +               if (!sk_fullsock(sk))
>                         return NULL;
> -               }
>         }
> =20
>         return sk;
> @@ -6239,13 +6243,17 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_soc=
k_tuple *tuple, u32 len,
>  {
>         struct sock *sk =3D bpf_skc_lookup(skb, tuple, len, proto, netns_=
id,
>                                          flags);
> +       struct sock *sk1 =3D sk;
> =20
>         if (sk) {
>                 sk =3D sk_to_full_sk(sk);
> -               if (!sk_fullsock(sk)) {
> -                       sock_gen_put(sk);
> +               /* sk_to_full_sk() may return (sk)->rsk_listener, so make=
 sure the original sk1
> +                * sock refcnt is decremented to prevent a request_sock l=
eak.
> +                */
> +               if (!sk_fullsock(sk1))
> +                       sock_gen_put(sk1);
> +               if (!sk_fullsock(sk))
>                         return NULL;
> -               }
>         }
> =20
>         return sk;
> --=20
> 2.31.1
>=20
