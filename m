Return-Path: <netdev+bounces-8156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C7D722ED7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E38F42813A8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461A31EA80;
	Mon,  5 Jun 2023 18:40:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2889168C6
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8A6C433EF;
	Mon,  5 Jun 2023 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685990408;
	bh=XKLcmGPK84JD3Ot5TEo2paSYMsmxdjiXdEhcQA58p48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W6KRlRDVgS2tYxiaLey3JvbUEo+ByRhdvpawL1zsKqQX+QUT9RlnaY18uX2EDoVrn
	 JmJtcS1wwOUxmRfUiHCGWqQpMSHD1lxxlMNJGSObY5Lt3OUuGtMhpQ+W7OXb/ru23W
	 QcqBU3FWYXcxhybpR5n0wkQMKnqJ7QmsDMED9xBHu/3e7MwmgZjKQm8Gxfa8WkbXw6
	 XTiwyyegPnQB6ZstJBVOMrFm0hqy8uAUBID28Mf/7M8QT8Z5Tfm7JpxZWaVeb1fNE+
	 MfkdKsbBf3tBiof9oVFQ6qUQjEtsyzTcz+buE7PKwkDaLIvQ8GeTDcbs5xDmb+mTQ7
	 vseXmvBAtze7g==
Date: Mon, 5 Jun 2023 20:40:04 +0200
From: Simon Horman <horms@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	Dan Carpenter <dan.carpenter@linaro.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: txgbe: Avoid passing uninitialised
 parameter to pci_wake_from_d3()
Message-ID: <ZH4sBF6frp9YjW4T@kernel.org>
References: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
 <ZH4n7vOXVh9KGExD@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH4n7vOXVh9KGExD@boxer>

On Mon, Jun 05, 2023 at 08:22:38PM +0200, Maciej Fijalkowski wrote:
> On Mon, Jun 05, 2023 at 04:20:28PM +0200, Simon Horman wrote:
> 
> Hey Simon,
> 
> > txgbe_shutdown() relies on txgbe_dev_shutdown() to initialise
> > wake by passing it by reference. However, txgbe_dev_shutdown()
> > doesn't use this parameter at all.
> > 
> > wake is then passed uninitialised by txgbe_dev_shutdown()
> > to pci_wake_from_d3().
> > 
> > Resolve this problem by:
> > * Removing the unused parameter from txgbe_dev_shutdown()
> > * Removing the uninitialised variable wake from txgbe_dev_shutdown()
> > * Passing false to pci_wake_from_d3() - this assumes that
> >   although uninitialised wake was in practice false (0).
> > 
> > I'm not sure that this counts as a bug, as I'm not sure that
> > it manifests in any unwanted behaviour. But in any case, the issue
> > was introduced by:
> > 
> >   bbd22f34b47c ("net: txgbe: Avoid passing uninitialised parameter to pci_wake_from_d3()")
> 
> wait, you are pointing to your own commit here?
> 
> this supposed to be:
> 3ce7547e5b71 net: txgbe: Add build support for txgbe
> 
> no?

Yes, sorry about that.

Will fix in a v2.

...

-- 
pw-bot: cr


