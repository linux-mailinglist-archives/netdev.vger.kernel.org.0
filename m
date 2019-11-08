Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF253F421C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 09:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbfKHIbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 03:31:12 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfKHIbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 03:31:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C10526087D; Fri,  8 Nov 2019 08:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573201871;
        bh=34LszczZ92Bfm5fxE+0iGWvnvoA6DVyJ5WaRZ59PkCo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eGMQe9cOecy7G7/hH10g77CHW9EyERa3RktxbSQ6kcIzNbDIoAmtJbtBuxKte7GNg
         sHVcG1Z7rapfPeDiZ4b/jTALqatxqmOgvwfbG+XuCC+ieEqyYwGXRd4ix1zS266j8Y
         F4gmxiBH3nfugRryrSH0fgDrg4N3xo2stgv4nLjw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 91CB160397;
        Fri,  8 Nov 2019 08:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573201871;
        bh=34LszczZ92Bfm5fxE+0iGWvnvoA6DVyJ5WaRZ59PkCo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eGMQe9cOecy7G7/hH10g77CHW9EyERa3RktxbSQ6kcIzNbDIoAmtJbtBuxKte7GNg
         sHVcG1Z7rapfPeDiZ4b/jTALqatxqmOgvwfbG+XuCC+ieEqyYwGXRd4ix1zS266j8Y
         F4gmxiBH3nfugRryrSH0fgDrg4N3xo2stgv4nLjw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 91CB160397
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        Ikjoon Jang <ikjn@chromium.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: disable cpuidle during downloading firmware.
References: <20191101054035.42101-1-ikjn@chromium.org>
        <87y2ws3lvh.fsf@kamboji.qca.qualcomm.com>
        <CAKR_QVKqGv+hpiENHmNFE4y=FY+Mqb7cAh7_5xhTXH27HW+Taw@mail.gmail.com>
Date:   Fri, 08 Nov 2019 10:31:07 +0200
In-Reply-To: <CAKR_QVKqGv+hpiENHmNFE4y=FY+Mqb7cAh7_5xhTXH27HW+Taw@mail.gmail.com>
        (Tom Psyborg's message of "Wed, 6 Nov 2019 19:33:54 +0100")
Message-ID: <87bltmydkk.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Psyborg <pozega.tomislav@gmail.com> writes:

> On 06/11/2019, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Ikjoon Jang <ikjn@chromium.org> writes:
>>
>>> Downloading ath10k firmware needs a large number of IOs and
>>> cpuidle's miss predictions make it worse. In the worst case,
>>> resume time can be three times longer than the average on sdio.
>>>
>>> This patch disables cpuidle during firmware downloading by
>>> applying PM_QOS_CPU_DMA_LATENCY in ath10k_download_fw().
>>>
>>> Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
>>
>> On what hardware and firmware versions did you test this? I'll add that
>> to the commit log.
>
> I've tested this on QCA9880. No issues during firmware download.

Great, thanks for testing.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
