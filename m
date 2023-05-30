Return-Path: <netdev+bounces-6237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F1E57154D5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 328BC1C20B14
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BBE4A1A;
	Tue, 30 May 2023 05:18:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D45F4A12
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E3DC433EF;
	Tue, 30 May 2023 05:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685423890;
	bh=TmcAKLb36S0mfPW5+98IjKrwm1yuWF74UnQr6qihhNo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SJAsnH5MKs8ERiYQlGGkUvq1av793AuCSQfI6cfI+K9+mffGwid+rQgxebgHnIz44
	 fKnXg606WNs0yP064eYDHqRb40sBk3iZYgXgWXOXAg/GS7pGUC21rJtTTzGPaFolmr
	 fC0Kf90kQvhzanjHAyd5Ar5HvUOBssX9ZB0JXf8Z4VfO8NH9d+TWSL27LA+49keLUE
	 Q/4XOkKtI5nUacEXlA4Tpxg1i2bAziTtaamdORCy/jY6LKF4FCdoWmoEZZkifitVGd
	 uBsXXlzdTIZ6hY2aSMXka1FG2U9RdSuMvlnIN5y/RQ4CZq7hXq28dqxRpbMXe1HG53
	 gL1kn2u/8ntMA==
Date: Mon, 29 May 2023 22:18:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
 <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
 <taras.chornyi@plvision.eu>, <saeedm@nvidia.com>, <leon@kernel.org>,
 <petrm@nvidia.com>, <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
 <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
 <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
 <roopa@nvidia.com>, <razor@blackwall.org>, <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 1/8] skbuff: bridge: Add layer 2 miss
 indication
Message-ID: <20230529221808.360b04c6@kernel.org>
In-Reply-To: <20230529114835.372140-2-idosch@nvidia.com>
References: <20230529114835.372140-1-idosch@nvidia.com>
	<20230529114835.372140-2-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 May 2023 14:48:28 +0300 Ido Schimmel wrote:
> For EVPN non-DF (Designated Forwarder) filtering we need to be able to
> prevent decapsulated traffic from being flooded to a multi-homed host.
> Filtering of multicast and broadcast traffic can be achieved using the
> following flower filter:
> 
>  # tc filter add dev bond0 egress pref 1 proto all flower indev vxlan0 dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 action drop
> 
> Unlike broadcast and multicast traffic, it is not currently possible to
> filter unknown unicast traffic. The classification into unknown unicast
> is performed by the bridge driver, but is not visible to other layers
> such as tc.
> 
> Solve this by adding a new 'l2_miss' bit to the tc skb extension. Clear
> the bit whenever a packet enters the bridge (received from a bridge port
> or transmitted via the bridge) and set it if the packet did not match an
> FDB or MDB entry. If there is no skb extension and the bit needs to be
> cleared, then do not allocate one as no extension is equivalent to the
> bit being cleared. The bit is not set for broadcast packets as they
> never perform a lookup and therefore never incur a miss.

Acked-by: Jakub Kicinski <kuba@kernel.org>

