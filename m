Return-Path: <netdev+bounces-2997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76335704EDB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6171E281576
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A321427706;
	Tue, 16 May 2023 13:09:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9409D34CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:09:56 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C844DD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:09:49 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QLGfz3NjfzTkhB;
	Tue, 16 May 2023 21:04:59 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 16 May
 2023 21:09:46 +0800
Subject: Re: [PATCH net-next 3/4] net: hns3: fix strncpy() not using dest-buf
 length as length issue
To: Simon Horman <simon.horman@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-4-lanhao@huawei.com> <ZGKOdijGtX03qV2p@corigine.com>
CC: <netdev@vger.kernel.org>, <yisen.zhuang@huawei.com>,
	<salil.mehta@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <richardcochran@gmail.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>, <cai.huoqing@linux.dev>,
	<xiujianfeng@huawei.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <55ca40e4-eae1-c037-7038-46160a76d5e8@huawei.com>
Date: Tue, 16 May 2023 21:09:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZGKOdijGtX03qV2p@corigine.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/16 3:57, Simon Horman wrote:
> On Mon, May 15, 2023 at 09:46:42PM +0800, Hao Lan wrote:
>> From: Hao Chen <chenhao418@huawei.com>
>>
>> Now, strncpy() in hns3_dbg_fill_content() use src-length as copy-length,
>> it may result in dest-buf overflow.
>>
>> This patch is to fix intel compile warning for csky-linux-gcc (GCC) 12.1.0
>> compiler.
>>
>> The warning reports as below:
>>
>> hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on
>> the length of the source argument [-Wstringop-truncation]
>>
>> strncpy(pos, items[i].name, strlen(items[i].name));
>>
>> hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before
>> terminating nul copying as many bytes from a string as its length
>> [-Wstringop-truncation]
>>
>> strncpy(pos, result[i], strlen(result[i]));
>>
>> strncpy() use src-length as copy-length, it may result in
>> dest-buf overflow.
>>
>> So,this patch add some values check to avoid this issue.
>>
>> Signed-off-by: Hao Chen <chenhao418@huawei.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/lkml/202207170606.7WtHs9yS-lkp@intel.com/T/
>> Signed-off-by: Hao Lan <lanhao@huawei.com>
>> ---
>>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 31 ++++++++++++++-----
>>  .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 29 ++++++++++++++---
>>  2 files changed, 48 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> index 4c3e90a1c4d0..cf415cb37685 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> @@ -438,19 +438,36 @@ static void hns3_dbg_fill_content(char *content, u16 len,
>>  				  const struct hns3_dbg_item *items,
>>  				  const char **result, u16 size)
>>  {
>> +#define HNS3_DBG_LINE_END_LEN	2
>>  	char *pos = content;
>> +	u16 item_len;
>>  	u16 i;
>>  
>> +	if (!len) {
>> +		return;
>> +	} else if (len <= HNS3_DBG_LINE_END_LEN) {
>> +		*pos++ = '\0';
>> +		return;
>> +	}
>> +
>>  	memset(content, ' ', len);
>> -	for (i = 0; i < size; i++) {
>> -		if (result)
>> -			strncpy(pos, result[i], strlen(result[i]));
>> -		else
>> -			strncpy(pos, items[i].name, strlen(items[i].name));
>> +	len -= HNS3_DBG_LINE_END_LEN;
>>  
>> -		pos += strlen(items[i].name) + items[i].interval;
>> +	for (i = 0; i < size; i++) {
>> +		item_len = strlen(items[i].name) + items[i].interval;
>> +		if (len < item_len)
>> +			break;
>> +
>> +		if (result) {
>> +			if (item_len < strlen(result[i]))
>> +				break;
>> +			memcpy(pos, result[i], strlen(result[i]));
>> +		} else {
>> +			memcpy(pos, items[i].name, strlen(items[i].name));
> 
> Hi,
> 
> The above memcpy() calls share the same property as the warning that
> is being addressed: the length copied depends on the source not the
> destination.
> 
> With the reworked code this seems safe. Which is good. But I wonder if,
> given all the checking done, it makes sense to simply call strcpy() here.
> Using strlen() as a length argument seems odd to me.
> 
Hi,
Thanks for your review.
1. We think the memcpy is correct, our length copied depends on the source,
or do I not understand you?
void *memcpy(void *dest, const void *src, size_t count)
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/lib/string.c#n619

2. We don't know any other way to replace strlen. Do you have a better way for us?

Thank you
>> +		}
>> +		pos += item_len;
>> +		len -= item_len;
>>  	}
>> -
>>  	*pos++ = '\n';
>>  	*pos++ = '\0';
>>  }
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
>> index a0b46e7d863e..1354fd0461f7 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
>> @@ -88,16 +88,35 @@ static void hclge_dbg_fill_content(char *content, u16 len,
>>  				   const struct hclge_dbg_item *items,
>>  				   const char **result, u16 size)
>>  {
>> +#define HCLGE_DBG_LINE_END_LEN	2
>>  	char *pos = content;
>> +	u16 item_len;
>>  	u16 i;
>>  
>> +	if (!len) {
>> +		return;
>> +	} else if (len <= HCLGE_DBG_LINE_END_LEN) {
>> +		*pos++ = '\0';
>> +		return;
>> +	}
>> +
>>  	memset(content, ' ', len);
>> +	len -= HCLGE_DBG_LINE_END_LEN;
>> +
>>  	for (i = 0; i < size; i++) {
>> -		if (result)
>> -			strncpy(pos, result[i], strlen(result[i]));
>> -		else
>> -			strncpy(pos, items[i].name, strlen(items[i].name));
>> -		pos += strlen(items[i].name) + items[i].interval;
>> +		item_len = strlen(items[i].name) + items[i].interval;
>> +		if (len < item_len)
>> +			break;
>> +
>> +		if (result) {
>> +			if (item_len < strlen(result[i]))
>> +				break;
>> +			memcpy(pos, result[i], strlen(result[i]));
>> +		} else {
>> +			memcpy(pos, items[i].name, strlen(items[i].name));
>> +		}
>> +		pos += item_len;
>> +		len -= item_len;
>>  	}
>>  	*pos++ = '\n';
>>  	*pos++ = '\0';
>> -- 
>> 2.30.0
>>
>>
> .
> 

