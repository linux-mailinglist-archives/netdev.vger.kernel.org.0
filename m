Return-Path: <netdev+bounces-5086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4471770FA1C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3795281390
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689A919910;
	Wed, 24 May 2023 15:30:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD2D18AE4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE11C433D2;
	Wed, 24 May 2023 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684942209;
	bh=qzViIOJygdrklxDyDE8mkf0N46C7o88E/vYxUdKRB8U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qB2uRT9HxAepFwd1APfRc9qiQFFKF3Q48L8adImdeHOOpyX7T1uf3aLMV3P+dOJs6
	 eAShSJzw3IdFoyqEECGeO/CcXUDXLmAKJkX26VYBjsX8erpQFb5e3HNKuSlYKPpFt0
	 Ac7ql1wdNf9ImK/oKjHELwc0AD5wt8Wr98PzPQE2HRKHUW3nNYkrI/Dxp/h1RfZp4B
	 C7gQNQhDExtaDCCcNOKYxXAZKslTkk5Ok5Q5xxf6/JiWEwZILhjbjGUdrUx1irFpEV
	 mk3gwWu2tYqBPK4DTuNnM56Xr+n7EP4kEV1v0LFqhfVU/ccbGx0bb3K/ACiS+FtJhH
	 nW2MAP3mzk3fQ==
Date: Wed, 24 May 2023 08:30:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v6 1/8] net: wangxun: libwx add tx offload
 functions
Message-ID: <20230524083008.4ab6937d@kernel.org>
In-Reply-To: <5B88318B-4944-43CB-8EF6-4942A2696480@net-swift.com>
References: <20230523030658.17738-1-mengyuanlou@net-swift.com>
	<20230523030658.17738-2-mengyuanlou@net-swift.com>
	<20230523210659.11304cce@kernel.org>
	<5B88318B-4944-43CB-8EF6-4942A2696480@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 24 May 2023 14:59:54 +0800 mengyuanlou@net-swift.com wrote:
> > 2023=E5=B9=B45=E6=9C=8824=E6=97=A5 12:06=EF=BC=8CJakub Kicinski <kuba@k=
ernel.org> =E5=86=99=E9=81=93=EF=BC=9A
> > On Tue, 23 May 2023 11:06:51 +0800 Mengyuan Lou wrote: =20
> >> + if (skb->encapsulation) {
> >> + union network_header hdr;
> >> +
> >> + switch (first->protocol) {
> >> + case htons(ETH_P_IP):
> >> + tun_prot =3D ip_hdr(skb)->protocol;
> >> + if (ip_is_fragment(ip_hdr(skb)))
> >> + return WX_PTYPE_PKT_IP | WX_PTYPE_TYP_IPFRAG;
> >> + ptype =3D WX_PTYPE_TUN_IPV4;
> >> + break;
> >> + case htons(ETH_P_IPV6):
> >> + wx_get_ipv6_proto(skb, skb_network_offset(skb), &tun_prot);
> >> + if (tun_prot =3D=3D NEXTHDR_FRAGMENT)
> >> + return WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6 |
> >> +       WX_PTYPE_TYP_IPFRAG;
> >> + ptype =3D WX_PTYPE_TUN_IPV6; =20
> >=20
> > Why does the HW care about fragmented packets?
> > AFAIU fragmented packets won't have any offloads enabled.
>=20
> According to hardware spec(Packet type table), try to tell the ptypes for=
 hardware.

Extracting information from the packet consumes CPU cycles.
If HW will not use the information anyway (because no offload=20
is requested for the packet) those cycles are wasted.

