Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C67561DFB
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbiF3Odc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236985AbiF3OdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:33:16 -0400
Received: from out199-1.us.a.mail.aliyun.com (out199-1.us.a.mail.aliyun.com [47.90.199.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0BC5C9F9;
        Thu, 30 Jun 2022 07:16:10 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=mqaio@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VHtfz19_1656598514;
Received: from 30.13.190.220(mailfrom:mqaio@linux.alibaba.com fp:SMTPD_---0VHtfz19_1656598514)
          by smtp.aliyun-inc.com;
          Thu, 30 Jun 2022 22:15:16 +0800
Message-ID: <529eadf1-5c7a-2068-2932-8e75ae02e405@linux.alibaba.com>
Date:   Thu, 30 Jun 2022 22:15:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] net: hinic: avoid kernel hung in hinic_get_stats64()
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, gustavoars@kernel.org,
        cai.huoqing@linux.dev, Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        zhaochen6@huawei.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
 <CANn89iLpW4zFf2ABADbMNERPFr=OrAXEMm6ZgCxYA5VpcDpYTw@mail.gmail.com>
 <8b012bbd-a175-5699-1f26-108dd52fc5b7@linux.alibaba.com>
 <CANn89iJ-2BTR1SfFBbNG3jSgHK-TuRE_J-Khbbednu=pWnFtmw@mail.gmail.com>
From:   maqiao <mqaio@linux.alibaba.com>
In-Reply-To: <CANn89iJ-2BTR1SfFBbNG3jSgHK-TuRE_J-Khbbednu=pWnFtmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/6/30 下午9:59, Eric Dumazet 写道:
> On Thu, Jun 30, 2022 at 3:57 PM maqiao <mqaio@linux.alibaba.com> wrote:
>>
>>
>>
>> 在 2022/6/30 下午6:23, Eric Dumazet 写道:
> 
>>> Note: The following is racy, because multiple threads can call
>>> hinic_get_stats64() at the same time.
>>> It needs a loop, see include/linux/u64_stats_sync.h for detail.
>> Thanks for reminding, and I noticed that nic_tx_stats/nic_rx_stats has
>> been protected by u64_stats_sync in update_t/rx_stats(), it seems that
>> it's unnecessary to use spinlock in update_nic_stats().
> 
> It is necessary to use the spinlock to protect writers among themselves.
Ohhh, sorry, I was wrong.
I did not realize that seqlock cannot prevent mutil writers enter 
critical section...
> 
> 
>>
>> I will send v2 as soon as possible, thanks.
