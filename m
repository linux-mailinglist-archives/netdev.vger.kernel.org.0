Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1E325FFE
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhBZJ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:26:13 -0500
Received: from z11.mailgun.us ([104.130.96.11]:45761 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhBZJYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 04:24:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614331442; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mp7yRwPgCTm+lkMg8IO3FOrSKleFckToDfTuDIRWlJU=;
 b=kiqaIFoIjraNsTFb95oqSPCbt8OIl7oMk9H3eTvzmfYhdXHB4yvToOnw6FwIIL9UcmiUnHKP
 +LhoylZE7asu8RSOlreu4FzciRVlv0X8RzximE9lvYfZKcc3Lb9tAumGjyHePm/74zHsQhuN
 BTGWJK8LHLZoRhO5ef+ZDMRkggI=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6038be039a7cefa92af9a507 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 26 Feb 2021 09:23:15
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 14FC6C43461; Fri, 26 Feb 2021 09:23:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7D371C433CA;
        Fri, 26 Feb 2021 09:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7D371C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] mt76: mt7915: fix unused 'mode' variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210225145953.404859-1-arnd@kernel.org>
References: <20210225145953.404859-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210226092315.14FC6C43461@smtp.codeaurora.org>
Date:   Fri, 26 Feb 2021 09:23:15 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang points out a possible corner case in the mt7915_tm_set_tx_cont()
> function if called with invalid arguments:
> 
> drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:593:2: warning: variable 'mode' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:597:13: note: uninitialized use occurs here
>         rateval =  mode << 6 | rate_idx;
>                    ^~~~
> drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:506:37: note: initialize the variable 'mode' to silence this warning
>         u8 rate_idx = td->tx_rate_idx, mode;
>                                            ^
> 
> Change it to return an error instead of continuing with invalid data
> here.
> 
> Fixes: 3f0caa3cbf94 ("mt76: mt7915: add support for continuous tx in testmode")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Please remove the break and send v2.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210225145953.404859-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

