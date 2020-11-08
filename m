Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E147F2AAAB3
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 12:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgKHLcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 06:32:05 -0500
Received: from z5.mailgun.us ([104.130.96.5]:24092 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKHLcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 06:32:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604835124; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Hh80t6DBe3X7mbuwvXT2qT4O+qR89/NR5LLrWLjb7W8=; b=f9oMDpZ/aY8vpDlfCTcTv40B5aToSuONm29uL5OQ0S7ndvmuz2LCcEM4XqsSDHtsCFfz9MyP
 xdx2p3s7n095+BOFeZ4Mp9VdfJnDagFTrhnFJwUvBKkUPwoSwZGcxL9UsbC6R+fmYcKvGGVl
 aKwAt38hgIZbt65NmRQnl/bCOzM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fa7d73160d947565276bf76 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 08 Nov 2020 11:32:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 96F5AC433F0; Sun,  8 Nov 2020 11:32:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A982C433C6;
        Sun,  8 Nov 2020 11:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2A982C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Subject: Re: [PATCH 1/2] mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
References: <20201028142110.18144-1-kitakar@gmail.com>
        <20201028142110.18144-2-kitakar@gmail.com>
Date:   Sun, 08 Nov 2020 13:31:55 +0200
In-Reply-To: <20201028142110.18144-2-kitakar@gmail.com> (Tsuchiya Yuto's
        message of "Wed, 28 Oct 2020 23:21:09 +0900")
Message-ID: <87pn4o5bkk.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tsuchiya Yuto <kitakar@gmail.com> writes:

> When FLR is performed but without fw reset for some reasons (e.g. on
> Surface devices, fw reset requires another quirk), it fails to reset
> properly. You can trigger the issue on such devices via debugfs entry
> for reset:
>
>     $ echo 1 | sudo tee /sys/kernel/debug/mwifiex/mlan0/reset
>
> and the resulting dmesg log:
>
>     [   45.740508] mwifiex_pcie 0000:03:00.0: Resetting per request
>     [   45.742937] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 3
>     [   45.744666] mwifiex_pcie 0000:03:00.0: info: shutdown mwifiex...
>     [   45.751530] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.751539] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.771691] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.771695] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [   45.771697] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.771698] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [   45.771699] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.771701] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [   45.771702] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.771703] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [   45.771704] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.771705] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [   45.771707] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
>     [   45.771708] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [   53.099343] mwifiex_pcie 0000:03:00.0: info: trying to associate to '[SSID]' bssid [BSSID]
>     [   53.241870] mwifiex_pcie 0000:03:00.0: info: associated to bssid [BSSID] successfully
>     [   75.377942] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
>     [   85.385491] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 15
>     [   87.539408] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
>     [   87.539412] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [   99.699917] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
>     [   99.699925] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [  111.859802] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
>     [  111.859808] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
>     [...]
>
> When comparing mwifiex_shutdown_sw() with mwifiex_pcie_remove(), it
> lacks mwifiex_init_shutdown_fw().
>
> This commit fixes mwifiex_shutdown_sw() by adding the missing
> mwifiex_init_shutdown_fw().
>
> Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>

Otherwise looks good to me, but what is FLR? I can add the description
to the commit log if you tell me what it is.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
