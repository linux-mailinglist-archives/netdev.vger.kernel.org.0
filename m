Return-Path: <netdev+bounces-3395-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2EC4706DC9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B004A28171F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE00111B8;
	Wed, 17 May 2023 16:15:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3642101D9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D52C433D2;
	Wed, 17 May 2023 16:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684340113;
	bh=B0hBV7fk9KlirqJW1ticwtTYWCy64Ur1IklR4V7E/6c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AS8bY6JpCo4tXRdxBfN+udtGXpX1luLvzsLdW0+E6H7P8jc0KxqfLUwtJv/JKzwct
	 IgY2cmxfDkvnuTM5jG668yafJFOTvsNEvKGApcsL1tp8H19r4rhH7Om6qEp4yTPlb+
	 xW/6oDILVTG/jZIHZqQsb+4fGNj9FFM2kibRuSiDClrwvLY0eI+yBufJ8OQaUoMDVi
	 RgsMuWnVzrnMNhzJ1rCDBD3Oxm+uldZb/VJ8tP1kGzjHD57RNB4C2vMJq7U/3tGcV6
	 OWHAXd77X2LGPMYy7vXDIFmr0tHS+kHa0yzFSQhEYcHeDvFiyvMFJv9x0Cd7svBD3L
	 3uxgt61lsBhgw==
Date: Wed, 17 May 2023 09:15:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 jiri@resnulli.us, j.vosburgh@gmail.com, andy@greyhouse.net,
 netdev@vger.kernel.org, jarod@redhat.com, razor@blackwall.org,
 simon.horman@corigine.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
Message-ID: <20230517091511.30cc0803@kernel.org>
In-Reply-To: <20230517143010.3596250-1-ap420073@gmail.com>
References: <20230517143010.3596250-1-ap420073@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 14:30:10 +0000 Taehee Yoo wrote:
> When the virtual interface's feature is updated, it synchronizes the
> updated feature for its own lower interface.
> This propagation logic should be worked as the iteration, not recursively.
> But it works recursively due to the netdev notification unexpectedly.
> This problem occurs when it disables LRO only for the team and bonding
> interface type.
> 
>        team0
>          |
>   +------+------+-----+-----+
>   |      |      |     |     |
> team1  team2  team3  ...  team200
> 
> If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANGE
> event to its own lower interfaces(team1 ~ team200).
> It is worked by netdev_sync_lower_features().
> So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
> work iteratively.
> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
> interface too.
> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for its own
> lower interfaces again.
> lower and upper interfaces receive this event and generate this
> event again and again.
> So, the stack overflow occurs.
> 
> But it is not the infinite loop issue.
> Because the netdev_sync_lower_features() updates features before
> generating the NETDEV_FEAT_CHANGE event.
> Already synchronized lower interfaces skip notification logic.

Why doesn't the (already synchronized) upper not skip the update?

> So, it is just the problem that iteration logic is changed to the
> recursive unexpectedly due to the notification mechanism.
> 
> Reproducer:
> 
> ip link add team0 type team
> ethtool -K team0 lro on
> for i in {1..200}
> do
>         ip link add team$i master team0 type team
>         ethtool -K team$i lro on
> done
> 
> ethtool -K team0 lro off
> 
> In order to fix it, the notifier_ctx member of bonding/team is introduced.


