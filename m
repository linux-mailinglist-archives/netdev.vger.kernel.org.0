Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54991316106
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBJIaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:30:10 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:43941 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229918AbhBJI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:29:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612945765; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=BQcw0kZHs0UzLmmDYGY+jo88rGm4rVQUuEYLarQue+s=; b=I3By4EIma951xdeUfUAVOrFqzbaaYlwQ3gdUSPrMsBaYOf8vAjF+eoqqrbOQEcBbjOFWSNSD
 omLOKVEN/L2kH5EAoTiNwnEwNyHYNvEvB8C6Y9XoqkOBItC64EEuZlG5vDA/rIyuFtQzJ+nb
 t3j8IKMMXlrhJDNPE2g3vKAj7Ls=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6023994481f6c45dce0f6d5c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Feb 2021 08:28:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5679CC43469; Wed, 10 Feb 2021 08:28:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5CADDC43461;
        Wed, 10 Feb 2021 08:28:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5CADDC43461
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH 5/5] ath10k: reduce invalid ht params rate message noise
References: <cover.1612915444.git.skhan@linuxfoundation.org>
        <76a816d983e6c4d636311738396f97971b5523fb.1612915444.git.skhan@linuxfoundation.org>
        <5c31f6dadbcc3dcb19239ad2b6106773@codeaurora.org>
Date:   Wed, 10 Feb 2021 10:28:45 +0200
In-Reply-To: <5c31f6dadbcc3dcb19239ad2b6106773@codeaurora.org> (Wen Gong's
        message of "Wed, 10 Feb 2021 10:36:23 +0800")
Message-ID: <87h7mktjgi.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wen Gong <wgong@codeaurora.org> writes:

> On 2021-02-10 08:42, Shuah Khan wrote:
>> ath10k_mac_get_rate_flags_ht() floods dmesg with the following
>> messages,
>> when it fails to find a match for mcs=7 and rate=1440.
>>
>> supported_ht_mcs_rate_nss2:
>> {7,  {1300, 2700, 1444, 3000} }
>>
>> ath10k_pci 0000:02:00.0: invalid ht params rate 1440 100kbps nss 2
>> mcs 7
>>
>> dev_warn_ratelimited() isn't helping the noise. Use dev_warn_once()
>> instead.
>>
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 3545ce7dce0a..276321f0cfdd 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -8970,8 +8970,9 @@ static void ath10k_mac_get_rate_flags_ht(struct
>> ath10k *ar, u32 rate, u8 nss, u8
>>  		*bw |= RATE_INFO_BW_40;
>>  		*flags |= RATE_INFO_FLAGS_SHORT_GI;
>>  	} else {
>> -		ath10k_warn(ar, "invalid ht params rate %d 100kbps nss %d mcs %d",
>> -			    rate, nss, mcs);
>> +		dev_warn_once(ar->dev,
>> +			      "invalid ht params rate %d 100kbps nss %d mcs %d",
>> +			      rate, nss, mcs);
>>  	}
>>  }
>
> The {7,  {1300, 2700, 1444, 3000} } is a correct value.
> The 1440 is report from firmware, its a wrong value, it has fixed in
> firmware.

In what version?

> If change it to dev_warn_once, then it will have no chance to find the
> other wrong values which report by firmware, and it indicate
> a wrong value to mac80211/cfg80211 and lead "iw wlan0 station dump"
> get a wrong bitrate.

I agree, we should keep this warning. If the firmware still keeps
sending invalid rates we should add a specific check to ignore the known
invalid values, but not all of them.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
