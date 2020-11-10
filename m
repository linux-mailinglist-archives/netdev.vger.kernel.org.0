Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3058C2ADEBB
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgKJSug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:50:36 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:50528 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgKJSue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 13:50:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605034233; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=TLsCNsopTYgMfYxQI+Rv7Ueci5CyMDHLKfaVFZJXCjQ=;
 b=XScreMz+A4XRPcVz7eSmOW7JPAuzIkNoMedezBZErBhsXBj7X0ypG2QHfjD35YewEBCfse5d
 N4AxeqpFedpf/z2nKKHpICK0eGl4aB5vrSaZxugKzvhHynBDCOKlzwNctZ761ZKbx98Bm8pJ
 U5XssYm3NFuJav4IMMtIBqhnl8I=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5faae0e60d87d63775d684a1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 18:50:14
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 36A35C433FE; Tue, 10 Nov 2020 18:50:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 71609C433C8;
        Tue, 10 Nov 2020 18:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 71609C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [1/2] mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201028142110.18144-2-kitakar@gmail.com>
References: <20201028142110.18144-2-kitakar@gmail.com>
To:     Tsuchiya Yuto <kitakar@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201110185013.36A35C433FE@smtp.codeaurora.org>
Date:   Tue, 10 Nov 2020 18:50:13 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tsuchiya Yuto <kitakar@gmail.com> wrote:

> When a PCIe function level reset (FLR) is performed but without fw reset for
> some reasons (e.g., on Microsoft Surface devices, fw reset requires other
> quirks), it fails to reset wifi properly. You can trigger the issue on such
> devices via debugfs entry for reset:
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

2 patches applied to wireless-drivers-next.git, thanks.

fa74cb1dc0f4 mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
566b4cb9587e mwifiex: update comment for shutdown_sw()/reinit_sw() to reflect current state

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201028142110.18144-2-kitakar@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

