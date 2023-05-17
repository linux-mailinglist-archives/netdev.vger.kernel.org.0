Return-Path: <netdev+bounces-3302-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5A1706636
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71CD61C20F8B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D85219E5A;
	Wed, 17 May 2023 11:05:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5709182C3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D99C43321;
	Wed, 17 May 2023 11:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684321504;
	bh=dP7yShpUMKY1hlEFVakjZvlEQOr+IanDVhIYO9CmG5w=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=sYVd5TaLHaPo10KrzLin9+p+UZcAoZKhIB0zTnfJM7/tDjj2vQxqPnfkbpkAM5XRF
	 yvmTLmdAv72F8B2Y+gjCAO1XYQNSTXHJN3QiMpNZqi7oqOkGx2+RSze+BxiWbydQBL
	 rYlmk8K+8VlkuNP5OXxRxbYvyXQAHsQDGI/L3zhw/CpJL09omAQBBP3DQWyytuPbOn
	 OVNkVLBvBe6n+fPagVJiSoAFJlfbV5i09g10Fku9u5aU59aSs+zx+yxdlbnGxrfJYI
	 o+CDHbWACrq+ubGB54hIIudG4ITIKhR3Vi7MlyWQxuPjEAoXVZtc3t2rI4URVE3pL4
	 F7QEZsJf6fO/w==
From: Kalle Valo <kvalo@kernel.org>
To: Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: linux-pci@vger.kernel.org,  Bjorn Helgaas <bhelgaas@google.com>,
  Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,  Rob Herring
 <robh@kernel.org>,  Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
  Emmanuel Grumbach <emmanuel.grumbach@intel.com>,  "Rafael J . Wysocki"
 <rafael@kernel.org>,  Heiner Kallweit <hkallweit1@gmail.com>,  Lukas
 Wunner <lukas@wunner.de>,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo
 Abeni <pabeni@redhat.com>,  Carl Huang <cjhuang@codeaurora.org>,
  ath11k@lists.infradead.org,  linux-wireless@vger.kernel.org,
  netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,  Dean Luick
 <dean.luick@cornelisnetworks.com>,  Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>,  stable@vger.kernel.org
Subject: Re: [PATCH v2 7/9] wifi: ath11k: Use RMW accessors for changing LNKCTL
References: <20230517105235.29176-1-ilpo.jarvinen@linux.intel.com>
	<20230517105235.29176-8-ilpo.jarvinen@linux.intel.com>
Date: Wed, 17 May 2023 14:04:57 +0300
In-Reply-To: <20230517105235.29176-8-ilpo.jarvinen@linux.intel.com> ("Ilpo
	\=\?utf-8\?Q\?J\=C3\=A4rvinen\=22's\?\= message of "Wed, 17 May 2023 13:52:33
 +0300")
Message-ID: <87wn17kyli.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com> writes:

> Don't assume that only the driver would be accessing LNKCTL. ASPM
> policy changes can trigger write to LNKCTL outside of driver's control.
>
> Use RMW capability accessors which do proper locking to avoid losing
> concurrent updates to the register value. On restore, clear the ASPMC
> field properly.
>
> Fixes: e9603f4bdcc0 ("ath11k: pci: disable ASPM L0sLs before downloading =
firmware")
> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> Cc: stable@vger.kernel.org

Acked-by: Kalle Valo <kvalo@kernel.org>

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

