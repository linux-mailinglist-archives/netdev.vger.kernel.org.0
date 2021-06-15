Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE03A7C3D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhFOKpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:45:14 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:50647 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhFOKpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:45:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623753789; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=26jUmp4vDfJYFJ+Qjl7Y8g8Lair1pch9T7baqcUuAJ4=;
 b=plhkZG6wCH0xfl5RDKnMJB1/uKH52Zfj4x4IqvQvsclBSoBoZqJpnD3MmX5vhYmY8tjbmPpX
 u5lZqQBo/lRx30X51YUgRrbLrVwZjz29X7sM4kE6sgEMr7UvKj+1Sp0VMGLUdGtAllBOppvl
 /o9Bnnq9UZaXDnMvkTGT9PdnHqY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60c88420b6ccaab753a548fd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 10:42:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57EF3C433F1; Tue, 15 Jun 2021 10:42:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC250C433F1;
        Tue, 15 Jun 2021 10:42:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CC250C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: brcmsmac: Drop unnecessary NULL check after container_of
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210511235629.1686038-1-linux@roeck-us.net>
References: <20210511235629.1686038-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615104240.57EF3C433F1@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 10:42:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> wrote:

> The parameter passed to ai_detach() is guaranteed to never be NULL
> because it is checked by the caller. Consequently, the result of
> container_of() on it is also never NULL, and a NULL check on it
> is unnecessary. Even without that, the NULL check would still be
> unnecessary because the subsequent kfree() can handle NULL arguments.
> On top of all that, it is misleading to check the result of container_of()
> against NULL because the position of the contained element could change,
> which would make the check invalid. Remove it.
> 
> This change was made automatically with the following Coccinelle script.
> 
> @@
> type t;
> identifier v;
> statement s;
> @@
> 
> <+...
> (
>   t v = container_of(...);
> |
>   v = container_of(...);
> )
>   ...
>   when != v
> - if (\( !v \| v == NULL \) ) s
> ...+>
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Patch applied to wireless-drivers-next.git, thanks.

34fe7038a3b3 brcmsmac: Drop unnecessary NULL check after container_of

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210511235629.1686038-1-linux@roeck-us.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

