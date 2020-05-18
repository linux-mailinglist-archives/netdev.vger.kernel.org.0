Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38391D7858
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgERMTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 08:19:22 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:41135 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726797AbgERMTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 08:19:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589804361; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=G7xMZKgmgJMfC5vY0lakFamZJIzamt/We/SweKruljk=;
 b=V0sPF9Tfj79/3w6zxxOWVBiAMFMakTZhT/6FbhGfnzRq9xg24e9a8p8rpFqMhUFGv/3x8HYt
 52eP8k6lEM+7ZRosmNdunAHQNHqWB8ejbyxb4QHQX3yMcTs9ohwmdH1ZF/5ynXTQ3Y05npRD
 dJbOdPejVXemWUMx7zNlbFm1joo=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec27d3c.7fa95bd7e570-smtp-out-n05;
 Mon, 18 May 2020 12:19:08 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E660AC433D2; Mon, 18 May 2020 12:19:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4693C433F2;
        Mon, 18 May 2020 12:19:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E4693C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwifiex: Fix memory corruption in dump_station
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200515075924.13841-1-pali@kernel.org>
References: <20200515075924.13841-1-pali@kernel.org>
To:     =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cathy Luo <cluo@marvell.com>,
        Avinash Patil <patila@marvell.com>,
        =?utf-8?q?Marek_Beh=C3=BAn?= <marek.behun@nic.cz>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200518121907.E660AC433D2@smtp.codeaurora.org>
Date:   Mon, 18 May 2020 12:19:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pali Rohár <pali@kernel.org> wrote:

> The mwifiex_cfg80211_dump_station() uses static variable for iterating
> over a linked list of all associated stations (when the driver is in UAP
> role). This has a race condition if .dump_station is called in parallel
> for multiple interfaces. This corruption can be triggered by registering
> multiple SSIDs and calling, in parallel for multiple interfaces
>     iw dev <iface> station dump
> 
> [16750.719775] Unable to handle kernel paging request at virtual address dead000000000110
> ...
> [16750.899173] Call trace:
> [16750.901696]  mwifiex_cfg80211_dump_station+0x94/0x100 [mwifiex]
> [16750.907824]  nl80211_dump_station+0xbc/0x278 [cfg80211]
> [16750.913160]  netlink_dump+0xe8/0x320
> [16750.916827]  netlink_recvmsg+0x1b4/0x338
> [16750.920861]  ____sys_recvmsg+0x7c/0x2b0
> [16750.924801]  ___sys_recvmsg+0x70/0x98
> [16750.928564]  __sys_recvmsg+0x58/0xa0
> [16750.932238]  __arm64_sys_recvmsg+0x28/0x30
> [16750.936453]  el0_svc_common.constprop.3+0x90/0x158
> [16750.941378]  do_el0_svc+0x74/0x90
> [16750.944784]  el0_sync_handler+0x12c/0x1a8
> [16750.948903]  el0_sync+0x114/0x140
> [16750.952312] Code: f9400003 f907f423 eb02007f 54fffd60 (b9401060)
> [16750.958583] ---[ end trace c8ad181c2f4b8576 ]---
> 
> This patch drops the use of the static iterator, and instead every time
> the function is called iterates to the idx-th position of the
> linked-list.
> 
> It would be better to convert the code not to use linked list for
> associated stations storage (since the chip has a limited number of
> associated stations anyway - it could just be an array). Such a change
> may be proposed in the future. In the meantime this patch can backported
> into stable kernels in this simple form.
> 
> Fixes: 8baca1a34d4c ("mwifiex: dump station support in uap mode")
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>

Patch applied to wireless-drivers-next.git, thanks.

3aa42bae9c4d mwifiex: Fix memory corruption in dump_station

-- 
https://patchwork.kernel.org/patch/11550701/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
