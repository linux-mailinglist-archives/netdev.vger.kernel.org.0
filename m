Return-Path: <netdev+bounces-1642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B37476FE9C0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CB8C2810E4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE94D1F184;
	Thu, 11 May 2023 02:14:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909E4EC9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAC5C433D2;
	Thu, 11 May 2023 02:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683771270;
	bh=8HDvTLAMW2dfW4OxIY0JXhwRgA6vSJyFPB6SI+F3pHE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ogGPbNLBv1s18UIBn50uP1fsht5u6Zttzvd6NReV80/yhqa4QJD3JbKOVff3JGkwf
	 n2yIZYPGYw7p4Fdr23AK67TKBSCRWDAw0jpSIfkLbF6xmFC2J89KrKHhojgWaLJAwK
	 9HovxrRivQayJ7poxK3Am+xqJw4gD4FO5I2PgQBzvlwjawq21R/bvMRoxr8Tvf+3Gs
	 JPl8YIEYHXwYl8nyC8+92uXMd/L8sMPGFzbMxkl6qwt1X4o+uJ71K0LX00PA9M3nRM
	 rjxtWxRUhXtS/cUpuVD+3GQdvYGC7AperCuSMc06j/2EE6uS/TYbRtFm9M3QiwpfzO
	 +LYqgyEHXpjTA==
Date: Wed, 10 May 2023 19:14:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Muhammad Husaini Zulkifli
 <muhammad.husaini.zulkifli@intel.com>, sasha.neftin@intel.com, Naama Meir
 <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 1/3] igc: Clean the TX buffer and TX descriptor ring
Message-ID: <20230510191428.75efff66@kernel.org>
In-Reply-To: <20230509170935.2237051-2-anthony.l.nguyen@intel.com>
References: <20230509170935.2237051-1-anthony.l.nguyen@intel.com>
	<20230509170935.2237051-2-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 May 2023 10:09:33 -0700 Tony Nguyen wrote:
> There could be a race condition during link down where interrupt
> being generated and igc_clean_tx_irq() been called to perform the
> TX completion. Properly clear the TX buffer and TX descriptor ring
> to avoid those case.

> +	/* Zero out the buffer ring */
> +	memset(tx_ring->tx_buffer_info, 0,
> +	       sizeof(*tx_ring->tx_buffer_info) * tx_ring->count);
> +
> +	/* Zero out the descriptor ring */
> +	memset(tx_ring->desc, 0, tx_ring->size);

Just from the diff and the commit description this does not seem
obviously correct. Race condition means the two functions can run 
at the same time, and memset() is not atomic.
-- 
pw-bot: cr

