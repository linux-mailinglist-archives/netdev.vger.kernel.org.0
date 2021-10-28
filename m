Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D8843DC05
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhJ1HbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:31:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:52194 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhJ1Haz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:30:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635406108; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Xy2s/FZomRSPdghy7qxK71w8rfqcDVVYA5SE6uPgsCs=; b=SIsye3x4u6RTp+CUqYuUJwGclVLvQL5HxXSBOSzgAHdwDsyPw9GFN68WYYCMw8AyXHpA1Iiv
 swi3iNY/hkDCUhvVjsGyB8eNiiAGDsWtihlX2puMkddCKtLZ6PA/89lOjYxXwYIwgSfxMYKv
 g7KGrQyLTToSnY0BYdFmNGSJHz8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 617a511bf6a3eeacf9a39140 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Oct 2021 07:28:27
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 20289C4361B; Thu, 28 Oct 2021 07:28:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1241BC43617;
        Thu, 28 Oct 2021 07:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 1241BC43617
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     Benjamin Li <benl@squareup.com>,
        Joseph Gates <jgates@squareup.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan
References: <20211027170306.555535-1-benl@squareup.com>
        <20211027170306.555535-4-benl@squareup.com>
        <9a933103-afbc-3278-3d2e-ade77b0e4b09@linaro.org>
Date:   Thu, 28 Oct 2021 10:28:19 +0300
In-Reply-To: <9a933103-afbc-3278-3d2e-ade77b0e4b09@linaro.org> (Bryan
        O'Donoghue's message of "Wed, 27 Oct 2021 23:30:18 +0100")
Message-ID: <87pmrp6224.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> writes:

