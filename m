Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B343E161E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhHENyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:54:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:63406 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241372AbhHENyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 09:54:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628171671; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=bcr6vJTCmnIH6dipHg22HDP4Lj3skF7+z+y098CkOwU=; b=hKwk7PM47X2GGtnm8h483tPzPOemFsGOc0RWYCpo+gTgdYJtzQ44mHpLr1p8ELuxJixBgRUT
 pjQubhuPzO1DYlC7F6r8phZd7Q7p0iBjKoQJO9yjRysZoYGwpZGVGFNXUWbthbxR3FHltGFU
 CCaxBP5Xmt3jjWUWIVkkdWb2jE4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 610bed7db4dfc4b0ef3c8f9f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 05 Aug 2021 13:54:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4FF41C43147; Thu,  5 Aug 2021 13:54:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E3DC7C433F1;
        Thu,  5 Aug 2021 13:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E3DC7C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Colin King <colin.king@canonical.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] brcmfmac: firmware: Fix uninitialized variable ret
References: <20210803150904.80119-1-colin.king@canonical.com>
        <CACRpkdZ5u-C8uH2pCr1689v_ndyzqevDDksXvtPYv=FfD=x_xg@mail.gmail.com>
Date:   Thu, 05 Aug 2021 16:53:54 +0300
In-Reply-To: <CACRpkdZ5u-C8uH2pCr1689v_ndyzqevDDksXvtPYv=FfD=x_xg@mail.gmail.com>
        (Linus Walleij's message of "Tue, 3 Aug 2021 21:14:07 +0200")
Message-ID: <875ywkc80d.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> On Tue, Aug 3, 2021 at 5:09 PM Colin King <colin.king@canonical.com> wrote:
>
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the variable ret is uninitialized and is only set if
>> the pointer alt_path is non-null. Fix this by ininitializing ret
>> to zero.
>>
>> Addresses-Coverity: ("Uninitialized scalar variable")
>> Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>
> Nice catch!
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I assume this will be fixed by Linus' patch "brcmfmac: firmware: Fix
firmware loading" and I should drop Colin's patch, correct?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
