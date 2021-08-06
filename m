Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5AB3E2AA0
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343709AbhHFMcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:32:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:17751 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343705AbhHFMcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 08:32:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628253150; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=64u7uNH1LgCuCacOvZPPHByj6Huub6A+vuiCo061RFw=; b=uKGaKfx9zvinlRfwJBIpePy7RnehuIWRisrF3DeJFJp85QkHEZBZTRte/99WV2IkRU0epb/w
 TDyJczjnf8t1gPpMD9hWapywP9JKkhVFMpiDovnOQpALsZpTPOBDaOOWkmDoh8MS1LVB8mF7
 ziXT5RG2ABqzVAffo7SsGmnzQrY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 610d2bbfb4dfc4b0efbb0243 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 12:31:59
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 48B99C4338A; Fri,  6 Aug 2021 12:31:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4B1ABC4338A;
        Fri,  6 Aug 2021 12:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4B1ABC4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Reto Schneider <rs@hqv.ch>
Cc:     chris.chiu@canonical.com, code@reto-schneider.ch,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jes.sorensen@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v2] rtl8xxxu: Fix the handling of TX A-MPDU aggregation
References: <20210804151325.86600-1-chris.chiu@canonical.com>
        <26f85a9f-552d-8420-0010-f5cda70d3a00@hqv.ch>
Date:   Fri, 06 Aug 2021 15:31:52 +0300
In-Reply-To: <26f85a9f-552d-8420-0010-f5cda70d3a00@hqv.ch> (Reto Schneider's
        message of "Fri, 6 Aug 2021 12:03:18 +0200")
Message-ID: <87o8aabvpj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reto Schneider <rs@hqv.ch> writes:

> On 8/4/21 17:13, chris.chiu@canonical.com wrote:
>> The TX A-MPDU aggregation is not handled in the driver since the
>> ieee80211_start_tx_ba_session has never been started properly.
>> Start and stop the TX BA session by tracking the TX aggregation
>> status of each TID. Fix the ampdu_action and the tx descriptor
>> accordingly with the given TID.
>
> I'd like to test this but I am not sure what to look for (before and
> after applying the patch).

Thanks, testing feedback is always very much appreciated.

> What should I look for when looking at the (sniffed) Wireshark traces?

From my (maintainer) point of view most important is that there are no
regressions visible to users, for example no data stalls, crashes or
anything like that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
