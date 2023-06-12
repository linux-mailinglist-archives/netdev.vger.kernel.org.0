Return-Path: <netdev+bounces-10231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A4972D13E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 162151C20AEF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DDA18B1A;
	Mon, 12 Jun 2023 21:01:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89327EA0;
	Mon, 12 Jun 2023 21:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA1C433D2;
	Mon, 12 Jun 2023 21:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686603657;
	bh=Whbo2+zN/D8vOeyism70JKGQiO49erZGdbsaIkmExoI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Wfkki1XZtQjnir1YO/2Ab6YqFeL1YSCE4Av04BjrsUy9O0BQjRefA6nJ1aM73c/Ba
	 B+X4Y0BH7xknZK0Elrhh1IdOqdFaMg+9ppA/HamNQ1ETu8KzjUGaag4PFfHwyEA2NO
	 tg18Xogj7E7ISL8DQ6KuBaRHdv+qqZyKZGMLCQr58tmG5vspbm+aA6/w8G4j4kQD0n
	 JON1+2lrBVZiT/wPBejFWflFkZ9j997BisoTXGzGgS/YA65tJRI/mM+fpf1R7gj+KU
	 37SrITPJ1q4c+oJEwhL7sn8OTY5RjxtIFF99Ji72PatOFimKxBfNa1L87cu685GWRF
	 MIyddbU+ghKvA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 6B196BBE8A5; Mon, 12 Jun 2023 23:00:54 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
 haoluo@google.com, jolsa@kernel.org, willemb@google.com,
 dsahern@kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org,
 maciej.fijalkowski@intel.com, netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
References: <20230612172307.3923165-1-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 12 Jun 2023 23:00:54 +0200
Message-ID: <87cz20xunt.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Some immediate thoughts after glancing through this:

> --- Use cases ---
>
> The goal of this series is to add two new standard-ish places
> in the transmit path:
>
> 1. Right before the packet is transmitted (with access to TX
>    descriptors)
> 2. Right after the packet is actually transmitted and we've received the
>    completion (again, with access to TX completion descriptors)
>
> Accessing TX descriptors unlocks the following use-cases:
>
> - Setting device hints at TX: XDP/AF_XDP might use these new hooks to
> use device offloads. The existing case implements TX timestamp.
> - Observability: global per-netdev hooks can be used for tracing
> the packets and exploring completion descriptors for all sorts of
> device errors.
>
> Accessing TX descriptors also means that the hooks have to be called
> from the drivers.
>
> The hooks are a light-weight alternative to XDP at egress and currently
> don't provide any packet modification abilities. However, eventually,
> can expose new kfuncs to operate on the packet (or, rather, the actual
> descriptors; for performance sake).

dynptr?

> --- UAPI ---
>
> The hooks are implemented in a HID-BPF style. Meaning they don't
> expose any UAPI and are implemented as tracing programs that call
> a bunch of kfuncs. The attach/detach operation happen via BPF syscall
> programs. The series expands device-bound infrastructure to tracing
> programs.

Not a fan of the "attach from BPF syscall program" thing. These are part
of the XDP data path API, and I think we should expose them as proper
bpf_link attachments from userspace with introspection etc. But I guess
the bpf_mprog thing will give us that?

> --- skb vs xdp ---
>
> The hooks operate on a new light-weight devtx_frame which contains:
> - data
> - len
> - sinfo
>
> This should allow us to have a unified (from BPF POW) place at TX
> and not be super-taxing (we need to copy 2 pointers + len to the stack
> for each invocation).

Not sure what I think about this one. At the very least I think we
should expose xdp->data_meta as well. I'm not sure what the use case for
accessing skbs is? If that *is* indeed useful, probably there will also
end up being a use case for accessing the full skb?

> --- Multiprog attachment ---
>
> Currently, attach/detach don't expose links and don't support multiple
> programs. I'm planning to use Daniel's bpf_mprog once it lands.
>
> --- TODO ---
>
> Things that I'm planning to do for the non-RFC series:
> - have some real device support to verify xdp_hw_metadata works

Would be good to see some performance numbers as well :)

> - freplace
> - Documentation/networking/xdp-rx-metadata.rst - like documentation
>
> --- CC ---
>
> CC'ing people only on the cover letter. Hopefully can find the rest via
> lore.

Well, I found it there, even though I was apparently left off the Cc
list :(

-Toke

