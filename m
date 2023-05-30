Return-Path: <netdev+bounces-6584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BE8717079
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3030D281324
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF3331F1B;
	Tue, 30 May 2023 22:14:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83F3200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45054C433D2;
	Tue, 30 May 2023 22:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685484842;
	bh=6dLqZ5TtGyzusZQYo/+adUos9dbUdyOJWy4guY6rH+g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f9Dasf+TiR3ATIxZ02xalhbDNPwG+xIasRBuSD91vMeVvrxoMT+A+dWfUCJBXBQuG
	 mRxibcWDQ0UJQd+hzk0zXToJ/V3brUlTTJDXhoRpC6MabJAKxThdgPco3SzS9DQn3m
	 rap0VCRhY+mciTaETkA/zv7Z8Db81blZ7+WBQ1rd5wu2LLpPAhHwvFO7hTWNNrsbY4
	 T7McOCGAyZBaovgYPEsH9Bb3/8Rp9svWxjOHZWaSvzhq/R4FazRew4lRZBi1OVYGY8
	 Q9hrpb73TgL3JUDLRCjC5ZiZtioHdyrDGecfCkn+Z6wlob3FGA3NdP+2FsT7xdbbGp
	 QaynLqze5TSrw==
Date: Tue, 30 May 2023 15:14:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
 dsahern@kernel.org, edumazet@google.com, kuni1840@gmail.com,
 netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
Message-ID: <20230530151401.621a8498@kernel.org>
In-Reply-To: <CAF=yD-Je+-t+tabGi6YOXAHjG7Osr+p3X=Utw=-24oMpE+08Jw@mail.gmail.com>
References: <CAF=yD-L88D+vxGcd1u9y07VKW242_macrQ+Q10ZCo_br9z2+ow@mail.gmail.com>
	<20230530173422.71583-1-kuniyu@amazon.com>
	<CAF=yD-Je+-t+tabGi6YOXAHjG7Osr+p3X=Utw=-24oMpE+08Jw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 16:16:20 -0400 Willem de Bruijn wrote:
> Is it a significant burden to keep the protocol, in case anyone is
> willing to maintain it?
> 
> If consensus is that it is time to remove, a warning may not be
> sufficient for people to notice.
> 
> Perhaps break it, but in a way that can be undone trivially,
> preferably even without recompiling the kernel. Say, returning
> EOPNOTSUPP on socket creation, unless a sysctl has some magic
> non-deprecated value. But maybe I'm overthinking it. There must be
> prior art for this?

It may be the most intertwined feature we attempted to remove.
UFO was smaller, right?

Did deprecation warnings ever work? 

How about we try to push a WARN_ONCE() on socket creation to net and
stable? With a message along the lines of "UDP lite is assumed to have
no users, and is been deleted, please contact netdev@.."

Then delete the whole thing in net-next? Hopefully pushing to stable
would expedite user reports? We'll find out if Greg throws rotten fruit
at us or not..

