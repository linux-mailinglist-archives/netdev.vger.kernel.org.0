Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB6451E359
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 03:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbiEGB5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 21:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiEGB5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 21:57:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B0450459
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 18:54:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD8BC60B07
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 01:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9534AC385A8;
        Sat,  7 May 2022 01:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651888447;
        bh=JCFaW3Ey9IJeiRkMZBtpgv6XC9wi9aA0Ndpuc1O2SQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pvyhh3eQ5aHUNa7GO3NmjhXuJm6uRymosbhbTFFxZALqrGDuU7QID2+hvQ2fskzPJ
         W371s1cFk8LvnNumSGiHf9M08ndntTqkJiaBA/ibUvFrmt43JLpLgCeMtT5b7a6/GK
         aVbtxrSAOIQgET9ewYyAtAro/dUTMJI6xKRIxvUfinYp+na9HUHRt2iq9UL4v4l8Ak
         osW1KOXiNevTrsSjwbcpNeu/OE+1T0M+km3muhVmNHnBkvdEsmKWoWr7A3voG3zwYy
         pI8wOnP04FeGNseQk4bn89axMxnKcmQgG8lNgGg5pcPqN0Pc3Hl3nTY2RYY9RmuCIF
         sbTYkxh5TjKuA==
Date:   Fri, 6 May 2022 18:54:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <20220506185405.527a79d4@kernel.org>
In-Reply-To: <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
        <20220506153048.3695721-13-eric.dumazet@gmail.com>
        <20220506153414.72f26ee3@kernel.org>
        <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 May 2022 17:32:43 -0700 Eric Dumazet wrote:
> On Fri, May 6, 2022 at 3:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri,  6 May 2022 08:30:48 -0700 Eric Dumazet wrote: =20
> > > From: Coco Li <lixiaoyan@google.com>
> > >
> > > mlx5 supports LSOv2.
> > >
> > > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> > > with JUMBO TLV for big packets.
> > >
> > > We need to ignore/skip this HBH header when populating TX descriptor.
> > >
> > > Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> > > layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
> > >
> > > v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> > > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=3Dy =20
> >
> > In file included from ../include/linux/string.h:253,
> >                  from ../arch/x86/include/asm/page_32.h:22,
> >                  from ../arch/x86/include/asm/page.h:14,
> >                  from ../arch/x86/include/asm/processor.h:19,
> >                  from ../arch/x86/include/asm/timex.h:5,
> >                  from ../include/linux/timex.h:65,
> >                  from ../include/linux/time32.h:13,
> >                  from ../include/linux/time.h:60,
> >                  from ../include/linux/skbuff.h:15,
> >                  from ../include/linux/tcp.h:17,
> >                  from ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.=
c:33:
> > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> >     inlined from =E2=80=98mlx5e_insert_vlan=E2=80=99 at ../drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c:104:2,
> >     inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c:404:5:
> > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__w=
rite_overflow_field=E2=80=99 declared with attribute warning: detected writ=
e beyond size of field (1st parameter); maybe use struct_group()? [-Wattrib=
ute-warning]
> >   328 |                         __write_overflow_field(p_size_field, si=
ze);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
> > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> >     inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c:408:5:
> > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__w=
rite_overflow_field=E2=80=99 declared with attribute warning: detected writ=
e beyond size of field (1st parameter); maybe use struct_group()? [-Wattrib=
ute-warning]
> >   328 |                         __write_overflow_field(p_size_field, si=
ze);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
> > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> >     inlined from =E2=80=98mlx5i_sq_xmit=E2=80=99 at ../drivers/net/ethe=
rnet/mellanox/mlx5/core/en_tx.c:962:4:
> > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98__w=
rite_overflow_field=E2=80=99 declared with attribute warning: detected writ=
e beyond size of field (1st parameter); maybe use struct_group()? [-Wattrib=
ute-warning]
> >   328 |                         __write_overflow_field(p_size_field, si=
ze);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~ =20
>=20
> I guess these warnings show up before this BIG TCP patch ?
>=20
> I do not see any struct_group() being used in mlx5
>=20
> May I ask which compiler is used here, and what CONFIG_ option needs to b=
e set ?
>=20
> Thanks.

Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds
cleanly. Gotta be the new W=3D1 filed overflow warnings, let's bother
Kees.

I believe this is the code in question:

@@ -379,15 +393,36 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb,

+		u8 *start =3D eseg->inline_hdr.start;
+
+		if (unlikely(attr->hopbyhop)) {
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			if (skb_vlan_tag_present(skb)) {
+				mlx5e_insert_vlan(start, skb, ETH_HLEN + sizeof(*h6));

Unhappiness #1 ^^^

Where mlx5e_insert_vlan() is:

static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 =
ihs)
{
	struct vlan_ethhdr *vhdr =3D (struct vlan_ethhdr *)start;
	int cpy1_sz =3D 2 * ETH_ALEN;
	int cpy2_sz =3D ihs - cpy1_sz;

	memcpy(&vhdr->addrs, skb->data, cpy1_sz);
	vhdr->h_vlan_proto =3D skb->vlan_proto;
	vhdr->h_vlan_TCI =3D cpu_to_be16(skb_vlan_tag_get(skb));
	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
}

indeed ihs =3D=3D ETH_HLEN + sizeof(*h6) will make cpy2_sz come out as some=
thing
much bigger than the vhdr->h_vlan_encapsulated_proto field.

+				ihs +=3D VLAN_HLEN;
+				h6 =3D (struct ipv6hdr *)(start + sizeof(struct vlan_ethhdr));
+			} else {
+				memcpy(start, skb->data, ETH_HLEN + sizeof(*h6));

Unhappiness #2 ^^^

Again, ETH_HLEN + sizeof(*h6) will be larger than eseg->inline_hdr.start
which is what start is pointing at.

+				h6 =3D (struct ipv6hdr *)(start + ETH_HLEN);
+			}

I didn't look where #3 is.
