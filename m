Return-Path: <netdev+bounces-8124-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2896D722D21
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D798C281337
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFCADDC6;
	Mon,  5 Jun 2023 16:58:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2208F41;
	Mon,  5 Jun 2023 16:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0656FC433EF;
	Mon,  5 Jun 2023 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685984309;
	bh=CrY2ZiVbWL+cdb7NhSsJPRJqo31JAAEjIeVjfeRjOSU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uz3/gsoa2JuN//yAO3fxQSyENy5z32PfIvosUKB65Eh9x29EXgX9OgK2j3UQrcR0U
	 /fiSf8McB0fZosy8lfgw786b66ablsMI5E/F9icD0TcmTxp68Wy5IiOhszBjjS5iMM
	 Zqc9zAYeUKq8Nnb2rrxZjbHgMfjzcamXRu1rP/7aLR8o4PutDqK88QPe/nwkbfh2IA
	 2rH1ZSpZywRtAqCbv8b4e62ztaqYo6Ng+1okBLR9KfQru8no1qhAaorZ8pQDiQOvUP
	 hAcSZQ6d5MjHXa83oHVkPRnm6HK/dUZuUnREZ7WTuRdeJ2KP1TsF3AhZIQ/LTbYXWv
	 Qx1AUDBfG2t0Q==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 02161BBDAE1; Mon,  5 Jun 2023 18:58:25 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, bpf@vger.kernel.org,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc: netdev@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org,
 tirthendu.sarkar@intel.com, maciej.fijalkowski@intel.com,
 simon.horman@corigine.com
Subject: Re: [PATCH v3 bpf-next 00/22] xsk: multi-buffer support
In-Reply-To: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 05 Jun 2023 18:58:25 +0200
Message-ID: <87edmp3ky6.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Great to see this proceeding! Thought I'd weigh in on this part:

> Unfortunately, we had to introduce a new bind flag (XDP_USE_SG) on the
> AF_XDP level to enable multi-buffer support. It would be great if you
> have ideas on how to get rid of it. The reason we need to
> differentiate between non multi-buffer and multi-buffer is the
> behaviour when the kernel gets a packet that is larger than the frame
> size. Without multi-buffer, this packet is dropped and marked in the
> stats. With multi-buffer on, we want to split it up into multiple
> frames instead.
>
> At the start, we thought that riding on the .frags section name of
> the XDP program was a good idea. You do not have to introduce yet
> another flag and all AF_XDP users must load an XDP program anyway
> to get any traffic up to the socket, so why not just say that the XDP
> program decides if the AF_XDP socket should get multi-buffer packets
> or not? The problem is that we can create an AF_XDP socket that is Tx
> only and that works without having to load an XDP program at
> all. Another problem is that the XDP program might change during the
> execution, so we would have to check this for every single packet.

I agree that it's better to tie the enabling of this to a socket flag
instead of to the XDP program, for a couple of reasons:

- The XDP program can, as you say, be changed, but it can also be shared
  between several sockets in a single XSK, so this really needs to be
  tied to the socket.

- The XDP program is often installed implicitly by libxdp, in which case
  the program can't really set the flag on the program itself.

There's a related question of whether the frags flag on the XDP program
should be a prerequisite for enabling it at the socket? I think probably
it should, right?

Also, related to the first point above, how does the driver respond to
two different sockets being attached to the same device with two
different values of the flag? (As you can probably tell I didn't look at
the details of the implementation...)

-Toke

