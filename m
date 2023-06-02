Return-Path: <netdev+bounces-7277-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB7371F825
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 03:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59F6D281994
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E39D10FA;
	Fri,  2 Jun 2023 01:46:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5AB10E3
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:46:25 +0000 (UTC)
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EA097;
	Thu,  1 Jun 2023 18:46:21 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m11875.qiye.163.com (Hmail) with ESMTPA id C5B62280374;
	Fri,  2 Jun 2023 09:46:11 +0800 (CST)
Message-ID: <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
Date: Fri, 2 Jun 2023 09:46:02 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
Content-Language: en-US
To: Alexander H Duyck <alexander.duyck@gmail.com>, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaThkZVkoaH0MdS0IfHR8aTFUTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a8879c8b25c2eb1kusnc5b62280374
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDY6Tww4DT1POj4*QxI1CBIN
	ThcKCy5VSlVKTUNOTUxLSExMS0JMVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFMT0tPNwY+
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/1 23:04, Alexander H Duyck wrote:
> On Thu, 2023-06-01 at 19:28 +0800, Ding Hui wrote:
>> When we get statistics by ethtool during changing the number of NIC
>> channels greater, the utility may crash due to memory corruption.
>>
>> The NIC drivers callback get_sset_count() could return a calculated
>> length depends on current number of channels (e.g. i40e, igb).
>>
> 
> The drivers shouldn't be changing that value. If the drivers are doing
> this they should be fixed to provide a fixed length in terms of their
> strings.
> 

Is there an explicit declaration for the rule?
I searched the ethernet drivers, found that many drivers that support
multiple queues return calculated length by number of queues rather than
fixed value. So pushing all these drivers to follow the rule is hard
to me.

>> The ethtool allocates a user buffer with the first ioctl returned
>> length and invokes the second ioctl to get data. The kernel copies
>> data to the user buffer but without checking its length. If the length
>> returned by the second get_sset_count() is greater than the length
>> allocated by the user, it will lead to an out-of-bounds copy.
>>
>> Fix it by restricting the copy length not exceed the buffer length
>> specified by userspace.
>>
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> 
> Changing the copy size would not fix this. The problem is the driver
> will be overwriting with the size that it thinks it should be using.
> Reducing the value that is provided for the memory allocations will
> cause the driver to corrupt memory.
> 

I noticed that, in fact I did use the returned length to allocate
kernel memory, and only use adjusted length to copy to user.

>> ---
>>   net/ethtool/ioctl.c | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>> index 6bb778e10461..82a975a9c895 100644
>> --- a/net/ethtool/ioctl.c
>> +++ b/net/ethtool/ioctl.c
>> @@ -1902,7 +1902,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
>>   	if (copy_from_user(&test, useraddr, sizeof(test)))
>>   		return -EFAULT;
>>   
>> -	test.len = test_len;
>> +	test.len = min_t(u32, test.len, test_len);
>>   	data = kcalloc(test_len, sizeof(u64), GFP_USER);
>>   	if (!data)
>>   		return -ENOMEM;
> 
> This is the wrong spot to be doing this. You need to use test_len for
> your allocation as that is what the driver will be writing to. You
> should look at adjusting after the allocation call and before you do
> the copy

data = kcalloc(test_len, sizeof(u64), GFP_USER);  // yes, **test_len** for kernel memory
...
copy_to_user(useraddr, data, array_size(test.len, sizeof(u64)) // **test.len** only for copy to user

> 
>> @@ -1915,7 +1915,8 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
>>   	if (copy_to_user(useraddr, &test, sizeof(test)))
>>   		goto out;
>>   	useraddr += sizeof(test);
>> -	if (copy_to_user(useraddr, data, array_size(test.len, sizeof(u64))))
>> +	if (test.len &&
>> +	    copy_to_user(useraddr, data, array_size(test.len, sizeof(u64))))
>>   		goto out;
>>   	ret = 0;
>>   
> 
> I don't believe this is adding any value. I wouldn't bother with
> checking for lengths of 0.
> 

Yes, we already checked the data ptr is not NULL, so we don't need checking test.len.
I'll remove it in v2.

>> @@ -1940,10 +1941,10 @@ static int ethtool_get_strings(struct net_device *dev, void __user *useraddr)
>>   		return -ENOMEM;
>>   	WARN_ON_ONCE(!ret);
>>   
>> -	gstrings.len = ret;
>> +	gstrings.len = min_t(u32, gstrings.len, ret);
>>   
>>   	if (gstrings.len) {
>> -		data = vzalloc(array_size(gstrings.len, ETH_GSTRING_LEN));
>> +		data = vzalloc(array_size(ret, ETH_GSTRING_LEN));
>>   		if (!data)
>>   			return -ENOMEM;
>>   
> 
> Same here. We should be using the returned value for the allocations
> and tests, and then doing the min adjustment after the allocationis
> completed.
> 

gstrings.len = min_t(u32, gstrings.len, ret);   // adjusting

if (gstrings.len) {  // checking the adjusted gstrings.len can avoid unnecessary vzalloc and __ethtool_get_strings()
vzalloc(array_size(ret, ETH_GSTRING_LEN)); // **ret** for kernel memory, rather than adjusted lenght

At last, adjusted gstrings.len for copy to user

>> @@ -2055,9 +2056,9 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
>>   	if (copy_from_user(&stats, useraddr, sizeof(stats)))
>>   		return -EFAULT;
>>   
>> -	stats.n_stats = n_stats;
>> +	stats.n_stats = min_t(u32, stats.n_stats, n_stats);
>>   
>> -	if (n_stats) {
>> +	if (stats.n_stats) {
>>   		data = vzalloc(array_size(n_stats, sizeof(u64)));
>>   		if (!data)
>>   			return -ENOMEM;
> 
> Same here. We should be using n_stats, not stats.n_stats and adjust
> before you do the final copy.
> 
>> @@ -2070,7 +2071,8 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
>>   	if (copy_to_user(useraddr, &stats, sizeof(stats)))
>>   		goto out;
>>   	useraddr += sizeof(stats);
>> -	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
>> +	if (stats.n_stats &&
>> +	    copy_to_user(useraddr, data, array_size(stats.n_stats, sizeof(u64))))
>>   		goto out;
>>   	ret = 0;
>>   
> 
> Again. I am not sure what value is being added. If n_stats is 0 then I
> am pretty sure this will do nothing anyway.
> 

Not really no, n_stats is returned value, and stats.n_stats is adjusted value,
if the adjusted stats.n_stats is 0, we avoid memory allocation and setting data ptr
to NULL, copy_to_user() with NULL ptr maybe cause warn log.

-- 
Thanks,
- Ding Hui


