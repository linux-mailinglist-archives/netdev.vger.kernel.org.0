Return-Path: <netdev+bounces-10578-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9573B72F318
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613AA1C20AE9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E651649;
	Wed, 14 Jun 2023 03:31:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E783621;
	Wed, 14 Jun 2023 03:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493E3C433C9;
	Wed, 14 Jun 2023 03:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686713487;
	bh=h8iTppC+DRV3+Olis5uqF2bGVW9j7aYR4cEAojmhZfc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gsQ06XWr97dr+bRgNn3ut5ch5ZomNNIyai9KSrP6WozhorSzDnk2uchQfmNAOTDnA
	 GFAz8wqstlJqo6JwyCe8UFtFm5VljcpB7Jnah//NlYeewZtbl5I4T32/lpuKUpHqBW
	 fBomZ3vvZ+3gGQGcgYnFXARfd/BZ4icLYtydBm0F55eZcsqHdQzapYYEgj6UjcZelp
	 7ujmV35jQELLcXSlTVUBXWX5CmW7AyN2OLHTnEAdjq2IpuZldb0LHuZop0mVDhLdLX
	 qfJAa7EdgX71ln2AC5WmNekkyB1u/JDoNe4THaSUJpKn6DaWk/wZpH/RznOmoIQpMB
	 8Slrsql68VrZw==
Date: Tue, 13 Jun 2023 20:31:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
 jolsa@kernel.org, willemb@google.com, dsahern@kernel.org,
 magnus.karlsson@intel.com, bjorn@kernel.org, maciej.fijalkowski@intel.com,
 netdev@vger.kernel.org
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
Message-ID: <20230613203125.7c7916bc@kernel.org>
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
References: <20230612172307.3923165-1-sdf@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 10:23:00 -0700 Stanislav Fomichev wrote:
> The goal of this series is to add two new standard-ish places
> in the transmit path:
> 
> 1. Right before the packet is transmitted (with access to TX
>    descriptors)

I'm not sure that the Tx descriptors can be populated piecemeal.
If we were ever to support more standard offload features, which
require packet geometry (hdr offsets etc.) to be described "call
per feature" will end up duplicating arguments, and there will be
a lot of args..

And if there is an SKB path in the future combining the normal SKB
offloads with the half-rendered descriptors may be a pain.

> 2. Right after the packet is actually transmitted and we've received the
>    completion (again, with access to TX completion descriptors)

For completions trace-style attach makes perfect sense.

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

Hm, a lot of lightweight features lately. Unbearable lightness of
features.

