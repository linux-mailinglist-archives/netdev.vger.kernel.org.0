Return-Path: <netdev+bounces-10202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C8DA72CD07
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 715CB281167
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A0B21074;
	Mon, 12 Jun 2023 17:39:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348241F189
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DE1C433D2;
	Mon, 12 Jun 2023 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686591542;
	bh=Uu3rCUxZa2FKssuywryrhaGDRaM51IT40AZmhi3ZQGY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UpgruHT9rVrN/Czamm4mV+WOZkK/yQeltubSNrYzVPrf2tYWO1SI6UtBNoBE7nzT9
	 F4vMJtccfuJIoKHSVSH2BtSlszRcG04jYuSgviwR0oCL6CLaFT2UIeLjtBKLIvsL4K
	 1TsyFlJSDXCn+qL3TOtjxBGyTVziQcYl8VJoz/XebJkQ9U9Bbpa2dSnQyNlioe4lqC
	 bf29izMIxOh1DMPSFgHwatnEG92vM31flHDkY6qiMwsgwzwt1gCClE4VWPnYh4glpV
	 5EwQWOYjwM3YP7o96iZc7KE+WTyz4OM1j75YC/gf+I9bneKh+d2nYP+oO1EXJ+pr73
	 eIvOEjSsdu5Gw==
Date: Mon, 12 Jun 2023 10:39:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 <netdev@vger.kernel.org>, <przemyslaw.kitszel@intel.com>,
 <michal.swiatkowski@linux.intel.com>, <pmenzel@molgen.mpg.de>,
 <anthony.l.nguyen@intel.com>, <simon.horman@corigine.com>,
 <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next] net: add check for current MAC address in
 dev_set_mac_address
Message-ID: <20230612103901.06efe4d6@kernel.org>
In-Reply-To: <f77b5c89-0f3d-80f9-19f4-f82a2ebf524e@intel.com>
References: <20230609165241.827338-1-piotrx.gardocki@intel.com>
	<20230609234439.3f415cd0@kernel.org>
	<b4242291-3476-03cc-523f-a09307dd0d08@intel.com>
	<ZIc7y9PdEdyCBb9r@boxer>
	<f77b5c89-0f3d-80f9-19f4-f82a2ebf524e@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 18:43:01 +0200 Piotr Gardocki wrote:
> On 12.06.2023 17:37, Maciej Fijalkowski wrote:
> > On Mon, Jun 12, 2023 at 04:49:47PM +0200, Piotr Gardocki wrote:  
> >> Before re-sending I just want to double check.
> >> Did you mean checking if sa->sa_family == AF_LOCAL ?
> >> There's no length in sockaddr.
> >>
> >> It would like this:
> >> 	if (sa->sa_family == AF_LOCAL &&
> >> 	    ether_addr_equal(dev->dev_addr, sa->sa_data))
> >> 		return 0;  
> > 
> > I believe Jakub just wanted this:
> > 
> > 	if (dev->addr_len)
> > 		if (ether_addr_equal(dev->dev_addr, sa->sa_data))
> > 			return 0;
> > 
> > so no clue why you want anything from sockaddr?  
> 
> I understood that dev->type and dev->addr_len can just be different
> than AF_LOCAL and 48 bits in this function.
> Your version does not convince me, let's wait for Jakub's judgement.

I'm probably missing something because I'm not sure where 
the discussion about AF_LOCAL came from. All I meant is:

	if (!memcmp(dev->dev_addr, sa->sa_data, dev->addr_len))
		return 0;

