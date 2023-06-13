Return-Path: <netdev+bounces-10457-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 025F372E936
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B047828115F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81BCC30B85;
	Tue, 13 Jun 2023 17:18:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F9433E3;
	Tue, 13 Jun 2023 17:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93485C433F1;
	Tue, 13 Jun 2023 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686676691;
	bh=YpBE+B+b/1O9SdbiuMOQn+daLcqceK2+RhVSsNdfcPc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GrS1FZw3U+WByyfcx+rMSw5gyxc7dMzyK7WwKqGBxGiOWkO44LEU+IsCFOPaXqvYF
	 oWZIWCYfVOPHJuYa8RuoQilSDuH5TsJwo2y0zI7oWpJrtWj8uCYSU/9tY/IXxR9uGI
	 181fNYKQYtuz9dfNqAhe+tgKWl7EkYZ9xOIiFpSd5SDFHLJxuk9VMbQv+9vFpu+/uz
	 2gLRM2aj+djkYBajxUUSvfd4q/2fBwAAZjIvosMivZpXa6F5OuPXl9lTv9/Oak7nAy
	 rtafi5rq49aR+bTAeWb+kascMDaYlkc1OwFvQc2Nn2GpJu9MSGmkcq+73nXAT9EmqZ
	 hxvtuAT6YfBgg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 31114BBEABD; Tue, 13 Jun 2023 19:18:09 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
 jolsa@kernel.org, willemb@google.com, dsahern@kernel.org,
 magnus.karlsson@intel.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
 netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
In-Reply-To: <ZIiaHXr9M0LGQ0Ht@google.com>
References: <20230612172307.3923165-1-sdf@google.com>
 <87cz20xunt.fsf@toke.dk> <ZIiaHXr9M0LGQ0Ht@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 13 Jun 2023 19:18:09 +0200
Message-ID: <877cs7xovi.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Stanislav Fomichev <sdf@google.com> writes:

> On 06/12, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Some immediate thoughts after glancing through this:
>>=20
>> > --- Use cases ---
>> >
>> > The goal of this series is to add two new standard-ish places
>> > in the transmit path:
>> >
>> > 1. Right before the packet is transmitted (with access to TX
>> >    descriptors)
>> > 2. Right after the packet is actually transmitted and we've received t=
he
>> >    completion (again, with access to TX completion descriptors)
>> >
>> > Accessing TX descriptors unlocks the following use-cases:
>> >
>> > - Setting device hints at TX: XDP/AF_XDP might use these new hooks to
>> > use device offloads. The existing case implements TX timestamp.
>> > - Observability: global per-netdev hooks can be used for tracing
>> > the packets and exploring completion descriptors for all sorts of
>> > device errors.
>> >
>> > Accessing TX descriptors also means that the hooks have to be called
>> > from the drivers.
>> >
>> > The hooks are a light-weight alternative to XDP at egress and currently
>> > don't provide any packet modification abilities. However, eventually,
>> > can expose new kfuncs to operate on the packet (or, rather, the actual
>> > descriptors; for performance sake).
>>=20
>> dynptr?
>
> Haven't considered, let me explore, but not sure what it buys us
> here?

API consistency, certainly. Possibly also performance, if using the
slice thing that gets you a direct pointer to the pkt data? Not sure
about that, though, haven't done extensive benchmarking of dynptr yet...

>> > --- UAPI ---
>> >
>> > The hooks are implemented in a HID-BPF style. Meaning they don't
>> > expose any UAPI and are implemented as tracing programs that call
>> > a bunch of kfuncs. The attach/detach operation happen via BPF syscall
>> > programs. The series expands device-bound infrastructure to tracing
>> > programs.
>>=20
>> Not a fan of the "attach from BPF syscall program" thing. These are part
>> of the XDP data path API, and I think we should expose them as proper
>> bpf_link attachments from userspace with introspection etc. But I guess
>> the bpf_mprog thing will give us that?
>
> bpf_mprog will just make those attach kfuncs return the link fd. The
> syscall program will still stay :-(

Why does the attachment have to be done this way, exactly? Couldn't we
just use the regular bpf_link attachment from userspace? AFAICT it's not
really piggy-backing on the function override thing anyway when the
attachment is per-dev? Or am I misunderstanding how all this works?

>> > --- skb vs xdp ---
>> >
>> > The hooks operate on a new light-weight devtx_frame which contains:
>> > - data
>> > - len
>> > - sinfo
>> >
>> > This should allow us to have a unified (from BPF POW) place at TX
>> > and not be super-taxing (we need to copy 2 pointers + len to the stack
>> > for each invocation).
>>=20
>> Not sure what I think about this one. At the very least I think we
>> should expose xdp->data_meta as well. I'm not sure what the use case for
>> accessing skbs is? If that *is* indeed useful, probably there will also
>> end up being a use case for accessing the full skb?
>
> skb_shared_info has meta_len, buf afaik, xdp doesn't use it. Maybe I
> a good opportunity to unify? Or probably won't work because if
> xdf_frame doesn't have frags, it won't have sinfo?

No, it won't. But why do we need this unification between the skb and
xdp paths in the first place? Doesn't the skb path already have support
for these things? Seems like we could just stick to making this xdp-only
and keeping xdp_frame as the ctx argument?

>> > --- Multiprog attachment ---
>> >
>> > Currently, attach/detach don't expose links and don't support multiple
>> > programs. I'm planning to use Daniel's bpf_mprog once it lands.
>> >
>> > --- TODO ---
>> >
>> > Things that I'm planning to do for the non-RFC series:
>> > - have some real device support to verify xdp_hw_metadata works
>>=20
>> Would be good to see some performance numbers as well :)
>
> +1 :-)
>
>> > - freplace
>> > - Documentation/networking/xdp-rx-metadata.rst - like documentation
>> >
>> > --- CC ---
>> >
>> > CC'ing people only on the cover letter. Hopefully can find the rest via
>> > lore.
>>=20
>> Well, I found it there, even though I was apparently left off the Cc
>> list :(
>>=20
>> -Toke
>
> Sure, I'll CC you explicitly next time! But I know you diligently follow =
bpf
> list, so decided to explicitly cc mostly netdev folks that might miss
> it otherwise.

Haha, fair point! And no big deal, I did obviously see it. I was just
feeling a bit left out, that's all ;)

-Toke

