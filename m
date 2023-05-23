Return-Path: <netdev+bounces-4723-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE6CD70E061
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96BFD281366
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE071F94E;
	Tue, 23 May 2023 15:25:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7D31F922
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198D2C433D2;
	Tue, 23 May 2023 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684855557;
	bh=36KGEMb1FrX6jTbn6n21r/JBWGn+BlZrYT1/+x1nW+U=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=H2+mATCuF5vPDTaTCcuoC/81ZJGHXGMTQLBPhLUPIeOItb9tcHmYtOEcPrhOm4dQy
	 AvedWUBUZ9ZZpQ9rhX1CewPTBD28EH9UF2xVOp0m3kxBJ81bEnkuURCV/LgZguW8v1
	 VmEm2kRzoEnyzZ+rsQ8IBWG9J2o2nD5n2oATWsv0sc9rExlKEvXu7fc/xyXWJGIAcC
	 4M1M0dK/mZDLeq9/C/bGi/ZQrce/frLd8JGcP8bPR3mB1k9xobYx6txN+EfIwAXcVq
	 VO1bAL8AKf60BQXUeWvqYSiSQGPMUG8LJ1PW/yhd//dMftsev2mWtyHRa3VPFNRsON
	 4IQTzmvSx4uQQ==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5f1ef3e1-be8f-4bbc-a877-ec13cdc9254a@ovn.org>
References: <20230511093456.672221-1-atenart@kernel.org> <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com> <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org> <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com> <168413833063.4854.12088632353537054947@kwain> <7c7fc244-012c-7760-a62e-7c31242d489a@ovn.org> <168422260272.35976.12561298456115365259@kwain> <485035ec-90f2-77fe-a3c5-21a0a40b111e@ovn.org> <168432511934.5394.6542526478980736820@kwain> <5f1ef3e1-be8f-4bbc-a877-ec13cdc9254a@ovn.org>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
From: Antoine Tenart <atenart@kernel.org>
Cc: i.maximets@ovn.org, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
To: Dumitru Ceara <dceara@redhat.com>, Eric Dumazet <edumazet@google.com>, Ilya Maximets <i.maximets@ovn.org>
Date: Tue, 23 May 2023 17:25:54 +0200
Message-ID: <168485555448.4954.15925446882328637898@kwain>

Quoting Ilya Maximets (2023-05-18 01:00:40)
> On 5/17/23 14:05, Antoine Tenart wrote:
> >=20
> > Even l4_hash w/o taking the rnd case into account does not guarantee a
> > stable hash for the lifetime of a flow; what happens if packets from the
> > same flow are received on two NICs using different keys and/or algs?
>=20
> Following the same logic we can't really say that it "provides a uniform
> distribution over L4 flows" either.  The fact that L4 fields were used
> to calculate the hash, doesn't mean the hash function is any good.

Well drivers need to either trust the h/w in some ways or not use what
is provided if it's broken; or we can't be sure of anything. It's not
the same as an example where a valid setup can't guarantee a property by
design.

> > Now, I'll let some time to give a chance for others to chime in.
>=20
> Sure.

I don't think we'll get more guidance and we failed to come to an
agreement so let's keep this as-is for now; I'll send a v2 w/o this
documentation change.

As for a way forward and the stability need, IMHO the hash needs to be
computed where it is used (with potential cache, not reusing skb->hash)
but if you feel this should be addressed at this level a patch doing so
might at least get others to comment (both ways).

Thanks,
Antoine

