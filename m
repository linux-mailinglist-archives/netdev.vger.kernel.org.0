Return-Path: <netdev+bounces-10827-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A97730618
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE4AF1C20D4C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65FA2EC38;
	Wed, 14 Jun 2023 17:31:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283F07F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3EBC433C0;
	Wed, 14 Jun 2023 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686763892;
	bh=pIDEdLZ6PfDDnDQqUoo3zpVEKD7ufb6FRfzpOCBUxBM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P753X1X6p3VGmZB++p6wV5nC/VBR5dfP/2wOVjbMm8ct8Mt3XI9nbU8e7+nl04Fm1
	 ubYVFabUZwtzxJsIY9vWZ4N6S35SqMS5VrMeAE47h7KI3xCiGI2gAEq3UaLBuIzSnO
	 22nelTqrJDdTlYCxkNpKFECdUdWMXH7k62ut+SRVN3LdUVni5Z4aKc0ZWBJedA0r9G
	 UGuj1XwrKodCcNqq/5iM+viy7sOtpHCbHyplJTvOUpZR6XzCO+gldVg+sOidwgYPOb
	 JyFvk4xGLPhiQi+aJtwg7k3QrAN5RscMxL2eL2RjTFgAPgBrFCQ3AP4HtEhBrBZ/av
	 9l2WX3wBiBHzA==
Date: Wed, 14 Jun 2023 10:31:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-net-drivers@amd.com, Fei
 Liu <feliu@redhat.com>
Subject: Re: [PATCH net] sfc: use budget for TX completions
Message-ID: <20230614103131.50a9abf1@kernel.org>
In-Reply-To: <CACT4oufPV6FbQ7xOU8uPOS2SsA6R-F+D5H80SnrH3BEOe+WoMA@mail.gmail.com>
References: <20230612144254.21039-1-ihuguet@redhat.com>
	<ZIdCFbjr0nEiS6+m@boxer>
	<CACT4oucSRrddFYaNDBsuvK_4imDZUvy9r2pvHp8Ji_E=oP6ecg@mail.gmail.com>
	<ZIl2Dw9Ve0b30WmV@gmail.com>
	<CACT4oufPV6FbQ7xOU8uPOS2SsA6R-F+D5H80SnrH3BEOe+WoMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Jun 2023 12:13:11 +0200 =C3=8D=C3=B1igo Huguet wrote:
> On Wed, Jun 14, 2023 at 10:03=E2=80=AFAM Martin Habets <habetsm.xilinx@gm=
ail.com> wrote:
> > On Mon, Jun 12, 2023 at 04:42:54PM +0200, =C3=8D=C3=B1igo Huguet wrote:=
 =20
> > > Documentations says "drivers can process completions for any number o=
f Tx
> > > packets but should only process up to budget number of Rx packets".
> > > However, many drivers do limit the amount of TX completions that they
> > > process in a single NAPI poll. =20
> >
> > I think your work and what other drivers do shows that the documentatio=
n is
> > no longer correct. I haven't checked when that was written, but maybe it
> > was years ago when link speeds were lower.
> > Clearly for drivers that support higher link speeds this is an issue, s=
o we
> > should update the documentation. Not sure what constitutes a high link =
speed,
> > with current CPUs for me it's anything >=3D 50G. =20
>=20
> I reproduced with a 10G link (with debug kernel, though)

Ah.

> > > +#define EFX_NAPI_MAX_TX 512 =20
> >
> > How did you determine this value? Is it what other driver use? =20
>=20
> A bit of trial and error. I wanted to find a value high enough to not
> decrease performance but low enough to solve the issue.
>=20
> Other drivers use lower values too, from 128. However, I decided to go
> to the high values in sfc because otherwise it can affect too much to
> RX. The most common case I saw in other drivers was: First process TX
> completions up to the established limit, then process RX completions
> up to the NAPI budget. But sfc processes TX and RX events serially,
> intermixed. We need to put a limit to TX events, but if it was too
> low, very few RX events would be processed with high TX traffic.
>=20
> > > I would better like to hear the opinion from the sfc maintainers, but
> > > I don't mind changing it because I'm neither happy with the chosen
> > > location. =20
> >
> > I think we should add it in include/linux/netdevice.h, close to
> > NAPI_POLL_WEIGHT. That way all drivers can use it.
> > Do we need to add this TX poll weight to struct napi_struct and
> > extend netif_napi_add_weight()?
> > That way all drivers could use the value from napi_struct instead of us=
ing
> > a hard-coded define. And at some point we can adjust it. =20
>=20
> That's what I thought too, but then we'd need to determine what's the
> exact meaning for that TX budget (as you see, it doesn't mean exactly
> the same for sfc than for other drivers, and between the other drivers
> there were small differences too).
>=20
> We would also need to decide what the default value for the TX budget
> is, so it is used in netif_napi_add. Right now, each driver is using
> different values.
>=20
> If something is done in that direction, it can take some time. May I
> suggest including this fix until then?

Agreed. Still needs a fixes tag, tho.

