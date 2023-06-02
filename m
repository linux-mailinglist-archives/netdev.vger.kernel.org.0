Return-Path: <netdev+bounces-7444-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F8A72054A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDDD72819B0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA3619E51;
	Fri,  2 Jun 2023 15:01:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7326819BA4
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:01:53 +0000 (UTC)
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E803E62;
	Fri,  2 Jun 2023 08:01:48 -0700 (PDT)
Received: from [IPV6:240e:3b7:327f:140:44b0:a08f:963d:32cc] (unknown [IPV6:240e:3b7:327f:140:44b0:a08f:963d:32cc])
	by mail-m11875.qiye.163.com (Hmail) with ESMTPA id 801F02804F5;
	Fri,  2 Jun 2023 23:01:44 +0800 (CST)
Message-ID: <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
Date: Fri, 2 Jun 2023 23:01:43 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Cc: dinghui@sangfor.com.cn, Alexander H Duyck <alexander.duyck@gmail.com>,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Andrew Lunn <andrew@lunn.ch>
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
 <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
 <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
Content-Language: en-US
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDGkIeVkIdHkIfSklCTk9LQlUTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTB1BSk9LQU9PGUtBGktDHUFCTUgfQUhJGBhZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a887ca0fb072eb1kusn801f02804f5
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P1E6PAw5OT1WTTNWOjg1SEwU
	NwlPCxBVSlVKTUNOTEpDSktOSENLVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUwdQUpPS0FPTxlLQRpLQx1BQk1IH0FISRgYWVdZCAFZQUlDQ0I3Bg++
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/2 8:26 下午, Andrew Lunn wrote:
>>> Changing the copy size would not fix this. The problem is the driver
>>> will be overwriting with the size that it thinks it should be using.
>>> Reducing the value that is provided for the memory allocations will
>>> cause the driver to corrupt memory.
>>>
>>
>> I noticed that, in fact I did use the returned length to allocate
>> kernel memory, and only use adjusted length to copy to user.
> 
> This is also something i checked when quickly looking at the patch. It
> does look correct.
> 

Thanks.

> Also, RTNL should be held during the time both calls are made into the
> driver. So nothing from userspace should be able to get in the middle
> of these calls to change the number of queues.
> 

The RTNL lock is already be held during every each ioctl in dev_ethtool().

     rtnl_lock();
     rc = __dev_ethtool(net, ifr, useraddr, ethcmd, state);
     rtnl_unlock();

-- 
Thanks,
-dinghui


