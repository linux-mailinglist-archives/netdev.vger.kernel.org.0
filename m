Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9329D3DC4A9
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 09:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhGaHyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 03:54:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:25312 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbhGaHx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 03:53:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627718030; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=053XoErYIp5BO4CyS7/Ja55Uun492HY50+ChgG3h3PM=; b=JRg2u9WNWnDPLttliR8fXE+VKfd9DOgEOcTP4tYm7nubkP3EEyUTZXQzUgtFC3NuQ74MYkZ7
 QGnKFG5LSytEo+CHGm+7iTO27us2yGOu0hBQOo93keIncchAGpjruo9I+KyKk9c+jdArm5az
 T1WSPVeET+WjmIZH1DjaEhYhuZY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6105017d17c2b4047da051ba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 31 Jul 2021 07:53:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 08086C4323A; Sat, 31 Jul 2021 07:53:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 535BEC433D3;
        Sat, 31 Jul 2021 07:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 535BEC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg KH <greg@kroah.com>
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH V2] cfg80211: Fix possible memory leak in function cfg80211_bss_update
References: <20210628132334.851095-1-phind.uet@gmail.com>
        <YQKELjKuAQsjmpLY@kroah.com>
Date:   Sat, 31 Jul 2021 10:53:28 +0300
In-Reply-To: <YQKELjKuAQsjmpLY@kroah.com> (Greg KH's message of "Thu, 29 Jul
        2021 12:34:22 +0200")
Message-ID: <877dh6dimf.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Mon, Jun 28, 2021 at 09:23:34PM +0800, Nguyen Dinh Phi wrote:
>> When we exceed the limit of BSS entries, this function will free the
>> new entry, however, at this time, it is the last door to access the
>> inputed ies, so these ies will be unreferenced objects and cause memory
>> leak.
>> Therefore we should free its ies before deallocating the new entry, beside
>> of dropping it from hidden_list.
>> 
>> Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>

[...]

> Did this change get lost somewhere?

Johannes applied it to the macc80211 tree:

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/commit/?id=f9a5c358c8d26fed0cc45f2afc64633d4ba21dff

Ah, and it's already in Linus' tree as well.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
