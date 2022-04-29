Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B555141A1
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 06:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbiD2FBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbiD2FBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:01:31 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CDEDF79;
        Thu, 28 Apr 2022 21:58:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xlpang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VBfc4uC_1651208288;
Received: from 30.178.81.83(mailfrom:xlpang@linux.alibaba.com fp:SMTPD_---0VBfc4uC_1651208288)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Apr 2022 12:58:10 +0800
Message-ID: <2d87cb86-3513-08dd-edb3-96a117b6da2c@linux.alibaba.com>
Date:   Fri, 29 Apr 2022 12:58:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] hinic: fix bug of wq out of bound access
To:     maqiao <mqaio@linux.alibaba.com>, luobin9@huawei.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, huangguangbin2@huawei.com,
        keescook@chromium.org, gustavoars@kernel.org,
        Xunlei Pang <xlpang@linux.alibaba.com>
References: <282817b0e1ae2e28fdf3ed8271a04e77f57bf42e.1651148587.git.mqaio@linux.alibaba.com>
 <5c641c77-f96d-4e75-ebc5-eef66cf0dbdc@linux.alibaba.com>
From:   Xunlei Pang <xlpang@linux.alibaba.com>
In-Reply-To: <5c641c77-f96d-4e75-ebc5-eef66cf0dbdc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/4/28 PM8:46, maqiao wrote:
> cc Paolo Abeni, Guangbin Huang, Kees Cook, Gustavo A. R. Silva
> 
> On 2022/4/28 PM8:30, Qiao Ma wrote:
>> If wq has only one page, we need to check wqe rolling over page by
>> compare end_idx and curr_idx, and then copy wqe to shadow wqe to
>> avoid out of bound access.
>> This work has been done in hinic_get_wqe, but missed for hinic_read_wqe.
>> This patch fixes it, and removes unnecessary MASKED_WQE_IDX().
>>
>> Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
>> Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
>> ---
>>   drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c 
>> b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
>> index 5dc3743f8091..f04ac00e3e70 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
>> @@ -771,7 +771,7 @@ struct hinic_hw_wqe *hinic_get_wqe(struct hinic_wq 
>> *wq, unsigned int wqe_size,
>>       /* If we only have one page, still need to get shadown wqe when
>>        * wqe rolling-over page
>>        */
>> -    if (curr_pg != end_pg || MASKED_WQE_IDX(wq, end_prod_idx) < 
>> *prod_idx) {
>> +    if (curr_pg != end_pg || end_prod_idx < *prod_idx) {
>>           void *shadow_addr = &wq->shadow_wqe[curr_pg * 
>> wq->max_wqe_size];
>>           copy_wqe_to_shadow(wq, shadow_addr, num_wqebbs, *prod_idx);
>> @@ -841,7 +841,10 @@ struct hinic_hw_wqe *hinic_read_wqe(struct 
>> hinic_wq *wq, unsigned int wqe_size,
>>       *cons_idx = curr_cons_idx;
>> -    if (curr_pg != end_pg) {
>> +    /* If we only have one page, still need to get shadown wqe when
>> +     * wqe rolling-over page
>> +     */
>> +    if (curr_pg != end_pg || end_cons_idx < curr_cons_idx) {
>>           void *shadow_addr = &wq->shadow_wqe[curr_pg * 
>> wq->max_wqe_size];
>>           copy_wqe_to_shadow(wq, shadow_addr, num_wqebbs, *cons_idx);

This is a fundamental problem, and caused kernel panic as follows:

  Unable to handle kernel paging request at virtual address ffff800041371000
  Call trace:
   hinic_sq_get_sges+0x50/0x84 [hinic]
   free_tx_poll+0x84/0x2fc [hinic]
   napi_poll+0xcc/0x270
   net_rx_action+0xd8/0x280
   __do_softirq+0x120/0x37c
   __irq_exit_rcu+0x108/0x140
   irq_exit+0x14/0x20
   __handle_domain_irq+0x84/0xe0
   gic_handle_irq+0x80/0x108

Reviewed-by: Xunlei Pang <xlpang@linux.alibaba.com>
