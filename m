Return-Path: <netdev+bounces-6983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A517191A5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38DCC1C20F59
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 04:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53546ADB;
	Thu,  1 Jun 2023 04:15:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630D046BF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 04:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9171C433D2;
	Thu,  1 Jun 2023 04:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685592939;
	bh=cCxeyczHrcByYedsISfqMCKf4898Z5Z9EOJEEbECPeU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OSBW++l5t28l85Li1ER7oYT44nptNE179sv8QtFcU/OSyvKALRHWTB+cM5h93qj/V
	 NGL4cezvGwZ0UmeLAQRLXgpi/0A7XddFFotY+uPKxF73L5rl6MIRZkSWK0t+MvEyn5
	 S5Shd/9k3QseGLpxgdOkGNM6QXMTCvNEctj2CX0aVNtMGvKcWY8SxMuW7jtozSFuwk
	 fv8rUpfZh+N+avYUT8+mL+IvszFdpTdp2t5xrRWL4fuJ1D30cQYKXo5zjNlQwUBfOp
	 T5EjQqAYvv/5j/f0yzmo1pvlDuThMLzK0Xm+bQOPqOsS+sSNPcIzJ6/D+8wMSEwHyO
	 r3IW+PPiPg6YQ==
Date: Wed, 31 May 2023 21:15:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stefan Roesch <shr@devkernel.io>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Message-ID: <20230531211537.2a8fda0f@kernel.org>
In-Reply-To: <qvqwleh41f8x.fsf@devbig1114.prn1.facebook.com>
References: <20230518211751.3492982-1-shr@devkernel.io>
	<20230518211751.3492982-2-shr@devkernel.io>
	<20230531103224.17a462cc@kernel.org>
	<qvqwleh41f8x.fsf@devbig1114.prn1.facebook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 12:16:50 -0700 Stefan Roesch wrote:
> > This will conflict with:
> >
> >     https://git.kernel.org/netdev/net-next/c/c857946a4e26
> >
> > :( Not sure what to do about it..
> >
> > Maybe we can merge a simpler version to unblock io-uring (just add
> > need_resched() to your loop_end callback and you'll get the same
> > behavior). Refactor in net-next in parallel. Then once trees converge
> > do simple a cleanup and call the _rcu version?  
> 
> Jakub, I can certainly call need_resched() in the loop_end callback, but
> isn't there a potential race? need_resched() in the loop_end callback
> might not return true, but the need_resched() call in napi_busy_poll
> does?

need_resched() is best effort. It gets added to potentially long
execution paths and loops. Extra single round thru the loop won't 
make a difference.

