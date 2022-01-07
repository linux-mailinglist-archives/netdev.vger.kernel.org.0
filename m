Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E448774A
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 13:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiAGMEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 07:04:42 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:11313 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346935AbiAGMEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 07:04:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V1B2FcK_1641557068;
Received: from 30.225.24.40(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1B2FcK_1641557068)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 07 Jan 2022 20:04:29 +0800
Message-ID: <2e06f67b-c445-61b4-64eb-fd3e3c412f0b@linux.alibaba.com>
Date:   Fri, 7 Jan 2022 20:04:28 +0800
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
 <095c6e45-dd9e-1809-ae51-224679783241@linux.alibaba.com>
 <1cf77005-1825-0d34-6d34-e1b513c28113@linux.ibm.com>
 <747c3399-4e6f-0353-95bf-6b6f3a0f5f60@linux.alibaba.com>
 <ed37164f-74b1-de58-8308-4a11ea352faa@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <ed37164f-74b1-de58-8308-4a11ea352faa@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2022/1/7 5:54 pm, Karsten Graul wrote:
> On 06/01/2022 14:02, Wen Gu wrote:
>> Thanks for your reply.
>>
>> On 2022/1/5 8:03 pm, Karsten Graul wrote:
>>> On 05/01/2022 09:27, Wen Gu wrote:
>>>> On 2022/1/3 6:36 pm, Karsten Graul wrote:
>>>>> On 31/12/2021 10:44, Wen Gu wrote:
>>>>>> On 2021/12/29 8:56 pm, Karsten Graul wrote:
>>>>>>> On 28/12/2021 16:13, Wen Gu wrote:
>>>>>>>> We encountered some crashes caused by the race between the access
>>>>>>>> and the termination of link groups.
>> So I am trying this way:
>>
>> 1) Introduce a new helper smc_conn_lgr_state() to check the three stages mentioned above.
>>
>>    enum smc_conn_lgr_state {
>>           SMC_CONN_LGR_ORPHAN,    /* conn was never registered in a link group */
>>           SMC_CONN_LGR_VALID,     /* conn is registered in a link group now */
>>           SMC_CONN_LGR_INVALID,   /* conn was registered in a link group, but now
>>                                      is unregistered from it and conn->lgr should
>>                                      not be used any more */
>>    };
> 
> Sounds good, but is it really needed to separate 3 cases, i.e. who is really using them 3?
> Doesn't it come down to a more simple smc_conn_lgr_valid() which is easier to implement in
> the various places in the code? (i.e.: if (smc_conn_lgr_valid()) ....)
> Valid would mean conn->lgr != NULL and conn->alert_token_local != 0. The more special cases
> would check what they want by there own.

Yes, Most of the time we only need to check whether conn->lgr is in SMC_CONN_LGR_VALID.
Only in smc_conn_free() we need to identify whether conn->lgr is in SMC_CONN_LGR_ORPHAN
(need a directly return) or SMC_CONN_LGR_INVALID (put link group refcnt and then return).

So I agree with only checking whether conn->lgr is valid with a more simple smc_conn_lgr_valid().
And distinguish SMC_CONN_LGR_ORPHAN and SMC_CONN_LGR_INVALID cases by additional check for
conn->lgr.

Thanks,
Wen Gu
