Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14662F667A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbhANQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:55:03 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:54280 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbhANQzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:55:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610643275; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2dDSdRh9UZ/2znGwAyp9VyErRlya3vyr5Lu5YMhcqbE=;
 b=Y/g+ANIGctEa5EZpxdIUz0GJjAgLoJGi1ZMec4P0+dEpAcNDmypxKdKrrQesiLmU7x8KYD/U
 hVDDfg6zvqAFL/k/5sGcnGUIUC1FJ6YwPKCSviKem73fNEwdEfd4/lKc7by8s4NlAqfaIhzb
 P2BnDaUKry15XIhTTrQJOPwHlxk=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6000772c415a6293c59074c8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 16:54:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D9318C43466; Thu, 14 Jan 2021 16:54:04 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E295C43461;
        Thu, 14 Jan 2021 16:54:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8E295C43461
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: mt7915: fix misplaced #ifdef
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210103135811.3749775-1-arnd@kernel.org>
References: <20210103135811.3749775-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114165404.D9318C43466@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 16:54:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The lone '|' at the end of a line causes a build failure:
> 
> drivers/net/wireless/mediatek/mt76/mt7915/init.c:47:2: error: expected expression before '}' token
> 
> Replace the #ifdef with an equivalent IS_ENABLED() check.
> 
> Fixes: af901eb4ab80 ("mt76: mt7915: get rid of dbdc debugfs knob")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This was already fixed by:

0bd157fa2aaa mt76: mt7915: fix MESH ifdef block

Recorded preimage for 'drivers/net/wireless/mediatek/mt76/mt7915/init.c'
error: Failed to merge in the changes.
Applying: mt76: mt7915: fix misplaced #ifdef
Using index info to reconstruct a base tree...
M	drivers/net/wireless/mediatek/mt76/mt7915/init.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/mediatek/mt76/mt7915/init.c
CONFLICT (content): Merge conflict in drivers/net/wireless/mediatek/mt76/mt7915/init.c
Patch failed at 0001 mt76: mt7915: fix misplaced #ifdef
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210103135811.3749775-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

