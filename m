Return-Path: <netdev+bounces-9133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A761B72767E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62128281657
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13BC46B5;
	Thu,  8 Jun 2023 05:01:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885FA111A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFD3C433EF;
	Thu,  8 Jun 2023 05:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686200488;
	bh=uMrMVly8veTYCq4HdOYufKR4oc4LSqg1YVmq1jxs+7Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MmxnIXUQZ+S8jjhBUONfER3gImIjP6RDXQP8hZU6bm+19pwlj0BDOuprG3+zqvgFA
	 WbtEtsYFlKyFQz9yU4pG+Cm3XWIitccDy0J/s5rFAn4p1ktaRhAqARi0vxxDzrkiVQ
	 WuGjHaeDcLxHl0aG5lV0Of/Q0SKKvEomdxWKoXQgsZoY+QpNDlWgFrzUNWvlJXRLja
	 FGShtGIT/An9zL6FCXDI3YSIkkNaHOfcDgwSOsC42BT4tdTyO8gX3Fp9ni08TNFOop
	 6o58hpGRV8/nPIEHkSG5Q+DPhxMi2UeG8gkqmoGuV0YH7sJZf6f3J9ZaOO6re8JvOC
	 Nhw54ibk2q6pw==
Date: Wed, 7 Jun 2023 22:01:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 b.a.t.m.a.n@lists.open-mesh.org, Vladislav Efanov <VEfanov@ispras.ru>,
 stable@kernel.org, Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed
 work
Message-ID: <20230607220126.26c6ee40@kernel.org>
In-Reply-To: <20230607155515.548120-2-sw@simonwunderlich.de>
References: <20230607155515.548120-1-sw@simonwunderlich.de>
	<20230607155515.548120-2-sw@simonwunderlich.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 17:55:15 +0200 Simon Wunderlich wrote:
> The reason for these issues is the lack of synchronization. Delayed
> work (batadv_dat_purge) schedules new timer/work while the device
> is being deleted. As the result new timer/delayed work is set after
> cancel_delayed_work_sync() was called. So after the device is freed
> the timer list contains pointer to already freed memory.

I guess this is better than status quo but is the fix really complete?
We're still not preventing the timer / work from getting scheduled
and staying alive after the netdev has been freed, right?

