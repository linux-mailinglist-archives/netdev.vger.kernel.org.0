Return-Path: <netdev+bounces-2541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0087026E4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56ECF1C20AA1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100988829;
	Mon, 15 May 2023 08:12:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A9A8470
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896D1C433D2;
	Mon, 15 May 2023 08:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684138334;
	bh=Klp6m+6M1WhJJoK5LuWP3e8ccyBCARQ4yxdPrGzT3aU=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=DMiUwZIku0g0MHHr9HxcbQqKe8fWhWMOyzKT45BvMqAPUUkXUm5A0zDjHECvogynC
	 o+2XjOqGVv6tUtAitoOSA+rnJy/FWNkZIa3p4oMt48hamAsa1IkzRv1WxXKco8iscD
	 Ya6UOKue3R9UqZvzfMmUcv/9pPtOnKB83tVGu4zR/FeuGbNMo1Mc1/FMzSyztRFt4Y
	 NiMSGwgb3zeUC61/7LlBp7u8sWP8euMcVQHbzu4pmv1zoUsDJoCT7I3P68KK5SIgZH
	 89M9yrq6b8Vi8PxM1FHs6+2vo2Nwfdl6YuoZLRpqKZ415VEXIVDoGV0571lv10hK2v
	 oIjMEPkQVNudA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com>
References: <20230511093456.672221-1-atenart@kernel.org> <20230511093456.672221-5-atenart@kernel.org> <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com> <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com> <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com> <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org> <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
From: Antoine Tenart <atenart@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
To: Dumitru Ceara <dceara@redhat.com>, Eric Dumazet <edumazet@google.com>, Ilya Maximets <i.maximets@ovn.org>
Date: Mon, 15 May 2023 10:12:10 +0200
Message-ID: <168413833063.4854.12088632353537054947@kwain>

Quoting Dumitru Ceara (2023-05-11 22:50:32)
> On 5/11/23 19:54, Ilya Maximets wrote:
> >>> Note that skb->hash has never been considered as canonical, for obvio=
us reasons.
> >=20
> > I guess, the other point here is that it's not an L4 hash either.
> >=20
> > It's a random number.  So, the documentation will still not be
> > correct even after the change proposed in this patch.

The proposed changed is "indicate hash is from layer 4 and provides a
uniform distribution over flows", which does not describe *how* the hash
is computed but *where* it comes from. This matches "random number set
by TCP" and changes in how hashes are computed won't affect the comment,
so we'll not end up in the same situation.

> > One way to not break everything doing that will be to introduce a
> > new flag, e.g. 'rnd_hash' that will be a hash that is "not related
> > to packet fields, but provides a uniform distribution over flows".
> >=20
> > skb_get_hash() then may return the current hash if it's any of
> > l4, rnd or sw.  That should preserve the current logic across
> > the kernel code.
> > But having a new flag, we could introduce a new helper, for example
> > skb_get_stable_hash() or skb_get_hash_nonrandom() or something like
> > that, that will be equal to the current version of skb_get_hash(),
> > i.e. not take the random hash into account.
> >=20
> > Affected subsystems (OVS, ECMP, SRv6) can be changed to use that
> > new function.  This way these subsystems will get a software hash
> > based on the real packet fields, if it was originally random.
> > This will also preserve ability to use hash provided by the HW,
> > since it is not normally random.

But then the whole point of txrehash would be dismissed, if ECMP and
others stop using the hash provided by TCP. This needs to be a
conditional setting, to make the skb hash to be stable over time only
when needed. That way both scenario are supported.

> What I had in mind is not really a stable hash but a "good enough
> alternative".  It's probably "good enough" (at least for OvS/OVN) if the
> hash used by OvS doesn't change throughout the lifetime of a TCP session.

So what's important is not how the hash is computed but the fact that
it should be stable over time when requested. Isn't exactly what
net.core.txrehash=3D0 does? If there are some bugs they should be fixed.

On top of this, if OvS needs to additionally provide a canonical
4/5-tuple hash because not only the stability over time is needed but
also the method is important, it needs to compute its own hash. As part
of such potential series ways to cache the result can be explored.
Numbers would help too. (This can be discussed here, that's fine, but I
thought it's important to distinguish the two topics).

Antoine

