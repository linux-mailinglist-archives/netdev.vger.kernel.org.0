Return-Path: <netdev+bounces-10731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B07973004C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A6F81C20CD8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D007BE49;
	Wed, 14 Jun 2023 13:45:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53357FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A07C433C8;
	Wed, 14 Jun 2023 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686750305;
	bh=xSFFVMHAsN7TXbEJj6G0rLspoDICTsX+VxgYjqegLgI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=tgQEjky3m9agkRBia5HsmccdZKEmAhQT3vL3Cg3osKdGwn6SpXd/lyBHnefYE+FnJ
	 mZa2i73InoRT3fgi2csrN+nt7VqKEDb1jH2zgGlyTPMZw+loseeFQKOxBVkY1bGKc1
	 WlLtRWzQtJ2XoyK3qkkG5XjWxyPFic2BA1c07ajoJwa1c8mSwneqBvTVimu4iMsPLi
	 3XxEyPqncde2VBy3/z1K5VKb8H6hXW+au0bgBdrMxU17eb5MbHwKq/AaBRkfN2ckji
	 NM0Sop9mtlqnNxpu0wwWP/10xisuTblMZV3S/YGSBkgY8nQa+kaxuQN2fpID329I8X
	 P4gFsZrRTczpQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 12083BBEBB7; Wed, 14 Jun 2023 15:42:29 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
 intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
 fred@cloudflare.com
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
In-Reply-To: <ZIm3lHaa3Rjl2xRe@boxer>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
 <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com> <ZIiJOVMs4qK+PDsp@boxer>
 <874jnbxmye.fsf@toke.dk> <16f10691-3339-0a18-402a-dc54df5a2e21@intel.com>
 <ZIm3lHaa3Rjl2xRe@boxer>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 14 Jun 2023 15:42:29 +0200
Message-ID: <87v8fqjh2y.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Wed, Jun 14, 2023 at 02:40:07PM +0200, Alexander Lobakin wrote:
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org>
>> Date: Tue, 13 Jun 2023 19:59:37 +0200
>>=20
>> > Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>> >=20
>> >> On Tue, Jun 13, 2023 at 05:15:15PM +0200, Alexander Lobakin wrote:
>> >>> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> >>> Date: Tue, 13 Jun 2023 17:10:05 +0200
>>=20
>> [...]
>>=20
>> >> Since we removed rcu sections from driver sides and given an assumpti=
on
>> >> that local_bh_{dis,en}able() pair serves this purpose now i believe t=
his
>> >> is safe. Are you aware of:
>> >>
>> >> https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/
>>=20
>> Why [0] then? Added in [1] precisely for the sake of safe XDP prog
>> access and wasn't removed :s I was relying on that one in my suggestions
>> and code :D
>>=20
>> >=20
>> > As the author of that series, I agree that it's not necessary to add
>> > additional RCU protection. ice_vsi_assign_bpf_prog() already uses xchg=
()
>> > and WRITE_ONCE() which should protect against tearing, and the xdp_prog
>> > pointer being passed to ice_run_xdp() is a copy residing on the stack,
>> > so it will only be read once per NAPI cycle anyway (which is in line
>> > with how most other drivers do it).
>>=20
>> What if a NAPI polling cycle is being run on one core while at the very
>> same moment I'm replacing the XDP prog on another core? Not in terms of
>> pointer tearing, I see now that this is handled correctly, but in terms
>> of refcounts? Can't bpf_prog_put() free it while the polling is still
>> active?
>
> Hmm you mean we should do bpf_prog_put() *after* we update bpf_prog on
> ice_rx_ring? I think this is a fair point as we don't bump the refcount
> per each Rx ring that holds the ptr to bpf_prog, we just rely on the main
> one from VSI.

Yes, that's true, the duplication of the pointer in all the ring
structures can lead to problems there (why is that done in the first
place?). I agree that swapping the order of the pointer assignments
should be enough to fix this.

>> > It *would* be nice to add an __rcu annotation to ice_vsi->xdp_prog and
>> > ice_rx_ring->xdp_prog (and move to using rcu_dereference(),
>> > rcu_assign_pointer() etc), but this is more a documentation/static
>> > checker thing than it's a "correctness of the generated code" thing :)
>
> Agree but I would rather address the rest of Intel drivers in the
> series.

That's fair :)

-Toke

