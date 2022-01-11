Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9935048B143
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343622AbiAKPtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:49:11 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60844 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235534AbiAKPtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:49:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1aSjdJ_1641916148;
Received: from 30.39.146.113(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1aSjdJ_1641916148)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 11 Jan 2022 23:49:08 +0800
Message-ID: <fa057e34-7626-2b19-2c2e-acd4999e7fe5@linux.alibaba.com>
Date:   Tue, 11 Jan 2022 23:49:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net 3/3] net/smc: Resolve the race between SMC-R link
 access and clear
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-4-git-send-email-guwen@linux.alibaba.com>
 <8f13aa62-6360-8038-3041-86fd51b40a3e@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <8f13aa62-6360-8038-3041-86fd51b40a3e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review.

On 2022/1/11 4:40 pm, Karsten Graul wrote:
> On 10/01/2022 10:26, Wen Gu wrote:
>> @@ -1226,15 +1245,23 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
>>   	smc_wr_free_link(lnk);
>>   	smc_ib_destroy_queue_pair(lnk);
>>   	smc_ib_dealloc_protection_domain(lnk);
>> -	smc_wr_free_link_mem(lnk);
>> -	smc_lgr_put(lnk->lgr); /* lgr_hold in smcr_link_init() */
>>   	smc_ibdev_cnt_dec(lnk);
>>   	put_device(&lnk->smcibdev->ibdev->dev);
>>   	smcibdev = lnk->smcibdev;
>> -	memset(lnk, 0, sizeof(struct smc_link));
>> -	lnk->state = SMC_LNK_UNUSED;
>>   	if (!atomic_dec_return(&smcibdev->lnk_cnt))
>>   		wake_up(&smcibdev->lnks_deleted);
> 
> Same here, waiter should not be woken up until the link memory is actually freed.
> 

OK, I will correct this as well.

And similarly I want to move smc_ibdev_cnt_dec() and put_device() to
__smcr_link_clear() as well to ensure that put link related resources
only when link is actually cleared. What do you think?

Thanks,
Wen Gu
