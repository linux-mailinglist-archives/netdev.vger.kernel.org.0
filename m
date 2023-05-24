Return-Path: <netdev+bounces-4855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8DB70EC58
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E1C51C20AF0
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 04:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF99115C2;
	Wed, 24 May 2023 04:04:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F1715B8
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D569C433D2;
	Wed, 24 May 2023 04:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684901095;
	bh=h0GPloYU1VAGgpUh/tie+7wVESLUBSFraCBtAuT3854=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HhkszsfZ6rTKFmLO70MxjxjEyH5t5GLtXOzqSyFg3csKk5knmXCzal/ZPLDFwBbZa
	 2rueLngCuYe5u99GHxsN+rmG20BcOvQjtt7NKqLejKL55Gq1qggCaGDbduq3PYo/Ca
	 RtGfNqygXL5l5XtiFAOl1dVFiG58XdCmjR1B8Ej5rziJkymRaOfsY5/3sz5qbzPIZe
	 atadsjt7JzAZjSTL/dAZFmywe6xT9KUAfY8BAgHBZfDAcWCX6ILxJarc99lXcaYLvl
	 gweyk2KB3e0G4p5hRQ1Gwc0+i8vW7Ia6XWA6HQPKfkYwllN98cDj078OhiKKBm7RyD
	 NWzwNXZ2VylMQ==
Date: Tue, 23 May 2023 21:04:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v6 2/8] net: wangxun: libwx add rx offload
 functions
Message-ID: <20230523210454.12963d67@kernel.org>
In-Reply-To: <20230523030658.17738-3-mengyuanlou@net-swift.com>
References: <20230523030658.17738-1-mengyuanlou@net-swift.com>
	<20230523030658.17738-3-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 11:06:52 +0800 Mengyuan Lou wrote:
> +static inline struct wx_dec_ptype wx_decode_ptype(const u8 ptype)
> +{
> +	return wx_ptype_lookup[ptype];
> +}

No need for inline keyword here, compiler will definitely inline this.

> +	/* If there is an outer header present that might contain a checksum
> +	 * we need to bump the checksum level by 1 to reflect the fact that
> +	 * we are indicating we validated the inner checksum.
> +	 */
> +	if (dptype.etype >= WX_DEC_PTYPE_ETYPE_IG) {
> +		skb->csum_level = 1;
> +		skb->encapsulation = 1;
> +	}

That's not right, you shouldn't set encapsulation, that field means skb
encap state / fields are valid. Just use
__skb_incr_checksum_unnecessary() please, it will do the right thing.

-- 
pw-bot: cr

