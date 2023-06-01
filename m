Return-Path: <netdev+bounces-7012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 425B3719302
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED5D32815F7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8B2BA2E;
	Thu,  1 Jun 2023 06:10:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1C0A94A
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEFDC433D2;
	Thu,  1 Jun 2023 06:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599831;
	bh=fIPgNhfboYHlCutR5fCKllpOQFyZqltZTQ8EQg1nrUc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZaRrgrSpAvoTr/cZ05simuKBcTh5hg0Va2gtkE5stKlUOmiEK548QTld1m6VC1jow
	 5w+dmFfo2g5OYbNtGf6nCAFDV4LRLwAWoLQ6jhRFPucvlPuq3R5gs1ltfHyWyBKFyn
	 wMFdSUAnDv5bln/ngQeUz6Wd2JZNBVFZKhHVz/TZrZ1HHMYTGg42VqdEcRFgaYC09V
	 soszEa3no62jZURj6acmH4YbhWSQfIYEXl3woYSmXjz6DvOhmKyguEV+Q+vdj5hQDy
	 PtbuCvIaIFuge0S+ADFLvc4DtHI2G9kqVfNvhCMURehW7CCXOUQjE0tJCEztsKU0rf
	 p2OqLMkGOC7Uw==
Date: Wed, 31 May 2023 23:10:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 sasha.neftin@intel.com, richardcochran@gmail.com, Vladimir Oltean
 <vladimir.oltean@nxp.com>, Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 2/4] igc: Check if hardware TX timestamping is
 enabled earlier
Message-ID: <20230531231029.36822957@kernel.org>
In-Reply-To: <20230530174928.2516291-3-anthony.l.nguyen@intel.com>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
	<20230530174928.2516291-3-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 10:49:26 -0700 Tony Nguyen wrote:
> -	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
> +	if (unlikely(adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
> +		     skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
>  		/* FIXME: add support for retrieving timestamps from
>  		 * the other timer registers before skipping the
>  		 * timestamping request.
> @@ -1586,7 +1587,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(&adapter->ptp_tx_lock, flags);
> -		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON && !adapter->ptp_tx_skb) {
> +		if (!adapter->ptp_tx_skb) {

AFAICT the cancel / cleanup path is not synchronized (I mean for
accesses to adapter->tstamp_config) so this looks racy to me :(

