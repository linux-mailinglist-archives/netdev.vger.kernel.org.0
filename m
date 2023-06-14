Return-Path: <netdev+bounces-10780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3EB8730475
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B68528145E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FCA10966;
	Wed, 14 Jun 2023 16:01:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B4101ED
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CCAC433C0;
	Wed, 14 Jun 2023 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686758488;
	bh=c/w30hWZPq7B/xF67XMBljxlZ1LiFXkgssX8UYL4sVU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oSYDBXh/T+vZ89y12Y2Ui0TIGUC+XmnpqzCftxHWAsrc1igZbdGpK2Cmfkfsd3SOm
	 04sXTBbwJwKI8TWMpjEp2+93uGQ+STTU7g9riaCKjA+lyQKcLwn8LcEsidVhBKG+0v
	 hGGVf3q/HVZZE6w9EO3G3qij2XSNRJon6zNcm0NuycxURdV65WtJldVZms9AvW/RGg
	 iRqh+23gxW5LdD8y80nUJe9hW8VG1kkU1UyPzPHgGXIsC4Er0jWD1LKqMMKai7jE9e
	 5hzR8h11oofrPEwINz3t5QuAsuRHnY6w/dZ0fotIw2YT93OmaTC3NFrLqVMLhWGtZB
	 ITfJdFhpBXyYg==
Date: Wed, 14 Jun 2023 09:01:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>, Lior Nahmanson
 <liorna@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Hannes Frederic
 Sowa <hannes@stressinduktion.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: macsec: fix double free of percpu stats
Message-ID: <20230614090126.149049b1@kernel.org>
In-Reply-To: <ZImx5pp98OSNnv4I@hog>
References: <20230613192220.159407-1-pchelkin@ispras.ru>
	<20230613200150.361bc462@kernel.org>
	<ZImx5pp98OSNnv4I@hog>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 14:26:14 +0200 Sabrina Dubroca wrote:
> > What prevents the device from being opened and used before
> > macsec_add_dev() has finished? I think we need a fix which 
> > would move this code before register_netdev(), instead :(  
> 
> Can the device be opened in parallel? We're under rtnl here.
> 
> If we want to move that code, then we'll also have to move the
> eth_hw_addr_inherit call that's currently in macsec's ndo_init: in
> case the user didn't give an SCI, we have to make it up based on the
> device's mac address (dev_to_sci(dev, ...)), whether it's set by the
> user or inherited. I can't remember if I had a good reason to put the
> inherit in ndo_init.

Ah, you're right, this is a link creation path.
-- 
pw-bot: ur

