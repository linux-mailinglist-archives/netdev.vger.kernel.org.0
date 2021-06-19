Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D011B3AD8CD
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 11:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhFSJIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 05:08:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20333 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhFSJId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Jun 2021 05:08:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624093582; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=JExdWib+2vNvSJ1ZeWNdFikcr81uBm3qt2YwfkU3z68=;
 b=pEqqmxqLZXL3KxxzeKAup8xqxjNN/sxwdM6huv0HMddJThfsNh0/QayPS0Q94s8+p4+SX6q8
 a5YmMd4ZQi+wmq0xHRbeeu1KNPhiqN912/w6GZbZZcafIzS11bBa4Ynk5nWBAWsnKpm8N5OC
 xqtPT3Lv1RNNbBQ0+lXYVfz0WOs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60cdb38ce570c056194f6451 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Jun 2021 09:06:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D786BC43460; Sat, 19 Jun 2021 09:06:19 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9C290C433D3;
        Sat, 19 Jun 2021 09:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9C290C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rtl8xxxu: avoid parsing short RX packet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210511071926.8951-1-ihuguet@redhat.com>
References: <20210511071926.8951-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ihuguet@redhat.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210619090619.D786BC43460@smtp.codeaurora.org>
Date:   Sat, 19 Jun 2021 09:06:19 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Íñigo Huguet <ihuguet@redhat.com> wrote:

> One USB data buffer can contain multiple received network
> packets. If that's the case, they're processed this way:
> 1. Original buffer is cloned
> 2. Original buffer is trimmed to contain only the first
>    network packet
> 3. This first network packet is passed to network stack
> 4. Cloned buffer is trimmed to eliminate the first network
>    packet
> 5. Repeat with the cloned buffer until there are no more
>    network packets inside
> 
> However, if the space remaining in original buffer after
> the first network packet is not enough to contain at least
> another network packet descriptor, it is not cloned.
> 
> The loop parsing this packets ended if remaining space == 0.
> But if the remaining space was > 0 but < packet descriptor
> size, another iteration of the loop was done, processing again
> the previous packet because cloning didn't happen. Moreover,
> the ownership of this packet had been passed to network
> stack in the previous iteration.
> 
> This patch ensures that no extra iteration is done if the
> remaining size is not enough for one packet, and also avoid
> the first iteration for the same reason.
> 
> Probably this doesn't happen in practice, but can happen
> theoretically.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

adf6a0f8c0a6 rtl8xxxu: avoid parsing short RX packet

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210511071926.8951-1-ihuguet@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

