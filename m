Return-Path: <netdev+bounces-10574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2887E72F2E5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24F021C20446
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D391381;
	Wed, 14 Jun 2023 03:01:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5865363
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1A7C433C0;
	Wed, 14 Jun 2023 03:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686711712;
	bh=J+s2slKhai8XoyOcd8BRcW7AAnL/2RowtfWNsgZlnt4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VJKJOxSM5D1wAB6WYS0ECG7YcHY4zcGi3xYMdXK87fVWyPnP1yKHuF7vWBX970rRG
	 HvyItXpsHSRlde4DzBOZgkq/AQxNawM8PlEiTGXSXaAaX6Rwt73IhTQISgbQTaq+rC
	 prmJR698iP3uo11HIPQrmLyh2pNxTZoMBwqefazReewy3O3hXL9ms2JfEhKYmMXRc6
	 s57ctjAqRZYnvVtHMq2NYspE040cDeDN8EGDHw9QJVwzXoMnJikrPIff7AwApStkXN
	 9DTZzPg0zvD6ZLAE32yeN4bWJCLvxVFJXnIsHDNE8/TlDTnOSz50lek7pAyym7RbPF
	 jmDXVjMZ4bu8w==
Date: Tue, 13 Jun 2023 20:01:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: "David S. Miller" <davem@davemloft.net>, Sabrina Dubroca
 <sd@queasysnail.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>, Lior Nahmanson
 <liorna@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Hannes Frederic
 Sowa <hannes@stressinduktion.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: macsec: fix double free of percpu stats
Message-ID: <20230613200150.361bc462@kernel.org>
In-Reply-To: <20230613192220.159407-1-pchelkin@ispras.ru>
References: <20230613192220.159407-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Jun 2023 22:22:20 +0300 Fedor Pchelkin wrote:
> Inside macsec_add_dev() we free percpu macsec->secy.tx_sc.stats and
> macsec->stats on some of the memory allocation failure paths. However, the
> net_device is already registered to that moment: in macsec_newlink(), just
> before calling macsec_add_dev(). This means that during unregister process
> its priv_destructor - macsec_free_netdev() - will be called and will free
> the stats again.
> 
> Remove freeing percpu stats inside macsec_add_dev() because
> macsec_free_netdev() will correctly free the already allocated ones. The
> pointers to unallocated stats stay NULL, and free_percpu() treats that
> correctly.

What prevents the device from being opened and used before
macsec_add_dev() has finished? I think we need a fix which 
would move this code before register_netdev(), instead :(
-- 
pw-bot: cr

