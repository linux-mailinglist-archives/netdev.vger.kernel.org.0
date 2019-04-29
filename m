Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4FCE577
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbfD2OxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:53:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbfD2OxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:53:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9ADFB608BA; Mon, 29 Apr 2019 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549602;
        bh=irxS69ui9uFMypPtZqVaCG/Lyxyxkh55XfmeD07SihU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Cs8My31ZU3N55iB9OsJd1qkpQ/pS1e7Tz1rvpTO77bQ9TZqXUMd5UYure5BBxXpV+
         yGf1XtsIWDvyN00FDOONjsJYznq2JGBi32jlw4j7LVoPCYLNYsV2s6FDM1/zQ7Agkg
         EZ1w52b46Dmqfllhif2/DeMjanM9oufKJgrDRkoQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 753E9605A2;
        Mon, 29 Apr 2019 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549602;
        bh=irxS69ui9uFMypPtZqVaCG/Lyxyxkh55XfmeD07SihU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kUMv2g9YWlEUImByOoq+dRrRUTRLUDM33tu/YtvF+krEF2knqyxMCmyozogHXt0UM
         PC6GfOGZ7zBR7Ii8z3Bh1a5oTNqSODuP1baG0ORe+xWVDvbkzeOJHn1Bm9EC+IgouK
         EHlzcohEw+tsV1VhbLLqM659jcWzpHmCNBdGMO3A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 753E9605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Check for errors when reading SREV register
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190318190557.21599-1-timschumi@gmx.de>
References: <20190318190557.21599-1-timschumi@gmx.de>
To:     Tim Schumacher <timschumi@gmx.de>
Cc:     unlisted-recipients:; (no To-header on input) timschumi@gmx.de,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)timschumi@gmx.de
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190429145322.9ADFB608BA@smtp.codeaurora.org>
Date:   Mon, 29 Apr 2019 14:53:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tim Schumacher <timschumi@gmx.de> wrote:

> Right now, if an error is encountered during the SREV register
> read (i.e. an EIO in ath9k_regread()), that error code gets
> passed all the way to __ath9k_hw_init(), where it is visible
> during the "Chip rev not supported" message.
> 
>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>     ath: phy2: Mac Chip Rev 0x0f.3 is not supported by this driver
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath9k_htc: Failed to initialize the device
> 
> Check for -EIO explicitly in ath9k_hw_read_revisions() and return
> a boolean based on the success of the operation. Check for that in
> __ath9k_hw_init() and abort with a more debugging-friendly message
> if reading the revisions wasn't successful.
> 
>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>     ath: phy2: Failed to read SREV register
>     ath: phy2: Could not read hardware revision
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath9k_htc: Failed to initialize the device
> 
> This helps when debugging by directly showing the first point of
> failure and it could prevent possible errors if a 0x0f.3 revision
> is ever supported.
> 
> Signed-off-by: Tim Schumacher <timschumi@gmx.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

2f90c7e5d094 ath9k: Check for errors when reading SREV register

-- 
https://patchwork.kernel.org/patch/10858399/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

