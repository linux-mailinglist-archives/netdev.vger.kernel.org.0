Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57174864DA
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbiAFNCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:02:38 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:51512 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238944AbiAFNCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:02:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V16OQG._1641474154;
Received: from 30.225.24.14(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V16OQG._1641474154)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jan 2022 21:02:35 +0800
Message-ID: <747c3399-4e6f-0353-95bf-6b6f3a0f5f60@linux.alibaba.com>
Date:   Thu, 6 Jan 2022 21:02:34 +0800
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
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <1cf77005-1825-0d34-6d34-e1b513c28113@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2022/1/5 8:03 pm, Karsten Graul wrote:
> On 05/01/2022 09:27, Wen Gu wrote:
>> On 2022/1/3 6:36 pm, Karsten Graul wrote:
>>> On 31/12/2021 10:44, Wen Gu wrote:
>>>> On 2021/12/29 8:56 pm, Karsten Graul wrote:
>>>>> On 28/12/2021 16:13, Wen Gu wrote:
>>>>>> We encountered some crashes caused by the race between the access
>>>>>> and the termination of link groups.
>> So I think checking conn->alert_token_local has the same effect with checking conn->lgr to
>> identify whether the link group pointed by conn->lgr is still healthy and able to be used.
> 
> Yeah that sounds like a good solution for that! So is it now guaranteed that conn->lgr is always
> set and this check can really be removed completely, or should there be a new helper that checks
> conn->lgr and the alert_token, like smc_lgr_valid() ?

In my humble opinion, the link group pointed by conn->lgr might have the following
three stages if we remove 'conn->lgr = NULL' from smc_lgr_unregister_conn().

1. conn->lgr = NULL and conn->alert_token_local is zero

This means that the connection has never been registered in a link group. conn->lgr is clearly
unable to use.

2. conn->lgr != NULL and conn->alert_token_local is non-zero

This means that the connection has been registered in a link group, and conn->lgr is valid to access.

3. conn->lgr != NULL but conn->alert_token_local is zero

This means that the connection was registered in a link group before, but is unregistered from
it now. conn->lgr shouldn't be used anymore.


So I am trying this way:

1) Introduce a new helper smc_conn_lgr_state() to check the three stages mentioned above.

   enum smc_conn_lgr_state {
          SMC_CONN_LGR_ORPHAN,    /* conn was never registered in a link group */
          SMC_CONN_LGR_VALID,     /* conn is registered in a link group now */
          SMC_CONN_LGR_INVALID,   /* conn was registered in a link group, but now
                                     is unregistered from it and conn->lgr should
                                     not be used any more */
   };

2) replace the current conn->lgr check with the new helper.

These new changes are under testing now.

What do you think about it? :)

Thanks,
Wen Gu
