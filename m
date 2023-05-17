Return-Path: <netdev+bounces-3424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A8070710A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:45:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 343BD2813C2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EDE31F04;
	Wed, 17 May 2023 18:45:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D983B4420
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE62C433D2;
	Wed, 17 May 2023 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684349153;
	bh=NHZttYW8cSwvqQfmVINFLArH4vmjm9pstqmxk1IEI8Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Aszpvcy6h2m+DK0ZFzRxDHryVUDirLr1QpigR8M5ihNe9J+pHtPu24ZsisFXZzN/J
	 F4CiIisRyxDvNKlv3GXTmSI8cuJ3uqMoS0Os5jsgYvA2qFTdj3cIivWrgmFZggc5zr
	 /XklFE95sIxha5jk/ibnCi3nVNm6B33bNmN5UuSnopdHS0Mhynab6pYPZBkKRw4htA
	 cRYkE8GeZjtrks85io2K6tgOWxJ6twOaEFnz3+EoielZENDJuGgTuRxP1cHfFEfDY1
	 IgFbH/MCXLkh5uTYYsYAPDiilWkdZvwnPHaVhBtlP+q9aLn+kQEHAOKsCPfPVf8W0U
	 i2HmKtBau6dGQ==
Date: Wed, 17 May 2023 11:45:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Taehee Yoo <ap420073@gmail.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 jiri@resnulli.us, j.vosburgh@gmail.com, andy@greyhouse.net,
 netdev@vger.kernel.org, jarod@redhat.com, razor@blackwall.org,
 simon.horman@corigine.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
Message-ID: <20230517114552.08c38d4c@kernel.org>
In-Reply-To: <6701e21c-a430-6309-bc13-dcff529d8ab5@gmail.com>
References: <20230517143010.3596250-1-ap420073@gmail.com>
	<20230517091511.30cc0803@kernel.org>
	<6701e21c-a430-6309-bc13-dcff529d8ab5@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 May 2023 02:28:29 +0900 Taehee Yoo wrote:
>  > Why doesn't the (already synchronized) upper not skip the update?  
> 
> The skipping logic of this is existing in the netdev_sync_lower_features().
> The purpose of this is to synchronize the lower interfaces, not the 
> upper interface.
> Actually, there is no upper-only synchronization logic.
>
> Both bonding and team interfaces rely on notification mechanisms to work 
> their own logic such as synchronization.
> The notification is a broadcasting mechanism.
> So, both lower and upper receive this event, and it works its own 
> notification handling.

This is all true.

> But the notification mechanism currently doesn't have options such as 
> filtering and these interfaces receive this event with updated feature 
> flags.

We don't have to filter notifications.

> So, the upper interface can't distinguish whether the received event is 
> the first event or duplicated event.

What I was thinking was basically why does __netdev_update_features()
not return early if it made no changes? Looking thru the history this
behavior has been created by commit e7868a85e1b26bcb2e. Can we revert
that and fix the problem of syncing features on new ports differently?

