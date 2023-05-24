Return-Path: <netdev+bounces-5080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F385470F9EF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83836281304
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD65F1952E;
	Wed, 24 May 2023 15:19:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7220F19528
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7791DC433D2;
	Wed, 24 May 2023 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684941575;
	bh=b0FUtTBTh0b230DQrrfvkGYuz7+7G3AZG0ETnEJJ3Ks=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j95lgJ+Yohg9mfGqQLUxF28ayZCi5FdjRe7IMbm5LWz0NAMLBohM79jnUuVSB1i/a
	 FTCvpVGB7YInPhpPuHCYzxMXy5h9drvbtJG2wLav05hIkizeIYhG7qg7atk8iORKPI
	 VtfxNQYuthGSB4ujydCClupo9zOIt7U18gnUEfYCXLQ/YkGT5GujLJohcIgG39njBi
	 3zpofnDund8ZYF3xc7lTuoSI5dPQxpw3BX/ejTrvu9OajI/wNvmqmikBWdTv+GPoPl
	 9E3ZXGBlCYLrX5JWiApLZQGzAeSERTdUY2gp2HQ41dnyRnDjk8gjoOnXJuTRcdqrLR
	 ZGwTnvzO315AA==
Date: Wed, 24 May 2023 08:19:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Luca Boccassi <bluca@debian.org>
Cc: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>, Christian
 Brauner <brauner@kernel.org>, davem@davemloft.net,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky
 <leon@kernel.org>, David Ahern <dsahern@kernel.org>, Arnd Bergmann
 <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Lennart Poettering <mzxreary@0pointer.de>,
 linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v6 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230524081933.44dc8bea@kernel.org>
In-Reply-To: <CAMw=ZnRmNaoRb2uceatrV8EAufJSKZzD2AsfT5PJE8NBBOrHCg@mail.gmail.com>
References: <20230522132439.634031-1-aleksandr.mikhalitsyn@canonical.com>
	<20230522132439.634031-2-aleksandr.mikhalitsyn@canonical.com>
	<20230522133409.5c6e839a@kernel.org>
	<20230523-flechten-ortsschild-e5724ecc4ed0@brauner>
	<CAMw=ZnS8GBTDV0rw+Dh6hPv3uLXJVwapRFQHLMYEYGZHNoLNOw@mail.gmail.com>
	<20230523140844.5895d645@kernel.org>
	<CAEivzxeS2J5i0RJDvFHq-U_RAU5bbKVF5ZbphYDGoPcMZTsE3Q@mail.gmail.com>
	<CAMw=ZnRmNaoRb2uceatrV8EAufJSKZzD2AsfT5PJE8NBBOrHCg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 11:47:50 +0100 Luca Boccassi wrote:
> > I will send SO_PEERPIDFD as an independent patch too, because it
> > doesn't require this change with CONFIG_UNIX
> > and we can avoid waiting until CONFIG_UNIX change will be merged.
> > I've a feeling that the discussion around making CONFIG_UNIX  to be a
> > boolean won't be easy and fast ;-)  
> 
> Thank you, that sounds great to me, I can start using SO_PEERPIDFD
> independently of SCM_PIDFD, there's no hard dependency between the
> two.

How about you put the UNIX -> bool patch at the end of the series,
(making it a 4 patch series) and if there's a discussion about it 
I'll just skip it and apply the first 3 patches?

In the (IMHO more likely) case that there isn't a discussion it saves
me from remembering to chase you to send that patch ;)

