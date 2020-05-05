Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1D21C5C26
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgEEPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:44:57 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:32510 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730625AbgEEPoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:44:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588693495; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=S242E4d9Q+x3WazT0LfEblmsx0Y/I8PQEL3G5k/rxP8=; b=pfqVJ8t3lfHAkmOH7wW4CLsXZ5BdZXHhD933hK0eF10f/MZyA+j6cy0AGjw6fe3Gye4sXUjf
 PT7lqLh+VoltzFTZvcOeMPQi5WOuAYF+hAZv+pcjZWFii3z0bFFmUTDLGX3WeyMUraXpteki
 ad1KorNDuIdcbTDQbWkESwY8sHk=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb189e5.7fcd01fa8c38-smtp-out-n03;
 Tue, 05 May 2020 15:44:37 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03FD1C44788; Tue,  5 May 2020 15:44:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6992FC433F2;
        Tue,  5 May 2020 15:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6992FC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dedy Lansky <dlansky@codeaurora.org>,
        Ahmad Masri <amasri@codeaurora.org>,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Tzahi Sabo <stzahi@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Lior David <liord@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wil6210: avoid gcc-10 zero-length-bounds warning
References: <20200505143332.1398524-1-arnd@arndb.de>
Date:   Tue, 05 May 2020 18:44:31 +0300
In-Reply-To: <20200505143332.1398524-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 5 May 2020 16:33:24 +0200")
Message-ID: <877dxqcrog.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> gcc-10 warns about accesses inside of a zero-length array:
>
> drivers/net/wireless/ath/wil6210/cfg80211.c: In function 'wil_cfg80211_scan':
> drivers/net/wireless/ath/wil6210/cfg80211.c:970:23: error: array
> subscript 255 is outside the bounds of an interior zero-length array
> 'struct <anonymous>[0]' [-Werror=zero-length-bounds]
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
> ---
> Gustavo has a patch to do it for all arrays in this file, and that
> should get merged as well, but this simpler patch is sufficient
> to shut up the warning.

I don't see Gustavo's patch yet so I'll take this one first.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
