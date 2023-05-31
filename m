Return-Path: <netdev+bounces-6667-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AACED717601
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 017441C20C97
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD3A15CE;
	Wed, 31 May 2023 05:10:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13F8EC0
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9FAC433D2;
	Wed, 31 May 2023 05:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685509844;
	bh=zt9Zn5aO4JQ5Sb3gpk4cARu9iCGRhooZqWXfXF4KlV0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jG2qyzfhz1Y47S85JxqhurnDUmcmrE2b39An3aSf/jeTG1qVvT7eOZ4IinUbTlYdB
	 y5QAUgtZo6cdEdi5tUHt6rG3gvApzrXOLswAmEkKmwjTk5tVckeyHAh3eilXpUsZjI
	 77wWxorJwf5x7dHvgxVnwWxfQMoeh2gGEANbsZp1JOE0AHjpTd4DRoD5GFvHImr81P
	 hvuy/vPw/et2IY3pCxQkJO0woWqVwW0QpVfNdgIO6HOxmp260o7tDKa+RPUeuqbAKw
	 eQem+BOIefv0wLGG9K0995MPI/OwjyLamftsTZhxZnl4jX9+Hx/R1yhbjJqqPIan85
	 A+pgH2A7ICMUA==
Date: Tue, 30 May 2023 22:10:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
 dsahern@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org,
 pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
Message-ID: <20230530221043.5ae05030@kernel.org>
In-Reply-To: <CANn89iKK4Si92z91ACV_mgh4vqbecxQCHmB-SYEbq6Bsqei_Qg@mail.gmail.com>
References: <20230530151401.621a8498@kernel.org>
	<20230531010130.43390-1-kuniyu@amazon.com>
	<CANn89iKK4Si92z91ACV_mgh4vqbecxQCHmB-SYEbq6Bsqei_Qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 06:25:33 +0200 Eric Dumazet wrote:
> > Yes, if it's ok, it would be better to add a WARN_ONCE() to stable.
> >
> > If we added it only in net-next, no one might notice it and we could
> > remove UDP-Lite before the warning is available in the next LTS stable
> > tree.  
> 
> WARN_ONCE() will fire a syzbot report.
> 
> Honestly I do not  think UDP-Lite is a significant burden.
> 
> What about instead adding a CONFIG_UDPLITE and default it to
> "CONFIG_UDPLITE is not set" ?
> 
> And add a static key, with /proc/sys/net/core/udplite_enable to
> eventually save some cycles in various fast paths
> and let the user opt-in, in case it is using a distro kernel. with
> CONFIG_UDPLITE=y

oohm, fair point user-reachable WARN() is a liability.
CONFIG_UDPLITE sounds like the best available option :(
With an appropriately discouraging config text.
That way syzbot can prevent bitrot but distros will hopefully drop it.

> DCCP is more interesting because removing it would allow for a better
> organisation of tcp fields to reduce
> number of cache lines hit in the fast path.

