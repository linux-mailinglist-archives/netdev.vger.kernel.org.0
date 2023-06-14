Return-Path: <netdev+bounces-10735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E0573005E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 870BB1C20D36
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A26EC137;
	Wed, 14 Jun 2023 13:47:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2818C7FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF82C433C0;
	Wed, 14 Jun 2023 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686750426;
	bh=l5n/L5NHjNAUQ1q3ufBr1NoPvkev3JAl2SGy6BnnzGU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=k6kMpmx6XivSeaiPRuwbUD99PRsLTH6oD2s30Cm2DFNMisgGsqfob7OVR7eLuvosP
	 FUbtHWrs66D1t85rZ9Rj72nnnl9xxX0ojxqAx1cpAIKcrI1SAziW9MO9XNbSCIqYt8
	 NU76sV7E6h3GZz9lfU8nBAKk/zeVWo1iFHvP7zi3bHdj9kI7I0fcXjqnRD4NHCvFXK
	 zfFI596NxDeilaDIGuhudsNoPudhE/vYooZN7zf67RI9bzmdQVIfZ/MxkWEi/ELy6r
	 T2JRPyxk/IfAuQiQHymcYrdGGVRu8mgT+FSSRHd2rBLPQp78KZ8uBXBtyvZTgn5ElB
	 RwjVXQgzzzuEg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id BEE71BBEBC1; Wed, 14 Jun 2023 15:47:02 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>
Cc: netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
 intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
 fred@cloudflare.com
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
In-Reply-To: <b3f96eb9-25c7-eeaf-3e0d-7c055939168b@intel.com>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
 <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com> <ZIiJOVMs4qK+PDsp@boxer>
 <874jnbxmye.fsf@toke.dk> <16f10691-3339-0a18-402a-dc54df5a2e21@intel.com>
 <ZIm3lHaa3Rjl2xRe@boxer> <b3f96eb9-25c7-eeaf-3e0d-7c055939168b@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 14 Jun 2023 15:47:02 +0200
Message-ID: <87sfaujgvd.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alexander Lobakin <aleksander.lobakin@intel.com> writes:

> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Wed, 14 Jun 2023 14:50:28 +0200
>
>> On Wed, Jun 14, 2023 at 02:40:07PM +0200, Alexander Lobakin wrote:
>>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org>
>>> Date: Tue, 13 Jun 2023 19:59:37 +0200
>
> [...]
>
>>> What if a NAPI polling cycle is being run on one core while at the very
>>> same moment I'm replacing the XDP prog on another core? Not in terms of
>>> pointer tearing, I see now that this is handled correctly, but in terms
>>> of refcounts? Can't bpf_prog_put() free it while the polling is still
>>> active?
>>=20
>> Hmm you mean we should do bpf_prog_put() *after* we update bpf_prog on
>> ice_rx_ring? I think this is a fair point as we don't bump the refcount
>> per each Rx ring that holds the ptr to bpf_prog, we just rely on the main
>> one from VSI.
>
> Not even after we update it there. I believe we should synchronize NAPI
> cycles with BPF prog update (have synchronize_rcu() before put or so to
> make the config path wait until there's no polling and onstack pointers,
> would that be enough?).
>
> NAPI polling starts
> |<--- XDP prog pointer is placed on the stack and used from there
> |
> |  <--- here you do xchg() and bpf_prog_put()
> |  <--- here you update XDP progs on the rings
> |
> |<--- polling loop is still using the [now invalid] onstack pointer
> |
> NAPI polling ends

No, this is fine; bpf_prog_put() uses call_rcu() to actually free the
program, which guarantees that any ongoing RCU critical sections have
ended before. And as explained in that other series of mine, this
includes any ongoing NAPI poll cycles.

-Toke

