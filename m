Return-Path: <netdev+bounces-8618-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2AD724E2C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B40D2281092
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993A81ED3D;
	Tue,  6 Jun 2023 20:35:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA9046BE;
	Tue,  6 Jun 2023 20:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B71AC433D2;
	Tue,  6 Jun 2023 20:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686083740;
	bh=Y3bLEGf5nz3t0HFcmCCRl87DSrid2c64nCFcYLKE4hU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JIJpn5DvO9e2pSQtbCPpyRzg4BPFvJ5z+IKIN6uuBqqRsSxLjshSAp7Vkweb9h+dC
	 Mr7RDaRy6Zs+KF7TpwjNwhI1E2xj/5KgCUl2I0X4Gs+s46covKCYuccme54zAi9RPm
	 r2bfbqpPeUPa4RbSVJWnVvZxs19HFYdeDxTXbvggErFAdkd0eNiT70h8ULjlRG4j/w
	 mPZNfidwoDzn1bBlHz4GcdAZdWQsgNuEWvGBN/mjs2cLjFj+r07qAmIby0TT2PPKzc
	 HPTZntwicOSauS4zuwGNLMOZRt5lN7djvXS30OZVeupO7U4zV3AWKwbIEVkoDiZInG
	 dEfFBa6U2B9jA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id F02A1BBDD0C; Tue,  6 Jun 2023 22:35:37 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, netdev@vger.kernel.org, magnus.karlsson@intel.com,
 bjorn@kernel.org, tirthendu.sarkar@intel.com, simon.horman@corigine.com
Subject: Re: [PATCH v3 bpf-next 00/22] xsk: multi-buffer support
In-Reply-To: <ZH8roRaXpova3Qwy@boxer>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
 <87edmp3ky6.fsf@toke.dk> <ZH8roRaXpova3Qwy@boxer>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 06 Jun 2023 22:35:37 +0200
Message-ID: <87ttvk1g86.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Mon, Jun 05, 2023 at 06:58:25PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Great to see this proceeding! Thought I'd weigh in on this part:
>
> Hey Toke that is very nice to hear and thanks for chiming in:)
>
>>=20
>> > Unfortunately, we had to introduce a new bind flag (XDP_USE_SG) on the
>> > AF_XDP level to enable multi-buffer support. It would be great if you
>> > have ideas on how to get rid of it. The reason we need to
>> > differentiate between non multi-buffer and multi-buffer is the
>> > behaviour when the kernel gets a packet that is larger than the frame
>> > size. Without multi-buffer, this packet is dropped and marked in the
>> > stats. With multi-buffer on, we want to split it up into multiple
>> > frames instead.
>> >
>> > At the start, we thought that riding on the .frags section name of
>> > the XDP program was a good idea. You do not have to introduce yet
>> > another flag and all AF_XDP users must load an XDP program anyway
>> > to get any traffic up to the socket, so why not just say that the XDP
>> > program decides if the AF_XDP socket should get multi-buffer packets
>> > or not? The problem is that we can create an AF_XDP socket that is Tx
>> > only and that works without having to load an XDP program at
>> > all. Another problem is that the XDP program might change during the
>> > execution, so we would have to check this for every single packet.
>>=20
>> I agree that it's better to tie the enabling of this to a socket flag
>> instead of to the XDP program, for a couple of reasons:
>>=20
>> - The XDP program can, as you say, be changed, but it can also be shared
>>   between several sockets in a single XSK, so this really needs to be
>>   tied to the socket.
>
> exactly
>
>>=20
>> - The XDP program is often installed implicitly by libxdp, in which case
>>   the program can't really set the flag on the program itself.
>>=20
>> There's a related question of whether the frags flag on the XDP program
>> should be a prerequisite for enabling it at the socket? I think probably
>> it should, right?
>
> These are two separate events (loading XDP prog vs loading AF_XDP socket)
> which are unordered, so you can load mbuf AF_XDP socket in the first place
> and then non-mbuf XDP prog and it will still work at some circumstances -
> i will quote here commit msg from patch 02:
>
> <quote>
> Such capability of the application needs to be independent of the
> xdp_prog's frag support capability since there are cases where even a
> single xdp_buffer may need to be split into multiple descriptors owing to
> a smaller xsk frame size.
>
> For e.g., with NIC rx_buffer size set to 4kB, a 3kB packet will
> constitute of a single buffer and so will be sent as such to AF_XDP layer
> irrespective of 'xdp.frags' capability of the XDP program. Now if the xsk
> frame size is set to 2kB by the AF_XDP application, then the packet will
> need to be split into 2 descriptors if AF_XDP application can handle
> multi-buffer, else it needs to be dropped.
> </quote>

Ah, right, the fact that the XSK frame size is set independently was not
present in my mind. Okay, makes sense. So the frags flag in the XDP
program is only needed to be able to attach the program to the large-MTU
interface in the first place, then. I guess for the default libxdp
program we can just always set the frags flag (it the kernel supports
it), since there's no processing of the packet data on the kernel side
there...

>>=20
>> Also, related to the first point above, how does the driver respond to
>> two different sockets being attached to the same device with two
>> different values of the flag? (As you can probably tell I didn't look at
>> the details of the implementation...)
>
> If we talk about zero-copy multi-buffer enabled driver then it will
> combine all of the frags that belong to particular packet onto xdp_buff
> which then will be redirected and AF_XDP core will check XDP_USE_SG flag
> vs the length of xdp_buff - if len is bigger than a chunk size from XSK
> pool (implies mbuf) and there is no XDP_USE_SG flag on socket - packet
> will be dropped.
>
> So driver is agnostic to that. AF_XDP core handles case you brought up
> respectively.
>
> Also what we actually attach down to driver is XSK pool not XSK socket
> itself as you know. XSK pool does not carry any info regarding frags.

Alright, makes sense, thanks for clarifying! :)

-Toke

