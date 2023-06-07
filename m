Return-Path: <netdev+bounces-8961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12203726688
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C01082811F6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB2A35B4D;
	Wed,  7 Jun 2023 16:55:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD4E63B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B56FC433D2;
	Wed,  7 Jun 2023 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686156943;
	bh=lHpEd50gTEijmEkCWFoSmf/58Vv4Gh9yH0NWwWRI72s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BIGFLMdMuRmdqyJ2qczERmqoGOrsBTFZf0BiKTQ6pXacpR/QWGXGR8/+TfyXRKinm
	 /750GR+7G0ymWTqZOOJjd5COL8MhF7UOqQP3xcSmq3v6828yxllyjaNR8fOzlF+zS2
	 PtrxBwx7qOZwG4YFRf4WW8SiLBC72+05royNh0kS33pNY+ekXbfapAzMl1xU0zyu+n
	 F4UurRtC/XLSBkKAtH05rW5vMvfg+9qckLbJXwYSw1qgDoJsnWgaFAMHi3UixJYeDc
	 kSBwE6Ph2mNlIXIuQIaM8dg0qpi1Zus2is2ZZZd6tHhQJJjmsMEyMNECtM8Sunwyzl
	 y4xlZhQ6tnNMg==
Date: Wed, 7 Jun 2023 09:55:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Chuck Lever <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 03/14] splice, net: Use
 sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
Message-ID: <20230607095541.586a3300@kernel.org>
In-Reply-To: <20230607140559.2263470-4-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-4-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 15:05:48 +0100 David Howells wrote:
> Replace generic_splice_sendpage() + splice_from_pipe + pipe_to_sendpage()
> with a net-specific handler, splice_to_socket(), that calls sendmsg() with
> MSG_SPLICE_PAGES set instead of calling ->sendpage().
> 
> MSG_MORE is used to indicate if the sendmsg() is expected to be followed
> with more data.
> 
> This allows multiple pipe-buffer pages to be passed in a single call in a
> BVEC iterator, allowing the processing to be pushed down to a loop in the
> protocol driver.  This helps pave the way for passing multipage folios down
> too.
> 
> Protocols that haven't been converted to handle MSG_SPLICE_PAGES yet should
> just ignore it and do a normal sendmsg() for now - although that may be a
> bit slower as it may copy everything.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

