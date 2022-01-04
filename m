Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6030B483A80
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 03:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiADCNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 21:13:35 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58803 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbiADCNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 21:13:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V0nqt.T_1641262408;
Received: from 30.225.24.14(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V0nqt.T_1641262408)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Jan 2022 10:13:29 +0800
Message-ID: <31d6cfe4-3f6b-98e4-1760-9f0c296f3292@linux.alibaba.com>
Date:   Tue, 4 Jan 2022 10:13:27 +0800
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
 <0082289b-d3dc-d202-ec37-844d8fe5303f@linux.alibaba.com>
 <3cef644a-aeb3-ee15-9809-e560f7b24a5c@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <3cef644a-aeb3-ee15-9809-e560f7b24a5c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2022/1/3 6:52 pm, Karsten Graul wrote:
> On 30/12/2021 04:50, Wen Gu wrote:
>> Thanks for your reply.
>>
>> On 2021/12/29 9:07 pm, Karsten Graul wrote:
>>> On 28/12/2021 08:49, Wen Gu wrote:
>>>> SMC connections might fail to be registered to a link group due to
>>>> things like unable to find a link to assign to in its creation. As
>>>> a result, connection creation will return a failure and most
>>>> resources related to the connection won't be applied or initialized,
>>>> such as conn->abort_work or conn->lnk.
>>> What I do not understand is the extra step after the new label out_unreg: that
>>> may invoke smc_lgr_schedule_free_work(). You did not talk about that one.
>>> Is the idea to have a new link group get freed() when a connection could not
>>> be registered on it?
>> Maybe we should try to free the link group when the registration fails, no matter
>> it is new created or already existing? If so, is it better to do it in the same
>> place like label 'out_unreg'?
> 
> I agree with your idea.
> 
> With the proposed change that conn->lgr gets not even set when the registration fails
> we would not need the "conn->lgr = NULL;" after label out_unreg?

Yes, conn->lgr now will be reset in smc_lgr_register_conn() if registration fails.

> 
> And as far as I understand the invocation of smc_lgr_schedule_free_work(lgr) is only
> needed after label "create", because when an existing link group was found and the registration
> failed then its free work would already be started when no more connections are assigned
> to the link group, right?

Thanks for your explanation. I also agree with only invoking smc_lgr_schedule_free_work(lgr)
after label "create" now. I will improve it and send a v2 patch.

Thanks,
Wen Gu
