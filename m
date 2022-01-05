Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8334C484FA4
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiAEIzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:55:55 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45346 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbiAEIzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:55:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V10P8Hb_1641372952;
Received: from 30.225.24.14(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V10P8Hb_1641372952)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 16:55:52 +0800
Message-ID: <23b607fe-95da-ea8a-8dda-900a51572b90@linux.alibaba.com>
Date:   Wed, 5 Jan 2022 16:55:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net v3] net/smc: Reset conn->lgr when link group
 registration fails
To:     dust.li@linux.alibaba.com, kgraul@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641364133-61284-1-git-send-email-guwen@linux.alibaba.com>
 <20220105075408.GC31579@linux.alibaba.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220105075408.GC31579@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggestion.

On 2022/1/5 3:54 pm, dust.li wrote:

>> -		if (rc)
>> +		if (rc) {
>> +			spin_lock_bh(lgr_lock);
>> +			if (!list_empty(&lgr->list))
>> +				list_del_init(&lgr->list);
>> +			spin_unlock_bh(lgr_lock);
>> +			__smc_lgr_terminate(lgr, true);
> 
> What about adding a smc_lgr_terminate() wrapper and put list_del_init()
> and __smc_lgr_terminate() into it ?

Adding a new wrapper is a good idea. But I think the logic here is relatively simple.
So instead of wrapping them, I coded them like what smc_lgr_cleanup_early() does.

Thanks,
Wen Gu

> 
>> 			goto out;
>> +		}
>> 	}
>> 	conn->local_tx_ctrl.common.type = SMC_CDC_MSG_TYPE;
>> 	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
>> -- 
>> 1.8.3.1
