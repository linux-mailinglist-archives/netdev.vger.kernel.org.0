Return-Path: <netdev+bounces-8947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6FD72661D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A66B51C20E8A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E90F14A83;
	Wed,  7 Jun 2023 16:38:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3943563B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4819CC433D2;
	Wed,  7 Jun 2023 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686155891;
	bh=mOCacmcGoMWs5mOs0JqV3jJMWGBr0x1RSVGpTSa4rm8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RF/oDD8QDkm/XqlIqRVmdcnayFoF2R1//s9Qs4tH0drlOd6cszvgwzX4iZnd5RbyZ
	 fTyqreIvaXh+D73dGNo38Ahp4YW/JSaJHsulu7GCn4AqfuED9Xa2BUKyM8t0QpOviP
	 O+5Qs4titWGIcPx9E8YocW82NdGh7/jwdpDrZynLdjB9WtWsI1+E565E0yXGowm3aZ
	 aEv3/FSdCIUQFUBaLNJ5vRGNVEb2ml9ZMAu/SU7dzH61MOpZRsQiaHVBdrWqF13zk0
	 JHuiaUC2kUMgiIVhKvjOKDBmi1pJOygLCwHuT7DdjdpMejo8Vp/wEyvmPod9FGJBwT
	 eeStTAi7yH5TQ==
Date: Wed, 7 Jun 2023 09:38:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Tony Nguyen
 <anthony.l.nguyen@intel.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
 <edumazet@google.com>, <netdev@vger.kernel.org>, "Michal Swiatkowski"
 <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
 <rafal.romanowski@intel.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
Message-ID: <20230607093810.36b03b55@kernel.org>
In-Reply-To: <b7b63c6b-7bfb-6bd7-e361-298da38011a4@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
	<20230602171302.745492-2-anthony.l.nguyen@intel.com>
	<ZH4xXCGWI31FB/pD@boxer>
	<e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com>
	<ZH8Ik3XyOzd28ao2@boxer>
	<20230606102430.294dee2f@kernel.org>
	<b7b63c6b-7bfb-6bd7-e361-298da38011a4@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 12:29:36 +0200 Piotr Gardocki wrote:
> I need a piece of advice though:
> 1) Should I fix it in this patch set, or treat it as a separate thread?

Separate is probably better, you can post such a change directly 
to netdev, without going via the Intel tree.

> 2) I suppose the change is required only in dev_set_mac_address function, but
> am I right assuming we should do it before call to dev_pre_changeaddr_notify
> and return from function early? What about call to add_device_randomness?

I'd add the check right after the netif_device_present() check and not
worry about notifier or randomness. The address isn't changing so
nothing to notify about and no real randomness to be gained.

