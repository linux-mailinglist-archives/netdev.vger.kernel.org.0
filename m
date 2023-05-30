Return-Path: <netdev+bounces-6227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4977154AA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8740A281021
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22041C08;
	Tue, 30 May 2023 04:58:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513587E9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886ABC433EF;
	Tue, 30 May 2023 04:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685422684;
	bh=ZGGpOq+uObnkcEWx80C+FBZ6VsPfRaAQ73HUlsFkY1A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VBswMtimzeTP8Fd10/OL6GTPRpKzRUnATE3+6olxdkhiPtO4nEC9ZDt7lzA5AySHs
	 iHLgVkrgi7bTNkVZWbrwoYBpiS69N1wuwW7ribHBV01G1uBWfAj2qZ5rrGqLHuNLob
	 CHcPJ/glWbgAxnS0fATEt+5kvIJex/91STY53qsgo6aiYKRjI1zl2Zn/Iqd6j8OMMw
	 GZsQ0gyhNF0ANL7GLCgRhPREG5+mUrfo5A47URyejc2ogEfejt2pgx3p4pQkHoj/gS
	 /99cUDEnL5HZ2l29iJO5uJHB/G2CwvsfFZlyUAzbiFMtE3+qjR2jK7NxcfvMN6NcLv
	 J0HjjvsOykriw==
Date: Mon, 29 May 2023 21:58:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Oleksij Rempel
 <linux@rempel-privat.de>, Heiner Kallweit <hkallweit1@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix a signedness bug in genphy_loopback()
Message-ID: <20230529215802.70710036@kernel.org>
In-Reply-To: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
References: <d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 14:45:54 +0300 Dan Carpenter wrote:
> The "val" variable is used to store error codes from phy_read() so
> it needs to be signed for the error handling to work as expected.
> 
> Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Is it going to be obvious to PHY-savvy folks that the val passed to
phy_read_poll_timeout() must be an int? Is it a very common pattern?
My outsider intuition is that since regs are 16b, u16 is reasonable,
and more people may make the same mistake. Therefore we should try to
fix phy_read_poll_timeout() instead to use a local variable like it
does for __ret. 

Weaker version would be to add a compile time check to ensure val 
is signed (assert(typeof(val)~0ULL < 0) or such?).

Opinions?

