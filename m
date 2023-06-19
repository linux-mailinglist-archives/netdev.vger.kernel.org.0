Return-Path: <netdev+bounces-11922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2CF7352F6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50BF828114E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD59F5381;
	Mon, 19 Jun 2023 10:40:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893183C23
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899B0C433C9;
	Mon, 19 Jun 2023 10:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687171235;
	bh=A32VZcKVct460PbyXiy0SEpYxkFlA+mChVgoKGC13xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VvE1YV7pbgTDCY3xO/1Vy4uSFVfwNSfxbjzoDv5tR5bIsVAkLbrCG5odDnpBe6Vwh
	 f5dMtO61lxlnfhjksIrUy5HSyS3G8piHZ9sD+JcjP5xsNih0CvYJNPT9VkUvTrZ7UH
	 OpoFkuuhuV+gRMumPY1YXTX54WpuRH00qUrKTyH/D0k81qHuefhf+XReLAEu13o9QN
	 AAn/9lKPcgLaC5nROiynVUvvjBTJ9S+oJdSg1spNJGahdul6PvRSbLnUNnvicbmMiE
	 H0rtAZegrL64yXltbK/Rg3AeILfFBKEfej/nz8uLw+u8ZrgtvhkQbOV1XFA4hKbmtZ
	 Hcjg3fThT0dHw==
Date: Mon, 19 Jun 2023 11:40:30 +0100
From: Lee Jones <lee@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 0/3] leds: trigger: netdev: add additional
 modes
Message-ID: <20230619104030.GB1472962@google.com>
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230617115355.22868-1-ansuelsmth@gmail.com>

On Sat, 17 Jun 2023, Christian Marangi wrote:

> This is a continue of [1]. It was decided to take a more gradual
> approach to implement LEDs support for switch and phy starting with
> basic support and then implementing the hw control part when we have all
> the prereq done.
> 
> This should be the final part for the netdev trigger.
> I added net-next tag and added netdev mailing list since I was informed
> that this should be merged with netdev branch.
> 
> We collect some info around and we found a good set of modes that are
> common in almost all the PHY and Switch.
> 
> These modes are:
> - Modes for dedicated link speed(10, 100, 1000 mbps). Additional mode
>   can be added later following this example.
> - Modes for half and full duplex.
> 
> The original idea was to add hw control only modes.
> While the concept makes sense in practice it would results in lots of 
> additional code and extra check to make sure we are setting correct modes.
> 
> With the suggestion from Andrew it was pointed out that using the ethtool
> APIs we can actually get the current link speed and duplex and this
> effectively removed the problem of having hw control only modes since we
> can fallback to software.
> 
> Since these modes are supported by software, we can skip providing an
> user for this in the LED driver to support hw control for these new modes
> (that will come right after this is merged) and prevent this to be another
> multi subsystem series.
> 
> For link speed and duplex we use ethtool APIs.
> 
> To call ethtool APIs, rtnl lock is needed but this can be skipped on
> handling netdev events as the lock is already held.
> 
> [1] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/
> 
> Changes v4:
> - Add net-next tag
> - Add additional patch to expose hw_control via sysfs
> - CC netdev mailing list
> Changes v3:
> - Add Andrew review tag
> - Use SPEED_UNKNOWN to init link_speed
> - Fix using HALF_DUPLEX as duplex init and use DUPLEX_UNKNOWN instead
> Changes v2:
> - Drop ACTIVITY patch as it can be handled internally in the LED driver
> - Reduce duplicate code and move the link state to a dedicated helper
> 
> Christian Marangi (3):
>   leds: trigger: netdev: add additional specific link speed mode
>   leds: trigger: netdev: add additional specific link duplex mode
>   leds: trigger: netdev: expose hw_control status via sysfs
> 
>  drivers/leds/trigger/ledtrig-netdev.c | 114 +++++++++++++++++++++++---
>  include/linux/leds.h                  |   5 ++
>  2 files changed, 109 insertions(+), 10 deletions(-)

Seeing as we're on -rc7 already, any reason why we shouldn't hold off
and simply apply these against LEDs once v6.5 is released?

-- 
Lee Jones [李琼斯]

