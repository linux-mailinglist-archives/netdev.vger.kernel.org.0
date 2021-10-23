Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CCE438233
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 09:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhJWHc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 03:32:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:15783 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhJWHc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 03:32:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634974239; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=6prkHAzg/ianVXk7VNqt9m/tBBvysRNdknkhwFj3piw=;
 b=uNKBukWTW7nQkuiAQCDAgK1PwZWGhhGB/v4EzonFS/17rQF4m5SYLmhpPzo+KvbnpyYdKL2w
 V7ENvyXll0+8fQq/LVjwaqwOBNoqPr2V21LeveCeQHUqix+2Xf+DUK22FMLj16JmISQPjufi
 lyLu19zHqQ8qGh1d9zQdOzJFmck=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6173ba0167f107c611dbe0b3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 07:30:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7C0D2C43460; Sat, 23 Oct 2021 07:30:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3F41C4338F;
        Sat, 23 Oct 2021 07:30:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C3F41C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC,v2] mt76: mt7615: mt7622: fix ibss and meshpoint
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211007225725.2615-1-vincent@systemli.org>
References: <20211007225725.2615-1-vincent@systemli.org>
To:     Nick Hainke <vincent@systemli.org>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>,
        Nick Hainke <vincent@systemli.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163497420151.29616.16838354269777236200.kvalo@codeaurora.org>
Date:   Sat, 23 Oct 2021 07:30:09 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Hainke <vincent@systemli.org> wrote:

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
> Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces")
> Signed-off-by: Nick Hainke <vincent@systemli.org>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

753453afacc0 mt76: mt7615: mt7622: fix ibss and meshpoint

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211007225725.2615-1-vincent@systemli.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