> On 27/10/2021 18:03, Benjamin Li wrote:
>> An SMD capture from the downstream prima driver on WCN3680B shows the
>> following command sequence for connected scans:
>>
>> - init_scan_req
>>      - start_scan_req, channel 1
>>      - end_scan_req, channel 1
>>      - start_scan_req, channel 2
>>      - ...
>>      - end_scan_req, channel 3
>> - finish_scan_req
>> - init_scan_req
>>      - start_scan_req, channel 4
>>      - ...
>>      - end_scan_req, channel 6
>> - finish_scan_req
>> - ...
>>      - end_scan_req, channel 165
>> - finish_scan_req
>>
>> Upstream currently never calls wcn36xx_smd_end_scan, and in some cases[1]
>> still sends finish_scan_req twice in a row or before init_scan_req. A
>> typical connected scan looks like this:
>>
>> - init_scan_req
>>      - start_scan_req, channel 1
>> - finish_scan_req
>> - init_scan_req
>>      - start_scan_req, channel 2
>> - ...
>>      - start_scan_req, channel 165
>> - finish_scan_req
>> - finish_scan_req
>>
>> This patch cleans up scanning so that init/finish and start/end are always
>> paired together and correctly nested.
>>
>> - init_scan_req
>>      - start_scan_req, channel 1
>>      - end_scan_req, channel 1
>> - finish_scan_req
>> - init_scan_req
>>      - start_scan_req, channel 2
>>      - end_scan_req, channel 2
>> - ...
>>      - start_scan_req, channel 165
>>      - end_scan_req, channel 165
>> - finish_scan_req
>>
>> Note that upstream will not do batching of 3 active-probe scans before
>> returning to the operating channel, and this patch does not change that.
>> To match downstream in this aspect, adjust IEEE80211_PROBE_DELAY and/or
>> the 125ms max off-channel time in ieee80211_scan_state_decision.
>>
>> [1]: commit d195d7aac09b ("wcn36xx: Ensure finish scan is not requested
>> before start scan") addressed one case of finish_scan_req being sent
>> without a preceding init_scan_req (the case of the operating channel
>> coinciding with the first scan channel); two other cases are:
>> 1) if SW scan is started and aborted immediately, without scanning any
>>     channels, we send a finish_scan_req without ever sending init_scan_req,
>>     and
>> 2) as SW scan logic always returns us to the operating channel before
>>     calling wcn36xx_sw_scan_complete, finish_scan_req is always sent twice
>>     at the end of a SW scan
>>
>> Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
>> Signed-off-by: Benjamin Li <benl@squareup.com>
>> ---
>>   drivers/net/wireless/ath/wcn36xx/main.c    | 34 +++++++++++++++++-----
>>   drivers/net/wireless/ath/wcn36xx/smd.c     |  4 +++
>>   drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
>>   3 files changed, 32 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
>> index 18383d0fc0933..37b4016f020c9 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/main.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
>> @@ -400,6 +400,7 @@ static void wcn36xx_change_opchannel(struct wcn36xx *wcn, int ch)
>>   static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
>>   {
>>   	struct wcn36xx *wcn = hw->priv;
>> +	int ret;
>>     	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac config changed 0x%08x\n",
>> changed);
>>   @@ -415,17 +416,31 @@ static int wcn36xx_config(struct
>> ieee80211_hw *hw, u32 changed)
>>   			 * want to receive/transmit regular data packets, then
>>   			 * simply stop the scan session and exit PS mode.
>>   			 */
>> -			wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
>> -						wcn->sw_scan_vif);
>> -			wcn->sw_scan_channel = 0;
>> +			if (wcn->sw_scan_channel)
>> +				wcn36xx_smd_end_scan(wcn, wcn->sw_scan_channel);
>> +			if (wcn->sw_scan_init) {
>> +				wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
>> +							wcn->sw_scan_vif);
>> +			}
>>   		} else if (wcn->sw_scan) {
>>   			/* A scan is ongoing, do not change the operating
>>   			 * channel, but start a scan session on the channel.
>>   			 */
>> -			wcn36xx_smd_init_scan(wcn, HAL_SYS_MODE_SCAN,
>> -					      wcn->sw_scan_vif);
>> +			if (wcn->sw_scan_channel)
>> +				wcn36xx_smd_end_scan(wcn, wcn->sw_scan_channel);
>> +			if (!wcn->sw_scan_init) {
>> +				/* This can fail if we are unable to notify the
>> +				 * operating channel.
>> +				 */
>> +				ret = wcn36xx_smd_init_scan(wcn,
>> +							    HAL_SYS_MODE_SCAN,
>> +							    wcn->sw_scan_vif);
>> +				if (ret) {
>> +					mutex_unlock(&wcn->conf_mutex);
>> +					return -EIO;
>> +				}
>> +			}
>>   			wcn36xx_smd_start_scan(wcn, ch);
>> -			wcn->sw_scan_channel = ch;
>>   		} else {
>>   			wcn36xx_change_opchannel(wcn, ch);
>>   		}
>> @@ -723,7 +738,12 @@ static void wcn36xx_sw_scan_complete(struct ieee80211_hw *hw,
>>   	wcn36xx_dbg(WCN36XX_DBG_MAC, "sw_scan_complete");
>>     	/* ensure that any scan session is finished */
>> -	wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN, wcn->sw_scan_vif);
>> +	if (wcn->sw_scan_channel)
>> +		wcn36xx_smd_end_scan(wcn, wcn->sw_scan_channel);
>> +	if (wcn->sw_scan_init) {
>> +		wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
>> +					wcn->sw_scan_vif);
>> +	}
>>   	wcn->sw_scan = false;
>>   	wcn->sw_scan_opchannel = 0;
>>   }
>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
>> index 3cecc8f9c9647..830341be72673 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
>> @@ -721,6 +721,7 @@ int wcn36xx_smd_init_scan(struct wcn36xx *wcn, enum wcn36xx_hal_sys_mode mode,
>>   		wcn36xx_err("hal_init_scan response failed err=%d\n", ret);
>>   		goto out;
>>   	}
>> +	wcn->sw_scan_init = true;
>>   out:
>>   	mutex_unlock(&wcn->hal_mutex);
>>   	return ret;
>> @@ -751,6 +752,7 @@ int wcn36xx_smd_start_scan(struct wcn36xx *wcn, u8 scan_channel)
>>   		wcn36xx_err("hal_start_scan response failed err=%d\n", ret);
>>   		goto out;
>>   	}
>> +	wcn->sw_scan_channel = scan_channel;
>>   out:
>>   	mutex_unlock(&wcn->hal_mutex);
>>   	return ret;
>> @@ -781,6 +783,7 @@ int wcn36xx_smd_end_scan(struct wcn36xx *wcn, u8 scan_channel)
>>   		wcn36xx_err("hal_end_scan response failed err=%d\n", ret);
>>   		goto out;
>>   	}
>> +	wcn->sw_scan_channel = 0;
>>   out:
>>   	mutex_unlock(&wcn->hal_mutex);
>>   	return ret;
>> @@ -822,6 +825,7 @@ int wcn36xx_smd_finish_scan(struct wcn36xx *wcn,
>>   		wcn36xx_err("hal_finish_scan response failed err=%d\n", ret);
>>   		goto out;
>>   	}
>> +	wcn->sw_scan_init = false;
>>   out:
>>   	mutex_unlock(&wcn->hal_mutex);
>>   	return ret;
>> diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
>> index 1c8d918137da2..fbd0558c2c196 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
>> +++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
>> @@ -248,6 +248,7 @@ struct wcn36xx {
>>   	struct cfg80211_scan_request *scan_req;
>>   	bool			sw_scan;
>>   	u8			sw_scan_opchannel;
>> +	bool			sw_scan_init;
>>   	u8			sw_scan_channel;
>>   	struct ieee80211_vif	*sw_scan_vif;
>>   	struct mutex		scan_lock;
>>
>
> LGTM
>
> Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Thanks, all review and testing is very much appreciated. But please trim
your replies, including the whole patch makes reading your replies and
using patchwork much harder:

https://patchwork.kernel.org/project/linux-wireless/patch/20211027170306.555535-4-benl@squareup.com/

I recommend just including the commit log and dropping the rest.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
