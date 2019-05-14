Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE41CAA5
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 16:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfENOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 10:43:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8191 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfENOnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 10:43:04 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CDB0D1582A9B13AFE968;
        Tue, 14 May 2019 22:42:59 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 14 May 2019
 22:42:55 +0800
Subject: Re: [PATCH] ppp: deflate: Fix possible crash in deflate_init
To:     Guillaume Nault <gnault@redhat.com>
References: <20190514074300.42588-1-yuehaibing@huawei.com>
 <20190514140547.GA25993@linux.home>
CC:     <davem@davemloft.net>, <paulus@samba.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <f276c92f-f112-ed47-30c6-d41211804eb7@huawei.com>
Date:   Tue, 14 May 2019 22:42:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190514140547.GA25993@linux.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/14 22:05, Guillaume Nault wrote:
> On Tue, May 14, 2019 at 03:43:00PM +0800, YueHaibing wrote:
>>
>> If ppp_deflate fails to register in deflate_init,
>> module initialization failed out, however
>> ppp_deflate_draft may has been regiestred and not
>> unregistered before return.
>> Then the seconed modprobe will trigger crash like this.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/net/ppp/ppp_deflate.c | 14 +++++++++-----
>>  1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ppp/ppp_deflate.c b/drivers/net/ppp/ppp_deflate.c
>> index b5edc7f..2829efe 100644
>> --- a/drivers/net/ppp/ppp_deflate.c
>> +++ b/drivers/net/ppp/ppp_deflate.c
>> @@ -610,12 +610,16 @@ static void z_incomp(void *arg, unsigned char *ibuf, int icnt)
>>  
>>  static int __init deflate_init(void)
>>  {
>> -        int answer = ppp_register_compressor(&ppp_deflate);
>> -        if (answer == 0)
>> -                printk(KERN_INFO
>> -		       "PPP Deflate Compression module registered\n");
>> +	int answer;
>> +
>> +	answer = ppp_register_compressor(&ppp_deflate);
>> +	if (answer)
>> +		return answer;
>> +
>> +	pr_info("PPP Deflate Compression module registered\n");
>>  	ppp_register_compressor(&ppp_deflate_draft);
>> -        return answer;
>> +
>> +	return 0;
>>  }
>>  
> I'd be cleaner to also check for ppp_deflate_draft registration failure
> IMHO (and print the log line only if both compressors get registered
> successfully).

Ok, will send v2 to do that, thanks!

> 
> .
> 

