Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD03D856B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhG1Bcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:32:52 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:63796 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhG1Bcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:32:51 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb6100b39f616-9ed92; Wed, 28 Jul 2021 09:32:15 +0800 (CST)
X-RM-TRANSID: 2eeb6100b39f616-9ed92
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.26.114] (unknown[10.42.68.12])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea6100b39e4e1-ba505;
        Wed, 28 Jul 2021 09:32:15 +0800 (CST)
X-RM-TRANSID: 2eea6100b39e4e1-ba505
Subject: Re: [PATCH] nfc: s3fwrn5: fix undefined parameter values in dev_err()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     k.opasiak@samsung.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
References: <20210727122506.6900-1-tangbin@cmss.chinamobile.com>
 <YQBDvOG51Tl0ts+g@Ryzen-9-3900X.localdomain>
From:   tangbin <tangbin@cmss.chinamobile.com>
Message-ID: <c4eeaf08-0d24-f7bb-c284-e1843e9edadd@cmss.chinamobile.com>
Date:   Wed, 28 Jul 2021 09:32:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YQBDvOG51Tl0ts+g@Ryzen-9-3900X.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nathan:

On 2021/7/28 1:34, Nathan Chancellor wrote:
> On Tue, Jul 27, 2021 at 08:25:06PM +0800, Tang Bin wrote:
>> In the function s3fwrn5_fw_download(), the 'ret' is not assigned,
>> so the correct value should be given in dev_err function.
>>
>> Fixes: a0302ff5906a ("nfc: s3fwrn5: remove unnecessary label")
>> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> This clears up a clang warning that I see:
>
> drivers/nfc/s3fwrn5/firmware.c:425:41: error: variable 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
>                          "Cannot allocate shash (code=%d)\n", ret);
>                                                               ^~~
> ./include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
>          dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
>                                                                         ^~~~~~~~~~~
> ./include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
>                  _p_func(dev, fmt, ##__VA_ARGS__);                       \
>                                      ^~~~~~~~~~~
> drivers/nfc/s3fwrn5/firmware.c:416:9: note: initialize the variable 'ret' to silence this warning
>          int ret;
>                 ^
>                  = 0
> 1 error generated.
>
> One comment below but regardless:
>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
>
>> ---
>>   drivers/nfc/s3fwrn5/firmware.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
>> index 1421ffd46d9a..52c6f76adfb2 100644
>> --- a/drivers/nfc/s3fwrn5/firmware.c
>> +++ b/drivers/nfc/s3fwrn5/firmware.c
>> @@ -422,7 +422,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
>>   	tfm = crypto_alloc_shash("sha1", 0, 0);
>>   	if (IS_ERR(tfm)) {
>>   		dev_err(&fw_info->ndev->nfc_dev->dev,
>> -			"Cannot allocate shash (code=%d)\n", ret);
>> +			"Cannot allocate shash (code=%d)\n", PTR_ERR(tfm));
> We know this is going to be an error pointer so this could be changed to
>
> "Cannot allocate shash (code=%pe)\n", tfm);
>
> to make it a little cleaner to understand. See commit 57f5677e535b
> ("printf: add support for printing symbolic error names").

Got it. My patch is looks like a revert, so in the dev_err I used 
'PTR_ERR(tfm)'. After your suggestion,

I will send V2 for you.

Thanks

Tang Bin



>
>>   		return PTR_ERR(tfm);
>>   	}
>>   
>> -- 
>> 2.18.2
> Cheers,
> Nathan


