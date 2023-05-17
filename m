Return-Path: <netdev+bounces-3213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FA6705FE5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 922A9280C69
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7102A5688;
	Wed, 17 May 2023 06:24:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB3E2CA9;
	Wed, 17 May 2023 06:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F3AC433D2;
	Wed, 17 May 2023 06:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684304661;
	bh=gMk6/EoGfuHArSq0Q8XKhHxU1olH0Y7/8YUqrbeK/Yc=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=FL8IyGRp6X7P8iL2t+MVz0jzW1UWUAYcxDsC/CE6eib1w50IkJqa54LgNvsl0kyWO
	 rzmbyK7nlkeaGwFZFHjEpaahPC5gwXeKJ00OwfL+dLuqxVuh03V2CUzJs1esJnDR6f
	 5HdNbKKPT8KUYlL3W7RoBuxNjQJY9bDLiO4/oJMmrwmWVvJDpWgyL6xiwcznhhvhvU
	 /1seolds4UBEwVzHC6MJnmJ3LQiD6aKW1K43ccdSZJLQ/Irqhb8f2CoRRZnGx6KPSa
	 FTw2fL9au1RYB/4VJsfNbSGJ6ABjpVqgeMTsPQJYaNBTPUxHZ3hg/uEcBpuNe5/9KT
	 n5L+7U11iM4kA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] wifi: b43: fix incorrect __packed annotation
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230516183442.536589-1-arnd@kernel.org>
References: <20230516183442.536589-1-arnd@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, =?utf-8?q?Michael_B=C3=BCsch?= <m@bues.ch>,
 kernel test robot <lkp@intel.com>, Simon Horman <simon.horman@corigine.com>,
 Larry Finger <Larry.Finger@lwfinger.net>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168430465407.24096.14761627656437604341.kvalo@kernel.org>
Date: Wed, 17 May 2023 06:24:17 +0000 (UTC)

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang warns about an unpacked structure inside of a packed one:
> 
> drivers/net/wireless/broadcom/b43/b43.h:654:4: error: field data within 'struct b43_iv' is less aligned than 'union (unnamed union at /home/arnd/arm-soc/drivers/net/wireless/broadcom/b43/b43.h:651:2)' and is usually due to 'struct b43_iv' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
> 
> The problem here is that the anonymous union has the default alignment
> from its members, apparently because the original author mixed up the
> placement of the __packed attribute by placing it next to the struct
> member rather than the union definition. As the struct itself is
> also marked as __packed, there is no need to mark its members, so just
> move the annotation to the inner type instead.
> 
> As Michael noted, the same problem is present in b43legacy, so
> change both at the same time.
> 
> Acked-by: Michael Büsch <m@bues.ch>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Link: https://lore.kernel.org/oe-kbuild-all/202305160749.ay1HAoyP-lkp@intel.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless.git, thanks.

212457ccbd60 wifi: b43: fix incorrect __packed annotation

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230516183442.536589-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


