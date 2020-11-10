Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19B2ADDEE
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgKJSOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:14:38 -0500
Received: from z5.mailgun.us ([104.130.96.5]:26628 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJSOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 13:14:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605032077; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ommY8NbC/6/vCsffz4CKNBy1MT65alpBUD3ahMItC0I=;
 b=fRewQd0cg4ZMvCug61bJw/0H1EPru89y6uc108/8vTkmV/XM1whpdjySPA28abaHUGTICLPr
 cGDqiebRhrNWp+fnXbjQLtQeriTpFLXGusLkByJ1dgJ+eC0zmKTczf4EoEwqFHdVnNeve56Z
 xLpEnCD9Smj+9/wvJdOOYoW4hhw=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5faad867e9dd187f53286145 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 18:13:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 143D8C43382; Tue, 10 Nov 2020 18:13:59 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66C6DC433C6;
        Tue, 10 Nov 2020 18:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66C6DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 08/11] ath9k: work around false-positive gcc
 warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201026213040.3889546-8-arnd@kernel.org>
References: <20201026213040.3889546-8-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201110181359.143D8C43382@smtp.codeaurora.org>
Date:   Tue, 10 Nov 2020 18:13:59 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> gcc-10 shows a false-positive warning with CONFIG_KASAN:
> 
> drivers/net/wireless/ath/ath9k/dynack.c: In function 'ath_dynack_sample_tx_ts':
> include/linux/etherdevice.h:290:14: warning: writing 4 bytes into a region of size 0 [-Wstringop-overflow=]
>   290 |  *(u32 *)dst = *(const u32 *)src;
>       |  ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
> 
> Until gcc is fixed, work around this by using memcpy() in place
> of ether_addr_copy(). Hopefully gcc-11 will not have this problem.
> 
> Link: https://godbolt.org/z/sab1MK
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> [kvalo@codeaurora.org: remove ifdef and add a comment]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

b96fab4e3602 ath9k: work around false-positive gcc warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201026213040.3889546-8-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

