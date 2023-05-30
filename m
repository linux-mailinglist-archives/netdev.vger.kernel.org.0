Return-Path: <netdev+bounces-6326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9CD715BD5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87F4128114B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF0A8F7B;
	Tue, 30 May 2023 10:32:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BB117AB6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EC6C433EF;
	Tue, 30 May 2023 10:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685442745;
	bh=h09OcZUBrFkTTAIDNH4KTQ50DointxObx3nECSUuE+I=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=TluZmhoL4RoPx/5DijUj5SB6Sf7L3+446+i++wm3IuCcMumtoA50KrphbYZghj9Id
	 ITAjdHdZwln4hvLW+DXfXEzChDBN0osamk89FOLAEpHB5z1CWBCpFslVSWY1hVgJN/
	 3UdWkyHYqTKbYytSAzk2VSpCwl40Bu8s2FQYVpuqxojVMz3IWEVhXcpHy2liyVdMU+
	 oILOjvfDO7XTxXlhf8paiR3tdREzldt0n2HJV5s2/G6iKETf9pzyzIVnP30jOsXJRx
	 0LwohtBQ1RK7AW9OEZRwnNqSyz5Q3llVpPWR3P52bBDXdyZ4Zo6bDv4EcJTwoz3Kiz
	 /CFRQYbmiyGNA==
From: Kalle Valo <kvalo@kernel.org>
To: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Johannes Berg <johannes@sipsolutions.net>,  linux-wireless@vger.kernel.org,  netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v5 1/1] wifi: mac80211: fortify the spinlock against deadlock by interrupt
References: <20230517213101.25617-1-mirsad.todorovac@alu.unizg.hr>
	<056e71bd6a06779bfcb1ef4518a2f67f67730fe7.camel@sipsolutions.net>
	<d574c978-c2b8-f2e0-abc5-19899b4fefe6@alu.unizg.hr>
Date: Tue, 30 May 2023 13:32:21 +0300
In-Reply-To: <d574c978-c2b8-f2e0-abc5-19899b4fefe6@alu.unizg.hr> (Mirsad Goran
	Todorovac's message of "Thu, 18 May 2023 20:50:16 +0200")
Message-ID: <87r0qyjeiy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr> writes:

> On 5/17/23 23:34, Johannes Berg wrote:
>>>
>>> Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
>>> Link: https://lore.kernel.org/all/1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr/
>>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>> Link: https://lore.kernel.org/all/cdc80531-f25f-6f9d-b15f-25e16130b53a@alu.unizg.hr/
>>> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
>>> ---
>>>
>>
>> You really should say what you changed, but anyway, it's too late - I
>> applied a previous version yesterday.
>
> Yes. Sorry, I was following Andy's advice to resend, at the wrong
> assumption that the system ate the patch after three weeks of
> inactivity. :-/

Yeah, unfortunately we maintainers are busy so sometimes it takes before
we can process patches. But you can check the patch status from
patchwork, link below. Also the wiki has more information how we use it.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

