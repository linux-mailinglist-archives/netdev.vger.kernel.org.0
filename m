Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B40C427822
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 10:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhJIIeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 04:34:21 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:14483 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhJIIeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 04:34:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633768344; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=3Za8k22LQYkE0ul8eOPaPOScUgtlzThVQSJqA9jh51Y=; b=Fb7zy05VGO9y68xi79tNTfvrcDx7mpYtIOCp+5yUc+YbNTfMOJuL+Hb3aWzGKP4+0Yh1ZFDI
 OhFypgVJEKl1re5aoK+ltR7/ib/3yDMIs9BIYpEzpmAk9ToedKBUn5dQubPu5xQWOWOE2IAF
 9FDj5ZQ8pdxT0hwwGzDbx+b2ylE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6161539703355859c832eb14 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 09 Oct 2021 08:32:23
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 47CF8C4360D; Sat,  9 Oct 2021 08:32:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E5164C4338F;
        Sat,  9 Oct 2021 08:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E5164C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nick Hainke <vincent@systemli.org>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
References: <20211007225725.2615-1-vincent@systemli.org>
Date:   Sat, 09 Oct 2021 11:32:14 +0300
In-Reply-To: <20211007225725.2615-1-vincent@systemli.org> (Nick Hainke's
        message of "Fri, 8 Oct 2021 00:57:25 +0200")
Message-ID: <87czoe61kh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Hainke <vincent@systemli.org> writes:

> Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").

The fixes tag should be in the end, before Signed-off-by tags. But I can
fix that during commit.

> commit 7f4b7920318b ("mt76: mt7615: add ibss support") introduced IBSS
> and commit f4ec7fdf7f83 ("mt76: mt7615: enable support for mesh")
> meshpoint support.
>
> Both used in the "get_omac_idx"-function:
>
> 	if (~mask & BIT(HW_BSSID_0))
> 		return HW_BSSID_0;
>
> With commit d8d59f66d136 ("mt76: mt7615: support 16 interfaces") the
> ibss and meshpoint mode should "prefer hw bssid slot 1-3". However,
> with that change the ibss or meshpoint mode will not send any beacon on
> the mt7622 wifi anymore. Devices were still able to exchange data but
> only if a bssid already existed. Two mt7622 devices will never be able
> to communicate.
>
> This commits reverts the preferation of slot 1-3 for ibss and
> meshpoint. Only NL80211_IFTYPE_STATION will still prefer slot 1-3.
>
> Tested on Banana Pi R64.
>
> Signed-off-by: Nick Hainke <vincent@systemli.org>

Felix, can I take this to wireless-drivers? Ack?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
