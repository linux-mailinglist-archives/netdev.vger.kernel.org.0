Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1292A32A0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgKBSNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:13:20 -0500
Received: from z5.mailgun.us ([104.130.96.5]:10510 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgKBSNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:13:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604340799; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6Kok7NnywWHLw5utXL9oDnF/16NNLDN2ZxzIH6GNbx0=;
 b=H8X0c/bgWmqGyZjCS77DAs+b4ykdAI0qAE6hK4knlRlMmgonFuEd8SB3U3+0r64QJ0TJIPuX
 Jqy7iHtbzg5h0xuWXAiM1fsovrt3Z/t4ExnOtjqDnxVfGUM2Q6MDh5d2S+Sb5rGk2BWdYKUA
 p+Kal4w29QNpBtLCDPZcnxax4lA=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fa04c308646b0f268a8f5d8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Nov 2020 18:13:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 259A9C43391; Mon,  2 Nov 2020 18:13:03 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22BD1C433C6;
        Mon,  2 Nov 2020 18:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 22BD1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH\ net] rtw88: fix fw dump support detection
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201026212323.3888550-1-arnd@kernel.org>
References: <20201026212323.3888550-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Chin-Yen Lee <timlee@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201102181303.259A9C43391@smtp.codeaurora.org>
Date:   Mon,  2 Nov 2020 18:13:03 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang points out a useless check that was recently added:
> 
> drivers/net/wireless/realtek/rtw88/fw.c:1485:21: warning: address of array 'rtwdev->chip->fw_fifo_addr' will always evaluate to 'true' [-Wpointer-bool-conversion]
>         if (!rtwdev->chip->fw_fifo_addr) {
>             ~~~~~~~~~~~~~~~^~~~~~~~~~~~
> 
> Apparently this was meant to check the contents of the array
> rather than the address, so check it accordingly.
> 
> Fixes: 0fbc2f0f34cc ("rtw88: add dump firmware fifo support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

I'll take Tom's patch as it was first.

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201026212323.3888550-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

