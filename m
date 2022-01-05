Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7AF484F52
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbiAEI14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:27:56 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:42221 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238495AbiAEI1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:27:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V106Zjz_1641371271;
Received: from 30.225.24.14(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V106Zjz_1641371271)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 16:27:52 +0800
Message-ID: <095c6e45-dd9e-1809-ae51-224679783241@linux.alibaba.com>
Date:   Wed, 5 Jan 2022 16:27:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [RFC PATCH net v2 1/2] net/smc: Resolve the race between link
 group access and termination
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-2-git-send-email-guwen@linux.alibaba.com>
 <4ec6e460-96d1-fedc-96ff-79a98fd38de8@linux.ibm.com>
 <0a972bf8-1d7b-a211-2c11-50e86c87700e@linux.alibaba.com>
 <4df6c3c1-7d52-6bfa-9b0d-365de5332c06@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <4df6c3c1-7d52-6bfa-9b0d-365de5332c06@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2022/1/3 6:36 pm, Karsten Graul wrote:
> On 31/12/2021 10:44, Wen Gu wrote:
>> On 2021/12/29 8:56 pm, Karsten Graul wrote:
>>> On 28/12/2021 16:13, Wen Gu wrote:
>>>> We encountered some crashes caused by the race between the access
>>>> and the termination of link groups.
>> What do you think about it?
>>
> 
> Hi Wen,
> 
> thank you, and I also wish you and your family a happy New Year!
> 
> Thanks for your detailed explanation, you convinced me of your idea to use
> a reference counting! I think its a good solution for the various problems you describe.
> 
> I am still thinking that even if you saw no problems when conn->lgr is not NULL when the lgr
> is already terminated there should be more attention on the places where conn->lgr is checked.

Thank you for reminding. I agree with the concern.

It should be improved to avoid the potential issue we haven't found.

> For example, in smc_cdc_get_slot_and_msg_send() there is a check for !conn->lgr with the intention
> to avoid working with a terminated link group.
> Should all checks for !conn->lgr be now replaced by the check for conn->freed ?? Does this make sense?

In my humble opinion, we can replace !conn->lgr with !conn->alert_token_local.

If a smc connection is registered to a link group successfully by smc_lgr_register_conn(),
conn->alert_token_local is set to non-zero. At this moment, the conn->lgr is ready to be used.

And if the link group is terminated, conn->alert_token_local is reset to zero in smc_lgr_unregister_conn(),
meaning that the link group registered to connection shouldn't be used anymore.

So I think checking conn->alert_token_local has the same effect with checking conn->lgr to
identify whether the link group pointed by conn->lgr is still healthy and able to be used.

What do you think about it? :)

Thanks,
Wen Gu
