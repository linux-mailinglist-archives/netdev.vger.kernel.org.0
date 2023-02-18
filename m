Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ABE69BAFE
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 17:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjBRQ0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 11:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBRQ0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 11:26:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A612D78;
        Sat, 18 Feb 2023 08:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8AAFB803F5;
        Sat, 18 Feb 2023 16:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D907C433D2;
        Sat, 18 Feb 2023 16:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676737598;
        bh=zUcJfJZk8tfAqsjf/uINW4J+WzQDryAf+30+DUdKJxQ=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=K/8fw7virAe90XsMLDmkak6nV2AScenBc4dZSeZ6QOpz+fxFlZZK6RjL+5VNQD4dh
         uqUYjU7ZuyJIWytgk5NomjZDHZEqBUJE6G1fg2tB7Mr1yRft6APMbDACNhlWjhO6ql
         aJjZ9RhvFlZu2fYiqzbJNNX+ZhT4eC9T8+8tk0U+C6sPUvHqf0e1RwRRTQjfmK8iHm
         fBdfbXKUm6L2scYwzO8ObQRi4Btllze7vgsDs+liwOLG3DxX4R0qft9lr4ZB42V3xM
         lgk/SJeI6Wv0CPvUmUZplu9wLbv/JR/JxOuQx7MkfoHATqxVMOw5ogZklNCZxPWz+4
         HQyKotm8nK8KA==
Date:   Sat, 18 Feb 2023 08:26:35 -0800
From:   Kees Cook <kees@kernel.org>
To:     Josef Oskera <joskera@redhat.com>, netdev@vger.kernel.org
CC:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] mlx4: supress fortify for inlined xmit
User-Agent: K-9 Mail for Android
In-Reply-To: <20230217094541.2362873-1-joskera@redhat.com>
References: <20230217094541.2362873-1-joskera@redhat.com>
Message-ID: <2E9A091B-ABA3-4B99-965A-EA893F402F25@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On February 17, 2023 1:45:41 AM PST, Josef Oskera <joskera@redhat=2Ecom> wr=
ote:
>This call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers FORTIFY=
 memcpy()
>warning on ppc64 platform=2E
>
>In function =E2=80=98fortify_memcpy_chk=E2=80=99,
>    inlined from =E2=80=98skb_copy_from_linear_data=E2=80=99 at =2E/inclu=
de/linux/skbuff=2Eh:4029:2,
>    inlined from =E2=80=98build_inline_wqe=E2=80=99 at drivers/net/ethern=
et/mellanox/mlx4/en_tx=2Ec:722:4,
>    inlined from =E2=80=98mlx4_en_xmit=E2=80=99 at drivers/net/ethernet/m=
ellanox/mlx4/en_tx=2Ec:1066:3:
>=2E/include/linux/fortify-string=2Eh:513:25: error: call to =E2=80=98__wr=
ite_overflow_field=E2=80=99 declared with attribute warning: detected write=
 beyond size of field (1st parameter); maybe use struct_group()? [-Werror=
=3Dattribute-warning]
>  513 |                         __write_overflow_field(p_size_field, size=
);
>      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~
>
>Same behaviour on x86 you can get if you use "__always_inline" instead of
>"inline" for skb_copy_from_linear_data() in skbuff=2Eh
>
>The call here copies data into inlined tx destricptor, which has 104 byte=
s
>(MAX_INLINE) space for data payload=2E In this case "spc" is known in com=
pile-time
>but the destination is used with hidden knowledge (real structure of dest=
ination
>is different from that the compiler can see)=2E That cause the fortify wa=
rning
>because compiler can check bounds, but the real bounds are different=2E
>"spc" can't be bigger than 64 bytes (MLX4_INLINE_ALIGN), so the data can =
always
>fit into inlined tx descriptor=2E
>The fact that "inl" points into inlined tx descriptor is determined earli=
er
>in mlx4_en_xmit()=2E
>
>Fixes: f68f2ff91512c1 fortify: Detect struct member overflows in memcpy()=
 at compile-time
>Signed-off-by: Josef Oskera <joskera@redhat=2Ecom>
>---
> drivers/net/ethernet/mellanox/mlx4/en_tx=2Ec | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx=2Ec b/drivers/net/e=
thernet/mellanox/mlx4/en_tx=2Ec
>index c5758637b7bed6=2E=2Ef30ca9fe90e5b4 100644
>--- a/drivers/net/ethernet/mellanox/mlx4/en_tx=2Ec
>+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx=2Ec
>@@ -719,7 +719,16 @@ static void build_inline_wqe(struct mlx4_en_tx_desc =
*tx_desc,
> 			inl =3D (void *) (inl + 1) + spc;
> 			memcpy(((void *)(inl + 1)), fragptr, skb->len - spc);

Using "unsafe" isn't the right solution here=2E What needs fixing is the "=
inl + 1" pattern which lacks any sense from the compilet's perspective=2E T=
he struct of inl needs to end with a flex array, and it should be used for =
all the accesses=2E i=2Ee=2E replace all the "inl + 1" instances with "inl-=
>data"=2E This makes it more readable for humans too=2E :)

I can send a patch=2E=2E=2E

-Kees

> 		} else {
>-			skb_copy_from_linear_data(skb, inl + 1, spc);
>+			unsafe_memcpy(inl + 1, skb->data, spc,
>+					/* This copies data into inlined tx descriptor, which has
>+					 * 104 bytes (MAX_INLINE) space for data=2E
>+					 * Real structure of destination is in this case hidden for
>+					 * the compiler
>+					 * "spc" is compile-time known variable and can't be bigger
>+					 * than 64 (MLX4_INLINE_ALIGN)=2E
>+					 * Bounds and other conditions are checked in current
>+					 * function and earlier in mlx4_en_xmit()
>+					 */);
> 			inl =3D (void *) (inl + 1) + spc;
> 			skb_copy_from_linear_data_offset(skb, spc, inl + 1,
> 							 hlen - spc);


--=20
Kees Cook
