Return-Path: <netdev+bounces-11284-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 561B0732690
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B86C2813EA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A11881B;
	Fri, 16 Jun 2023 05:23:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213D27C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0BBC433C0;
	Fri, 16 Jun 2023 05:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686893009;
	bh=cfvedA+APUAxhrJ767ArAlv5k/lXbdNasLfuw1iA/v8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fzEg+oqsW/+IqclK8T1ogmt1cZoCdtIoX9ldgelPE3zd6dEW2Y+GPkuMgiQomArBo
	 2dX4m/8Jx+P8Gi0ra+jlolnn9JoWGQeHEqow7siQ2k+3o/2M34rrVFccwX/sg8FM7l
	 zZq9C9dq8XvwKvPKaq4t8fhQhF6pJdyOu1fxYDiUNpW/MIEXDVuZzgPLX5/VHf3svC
	 Mk+Dq7rU8Q2hCUKPBbkWtdksTbOSQKc+LcjmY8n/8Od3ruVv9VckRtykbyZWnotFQb
	 GHM41694xUPdXlgxgY3DKncAfyCAWg8/CwJOE65miOfnEebCPTMJzy2s4y32jA5bD6
	 GmJ1He+NcUNjw==
Date: Thu, 15 Jun 2023 22:23:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
 syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com, David Ahern
 <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jens Axboe
 <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ip, ip6: Fix splice to raw and ping sockets
Message-ID: <20230615222327.15e85c55@kernel.org>
In-Reply-To: <1410156.1686729856@warthog.procyon.org.uk>
References: <1410156.1686729856@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 09:04:16 +0100 David Howells wrote:
> Splicing to SOCK_RAW sockets may set MSG_SPLICE_PAGES, but in such a case,
> __ip_append_data() will call skb_splice_from_iter() to access the 'from'
> data, assuming it to point to a msghdr struct with an iter, instead of
> using the provided getfrag function to access it.
> 
> In the case of raw_sendmsg(), however, this is not the case and 'from' will
> point to a raw_frag_vec struct and raw_getfrag() will be the frag-getting
> function.  A similar issue may occur with rawv6_sendmsg().
> 
> Fix this by ignoring MSG_SPLICE_PAGES if getfrag != ip_generic_getfrag as
> ip_generic_getfrag() expects "from" to be a msghdr*, but the other getfrags
> don't.  Note that this will prevent MSG_SPLICE_PAGES from being effective
> for udplite.
> 
> This likely affects ping sockets too.  udplite looks like it should be okay
> as it expects "from" to be a msghdr.

Willem, looks good?

