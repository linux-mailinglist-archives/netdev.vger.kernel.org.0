Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B18320495
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 10:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhBTJIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 04:08:45 -0500
Received: from z11.mailgun.us ([104.130.96.11]:32068 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhBTJIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 04:08:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613812085; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=K1oeCEHtgyAcQeVkUAX9y//DnPQ0qwPlMtqyd51eMEM=; b=hRD17bKWKfF4QbMDyYOAxR60Yb0rt1XwPag2S6D2CvpzWwpcE1sj9ORUYpIojXvqZBRAl+K2
 mXWLV4ki6olKQCYsekzJjEiQ3fc42kqyCH77qjagHl5LF4AMBjuyskokzytiXuWqDtWERQ5W
 +yBnqc3Fs4M4vm1u3/S/9e+oqZ4=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6030d15b7237f827dc2d8748 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 20 Feb 2021 09:07:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D487EC43461; Sat, 20 Feb 2021 09:07:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5C3BC433CA;
        Sat, 20 Feb 2021 09:07:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B5C3BC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hao Chen <chenhaoa@uniontech.com>
Cc:     tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR laptop
References: <20210220084602.22386-1-chenhaoa@uniontech.com>
Date:   Sat, 20 Feb 2021 11:07:34 +0200
In-Reply-To: <20210220084602.22386-1-chenhaoa@uniontech.com> (Hao Chen's
        message of "Sat, 20 Feb 2021 16:46:02 +0800")
Message-ID: <878s7jjeeh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hao Chen <chenhaoa@uniontech.com> writes:

> When the laptop HONOR MagicBook 14 sleep to S3/S4, the laptop can't
> resume.
> The dmesg of kernel report:
> "[   99.990168] pcieport 0000:00:01.2: can't change power state
> from D3hot to D0 (config space inaccessible)
> [   99.993334] rtw_pci 0000:01:00.0: can't change power state
> from D3hot to D0 (config space inaccessible)
> [  104.435004] rtw_pci 0000:01:00.0: mac power on failed
> [  104.435010] rtw_pci 0000:01:00.0: failed to power on mac"
> When try to pointer the driver.pm to NULL, the problem is fixed.
> This driver hasn't implemented pm ops yet.It makes the sleep and
> wake procedure expected when pm's ops not NULL.

But why rtw_pci_suspend() and rtw_pci_resume() are empty? Should we just
remove them if they cause issues for the users? And if they are really
needed there should be a comment in the functions explaining the
situation.

> Fixed: commit e3037485c68e ("rtw88: new Realtek 802.11ac driver")

This should be:

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
