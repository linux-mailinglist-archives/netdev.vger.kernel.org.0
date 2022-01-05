Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE046484E4A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 07:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiAEGTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 01:19:06 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:40416 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232752AbiAEGSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 01:18:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V1.itqv_1641363513;
Received: from 30.225.24.14(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1.itqv_1641363513)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 14:18:34 +0800
Message-ID: <8242aa42-4356-0333-4e59-3d6a6f20d737@linux.alibaba.com>
Date:   Wed, 5 Jan 2022 14:18:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net v2] net/smc: Reset conn->lgr when link group
 registration fails
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1641265187-108970-1-git-send-email-guwen@linux.alibaba.com>
 <a4b54142-e324-8c08-738b-b89046ccc794@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <a4b54142-e324-8c08-738b-b89046ccc794@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2022/1/4 5:58 pm, Karsten Graul wrote:
> On 04/01/2022 03:59, Wen Gu wrote:
>> SMC connections might fail to be registered to a link group due to
>> things like unable to find a link to assign to in its creation. As
>> a result, connection creation will return a failure and most
>> resources related to the connection won't be applied or initialized,
>> such as conn->abort_work or conn->lnk.
> 
> Patch looks good to me, but one more thing to think about:
> 
> Would it be better to invoke __smc_lgr_terminate() instead of smc_lgr_schedule_free_work()
> when a link group was created but cannot be used now? This would immediately free up all
> allocated resources for this unusable link group instead of starting the default 10-minute
> timer until the link group is freed.
> __smc_lgr_terminate() takes care of completely removing the link group in the context of
> its caller. It is also used from within smc_lgr_cleanup_early() that is used when the very
> first connection of a link group is aborted.

Thanks for your suggestion.

I also agree with using link group termination function for a immediate free.

I will improve it and send a v3 patch.

Thanks,
Wen Gu
