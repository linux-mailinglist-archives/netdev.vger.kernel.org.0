Return-Path: <netdev+bounces-10498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D776272EB9F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A2EF1C20446
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE18737B82;
	Tue, 13 Jun 2023 19:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343E317FE6;
	Tue, 13 Jun 2023 19:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8934BC433F0;
	Tue, 13 Jun 2023 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686683420;
	bh=UkhMhQbNuGkNSp/rihKTB28p0jSTTH6gXRZQq9o/us4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aNWDjnJHCZGE77R3ugB0iIMJJYmCSY2yGv93mQ/kJfhyftTc8iZzZoIY0YO0g7g/h
	 0V3XhR4BTGvbnww16Y0VKIgPw32mhEBekbspBkJ+JDv5sFo/qNwuIy9PSO8v5c5qjV
	 TcY9u2Go8U63LTyawUE4v9Fhx81kYF4zPHbZ6dUHEIkuRa9ppF7HW53L3tMTbTmuYO
	 M6fO1xjkxqkVPfso6jt7Ff2F5IGqF2BcEbGaI3w2bGGkIYk7GVzMiPMbTIb/uN3uzg
	 ludSn2yc5z+FP4NMPF8Z6Zm3xeX/S6HGHJdoJB/L7yzhV9URaDj8ZhKSHLo+F9bT+H
	 RiRjlaAxWKfuw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 94B8FBBEAE1; Tue, 13 Jun 2023 21:10:17 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
 jolsa@kernel.org, willemb@google.com, dsahern@kernel.org,
 magnus.karlsson@intel.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
 netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
In-Reply-To: <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
References: <20230612172307.3923165-1-sdf@google.com>
 <87cz20xunt.fsf@toke.dk> <ZIiaHXr9M0LGQ0Ht@google.com>
 <877cs7xovi.fsf@toke.dk>
 <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 13 Jun 2023 21:10:17 +0200
Message-ID: <87v8frw546.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Stanislav Fomichev <sdf@google.com> writes:

> On Tue, Jun 13, 2023 at 10:18=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen=
 <toke@kernel.org> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > On 06/12, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> Some immediate thoughts after glancing through this:
>> >>
>> >> > --- Use cases ---
>> >> >
>> >> > The goal of this series is to add two new standard-ish places
>> >> > in the transmit path:
>> >> >
>> >> > 1. Right before the packet is transmitted (with access to TX
>> >> >    descriptors)
>> >> > 2. Right after the packet is actually transmitted and we've receive=
d the
>> >> >    completion (again, with access to TX completion descriptors)
>> >> >
>> >> > Accessing TX descriptors unlocks the following use-cases:
>> >> >
>> >> > - Setting device hints at TX: XDP/AF_XDP might use these new hooks =
to
>> >> > use device offloads. The existing case implements TX timestamp.
>> >> > - Observability: global per-netdev hooks can be used for tracing
>> >> > the packets and exploring completion descriptors for all sorts of
>> >> > device errors.
>> >> >
>> >> > Accessing TX descriptors also means that the hooks have to be called
>> >> > from the drivers.
>> >> >
>> >> > The hooks are a light-weight alternative to XDP at egress and curre=
ntly
>> >> > don't provide any packet modification abilities. However, eventuall=
y,
>> >> > can expose new kfuncs to operate on the packet (or, rather, the act=
ual
>> >> > descriptors; for performance sake).
>> >>
>> >> dynptr?
>> >
>> > Haven't considered, let me explore, but not sure what it buys us
>> > here?
>>
>> API consistency, certainly. Possibly also performance, if using the
>> slice thing that gets you a direct pointer to the pkt data? Not sure
>> about that, though, haven't done extensive benchmarking of dynptr yet...
>
> Same. Let's keep it on the table, I'll try to explore. I was just
> thinking that having less abstraction here might be better
> performance-wise.

Sure, let's evaluate this once we have performance numbers.

>> >> > --- UAPI ---
>> >> >
>> >> > The hooks are implemented in a HID-BPF style. Meaning they don't
>> >> > expose any UAPI and are implemented as tracing programs that call
>> >> > a bunch of kfuncs. The attach/detach operation happen via BPF sysca=
ll
>> >> > programs. The series expands device-bound infrastructure to tracing
>> >> > programs.
>> >>
>> >> Not a fan of the "attach from BPF syscall program" thing. These are p=
art
>> >> of the XDP data path API, and I think we should expose them as proper
>> >> bpf_link attachments from userspace with introspection etc. But I gue=
ss
>> >> the bpf_mprog thing will give us that?
>> >
>> > bpf_mprog will just make those attach kfuncs return the link fd. The
>> > syscall program will still stay :-(
>>
>> Why does the attachment have to be done this way, exactly? Couldn't we
>> just use the regular bpf_link attachment from userspace? AFAICT it's not
>> really piggy-backing on the function override thing anyway when the
>> attachment is per-dev? Or am I misunderstanding how all this works?
>
> It's UAPI vs non-UAPI. I'm assuming kfunc makes it non-UAPI and gives
> us an opportunity to fix things.
> We can do it via a regular syscall path if there is a consensus.

Yeah, the API exposed to the BPF program is kfunc-based in any case. If
we were to at some point conclude that this whole thing was not useful
at all and deprecate it, it doesn't seem to me that it makes much
difference whether that means "you can no longer create a link
attachment of this type via BPF_LINK_CREATE" or "you can no longer
create a link attachment of this type via BPF_PROG_RUN of a syscall type
program" doesn't really seem like a significant detail to me...

>> >> > --- skb vs xdp ---
>> >> >
>> >> > The hooks operate on a new light-weight devtx_frame which contains:
>> >> > - data
>> >> > - len
>> >> > - sinfo
>> >> >
>> >> > This should allow us to have a unified (from BPF POW) place at TX
>> >> > and not be super-taxing (we need to copy 2 pointers + len to the st=
ack
>> >> > for each invocation).
>> >>
>> >> Not sure what I think about this one. At the very least I think we
>> >> should expose xdp->data_meta as well. I'm not sure what the use case =
for
>> >> accessing skbs is? If that *is* indeed useful, probably there will al=
so
>> >> end up being a use case for accessing the full skb?
>> >
>> > skb_shared_info has meta_len, buf afaik, xdp doesn't use it. Maybe I
>> > a good opportunity to unify? Or probably won't work because if
>> > xdf_frame doesn't have frags, it won't have sinfo?
>>
>> No, it won't. But why do we need this unification between the skb and
>> xdp paths in the first place? Doesn't the skb path already have support
>> for these things? Seems like we could just stick to making this xdp-only
>> and keeping xdp_frame as the ctx argument?
>
> For skb path, I'm assuming we can read sinfo->meta_len; it feels nice
> to make it work for both cases?
> We can always export metadata len via some kfunc, sure.

I wasn't referring to the metadata field specifically when talking about
the skb path. I'm wondering why we need these hooks to work for the skb
path at all? :)

-Toke

