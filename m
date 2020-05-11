Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A4E1CD9FB
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbgEKMeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:34:15 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:20975 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbgEKMeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:34:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589200448; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=K/ZVBtan0dAMs+9OwwNDoOBPaVIbhgR20VKrES40O3Q=;
 b=ih0/+C7DaFCWD15cF6qJF4WerlDxKq0oEYFBiIsEi9aUxVDjRft8uw5mi09QhJFOxNrN7fzK
 2eroEs+/a+Db2j7pmt5f9o0qB/HaEhbCWPTkCEidCw97MKTzrhNs90y62yAPCB8EnoMtKLlZ
 2bEoXP6LrHW0Bnt0dswBubJmCbg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb94630.7f93acdfeab0-smtp-out-n04;
 Mon, 11 May 2020 12:33:52 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D753CC43637; Mon, 11 May 2020 12:33:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 75375C432C2;
        Mon, 11 May 2020 12:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 75375C432C2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: avoid gcc-10 zero-length-bounds warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200505143332.1398524-1-arnd@arndb.de>
References: <20200505143332.1398524-1-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Dedy Lansky <dlansky@codeaurora.org>,
        Ahmad Masri <amasri@codeaurora.org>,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Tzahi Sabo <stzahi@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Lior David <liord@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200511123352.D753CC43637@smtp.codeaurora.org>
Date:   Mon, 11 May 2020 12:33:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> gcc-10 warns about accesses inside of a zero-length array:
> 
> drivers/net/wireless/ath/wil6210/cfg80211.c: In function 'wil_cfg80211_scan':
> drivers/net/wireless/ath/wil6210/cfg80211.c:970:23: error: array subscript 255 is outside the bounds of an interior zero-length array 'struct <anonymous>[0]' [-Werror=zero-length-bounds]
>   970 |   cmd.cmd.channel_list[cmd.cmd.num_channels++].channel = ch - 1;
>       |   ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/net/wireless/ath/wil6210/wil6210.h:17,
>                  from drivers/net/wireless/ath/wil6210/cfg80211.c:11:
> drivers/net/wireless/ath/wil6210/wmi.h:477:4: note: while referencing 'channel_list'
>   477 |  } channel_list[0];
>       |    ^~~~~~~~~~~~
> 
> Turn this into a flexible array to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

04a4d3416372 wil6210: avoid gcc-10 zero-length-bounds warning

-- 
https://patchwork.kernel.org/patch/11529309/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
