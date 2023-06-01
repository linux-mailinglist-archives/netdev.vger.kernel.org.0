Return-Path: <netdev+bounces-7185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D1E71F075
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2121B1C2104A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA4F46FE8;
	Thu,  1 Jun 2023 17:15:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC1540795
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06855C433EF;
	Thu,  1 Jun 2023 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685639715;
	bh=QfAZcd+QCdE7N/hMns1wsimPjoZruesbkhbU/kUhZRk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LIn4UV/P7WgWduHTuZ0c1iI3s6nt1m7E1jgUbW0nOhv/DTJsV1vqpAIJoBupS0Atx
	 AqeebYcwXjYAwkIzc9xY9H/2NicvfGv59NgdCe0HNHWsshKhdIPFjk8PoFzn+hcQZ5
	 AtMBSonHzBFAOZF3wti2uPz3Qhs79m+y8T1mXApr3BwvmYXzU0y/FBRqXor2HY8a6c
	 CTZKrpve3wSvLgy/YjNYjdRJS+Fvu+d4dzgyjF39kEFZwdI4Q15Rad/58BPmZQw3St
	 wFnVYpAxHVYo+wp2QOOryb9jeP75jFYNKQ2gcTQq3jnPGsrlVMwm7fArAG0nkSkMyz
	 DYXGLui2oeAHg==
Date: Thu, 1 Jun 2023 10:15:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>, Evgeniy
 Polyakov <zbr@ioremap.net>, Christian Brauner <brauner@kernel.org>,
 "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
 "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>, "leon@kernel.org"
 <leon@kernel.org>, "keescook@chromium.org" <keescook@chromium.org>,
 "socketcan@hartkopp.net" <socketcan@hartkopp.net>, "petrm@nvidia.com"
 <petrm@nvidia.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Message-ID: <20230601101514.775c631a@kernel.org>
In-Reply-To: <FD84A5B5-8C98-4796-8F69-5754C34D2172@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
	<20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
	<20230601092533.05270ab1@kernel.org>
	<B9B5E492-36A1-4ED5-97ED-1ED048F51FCF@oracle.com>
	<20230601094827.60bd8db1@kernel.org>
	<FD84A5B5-8C98-4796-8F69-5754C34D2172@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 16:53:07 +0000 Anjali Kulkarni wrote:
> > Is it possible to recode the sample so the format can be decided based
> > on cmd line argument? To be honest samples are kinda dead, it'd be best
> > if the code was rewritten to act as a selftest.  
> 
> Yes, I can recode to use a cmd line argument. Where would a selftest
> be committed?

The path flow is the same as for the sample, the file just goes to
tools/testing/selftests rather than samples/.

> This is kind of a self test in the sense that this is
> working code  to test the other kernel code. What else is needed to
> make it a selftest?

Not much, really. I think the requirement is to exit with a non-zero
return code on failure, which you already do. 0 means success; 1 means
failure; 2 means skip, IIRC.

The main work in your case would be that the selftest needs to do its
checking and exit, so the stimuli must be triggered automatically.
(You can use a bash script to drive the events.)

