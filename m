Return-Path: <netdev+bounces-4053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5859F70A553
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 06:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CBBC281B41
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4727363;
	Sat, 20 May 2023 04:30:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D15A64D
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 04:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5EFC433EF;
	Sat, 20 May 2023 04:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684557042;
	bh=vk1WpJSGWERPP8ZVYUIJeoVorXzoNuk7QboDjtn3nR8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hXiKDUYkyXGdmOmUcxFusHKrbC7WSJWkQy943yq4YkJ7X85yx1h+0sewANQpEgRWJ
	 5RLVFIWYZ0yfANTFSIEILDm9VUP9V64GCRFE7vYdVs/6twLZkAShP/uAh0vbXdSPre
	 nMsIe4o+gd3usFD92Ni9IkKV79ZIAjd+hPnFLQObEZivy02p09toBeIxD7Qq5ZHksf
	 d/iSLptwAsSocydZjogV6ufEKB3Ct6Q0N1NW0HZq/URtWOYVZ9xCSSfB61zuUvati5
	 uIRnfh93ealqmY710WfsuH761tI7E9lKKeEjtq5h/7Vo3CLLtBMv5RVCitZqIRV6c7
	 bWlB9v1WD+Ywg==
Date: Fri, 19 May 2023 21:30:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Manish Chopra <manishc@marvell.com>
Cc: <netdev@vger.kernel.org>, <aelior@marvell.com>, <palok@marvell.com>,
 Sudarsana Kalluru <skalluru@marvell.com>, David Miller
 <davem@davemloft.net>
Subject: Re: [PATCH v4 net] qede: Fix scheduling while atomic
Message-ID: <20230519213040.0ff30813@kernel.org>
In-Reply-To: <20230518145214.570101-1-manishc@marvell.com>
References: <20230518145214.570101-1-manishc@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 May 2023 20:22:14 +0530 Manish Chopra wrote:
> Bonding module collects the statistics while holding
> the spinlock, beneath that qede->qed driver statistics
> flow gets scheduled out due to usleep_range() used in PTT
> acquire logic which results into below bug and traces -

>  	struct qede_dump_info		dump_info;
> +	struct delayed_work		periodic_task;
> +	unsigned long			stats_coal_interval;
> +	u32				stats_coal_ticks;

It's a bit odd to make _interval ulong and ticks u32 when _ticks will
obviously be much larger..

Also - s/ticks/usecs/ ? I'd have guessed interval == usecs, ticks ==
jiffies without reading the code, and the inverse is true.

> +	spinlock_t			stats_lock; /* lock for vport stats access */
>  };

> +	if (edev->stats_coal_ticks != coal->stats_block_coalesce_usecs) {
> +		u32 stats_coal_ticks, prev_stats_coal_ticks;
> +
> +		stats_coal_ticks = coal->stats_block_coalesce_usecs;
> +		prev_stats_coal_ticks = edev->stats_coal_ticks;
> +
> +		/* zero coal ticks to disable periodic stats */
> +		if (stats_coal_ticks)
> +			stats_coal_ticks = clamp_t(u32, stats_coal_ticks,
> +						   QEDE_MIN_STATS_COAL_TICKS,
> +						   QEDE_MAX_STATS_COAL_TICKS);
> +
> +		stats_coal_ticks = rounddown(stats_coal_ticks, QEDE_MIN_STATS_COAL_TICKS);
> +		edev->stats_coal_ticks = stats_coal_ticks;

Why round down the usecs?  Don't you want to return to the user on get
exactly what set specified?  Otherwise I wouldn't bother saving the
usecs at all, just convert back from jiffies.

> +		if (edev->stats_coal_ticks) {
> +			edev->stats_coal_interval = (unsigned long)edev->stats_coal_ticks *
> +							HZ / 1000000;

usecs_to_jiffies()

> +			if (prev_stats_coal_ticks == 0)
> +				schedule_delayed_work(&edev->periodic_task, 0);
> +		}
> +
> +		DP_VERBOSE(edev, QED_MSG_DEBUG, "stats coal interval=%lu jiffies\n",
> +			   edev->stats_coal_interval);
> +	}
> +
>  	if (!netif_running(dev)) {
>  		DP_INFO(edev, "Interface is down\n");
>  		return -EINVAL;
-- 
pw-bot: cr

