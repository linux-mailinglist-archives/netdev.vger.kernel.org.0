Return-Path: <netdev+bounces-11266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D44973255E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 528D21C20F3B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11F739A;
	Fri, 16 Jun 2023 02:45:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A590E368
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD01C433C0;
	Fri, 16 Jun 2023 02:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686883526;
	bh=gYUxWe5lBhmkMYsrBGaBMQPWQ2ckcLGPdVZjk0GP85U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q2W4JTTRMfMNSa1N88Adux27avcE66JFfT10h52ja9l+3QONDugwvypiULgHlq/8v
	 yRIvpE4e+2I2zJsSCRR43ocl4Hf+AzxUPgwxQ+h1paBcgoL4yJQMfI0WicIq0Sw4Wk
	 zQoiIy7XwLpPQUbgWc23DkGD/4GC9P21J9504FrFWUjYWXjrJ+BvrU6oNIYweAye50
	 85b9S5Bc75QIG24REpNZH9HjPkkQI8XzcUIMmvdNJtWz3io0MH8Obe9N4fVdYOJPjq
	 aIm/0P/9M6+5dOQrSRKLq3l0YXWVm0/GURvWQEmd2nal0A58o8f40p6pKXRW/3jU/9
	 ANHx9KMoWBPAA==
Date: Thu, 15 Jun 2023 19:45:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Liang Chen <liangchen.linux@gmail.com>, brouer@redhat.com,
 hawk@kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com
Subject: Re: [PATCH net-next] page pool: not return page to alloc cache
 during pool destruction
Message-ID: <20230615194524.1201bd0d@kernel.org>
In-Reply-To: <b28b0e3e-87e4-5a02-c172-2d1424405a5a@redhat.com>
References: <20230615013645.7297-1-liangchen.linux@gmail.com>
	<20230614212031.7e1b6893@kernel.org>
	<b28b0e3e-87e4-5a02-c172-2d1424405a5a@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 16:00:13 +0200 Jesper Dangaard Brouer wrote:
> Adding a DEBUG_NET_WARN_ON_ONCE will be annoying as I like to run my
> testlab kernels with CONFIG_DEBUG_NET, which will change this extreme
> fash-path slightly (adding some unlikely's affecting code layout to the
> mix).

That's counter-intuitive - the whole point of DEBUG_NET is to have 
a place where we can add checks which we don't want in production
builds. If we can't use it on the datapath we should just remove it
completely and have its checks always enabled..

I do feel your pain of having to test code both with debug enabled
and disabled, but we can't have a cookie and eat it too :(

