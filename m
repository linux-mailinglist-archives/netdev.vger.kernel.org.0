Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC81651A7C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 07:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiLTGCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 01:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiLTGCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 01:02:32 -0500
Received: from pv50p00im-ztbu10021601.me.com (pv50p00im-ztbu10021601.me.com [17.58.6.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B9A14D1E
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1671516148;
        bh=7qE9xHexBnOSQP7DLwAIc3M9AGwYnVABLly0YPrjr8A=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=nJyvAOpnjXw3HDo+bjrSq3f+9gyNPaMuxpKgU0SYbt9BPAM6KwkTGpZxY5uBMSZHI
         gmTQ2tIjVZAAsIxTDL0wOf+noiYK+P2jYkOhEuqHzfHnE9mathwJw4hBH5c9XOBAMX
         bFkXb6+MelOiEU2CauDFEMTsdT/iouBs6ymYslRoT8SzE73cXzUgAblRfUXs9RjXCx
         FyGVej9HfPSv0sn4Lt3hrjFCRjSY/9wYm9L9Olv2FMChvJS4XRrg29Q/DoL5tsj9KI
         LY5YbC5Sq58odlp5pWRbXnF2zZcn1CdSw/i/NLpFELDiK37OVkZ1HX3z8eEUzsjLpG
         Hr5CgFj4DXjtA==
Received: from [192.168.1.30] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztbu10021601.me.com (Postfix) with ESMTPSA id 34CCA8089D;
        Tue, 20 Dec 2022 06:02:24 +0000 (UTC)
Message-ID: <feb8e6f0-be76-925d-e85d-793085dface6@zzy040330.moe>
Date:   Tue, 20 Dec 2022 14:02:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
To:     Ping-Ke Shih <pkshih@realtek.com>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
 <3b4124ebabcb4ceaae89cd9ccf84c7de@realtek.com>
Content-Language: en-US
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <3b4124ebabcb4ceaae89cd9ccf84c7de@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Ab5CiSP5moxstGcKAV8LZuvltnmr-6h9
X-Proofpoint-GUID: Ab5CiSP5moxstGcKAV8LZuvltnmr-6h9
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.572,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F01:2022-06-21=5F01,2020-02-14=5F11,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=741 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 clxscore=1030 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212200050
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/12/2022 13:44, Ping-Ke Shih wrote:
>
>> -----Original Message-----
>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Sent: Saturday, December 17, 2022 11:07 AM
>> To: Jes.Sorensen@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
>> <JunASAKA@zzy040330.moe>
>> Subject: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
>>
>> Fixing transmission failure which results in
>> "authentication with ... timed out". This can be
>> fixed by disable the REG_TXPAUSE.
>>
>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> ---
>>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> index a7d76693c02d..9d0ed6760cb6 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>>   	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>>   	val8 &= ~BIT(0);
>>   	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
>> +
>> +	/*
>> +	 * Fix transmission failure of rtl8192e.
>> +	 */
>> +	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
> I trace when rtl8xxxu set REG_TXPAUSE=0xff that will stop TX.
> The occasions include RF calibration, LPS mode (called by power off), and
> going to stop. So, I think RF calibration does TX pause but not restore
> settings after calibration, and causes TX stuck. As the flow I traced,
> this patch looks reasonable. But, I wonder why other people don't meet
> this problem.
>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
>
>>   }
>>
>>   static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)
>> --
>> 2.31.1

For my occasion, one of my rtl8192ru device which is Tenda U1 doesn't 
work originally with this module, it prints "authentication with ... 
timed out" in dmesg. And this change can fix the problem.

Thanks for your review.


Jun ASAKA.

