Return-Path: <netdev+bounces-10585-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D17DB72F345
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8354E281024
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C1B64C;
	Wed, 14 Jun 2023 03:54:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BAF363;
	Wed, 14 Jun 2023 03:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E056C433C0;
	Wed, 14 Jun 2023 03:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686714869;
	bh=xLlzm8L28ec7BJtXsq88qOGFRIhR7cLKStyGTGlmIuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O3X8HdQQLsbIeh14iAdGGYTGEShLfViN5QK9uCLZv+50ZIAvgb8kR8HQwssVql3u0
	 3rQc04LMVU9ovnrugVfQqM6u5Mb91tdkSk68LxjhhpRdDJvi/be4yIlFeREOwcvQ+K
	 6l8PDTGizGWt56jBNHRiwzDzpLRwAgtWnuUPX0Xl7jQ/Yw86TObgqoVg+c/5M25O5O
	 kY9HBHzLYuuC03NPAJo6W/7s5tOuu/jCzVcT7swivC2fJGQDoBKRjkoZr/cGT4MqQR
	 RSv00lBq6djOxGzlYthLob7CcsPObCoqNYkgroE+Qwq6oanFeR1nDXd73zt07+MxH9
	 cytYIHn9hJUKw==
Message-ID: <70d0f31b-3358-d615-a00c-7e664f5f789f@kernel.org>
Date: Tue, 13 Jun 2023 20:54:26 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
 jolsa@kernel.org, willemb@google.com, magnus.karlsson@intel.com,
 bjorn@kernel.org, maciej.fijalkowski@intel.com, netdev@vger.kernel.org
References: <20230612172307.3923165-1-sdf@google.com>
 <20230613203125.7c7916bc@kernel.org>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230613203125.7c7916bc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/13/23 9:31 PM, Jakub Kicinski wrote:
> On Mon, 12 Jun 2023 10:23:00 -0700 Stanislav Fomichev wrote:
>> The goal of this series is to add two new standard-ish places
>> in the transmit path:
>>
>> 1. Right before the packet is transmitted (with access to TX
>>    descriptors)

If a device requires multiple Tx descriptors per skb or multibuf frame,
how would that be handled within the XDP API?

> 
> I'm not sure that the Tx descriptors can be populated piecemeal.

If it is host memory before the pidx move, why would that matter? Do you
have a specific example in mind?

> If we were ever to support more standard offload features, which
> require packet geometry (hdr offsets etc.) to be described "call
> per feature" will end up duplicating arguments, and there will be
> a lot of args..
> 
> And if there is an SKB path in the future combining the normal SKB
> offloads with the half-rendered descriptors may be a pain.

Once the descriptor(s) is (are) populated, the skb is irrelevant is it
not? Only complication that comes to mind is wanting to add or remove
headers (e.g., tunnels) which will be much more complicated at this
point, but might still be possible on a per NIC (and maybe version) basis.

