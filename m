Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826A4481911
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhL3Dub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:50:31 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:35453 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235450AbhL3Dua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 22:50:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V0IZcsQ_1640836227;
Received: from 30.225.24.59(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V0IZcsQ_1640836227)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Dec 2021 11:50:28 +0800
Message-ID: <0082289b-d3dc-d202-ec37-844d8fe5303f@linux.alibaba.com>
Date:   Thu, 30 Dec 2021 11:50:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [RFC PATCH net] net/smc: Reset conn->lgr when link group
 registration fails
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        tonylu_linux <tonylu@linux.alibaba.com>
References: <1640677770-112053-1-git-send-email-guwen@linux.alibaba.com>
 <07930fec-4109-0dfd-7df4-286cb56ec75b@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <07930fec-4109-0dfd-7df4-286cb56ec75b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2021/12/29 9:07 pm, Karsten Graul wrote:
> On 28/12/2021 08:49, Wen Gu wrote:
>> SMC connections might fail to be registered to a link group due to
>> things like unable to find a link to assign to in its creation. As
>> a result, connection creation will return a failure and most
>> resources related to the connection won't be applied or initialized,
>> such as conn->abort_work or conn->lnk.
> 
> I agree with your fix to set conn->lgr to NULL when smc_lgr_register_conn() fails.
> 
> It would probably be better to have smc_lgr_register_conn() set conn->lgr instead to set
> it before in smc_conn_create(). So it would not be set at all then the registration failes.
> 

I agree and will improve it, thanks.

> 
> What I do not understand is the extra step after the new label out_unreg: that
> may invoke smc_lgr_schedule_free_work(). You did not talk about that one.
> Is the idea to have a new link group get freed() when a connection could not
> be registered on it?

I noticed that smc_conn_create() may be invoked by smc_listen_work(rdma/ism) and
__smc_connect(rdma/ism).

In smc_listen_work() case, if smc_conn_create() fails at smc_lgr_register_conn()
and returns a not-zero rc, the conn->lgr (which won't be reset in original
implementation) will be freed through smc_listen_decline()->smc_conn_abort()->
smc_conn_free()->smc_lgr_schedule_free_work().

So I invoke smc_lgr_schedule_free_work() in label 'out_unreg:' to be consistent
with the above behavior because the conn->lgr is reset to NULL in my implementation,
thus smc_lgr_schedule_free_work() won't be invoked in smc_conn_free().

In __smc_connect() case, I noticed that the behavior of __smc_connect() is not
symmetric with smc_listen_work()'s. If smc_conn_create() fails at smc_lgr_register_conn()
__smc_connect() will not try to free conn->lgr as what did in smc_listen_work().
I am a bit puzzled about it and want to hear your opinions.

In my humble opinion, it also should try to free link group in __smc_connect() case,
so I invoke smc_lgr_schedule_free_work() in label 'out_unreg:'.

> In that case I would expect this code after label create:
> in smc_lgr_create(), when the rc from smc_lgr_register_conn() is not zero.
> Thoughts?

Maybe we should try to free the link group when the registration fails, no matter
it is new created or already existing? If so, is it better to do it in the same
place like label 'out_unreg'?

Cheers,
Wen Gu
