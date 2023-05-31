Return-Path: <netdev+bounces-6931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B902718D77
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B953D1C20F81
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718773D3B8;
	Wed, 31 May 2023 21:48:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BB619E7C;
	Wed, 31 May 2023 21:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88739C433EF;
	Wed, 31 May 2023 21:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685569715;
	bh=md3hNAYKn0lyhGYaSSrqLUBDR6InA+O5aSwui2MwuTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rd9/VP+eQSrjMxHJv2xZCbdoPVfg16o9s/rZ2O61kNKk5ZmwG6wFz8iQnzzvuaFp4
	 khRX2CptZYGEP0h9iHDXL8fqBuuZXreq+paJgoPx8mXokqpHcb9peQTnhIa2qCsSAY
	 n/iQRwC22qUUlRW+8wfyZA+AwhMGznv1ij4Uuns7NxYoZ7mI8S4Dr7c17No6fVcno1
	 TSFfA7STC8aYcyxsMVHsiwGiQRmhBzMmchf/4utX8m2APkxtO7gxV9+9msKIiWom1N
	 F1d3e/1B3DlPdDCq8PKw5O56yg2IiLCp8t61Fl31tuQDmmj4nVwFBywkrQ5vaGUf86
	 AJm86XZxCxHOQ==
Date: Wed, 31 May 2023 14:48:34 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>, Shay Drory <shayd@nvidia.com>,
	chuck.lever@oracle.com, Saeed Mahameed <saeedm@nvidia.com>,
	Eli Cohen <elic@nvidia.com>, netdev@vger.kernel.org
Subject: Re: mlx5 driver is broken when pci_msix_can_alloc_dyn() is false
 with v6.4-rc4
Message-ID: <ZHfAsm2Ogic+vM0d@x130>
References: <d6ada86741a440f99b5d6fedff532c8dbe86254f.camel@linux.ibm.com>
 <cb093081-ef71-c556-fe2f-9ec30bbcfe80@leemhuis.info>
 <c2702c969f01f9dcf2d6b3d3326e804c3fee86c0.camel@linux.ibm.com>
 <ab31715a-0fe7-f881-be1a-2b69fde82f23@leemhuis.info>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ab31715a-0fe7-f881-be1a-2b69fde82f23@leemhuis.info>

On 31 May 15:57, Linux regression tracking (Thorsten Leemhuis) wrote:
>
>
>On 31.05.23 15:43, Niklas Schnelle wrote:
>> On Wed, 2023-05-31 at 15:33 +0200, Linux regression tracking #adding
>> (Thorsten Leemhuis) wrote:
>>> [CCing the regression list, as it should be in the loop for regressions:
>>> https://docs.kernel.org/admin-guide/reporting-regressions.html]
>>>
>>> [TLDR: I'm adding this report to the list of tracked Linux kernel
>>> regressions; the text you find below is based on a few templates
>>> paragraphs you might have encountered already in similar form.
>>> See link in footer if these mails annoy you.]
>>>
>>> On 30.05.23 15:04, Niklas Schnelle wrote:
>>>>
>>>> With v6.4-rc4 I'm getting a stream of RX and TX timeouts when trying to
>>>> use ConnectX-4 and ConnectX-6 VFs on s390. I've bisected this and found
>>>> the following commit to be broken:
>>>>
>>>> commit 1da438c0ae02396dc5018b63237492cb5908608d
>>>> Author: Shay Drory <shayd@nvidia.com>
>>>> Date:   Mon Apr 17 10:57:50 2023 +0300
>>>> [...]
>>>
>>> Thanks for the report. To be sure the issue doesn't fall through the
>>> cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
>>> tracking bot:
>>>
>>> #regzbot ^introduced 1da438c0ae02396dc5018b63237492cb5908608d
>>> #regzbot title net/mlx5: RX and TX timeouts with ConnectX-4 and
>>> ConnectX-6 VFs on s390
>>> #regzbot ignore-activity
>>>
>>> This isn't a regression? This issue or a fix for it are already
>>> discussed somewhere else? It was fixed already? You want to clarify when
>>> the regression started to happen? Or point out I got the title or
>>> something else totally wrong? Then just reply and tell me -- ideally
>>> while also telling regzbot about it, as explained by the page listed in
>>> the footer of this mail.
>>>
>>> Developers: When fixing the issue, remember to add 'Link:' tags pointing
>>> to the report (the parent of this mail). See page linked in footer for
>>> details.
>>>
>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>>> --
>>> Everything you wanna know about Linux kernel regression tracking:
>>> https://linux-regtracking.leemhuis.info/about/#tldr
>>> That page also explains what to do if mails like this annoy you.
>>
>> Hi Thorsten,
>>
>> Thanks for tracking. I actually already sent a fix patch (and v2) for
>> this. Sadly I forgot to link to this mail. Let's see if I can get the
>> regzbot command right to update it. As for the humans the latest fix
>> patch is here:
>>
>> https://lore.kernel.org/netdev/20230531084856.2091666-1-schnelle@linux.ibm.com/
>>

I picked up this patch to net-mlx5 tree, will post to net shortly.

Thanks,
Saeed.

>> Thanks,
>> Niklas
>>
>> #regzbot fix: net/mlx5: Fix setting of irq->map.index for static IRQ case
>
>Looks right, many thx. Sorry, should have looked for that myself. Sadly
>regzbot doesn't yet search for existing post on lore with a matching
>subject, so for completeness let me point manually to it while at it:
>
>#regzbot monitor:
>https://lore.kernel.org/netdev/20230531084856.2091666-1-schnelle@linux.ibm.com/
>
>Ciao, Thorsten
>

