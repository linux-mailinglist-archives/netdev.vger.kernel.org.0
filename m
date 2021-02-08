Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4A3130CE
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhBHL1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:27:20 -0500
Received: from so15.mailgun.net ([198.61.254.15]:12094 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233037AbhBHLYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 06:24:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612783447; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=94O3q+hrlwecJKOh0uEeXAGFAVqfWgT1LWYjYLGX8bE=;
 b=WAqGyLG9Tw2UUhKacmmIXUq3edwfBdFSvb73N2aMsNKdtLogjzY92FnCQX1QV17wGgwhNOg2
 Ws89QlT1e/GbwavPTp0nt855vBZ7LuMTMatoG5gHamIMhZnLHggIG0hNeUgU6tiHXjoFcAQ6
 B/KEhi1gbqPyLflTNtMxyavBxcg=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60211f323919dfb4559bf54d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 11:23:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4B57BC43464; Mon,  8 Feb 2021 11:23:29 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02154C433ED;
        Mon,  8 Feb 2021 11:23:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 02154C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: mwl8k: fix alignment constraints
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210204162813.3159319-1-arnd@kernel.org>
References: <20210204162813.3159319-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Romain Perier <romain.perier@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Allen Pais <allen.lkml@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208112329.4B57BC43464@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 11:23:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> sturct mwl8k_dma_data contains a ieee80211_hdr structure, which is required to
> have at least two byte alignment, and this conflicts with the __packed
> attribute:
> 
> vers/net/wireless/marvell/mwl8k.c:811:1: warning: alignment 1 of 'struct mwl8k_dma_data' is less than 2 [-Wpacked-not-aligned]
> 
> Mark mwl8k_dma_data itself as having two-byte alignment to ensure the
> inner structure is properly aligned.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

bfdc4d7cbe57 mwl8k: fix alignment constraints

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210204162813.3159319-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

