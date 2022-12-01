Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20C263E728
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 02:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLABit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 20:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLABir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 20:38:47 -0500
Received: from pv50p00im-zteg10011501.me.com (pv50p00im-zteg10011501.me.com [17.58.6.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB119953C
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 17:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669858726;
        bh=FYXfjZRM6Alu8j0iBNJfkxXx1o2E05N1SoEyiLJM9G4=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=Dx5+ozzifgYltsJMSUtEb1ehj1NbPP0lYQHZyp/APT3q6ExeqM/hge08r7ZBjWO83
         iCr01kWWWsZ7v42dPnGlp09uazS1tdkBtBCX38pHgEHNVk1fgBmXXS6+5QSVRgL3MF
         5vM3HTupKPT4byciWPywa/XgVG9XE5oep+QpDsg2N4IHbaGzl8QBC3mzRoy3k4Uk1L
         FTTK52RejEokwSI6pfmbtGZP2/wowNiZZjeIQbC6YVdBIQHz6eXq+Kef/KzQhLixxC
         j/xN0MdhbSGz3KWCww/Mr+vsL3WggyWdQEg1K1dj4U8IQWsdX4y4pSpUJlIlb5Inma
         TGO1gekyupYYQ==
Received: from [10.8.0.2] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id 49E312E007B;
        Thu,  1 Dec 2022 01:38:43 +0000 (UTC)
Message-ID: <6ce2e648-9c12-56a1-9118-e1e18c7ecd7d@zzy040330.moe>
Date:   Thu, 1 Dec 2022 09:38:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Content-Language: en-GB
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
References: <20221130140849.153705-1-JunASAKA@zzy040330.moe>
 <663e6d79c34f44998a937fe9fbd228e9@realtek.com>
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
In-Reply-To: <663e6d79c34f44998a937fe9fbd228e9@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: HIk-QxeqAB7rSSlbznkbuHQsx_yj5pJc
X-Proofpoint-ORIG-GUID: HIk-QxeqAB7rSSlbznkbuHQsx_yj5pJc
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.572,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F01:2022-06-21=5F01,2020-02-14=5F11,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1030 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212010007
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 8:54 am, Ping-Ke Shih wrote:

>
>> -----Original Message-----
>> From: JunASAKA <JunASAKA@zzy040330.moe>
>> Sent: Wednesday, November 30, 2022 10:09 PM
>> To: Jes.Sorensen@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; JunASAKA
>> <JunASAKA@zzy040330.moe>
>> Subject: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>>
>> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
>> issues for rtl8192eu chips by replacing the arguments with
>> the ones in the updated official driver.
> I think it would be better if you can point out which version you use, and
> people will not modify them back to old version suddenly.
>
>> Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
>> ---
>>   .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 76 +++++++++++++------
>>   1 file changed, 54 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> index b06508d0cd..82346500f2 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> [...]
>
>> @@ -891,22 +907,28 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
>>
>>   	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>>   	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00180);
>> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>>
>> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x20000);
>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0x07f77);
>> +
>>   	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>>
>> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>> +
> I think this is a test code of vendor driver. No need them here.
>
>
>>   	/* Path B IQK setting */
>>   	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
>>   	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
>>   	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
>>   	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
>>
>> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x821403e2);
>> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82140303);
>>   	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160000);
>>
>>   	/* LO calibration setting */
>> -	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00492911);
>> +	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00462911);
>>
>>   	/* One shot, path A LOK & IQK */
>>   	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
> [...]
>
> I have compared your patch with internal code, and they are the same.
> But, I don't have a test.
>
> Ping-Ke

I changed those arguments into the ones here: 
https://github.com/Mange/rtl8192eu-linux-driver which works fine with my 
rtl8192eu wifi dongle. But forgive my ignorant that I don't have enough 
experience on wifi drivers, I just compared those two drivers and 
figured that those codes fixing my IQK failures.

I tested it on my PC (fedora 37 with kernel v6.1.0-rc7) with my 
rtl8192eu device and it works well.


Jun ASAKA.


