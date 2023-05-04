Return-Path: <netdev+bounces-244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F586F64DB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5B75280CE9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 06:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A081386;
	Thu,  4 May 2023 06:22:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36C2ED2
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 06:22:21 +0000 (UTC)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E415D199E;
	Wed,  3 May 2023 23:22:09 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vhe9zcQ_1683181325;
Received: from 30.221.129.60(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vhe9zcQ_1683181325)
          by smtp.aliyun-inc.com;
          Thu, 04 May 2023 14:22:06 +0800
Message-ID: <38151aa1-10f4-9104-1b92-640e153d39da@linux.alibaba.com>
Date: Thu, 4 May 2023 14:22:03 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC PATCH net-next v5 2/9] net/smc: Decouple ism_dev from SMC-D
 DMB registration
To: Simon Horman <simon.horman@corigine.com>
Cc: kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
 <1682252271-2544-3-git-send-email-guwen@linux.alibaba.com>
 <ZEva5rj3DWQEmix8@corigine.com>
From: Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <ZEva5rj3DWQEmix8@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-14.2 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/4/28 22:40, Simon Horman wrote:

> On Sun, Apr 23, 2023 at 08:17:44PM +0800, Wen Gu wrote:
>> This patch tries to decouple ISM device from SMC-D DMB registration,
>> So that the register_dmb option is not restricted to be used by ISM
>> device.
>>
>> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
>> ---
>>   drivers/s390/net/ism_drv.c | 5 +++--
>>   include/net/smc.h          | 4 ++--
>>   net/smc/smc_ism.c          | 7 ++-----
>>   3 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
>> index 8acb9eb..5eeb54d 100644
>> --- a/drivers/s390/net/ism_drv.c
>> +++ b/drivers/s390/net/ism_drv.c
>> @@ -796,9 +796,10 @@ static int smcd_query_rgid(struct smcd_dev *smcd, u64 rgid, u32 vid_valid,
>>   }
>>   
>>   static int smcd_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
>> -			     struct ism_client *client)
>> +			     void *client_priv)
>>   {
>> -	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb, client);
>> +	return ism_register_dmb(smcd->priv, (struct ism_dmb *)dmb,
>> +				(struct ism_client *)client_priv);
> 
> Hi Wen Gu,
> 
> a minor nit from my side: there is no need to cast a void pointer to
> another type.
> 
>>   }
>>   
>>   static int smcd_unregister_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb)
> 
> ...

Hi Simon Horman,

Thanks for your review and suggestions in this patch and others.
I will take them in the next version.

Thanks!
Wen Gu

