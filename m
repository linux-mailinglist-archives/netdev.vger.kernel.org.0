Return-Path: <netdev+bounces-10826-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1141C730612
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 433DA1C20DA5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84ABA2EC3B;
	Wed, 14 Jun 2023 17:27:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDF67F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A921EC433C9;
	Wed, 14 Jun 2023 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686763666;
	bh=nlwk6XMb5RnSmIqe4EjUjhd0IbL+TxpJ7NFl5M/ICHs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bUlUyRvRm4MxoOmh2UQm/2dkWk+jOunKpVZPKH7ManG84howibVGCCCsUnPh1tesE
	 hqV417Yio2xUA0oTICH/HJi+lMxTsOeDymrSr3eMtJINZ5oRttCl3n6+Bgsi4pnujL
	 3J5NsuHPxXzp9Nlri+9/rIICYdY/L87jbbEz1urLP08Fn9ujp9NoKu1Aa78s74Z1t1
	 LChDgrBQhJZ7HzDuqLLvefEFfltB+SxSGgEHpRFr5d8rvgXUcgp0Uz+/kw9J9dYC6T
	 eg1UMZVRojZaVl2uEPX8Lb3zySvvMUut0TYhvw73VvuIA1NmEc+wqB1T5nO2ZVm6VG
	 9DlWNJjPZ2vsg==
Date: Wed, 14 Jun 2023 10:27:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Martin Habets <habetsm.xilinx@gmail.com>
Cc: =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>,
 ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-net-drivers@amd.com, Fei
 Liu <feliu@redhat.com>
Subject: Re: [PATCH net] sfc: use budget for TX completions
Message-ID: <20230614102744.71c91f20@kernel.org>
In-Reply-To: <ZIl0OYvze+iTehWX@gmail.com>
References: <20230612144254.21039-1-ihuguet@redhat.com>
	<ZIl0OYvze+iTehWX@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Jun 2023 09:03:05 +0100 Martin Habets wrote:
> On Mon, Jun 12, 2023 at 04:42:54PM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > When running workloads heavy unbalanced towards TX (high TX, low RX
> > traffic), sfc driver can retain the CPU during too long times. Although
> > in many cases this is not enough to be visible, it can affect
> > performance and system responsiveness.
> >=20
> > A way to reproduce it is to use a debug kernel and run some parallel
> > netperf TX tests. In some systems, this will lead to this message being
> > logged:
> >   kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 22s!
> >=20
> > The reason is that sfc driver doesn't account any NAPI budget for the TX
> > completion events work. With high-TX/low-RX traffic, this makes that the
> > CPU is held for long time for NAPI poll.
> >=20
> > Documentations says "drivers can process completions for any number of =
Tx
> > packets but should only process up to budget number of Rx packets".
> > However, many drivers do limit the amount of TX completions that they
> > process in a single NAPI poll. =20
>=20
> I think your work and what other drivers do shows that the documentation =
is
> no longer correct. I haven't checked when that was written, but maybe it
> was years ago when link speeds were lower.
> Clearly for drivers that support higher link speeds this is an issue, so =
we
> should update the documentation. Not sure what constitutes a high link sp=
eed,
> with current CPUs for me it's anything >=3D 50G.

The documentation is pretty recent. I haven't seen this lockup once=20
in production or testing. Do multiple queues complete on the same CPU
for SFC or something weird like that?

