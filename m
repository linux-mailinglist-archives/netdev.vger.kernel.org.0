Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F6F1A2E65
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 06:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDIE3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 00:29:52 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:63099 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbgDIE3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 00:29:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586406591; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=B3sXth08Y02Tmoumwkje6Jf2EC2NrHb4e6PE2kpw8bM=; b=C+vn6DEB9vqBg8YNTydR6sBdGszWrYuNk0gcaPQcfZKooczxAV/fJCEQbZaanzO7jDcesyVT
 D9nF+GkvNQ2NhI5dNNjC3f0yi8lZczWw2W4eOnvKWgm205IhO42dKUwhKncjRNU4pWamuYJi
 DT8frQt9ZjflsAnlhs3k/C+RuHk=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8ea4b9.7f540a9fd420-smtp-out-n04;
 Thu, 09 Apr 2020 04:29:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AE7F7C43637; Thu,  9 Apr 2020 04:29:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BCE66C433F2;
        Thu,  9 Apr 2020 04:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BCE66C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Chin-Yen Lee <timlee@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Norris <briannorris@chromium.org>,
        Chris Chiu <chiu@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtw88: avoid unused function warnings
References: <20200408185413.218643-1-arnd@arndb.de>
Date:   Thu, 09 Apr 2020 07:29:39 +0300
In-Reply-To: <20200408185413.218643-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 8 Apr 2020 20:53:51 +0200")
Message-ID: <87v9m9uvrg.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> The rtw88 driver defines emtpy functions with multiple indirections
> but gets one of these wrong:
>
> drivers/net/wireless/realtek/rtw88/pci.c:1347:12: error: 'rtw_pci_resume' defined but not used [-Werror=unused-function]
>  1347 | static int rtw_pci_resume(struct device *dev)
>       |            ^~~~~~~~~~~~~~
> drivers/net/wireless/realtek/rtw88/pci.c:1342:12: error: 'rtw_pci_suspend' defined but not used [-Werror=unused-function]
>  1342 | static int rtw_pci_suspend(struct device *dev)
>
> Better simplify it to rely on the conditional reference in
> SIMPLE_DEV_PM_OPS(), and mark the functions as __maybe_unused to avoid
> warning about it.
>
> I'm not sure if these are needed at all given that the functions
> don't do anything, but they were only recently added.
>
> Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I'll queue this to v5.7.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
