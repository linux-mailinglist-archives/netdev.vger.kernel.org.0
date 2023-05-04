Return-Path: <netdev+bounces-229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C24B56F62BA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 03:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C2801C21053
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 01:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1D3A4C;
	Thu,  4 May 2023 01:47:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ED37E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 01:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CA5C433D2;
	Thu,  4 May 2023 01:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683164824;
	bh=82XPEMDGqx/DupJFcJ/qnxYmRUq7vgjoNaQTnLllrxM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LJYq/vcA5MWieh9eK0b6mqjz3pHG4u5zDnJ9orgFr+NC6mxLoSrglv9U7pw/kqsMp
	 aXRCkvcsyJatKPkbUaFr2wEe8Gf+rw6+u7Xs/CpnG+r1vwfn8ErfHFOWrUdtWY7zkD
	 J6ft8ubJqI8jYXzpp4ZOoX8T3T4QPc7OKosE3fFukR/xsOp59149hoJ9KolPU6pnZN
	 lLzAheHDMkIbEtcDoRmSzyvyKRubPo4QRtJCLatcqPUBKvKuzSU/lP8mWkIMgGks3G
	 gAfz5A9KiNCQLzWdu100k2AsDuFKn5KUReB+U130cIyDI+XPjF8tqAWrrn99GgtQPD
	 HxpaK46iUD+vA==
Date: Wed, 3 May 2023 18:47:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
 brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
 linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>,
 lorenzo@kernel.org, linyunsheng@huawei.com, bpf@vger.kernel.org, "David S.
 Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Andrew
 Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V3 1/2] page_pool: Remove workqueue in
 new shutdown scheme
Message-ID: <20230503184702.65dceb90@kernel.org>
In-Reply-To: <3a5a28c4-01a3-793c-6969-475aba3ff3b5@redhat.com>
References: <168269854650.2191653.8465259808498269815.stgit@firesoul>
	<168269857929.2191653.13267688321246766547.stgit@firesoul>
	<20230502193309.382af41e@kernel.org>
	<87ednxbr3c.fsf@toke.dk>
	<3a5a28c4-01a3-793c-6969-475aba3ff3b5@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 3 May 2023 17:49:34 +0200 Jesper Dangaard Brouer wrote:
> On 03/05/2023 13.18, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> >> We can remove the warning without removing the entire delayed freeing
> >> scheme. I definitely like the SHUTDOWN flag and patch 2 but I'm a bit
> >> less clear on why the complexity of datapath freeing is justified.
> >> Can you explain? =20
> >=20
> > You mean just let the workqueue keep rescheduling itself every minute
> > for the (potentially) hours that skbs will stick around? Seems a bit
> > wasteful, doesn't it? :) =20
>=20
> I agree that this workqueue that keeps rescheduling is wasteful.
> It actually reschedules every second, even more wasteful.
> NIC drivers will have many HW RX-queues, with separate PP instances,=20
> that each can start a workqueue that resched every sec.

There's a lot of work items flying around on a working system.
I don't think the rare (and very cheap) PP check work is going=20
to move the needle. You should see how many work items DIM schedules :(

I'd think that potentially having the extra memory pinned is much more
of an issue than a periodic check, and that does not go away by
changing the checking mechanism.

> Eric have convinced me that SKBs can "stick around" for longer than the
> assumptions in PP.  The old PP assumptions came from XDP-return path.
> It is time to cleanup.

I see. Regardless - should we have some count/statistic for the number
of "zombie" page pools sitting around in the system? Could be useful
for debug.

> > We did see an issue where creating and tearing down lots of page pools
> > in a short period of time caused significant slowdowns due to the
> > workqueue mechanism. Lots being "thousands per second". This is possible
> > using the live packet mode of bpf_prog_run() for XDP, which will setup
> > and destroy a page pool for each syscall... =20
>=20
> Yes, the XDP live packet mode of bpf_prog_run is IMHO abusing the
> page_pool API.  We should fix that somehow, at least the case where live
> packet mode is only injecting a single packet, but still creates a PP
> instance. The PP in live packet mode IMHO only makes sense when
> repeatedly sending packets that gets recycles and are pre-inited by PP.

+1, FWIW, I was surprised that we have a init_callback which sits in=20
the fastpath exists purely for testing.

> This use of PP does exemplify why is it problematic to keep the workqueue.
>=20
> I have considered (and could be convinced) delaying the free via
> call_rcu, but it also create an unfortunate backlog of work in the case
> of live packet mode of bpf_prog_run.

Maybe let the pp used by BPF testing be reusable? No real driver will
create thousands of PPs a seconds, that's not sane.

Anyway, you'll choose what you'll choose. I just wanted to cast my vote
for the work queue rather than the tricky lockless release code.

