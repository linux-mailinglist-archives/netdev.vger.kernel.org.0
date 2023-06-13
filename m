Return-Path: <netdev+bounces-10472-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD5672EA6A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0CA1281264
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38FB63C0B6;
	Tue, 13 Jun 2023 17:59:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA183B8D5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E07AC433D9;
	Tue, 13 Jun 2023 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686679180;
	bh=XMbXrY2QSZ7SK1RGlb6OVyN+sYIHDTpVIUzDFjQKJ6I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eksRU4jqs7WlA1xyd2EBqkY2CBN53qmt+iiVSaM/pF0xPTjRWOtj7z8HGfMWqEg0f
	 ze/aC11mJML9rI+WP0n4ZQVBVHhDtMjXgWjUoygF/opCtVKhsk7R3ZYO8KGf6bl062
	 ZVpS2vjc3ya6+ZO7txQ+pdG/H9SQPYxoOo0whnZMG1HDGgHNuapQNDDUldgEwOZhiZ
	 xzXhkoGROewZhFVf8hSOVqHEteSiwS1xw3xJ8Rn0jdY+iwxSms8FL2v5VgFzxVQvXB
	 RTosgnbt0fhNB1l8kixeSCvxcOk1ofBiEXh76bP3DxegdmlI4zXxsI5iz0PkXqEy/t
	 b4ptI9Eh8buaw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 04C9BBBEAC8; Tue, 13 Jun 2023 19:59:38 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
 intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
 fred@cloudflare.com
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
In-Reply-To: <ZIiJOVMs4qK+PDsp@boxer>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
 <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com> <ZIiJOVMs4qK+PDsp@boxer>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 13 Jun 2023 19:59:37 +0200
Message-ID: <874jnbxmye.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Tue, Jun 13, 2023 at 05:15:15PM +0200, Alexander Lobakin wrote:
>> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> Date: Tue, 13 Jun 2023 17:10:05 +0200
>> 
>> > Currently ice driver's .ndo_bpf callback brings the interface down and
>> > up independently of the presence of XDP resources. This is only needed
>> > when either these resources have to be configured or removed. It means
>> > that if one is switching XDP programs on-the-fly with running traffic,
>> > packets will be dropped.
>> > 
>> > To avoid this, compare early on ice_xdp_setup_prog() state of incoming
>> > bpf_prog pointer vs the bpf_prog pointer that is already assigned to
>> > VSI. Do the swap in case VSI has bpf_prog and incoming one are non-NULL.
>> > 
>> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> 
>> [0] :D
>> 
>> But if be serious, are you sure you won't have any pointer tears /
>> partial reads/writes without such RCU protection as added in the
>> linked commit ?
>
> Since we removed rcu sections from driver sides and given an assumption
> that local_bh_{dis,en}able() pair serves this purpose now i believe this
> is safe. Are you aware of:
>
> https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/

As the author of that series, I agree that it's not necessary to add
additional RCU protection. ice_vsi_assign_bpf_prog() already uses xchg()
and WRITE_ONCE() which should protect against tearing, and the xdp_prog
pointer being passed to ice_run_xdp() is a copy residing on the stack,
so it will only be read once per NAPI cycle anyway (which is in line
with how most other drivers do it).

It *would* be nice to add an __rcu annotation to ice_vsi->xdp_prog and
ice_rx_ring->xdp_prog (and move to using rcu_dereference(),
rcu_assign_pointer() etc), but this is more a documentation/static
checker thing than it's a "correctness of the generated code" thing :)

-Toke

