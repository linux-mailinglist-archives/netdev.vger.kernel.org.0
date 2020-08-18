Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E9247BF1
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 03:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgHRBm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 21:42:59 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:58142 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgHRBm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 21:42:57 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee35f3b320ed58-a7502; Tue, 18 Aug 2020 09:42:38 +0800 (CST)
X-RM-TRANSID: 2ee35f3b320ed58-a7502
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.21.77] (unknown[10.42.68.12])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55f3b320d8b7-328ee;
        Tue, 18 Aug 2020 09:42:38 +0800 (CST)
X-RM-TRANSID: 2ee55f3b320d8b7-328ee
Subject: Re: [PATCH] ath10k: fix the status check and wrong return
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
References: <20200814144844.1920-1-tangbin@cmss.chinamobile.com>
 <87y2mdjqkx.fsf@codeaurora.org>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <e53ee8ca-9c2b-2313-6fd7-8f73ae33e1a2@cmss.chinamobile.com>
Date:   Tue, 18 Aug 2020 09:42:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87y2mdjqkx.fsf@codeaurora.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle£º

ÔÚ 2020/8/17 22:26, Kalle Valo Ð´µÀ:
>> In the function ath10k_ahb_clock_init(), devm_clk_get() doesn't
>> return NULL. Thus use IS_ERR() and PTR_ERR() to validate
>> the returned value instead of IS_ERR_OR_NULL().
> Why? What's the benefit of this patch? Or what harm does
> IS_ERR_OR_NULL() create?

Thanks for you reply, the benefit of this patch is simplify the code, 
because in

this function, I don't think the situation of 'devm_clk_get() return 
NULL' exists.

So please think about it, thanks.


Tang Bin

>
>> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/ahb.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
>> index ed87bc00f..ea669af6a 100644
>> --- a/drivers/net/wireless/ath/ath10k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath10k/ahb.c
>> @@ -87,24 +87,24 @@ static int ath10k_ahb_clock_init(struct ath10k *ar)
>>   	dev = &ar_ahb->pdev->dev;
>>   
>>   	ar_ahb->cmd_clk = devm_clk_get(dev, "wifi_wcss_cmd");
>> -	if (IS_ERR_OR_NULL(ar_ahb->cmd_clk)) {
>> +	if (IS_ERR(ar_ahb->cmd_clk)) {
>>   		ath10k_err(ar, "failed to get cmd clk: %ld\n",
>>   			   PTR_ERR(ar_ahb->cmd_clk));
>> -		return ar_ahb->cmd_clk ? PTR_ERR(ar_ahb->cmd_clk) : -ENODEV;
>> +		return PTR_ERR(ar_ahb->cmd_clk);
>>   	}
> devm_clk_get() can return NULL if CONFIG_HAVE_CLK is disabled:
>
> static inline struct clk *devm_clk_get(struct device *dev, const char *id)
> {
> 	return NULL;
> }
>


