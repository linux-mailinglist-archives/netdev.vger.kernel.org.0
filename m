Return-Path: <netdev+bounces-4886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CC770EFD2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 606821C20B68
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22A2BE78;
	Wed, 24 May 2023 07:47:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885CABE73
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2144C433EF;
	Wed, 24 May 2023 07:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684914446;
	bh=KhQ0blVR5cXlzUR6vdxYF+zuuLth0MWzdADoCBQqa44=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=pLpUbESyZfGpmf0GKjmrfiv0HHs77Na8zqN6Wm0A4OWoRIqWT/PyZufb9YZz4NZWC
	 Ak2xLnl8NWJfwuYnjB8LEZBwoCQw16eHDK1JYar9J+uOnj3AoTwLrZalzcX7Vfj/Sp
	 8aRkeCka6sTbv9VltyPUCMqe6jrev4TDqj1FLNzLThHZZyawLZJbU4rVjakc3TR5Bo
	 6S4U+EXpcQbuvBM8Xehrfa8zzvdAQhrGijsGP2zEYHbTcOsWUt/0BOK6Foz9RkShS6
	 WmcvuYcrck/2xnpHctbegwgKwNi+n0peoHIi/UNq+8g6zb3udU5seVDMXa9wW3UtMh
	 qOR899x8zbmzg==
From: Kalle Valo <kvalo@kernel.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Jakub Kicinski <kuba@kernel.org>,  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Matthias Brugger <matthias.bgg@gmail.com>,  AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,  linux-wireless@vger.kernel.org,  netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,  linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt7601u: update firmware path
References: <fefcbf36f13873ae0d97438a0156b87e7e1ae64e.1684191377.git.daniel@makrotopia.org>
	<87o7mkn91f.fsf@kernel.org>
Date: Wed, 24 May 2023 10:47:21 +0300
In-Reply-To: <87o7mkn91f.fsf@kernel.org> (Kalle Valo's message of "Tue, 16 May
	2023 08:24:12 +0300")
Message-ID: <87ttw2kw6u.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Kalle Valo <kvalo@kernel.org> writes:

> Daniel Golle <daniel@makrotopia.org> writes:
>
>> mt7601u.bin was moved to mediatek/ folder in linux-wireless via commit
>> 8451c2b1 ("mt76xx: Move the old Mediatek WiFi firmware to mediatek")
>> and linux-firmware release 20230515.
>
> Why was it moved?

Here's the link to the commit in linux-firmware:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=8451c2b1d529dc1a49328ac9235d3cf5bb8a8fcb

It would be good to include that in the commit log. Unfortunately the
linux-firmware commit doesn't explain why the change is made, oh well.

>> --- a/drivers/net/wireless/mediatek/mt7601u/usb.h
>> +++ b/drivers/net/wireless/mediatek/mt7601u/usb.h
>> @@ -8,7 +8,7 @@
>>  
>>  #include "mt7601u.h"
>>  
>> -#define MT7601U_FIRMWARE	"mt7601u.bin"
>> +#define MT7601U_FIRMWARE	"mediatek/mt7601u.bin"
>
> How do we handle backwards compatibility? We have a rule that old
> userspace needs to work with new kernel and this change breaks that.

Luckily the linux-firmware commit added symlinks so that won't break the
backward compatibility. But I think in the driver we still need to
support both the old and new location for several years. So the driver
should first try the new location, next the old location and only after
that fail.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

