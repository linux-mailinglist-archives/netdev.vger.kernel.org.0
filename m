Return-Path: <netdev+bounces-11705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 602B9733F57
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 10:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00E24281945
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058626FDC;
	Sat, 17 Jun 2023 08:00:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC2F63B3
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 08:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF2BC433C9;
	Sat, 17 Jun 2023 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686988816;
	bh=aGI1EtvgBKMftc0nB3TQWOCGMnklOHnyR3VXyWdVZQg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Icfuzb7HVC6Lo7zbjg3SbnEvDeznMXzJVO2D7UvmKiN5hLeFzqqWuo20yhqKtnzJ4
	 HmDa1kAV2MN2xD0cICGKcqnl2b9k5b80qaMAn2AU4z7dQOT6B2BCy9sW1pRHn2oDA1
	 xqSQo9n5BzhW2FP4d8mBTUH6PFZl4Debp5VQa2Yg24XTqOOchPQKBZMtcuctEoxza1
	 9d8EDsEeQbl2ZcWRXTTcW3u1BqxQESLhB/wNhWn+VqzyfYkXFeR1ZbzWPiSuEqFbNU
	 i1JlsysT/BlaLwGRAEXkeeqY2MLuH15LgiRCN09W0LRrXQ3zngb5ZS1j/xs9za0Xvu
	 ecOPwxe80pm/w==
Date: Sat, 17 Jun 2023 01:00:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, David Ahern
 <dsahern@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 net-next 1/5] ipv6: rpl: Remove pskb(_may)?_pull() in
 ipv6_rpl_srh_rcv().
Message-ID: <20230617010014.00f34757@kernel.org>
In-Reply-To: <20230614230107.22301-2-kuniyu@amazon.com>
References: <20230614230107.22301-1-kuniyu@amazon.com>
	<20230614230107.22301-2-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 16:01:03 -0700 Kuniyuki Iwashima wrote:
> -	if (!pskb_may_pull(skb, ipv6_rpl_srh_size(n, hdr->cmpri,
> -						  hdr->cmpre))) {

Are we checking that 

	ipv6_rpl_srh_size(n, hdr->cmpri, hdr->cmpre) < (hdrlen + 1) << 3

somewhere?

also nit:

> As Eric Dumazet pointed out [0], ipv6_rthdr_rcv() pulls these data
> 
>   - Segment Routing Header : 8
>   - Hdr Ext Len            : skb_transport_header(skb)[1] << 3

+1 missing here, AFAICT

