Return-Path: <netdev+bounces-12058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEA8735D77
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E763C28105B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D959E1428C;
	Mon, 19 Jun 2023 18:28:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8019D1427B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE39C433C8;
	Mon, 19 Jun 2023 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687199331;
	bh=E9u7K9JH+dqmz9UAQAfDkvOH6k1Kob+AEXDh4lGTknc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q8E5iMqNlimEHdFM/5df9pJap90oEqlwZEp6jIkNp9JJHvSGCVnBZXuL0yNm9/pjq
	 KnNkxaC6dDHAWhMZdpepXnnCgWGOrT9WxOWUNH1H27wSUrgRje2xL8C3aO+YQh8tKg
	 6cqsBk6c6YpqQ1KOemQcYBPj3k6XuhbCU/P2cPyzUjD29wC5XXxrDmA6UjKww1rp0h
	 nqoU7Ux5kVgQgrcOpegmOZTRr7iuVIpRC3THh2Df0ICwt4N/XUTP3cszSVlKXGyGiu
	 f4IBg6nzLwxtX+h/b6GhWig488s3t5vkvP80ajvjo70dBgmDCVXXKmmyuOTcocL32I
	 ZePAYQkaHEybg==
Date: Mon, 19 Jun 2023 11:28:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
 <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Gal Pressman
 <gal@nvidia.com>
Subject: Re: [net-next 07/15] net/mlx5: Bridge, expose FDB state via debugfs
Message-ID: <20230619112849.06252444@kernel.org>
In-Reply-To: <87v8fjvnhq.fsf@nvidia.com>
References: <20230616201113.45510-1-saeed@kernel.org>
	<20230616201113.45510-8-saeed@kernel.org>
	<20230617004811.46a432a4@kernel.org>
	<87v8fjvnhq.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Jun 2023 11:37:30 +0300 Vlad Buslov wrote:
> On Sat 17 Jun 2023 at 00:48, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 16 Jun 2023 13:11:05 -0700 Saeed Mahameed wrote:  
> >> $ cat mlx5/0000\:08\:00.0/esw/bridge/bridge1/fdb
> >> DEV              MAC               VLAN              PACKETS                BYTES              LASTUSE FLAGS
> >> enp8s0f0_1       e4:0a:05:08:00:06    2                    2                  204           4295567112   0x0
> >> enp8s0f0_0       e4:0a:05:08:00:03    2                    3                  278           4295567112   0x0  
> >
> > The flags here are the only thing that's mlx5 specific?  
> 
> Not exactly. This debugfs exposes the state of our bridge offload layer.
> For example, when VF representors from different eswitches are added to
> the same bridge every FDB entry on such bridge will have multiple
> underlying offloaded steering rules (one per eswitch instance connected
> to the bridge). User will observe the entries in all connected 'fdb'
> debugfs' (all except the 'main' entry will have flag
> MLX5_ESW_BRIDGE_FLAG_PEER set) and their corresponding counters will
> increment only on the eswitch instance that is actually processing the
> packets, which depends on the mode (when bonding device is added to the
> bridge in single FDB LAG mode all traffic appears on eswitch 0, without
> it the the traffic is on the eswitch of parent uplink of the VF). I
> understand that this is rather convoluted but this is exactly why we are
> going with debugfs.
> 
> > Why not add an API for dumping this kind of stats that other drivers
> > can reuse?  
> 
> As explained in previous paragraph we would like to expose internal mlx5
> bridge layer for debug purposes, not to design generic bridge FDB
> counter interface. Also, the debugging needs of our implementation may
> not correspond to other drivers because we don't have a 'hardware
> switch' on our NIC, so we do things like learning and ageing in
> software, and have to deal with multiple possible mode of operations
> (single FDB vs merged eswitch from previous example, etc.).

Looks like my pw-bot shenanigans backfired / crashed, patches didn't
get marked as Changes Requested and Dave applied the series :S

I understand the motivation but the information is easy enough to
understand to potentially tempt a user to start depending on it for
production needs. Then another vendor may get asked to implement
similar but not exactly the same set of stats etc. etc.

Do you have customer who will need this?

At the very least please follow up to make the files readable to only
root. Normal users should never look at debugfs IMO.

