Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B09648EB7
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 13:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiLJMrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 07:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiLJMrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 07:47:49 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11C4BC05;
        Sat, 10 Dec 2022 04:47:44 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NTncc0g3VzqSyh;
        Sat, 10 Dec 2022 20:43:28 +0800 (CST)
Received: from [10.67.111.176] (10.67.111.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sat, 10 Dec 2022 20:47:40 +0800
Message-ID: <40c4ace2-68f3-5e7d-2e68-7ea36a104a28@huawei.com>
Date:   Sat, 10 Dec 2022 20:47:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in
 _rtl8812ae_phy_set_txpower_limit()
Content-Language: en-US
To:     Ping-Ke Shih <pkshih@realtek.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221207152319.3135500-1-lizetao1@huawei.com>
 <e985ead3ea7841b8b3a94201dfb18776@realtek.com>
From:   Li Zetao <lizetao1@huawei.com>
In-Reply-To: <e985ead3ea7841b8b3a94201dfb18776@realtek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.176]
X-ClientProxiedBy: dggpeml500012.china.huawei.com (7.185.36.15) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On 2022/12/9 13:11, Ping-Ke Shih wrote:
>
>> -----Original Message-----
>> From: Li Zetao <lizetao1@huawei.com>
>> Sent: Wednesday, December 7, 2022 11:23 PM
>> To: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
>> kuba@kernel.org; pabeni@redhat.com
>> Cc: lizetao1@huawei.com; Larry.Finger@lwfinger.net; linville@tuxdriver.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
>>
>> There is a global-out-of-bounds reported by KASAN:
>>
>>    BUG: KASAN: global-out-of-bounds in
>>    _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
>>    Read of size 1 at addr ffffffffa0773c43 by task NetworkManager/411
>>
>>    CPU: 6 PID: 411 Comm: NetworkManager Tainted: G      D
>>    6.1.0-rc8+ #144 e15588508517267d37
>>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>>    Call Trace:
>>     <TASK>
>>     ...
>>     kasan_report+0xbb/0x1c0
>>     _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
>>     rtl8821ae_phy_bb_config.cold+0x346/0x641 [rtl8821ae]
>>     rtl8821ae_hw_init+0x1f5e/0x79b0 [rtl8821ae]
>>     ...
>>     </TASK>
>>
>> The root cause of the problem is that the comparison order of
>> "prate_section" in _rtl8812ae_phy_set_txpower_limit() is wrong. The
>> _rtl8812ae_eq_n_byte() is used to compare the first n bytes of the two
>> strings, so this requires the length of the two strings be greater
>> than or equal to n. In the  _rtl8812ae_phy_set_txpower_limit(), it was
>> originally intended to meet this requirement by carefully designing
>> the comparison order. For example, "pregulation" and "pbandwidth" are
>> compared in order of length from small to large, first is 3 and last
>> is 4. However, the comparison order of "prate_section" dose not obey
>> such order requirement, therefore when "prate_section" is "HT", it will
>> lead to access out of bounds in _rtl8812ae_eq_n_byte().
>>
>> Fix it by adding a length check in _rtl8812ae_eq_n_byte(). Although it
>> can be fixed by adjusting the comparison order of "prate_section", this
>> may cause the value of "rate_section" to not be from 0 to 5. In
>> addition, commit "21e4b0726dc6" not only moved driver from staging to
>> regular tree, but also added setting txpower limit function during the
>> driver config phase, so the problem was introduced by this commit.
>>
>> Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
>> Signed-off-by: Li Zetao <lizetao1@huawei.com>
>> ---
>>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
>> b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
>> index a29321e2fa72..720114a9ddb2 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
>> @@ -1600,7 +1600,7 @@ static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
>>
>>   static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
>>   {
> This can causes problem because it compares characters from tail to head, and
> we can't simply replace this by strncmp() that does similar work. But, I also
> don't like strlen() to loop 'str1' constantly.
>
> How about having a simple loop to compare characters forward:
>
> for (i = 0; i < num; i++)
>      if (str1[i] != str2[i])
>           return false;
>
> return true;

Thanks for your comment, but I don't think the problem has anything to 
do with head-to-tail or

tail-to-head comparison. The problem is that num is the length of str2, 
but the length of str1 may

be less than num, which may lead to reading str1 out of bounds, for 
example, when comparing

"prate_section", str1 may be "HT", while str2 may by "CCK", and num is 
3. So I think it is neccssary

to check the length of str1 to ensure that will not read out of bounds.


Looking forward to your comments.


With Best Regards,

Li Zetao

>> -	if (num == 0)
>> +	if (num == 0 || strlen(str1) < num)
>>   		return false;
>>   	while (num > 0) {
>>   		num--;
>> --
>> 2.31.1
>>
>>
>> ------Please consider the environment before printing this e-mail.
