Return-Path: <netdev+bounces-3790-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B971E708DD5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BFF9281AEE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 02:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA5A36E;
	Fri, 19 May 2023 02:35:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095B190
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB56C433D2;
	Fri, 19 May 2023 02:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684463703;
	bh=du0AOTEUxPi+TqqbX9Fy1OdbLVoELH7arYiLp0d/czI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ni6NR5sB5gh3D26HkSY14vcilrJKY/54tRBfPAc8JWcGBOIHM1KOFQXyzlN66CB3T
	 J1hCtVArtc6o2yNGHopEoqZD3DxbEAsLYip/R4rqDKhNz1xr3w9jwZkoiyVnuv6128
	 q65NMvyyqY8bUzbh/YxBalovvc2wVbZoFvRNIoWPV5jgt11n5yEf69sYF5jx8cPynQ
	 nieuNR5afeovQ2if3b4l7J8em9C+s6jZ2gC7Oo5aMjTHBMZNhpzWxImAWS2pHXSRaz
	 xdckO1y3CDaCWBKQR2RMi/BNynTTGGFUZxbXhhJBKL14YY9I7wr9h/Ru84HL+e2mC0
	 qHxA778xnylUQ==
Message-ID: <5b949924-65bb-9b6d-0e7f-252c12476849@kernel.org>
Date: Thu, 18 May 2023 20:35:02 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next v2 0/2] Mitigate the Issue of Expired Routes
 in Linux IPv6 Routing Tables
Content-Language: en-US
To: Kui-Feng Lee <sinquersw@gmail.com>, Kui-Feng Lee <thinker.li@gmail.com>,
 netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
 kernel-team@meta.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Cc: Kui-Feng Lee <kuifeng@meta.com>, Ido Schimmel <idosch@idosch.org>
References: <20230517183337.190591-1-kuifeng@meta.com>
 <61248e45-c619-d5f2-95a0-5971593fbe8d@kernel.org>
 <337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
 <15c7358b-ab69-38af-60fc-d6c8778f25e8@kernel.org>
 <1284f846-f8ed-d95a-4476-40e2de26c092@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <1284f846-f8ed-d95a-4476-40e2de26c092@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/18/23 12:51 PM, Kui-Feng Lee wrote:
> This is one of solutions I considered at beginning.
> With this approach, we can have a maximum
> number of entries like what neighbor tables do.
> Remove entries only if the list reach the maximum without running
> a GC timer.  However, it can be very inefficient to insert a new entry
> ordered. Stephen mentioned 3 million routes on backbone router
> in another message.  We may need something more complicated
> like RB-tree or HEAP to reduce the overhead.

I do not believe so. Not every route will have an expiration timer. Only
those are added to the new, time ordered list_head.

And you can not cap the number of entries in a FIB.

