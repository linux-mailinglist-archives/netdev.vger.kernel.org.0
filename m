Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC144EA07
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhKLPbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:31:08 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:56448 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhKLPbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:31:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UwDEY-q_1636730891;
Received: from 192.168.2.101(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0UwDEY-q_1636730891)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Nov 2021 23:28:12 +0800
Subject: Re: [PATCH net] net/smc: Transfer remaining wait queue entries during
 fallback
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tonylu@linux.alibaba.com,
        dust.li@linux.alibaba.com, xuanzhuo@linux.alibaba.com
References: <1636687839-38962-1-git-send-email-guwen@linux.alibaba.com>
 <YY5z4H5/CVpRtrwh@osiris>
From:   Wen Gu <guwen@linux.alibaba.com>
Message-ID: <0a5d62a6-4486-16c8-9b69-bea8949606ee@linux.alibaba.com>
Date:   Fri, 12 Nov 2021 23:28:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YY5z4H5/CVpRtrwh@osiris>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/12 10:02 pm, Heiko Carstens wrote:
> On Fri, Nov 12, 2021 at 11:30:39AM +0800, Wen Gu wrote:
> ...
>> +	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
>> +	wait_queue_head_t *clc_wait = sk_sleep(smc->clcsock->sk);
>> +	unsigned long flags;
>> +
>>   	smc->use_fallback = true;
>>   	smc->fallback_rsn = reason_code;
>>   	smc_stat_fallback(smc);
>> @@ -571,6 +575,16 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
>>   		smc->clcsock->file->private_data = smc->clcsock;
>>   		smc->clcsock->wq.fasync_list =
>>   			smc->sk.sk_socket->wq.fasync_list;
>> +
>> +		/* There might be some wait queue entries remaining
>> +		 * in smc socket->wq, which should be removed to
>> +		 * clcsocket->wq during the fallback.
>> +		 */
>> +		spin_lock_irqsave(&smc_wait->lock, flags);
>> +		spin_lock_irqsave(&clc_wait->lock, flags);
>> +		list_splice_init(&smc_wait->head, &clc_wait->head);
>> +		spin_unlock_irqrestore(&clc_wait->lock, flags);
>> +		spin_unlock_irqrestore(&smc_wait->lock, flags);
> 
> No idea if the rest of the patch makes sense, however this usage of
> spin_lock_irqsave() is not correct. The second spin_lock_irqsave()
> would always save a state with irqs disabled into "flags", and
> therefore this path would always be left with irqs disabled,
> regardless if irqs were enabled or disabled when entering.
> 
> You need to change it to something like
> 
>> +		spin_lock_irqsave(&smc_wait->lock, flags);
>> +		spin_lock(&clc_wait->lock);
>> +		list_splice_init(&smc_wait->head, &clc_wait->head);
>> +		spin_unlock(&clc_wait->lock);
>> +		spin_unlock_irqrestore(&smc_wait->lock, flags);

Sorry for the mistake... I will correct this.

Thanks,
Wen Gu
