Return-Path: <netdev+bounces-8239-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8C072339D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC7231C20932
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAB328C04;
	Mon,  5 Jun 2023 23:19:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F72F5256
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E29C433EF;
	Mon,  5 Jun 2023 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686007163;
	bh=aWQhnRxHE164WalESsY2Agv+EkbUckwBu8/Kcr/s6Dw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MXmixwPsNly4LfElyNJSjFJQfstd1C1O9n82CX/qq5+1Xtie5h4TwLe57xsM3PDrP
	 NkSplDXl47Vhyp6PAWeH0qwxRquKg1FN6t8zWZd+E4awKx/Mk2Vw+lom1CtMjRPfgU
	 lzCRvBKez7sCaZpoYDt7J0Zc84OjjcRQd1/QqrPbRkAfJmR6CiJrU//Xsx3xq6aOfy
	 Ya3latCAbcU5vRzzD+usC5LvAllYbz+l+shAtV1M0vlaqcKMx5G6kwwFOE0nBag8pC
	 xpyhuUC5waTRWSMoS9CpHYCB0yqfVqeFvK5Uv5P6fGfur2GphD0cSI/3V36WreY6QO
	 xhdAf5I/eEscw==
Date: Mon, 5 Jun 2023 16:19:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "luwei (O)" <luwei32@huawei.com>
Cc: Networking <netdev@vger.kernel.org>
Subject: Re: [Question] integer overflow in function
 __qdisc_calculate_pkt_len()
Message-ID: <20230605161922.5e417434@kernel.org>
In-Reply-To: <7723cc01-57bf-2b64-7f78-98a0e6508a2e@huawei.com>
References: <7723cc01-57bf-2b64-7f78-98a0e6508a2e@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Jun 2023 10:50:44 +0800 luwei (O) wrote:
>  =C2=A0=C2=A0=C2=A0 I found an integer overflow issue in function=20
> __qdisc_calculate_pkt_len(), the root cause is overhead and cell_align=20
> in stab is not checked.
>=20
> For example, if overhead is set to -2147483559 and cell_align is set to=20
> -32767 (tc tool limit it to 0 and -1, but other values can be set with=20
> netlink api),
>=20
> the integer overflow occurs:
>=20
>  =C2=A0568 void __qdisc_calculate_pkt_len(struct sk_buff *skb,
>  =C2=A0569=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct qdisc_size_ta=
ble *stab)
>  =C2=A0570 {
>  =C2=A0571=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int pkt_len, s=
lot;
>  =C2=A0572
>  =C2=A0573=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pkt_len =3D sk=
b->len + stab->szopts.overhead; (1)
>  =C2=A0574=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!=
stab->szopts.tsize))
>  =C2=A0575=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>  =C2=A0576
>  =C2=A0577=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 slot =3D pkt_l=
en + stab->szopts.cell_align; =C2=A0 (2)
>  =C2=A0578=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(s=
lot < 0))
>  =C2=A0579=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 slot =3D 0;
>=20
> if skb->len is 66, slot will be 66 + (-2147483559) + (-32767) =3D=20
> 2147451036, and pkt_len will be 2147451040 finally.=C2=A0 I think the val=
ue=20
> of overhead and cell_align
>=20
> should be limited, but not sure to which values they should be limited,=20
> can any one give me some suggestions?

on a quick look limiting the cell_align to S16_MIN at the netlink level
(NLA_POLICY_MIN()) seems reasonable, feel free to send a patch.

